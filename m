Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754954AbaEEH5B (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2014 03:57:01 -0400
Received: from e28smtp07.in.ibm.com ([122.248.162.7]:52961 "EHLO
	e28smtp07.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754935AbaEEH47 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2014 03:56:59 -0400
From: Anshuman Khandual <khandual@linux.vnet.ibm.com>
To: linuxppc-dev@ozlabs.org, linux-kernel@vger.kernel.org
Cc: michael@ellerman.id.au, mikey@neuling.org, avagin@openvz.org,
        oleg@redhat.com, roland@redhat.com, palves@redhat.com,
        Anshuman Khandual <khandual@linux.vnet.ibm.com>
Subject: [PATCH V2 2/3] powerpc, ptrace: Enable support for transactional memory register sets
Date: Mon,  5 May 2014 13:24:28 +0530
Message-Id: <1399276469-13541-3-git-send-email-khandual@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1399276469-13541-1-git-send-email-khandual@linux.vnet.ibm.com>
References: <1399276469-13541-1-git-send-email-khandual@linux.vnet.ibm.com>
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14050507-8878-0000-0000-00000C423814
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch enables get and set of transactional memory related register
sets through PTRACE_GETREGSET/PTRACE_SETREGSET interface by implementing
four new powerpc specific register sets i.e REGSET_TM_SPR, REGSET_TM_CGPR,
REGSET_TM_CFPR, REGSET_CVMX support corresponding to these following new
ELF core note types added previously in this regard.

	(1) NT_PPC_TM_SPR
	(2) NT_PPC_TM_CGPR
	(3) NT_PPC_TM_CFPR
	(4) NT_PPC_TM_CVMX

Signed-off-by: Anshuman Khandual <khandual@linux.vnet.ibm.com>
---
 arch/powerpc/include/asm/switch_to.h |   8 +
 arch/powerpc/kernel/process.c        |  24 ++
 arch/powerpc/kernel/ptrace.c         | 683 +++++++++++++++++++++++++++++++++--
 3 files changed, 687 insertions(+), 28 deletions(-)

diff --git a/arch/powerpc/include/asm/switch_to.h b/arch/powerpc/include/asm/switch_to.h
index 0e83e7d..2737f46 100644
--- a/arch/powerpc/include/asm/switch_to.h
+++ b/arch/powerpc/include/asm/switch_to.h
@@ -80,6 +80,14 @@ static inline void flush_spe_to_thread(struct task_struct *t)
 }
 #endif
 
+#ifdef CONFIG_PPC_TRANSACTIONAL_MEM
+extern void flush_tmregs_to_thread(struct task_struct *);
+#else
+static inline void flush_tmregs_to_thread(struct task_struct *t)
+{
+}
+#endif /* CONFIG_PPC_TRANSACTIONAL_MEM */
+
 static inline void clear_task_ebb(struct task_struct *t)
 {
 #ifdef CONFIG_PPC_BOOK3S_64
diff --git a/arch/powerpc/kernel/process.c b/arch/powerpc/kernel/process.c
index 31d0215..e247898 100644
--- a/arch/powerpc/kernel/process.c
+++ b/arch/powerpc/kernel/process.c
@@ -695,6 +695,30 @@ static inline void __switch_to_tm(struct task_struct *prev)
 	}
 }
 
