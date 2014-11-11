Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752234AbaKKF1Z (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2014 00:27:25 -0500
Received: from e23smtp09.au.ibm.com ([202.81.31.142]:60823 "EHLO
	e23smtp09.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752100AbaKKF1U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2014 00:27:20 -0500
From: Anshuman Khandual <khandual@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org
Cc: peterz@infradead.org, akpm@linux-foundation.org, tglx@linutronix.de,
        james.hogan@imgtec.com, avagin@openvz.org, Paul.Clothier@imgtec.com,
        palves@redhat.com, oleg@redhat.com, dhowells@redhat.com,
        davej@redhat.com, davem@davemloft.net, mikey@neuling.org,
        benh@kernel.crashing.org, sukadev@linux.vnet.ibm.com,
        mpe@ellerman.id.au, sam.bobroff@au1.ibm.com
Subject: [PATCH V4 6/8] powerpc, ptrace: Enable support for transactional memory register sets
Date: Tue, 11 Nov 2014 10:56:35 +0530
Message-Id: <1415683597-22819-7-git-send-email-khandual@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1415683597-22819-1-git-send-email-khandual@linux.vnet.ibm.com>
References: <1415683597-22819-1-git-send-email-khandual@linux.vnet.ibm.com>
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14111105-0033-0000-0000-0000007C2180
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch enables get and set of transactional memory related register
sets through PTRACE_GETREGSET-PTRACE_SETREGSET interface by implementing
four new powerpc specific register sets i.e REGSET_TM_SPR, REGSET_TM_CGPR,
REGSET_TM_CFPR, REGSET_CVMX support corresponding to these following new
ELF core note types added previously in this regard.

	(1) NT_PPC_TM_SPR
	(2) NT_PPC_TM_CGPR
	(3) NT_PPC_TM_CFPR
	(4) NT_PPC_TM_CVMX

Signed-off-by: Anshuman Khandual <khandual@linux.vnet.ibm.com>
---
 arch/powerpc/include/uapi/asm/elf.h |   2 +
 arch/powerpc/kernel/ptrace.c        | 666 +++++++++++++++++++++++++++++++++++-
 2 files changed, 653 insertions(+), 15 deletions(-)

diff --git a/arch/powerpc/include/uapi/asm/elf.h b/arch/powerpc/include/uapi/asm/elf.h
index 59dad11..fdc8e2f 100644
--- a/arch/powerpc/include/uapi/asm/elf.h
+++ b/arch/powerpc/include/uapi/asm/elf.h
@@ -91,6 +91,8 @@
 
 #define ELF_NGREG	48	/* includes nip, msr, lr, etc. */
 #define ELF_NFPREG	33	/* includes fpscr */
+#define ELF_NVMX	34	/* includes all vector registers */
+#define ELF_NTMSPRREG	7	/* includes TM sprs, org_msr, dscr, tar, ppr */
 
 typedef unsigned long elf_greg_t64;
 typedef elf_greg_t64 elf_gregset_t64[ELF_NGREG];
diff --git a/arch/powerpc/kernel/ptrace.c b/arch/powerpc/kernel/ptrace.c
index 2bbbd10..b279947 100644
--- a/arch/powerpc/kernel/ptrace.c
+++ b/arch/powerpc/kernel/ptrace.c
@@ -63,6 +63,11 @@ struct pt_regs_offset {
 	{.name = STR(gpr##num), .offset = offsetof(struct pt_regs, gpr[num])}
 #define REG_OFFSET_END {.name = NULL, .offset = 0}
 
+/* Some common structure offsets */
+#define TSO(f)	(offsetof(struct thread_struct, f))
+#define TVSO(f)	(offsetof(struct thread_vr_state, f))
+#define TFSO(f)	(offsetof(struct thread_fp_state, f))
+
 static const struct pt_regs_offset regoffset_table[] = {
 	GPR_OFFSET_NAME(0),
 	GPR_OFFSET_NAME(1),
@@ -792,6 +797,534 @@ static int evr_set(struct task_struct *target, const struct user_regset *regset,
 }
 #endif /* CONFIG_SPE */
 
+#ifdef CONFIG_PPC_TRANSACTIONAL_MEM
+/*
+ * tm_spr_active
+ *
+ * This function checks number of available regisers in
+ * the transactional memory SPR category.
+ */
+static int tm_spr_active(struct task_struct *target,
+			 const struct user_regset *regset)
+{
+	if (!cpu_has_feature(CPU_FTR_TM))
+		return -ENODEV;
+
+	if (!MSR_TM_ACTIVE(target->thread.regs->msr))
+		return 0;
+
+	return regset->n;
+}
+
+/*
+ * tm_spr_get
+ *
+ * This function gets transactional memory related SPR registers
+ *
+ * Userspace interface buffer layout:
+ *
+ * struct {
+ *	u64		tm_tfhar;
+ *	u64		tm_texasr;
+ *	u64		tm_tfiar;
+ *	unsigned long	tm_orig_msr;
+ *	unsigned long	tm_tar;
+ *	unsigned long	tm_ppr;
+ *	unsigned long	tm_dscr;
+ * };
+ */
+static int tm_spr_get(struct task_struct *target,
+		      const struct user_regset *regset,
+		      unsigned int pos, unsigned int count,
+		      void *kbuf, void __user *ubuf)
+{
+	int ret;
+
+	/* Build tests */
+	BUILD_BUG_ON(TSO(tm_tfhar) + sizeof(u64) != TSO(tm_texasr));
+	BUILD_BUG_ON(TSO(tm_texasr) + sizeof(u64) != TSO(tm_tfiar));
+	BUILD_BUG_ON(TSO(tm_tfiar) + sizeof(u64) != TSO(tm_orig_msr));
+	BUILD_BUG_ON(TSO(tm_orig_msr) +	sizeof(unsigned long) +
+				sizeof(struct pt_regs) != TSO(tm_tar));
+	BUILD_BUG_ON(TSO(tm_tar) + sizeof(unsigned long) != TSO(tm_ppr));
+	BUILD_BUG_ON(TSO(tm_ppr) + sizeof(unsigned long) != TSO(tm_dscr));
+
+	if (!cpu_has_feature(CPU_FTR_TM))
+		return -ENODEV;
+
+	if (!MSR_TM_ACTIVE(target->thread.regs->msr))
+		return -ENODATA;
+
+	/* Flush the states */
+	flush_fp_to_thread(target);
+	flush_altivec_to_thread(target);
+	flush_tmregs_to_thread(target);
+
+	/* TFHAR register */
+	ret = user_regset_copyout(&pos, &count, &kbuf, &ubuf,
+				&target->thread.tm_tfhar, 0, sizeof(u64));
+
+	/* TEXASR register */
+	if (!ret)
+		ret = user_regset_copyout(&pos, &count, &kbuf, &ubuf,
+				&target->thread.tm_texasr, sizeof(u64),
+				2 * sizeof(u64));
+
+	/* TFIAR register */
+	if (!ret)
+		ret = user_regset_copyout(&pos, &count, &kbuf, &ubuf,
+				&target->thread.tm_tfiar,
+				2 * sizeof(u64), 3 * sizeof(u64));
+
+	/* TM checkpointed original MSR */
+	if (!ret)
+		ret = user_regset_copyout(&pos, &count, &kbuf, &ubuf,
+				&target->thread.tm_orig_msr, 3 * sizeof(u64),
+				3 * sizeof(u64) + sizeof(unsigned long));
+
+	/* TM checkpointed TAR register */
+	if (!ret)
+		ret = user_regset_copyout(&pos, &count, &kbuf, &ubuf,
+				&target->thread.tm_tar, 3 * sizeof(u64) +
+				sizeof(unsigned long) ,
+				3 * sizeof(u64) + 2 * sizeof(unsigned long));
+
+	/* TM checkpointed PPR register */
+	if (!ret)
+		ret = user_regset_copyout(&pos, &count, &kbuf, &ubuf,
+				&target->thread.tm_ppr, 3 * sizeof(u64) +
+				2 * sizeof(unsigned long),
+				3 * sizeof(u64) + 3 * sizeof(unsigned long));
+
+	/* TM checkpointed DSCR register */
+	if (!ret)
+		ret = user_regset_copyout(&pos, &count, &kbuf, &ubuf,
+				&target->thread.tm_dscr, 3 * sizeof(u64) +
+				3 * sizeof(unsigned long),
+				3 * sizeof(u64) + 4 * sizeof(unsigned long));
+	return ret;
+}
+
+/*
+ * tm_spr_set
+ *
+ * This function sets transactional memory related SPR registers
+ *
+ * Userspace interface buffer layout:
+ *
+ * struct {
+ *	u64		tm_tfhar;
+ *	u64		tm_texasr;
+ *	u64		tm_tfiar;
+ *	unsigned long	tm_orig_msr;
+ *	unsigned long	tm_tar;
+ *	unsigned long	tm_ppr;
+ *	unsigned long	tm_dscr;
+ * };
+ */
+static int tm_spr_set(struct task_struct *target,
+		      const struct user_regset *regset,
+		      unsigned int pos, unsigned int count,
+		      const void *kbuf, const void __user *ubuf)
+{
+	int ret;
+
+	/* Build tests */
+	BUILD_BUG_ON(TSO(tm_tfhar) + sizeof(u64) != TSO(tm_texasr));
+	BUILD_BUG_ON(TSO(tm_texasr) + sizeof(u64) != TSO(tm_tfiar));
+	BUILD_BUG_ON(TSO(tm_orig_msr) + sizeof(unsigned long)
+				+ sizeof(struct pt_regs) != TSO(tm_tar));
+	BUILD_BUG_ON(TSO(tm_tar) + sizeof(unsigned long) != TSO(tm_ppr));
+	BUILD_BUG_ON(TSO(tm_ppr) + sizeof(unsigned long) != TSO(tm_dscr));
+	BUILD_BUG_ON(TSO(tm_tfiar) + sizeof(u64) != TSO(tm_orig_msr));
+
+	if (!cpu_has_feature(CPU_FTR_TM))
+		return -ENODEV;
+
+	if (!MSR_TM_ACTIVE(target->thread.regs->msr))
+		return -ENODATA;
+
+	/* Flush the states */
+	flush_fp_to_thread(target);
+	flush_altivec_to_thread(target);
+	flush_tmregs_to_thread(target);
+
+	/* TFHAR register */
+	ret = user_regset_copyin(&pos, &count, &kbuf, &ubuf,
+				&target->thread.tm_tfhar, 0, sizeof(u64));
+
+	/* TEXASR register */
+	if (!ret)
+		ret = user_regset_copyin(&pos, &count, &kbuf, &ubuf,
+				&target->thread.tm_texasr, sizeof(u64),
+				2 * sizeof(u64));
+
+	/* TFIAR register */
+	if (!ret)
+		ret = user_regset_copyin(&pos, &count, &kbuf, &ubuf,
+				&target->thread.tm_tfiar,
+				 2 * sizeof(u64), 3 * sizeof(u64));
+
+
+	/* TM checkpointed orig MSR */
+	if (!ret)
+		ret = user_regset_copyin(&pos, &count, &kbuf, &ubuf,
+				&target->thread.tm_orig_msr, 3 * sizeof(u64),
+				3 * sizeof(u64) + sizeof(unsigned long));
+
+
+	/* TM checkpointed TAR register */
+	if (!ret)
+		ret = user_regset_copyin(&pos, &count, &kbuf, &ubuf,
+				&target->thread.tm_tar, 3 * sizeof(u64) +
+				sizeof(unsigned long), 3 * sizeof(u64) +
+				2 * sizeof(unsigned long));
+
+	/* TM checkpointed PPR register */
+	if (!ret)
+		ret = user_regset_copyin(&pos, &count, &kbuf, &ubuf,
+				&target->thread.tm_ppr, 3 * sizeof(u64) +
+				2 * sizeof(unsigned long), 3 * sizeof(u64) +
+				3 * sizeof(unsigned long));
+
+	/* TM checkpointed DSCR register */
+	if (!ret)
+		ret = user_regset_copyin(&pos, &count, &kbuf, &ubuf,
+				&target->thread.tm_dscr, 3 * sizeof(u64) +
+				3 * sizeof(unsigned long), 3 * sizeof(u64) +
+				4 * sizeof(unsigned long));
+	return ret;
+}
+
+/*
+ * tm_cgpr_active
+ *
+ * This function checks the number of available regisers in
+ * transaction checkpointed GPR category.
+ */
+static int tm_cgpr_active(struct task_struct *target,
+			  const struct user_regset *regset)
+{
+	if (!cpu_has_feature(CPU_FTR_TM))
+		return -ENODEV;
+
+	if (!MSR_TM_ACTIVE(target->thread.regs->msr))
+		return 0;
+
+	return regset->n;
+}
+
+/*
+ * tm_cgpr_get
+ *
+ * This function gets transaction checkpointed GPR registers
+ *
+ * When the transaction is active, 'ckpt_regs' holds all the checkpointed
+ * GPR register values for the current transaction to fall back on if it
+ * aborts in between. This function gets those checkpointed GPR registers.
+ *
+ * Userspace interface buffer layout:
+ *
+ * struct data {
+ *	struct pt_regs ckpt_regs;
+ * };
+ */
+static int tm_cgpr_get(struct task_struct *target,
+			const struct user_regset *regset,
+			unsigned int pos, unsigned int count,
+			void *kbuf, void __user *ubuf)
+{
+	int ret;
+
+	if (!cpu_has_feature(CPU_FTR_TM))
+		return -ENODEV;
+
+	if (!MSR_TM_ACTIVE(target->thread.regs->msr))
+		return -ENODATA;
+
+	flush_fp_to_thread(target);
+	flush_altivec_to_thread(target);
+	flush_tmregs_to_thread(target);
+	ret = user_regset_copyout(&pos, &count, &kbuf, &ubuf,
+					&target->thread.ckpt_regs, 0,
+					sizeof(struct pt_regs));
+	return ret;
+}
+
+/*
+ * tm_cgpr_set
+ *
+ * This function sets in transaction checkpointed GPR registers
+ *
+ * When the transaction is active, 'ckpt_regs' holds the checkpointed
+ * GPR register values for the current transaction to fall back on if it
+ * aborts in between. This function sets those checkpointed GPR registers.
+ *
+ * Userspace intaerface buffer:
+ *
+ * struct data {
+ *	struct pt_regs ckpt_regs;
+ * };
+ */
+static int tm_cgpr_set(struct task_struct *target,
+			const struct user_regset *regset,
+			unsigned int pos, unsigned int count,
+			const void *kbuf, const void __user *ubuf)
+{
+	int ret;
+
+	if (!cpu_has_feature(CPU_FTR_TM))
+		return -ENODEV;
+
+	if (!MSR_TM_ACTIVE(target->thread.regs->msr))
+		return -ENODATA;
+
+	flush_fp_to_thread(target);
+	flush_altivec_to_thread(target);
+	flush_tmregs_to_thread(target);
+	ret = user_regset_copyin(&pos, &count, &kbuf, &ubuf,
+					&target->thread.ckpt_regs, 0,
+					sizeof(struct pt_regs));
+	return ret;
+}
+
+/*
+ * tm_cfpr_active
+ *
+ * This function checks number of available regisers in
+ * transaction checkpointed FPR category.
+ */
+static int tm_cfpr_active(struct task_struct *target,
+				const struct user_regset *regset)
+{
+	if (!cpu_has_feature(CPU_FTR_TM))
+		return -ENODEV;
+
+	if (!MSR_TM_ACTIVE(target->thread.regs->msr))
+		return 0;
+
+	return regset->n;
+}
+
+/*
+ * tm_cfpr_get
+ *
+ * This function gets in transaction checkpointed FPR registers
+ *
+ * When the transaction is active 'fp_state' holds the checkpointed
+ * values for the current transaction to fall back on if it aborts
+ * in between. This function gets those checkpointed FPR registers.
+ *
+ * Userspace interface buffer layout:
+ *
+ * struct data {
+ *	u64	fpr[32];
+ *	u64	fpscr;
+ *};
+ */
+static int tm_cfpr_get(struct task_struct *target,
+			const struct user_regset *regset,
+			unsigned int pos, unsigned int count,
+			void *kbuf, void __user *ubuf)
+{
+	u64 buf[33];
+	int i;
+
+	if (!cpu_has_feature(CPU_FTR_TM))
+		return -ENODEV;
+
+	if (!MSR_TM_ACTIVE(target->thread.regs->msr))
+		return -ENODATA;
+
+	flush_fp_to_thread(target);
+	flush_altivec_to_thread(target);
+	flush_tmregs_to_thread(target);
+
+	/* copy to local buffer then write that out */
+	for (i = 0; i < 32 ; i++)
+		buf[i] = target->thread.TS_FPR(i);
+	buf[32] = target->thread.fp_state.fpscr;
+	return user_regset_copyout(&pos, &count, &kbuf, &ubuf, buf, 0, -1);
+}
+
+/*
+ * tm_cfpr_set
+ *
+ * This function sets in transaction checkpointed FPR registers
+ *
+ * When the transaction is active 'fp_state' holds the checkpointed
+ * FPR register values for the current transaction to fall back on
+ * if it aborts in between. This function sets these checkpointed
+ * FPR registers.
+ *
+ * Userspace interface buffer layout:
+ *
+ * struct data {
+ *	u64	fpr[32];
+ *	u64	fpscr;
+ *};
+ */
+static int tm_cfpr_set(struct task_struct *target,
+			const struct user_regset *regset,
+			unsigned int pos, unsigned int count,
+			const void *kbuf, const void __user *ubuf)
+{
+	u64 buf[33];
+	int i;
+
+	if (!cpu_has_feature(CPU_FTR_TM))
+		return -ENODEV;
+
+	if (!MSR_TM_ACTIVE(target->thread.regs->msr))
+		return -ENODATA;
+
+	flush_fp_to_thread(target);
+	flush_altivec_to_thread(target);
+	flush_tmregs_to_thread(target);
+
+	/* copy to local buffer then write that out */
+	i = user_regset_copyin(&pos, &count, &kbuf, &ubuf, buf, 0, -1);
+	if (i)
+		return i;
+	for (i = 0; i < 32 ; i++)
+		target->thread.TS_FPR(i) = buf[i];
+	target->thread.fp_state.fpscr = buf[32];
+	return 0;
+}
+
+/*
+ * tm_cvmx_active
+ *
+ * This function checks the number of available regisers in
+ * checkpointed VMX category.
+ */
+static int tm_cvmx_active(struct task_struct *target,
+				const struct user_regset *regset)
+{
+	if (!cpu_has_feature(CPU_FTR_TM))
+		return -ENODEV;
+
+	if (!MSR_TM_ACTIVE(target->thread.regs->msr))
+		return 0;
+
+	return regset->n;
+}
+
+/*
+ * tm_cvmx_get
+ *
+ * This function gets in transaction checkpointed VMX registers
+ *
+ * When the transaction is active 'vr_state' and 'vr_save' hold
+ * the checkpointed values for the current transaction to fall
+ * back on if it aborts in between.
+ *
+ * User interface buffer:
+ *
+ * struct data {
+ *	vector128	vr[32];
+ *	vector128	vscr;
+ *	vector128	vrsave;
+ *};
+ */
+static int tm_cvmx_get(struct task_struct *target,
+			const struct user_regset *regset,
+			unsigned int pos, unsigned int count,
+			void *kbuf, void __user *ubuf)
+{
+	int ret;
+
+	BUILD_BUG_ON(TVSO(vscr) != TVSO(vr[32]));
+
+	if (!cpu_has_feature(CPU_FTR_TM))
+		return -ENODEV;
+
+	if (!MSR_TM_ACTIVE(target->thread.regs->msr))
+		return -ENODATA;
+
+	/* Flush the state */
+	flush_fp_to_thread(target);
+	flush_altivec_to_thread(target);
+	flush_tmregs_to_thread(target);
+
+	ret = user_regset_copyout(&pos, &count, &kbuf, &ubuf,
+					&target->thread.vr_state, 0,
+					33 * sizeof(vector128));
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
+						33 * sizeof(vector128), -1);
+	}
+
+	return ret;
+}
+
+/*
+ * tm_cvmx_set
+ *
+ * This function sets in transaction checkpointed VMX registers
+ *
+ * When the transaction is active 'vr_state' and 'vr_save' hold
+ * the checkpointed values for the current transaction to fall
+ * back on if it aborts in between.
+ *
+ * Userspace interface buffer:
+ *
+ * struct data {
+ *	vector128	vr[32];
+ *	vector128	vscr;
+ *	vector128	vrsave;
+ *};
+ */
+static int tm_cvmx_set(struct task_struct *target,
+			const struct user_regset *regset,
+			unsigned int pos, unsigned int count,
+			const void *kbuf, const void __user *ubuf)
+{
+	int ret;
+
+	BUILD_BUG_ON(TVSO(vscr) != TVSO(vr[32]));
+
+	if (!cpu_has_feature(CPU_FTR_TM))
+		return -ENODEV;
+
+	if (!MSR_TM_ACTIVE(target->thread.regs->msr))
+		return -ENODATA;
+
+	flush_fp_to_thread(target);
+	flush_altivec_to_thread(target);
+	flush_tmregs_to_thread(target);
+
+	ret = user_regset_copyin(&pos, &count, &kbuf, &ubuf,
+					&target->thread.vr_state, 0,
+					33 * sizeof(vector128));
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
+						33 * sizeof(vector128), -1);
+		if (!ret)
+			target->thread.vrsave = vrsave.word;
+	}
+
+	return ret;
+}
+#endif	/* CONFIG_PPC_TRANSACTIONAL_MEM */
 
 /*
  * These are our native regset flavors.
@@ -808,6 +1341,12 @@ enum powerpc_regset {
 #ifdef CONFIG_SPE
 	REGSET_SPE,
 #endif
+#ifdef CONFIG_PPC_TRANSACTIONAL_MEM
+	REGSET_TM_SPR,		/* TM specific SPR registers */
+	REGSET_TM_CGPR,		/* TM checkpointed GPR registers */
+	REGSET_TM_CFPR,		/* TM checkpointed FPR registers */
+	REGSET_TM_CVMX,		/* TM checkpointed VMX registers */
+#endif
 };
 
 static const struct user_regset native_regsets[] = {
@@ -842,6 +1381,28 @@ static const struct user_regset native_regsets[] = {
 		.active = evr_active, .get = evr_get, .set = evr_set
 	},
 #endif
+#ifdef CONFIG_PPC_TRANSACTIONAL_MEM
+	[REGSET_TM_SPR] = {
+		.core_note_type = NT_PPC_TM_SPR, .n = ELF_NTMSPRREG,
+		.size = sizeof(u64), .align = sizeof(u64),
+		.active = tm_spr_active, .get = tm_spr_get, .set = tm_spr_set
+	},
+	[REGSET_TM_CGPR] = {
+		.core_note_type = NT_PPC_TM_CGPR, .n = ELF_NGREG,
+		.size = sizeof(long), .align = sizeof(long),
+		.active = tm_cgpr_active, .get = tm_cgpr_get, .set = tm_cgpr_set
+	},
+	[REGSET_TM_CFPR] = {
+		.core_note_type = NT_PPC_TM_CFPR, .n = ELF_NFPREG,
+		.size = sizeof(double), .align = sizeof(double),
+		.active = tm_cfpr_active, .get = tm_cfpr_get, .set = tm_cfpr_set
+	},
+	[REGSET_TM_CVMX] = {
+		.core_note_type = NT_PPC_TM_CVMX, .n = ELF_NVMX,
+		.size = sizeof(vector128), .align = sizeof(vector128),
+		.active = tm_cvmx_active, .get = tm_cvmx_get, .set = tm_cvmx_set
+	},
+#endif
 };
 
 static const struct user_regset_view user_ppc_native_view = {
@@ -852,24 +1413,35 @@ static const struct user_regset_view user_ppc_native_view = {
 #ifdef CONFIG_PPC64
 #include <linux/compat.h>
 
-static int gpr32_get(struct task_struct *target,
+static int common_gpr32_get(struct task_struct *target,
 		     const struct user_regset *regset,
 		     unsigned int pos, unsigned int count,
-		     void *kbuf, void __user *ubuf)
+			    void *kbuf, void __user *ubuf, bool in_tm)
 {
-	const unsigned long *regs = &target->thread.regs->gpr[0];
+	const unsigned long *regs;
 	compat_ulong_t *k = kbuf;
 	compat_ulong_t __user *u = ubuf;
 	compat_ulong_t reg;
 	int i;
 
-	if (target->thread.regs == NULL)
-		return -EIO;
+	if (in_tm) {
+#ifdef CONFIG_PPC_TRANSACTIONAL_MEM
+		regs = &target->thread.ckpt_regs.gpr[0];
+#endif
+	} else {
+		regs = &target->thread.regs->gpr[0];
 
-	if (!FULL_REGS(target->thread.regs)) {
-		/* We have a partial register set.  Fill 14-31 with bogus values */
-		for (i = 14; i < 32; i++)
-			target->thread.regs->gpr[i] = NV_REG_POISON; 
+		if (target->thread.regs == NULL)
+			return -EIO;
+
+		if (!FULL_REGS(target->thread.regs)) {
+			/*
+			 * We have a partial register set.
+			 * Fill 14-31 with bogus values.
+			 */
+			for (i = 14; i < 32; i++)
+				target->thread.regs->gpr[i] = NV_REG_POISON;
+		}
 	}
 
 	pos /= sizeof(reg);
@@ -909,20 +1481,28 @@ static int gpr32_get(struct task_struct *target,
 					PT_REGS_COUNT * sizeof(reg), -1);
 }
 
-static int gpr32_set(struct task_struct *target,
+static int common_gpr32_set(struct task_struct *target,
 		     const struct user_regset *regset,
 		     unsigned int pos, unsigned int count,
-		     const void *kbuf, const void __user *ubuf)
+		     const void *kbuf, const void __user *ubuf, bool in_tm)
 {
-	unsigned long *regs = &target->thread.regs->gpr[0];
+	unsigned long *regs;
 	const compat_ulong_t *k = kbuf;
 	const compat_ulong_t __user *u = ubuf;
 	compat_ulong_t reg;
 
-	if (target->thread.regs == NULL)
-		return -EIO;
+	if (in_tm) {
+#ifdef CONFIG_PPC_TRANSACTIONAL_MEM
+		regs = &target->thread.ckpt_regs.gpr[0];
+#endif
+	} else {
+		regs = &target->thread.regs->gpr[0];
 
-	CHECK_FULL_REGS(target->thread.regs);
+		if (target->thread.regs == NULL)
+			return -EIO;
+
+		CHECK_FULL_REGS(target->thread.regs);
+	}
 
 	pos /= sizeof(reg);
 	count /= sizeof(reg);
@@ -982,6 +1562,39 @@ static int gpr32_set(struct task_struct *target,
 					 (PT_TRAP + 1) * sizeof(reg), -1);
 }
 
+#ifdef CONFIG_PPC_TRANSACTIONAL_MEM
+static int tm_cgpr32_get(struct task_struct *target,
+		     const struct user_regset *regset,
+		     unsigned int pos, unsigned int count,
+		     void *kbuf, void __user *ubuf)
+{
+	return common_gpr32_get(target, regset, pos, count, kbuf, ubuf, 1);
+}
+
+static int tm_cgpr32_set(struct task_struct *target,
+		     const struct user_regset *regset,
+		     unsigned int pos, unsigned int count,
+		     const void *kbuf, const void __user *ubuf)
+{
+	return common_gpr32_set(target, regset, pos, count, kbuf, ubuf, 0);
+}
+#endif /* CONFIG_PPC_TRANSACTIONAL_MEM */
+
+static int gpr32_get(struct task_struct *target,
+		     const struct user_regset *regset,
+		     unsigned int pos, unsigned int count,
+		     void *kbuf, void __user *ubuf)
+{
+	return common_gpr32_get(target, regset, pos, count, kbuf, ubuf, 0);
+}
+
+static int gpr32_set(struct task_struct *target,
+		     const struct user_regset *regset,
+		     unsigned int pos, unsigned int count,
+		     const void *kbuf, const void __user *ubuf)
+{
+	return common_gpr32_set(target, regset, pos, count, kbuf, ubuf, 0);
+}
 /*
  * These are the regset flavors matching the CONFIG_PPC32 native set.
  */
@@ -1010,6 +1623,29 @@ static const struct user_regset compat_regsets[] = {
 		.active = evr_active, .get = evr_get, .set = evr_set
 	},
 #endif
+#ifdef CONFIG_PPC_TRANSACTIONAL_MEM
+	[REGSET_TM_SPR] = {
+		.core_note_type = NT_PPC_TM_SPR, .n = ELF_NTMSPRREG,
+		.size = sizeof(u64), .align = sizeof(u64),
+		.active = tm_spr_active, .get = tm_spr_get, .set = tm_spr_set
+	},
+	[REGSET_TM_CGPR] = {
+		.core_note_type = NT_PPC_TM_CGPR, .n = ELF_NGREG,
+		.size = sizeof(long), .align = sizeof(long),
+		.active = tm_cgpr_active,
+		.get = tm_cgpr32_get, .set = tm_cgpr32_set
+	},
+	[REGSET_TM_CFPR] = {
+		.core_note_type = NT_PPC_TM_CFPR, .n = ELF_NFPREG,
+		.size = sizeof(double), .align = sizeof(double),
+		.active = tm_cfpr_active, .get = tm_cfpr_get, .set = tm_cfpr_set
+	},
+	[REGSET_TM_CVMX] = {
+		.core_note_type = NT_PPC_TM_CVMX, .n = ELF_NVMX,
+		.size = sizeof(vector128), .align = sizeof(vector128),
+		.active = tm_cvmx_active, .get = tm_cvmx_get, .set = tm_cvmx_set
+	},
+#endif
 };
 
 static const struct user_regset_view user_ppc_compat_view = {
-- 
1.9.3

