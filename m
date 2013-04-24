Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757891Ab3DXJnY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Apr 2013 05:43:24 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:37587 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756331Ab3DXJnV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Apr 2013 05:43:21 -0400
Date: Wed, 24 Apr 2013 10:42:51 +0100
From: Will Deacon <will.deacon@arm.com>
To: =?iso-8859-1?Q?Andr=E9?= Hentschel <nerv@dawncrow.de>
Cc: Russell King - ARM Linux <linux@arm.linux.org.uk>,
        "linux-arch@vger.kernel.org" <linux-arch@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCHv2] arm: Preserve TPIDRURW on context switch
Message-ID: <20130424094251.GA21850@mudshark.cambridge.arm.com>
References: <517168BB.3070903@dawncrow.de>
 <20130422143616.GP14496@n2100.arm.linux.org.uk>
 <20130422151836.GA15665@mudshark.cambridge.arm.com>
 <5175A697.3080308@dawncrow.de>
 <20130423091536.GB17593@mudshark.cambridge.arm.com>
 <51770E4E.2040003@dawncrow.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <51770E4E.2040003@dawncrow.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Andrew,

On Tue, Apr 23, 2013 at 11:42:22PM +0100, André Hentschel wrote:
> Am 23.04.2013 11:15, schrieb Will Deacon:
> > You could introduce `get' tls functions, which don't do anything for CPUs
> > without the relevant registers.
> 
> Before i have another round of testing and patch formatting/sending,
> what about the untested patch below?

Ok. Comments inline.

> diff --git a/arch/arm/include/asm/thread_info.h b/arch/arm/include/asm/thread_info.h
> index cddda1f..bb5b48d 100644
> --- a/arch/arm/include/asm/thread_info.h
> +++ b/arch/arm/include/asm/thread_info.h
> @@ -58,7 +58,7 @@ struct thread_info {
>  	struct cpu_context_save	cpu_context;	/* cpu context */
>  	__u32			syscall;	/* syscall number */
>  	__u8			used_cp[16];	/* thread used copro */
> -	unsigned long		tp_value;
> +	unsigned long		tp_value[2];
>  #ifdef CONFIG_CRUNCH
>  	struct crunch_state	crunchstate;
>  #endif
> diff --git a/arch/arm/include/asm/tls.h b/arch/arm/include/asm/tls.h
> index 73409e6..1c10163 100644
> --- a/arch/arm/include/asm/tls.h
> +++ b/arch/arm/include/asm/tls.h
> @@ -2,13 +2,30 @@
>  #define __ASMARM_TLS_H
>  
>  #ifdef __ASSEMBLY__
> +	.macro get_tls2_none, tp, tmp1
> +	.endm

Cosmetic, but these are really horrible macro names.

> +	.macro get_tls2_v6k, tp, tmp1
> +	mrc	p15, 0, \tmp1, c13, c0, 2		@ get user r/w TLS register
> +	str	\tmp1, [\tp, #4]
> +	.endm
> +
> +	.macro get_tls2_v6, tp, tmp1
> +	ldr	\tmp1, =elf_hwcap
> +	ldr	\tmp1, [\tmp1, #0]
> +	tst	\tmp1, #HWCAP_TLS		@ hardware TLS available?
> +	mrcne	p15, 0, \tmp1, c13, c0, 2		@ get user r/w TLS register
> +	strne	\tmp1, [\tp, #4]

You could factor out some of this hwcap checking now that it's used by both
set and get.

> +	.endm
> +
> +
>  	.macro set_tls_none, tp, tmp1, tmp2
>  	.endm
>  
>  	.macro set_tls_v6k, tp, tmp1, tmp2
> -	mcr	p15, 0, \tp, c13, c0, 3		@ set TLS register
> -	mov	\tmp1, #0
> -	mcr	p15, 0, \tmp1, c13, c0, 2	@ clear user r/w TLS register
> +	ldrd	\tmp1, \tmp2, [\tp]
> +	mcr	p15, 0, \tmp1, c13, c0, 3	@ set user r/o TLS register
> +	mcr	p15, 0, \tmp2, c13, c0, 2	@ set user r/w TLS register
>  	.endm
>  
>  	.macro set_tls_v6, tp, tmp1, tmp2
> @@ -16,33 +33,39 @@
>  	ldr	\tmp1, [\tmp1, #0]
>  	mov	\tmp2, #0xffff0fff
>  	tst	\tmp1, #HWCAP_TLS		@ hardware TLS available?
> -	mcrne	p15, 0, \tp, c13, c0, 3		@ yes, set TLS register
> -	movne	\tmp1, #0
> -	mcrne	p15, 0, \tmp1, c13, c0, 2	@ clear user r/w TLS register
> -	streq	\tp, [\tmp2, #-15]		@ set TLS value at 0xffff0ff0
> +	ldrdne	\tmp1, \tmp2, [\tp]

Does this work for big-endian CPUs?

> +	ldreq	\tmp1, [\tp]
> +	mcrne	p15, 0, \tmp1, c13, c0, 3	@ yes, set user r/o TLS register
> +	mcrne	p15, 0, \tmp2, c13, c0, 2	@ set user r/w TLS register
> +	streq	\tmp1, [\tmp2, #-15]		@ set TLS value at 0xffff0ff0
>  	.endm
>  
>  	.macro set_tls_software, tp, tmp1, tmp2
> -	mov	\tmp1, #0xffff0fff
> -	str	\tp, [\tmp1, #-15]		@ set TLS value at 0xffff0ff0
> +	ldr	\tmp1, [\tp]
> +	mov	\tmp2, #0xffff0fff
> +	str	\tmp1, [\tmp2, #-15]		@ set TLS value at 0xffff0ff0
>  	.endm
>  #endif
>  
>  #ifdef CONFIG_TLS_REG_EMUL
>  #define tls_emu		1
>  #define has_tls_reg		1
> +#define get_tls2		get_tls2_none
>  #define set_tls		set_tls_none
>  #elif defined(CONFIG_CPU_V6)
>  #define tls_emu		0
>  #define has_tls_reg		(elf_hwcap & HWCAP_TLS)
> +#define get_tls2		get_tls2_v6
>  #define set_tls		set_tls_v6
>  #elif defined(CONFIG_CPU_32v6K)
>  #define tls_emu		0
>  #define has_tls_reg		1
> +#define get_tls2		get_tls2_v6k
>  #define set_tls		set_tls_v6k
>  #else
>  #define tls_emu		0
>  #define has_tls_reg		0
> +#define get_tls2		get_tls2_none
>  #define set_tls		set_tls_software
>  #endif
>  
> diff --git a/arch/arm/kernel/entry-armv.S b/arch/arm/kernel/entry-armv.S
> index 0f82098..097686b 100644
> --- a/arch/arm/kernel/entry-armv.S
> +++ b/arch/arm/kernel/entry-armv.S
> @@ -728,7 +728,7 @@ ENTRY(__switch_to)
>   UNWIND(.fnstart	)
>   UNWIND(.cantunwind	)
>  	add	ip, r1, #TI_CPU_SAVE
> -	ldr	r3, [r2, #TI_TP_VALUE]
> +	add	r3, r1, #TI_TP_VALUE
>   ARM(	stmia	ip!, {r4 - sl, fp, sp, lr} )	@ Store most regs on stack
>   THUMB(	stmia	ip!, {r4 - sl, fp}	   )	@ Store most regs on stack
>   THUMB(	str	sp, [ip], #4		   )
> @@ -736,6 +736,8 @@ ENTRY(__switch_to)
>  #ifdef CONFIG_CPU_USE_DOMAINS
>  	ldr	r6, [r2, #TI_CPU_DOMAIN]
>  #endif
> +	get_tls2	r3, r4
> +	add	r3, r2, #TI_TP_VALUE
>  	set_tls	r3, r4, r5
>  #if defined(CONFIG_CC_STACKPROTECTOR) && !defined(CONFIG_SMP)
>  	ldr	r7, [r2, #TI_TASK]
> diff --git a/arch/arm/kernel/process.c b/arch/arm/kernel/process.c
> index 047d3e4..6138eb1 100644
> --- a/arch/arm/kernel/process.c
> +++ b/arch/arm/kernel/process.c
> @@ -395,7 +395,8 @@ copy_thread(unsigned long clone_flags, unsigned long stack_start,
>  	clear_ptrace_hw_breakpoint(p);
>  
>  	if (clone_flags & CLONE_SETTLS)
> -		thread->tp_value = childregs->ARM_r3;
> +		thread->tp_value[0] = childregs->ARM_r3;
> +	thread->tp_value[1] = current_thread_info()->tp_value[1];
>

This still isn't correct. Imagine the following sequence of events:

  - Task foo writes its TPIDRURW register from userspace and then issues a
    fork() system call. No context switch occurs between these two events.

  - We start creating the child task, bar, and end up in copy_thread with
    the `thread' pointing at foo's struct thread_info, which contains the
    *old* TPIDRURW value.

  - We copy out the stale value into bar, which is then scheduled with an
    old TPIDRURW value.

The solution is to reload the value sitting in the register in copy_thread,
rather than relying on the thread_info being up-to-date. That's why I
previously suggested not using asm macros for the getters.

>  	thread_notify(THREAD_NOTIFY_COPY, thread);
>  
> diff --git a/arch/arm/kernel/ptrace.c b/arch/arm/kernel/ptrace.c
> index 03deeff..2bc1514 100644
> --- a/arch/arm/kernel/ptrace.c
> +++ b/arch/arm/kernel/ptrace.c
> @@ -849,7 +849,7 @@ long arch_ptrace(struct task_struct *child, long request,
>  #endif
>  
>  		case PTRACE_GET_THREAD_AREA:
> -			ret = put_user(task_thread_info(child)->tp_value,
> +			ret = put_user(task_thread_info(child)->tp_value[0],
>  				       datap);
>  			break;

I'm guessing debuggers don't care about the new TLS value, or do we need a
new ptrace request?

Will