+void flush_tmregs_to_thread(struct task_struct *tsk)
+{
+	/*
+	 * If task is not current, it should have been flushed
+	 * already to it's thread_struct during __switch_to().
+	 */
+	if (tsk != current)
+		return;
+
+	preempt_disable();
+	if (tsk->thread.regs) {
+		/*
+		 * If we are still current, the TM state need to
+		 * be flushed to thread_struct as it will be still
+		 * present in the current cpu.
+		 */
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
index 2e3d2bf..92faded 100644
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
+		flush_tmregs_to_thread(target);
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
+		flush_tmregs_to_thread(target);
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
+		flush_tmregs_to_thread(target);
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
+		flush_tmregs_to_thread(target);
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
+	flush_tmregs_to_thread(target);
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
+	flush_tmregs_to_thread(target);
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
+	flush_tmregs_to_thread(target);
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
+	flush_tmregs_to_thread(target);
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
+	flush_tmregs_to_thread(target);
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
+	flush_tmregs_to_thread(target);
+
+#ifdef CONFIG_VSX
+	/* copy to local buffer then write that out */
+	i = user_regset_copyin(&pos, &count, &kbuf, &ubuf, buf, 0, -1);
+	if (i)
+		return i;
+	for (i = 0; i < 32 ; i++)
+		target->thread.TS_FPR(i) = buf[i];
+	target->thread.fp_state.fpscr = buf[32];
+	return 0;
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
+	flush_tmregs_to_thread(target);
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
+	flush_tmregs_to_thread(target);
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
+	REGSET_TM_CVMX,		/* TM checkpointed VMX */
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
+		.core_note_type = NT_PPC_TM_CGPR, .n = ELF_NGREG,
+		.size = sizeof(long), .align = sizeof(long),
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
@@ -803,6 +1270,145 @@ static int gpr32_set(struct task_struct *target,
 					 (PT_TRAP + 1) * sizeof(reg), -1);
 }
 
+static int tm_cgpr32_get(struct task_struct *target,
+		     const struct user_regset *regset,
+		     unsigned int pos, unsigned int count,
+		     void *kbuf, void __user *ubuf)
+{
+	const unsigned long *regs = &target->thread.ckpt_regs.gpr[0];
+	compat_ulong_t *k = kbuf;
+	compat_ulong_t __user *u = ubuf;
+	compat_ulong_t reg;
+	int i;
+
+	flush_fp_to_thread(target);
+	flush_altivec_to_thread(target);
+	flush_tmregs_to_thread(target);
+
+	if (target->thread.regs == NULL)
+		return -EIO;
+
+	if (!FULL_REGS(target->thread.regs)) {
+		/* We have a partial register set.  Fill 14-31 with bogus values */
+		for (i = 14; i < 32; i++)
+			target->thread.regs->gpr[i] = NV_REG_POISON; 
+	}
+
+	pos /= sizeof(reg);
+	count /= sizeof(reg);
+
+	if (kbuf)
+		for (; count > 0 && pos < PT_MSR; --count)
+			*k++ = regs[pos++];
+	else
+		for (; count > 0 && pos < PT_MSR; --count)
+			if (__put_user((compat_ulong_t) regs[pos++], u++))
+				return -EFAULT;
+
+	if (count > 0 && pos == PT_MSR) {
+		reg = get_user_msr(target);
+		if (kbuf)
+			*k++ = reg;
+		else if (__put_user(reg, u++))
+			return -EFAULT;
+		++pos;
+		--count;
+	}
+
+	if (kbuf)
+		for (; count > 0 && pos < PT_REGS_COUNT; --count)
+			*k++ = regs[pos++];
+	else
+		for (; count > 0 && pos < PT_REGS_COUNT; --count)
+			if (__put_user((compat_ulong_t) regs[pos++], u++))
+				return -EFAULT;
+
+	kbuf = k;
+	ubuf = u;
+	pos *= sizeof(reg);
+	count *= sizeof(reg);
+	return user_regset_copyout_zero(&pos, &count, &kbuf, &ubuf,
+					PT_REGS_COUNT * sizeof(reg), -1);
+}
+
+static int tm_cgpr32_set(struct task_struct *target,
+		     const struct user_regset *regset,
+		     unsigned int pos, unsigned int count,
+		     const void *kbuf, const void __user *ubuf)
+{
+	unsigned long *regs = &target->thread.ckpt_regs.gpr[0];
+	const compat_ulong_t *k = kbuf;
+	const compat_ulong_t __user *u = ubuf;
+	compat_ulong_t reg;
+
+	flush_fp_to_thread(target);
+	flush_altivec_to_thread(target);
+	flush_tmregs_to_thread(target);
+
+	if (target->thread.regs == NULL)
+		return -EIO;
+
+	CHECK_FULL_REGS(target->thread.regs);
+
+	pos /= sizeof(reg);
+	count /= sizeof(reg);
+
+	if (kbuf)
+		for (; count > 0 && pos < PT_MSR; --count)
+			regs[pos++] = *k++;
+	else
+		for (; count > 0 && pos < PT_MSR; --count) {
+			if (__get_user(reg, u++))
+				return -EFAULT;
+			regs[pos++] = reg;
+		}
+
+
+	if (count > 0 && pos == PT_MSR) {
+		if (kbuf)
+			reg = *k++;
+		else if (__get_user(reg, u++))
+			return -EFAULT;
+		set_user_msr(target, reg);
+		++pos;
+		--count;
+	}
+
+	if (kbuf) {
+		for (; count > 0 && pos <= PT_MAX_PUT_REG; --count)
+			regs[pos++] = *k++;
+		for (; count > 0 && pos < PT_TRAP; --count, ++pos)
+			++k;
+	} else {
+		for (; count > 0 && pos <= PT_MAX_PUT_REG; --count) {
+			if (__get_user(reg, u++))
+				return -EFAULT;
+			regs[pos++] = reg;
+		}
+		for (; count > 0 && pos < PT_TRAP; --count, ++pos)
+			if (__get_user(reg, u++))
+				return -EFAULT;
+	}
+
+	if (count > 0 && pos == PT_TRAP) {
+		if (kbuf)
+			reg = *k++;
+		else if (__get_user(reg, u++))
+			return -EFAULT;
+		set_user_trap(target, reg);
+		++pos;
+		--count;
+	}
+
+	kbuf = k;
+	ubuf = u;
+	pos *= sizeof(reg);
+	count *= sizeof(reg);
+	return user_regset_copyin_ignore(&pos, &count, &kbuf, &ubuf,
+					 (PT_TRAP + 1) * sizeof(reg), -1);
+}
+
+
 /*
  * These are the regset flavors matching the CONFIG_PPC32 native set.
  */
@@ -831,6 +1437,28 @@ static const struct user_regset compat_regsets[] = {
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
+		.core_note_type = NT_PPC_TM_CGPR, .n = ELF_NGREG,
+		.size = sizeof(long), .align = sizeof(long),
+		.get = tm_cgpr32_get, .set = tm_cgpr32_set
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
@@ -1754,7 +2382,6 @@ long arch_ptrace(struct task_struct *child, long request,
 					     REGSET_SPE, 0, 35 * sizeof(u32),
 					     datavp);
 #endif
-
 	default:
 		ret = ptrace_request(child, request, addr, data);
 		break;
-- 
1.7.11.7

