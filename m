Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755766Ab3DSPy6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Apr 2013 11:54:58 -0400
Received: from moutng.kundenserver.de ([212.227.126.171]:51106 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751775Ab3DSPy4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Apr 2013 11:54:56 -0400
Message-ID: <517168BB.3070903@dawncrow.de>
Date: Fri, 19 Apr 2013 17:54:35 +0200
From: =?ISO-8859-15?Q?Andr=E9_Hentschel?= <nerv@dawncrow.de>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130329 Thunderbird/17.0.5
MIME-Version: 1.0
To: linux-arch@vger.kernel.org, will.deacon@arm.com
CC: linux@arm.linux.org.uk, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, gregkh@linuxfoundation.org
Subject: [PATCHv2] arm: Preserve TPIDRURW on context switch
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 8bit
X-Provags-ID: V02:K0:b7wc3kbffk5zx4NCnarDxY5InUp1jmjmO4RsHEux/nr
 eLMqJc93ftmCzEYm492YuyABqrdsUG/SjsGBfJf2EG4S5U2xeF
 Wp7MswPbIe7BLrkjvWQk/lVcgxrZGz3Wy1cxToNWJp138hCpLI
 4c3eoZ5ewPD7nF9riM4726itDV9zbs8haVcNaStC6v/NFRPGGB
 F/qFyX2M+UhEvmffuluQUIP1/xJ0/jFdgn0GvpRguZGmEOq8Ef
 bmnu2cUxDJTc662b5s1HphKYbFL+k80gXkdGelsQDrVMwGrR18
 lR73yuxG2Yc8PrZXKAw5jKhaNIiJfYI7NxM+3VJJUMKe/qqnbP
 4d9zkaIhzgThcbRY2O+g=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: =?UTF-8?q?Andr=C3=A9=20Hentschel?= <nerv@dawncrow.de>

There are more and more applications coming to WinRT, Wine could support them,
but mostly they expect to have the thread environment block (TEB) in TPIDRURW.
This register must be preserved per thread instead of being cleared.

Signed-off-by: André Hentschel <nerv@dawncrow.de>

---
This patch is against a86d52667d8eda5de39393ce737794403bdce1eb

I could only test it with kernel 3.4.6

 arch/arm/include/asm/thread_info.h |    2 +-
 arch/arm/include/asm/tls.h         |   32 +++++++++++++++++++-------------
 arch/arm/kernel/entry-armv.S       |    9 ++++-----
 arch/arm/kernel/process.c          |    2 +-
 arch/arm/kernel/ptrace.c           |    2 +-
 arch/arm/kernel/traps.c            |    4 ++--
 6 files changed, 28 insertions(+), 23 deletions(-)

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
index 73409e6..ea0189e 100644
--- a/arch/arm/include/asm/tls.h
+++ b/arch/arm/include/asm/tls.h
@@ -2,29 +2,35 @@
 #define __ASMARM_TLS_H
 
 #ifdef __ASSEMBLY__
-	.macro set_tls_none, tp, tmp1, tmp2
+	.macro set_tls_none, ntp, ptp, tmp1, tmp2
 	.endm
 
-	.macro set_tls_v6k, tp, tmp1, tmp2
-	mcr	p15, 0, \tp, c13, c0, 3		@ set TLS register
-	mov	\tmp1, #0
-	mcr	p15, 0, \tmp1, c13, c0, 2	@ clear user r/w TLS register
+	.macro set_tls_v6k, ntp, ptp, tmp1, tmp2
+	mrc	p15, 0, \tmp2, c13, c0, 2		@ get user r/w TLS register
+	str	\tmp2, [\ptp, #4]
+	ldrd	\tmp1, \tmp2, [\ntp]
+	mcr	p15, 0, \tmp1, c13, c0, 3	@ set user r/o TLS register
+	mcr	p15, 0, \tmp2, c13, c0, 2	@ set user r/w TLS register
 	.endm
 
-	.macro set_tls_v6, tp, tmp1, tmp2
+	.macro set_tls_v6, ntp, ptp, tmp1, tmp2
 	ldr	\tmp1, =elf_hwcap
 	ldr	\tmp1, [\tmp1, #0]
 	mov	\tmp2, #0xffff0fff
 	tst	\tmp1, #HWCAP_TLS		@ hardware TLS available?
-	mcrne	p15, 0, \tp, c13, c0, 3		@ yes, set TLS register
-	movne	\tmp1, #0
-	mcrne	p15, 0, \tmp1, c13, c0, 2	@ clear user r/w TLS register
-	streq	\tp, [\tmp2, #-15]		@ set TLS value at 0xffff0ff0
+	mrcne	p15, 0, \tmp2, c13, c0, 2		@ get user r/w TLS register
+	strne	\tmp2, [\ptp, #4]
+	ldrdne	\tmp1, \tmp2, [\ntp]
+	ldreq	\tmp1, [\ntp]
+	mcrne	p15, 0, \tmp1, c13, c0, 3	@ yes, set user r/o TLS register
+	mcrne	p15, 0, \tmp2, c13, c0, 2	@ set user r/w TLS register
+	streq	\tmp1, [\tmp2, #-15]		@ set TLS value at 0xffff0ff0
 	.endm
 
-	.macro set_tls_software, tp, tmp1, tmp2
-	mov	\tmp1, #0xffff0fff
-	str	\tp, [\tmp1, #-15]		@ set TLS value at 0xffff0ff0
+	.macro set_tls_software, ntp, ptp, tmp1, tmp2
+	ldr	\tmp1, [\ntp]
+	mov	\tmp2, #0xffff0fff
+	str	\tmp1, [\tmp2, #-15]		@ set TLS value at 0xffff0ff0
 	.endm
 #endif
 
diff --git a/arch/arm/kernel/entry-armv.S b/arch/arm/kernel/entry-armv.S
index 0f82098..78ce1c6 100644
--- a/arch/arm/kernel/entry-armv.S
+++ b/arch/arm/kernel/entry-armv.S
@@ -728,21 +728,20 @@ ENTRY(__switch_to)
  UNWIND(.fnstart	)
  UNWIND(.cantunwind	)
 	add	ip, r1, #TI_CPU_SAVE
-	ldr	r3, [r2, #TI_TP_VALUE]
  ARM(	stmia	ip!, {r4 - sl, fp, sp, lr} )	@ Store most regs on stack
  THUMB(	stmia	ip!, {r4 - sl, fp}	   )	@ Store most regs on stack
  THUMB(	str	sp, [ip], #4		   )
  THUMB(	str	lr, [ip], #4		   )
-#ifdef CONFIG_CPU_USE_DOMAINS
-	ldr	r6, [r2, #TI_CPU_DOMAIN]
-#endif
-	set_tls	r3, r4, r5
+	add	r3, r2, #TI_TP_VALUE
+	add	r4, r1, #TI_TP_VALUE
+	set_tls	r3, r4, r6, r7
 #if defined(CONFIG_CC_STACKPROTECTOR) && !defined(CONFIG_SMP)
 	ldr	r7, [r2, #TI_TASK]
 	ldr	r8, =__stack_chk_guard
 	ldr	r7, [r7, #TSK_STACK_CANARY]
 #endif
 #ifdef CONFIG_CPU_USE_DOMAINS
+	ldr	r6, [r2, #TI_CPU_DOMAIN]
 	mcr	p15, 0, r6, c3, c0, 0		@ Set domain register
 #endif
 	mov	r5, r0
diff --git a/arch/arm/kernel/process.c b/arch/arm/kernel/process.c
index 047d3e4..b3171c4 100644
--- a/arch/arm/kernel/process.c
+++ b/arch/arm/kernel/process.c
@@ -395,7 +395,7 @@ copy_thread(unsigned long clone_flags, unsigned long stack_start,
 	clear_ptrace_hw_breakpoint(p);
 
 	if (clone_flags & CLONE_SETTLS)
-		thread->tp_value = childregs->ARM_r3;
+		thread->tp_value[0] = childregs->ARM_r3;
 
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
-- 
1.7.10.4


