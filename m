Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752507AbbANHJo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2015 02:09:44 -0500
Received: from e23smtp03.au.ibm.com ([202.81.31.145]:40203 "EHLO
	e23smtp03.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751191AbbANHJl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2015 02:09:41 -0500
From: Anshuman Khandual <khandual@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org
Cc: peterz@infradead.org, akpm@linux-foundation.org, tglx@linutronix.de,
        james.hogan@imgtec.com, avagin@openvz.org, Paul.Clothier@imgtec.com,
        palves@redhat.com, oleg@redhat.com, dhowells@redhat.com,
        davej@redhat.com, davem@davemloft.net, mikey@neuling.org,
        benh@kernel.crashing.org, sukadev@linux.vnet.ibm.com,
        mpe@ellerman.id.au, sam.bobroff@au1.ibm.com, kirjanov@gmail.com,
        shuahkh@osg.samsung.com
Subject: [PATCH V7 6/8] powerpc, ptrace: Enable support for miscellaneous debug registers
Date: Wed, 14 Jan 2015 12:38:48 +0530
Message-Id: <1421219330-19984-7-git-send-email-khandual@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1421219330-19984-1-git-send-email-khandual@linux.vnet.ibm.com>
References: <1421219330-19984-1-git-send-email-khandual@linux.vnet.ibm.com>
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 15011407-0009-0000-0000-000000CC14AC
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch enables get and set of miscellaneous debug registers through
ptrace PTRACE_GETREGSET-PTRACE_SETREGSET interface by implementing new
powerpc specific register set REGSET_MISC support corresponding to the
new ELF core note NT_PPC_MISC added previously in this regard.

Signed-off-by: Anshuman Khandual <khandual@linux.vnet.ibm.com>
---
 arch/powerpc/include/uapi/asm/elf.h |   1 +
 arch/powerpc/kernel/ptrace.c        | 133 ++++++++++++++++++++++++++++++++++++
 2 files changed, 134 insertions(+)

diff --git a/arch/powerpc/include/uapi/asm/elf.h b/arch/powerpc/include/uapi/asm/elf.h
index fdc8e2f..a41bd98 100644
--- a/arch/powerpc/include/uapi/asm/elf.h
+++ b/arch/powerpc/include/uapi/asm/elf.h
@@ -93,6 +93,7 @@
 #define ELF_NFPREG	33	/* includes fpscr */
 #define ELF_NVMX	34	/* includes all vector registers */
 #define ELF_NTMSPRREG	7	/* includes TM sprs, org_msr, dscr, tar, ppr */
+#define ELF_NMISCREG	3	/* includes dscr, tar, ppr */
 
 typedef unsigned long elf_greg_t64;
 typedef elf_greg_t64 elf_gregset_t64[ELF_NGREG];
diff --git a/arch/powerpc/kernel/ptrace.c b/arch/powerpc/kernel/ptrace.c
index b14397c..38a1147 100644
--- a/arch/powerpc/kernel/ptrace.c
+++ b/arch/powerpc/kernel/ptrace.c
@@ -1371,6 +1371,122 @@ static int tm_cvmx_set(struct task_struct *target,
 }
 #endif	/* CONFIG_PPC_TRANSACTIONAL_MEM */
 
+#ifdef CONFIG_PPC64
+/**
+ * get_misc_dbg() - get MISC debug registers
+ * @target:	The target task.
+ * @regset:	The user regset structure.
+ * @pos:	The buffer position.
+ * @count:	Number of bytes to copy.
+ * @kbuf:	Kernel buffer to copy from.
+ * @ubuf:	User buffer to copy into.
+ *
+ * This function gets various miscellaneous debug registers which includes
+ * DSCR, PPR and TAR. The userspace intarface buffer layout is as follows.
+ *
+ * struct {
+ *	unsigned long dscr;
+ *	unsigned long ppr;
+ *	unsigned long tar;
+ * };
+ *
+ * The data element 'tar' in the structure will be valid only if the kernel
+ * has CONFIG_PPC_BOOK3S_64 config option enabled.
+ */
+static int get_misc_dbg(struct task_struct *target,
+			const struct user_regset *regset, unsigned int pos,
+			unsigned int count, void *kbuf, void __user *ubuf)
+{
+	int ret;
+
+	/* Build test */
+	BUILD_BUG_ON(TSO(dscr) + 2 * sizeof(unsigned long) != TSO(ppr));
+
+#ifdef CONFIG_PPC_BOOK3S_64
+	BUILD_BUG_ON(TSO(ppr) + sizeof(unsigned long) != TSO(tar));
+#endif
+
+	/* DSCR register */
+	ret = user_regset_copyout(&pos, &count, &kbuf, &ubuf,
+					&target->thread.dscr, 0,
+					sizeof(unsigned long));
+
+	/* PPR register */
+	if (!ret)
+		ret = user_regset_copyout(&pos, &count, &kbuf, &ubuf,
+						&target->thread.ppr,
+						sizeof(unsigned long),
+						2 * sizeof(unsigned long));
+
+#ifdef CONFIG_PPC_BOOK3S_64
+	/* TAR register */
+	if (!ret)
+		ret = user_regset_copyout(&pos, &count, &kbuf, &ubuf,
+						&target->thread.tar,
+						2 * sizeof(unsigned long),
+						3 * sizeof(unsigned long));
+#endif
+	return ret;
+}
+
+/**
+ * set_misc_dbg() - set MISC debug registers
+ * @target:	The target task.
+ * @regset:	The user regset structure.
+ * @pos:	The buffer position.
+ * @count:	Number of bytes to copy.
+ * @kbuf:	Kernel buffer to copy into.
+ * @ubuf:	User buffer to copy from.
+ *
+ * This function sets various miscellaneous debug registers which includes
+ * DSCR, PPR and TAR. The userspace intarface buffer layout is as follows.
+ *
+ * struct {
+ *	unsigned long dscr;
+ *	unsigned long ppr;
+ *	unsigned long tar;
+ * };
+ *
+ * The data element 'tar' in the structure will be valid only if the kernel
+ * has CONFIG_PPC_BOOK3S_64 config option enabled.
+ */
+static int set_misc_dbg(struct task_struct *target,
+			const struct user_regset *regset, unsigned int pos,
+			unsigned int count, const void *kbuf,
+			const void __user *ubuf)
+{
+	int ret;
+
+	/* Build test */
+	BUILD_BUG_ON(TSO(dscr) + 2 * sizeof(unsigned long) != TSO(ppr));
+
+#ifdef CONFIG_PPC_BOOK3S_64
+	BUILD_BUG_ON(TSO(ppr) + sizeof(unsigned long) != TSO(tar));
+#endif
+
+	/* DSCR register */
+	ret = user_regset_copyin(&pos, &count, &kbuf, &ubuf,
+					&target->thread.dscr, 0,
+					sizeof(unsigned long));
+
+	/* PPR register */
+	if (!ret)
+		ret = user_regset_copyin(&pos, &count, &kbuf, &ubuf,
+						&target->thread.ppr,
+						sizeof(unsigned long),
+						2 * sizeof(unsigned long));
+#ifdef CONFIG_PPC_BOOK3S_64
+	/* TAR register */
+	if (!ret)
+		ret = user_regset_copyin(&pos, &count, &kbuf, &ubuf,
+						&target->thread.tar,
+						2 * sizeof(unsigned long),
+						3 * sizeof(unsigned long));
+#endif
+	return ret;
+}
+#endif /* CONFIG_PPC64 */
+
 /*
  * These are our native regset flavors.
  */
@@ -1392,6 +1508,9 @@ enum powerpc_regset {
 	REGSET_TM_CFPR,		/* TM checkpointed FPR registers */
 	REGSET_TM_CVMX,		/* TM checkpointed VMX registers */
 #endif
+#ifdef CONFIG_PPC64
+	REGSET_MISC		/* Miscellaneous debug registers */
+#endif
 };
 
 static const struct user_regset native_regsets[] = {
@@ -1448,6 +1567,13 @@ static const struct user_regset native_regsets[] = {
 		.active = tm_cvmx_active, .get = tm_cvmx_get, .set = tm_cvmx_set
 	},
 #endif
+#ifdef CONFIG_PPC64
+	[REGSET_MISC] = {
+		.core_note_type = NT_PPC_MISC, .n = ELF_NMISCREG,
+		.size = sizeof(u64), .align = sizeof(u64),
+		.get = get_misc_dbg, .set = set_misc_dbg
+	},
+#endif
 };
 
 static const struct user_regset_view user_ppc_native_view = {
@@ -1694,6 +1820,13 @@ static const struct user_regset compat_regsets[] = {
 		.active = tm_cvmx_active, .get = tm_cvmx_get, .set = tm_cvmx_set
 	},
 #endif
+#ifdef CONFIG_PPC64
+	[REGSET_MISC] = {
+		.core_note_type = NT_PPC_MISC, .n = ELF_NMISCREG,
+		.size = sizeof(u64), .align = sizeof(u64),
+		.get = get_misc_dbg, .set = set_misc_dbg
+	},
+#endif
 };
 
 static const struct user_regset_view user_ppc_compat_view = {
-- 
1.9.3

