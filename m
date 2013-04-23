Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756909Ab3DWWme (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Apr 2013 18:42:34 -0400
Received: from moutng.kundenserver.de ([212.227.126.187]:51561 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756477Ab3DWWmc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Apr 2013 18:42:32 -0400
Message-ID: <51770E4E.2040003@dawncrow.de>
Date: Wed, 24 Apr 2013 00:42:22 +0200
From: =?ISO-8859-1?Q?Andr=E9_Hentschel?= <nerv@dawncrow.de>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130329 Thunderbird/17.0.5
MIME-Version: 1.0
To: Will Deacon <will.deacon@arm.com>
CC: Russell King - ARM Linux <linux@arm.linux.org.uk>,
        "linux-arch@vger.kernel.org" <linux-arch@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCHv2] arm: Preserve TPIDRURW on context switch
References: <517168BB.3070903@dawncrow.de> <20130422143616.GP14496@n2100.arm.linux.org.uk> <20130422151836.GA15665@mudshark.cambridge.arm.com> <5175A697.3080308@dawncrow.de> <20130423091536.GB17593@mudshark.cambridge.arm.com>
In-Reply-To: <20130423091536.GB17593@mudshark.cambridge.arm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
X-Provags-ID: V02:K0:g/AwBd7Mf9qxhry/6yVJQ9emKnGErp8ZHsSV6J2BSkE
 1oT6jVcXnn8gjIBpEfe2S7YNCmbQPEXX5nSDIdCzIqjDasx5Zu
 tGYJDt3E4TQGSj0Mj3YlZ9OIt3ZKpMVIuo3Gbytl1YfB1/uU71
 eJNwvJR+oWA8DxDXc7Mni2oKlIcdD5XMrg5kJKXAImyE/EJ+ol
 gbFcUHrw2ElBlIMz8V/Gm3uEh1KR+FzZt9zLm7YXHPZbIzsrSa
 bKXfbg+Vr4p//aq1LFLgNtcaA39e13MEhCcUHiN1NWn6mquYgu
 ZLEoh53gwxHAM8lLbHY2xUPCQG1Etwt8jhH0WW9VLhNIanU6Cv
 s5QQkJa2EeTvJp8nnIug=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am 23.04.2013 11:15, schrieb Will Deacon:
> On Mon, Apr 22, 2013 at 10:07:35PM +0100, André Hentschel wrote:
>> Am 22.04.2013 17:18, schrieb Will Deacon:
>>> On Mon, Apr 22, 2013 at 03:36:16PM +0100, Russell King - ARM Linux wrote:
>>>> On Fri, Apr 19, 2013 at 05:54:35PM +0200, André Hentschel wrote:
>>>>> From: =?UTF-8?q?Andr=C3=A9=20Hentschel?= <nerv@dawncrow.de>
>>>>>
>>>>> There are more and more applications coming to WinRT, Wine could support them,
>>>>> but mostly they expect to have the thread environment block (TEB) in TPIDRURW.
>>>>> This register must be preserved per thread instead of being cleared.
>>>>>
>>>>> Signed-off-by: André Hentschel <nerv@dawncrow.de>
>>>>
>>>> This actually makes things less efficient all round, because you
>>>> now use the value immediately after loading, which means it will cause
>>>> pipeline stalls, certainly on older CPUs.
>>>>
>>>> Could you please rework the patch to try avoiding soo many modifications
>>>> to the way things have been done here?
>>>
>>> copy_thread also needs updating so that the *register* value for the parent
>>> is copied to the child, since the parent may have written the register
>>> after the last context-switch, meaning that tp_value is out-of-date.
>>
>> Thank you both for reviewing.
>>
>> I guess you mostly mean "ldr	r6, [r2, #TI_CPU_DOMAIN]".
>> I just thought about old CPUs and remembered again that we at Wine
>> need that patch only on v7 (and later). So is it ok to introduce a set_tls_v7
>> in tls.h and make use of CONFIG_CPU_V7 compile-time check in
>> the changed files and in the copy_thread function?
> 
> No, we should support this feature on any CPU with the TPIDRURW register,
> otherwise it's going to get really confusing for userspace.

Sure, remembered that today.

>> Do i need any further flag checks in copy_thread or can i use the
>> compile-time check to add unconditional code?
> 
> You could introduce `get' tls functions, which don't do anything for CPUs
> without the relevant registers.

Before i have another round of testing and patch formatting/sending,
what about the untested patch below?


diff --git a/arch/arm/include/asm/thread_info.h b/arch/arm/include/asm/thread_info.h
index cddda1f..bb5b48d 100644
--- a/arch/arm/include/asm/thread_info.h
+++ b/arch/arm/include/asm/thread_info.h
@@ -58,7 +58,7 @@ struct thread_info {
 	struct cpu_context_save	cpu_context;	/* cpu context */
 	__u32			syscall;	/* syscall number */
 	__u8			used_cp[16];	/* thread used copro */
-	unsigned long		tp_value;
+	unsigned long		tp_value[2];
 #ifdef CONFIG_CRUNCH
 	struct crunch_state	crunchstate;
 #endif
diff --git a/arch/arm/include/asm/tls.h b/arch/arm/include/asm/tls.h
index 73409e6..1c10163 100644
--- a/arch/arm/include/asm/tls.h
+++ b/arch/arm/include/asm/tls.h
@@ -2,13 +2,30 @@
 #define __ASMARM_TLS_H
 
 #ifdef __ASSEMBLY__
+	.macro get_tls2_none, tp, tmp1
+	.endm
+
+	.macro get_tls2_v6k, tp, tmp1
+	mrc	p15, 0, \tmp1, c13, c0, 2		@ get user r/w TLS register
+	str	\tmp1, [\tp, #4]
+	.endm
+
+	.macro get_tls2_v6, tp, tmp1
+	ldr	\tmp1, =elf_hwcap
+	ldr	\tmp1, [\tmp1, #0]
+	tst	\tmp1, #HWCAP_TLS		@ hardware TLS available?
+	mrcne	p15, 0, \tmp1, c13, c0, 2		@ get user r/w TLS register
+	strne	\tmp1, [\tp, #4]
+	.endm
+
+
 	.macro set_tls_none, tp, tmp1, tmp2
 	.endm
 
 	.macro set_tls_v6k, tp, tmp1, tmp2
-	mcr	p15, 0, \tp, c13, c0, 3		@ set TLS register
-	mov	\tmp1, #0
-	mcr	p15, 0, \tmp1, c13, c0, 2	@ clear user r/w TLS register
+	ldrd	\tmp1, \tmp2, [\tp]
+	mcr	p15, 0, \tmp1, c13, c0, 3	@ set user r/o TLS register
+	mcr	p15, 0, \tmp2, c13, c0, 2	@ set user r/w TLS register
 	.endm
 
 	.macro set_tls_v6, tp, tmp1, tmp2
@@ -16,33 +33,39 @@
 	ldr	\tmp1, [\tmp1, #0]
 	mov	\tmp2, #0xffff0fff
 	tst	\tmp1, #HWCAP_TLS		@ hardware TLS available?
-	mcrne	p15, 0, \tp, c13, c0, 3		@ yes, set TLS register
-	movne	\tmp1, #0
-	mcrne	p15, 0, \tmp1, c13, c0, 2	@ clear user r/w TLS register
-	streq	\tp, [\tmp2, #-15]		@ set TLS value at 0xffff0ff0
+	ldrdne	\tmp1, \tmp2, [\tp]
+	ldreq	\tmp1, [\tp]
+	mcrne	p15, 0, \tmp1, c13, c0, 3	@ yes, set user r/o TLS register
+	mcrne	p15, 0, \tmp2, c13, c0, 2	@ set user r/w TLS register
+	streq	\tmp1, [\tmp2, #-15]		@ set TLS value at 0xffff0ff0
 	.endm
 
 	.macro set_tls_software, tp, tmp1, tmp2
-	mov	\tmp1, #0xffff0fff
-	str	\tp, [\tmp1, #-15]		@ set TLS value at 0xffff0ff0
+	ldr	\tmp1, [\tp]
+	mov	\tmp2, #0xffff0fff
+	str	\tmp1, [\tmp2, #-15]		@ set TLS value at 0xffff0ff0
 	.endm
 #endif
 
 #ifdef CONFIG_TLS_REG_EMUL
 #define tls_emu		1
 #define has_tls_reg		1
+#define get_tls2		get_tls2_none
 #define set_tls		set_tls_none
 #elif defined(CONFIG_CPU_V6)
 #define tls_emu		0
 #define has_tls_reg		(elf_hwcap & HWCAP_TLS)
+#define get_tls2		get_tls2_v6
 #define set_tls		set_tls_v6
 #elif defined(CONFIG_CPU_32v6K)
 #define tls_emu		0
 #define has_tls_reg		1
+#define get_tls2		get_tls2_v6k
 #define set_tls		set_tls_v6k
 #else
 #define tls_emu		0
 #define has_tls_reg		0
+#define get_tls2		get_tls2_none
 #define set_tls		set_tls_software
 #endif
 
diff --git a/arch/arm/kernel/entry-armv.S b/arch/arm/kernel/entry-armv.S
index 0f82098..097686b 100644
--- a/arch/arm/kernel/entry-armv.S
+++ b/arch/arm/kernel/entry-armv.S
@@ -728,7 +728,7 @@ ENTRY(__switch_to)
  UNWIND(.fnstart	)
  UNWIND(.cantunwind	)
 	add	ip, r1, #TI_CPU_SAVE
-	ldr	r3, [r2, #TI_TP_VALUE]
+	add	r3, r1, #TI_TP_VALUE
  ARM(	stmia	ip!, {r4 - sl, fp, sp, lr} )	@ Store most regs on stack
  THUMB(	stmia	ip!, {r4 - sl, fp}	   )	@ Store most regs on stack
  THUMB(	str	sp, [ip], #4		   )
@@ -736,6 +736,8 @@ ENTRY(__switch_to)
 #ifdef CONFIG_CPU_USE_DOMAINS
 	ldr	r6, [r2, #TI_CPU_DOMAIN]
 #endif
+	get_tls2	r3, r4
+	add	r3, r2, #TI_TP_VALUE
 	set_tls	r3, r4, r5
 #if defined(CONFIG_CC_STACKPROTECTOR) && !defined(CONFIG_SMP)
 	ldr	r7, [r2, #TI_TASK]
diff --git a/arch/arm/kernel/process.c b/arch/arm/kernel/process.c
index 047d3e4..6138eb1 100644
--- a/arch/arm/kernel/process.c
+++ b/arch/arm/kernel/process.c
@@ -395,7 +395,8 @@ copy_thread(unsigned long clone_flags, unsigned long stack_start,
 	clear_ptrace_hw_breakpoint(p);
 
 	if (clone_flags & CLONE_SETTLS)
-		thread->tp_value = childregs->ARM_r3;
+		thread->tp_value[0] = childregs->ARM_r3;
+	thread->tp_value[1] = current_thread_info()->tp_value[1];
 
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

