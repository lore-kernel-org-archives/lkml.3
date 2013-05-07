Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756739Ab3EGKQ4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 May 2013 06:16:56 -0400
Received: from service87.mimecast.com ([91.220.42.44]:47638 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756489Ab3EGKQy convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 May 2013 06:16:54 -0400
Message-ID: <5188D498.9010203@arm.com>
Date: Tue, 07 May 2013 11:16:56 +0100
From: Jonathan Austin <jonathan.austin@arm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130308 Thunderbird/17.0.4
MIME-Version: 1.0
To: =?UTF-8?B?QW5kcsOpIEhlbnRzY2hlbA==?= <nerv@dawncrow.de>
CC: Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Will Deacon <Will.Deacon@arm.com>,
        "linux-arch@vger.kernel.org" <linux-arch@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCHv2] arm: Preserve TPIDRURW on context switch
References: <517168BB.3070903@dawncrow.de> <20130422143616.GP14496@n2100.arm.linux.org.uk> <20130422151836.GA15665@mudshark.cambridge.arm.com> <5175A697.3080308@dawncrow.de> <20130423091536.GB17593@mudshark.cambridge.arm.com> <51770E4E.2040003@dawncrow.de> <20130424094251.GA21850@mudshark.cambridge.arm.com> <5182C480.3080001@dawncrow.de> <5183819E.50308@arm.com> <20130503095547.GD18614@n2100.arm.linux.org.uk> <5183D6C3.8090402@arm.com> <51882E6A.6070302@dawncrow.de>
In-Reply-To: <51882E6A.6070302@dawncrow.de>
X-OriginalArrivalTime: 07 May 2013 10:16:50.0176 (UTC) FILETIME=[FD013000:01CE4B0B]
X-MC-Unique: 113050711165204601
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi André,

On 06/05/13 23:27, André Hentschel wrote:
> Am 03.05.2013 17:24, schrieb Jonathan Austin:
>>> -	.macro set_tls_none, tp, tmp1, tmp2
>>> +	.macro switch_tls_none, base, tp, trw, tmp1, tmp2
>>>    	.endm
>>>
>>> -	.macro set_tls_v6k, tp, tmp1, tmp2
>>> +	.macro switch_tls_v6k, base, tp, trw, tmp1, tmp2
>>
>> How do you feel about calling tp and trw something different? tpidro
>> and tpidrw, or tp and tpuser?
>>
>> The naming threw me off slightly first time I read this new signature
>> (tp=thread_pointer/tls_pointer/etc).
>>
>
> FWIW i think tp&tpuser is more consistent.
>
>> André, Assuming I've understood things okay, there's a patch that
>> uses Russell's asm stuff (with minor modifications, see the questions)
>> and includes the C-world changes too. Perhaps you could see that it
>> solves your problem?
>
> It works, but for various reasons i would like to suggest the patch below.
> Reasons include: My thoughts about tp&tpuser naming and the helper function for copy_thread, further i'd really like to get a bit credit for spending weeks on getting my second kernel patch in :)
> If that patch is fine for you and no one object, i'd be happy to test it, adapt the commit message and include:
> 	Reported-by: André Hentschel <nerv@dawncrow.de>
> 	Signed-off-by: André Hentschel <nerv@dawncrow.de>
> 	Signed-off-by: Will Deacon <will.deacon@arm.com>
> 	Signed-off-by: Russell King <rmk+kernel@arm.linux.org.uk>
> 	Signed-off-by: Jonathan Austin <jonathan.austin@arm.com>

I'm not worried about authorship, so you're welcome to be the author on 
the patch - assuming Russell's happy with that and with the change of 
register naming in your patch below.

As this will go through Russell's tree (probably via has patch system), 
you don't need his Signed-off-by - It'll get added as he takes the 
patch. As you're signing off, too, you don't need to list yourself as 
reporting the problem.

