Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932110AbaDBHFm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Apr 2014 03:05:42 -0400
Received: from e23smtp07.au.ibm.com ([202.81.31.140]:43784 "EHLO
	e23smtp07.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757929AbaDBHFl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Apr 2014 03:05:41 -0400
From: Anshuman Khandual <khandual@linux.vnet.ibm.com>
To: linuxppc-dev@ozlabs.org, linux-kernel@vger.kernel.org
Cc: avagin@openvz.org, oleg@redhat.com, roland@redhat.com, mikey@neuling.org,
        benh@kernel.crashing.org,
        Anshuman Khandual <khandual@linux.vnet.ibm.com>
Subject: [PATCH 2/3] powerpc, ptrace: Add new ptrace request macros for transactional memory
Date: Wed,  2 Apr 2014 12:32:23 +0530
Message-Id: <1396422144-11032-3-git-send-email-khandual@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1396422144-11032-1-git-send-email-khandual@linux.vnet.ibm.com>
References: <1396422144-11032-1-git-send-email-khandual@linux.vnet.ibm.com>
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14040207-0260-0000-0000-000004A1861B
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds following new sets of ptrace request macros for transactional
memory expanding the existing ptrace ABI on PowerPC.

	/* TM special purpose registers */
	PTRACE_GETTM_SPRREGS
	PTRACE_SETTM_SPRREGS

	/* TM checkpointed GPR registers */
	PTRACE_GETTM_CGPRREGS
	PTRACE_SETTM_CGPRREGS

	/* TM checkpointed FPR registers */
	PTRACE_GETTM_CFPRREGS
	PTRACE_SETTM_CFPRREGS

	/* TM checkpointed VMX registers */
	PTRACE_GETTM_CVMXREGS
	PTRACE_SETTM_CVMXREGS

Signed-off-by: Anshuman Khandual <khandual@linux.vnet.ibm.com>
---
 arch/powerpc/include/asm/switch_to.h   |   8 +
 arch/powerpc/include/uapi/asm/ptrace.h |  51 +++
 arch/powerpc/kernel/process.c          |  24 ++
 arch/powerpc/kernel/ptrace.c           | 570 +++++++++++++++++++++++++++++++--
 4 files changed, 625 insertions(+), 28 deletions(-)

diff --git a/arch/powerpc/include/asm/switch_to.h b/arch/powerpc/include/asm/switch_to.h
index 0e83e7d..22095e2 100644
--- a/arch/powerpc/include/asm/switch_to.h
+++ b/arch/powerpc/include/asm/switch_to.h
@@ -80,6 +80,14 @@ static inline void flush_spe_to_thread(struct task_struct *t)
 }
 #endif
 
