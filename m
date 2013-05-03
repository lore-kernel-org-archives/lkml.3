Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763044Ab3ECPYt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 May 2013 11:24:49 -0400
Received: from service87.mimecast.com ([91.220.42.44]:39340 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762657Ab3ECPYq convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 May 2013 11:24:46 -0400
Message-ID: <5183D6C3.8090402@arm.com>
Date: Fri, 03 May 2013 16:24:51 +0100
From: Jonathan Austin <jonathan.austin@arm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130308 Thunderbird/17.0.4
MIME-Version: 1.0
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
CC: =?UTF-8?B?QW5kcsOpIEhlbnRzY2hlbA==?= <nerv@dawncrow.de>,
        Will Deacon <Will.Deacon@arm.com>,
        "linux-arch@vger.kernel.org" <linux-arch@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCHv2] arm: Preserve TPIDRURW on context switch
References: <517168BB.3070903@dawncrow.de> <20130422143616.GP14496@n2100.arm.linux.org.uk> <20130422151836.GA15665@mudshark.cambridge.arm.com> <5175A697.3080308@dawncrow.de> <20130423091536.GB17593@mudshark.cambridge.arm.com> <51770E4E.2040003@dawncrow.de> <20130424094251.GA21850@mudshark.cambridge.arm.com> <5182C480.3080001@dawncrow.de> <5183819E.50308@arm.com> <20130503095547.GD18614@n2100.arm.linux.org.uk>
In-Reply-To: <20130503095547.GD18614@n2100.arm.linux.org.uk>
X-OriginalArrivalTime: 03 May 2013 15:24:44.0085 (UTC) FILETIME=[56A8FE50:01CE4812]
X-MC-Unique: 113050316244416201
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Russell,

Thanks for the comments - you're right about the 'switch_tls'
being more appropriate - needed to take a step back to see that.

I've got a few questions, added inline.

André, Assuming I've understood things okay, there's a patch that
uses Russell's asm stuff (with minor modifications, see the questions)
and includes the C-world changes too. Perhaps you could see that it
solves your problem?

On 03/05/13 10:55, Russell King - ARM Linux wrote:
> On Fri, May 03, 2013 at 10:21:34AM +0100, Jonathan Austin wrote:
>>   	.macro set_tls_v6k, tp, tmp1, tmp2
>> -	mcr	p15, 0, \tp, c13, c0, 3		@ set TLS register
>> -	mov	\tmp1, #0
>> -	mcr	p15, 0, \tmp1, c13, c0, 2	@ clear user r/w TLS register
>> +	ldrd	\tmp1, \tmp2, [\tp]
>> +	mcr	p15, 0, \tmp1, c13, c0, 3	@ set user r/o TLS register
>> +	mcr	p15, 0, \tmp2, c13, c0, 2	@ set user r/w TLS register
> 
> So we're still back at stalling the pipeline with result delays on older
> CPUs?

How much older? This particular bit is v6k specific so I wasn't worrying
too much but I guess I'm missing something?

It's an academic question wrt to this patch now, though, as the version
you show below re-orders to reduce the stalls...