It'll look a bit weird to have 3 people signing off on quite a little 
patch (4 once it goes through Russell's tree) so it's best to make some 
notes in the commit message about the way this patch was written (IE 
many authors)

Hope that helps,
Jonny
>
> Not totally sure about the Signed-off-bys. Can i add a Signed-off-by for Russell King? Is it the right mail address for him/you?
>
>
>
>
> diff --git a/arch/arm/include/asm/thread_info.h b/arch/arm/include/asm/thread_info.h
> index cddda1f..d90be6d 100644
> --- a/arch/arm/include/asm/thread_info.h
> +++ b/arch/arm/include/asm/thread_info.h
> @@ -58,7 +58,7 @@ struct thread_info {
>   	struct cpu_context_save	cpu_context;	/* cpu context */
>   	__u32			syscall;	/* syscall number */
>   	__u8			used_cp[16];	/* thread used copro */
> -	unsigned long		tp_value;
> +	unsigned long		tp_value[2];	/* TLS registers */
>   #ifdef CONFIG_CRUNCH
>   	struct crunch_state	crunchstate;
>   #endif
> diff --git a/arch/arm/include/asm/tls.h b/arch/arm/include/asm/tls.h
> index 73409e6..d7d542b 100644
> --- a/arch/arm/include/asm/tls.h
> +++ b/arch/arm/include/asm/tls.h
> @@ -2,27 +2,30 @@
>   #define __ASMARM_TLS_H
>
>   #ifdef __ASSEMBLY__
> -	.macro set_tls_none, tp, tmp1, tmp2
> +#include <asm/asm-offsets.h>
> +	.macro switch_tls_none, base, tp, tpuser, tmp1, tmp2
>   	.endm
>
> -	.macro set_tls_v6k, tp, tmp1, tmp2
> +	.macro switch_tls_v6k, base, tp, tpuser, tmp1, tmp2
> +	mrc	p15, 0, \tmp2, c13, c0, 2	@ get the user r/w register
>   	mcr	p15, 0, \tp, c13, c0, 3		@ set TLS register
> -	mov	\tmp1, #0
> -	mcr	p15, 0, \tmp1, c13, c0, 2	@ clear user r/w TLS register
> +	mcr	p15, 0, \tpuser, c13, c0, 2	@ and the user r/w register
> +	strne	\tmp2, [\base, #TI_TP_VALUE + 4] @ save it
>   	.endm
>
> -	.macro set_tls_v6, tp, tmp1, tmp2
> +	.macro switch_tls_v6, base, tp, tpuser, tmp1, tmp2
>   	ldr	\tmp1, =elf_hwcap
>   	ldr	\tmp1, [\tmp1, #0]
>   	mov	\tmp2, #0xffff0fff
>   	tst	\tmp1, #HWCAP_TLS		@ hardware TLS available?
> -	mcrne	p15, 0, \tp, c13, c0, 3		@ yes, set TLS register
> -	movne	\tmp1, #0
> -	mcrne	p15, 0, \tmp1, c13, c0, 2	@ clear user r/w TLS register
>   	streq	\tp, [\tmp2, #-15]		@ set TLS value at 0xffff0ff0
> +	mrcne	p15, 0, \tmp2, c13, c0, 2	@ get the user r/w register
> +	mcrne	p15, 0, \tp, c13, c0, 3		@ yes, set TLS register
> +	mcrne	p15, 0, \tpuser, c13, c0, 2	@ set user r/w register
> +	strne	\tmp2, [\base, #TI_TP_VALUE + 4] @ save it
>   	.endm
>
> -	.macro set_tls_software, tp, tmp1, tmp2
> +	.macro switch_tls_software, base, tp, tpuser, tmp1, tmp2
>   	mov	\tmp1, #0xffff0fff
>   	str	\tp, [\tmp1, #-15]		@ set TLS value at 0xffff0ff0
>   	.endm
> @@ -31,19 +34,31 @@
>   #ifdef CONFIG_TLS_REG_EMUL
>   #define tls_emu		1
>   #define has_tls_reg		1
> -#define set_tls		set_tls_none
> +#define switch_tls	switch_tls_none
>   #elif defined(CONFIG_CPU_V6)
>   #define tls_emu		0
>   #define has_tls_reg		(elf_hwcap & HWCAP_TLS)
> -#define set_tls		set_tls_v6
> +#define switch_tls	switch_tls_v6
>   #elif defined(CONFIG_CPU_32v6K)
>   #define tls_emu		0
>   #define has_tls_reg		1
> -#define set_tls		set_tls_v6k
> +#define switch_tls	switch_tls_v6k
>   #else
>   #define tls_emu		0
>   #define has_tls_reg		0
> -#define set_tls		set_tls_software
> +#define switch_tls	switch_tls_software
>   #endif
>
> +#ifndef __ASSEMBLY__
> +static inline unsigned long get_tlsuser(void)
> +{
> +	if (has_tls_reg && !tls_emu)
> +	{
> +		unsigned long t;
> +		__asm__("mcr p15, 0, %0, c13, c0, 2" : : "r" (t));
> +		return t;
> +	}
> +	return 0;
> +}
> +#endif
>   #endif	/* __ASMARM_TLS_H */
> diff --git a/arch/arm/kernel/entry-armv.S b/arch/arm/kernel/entry-armv.S
> index 0f82098..80f09fe 100644
> --- a/arch/arm/kernel/entry-armv.S
> +++ b/arch/arm/kernel/entry-armv.S
> @@ -728,15 +728,15 @@ ENTRY(__switch_to)
>    UNWIND(.fnstart	)
>    UNWIND(.cantunwind	)
>   	add	ip, r1, #TI_CPU_SAVE
> -	ldr	r3, [r2, #TI_TP_VALUE]
>    ARM(	stmia	ip!, {r4 - sl, fp, sp, lr} )	@ Store most regs on stack
>    THUMB(	stmia	ip!, {r4 - sl, fp}	   )	@ Store most regs on stack
>    THUMB(	str	sp, [ip], #4		   )
>    THUMB(	str	lr, [ip], #4		   )
> +	ldrd	r4, r5, [r2, #TI_TP_VALUE]
>   #ifdef CONFIG_CPU_USE_DOMAINS
>   	ldr	r6, [r2, #TI_CPU_DOMAIN]
>   #endif
> -	set_tls	r3, r4, r5
> +	switch_tls r1, r4, r5, r3, r7
>   #if defined(CONFIG_CC_STACKPROTECTOR) && !defined(CONFIG_SMP)
>   	ldr	r7, [r2, #TI_TASK]
>   	ldr	r8, =__stack_chk_guard
> diff --git a/arch/arm/kernel/process.c b/arch/arm/kernel/process.c
> index 047d3e4..24dbc72 100644
> --- a/arch/arm/kernel/process.c
> +++ b/arch/arm/kernel/process.c
> @@ -39,6 +39,7 @@
>   #include <asm/thread_notify.h>
>   #include <asm/stacktrace.h>
>   #include <asm/mach/time.h>
> +#include <asm/tls.h>
>
>   #ifdef CONFIG_CC_STACKPROTECTOR
>   #include <linux/stackprotector.h>
> @@ -395,7 +396,8 @@ copy_thread(unsigned long clone_flags, unsigned long stack_start,
>   	clear_ptrace_hw_breakpoint(p);
>
>   	if (clone_flags & CLONE_SETTLS)
> -		thread->tp_value = childregs->ARM_r3;
> +		thread->tp_value[0] = childregs->ARM_r3;
> +	thread->tp_value[1] = get_tlsuser();
>
>   	thread_notify(THREAD_NOTIFY_COPY, thread);
>
> diff --git a/arch/arm/kernel/ptrace.c b/arch/arm/kernel/ptrace.c
> index 03deeff..2bc1514 100644
> --- a/arch/arm/kernel/ptrace.c
> +++ b/arch/arm/kernel/ptrace.c
> @@ -849,7 +849,7 @@ long arch_ptrace(struct task_struct *child, long request,
>   #endif
>
>   		case PTRACE_GET_THREAD_AREA:
> -			ret = put_user(task_thread_info(child)->tp_value,
> +			ret = put_user(task_thread_info(child)->tp_value[0],
>   				       datap);
>   			break;
>
> diff --git a/arch/arm/kernel/traps.c b/arch/arm/kernel/traps.c
> index 1c08911..f9d6259 100644
> --- a/arch/arm/kernel/traps.c
> +++ b/arch/arm/kernel/traps.c
> @@ -588,7 +588,7 @@ asmlinkage int arm_syscall(int no, struct pt_regs *regs)
>   		return regs->ARM_r0;
>
>   	case NR(set_tls):
> -		thread->tp_value = regs->ARM_r0;
> +		thread->tp_value[0] = regs->ARM_r0;
>   		if (tls_emu)
>   			return 0;
>   		if (has_tls_reg) {
> @@ -706,7 +706,7 @@ static int get_tp_trap(struct pt_regs *regs, unsigned int instr)
>   	int reg = (instr >> 12) & 15;
>   	if (reg == 15)
>   		return 1;
> -	regs->uregs[reg] = current_thread_info()->tp_value;
> +	regs->uregs[reg] = current_thread_info()->tp_value[0];
>   	regs->ARM_pc += 4;
>   	return 0;
>   }
>
>