+#ifdef CONFIG_PPC_TRANSACTIONAL_MEM
+extern void flush_tmreg_to_thread(struct task_struct *);
+#else
+static inline void flush_tmreg_to_thread(struct task_struct *t)
+{
+}
+#endif /* CONFIG_PPC_TRANSACTIONAL_MEM */
+
 static inline void clear_task_ebb(struct task_struct *t)
 {
 #ifdef CONFIG_PPC_BOOK3S_64
diff --git a/arch/powerpc/include/uapi/asm/ptrace.h b/arch/powerpc/include/uapi/asm/ptrace.h
index 77d2ed3..1a12c36 100644
--- a/arch/powerpc/include/uapi/asm/ptrace.h
+++ b/arch/powerpc/include/uapi/asm/ptrace.h
@@ -190,6 +190,57 @@ struct pt_regs {
 #define PPC_PTRACE_SETHWDEBUG	0x88
 #define PPC_PTRACE_DELHWDEBUG	0x87
 
+/* Transactional memory */
+
+/*
+ * TM specific SPR
+ *
+ * struct data {
+ * 	u64		tm_tfhar;
+ *	u64		tm_texasr;
+ *	u64		tm_tfiar;
+ *	unsigned long   tm_orig_msr;
+ *	u64		tm_tar;
+ *	u64		tm_ppr;
+ *	u64		tm_dscr;
+ * };
+ */
+#define PTRACE_GETTM_SPRREGS	0x70
+#define PTRACE_SETTM_SPRREGS	0x71
+
+/*
+ * TM Checkpointed GPR
+ *
+ * struct data {
+ *	struct pt_regs	ckpt_regs;
+ * };
+ */
+#define PTRACE_GETTM_CGPRREGS	0x72
+#define PTRACE_SETTM_CGPRREGS	0x73
+
+/*
+ * TM Checkpointed FPR
+ *
+ * struct data {
+ * 	u64	fpr[32];
+ * 	u64	fpscr;
+ * };
+ */
+#define PTRACE_GETTM_CFPRREGS	0x74
+#define PTRACE_SETTM_CFPRREGS	0x75
+
+/*
+ * TM Checkpointed VMX
+ *
+ * struct data {
+ *	vector128	vr[32];
+ *	vector128	vscr;
+ *	unsigned long	vrsave;
+ *};
+ */
+#define PTRACE_GETTM_CVMXREGS	0x76
+#define PTRACE_SETTM_CVMXREGS	0x77
+
 #ifndef __ASSEMBLY__
 
 struct ppc_debug_info {
diff --git a/arch/powerpc/kernel/process.c b/arch/powerpc/kernel/process.c
index af064d2..230a0ee 100644
--- a/arch/powerpc/kernel/process.c
+++ b/arch/powerpc/kernel/process.c
@@ -673,6 +673,30 @@ static inline void __switch_to_tm(struct task_struct *prev)
 	}
 }
 
+void flush_tmreg_to_thread(struct task_struct *tsk)
+{
+	/*
+ 	 * If task is not current, it should have been flushed
+ 	 * already to it's thread_struct during __switch_to().
+ 	 */
+	if (tsk != current)
+		return;
+
+	preempt_disable();
+	if (tsk->thread.regs) {
+		/*
+ 		 * If we are still current, the TM state need to
+ 		 * be flushed to thread_struct as it will be still
+ 		 * present in the current cpu
+ 		 */
+		if (MSR_TM_ACTIVE(tsk->thread.regs->msr)) {
+			__switch_to_tm(tsk);
+			tm_recheckpoint_new_task(tsk);
+		}
+	}
+	preempt_enable();
+}
+
 /*
  * This is called if we are on the way out to userspace and the
  * TIF_RESTORE_TM flag is set.  It checks if we need to reload
diff --git a/arch/powerpc/kernel/ptrace.c b/arch/powerpc/kernel/ptrace.c
index 2e3d2bf..9fbcb6a 100644
--- a/arch/powerpc/kernel/ptrace.c
+++ b/arch/powerpc/kernel/ptrace.c
@@ -357,6 +357,17 @@ static int gpr_set(struct task_struct *target, const struct user_regset *regset,
 	return ret;
 }
 
+/*
+ * When any transaction is active, "thread_struct->transact_fp" holds
+ * the current running value of all FPR registers and "thread_struct->
+ * fp_state" holds the last checkpointed FPR registers state for the
+ * current transaction.
+ *
+ * struct data {
+ * 	u64	fpr[32];
+ * 	u64	fpscr;
+ * };
+ */
 static int fpr_get(struct task_struct *target, const struct user_regset *regset,
 		   unsigned int pos, unsigned int count,
 		   void *kbuf, void __user *ubuf)
@@ -365,21 +376,41 @@ static int fpr_get(struct task_struct *target, const struct user_regset *regset,
 	u64 buf[33];
 	int i;
 #endif
-	flush_fp_to_thread(target);
+	if (MSR_TM_ACTIVE(target->thread.regs->msr)) {
+		flush_fp_to_thread(target);
+		flush_altivec_to_thread(target);
+		flush_tmreg_to_thread(target);
+	} else {
+		flush_fp_to_thread(target);
+	}
 
 #ifdef CONFIG_VSX
 	/* copy to local buffer then write that out */
-	for (i = 0; i < 32 ; i++)
-		buf[i] = target->thread.TS_FPR(i);
-	buf[32] = target->thread.fp_state.fpscr;
+	if (MSR_TM_ACTIVE(target->thread.regs->msr)) {
+		for (i = 0; i < 32 ; i++)
+			buf[i] = target->thread.TS_TRANS_FPR(i);
+		buf[32] = target->thread.transact_fp.fpscr;
+	} else {
+		for (i = 0; i < 32 ; i++)
+			buf[i] = target->thread.TS_FPR(i);
+		buf[32] = target->thread.fp_state.fpscr;
+	}
 	return user_regset_copyout(&pos, &count, &kbuf, &ubuf, buf, 0, -1);
 
 #else
-	BUILD_BUG_ON(offsetof(struct thread_fp_state, fpscr) !=
-		     offsetof(struct thread_fp_state, fpr[32][0]));
+	if (MSR_TM_ACTIVE(tsk->thread.regs->msr)) {
+		BUILD_BUG_ON(offsetof(struct transact_fp, fpscr) !=
+				offsetof(struct transact_fp, fpr[32][0]));
 
-	return user_regset_copyout(&pos, &count, &kbuf, &ubuf,
+		return user_regset_copyout(&pos, &count, &kbuf, &ubuf,
+				   &target->thread.transact_fp, 0, -1);
+	} esle {
+		BUILD_BUG_ON(offsetof(struct thread_fp_state, fpscr) !=
+			     offsetof(struct thread_fp_state, fpr[32][0]));
+
+		return user_regset_copyout(&pos, &count, &kbuf, &ubuf,
 				   &target->thread.fp_state, 0, -1);
+	}
 #endif
 }
 
@@ -391,23 +422,44 @@ static int fpr_set(struct task_struct *target, const struct user_regset *regset,
 	u64 buf[33];
 	int i;
 #endif
-	flush_fp_to_thread(target);
+	if (MSR_TM_ACTIVE(target->thread.regs->msr)) {
+		flush_fp_to_thread(target);
+		flush_altivec_to_thread(target);
+		flush_tmreg_to_thread(target);
+	} else {
+		flush_fp_to_thread(target);
+	}
 
 #ifdef CONFIG_VSX
 	/* copy to local buffer then write that out */
 	i = user_regset_copyin(&pos, &count, &kbuf, &ubuf, buf, 0, -1);
 	if (i)
 		return i;
-	for (i = 0; i < 32 ; i++)
-		target->thread.TS_FPR(i) = buf[i];
-	target->thread.fp_state.fpscr = buf[32];
+	for (i = 0; i < 32 ; i++) {
+		if (MSR_TM_ACTIVE(target->thread.regs->msr))
+			target->thread.TS_TRANS_FPR(i) = buf[i];
+		else
+			target->thread.TS_FPR(i) = buf[i];
+	}
+	if (MSR_TM_ACTIVE(target->thread.regs->msr))
+		target->thread.transact_fp.fpscr = buf[32];
+	else
+		target->thread.fp_state.fpscr = buf[32];
 	return 0;
 #else
-	BUILD_BUG_ON(offsetof(struct thread_fp_state, fpscr) !=
-		     offsetof(struct thread_fp_state, fpr[32][0]));
+	if (MSR_TM_ACTIVE(target->thread.regs->msr)) {
+		BUILD_BUG_ON(offsetof(struct transact_fp, fpscr) !=
+			     offsetof(struct transact_fp, fpr[32][0]));
 
-	return user_regset_copyin(&pos, &count, &kbuf, &ubuf,
-				  &target->thread.fp_state, 0, -1);
+		return user_regset_copyin(&pos, &count, &kbuf, &ubuf,
+					  &target->thread.transact_fp, 0, -1);
+	} else {
+		BUILD_BUG_ON(offsetof(struct thread_fp_state, fpscr) !=
+			     offsetof(struct thread_fp_state, fpr[32][0]));
+
+		return user_regset_copyin(&pos, &count, &kbuf, &ubuf,
+				&target->thread.fp_state, 0, -1);
+	}
 #endif
 }
 
@@ -432,20 +484,44 @@ static int vr_active(struct task_struct *target,
 	return target->thread.used_vr ? regset->n : 0;
 }
 
+/*
+ * When any transaction is active, "thread_struct->transact_vr" holds
+ * the current running value of all VMX registers and "thread_struct->
+ * vr_state" holds the last checkpointed value of VMX registers for the
+ * current transaction.
+ *
+ * struct data {
+ * 	vector128	vr[32];
+ * 	vector128	vscr;
+ * 	vector128	vrsave;
+ * };
+ */
 static int vr_get(struct task_struct *target, const struct user_regset *regset,
 		  unsigned int pos, unsigned int count,
 		  void *kbuf, void __user *ubuf)
 {
 	int ret;
+	struct thread_vr_state *addr;
 
-	flush_altivec_to_thread(target);
+	if (MSR_TM_ACTIVE(target->thread.regs->msr)) {
+		flush_fp_to_thread(target);
+		flush_altivec_to_thread(target);
+		flush_tmreg_to_thread(target);
+	} else {
+		flush_altivec_to_thread(target);
+	}
 
 	BUILD_BUG_ON(offsetof(struct thread_vr_state, vscr) !=
 		     offsetof(struct thread_vr_state, vr[32]));
 
+	if (MSR_TM_ACTIVE(target->thread.regs->msr))
+		addr = &target->thread.transact_vr;
+	else
+		addr = &target->thread.vr_state;
+
 	ret = user_regset_copyout(&pos, &count, &kbuf, &ubuf,
-				  &target->thread.vr_state, 0,
-				  33 * sizeof(vector128));
+				addr, 0, 33 * sizeof(vector128));
+
 	if (!ret) {
 		/*
 		 * Copy out only the low-order word of vrsave.
@@ -455,11 +531,14 @@ static int vr_get(struct task_struct *target, const struct user_regset *regset,
 			u32 word;
 		} vrsave;
 		memset(&vrsave, 0, sizeof(vrsave));
-		vrsave.word = target->thread.vrsave;
+		if (MSR_TM_ACTIVE(target->thread.regs->msr))
+			vrsave.word = target->thread.transact_vrsave;
+		else
+			vrsave.word = target->thread.vrsave;
+
 		ret = user_regset_copyout(&pos, &count, &kbuf, &ubuf, &vrsave,
 					  33 * sizeof(vector128), -1);
 	}
-
 	return ret;
 }
 
@@ -467,16 +546,27 @@ static int vr_set(struct task_struct *target, const struct user_regset *regset,
 		  unsigned int pos, unsigned int count,
 		  const void *kbuf, const void __user *ubuf)
 {
+	struct thread_vr_state *addr;
 	int ret;
 
-	flush_altivec_to_thread(target);
+	if (MSR_TM_ACTIVE(target->thread.regs->msr)) {
+		flush_fp_to_thread(target);
+		flush_altivec_to_thread(target);
+		flush_tmreg_to_thread(target);
+	} else {
+		flush_altivec_to_thread(target);
+	}
 
 	BUILD_BUG_ON(offsetof(struct thread_vr_state, vscr) !=
 		     offsetof(struct thread_vr_state, vr[32]));
 
+	if (MSR_TM_ACTIVE(target->thread.regs->msr))
+		addr = &target->thread.transact_vr;
+	else
+		addr = &target->thread.vr_state;
 	ret = user_regset_copyin(&pos, &count, &kbuf, &ubuf,
-				 &target->thread.vr_state, 0,
-				 33 * sizeof(vector128));
+			addr, 0, 33 * sizeof(vector128));
+
 	if (!ret && count > 0) {
 		/*
 		 * We use only the first word of vrsave.
@@ -486,13 +576,21 @@ static int vr_set(struct task_struct *target, const struct user_regset *regset,
 			u32 word;
 		} vrsave;
 		memset(&vrsave, 0, sizeof(vrsave));
-		vrsave.word = target->thread.vrsave;
+
+		if (MSR_TM_ACTIVE(target->thread.regs->msr))
+			vrsave.word = target->thread.transact_vrsave;
+		else
+			vrsave.word = target->thread.vrsave;
+
 		ret = user_regset_copyin(&pos, &count, &kbuf, &ubuf, &vrsave,
 					 33 * sizeof(vector128), -1);
-		if (!ret)
-			target->thread.vrsave = vrsave.word;
+		if (!ret) {
+			if (MSR_TM_ACTIVE(target->thread.regs->msr))
+				target->thread.transact_vrsave = vrsave.word;
+			else
+				target->thread.vrsave = vrsave.word;
+		}
 	}
-
 	return ret;
 }
 #endif /* CONFIG_ALTIVEC */
@@ -613,6 +711,347 @@ static int evr_set(struct task_struct *target, const struct user_regset *regset,
 }
 #endif /* CONFIG_SPE */
 
+#ifdef CONFIG_PPC_TRANSACTIONAL_MEM
+
+/*
+ *  Transactional memory SPR
+ *
+ * struct {
+ * 	u64		tm_tfhar;
+ *	u64		tm_texasr;
+ *	u64		tm_tfiar;
+ *	unsigned long	tm_orig_msr;
+ * 	unsigned long	tm_tar;
+ *	unsigned long	tm_ppr;
+ *	unsigned long	tm_dscr;
+ * };
+ */
+static int tm_spr_get(struct task_struct *target, const struct user_regset *regset,
+		   unsigned int pos, unsigned int count,
+		   void *kbuf, void __user *ubuf)
+{
+	int ret;
+
+	flush_fp_to_thread(target);
+	flush_altivec_to_thread(target);
+	flush_tmreg_to_thread(target);
+
+	/* TFHAR register */
+	ret = user_regset_copyout(&pos, &count, &kbuf, &ubuf,
+			&target->thread.tm_tfhar, 0, sizeof(u64));
+
+	BUILD_BUG_ON(offsetof(struct thread_struct, tm_tfhar) +
+			sizeof(u64) != offsetof(struct thread_struct, tm_texasr));
+
+	/* TEXASR register */
+	if (!ret)
+		ret = user_regset_copyout(&pos, &count, &kbuf, &ubuf,
+			&target->thread.tm_texasr, sizeof(u64), 2 * sizeof(u64));
+
+	BUILD_BUG_ON(offsetof(struct thread_struct, tm_texasr) +
+			sizeof(u64) != offsetof(struct thread_struct, tm_tfiar));
+
+	/* TFIAR register */
+	if (!ret)
+		ret = user_regset_copyout(&pos, &count, &kbuf, &ubuf,
+			&target->thread.tm_tfiar, 2 * sizeof(u64), 3 * sizeof(u64));
+
+	BUILD_BUG_ON(offsetof(struct thread_struct, tm_tfiar) +
+			sizeof(u64) != offsetof(struct thread_struct, tm_orig_msr));
+
+	/* TM checkpointed original MSR */
+	if (!ret)
+		ret = user_regset_copyout(&pos, &count, &kbuf, &ubuf,
+			&target->thread.tm_orig_msr, 3 * sizeof(u64),
+				3 * sizeof(u64) + sizeof(unsigned long));
+
+	BUILD_BUG_ON(offsetof(struct thread_struct, tm_orig_msr) +
+			sizeof(unsigned long) + sizeof(struct pt_regs)
+				!= offsetof(struct thread_struct, tm_tar));
+
+	/* TM checkpointed TAR register */
+	if (!ret)
+		ret = user_regset_copyout(&pos, &count, &kbuf, &ubuf,
+			&target->thread.tm_tar, 3 * sizeof(u64) +
+				sizeof(unsigned long) , 3 * sizeof(u64) +
+					2 * sizeof(unsigned long));
+
+	BUILD_BUG_ON(offsetof(struct thread_struct, tm_tar)
+			+ sizeof(unsigned long) !=
+				offsetof(struct thread_struct, tm_ppr));
+
+	/* TM checkpointed PPR register */
+	if (!ret)
+		ret = user_regset_copyout(&pos, &count, &kbuf, &ubuf,
+				&target->thread.tm_ppr, 3 * sizeof(u64) +
+					2 * sizeof(unsigned long), 3 * sizeof(u64) +
+						3 * sizeof(unsigned long));
+
+	BUILD_BUG_ON(offsetof(struct thread_struct, tm_ppr) +
+			sizeof(unsigned long) !=
+				offsetof(struct thread_struct, tm_dscr));
+
+	/* TM checkpointed DSCR register */
+	if (!ret)
+		ret = user_regset_copyout(&pos, &count, &kbuf, &ubuf,
+			&target->thread.tm_dscr, 3 * sizeof(u64)
+				+ 3 * sizeof(unsigned long), 3 * sizeof(u64)
+						+ 4 * sizeof(unsigned long));
+	return ret;
+}
+
+static int tm_spr_set(struct task_struct *target, const struct user_regset *regset,
+		   unsigned int pos, unsigned int count,
+		   const void *kbuf, const void __user *ubuf)
+{
+	int ret;
+
+	flush_fp_to_thread(target);
+	flush_altivec_to_thread(target);
+	flush_tmreg_to_thread(target);
+
+	/* TFHAR register */
+	ret = user_regset_copyin(&pos, &count, &kbuf, &ubuf,
+				&target->thread.tm_tfhar, 0, sizeof(u64));
+
+	BUILD_BUG_ON(offsetof(struct thread_struct, tm_tfhar)
+		+ sizeof(u64) != offsetof(struct thread_struct, tm_texasr));
+
+	/* TEXASR register */
+	if (!ret)
+		ret = user_regset_copyin(&pos, &count, &kbuf, &ubuf,
+			&target->thread.tm_texasr, sizeof(u64), 2 * sizeof(u64));
+
+	BUILD_BUG_ON(offsetof(struct thread_struct, tm_texasr)
+		+ sizeof(u64) != offsetof(struct thread_struct, tm_tfiar));
+
+	/* TFIAR register */
+	if (!ret)
+		ret = user_regset_copyin(&pos, &count, &kbuf, &ubuf,
+			&target->thread.tm_tfiar, 2 * sizeof(u64), 3 * sizeof(u64));
+
+	BUILD_BUG_ON(offsetof(struct thread_struct, tm_tfiar)
+		+ sizeof(u64) != offsetof(struct thread_struct, tm_orig_msr));
+
+	/* TM checkpointed orig MSR */
+	if (!ret)
+		ret = user_regset_copyin(&pos, &count, &kbuf, &ubuf,
+			&target->thread.tm_orig_msr, 3 * sizeof(u64),
+				3 * sizeof(u64) + sizeof(unsigned long));
+
+	BUILD_BUG_ON(offsetof(struct thread_struct, tm_orig_msr)
+		+ sizeof(unsigned long) + sizeof(struct pt_regs) !=
+			offsetof(struct thread_struct, tm_tar));
+
+	/* TM checkpointed TAR register */
+	if (!ret)
+		ret = user_regset_copyin(&pos, &count, &kbuf, &ubuf,
+			&target->thread.tm_tar, 3 * sizeof(u64) +
+				sizeof(unsigned long), 3 * sizeof(u64) +
+					2 * sizeof(unsigned long));
+
+	BUILD_BUG_ON(offsetof(struct thread_struct, tm_tar)
+			+ sizeof(unsigned long) != offsetof(struct thread_struct, tm_ppr));
+
+	/* TM checkpointed PPR register */
+	if (!ret)
+		ret = user_regset_copyin(&pos, &count, &kbuf, &ubuf,
+				&target->thread.tm_ppr, 3 * sizeof(u64)
+					+ 2 * sizeof(unsigned long), 3 * sizeof(u64)
+					+ 3 * sizeof(unsigned long));
+
+	BUILD_BUG_ON(offsetof(struct thread_struct, tm_ppr) +
+			sizeof(unsigned long) !=
+				offsetof(struct thread_struct, tm_dscr));
+
+	/* TM checkpointed DSCR register */
+	if (!ret)
+		ret = user_regset_copyin(&pos, &count, &kbuf, &ubuf,
+				&target->thread.tm_dscr,
+					3 * sizeof(u64) + 3 * sizeof(unsigned long),
+					3 * sizeof(u64) + 4 * sizeof(unsigned long));
+
+	return ret;
+}
+
+/*
+ * TM Checkpointed GPR
+ *
+ * struct data {
+ * 	struct pt_regs ckpt_regs;
+ * };
+ */
+static int tm_cgpr_get(struct task_struct *target, const struct user_regset *regset,
+		   unsigned int pos, unsigned int count,
+		   void *kbuf, void __user *ubuf)
+{
+	int ret;
+
+	flush_fp_to_thread(target);
+	flush_altivec_to_thread(target);
+	flush_tmreg_to_thread(target);
+	ret = user_regset_copyout(&pos, &count, &kbuf, &ubuf,
+			&target->thread.ckpt_regs, 0,
+				sizeof(struct pt_regs));
+	return ret;
+}
+
+static int tm_cgpr_set(struct task_struct *target, const struct user_regset *regset,
+		   unsigned int pos, unsigned int count,
+		   const void *kbuf, const void __user *ubuf)
+{
+	int ret;
+
+	flush_fp_to_thread(target);
+	flush_altivec_to_thread(target);
+	flush_tmreg_to_thread(target);
+	ret = user_regset_copyin(&pos, &count, &kbuf, &ubuf,
+					&target->thread.ckpt_regs, 0,
+						sizeof(struct pt_regs));
+	return ret;
+}
+
+/*
+ * TM Checkpointed FPR
+ *
+ * struct data {
+ * 	u64	fpr[32];
+ * 	u64	fpscr;
+ * };
+ */
+static int tm_cfpr_get(struct task_struct *target, const struct user_regset *regset,
+		   unsigned int pos, unsigned int count,
+		   void *kbuf, void __user *ubuf)
+{
+#ifdef CONFIG_VSX
+	u64 buf[33];
+	int i;
+#endif
+	flush_fp_to_thread(target);
+	flush_altivec_to_thread(target);
+	flush_tmreg_to_thread(target);
+
+#ifdef CONFIG_VSX
+	/* copy to local buffer then write that out */
+	for (i = 0; i < 32 ; i++)
+		buf[i] = target->thread.TS_FPR(i);
+	buf[32] = target->thread.fp_state.fpscr;
+	return user_regset_copyout(&pos, &count, &kbuf, &ubuf, buf, 0, -1);
+
+#else
+	BUILD_BUG_ON(offsetof(struct thread_fp_state, fpscr) !=
+		offsetof(struct thread_fp_state, fpr[32][0]));
+
+	return user_regset_copyout(&pos, &count, &kbuf, &ubuf,
+			&target->thread.thread_fp_state, 0, -1);
+#endif
+}
+
+static int tm_cfpr_set(struct task_struct *target, const struct user_regset *regset,
+		   unsigned int pos, unsigned int count,
+		   const void *kbuf, const void __user *ubuf)
+{
+#ifdef CONFIG_VSX
+	u64 buf[33];
+	int i;
+#endif
+	flush_fp_to_thread(target);
+	flush_altivec_to_thread(target);
+	flush_tmreg_to_thread(target);
+
+#ifdef CONFIG_VSX
+	/* copy to local buffer then write that out */
+	i = user_regset_copyin(&pos, &count, &kbuf, &ubuf, buf, 0, -1);
+	if (i)
+		return i;
+	for (i = 0; i < 32 ; i++)
+		target->thread.TS_FPR(i) = buf[i];
+	target->thread.fp_state.fpscr = buf[32];
+        return 0;
+#else
+	BUILD_BUG_ON(offsetof(struct thread_fp_state, fpscr) !=
+		      offsetof(struct thread_fp_state, fpr[32][0]));
+
+	return user_regset_copyin(&pos, &count, &kbuf, &ubuf,
+				&target->thread.fp_state, 0, -1);
+#endif
+}
+
+/*
+ * TM Checkpointed VMX
+ *
+ * struct data {
+ * 	vector128	vr[32];
+ * 	vector128	vscr;
+ * 	vector128	vrsave;
+ *};
+ */
+static int tm_cvmx_get(struct task_struct *target, const struct user_regset *regset,
+		   unsigned int pos, unsigned int count,
+		   void *kbuf, void __user *ubuf)
+{
+	int ret;
+
+	flush_fp_to_thread(target);
+	flush_altivec_to_thread(target);
+	flush_tmreg_to_thread(target);
+
+	BUILD_BUG_ON(offsetof(struct thread_vr_state, vscr) !=
+		     offsetof(struct thread_vr_state, vr[32]));
+
+	ret = user_regset_copyout(&pos, &count, &kbuf, &ubuf,
+				  &target->thread.vr_state, 0,
+				  33 * sizeof(vector128));
+	if (!ret) {
+		/*
+		 * Copy out only the low-order word of vrsave.
+		 */
+		union {
+			elf_vrreg_t reg;
+			u32 word;
+		} vrsave;
+		memset(&vrsave, 0, sizeof(vrsave));
+		vrsave.word = target->thread.vrsave;
+		ret = user_regset_copyout(&pos, &count, &kbuf, &ubuf, &vrsave,
+					  33 * sizeof(vector128), -1);
+	}
+	return ret;
+}
+
+static int tm_cvmx_set(struct task_struct *target, const struct user_regset *regset,
+		   unsigned int pos, unsigned int count,
+		   const void *kbuf, const void __user *ubuf)
+{
+	int ret;
+
+	flush_fp_to_thread(target);
+	flush_altivec_to_thread(target);
+	flush_tmreg_to_thread(target);
+
+	BUILD_BUG_ON(offsetof(struct thread_vr_state, vscr) !=
+		offsetof(struct thread_vr_state, vr[32]));
+
+	ret = user_regset_copyin(&pos, &count, &kbuf, &ubuf,
+				 &target->thread.vr_state, 0,
+				 33 * sizeof(vector128));
+	if (!ret && count > 0) {
+		/*
+		 * We use only the first word of vrsave.
+		 */
+		union {
+			elf_vrreg_t reg;
+			u32 word;
+		} vrsave;
+		memset(&vrsave, 0, sizeof(vrsave));
+		vrsave.word = target->thread.vrsave;
+		ret = user_regset_copyin(&pos, &count, &kbuf, &ubuf, &vrsave,
+					 33 * sizeof(vector128), -1);
+		if (!ret)
+			target->thread.vrsave = vrsave.word;
+	}
+	return ret;
+}
+#endif	/* CONFIG_PPC_TRANSACTIONAL_MEM */
 
 /*
  * These are our native regset flavors.
@@ -629,6 +1068,12 @@ enum powerpc_regset {
 #ifdef CONFIG_SPE
 	REGSET_SPE,
 #endif
+#ifdef CONFIG_PPC_TRANSACTIONAL_MEM
+	REGSET_TM_SPR,		/* TM specific SPR */
+	REGSET_TM_CGPR,		/* TM checkpointed GPR */
+	REGSET_TM_CFPR,		/* TM checkpointed FPR */
+	REGSET_TM_CVMX		/* TM checkpointed VMX */
+#endif
 };
 
 static const struct user_regset native_regsets[] = {
@@ -663,6 +1108,28 @@ static const struct user_regset native_regsets[] = {
 		.active = evr_active, .get = evr_get, .set = evr_set
 	},
 #endif
+#ifdef CONFIG_PPC_TRANSACTIONAL_MEM
+	[REGSET_TM_SPR] = {
+		.core_note_type = NT_PPC_TM_SPR, .n = 7,
+		.size = sizeof(u64), .align = sizeof(u64),
+		.get = tm_spr_get, .set = tm_spr_set
+	},
+	[REGSET_TM_CGPR] = {
+		.core_note_type = NT_PPC_TM_CGPR, .n = 14,
+		.size = sizeof(u64), .align = sizeof(u64),
+		.get = tm_cgpr_get, .set = tm_cgpr_set
+	},
+	[REGSET_TM_CFPR] = {
+		.core_note_type = NT_PPC_TM_CFPR, .n = ELF_NFPREG,
+		.size = sizeof(double), .align = sizeof(double),
+		.get = tm_cfpr_get, .set = tm_cfpr_set
+	},
+	[REGSET_TM_CVMX] = {
+		.core_note_type = NT_PPC_TM_CVMX, .n = 34,
+		.size = sizeof(vector128), .align = sizeof(vector128),
+		.get = tm_cvmx_get, .set = tm_cvmx_set
+	},
+#endif
 };
 
 static const struct user_regset_view user_ppc_native_view = {
@@ -831,6 +1298,28 @@ static const struct user_regset compat_regsets[] = {
 		.active = evr_active, .get = evr_get, .set = evr_set
 	},
 #endif
+#ifdef CONFIG_PPC_TRANSACTIONAL_MEM
+	[REGSET_TM_SPR] = {
+		.core_note_type = NT_PPC_TM_SPR, .n = 7,
+		.size = sizeof(u64), .align = sizeof(u64),
+		.get = tm_spr_get, .set = tm_spr_set
+	},
+	[REGSET_TM_CGPR] = {
+		.core_note_type = NT_PPC_TM_CGPR, .n = 14,
+		.size = sizeof(u64), .align = sizeof(u64),
+		.get = tm_cgpr_get, .set = tm_cgpr_set
+	},
+	[REGSET_TM_CFPR] = {
+		.core_note_type = NT_PPC_TM_CFPR, .n = ELF_NFPREG,
+		.size = sizeof(double), .align = sizeof(double),
+		.get = tm_cfpr_get, .set = tm_cfpr_set
+	},
+	[REGSET_TM_CVMX] = {
+		.core_note_type = NT_PPC_TM_CVMX, .n = 34,
+		.size = sizeof(vector128), .align = sizeof(vector128),
+		.get = tm_cvmx_get, .set = tm_cvmx_set
+	},
+#endif
 };
 
 static const struct user_regset_view user_ppc_compat_view = {
@@ -1754,7 +2243,32 @@ long arch_ptrace(struct task_struct *child, long request,
 					     REGSET_SPE, 0, 35 * sizeof(u32),
 					     datavp);
 #endif
-
+#ifdef CONFIG_PPC_TRANSACTIONAL_MEM
+	case PTRACE_GETTM_SPRREGS:
+		return copy_regset_to_user(child, &user_ppc_native_view,
+					   REGSET_TM_SPR, 0, 6 * sizeof(u64) + sizeof(unsigned long), datavp);
+	case PTRACE_SETTM_SPRREGS:
+		return copy_regset_from_user(child, &user_ppc_native_view,
+					   REGSET_TM_SPR, 0, 6 * sizeof(u64) + sizeof(unsigned long), datavp);
+	case PTRACE_GETTM_CGPRREGS:
+		return copy_regset_to_user(child, &user_ppc_native_view,
+					   REGSET_TM_CGPR, 0, sizeof(struct pt_regs), datavp);
+	case PTRACE_SETTM_CGPRREGS:
+		return copy_regset_from_user(child, &user_ppc_native_view,
+					   REGSET_TM_CGPR, 0, sizeof(struct pt_regs), datavp);
+	case PTRACE_GETTM_CFPRREGS:
+		return copy_regset_to_user(child, &user_ppc_native_view,
+					   REGSET_TM_CFPR, 0, sizeof(elf_fpregset_t), datavp);
+	case PTRACE_SETTM_CFPRREGS:
+		return copy_regset_from_user(child, &user_ppc_native_view,
+					   REGSET_TM_CFPR, 0, sizeof(elf_fpregset_t), datavp);
+	case PTRACE_GETTM_CVMXREGS:
+		return copy_regset_to_user(child, &user_ppc_native_view,
+					   REGSET_TM_CVMX, 0, (33 * sizeof(vector128) + sizeof(u32)), datavp);
+	case PTRACE_SETTM_CVMXREGS:
+		return copy_regset_from_user(child, &user_ppc_native_view,
+					   REGSET_TM_CVMX, 0, (33 * sizeof(vector128) + sizeof(u32)), datavp);
+#endif /* CONFIG_PPC_TRANSACTIONAL_MEM */
 	default:
 		ret = ptrace_request(child, request, addr, data);
 		break;
-- 
1.7.11.7

