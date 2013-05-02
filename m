Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761986Ab3EBTyr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 May 2013 15:54:47 -0400
Received: from moutng.kundenserver.de ([212.227.17.9]:51733 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760842Ab3EBTyp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 May 2013 15:54:45 -0400
Message-ID: <5182C480.3080001@dawncrow.de>
Date: Thu, 02 May 2013 21:54:40 +0200
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
References: <517168BB.3070903@dawncrow.de> <20130422143616.GP14496@n2100.arm.linux.org.uk> <20130422151836.GA15665@mudshark.cambridge.arm.com> <5175A697.3080308@dawncrow.de> <20130423091536.GB17593@mudshark.cambridge.arm.com> <51770E4E.2040003@dawncrow.de> <20130424094251.GA21850@mudshark.cambridge.arm.com>
In-Reply-To: <20130424094251.GA21850@mudshark.cambridge.arm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
X-Provags-ID: V02:K0:gewfY/gK1oy8cLsLdpC37h+AK+bjd8bOYMDFVwSbAJM
 pu3npKXPZx2xpyzWXOK5XzC/65Ukf3m1k3GgW7EyOncFws3Def
 Ysj0QspgngqDhRikr5rG5wqIMRZDcfmBm8ib3n5GM89C4z91Fv
 6+A9f2Sn3nAJe0QAa/EVMnT83q04sF9Cw3lDrU4d77UMLbQ9m1
 2Dbxdy8e8PLDEg/4Nn2RlMlTylCGx5wpZFG2s524iesL+p3CXj
 +i2PTTgk8/KPTW7qWEtPYis9kn3uE62h9w7w9IkSNJ2+q4FHKC
 oS0IX8b4ri/brdVeXGABQs87PfACiC1Owwcuv6CYn9nUUmmeup
 GvZQxIxPkEXYP2wx1dbM=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am 24.04.2013 11:42, schrieb Will Deacon:
> Hi Andrew,
> 
> On Tue, Apr 23, 2013 at 11:42:22PM +0100, André Hentschel wrote:
>> Am 23.04.2013 11:15, schrieb Will Deacon:
>>> You could introduce `get' tls functions, which don't do anything for CPUs
>>> without the relevant registers.
>>
>> Before i have another round of testing and patch formatting/sending,
>> what about the untested patch below?
> 
> Ok. Comments inline.

I answered to that seperatly.
Here is another try based on your comments:



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
index 73409e6..02f8674 100644
--- a/arch/arm/include/asm/tls.h
+++ b/arch/arm/include/asm/tls.h
@@ -2,48 +2,87 @@
 #define __ASMARM_TLS_H
 
 #ifdef __ASSEMBLY__
+	.macro check_hwcap_tls, tmp1
+	ldr	\tmp1, =elf_hwcap
+	ldr	\tmp1, [\tmp1, #0]
+	tst	\tmp1, #HWCAP_TLS		@ hardware TLS available?
+	.endm
+
+
+	.macro get_tls_none, tp, tmp1
+	.endm
+
+	.macro get_tls_v6k, tp, tmp1
+	mrc	p15, 0, \tmp1, c13, c0, 2		@ get user r/w TLS register
+	str	\tmp1, [\tp, #4]
+	.endm
+
+	.macro get_tls_v6, tp, tmp1
+	check_hwcap_tls \tmp1
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
-	ldr	\tmp1, =elf_hwcap
-	ldr	\tmp1, [\tmp1, #0]
 	mov	\tmp2, #0xffff0fff
-	tst	\tmp1, #HWCAP_TLS		@ hardware TLS available?
-	mcrne	p15, 0, \tp, c13, c0, 3		@ yes, set TLS register
-	movne	\tmp1, #0
-	mcrne	p15, 0, \tmp1, c13, c0, 2	@ clear user r/w TLS register
-	streq	\tp, [\tmp2, #-15]		@ set TLS value at 0xffff0ff0
+	check_hwcap_tls \tmp1
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
+#define get_tls		get_tls_none
 #define set_tls		set_tls_none
 #elif defined(CONFIG_CPU_V6)
 #define tls_emu		0
 #define has_tls_reg		(elf_hwcap & HWCAP_TLS)
+#define get_tls		get_tls_v6
 #define set_tls		set_tls_v6
 #elif defined(CONFIG_CPU_32v6K)
 #define tls_emu		0
 #define has_tls_reg		1
+#define get_tls		get_tls_v6k
 #define set_tls		set_tls_v6k
 #else
 #define tls_emu		0
 #define has_tls_reg		0
+#define get_tls		get_tls_none
 #define set_tls		set_tls_software
 #endif
 
+#ifndef __ASSEMBLY__
+static inline void get_tpidrurw(unsigned long *tpidrurw)
+{
+	unsigned long t;
+#ifdef CONFIG_TLS_REG_EMUL
+	return;
+#endif
+	if (!has_tls_reg) return;
+	__asm__("mcr p15, 0, %0, c13, c0, 2" : : "r" (t));
+	*tpidrurw = t;
+}
+#endif
+
 #endif	/* __ASMARM_TLS_H */
diff --git a/arch/arm/kernel/entry-armv.S b/arch/arm/kernel/entry-armv.S
index 0f82098..2c892b2 100644
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
+	get_tls	r3, r4
+	add	r3, r2, #TI_TP_VALUE
 	set_tls	r3, r4, r5
 #if defined(CONFIG_CC_STACKPROTECTOR) && !defined(CONFIG_SMP)
 	ldr	r7, [r2, #TI_TASK]
diff --git a/arch/arm/kernel/process.c b/arch/arm/kernel/process.c
index 047d3e4..a13bbc8 100644
--- a/arch/arm/kernel/process.c
+++ b/arch/arm/kernel/process.c
@@ -36,6 +36,7 @@
 #include <asm/cacheflush.h>
 #include <asm/idmap.h>
 #include <asm/processor.h>
+#include <asm/tls.h>
 #include <asm/thread_notify.h>
 #include <asm/stacktrace.h>
 #include <asm/mach/time.h>
@@ -395,7 +396,10 @@ copy_thread(unsigned long clone_flags, unsigned long stack_start,
 	clear_ptrace_hw_breakpoint(p);
 
 	if (clone_flags & CLONE_SETTLS)
-		thread->tp_value = childregs->ARM_r3;
+	{
+		thread->tp_value[0] = childregs->ARM_r3;
+		get_tpidrurw(&thread->tp_value[1]);
+	}
 
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