> 
>> +	.endm
>> +
>> +	.macro save_tlsuser_v6k, tp, tmp1, tmp2
>> +	@ TPIDRURW can be updated from userspace, so we have to re-read it
>> +	mrc	p15, 0, \tmp2, c13, c0, 2	@ load user r/w TLS register
>> +	str	\tmp2, [\tp, #4]
>>   	.endm
>>   
>>   	.macro set_tls_v6, tp, tmp1, tmp2
>> @@ -16,15 +25,26 @@
>>   	ldr	\tmp1, [\tmp1, #0]
>>   	mov	\tmp2, #0xffff0fff
>>   	tst	\tmp1, #HWCAP_TLS		@ hardware TLS available?
>> -	mcrne	p15, 0, \tp, c13, c0, 3		@ yes, set TLS register
>> -	movne	\tmp1, #0
>> -	mcrne	p15, 0, \tmp1, c13, c0, 2	@ clear user r/w TLS register
>> -	streq	\tp, [\tmp2, #-15]		@ set TLS value at 0xffff0ff0
>> +	ldrned	\tmp1, \tmp2, [\tp]
>> +	ldreq	\tmp1, [\tp]
>> +	mcrne	p15, 0, \tmp1, c13, c0, 3	@ yes, set user r/o TLS register
>> +	mcrne	p15, 0, \tmp2, c13, c0, 2	@ set user r/w TLS register
>> +	streq	\tmp1, [\tmp2, #-15]		@ set TLS value at 0xffff0ff0
> 
> This at least is better.
> 
>> +	.endm
>> +
>> +	.macro save_tlsuser_v6, tp, tmp1, tmp2
>> +	@ TPIDRURW can be updated from userspace, so we have to re-read it
>> +	ldr	\tmp1, =elf_hwcap
>> +	ldr	\tmp1, [\tmp1, #0]
>> +	tst	\tmp1, #HWCAP_TLS		@ hardware TLS available?
> 
> But this isn't - this involves two delays.

Indeed. You left this section untouched in your asm below - was that
because you didn't look at optimising it, or because you thought there
wasn't much better that could be done with it?

As far as I can see, we can't start doing any mcr/mrc operations until we
know for sure that the hw implements them, so this is something we're
stuck with?

Is V6 but not V6k just 1136?

> 
>> +	mrcne	p15, 0, \tmp2, c13, c0, 2	@ read user r/w TLS register
>> +	strne	\tmp2, [\tp, #4]		@ save in to thread_info
>>   	.endm
>>   
>>   	.macro set_tls_software, tp, tmp1, tmp2
>> -	mov	\tmp1, #0xffff0fff
>> -	str	\tp, [\tmp1, #-15]		@ set TLS value at 0xffff0ff0
>> +	ldr	\tmp1, [\tp]
>> +	mov	\tmp2, #0xffff0fff
>> +	str	\tmp1, [\tmp2, #-15]		@ set TLS value at 0xffff0ff0
>>   	.endm
>>   #endif
>>   
>> @@ -32,18 +52,31 @@
>>   #define tls_emu		1
>>   #define has_tls_reg		1
>>   #define set_tls		set_tls_none
>> +#define save_tlsuser	save_tlsuser_none
>> +#define get_tlsuser	get_tlsuser_none
>>   #elif defined(CONFIG_CPU_V6)
>>   #define tls_emu		0
>>   #define has_tls_reg		(elf_hwcap & HWCAP_TLS)
>>   #define set_tls		set_tls_v6
>> +#define save_tlsuser	save_tlsuser_v6
>> +#define get_tlsuser	get_tlsuser_v6
>>   #elif defined(CONFIG_CPU_32v6K)
>>   #define tls_emu		0
>>   #define has_tls_reg		1
>>   #define set_tls		set_tls_v6k
>> +#define save_tlsuser	save_tlsuser_v6k
>> +#define get_tlsuser	get_tlsuser_v6k
>>   #else
>>   #define tls_emu		0
>>   #define has_tls_reg		0
>>   #define set_tls		set_tls_software
>> +#define save_tlsuser	save_tlsuser_none
>> +#define get_tlsuser	get_tlsuser_none
>>   #endif
> 
> This separation of setting and saving the TLS value is actually quite
> silly.  They're called from the same place, so lets just call it
> "switch_tls" instead.

Agreed. Thanks for the suggestion.

> 
> Here's just the assembly bits doing that - this is totally untested
> of course:
> 
>   arch/arm/include/asm/tls.h   |   28 +++++++++++++++-------------
>   arch/arm/kernel/entry-armv.S |    4 ++--
>   2 files changed, 17 insertions(+), 15 deletions(-)
> 
> diff --git a/arch/arm/include/asm/tls.h b/arch/arm/include/asm/tls.h
> index 73409e6..9c377f1 100644
> --- a/arch/arm/include/asm/tls.h
> +++ b/arch/arm/include/asm/tls.h
> @@ -2,27 +2,29 @@
>   #define __ASMARM_TLS_H
>   
>   #ifdef __ASSEMBLY__

+#include <asm/asm-offsets.h>

required for TI_TP_VALUE

> -	.macro set_tls_none, tp, tmp1, tmp2
> +	.macro switch_tls_none, base, tp, trw, tmp1, tmp2
>   	.endm
>   
> -	.macro set_tls_v6k, tp, tmp1, tmp2
> +	.macro switch_tls_v6k, base, tp, trw, tmp1, tmp2

How do you feel about calling tp and trw something different? tpidro
and tpidrw, or tp and tpuser?

The naming threw me off slightly first time I read this new signature
(tp=thread_pointer/tls_pointer/etc).

> +	mrc	p15, 0, \tmp2, c13, c0, 2	@ get the user r/w register
>   	mcr	p15, 0, \tp, c13, c0, 3		@ set TLS register
> -	mov	\tmp1, #0
> -	mcr	p15, 0, \tmp1, c13, c0, 2	@ clear user r/w TLS register
> +	mcr	p15, 0, \trw, c13, c0, 2	@ and the user r/w register
> +	str	\tmp2, [\base, #TI_TP_VALUE + 4]@ save it
>   	.endm
>   
> -	.macro set_tls_v6, tp, tmp1, tmp2
> +	.macro switch_tls_v6, base, tp, trw, tmp1, tmp2
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
> +	mcrne	p15, 0, \trw, c13, c0, 2	@ set user r/w register
> +	strne	\tmp2, [\base, #TI_TP_VALUE + 4]@ save it
>   	.endm
>   
> -	.macro set_tls_software, tp, tmp1, tmp2
> +	.macro switch_tls_software, base, tp, trw, tmp1, tmp2
>   	mov	\tmp1, #0xffff0fff
>   	str	\tp, [\tmp1, #-15]		@ set TLS value at 0xffff0ff0
>   	.endm
> @@ -31,19 +33,19 @@
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
>   #endif	/* __ASMARM_TLS_H */
> diff --git a/arch/arm/kernel/entry-armv.S b/arch/arm/kernel/entry-armv.S
> index 0f82098..81a08b1 100644
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
> +	switch_tls r2, r4, r5, r3, r7

Looking at the implementation above and the way you use 'base', I think
that should be 
switch_tls r1, r4, r5, r3, r7
not
switch_tls r2, r4, r5, r3, r7

That way we save tpidrurw in to the old thread pointer not the new one.

>   #if defined(CONFIG_CC_STACKPROTECTOR) && !defined(CONFIG_SMP)
>   	ldr	r7, [r2, #TI_TASK]
>   	ldr	r8, =__stack_chk_guard
> 
> 

Here's a complete patch including Russell's suggested asm. Tested on
TC2, build-tested for 1136

I think we could drop the extra .c file too - though it is kinda nice
for keeping include/asm/tls.h clean...

----8<------
diff --git a/arch/arm/include/asm/thread_info.h b/arch/arm/include/asm/thread_info.h
index cddda1f..d90be6d 100644
--- a/arch/arm/include/asm/thread_info.h
+++ b/arch/arm/include/asm/thread_info.h
@@ -58,7 +58,7 @@ struct thread_info {
 	struct cpu_context_save	cpu_context;	/* cpu context */
 	__u32			syscall;	/* syscall number */
 	__u8			used_cp[16];	/* thread used copro */
-	unsigned long		tp_value;
+	unsigned long		tp_value[2];	/* TLS registers */
 #ifdef CONFIG_CRUNCH
 	struct crunch_state	crunchstate;
 #endif
diff --git a/arch/arm/include/asm/tls.h b/arch/arm/include/asm/tls.h
index 73409e6..39bce5b 100644
--- a/arch/arm/include/asm/tls.h
+++ b/arch/arm/include/asm/tls.h
@@ -2,27 +2,30 @@
 #define __ASMARM_TLS_H
 
 #ifdef __ASSEMBLY__
-	.macro set_tls_none, tp, tmp1, tmp2
+#include <asm/asm-offsets.h>
+	.macro switch_tls_none, base, tp, trw, tmp1, tmp2
 	.endm
 
-	.macro set_tls_v6k, tp, tmp1, tmp2
+	.macro switch_tls_v6k, base, tp, trw, tmp1, tmp2
+	mrc	p15, 0, \tmp2, c13, c0, 2	@ get the user r/w register
 	mcr	p15, 0, \tp, c13, c0, 3		@ set TLS register
-	mov	\tmp1, #0
-	mcr	p15, 0, \tmp1, c13, c0, 2	@ clear user r/w TLS register
+	mcr	p15, 0, \trw, c13, c0, 2	@ and the user r/w register
+	strne	\tmp2, [\base, #TI_TP_VALUE + 4] @ save it
 	.endm
 
-	.macro set_tls_v6, tp, tmp1, tmp2
+	.macro switch_tls_v6, base, tp, trw, tmp1, tmp2
 	ldr	\tmp1, =elf_hwcap
 	ldr	\tmp1, [\tmp1, #0]
 	mov	\tmp2, #0xffff0fff
 	tst	\tmp1, #HWCAP_TLS		@ hardware TLS available?
-	mcrne	p15, 0, \tp, c13, c0, 3		@ yes, set TLS register
-	movne	\tmp1, #0
-	mcrne	p15, 0, \tmp1, c13, c0, 2	@ clear user r/w TLS register
 	streq	\tp, [\tmp2, #-15]		@ set TLS value at 0xffff0ff0
+	mrcne	p15, 0, \tmp2, c13, c0, 2	@ get the user r/w register
+	mcrne	p15, 0, \tp, c13, c0, 3		@ yes, set TLS register
+	mcrne	p15, 0, \trw, c13, c0, 2	@ set user r/w register
+	strne	\tmp2, [\base, #TI_TP_VALUE + 4] @ save it
 	.endm
 
-	.macro set_tls_software, tp, tmp1, tmp2
+	.macro switch_tls_software, base, tp, trw, tmp1, tmp2
 	mov	\tmp1, #0xffff0fff
 	str	\tp, [\tmp1, #-15]		@ set TLS value at 0xffff0ff0
 	.endm
@@ -31,19 +34,28 @@
 #ifdef CONFIG_TLS_REG_EMUL
 #define tls_emu		1
 #define has_tls_reg		1
-#define set_tls		set_tls_none
+#define switch_tls	switch_tls_none
+#define get_tlsuser	get_tlsuser_none
 #elif defined(CONFIG_CPU_V6)
 #define tls_emu		0
 #define has_tls_reg		(elf_hwcap & HWCAP_TLS)
-#define set_tls		set_tls_v6
+#define switch_tls	switch_tls_v6
+#define get_tlsuser	get_tlsuser_v6
 #elif defined(CONFIG_CPU_32v6K)
 #define tls_emu		0
 #define has_tls_reg		1
-#define set_tls		set_tls_v6k
+#define switch_tls	switch_tls_v6k
+#define get_tlsuser	get_tlsuser_v6k
 #else
 #define tls_emu		0
 #define has_tls_reg		0
-#define set_tls		set_tls_software
+#define switch_tls	switch_tls_software
+#define get_tlsuser	get_tlsuser_none
 #endif
 
+#ifndef __ASSEMBLY__
+extern unsigned long get_tlsuser_none(void);
+extern unsigned long get_tlsuser_v6(void);
+extern unsigned long get_tlsuser_v6k(void);
+#endif
 #endif	/* __ASMARM_TLS_H */
diff --git a/arch/arm/kernel/Makefile b/arch/arm/kernel/Makefile
index 5f3338e..4e1114c 100644
--- a/arch/arm/kernel/Makefile
+++ b/arch/arm/kernel/Makefile
@@ -17,7 +17,7 @@ CFLAGS_REMOVE_return_address.o = -pg
 
 obj-y		:= elf.o entry-armv.o entry-common.o irq.o opcodes.o \
 		   process.o ptrace.o return_address.o sched_clock.o \
-		   setup.o signal.o stacktrace.o sys_arm.o time.o traps.o
+		   setup.o signal.o stacktrace.o sys_arm.o time.o tls.o traps.o
 
 obj-$(CONFIG_ATAGS)		+= atags_parse.o
 obj-$(CONFIG_ATAGS_PROC)	+= atags_proc.o
diff --git a/arch/arm/kernel/entry-armv.S b/arch/arm/kernel/entry-armv.S
index 0f82098..80f09fe 100644
--- a/arch/arm/kernel/entry-armv.S
+++ b/arch/arm/kernel/entry-armv.S
@@ -728,15 +728,15 @@ ENTRY(__switch_to)
  UNWIND(.fnstart	)
  UNWIND(.cantunwind	)
 	add	ip, r1, #TI_CPU_SAVE
-	ldr	r3, [r2, #TI_TP_VALUE]
  ARM(	stmia	ip!, {r4 - sl, fp, sp, lr} )	@ Store most regs on stack
  THUMB(	stmia	ip!, {r4 - sl, fp}	   )	@ Store most regs on stack
  THUMB(	str	sp, [ip], #4		   )
  THUMB(	str	lr, [ip], #4		   )
+	ldrd	r4, r5, [r2, #TI_TP_VALUE]
 #ifdef CONFIG_CPU_USE_DOMAINS
 	ldr	r6, [r2, #TI_CPU_DOMAIN]
 #endif
-	set_tls	r3, r4, r5
+	switch_tls r1, r4, r5, r3, r7
 #if defined(CONFIG_CC_STACKPROTECTOR) && !defined(CONFIG_SMP)
 	ldr	r7, [r2, #TI_TASK]
 	ldr	r8, =__stack_chk_guard
diff --git a/arch/arm/kernel/process.c b/arch/arm/kernel/process.c
index 047d3e4..24dbc72 100644
--- a/arch/arm/kernel/process.c
+++ b/arch/arm/kernel/process.c
@@ -39,6 +39,7 @@
 #include <asm/thread_notify.h>
 #include <asm/stacktrace.h>
 #include <asm/mach/time.h>
+#include <asm/tls.h>
 
 #ifdef CONFIG_CC_STACKPROTECTOR
 #include <linux/stackprotector.h>
@@ -395,7 +396,8 @@ copy_thread(unsigned long clone_flags, unsigned long stack_start,
 	clear_ptrace_hw_breakpoint(p);
 
 	if (clone_flags & CLONE_SETTLS)
-		thread->tp_value = childregs->ARM_r3;
+		thread->tp_value[0] = childregs->ARM_r3;
+	thread->tp_value[1] = get_tlsuser();
 
 	thread_notify(THREAD_NOTIFY_COPY, thread);
 
diff --git a/arch/arm/kernel/ptrace.c b/arch/arm/kernel/ptrace.c
index 03deeff..2bc1514 100644
--- a/arch/arm/kernel/ptrace.c
+++ b/arch/arm/kernel/ptrace.c
@@ -849,7 +849,7 @@ long arch_ptrace(struct task_struct *child, long request,
 #endif
 
 		case PTRACE_GET_THREAD_AREA:
-			ret = put_user(task_thread_info(child)->tp_value,
+			ret = put_user(task_thread_info(child)->tp_value[0],
 				       datap);
 			break;
 
diff --git a/arch/arm/kernel/tls.c b/arch/arm/kernel/tls.c
new file mode 100644
index 0000000..1627f5b
--- /dev/null
+++ b/arch/arm/kernel/tls.c
@@ -0,0 +1,50 @@
+/*
+ * arch/arm/kernel/tls.c
+ *
+ * Copyright (C) 2013 ARM Limited
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA
+ */
+
+#include <linux/kernel.h>
+#include <asm/tls.h>
+
+/*
+ * Access to the TPIDRURW register, with full certainty that it exists.
+ */
+unsigned long get_tlsuser_v6k(void)
+{
+	unsigned long v;
+	asm("mrc        p15, 0, %0, c13, c0, 2\n" : "=r" (v));
+	return v;
+}
+
+/*
+ * Access to the TPIDRURW register if it exists.
+ */
+unsigned long get_tlsuser_v6(void)
+{
+	unsigned long v = 0;
+	if (elf_hwcap & HWCAP_TLS)
+		asm("mrc        p15, 0, %0, c13, c0, 2\n" : "=r" (v));
+	return v;
+}
+
+/*
+ * Dummy access for the case that TLS is emulated in software
+ */
+unsigned long get_tlsuser_none(void)
+{
+	return 0;
+}
diff --git a/arch/arm/kernel/traps.c b/arch/arm/kernel/traps.c
index 1c08911..f9d6259 100644
--- a/arch/arm/kernel/traps.c
+++ b/arch/arm/kernel/traps.c
@@ -588,7 +588,7 @@ asmlinkage int arm_syscall(int no, struct pt_regs *regs)
 		return regs->ARM_r0;
 
 	case NR(set_tls):
-		thread->tp_value = regs->ARM_r0;
+		thread->tp_value[0] = regs->ARM_r0;
 		if (tls_emu)
 			return 0;
 		if (has_tls_reg) {
@@ -706,7 +706,7 @@ static int get_tp_trap(struct pt_regs *regs, unsigned int instr)
 	int reg = (instr >> 12) & 15;
 	if (reg == 15)
 		return 1;
-	regs->uregs[reg] = current_thread_info()->tp_value;
+	regs->uregs[reg] = current_thread_info()->tp_value[0];
 	regs->ARM_pc += 4;
 	return 0;
 }


