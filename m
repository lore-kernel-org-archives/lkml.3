Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933817Ab3FRWXZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Jun 2013 18:23:25 -0400
Received: from moutng.kundenserver.de ([212.227.126.186]:56003 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932479Ab3FRWXW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Jun 2013 18:23:22 -0400
Message-ID: <51C0DDB9.6050508@dawncrow.de>
Date: Wed, 19 Jun 2013 00:22:49 +0200
From: =?ISO-8859-1?Q?Andr=E9_Hentschel?= <nerv@dawncrow.de>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: "linux-arch@vger.kernel.org" <linux-arch@vger.kernel.org>
CC: Russell King - ARM Linux <linux@arm.linux.org.uk>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        Will Deacon <will.deacon@arm.com>,
        Jonathan Austin <jonathan.austin@arm.com>
Subject: [PATCH v7] arm: Preserve the user r/w register TPIDRURW on context,
 switch and fork
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
X-Provags-ID: V02:K0:PlGe7DnQYcWe5GNpV06UUx+YpgGfMoJDKMDEOfmahnc
 NzH2NORbp5DHoR0KoMsqVrZMPSO84xffntnGbsq9HsvyHO4TEs
 7t1lccwQcKT0ymTPDYAlYtKFzfbvodsnQyb6xnauhPbIG0yEkZ
 H5VyaaU1J7hV4yY6WTeIODUVzcyfC6fNFDSBXXT2omHK89VYXm
 oxF39UdeJQdcAbKV/o/hTXR/9Y+2y0W1wTGLA+l+LTfBfxSFgF
 isAfGbWSuhehWsozdHBFvLwVHbXVNTVvpYMfDwGzVe5VsAGIDi
 g6MrYrhp8m178CMx2DjOhLqV1RdJ655apanDFD6x8RXX32I0bV
 /EiL37AoKTBXPLKvcwjg=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: André Hentschel <nerv@dawncrow.de>

Since commit 6a1c53124aa1 the user writeable TLS register was zeroed to
prevent it from being used as a covert channel between two tasks.

There are more and more applications coming to Windows RT,
Wine could support them, but mostly they expect to have
the thread environment block (TEB) in TPIDRURW.

This patch preserves that register per thread instead of clearing it.
Unlike the TPIDRURO, which is already switched, the TPIDRURW
can be updated from userspace so needs careful treatment in the case that we
modify TPIDRURW and call fork(). To avoid this we must always read
TPIDRURW in copy_thread.

Signed-off-by: André Hentschel <nerv@dawncrow.de>
Signed-off-by: Will Deacon <will.deacon@arm.com>
Signed-off-by: Jonathan Austin <jonathan.austin@arm.com> 

---
This patch is against Linux 3.10-rc6 (7d132055814ef17a6c7b69f342244c410a5e000f)

v2: rework and fixup of v1, based on a suggested patch by Will Deacon
v3: total rework and fixup of v2
v4: removed condition on assembler instruction,
    adapted my code to kernel-style, both based on comments by Will Deacon
v5: rebased v4 on 3.10-rc2 and adding this version history
v6: moved loading the TLS registers to the macros
    (fixing the "LDRD is not supported on all the CPUs we have" problem)
v7: this is based on v5 as suggested by Will Deacon and
    uses two ldr instructions instead of ldrd

i'll also send this to rmk's patchtracker for time reasons

Why so much Signed-off-bys? Some History:
The first patch had performance issues pointed out by Russel King,
so Will Deacon jumped in to help me with that. The second one again
had performance issues and the missing copy_thread part was uncovered.
After some iterations by me, Jonathan Austin proposed a patch and
Russel King sent his idea of the assembler part. All this was finally
merged and refined into this patch.
Thanks to everyone!


diff --git a/arch/arm/include/asm/thread_info.h b/arch/arm/include/asm/thread_info.h
index 1995d1a..214d415 100644
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
index 73409e6..83259b8 100644
--- a/arch/arm/include/asm/tls.h
+++ b/arch/arm/include/asm/tls.h
@@ -2,27 +2,30 @@
 #define __ASMARM_TLS_H
 
 #ifdef __ASSEMBLY__
-	.macro set_tls_none, tp, tmp1, tmp2
+#include <asm/asm-offsets.h>
+	.macro switch_tls_none, base, tp, tpuser, tmp1, tmp2
 	.endm
 
-	.macro set_tls_v6k, tp, tmp1, tmp2
+	.macro switch_tls_v6k, base, tp, tpuser, tmp1, tmp2
+	mrc	p15, 0, \tmp2, c13, c0, 2	@ get the user r/w register
 	mcr	p15, 0, \tp, c13, c0, 3		@ set TLS register
-	mov	\tmp1, #0
-	mcr	p15, 0, \tmp1, c13, c0, 2	@ clear user r/w TLS register
+	mcr	p15, 0, \tpuser, c13, c0, 2	@ and the user r/w register
+	str	\tmp2, [\base, #TI_TP_VALUE + 4] @ save it
 	.endm
 
-	.macro set_tls_v6, tp, tmp1, tmp2
+	.macro switch_tls_v6, base, tp, tpuser, tmp1, tmp2
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
+	mcrne	p15, 0, \tpuser, c13, c0, 2	@ set user r/w register
+	strne	\tmp2, [\base, #TI_TP_VALUE + 4] @ save it
 	.endm
 
-	.macro set_tls_software, tp, tmp1, tmp2
+	.macro switch_tls_software, base, tp, tpuser, tmp1, tmp2
 	mov	\tmp1, #0xffff0fff
 	str	\tp, [\tmp1, #-15]		@ set TLS value at 0xffff0ff0
 	.endm
@@ -31,19 +34,30 @@
 #ifdef CONFIG_TLS_REG_EMUL
 #define tls_emu		1
 #define has_tls_reg		1
-#define set_tls		set_tls_none
+#define switch_tls	switch_tls_none
 #elif defined(CONFIG_CPU_V6)
 #define tls_emu		0
 #define has_tls_reg		(elf_hwcap & HWCAP_TLS)
-#define set_tls		set_tls_v6
+#define switch_tls	switch_tls_v6
 #elif defined(CONFIG_CPU_32v6K)
 #define tls_emu		0
 #define has_tls_reg		1
-#define set_tls		set_tls_v6k
+#define switch_tls	switch_tls_v6k
 #else
 #define tls_emu		0
 #define has_tls_reg		0
-#define set_tls		set_tls_software
+#define switch_tls	switch_tls_software
 #endif
 
+#ifndef __ASSEMBLY__
+static inline unsigned long get_tpuser(void)
+{
+	unsigned long reg = 0;
+
+	if (has_tls_reg && !tls_emu)
+		__asm__("mrc p15, 0, %0, c13, c0, 2" : "=r" (reg));
+
+	return reg;
+}
+#endif
 #endif	/* __ASMARM_TLS_H */
diff --git a/arch/arm/kernel/entry-armv.S b/arch/arm/kernel/entry-armv.S
index 582b405..a39cfc2a1 100644
--- a/arch/arm/kernel/entry-armv.S
+++ b/arch/arm/kernel/entry-armv.S
@@ -685,15 +685,16 @@ ENTRY(__switch_to)
  UNWIND(.fnstart	)
  UNWIND(.cantunwind	)
 	add	ip, r1, #TI_CPU_SAVE
-	ldr	r3, [r2, #TI_TP_VALUE]
  ARM(	stmia	ip!, {r4 - sl, fp, sp, lr} )	@ Store most regs on stack
  THUMB(	stmia	ip!, {r4 - sl, fp}	   )	@ Store most regs on stack
  THUMB(	str	sp, [ip], #4		   )
  THUMB(	str	lr, [ip], #4		   )
+	ldr	r4, [r2, #TI_TP_VALUE]
+	ldr	r5, [r2, #TI_TP_VALUE + 4]
 #ifdef CONFIG_CPU_USE_DOMAINS
 	ldr	r6, [r2, #TI_CPU_DOMAIN]
 #endif
-	set_tls	r3, r4, r5
+	switch_tls r1, r4, r5, r3, r7
 #if defined(CONFIG_CC_STACKPROTECTOR) && !defined(CONFIG_SMP)
 	ldr	r7, [r2, #TI_TASK]
 	ldr	r8, =__stack_chk_guard
diff --git a/arch/arm/kernel/process.c b/arch/arm/kernel/process.c
index 282de48..a24110f 100644
--- a/arch/arm/kernel/process.c
+++ b/arch/arm/kernel/process.c
@@ -39,6 +39,7 @@
 #include <asm/thread_notify.h>
 #include <asm/stacktrace.h>
 #include <asm/mach/time.h>
+#include <asm/tls.h>
 
 #ifdef CONFIG_CC_STACKPROTECTOR
 #include <linux/stackprotector.h>
@@ -343,7 +344,8 @@ copy_thread(unsigned long clone_flags, unsigned long stack_start,
 	clear_ptrace_hw_breakpoint(p);
 
 	if (clone_flags & CLONE_SETTLS)
-		thread->tp_value = childregs->ARM_r3;
+		thread->tp_value[0] = childregs->ARM_r3;
+	thread->tp_value[1] = get_tpuser();
 
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
index 18b32e8..517bfd4 100644
--- a/arch/arm/kernel/traps.c
+++ b/arch/arm/kernel/traps.c
@@ -581,7 +581,7 @@ asmlinkage int arm_syscall(int no, struct pt_regs *regs)
 		return regs->ARM_r0;
 
 	case NR(set_tls):
-		thread->tp_value = regs->ARM_r0;
+		thread->tp_value[0] = regs->ARM_r0;
 		if (tls_emu)
 			return 0;
 		if (has_tls_reg) {
@@ -699,7 +699,7 @@ static int get_tp_trap(struct pt_regs *regs, unsigned int instr)
 	int reg = (instr >> 12) & 15;
 	if (reg == 15)
 		return 1;
-	regs->uregs[reg] = current_thread_info()->tp_value;
+	regs->uregs[reg] = current_thread_info()->tp_value[0];
 	regs->ARM_pc += 4;
 	return 0;
 }
-- 
1.8.1.2
--
To unsubscribe from this list: send the line "unsubscribe linux-arch" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
