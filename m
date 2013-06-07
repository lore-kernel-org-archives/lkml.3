Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161022Ab3FGXN7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Jun 2013 19:13:59 -0400
Received: from mail-ie0-f176.google.com ([209.85.223.176]:50967 "EHLO
	mail-ie0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756177Ab3FGXDq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Jun 2013 19:03:46 -0400
From: David Daney <ddaney.cavm@gmail.com>
To: linux-mips@linux-mips.org, ralf@linux-mips.org, kvm@vger.kernel.org,
        Sanjay Lal <sanjayl@kymasys.com>
Cc: linux-kernel@vger.kernel.org, David Daney <david.daney@cavium.com>
Subject: [PATCH 02/31] MIPS: Save and restore K0/K1 when CONFIG_KVM_MIPSVZ
Date: Fri,  7 Jun 2013 16:03:06 -0700
Message-Id: <1370646215-6543-3-git-send-email-ddaney.cavm@gmail.com>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1370646215-6543-1-git-send-email-ddaney.cavm@gmail.com>
References: <1370646215-6543-1-git-send-email-ddaney.cavm@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: David Daney <david.daney@cavium.com>

We cannot clobber any registers on exceptions as any guest will need
them all.

Signed-off-by: David Daney <david.daney@cavium.com>
---
 arch/mips/include/asm/mipsregs.h   |  2 ++
 arch/mips/include/asm/stackframe.h | 15 +++++++++++++++
 arch/mips/kernel/cpu-probe.c       |  7 ++++++-
 arch/mips/kernel/genex.S           |  5 +++++
 arch/mips/kernel/scall64-64.S      | 12 ++++++++++++
 arch/mips/kernel/scall64-n32.S     | 12 ++++++++++++
 arch/mips/kernel/traps.c           |  5 +++++
 arch/mips/mm/tlbex.c               | 25 +++++++++++++++++++++++++
 8 files changed, 82 insertions(+), 1 deletion(-)

diff --git a/arch/mips/include/asm/mipsregs.h b/arch/mips/include/asm/mipsregs.h
index 6e0da5aa..6f03c72 100644
--- a/arch/mips/include/asm/mipsregs.h
+++ b/arch/mips/include/asm/mipsregs.h
@@ -73,6 +73,8 @@
 #define CP0_TAGHI $29
 #define CP0_ERROREPC $30
 #define CP0_DESAVE $31
+#define CP0_KSCRATCH1 $31, 2
+#define CP0_KSCRATCH2 $31, 3
 
 /*
  * R4640/R4650 cp0 register names.  These registers are listed
diff --git a/arch/mips/include/asm/stackframe.h b/arch/mips/include/asm/stackframe.h
index a89d1b1..20627b2 100644
--- a/arch/mips/include/asm/stackframe.h
+++ b/arch/mips/include/asm/stackframe.h
@@ -181,6 +181,16 @@
 #endif
 		LONG_S	k0, PT_R29(sp)
 		LONG_S	$3, PT_R3(sp)
+#ifdef CONFIG_KVM_MIPSVZ
+		/*
+		 * With KVM_MIPSVZ, we must not clobber k0/k1
+		 * they were saved before they were used
+		 */
+		MFC0	k0, CP0_KSCRATCH1
+		MFC0	$3, CP0_KSCRATCH2
+		LONG_S	k0, PT_R26(sp)
+		LONG_S	$3, PT_R27(sp)
+#endif
 		/*
 		 * You might think that you don't need to save $0,
 		 * but the FPU emulator and gdb remote debug stub
@@ -447,6 +457,11 @@
 		.endm
 
 		.macro	RESTORE_SP_AND_RET
+
+#ifdef CONFIG_KVM_MIPSVZ
+		LONG_L	k0, PT_R26(sp)
+		LONG_L	k1, PT_R27(sp)
+#endif
 		LONG_L	sp, PT_R29(sp)
 		.set	mips3
 		eret
diff --git a/arch/mips/kernel/cpu-probe.c b/arch/mips/kernel/cpu-probe.c
index ee1014e..7a07edb 100644
--- a/arch/mips/kernel/cpu-probe.c
+++ b/arch/mips/kernel/cpu-probe.c
@@ -1067,7 +1067,12 @@ __cpuinit void cpu_report(void)
 
 static DEFINE_SPINLOCK(kscratch_used_lock);
 
-static unsigned int kscratch_used_mask;
+static unsigned int kscratch_used_mask
+#ifdef CONFIG_KVM_MIPSVZ
+/* KVM_MIPSVZ implemtation uses these two statically. */
+= 0xc
+#endif
+;
 
 int allocate_kscratch(void)
 {
diff --git a/arch/mips/kernel/genex.S b/arch/mips/kernel/genex.S
index 31fa856..163e299 100644
--- a/arch/mips/kernel/genex.S
+++ b/arch/mips/kernel/genex.S
@@ -46,6 +46,11 @@
 NESTED(except_vec3_generic, 0, sp)
 	.set	push
 	.set	noat
+#ifdef CONFIG_KVM_MIPSVZ
+		/* With KVM_MIPSVZ, we must not clobber k0/k1 */
+	MTC0	k0, CP0_KSCRATCH1
+	MTC0	k1, CP0_KSCRATCH2
+#endif
 #if R5432_CP0_INTERRUPT_WAR
 	mfc0	k0, CP0_INDEX
 #endif
diff --git a/arch/mips/kernel/scall64-64.S b/arch/mips/kernel/scall64-64.S
index 97a5909..5ff4882 100644
--- a/arch/mips/kernel/scall64-64.S
+++ b/arch/mips/kernel/scall64-64.S
@@ -62,6 +62,9 @@ NESTED(handle_sys64, PT_SIZE, sp)
 	jalr	t2			# Do The Real Thing (TM)
 
 	li	t0, -EMAXERRNO - 1	# error?
+#if defined(CONFIG_KVM_MIPSVZ) && defined(CONFIG_FAST_ACCESS_TO_THREAD_POINTER)
+	ld	t2, TI_TP_VALUE($28)
+#endif
 	sltu	t0, t0, v0
 	sd	t0, PT_R7(sp)		# set error flag
 	beqz	t0, 1f
@@ -70,6 +73,9 @@ NESTED(handle_sys64, PT_SIZE, sp)
 	dnegu	v0			# error
 	sd	t1, PT_R0(sp)		# save it for syscall restarting
 1:	sd	v0, PT_R2(sp)		# result
+#if defined(CONFIG_KVM_MIPSVZ) && defined(CONFIG_FAST_ACCESS_TO_THREAD_POINTER)
+	sd	t2, PT_R26(sp)
+#endif
 
 n64_syscall_exit:
 	j	syscall_exit_partial
@@ -93,6 +99,9 @@ syscall_trace_entry:
 	jalr	t0
 
 	li	t0, -EMAXERRNO - 1	# error?
+#if defined(CONFIG_KVM_MIPSVZ) && defined(CONFIG_FAST_ACCESS_TO_THREAD_POINTER)
+	ld	t2, TI_TP_VALUE($28)
+#endif
 	sltu	t0, t0, v0
 	sd	t0, PT_R7(sp)		# set error flag
 	beqz	t0, 1f
@@ -101,6 +110,9 @@ syscall_trace_entry:
 	dnegu	v0			# error
 	sd	t1, PT_R0(sp)		# save it for syscall restarting
 1:	sd	v0, PT_R2(sp)		# result
+#if defined(CONFIG_KVM_MIPSVZ) && defined(CONFIG_FAST_ACCESS_TO_THREAD_POINTER)
+	sd	t2, PT_R26(sp)
+#endif
 
 	j	syscall_exit
 
diff --git a/arch/mips/kernel/scall64-n32.S b/arch/mips/kernel/scall64-n32.S
index edcb659..cba35b4 100644
--- a/arch/mips/kernel/scall64-n32.S
+++ b/arch/mips/kernel/scall64-n32.S
@@ -55,6 +55,9 @@ NESTED(handle_sysn32, PT_SIZE, sp)
 	jalr	t2			# Do The Real Thing (TM)
 
 	li	t0, -EMAXERRNO - 1	# error?
+#if defined(CONFIG_KVM_MIPSVZ) && defined(CONFIG_FAST_ACCESS_TO_THREAD_POINTER)
+	ld	t2, TI_TP_VALUE($28)
+#endif
 	sltu	t0, t0, v0
 	sd	t0, PT_R7(sp)		# set error flag
 	beqz	t0, 1f
@@ -63,6 +66,9 @@ NESTED(handle_sysn32, PT_SIZE, sp)
 	dnegu	v0			# error
 	sd	t1, PT_R0(sp)		# save it for syscall restarting
 1:	sd	v0, PT_R2(sp)		# result
+#if defined(CONFIG_KVM_MIPSVZ) && defined(CONFIG_FAST_ACCESS_TO_THREAD_POINTER)
+	sd	t2, PT_R26(sp)
+#endif
 
 	j	syscall_exit_partial
 
@@ -85,6 +91,9 @@ n32_syscall_trace_entry:
 	jalr	t0
 
 	li	t0, -EMAXERRNO - 1	# error?
+#if defined(CONFIG_KVM_MIPSVZ) && defined(CONFIG_FAST_ACCESS_TO_THREAD_POINTER)
+	ld	t2, TI_TP_VALUE($28)
+#endif
 	sltu	t0, t0, v0
 	sd	t0, PT_R7(sp)		# set error flag
 	beqz	t0, 1f
@@ -93,6 +102,9 @@ n32_syscall_trace_entry:
 	dnegu	v0			# error
 	sd	t1, PT_R0(sp)		# save it for syscall restarting
 1:	sd	v0, PT_R2(sp)		# result
+#if defined(CONFIG_KVM_MIPSVZ) && defined(CONFIG_FAST_ACCESS_TO_THREAD_POINTER)
+	sd	t2, PT_R26(sp)
+#endif
 
 	j	syscall_exit
 
diff --git a/arch/mips/kernel/traps.c b/arch/mips/kernel/traps.c
index e3be670..f008795 100644
--- a/arch/mips/kernel/traps.c
+++ b/arch/mips/kernel/traps.c
@@ -1483,6 +1483,11 @@ void __init *set_except_vector(int n, void *addr)
 #endif
 		u32 *buf = (u32 *)(ebase + 0x200);
 		unsigned int k0 = 26;
+#ifdef CONFIG_KVM_MIPSVZ
+		unsigned int k1 = 27;
+		UASM_i_MTC0(&buf, k0, 31, 2);
+		UASM_i_MTC0(&buf, k1, 31, 3);
+#endif
 		if ((handler & jump_mask) == ((ebase + 0x200) & jump_mask)) {
 			uasm_i_j(&buf, handler & ~jump_mask);
 			uasm_i_nop(&buf);
diff --git a/arch/mips/mm/tlbex.c b/arch/mips/mm/tlbex.c
index 001b87c..3ce7208 100644
--- a/arch/mips/mm/tlbex.c
+++ b/arch/mips/mm/tlbex.c
@@ -372,11 +372,19 @@ static void __cpuinit build_restore_work_registers(u32 **p)
 {
 	if (scratch_reg > 0) {
 		UASM_i_MFC0(p, 1, 31, scratch_reg);
+#ifdef CONFIG_KVM_MIPSVZ
+		UASM_i_MFC0(p, K0, 31, 2);
+		UASM_i_MFC0(p, K1, 31, 3);
+#endif
 		return;
 	}
 	/* K0 already points to save area, restore $1 and $2  */
 	UASM_i_LW(p, 1, offsetof(struct tlb_reg_save, a), K0);
 	UASM_i_LW(p, 2, offsetof(struct tlb_reg_save, b), K0);
+#ifdef CONFIG_KVM_MIPSVZ
+	UASM_i_MFC0(p, K0, 31, 2);
+	UASM_i_MFC0(p, K1, 31, 3);
+#endif
 }
 
 #ifndef CONFIG_MIPS_PGD_C0_CONTEXT
@@ -1089,6 +1097,11 @@ build_fast_tlb_refill_handler (u32 **p, struct uasm_label **l,
 	int vmalloc_branch_delay_filled = 0;
 	const int scratch = 1; /* Our extra working register */
 
+#ifdef CONFIG_KVM_MIPSVZ
+	UASM_i_MTC0(p, K0, 31, 2);
+	UASM_i_MTC0(p, K1, 31, 3);
+#endif
+
 	rv.huge_pte = scratch;
 	rv.restore_scratch = 0;
 
@@ -1244,6 +1257,10 @@ build_fast_tlb_refill_handler (u32 **p, struct uasm_label **l,
 		rv.restore_scratch = 1;
 	}
 
+#ifdef CONFIG_KVM_MIPSVZ
+	UASM_i_MFC0(p, K0, 31, 2);
+	UASM_i_MFC0(p, K1, 31, 3);
+#endif
 	uasm_i_eret(p); /* return from trap */
 
 	return rv;
@@ -1277,6 +1294,10 @@ static void __cpuinit build_r4000_tlb_refill_handler(void)
 							  scratch_reg);
 		vmalloc_mode = refill_scratch;
 	} else {
+#ifdef CONFIG_KVM_MIPSVZ
+		UASM_i_MTC0(&p, K0, 31, 2);
+		UASM_i_MTC0(&p, K1, 31, 3);
+#endif
 		htlb_info.huge_pte = K0;
 		htlb_info.restore_scratch = 0;
 		vmalloc_mode = refill_noscratch;
@@ -1311,6 +1332,10 @@ static void __cpuinit build_r4000_tlb_refill_handler(void)
 		build_update_entries(&p, K0, K1);
 		build_tlb_write_entry(&p, &l, &r, tlb_random);
 		uasm_l_leave(&l, p);
+#ifdef CONFIG_KVM_MIPSVZ
+		UASM_i_MFC0(&p, K0, 31, 2);
+		UASM_i_MFC0(&p, K1, 31, 3);
+#endif
 		uasm_i_eret(&p); /* return from trap */
 	}
 #ifdef CONFIG_MIPS_HUGE_TLB_SUPPORT
-- 
1.7.11.7

