Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752476AbaKKF14 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2014 00:27:56 -0500
Received: from e23smtp07.au.ibm.com ([202.81.31.140]:41003 "EHLO
	e23smtp07.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752100AbaKKF10 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2014 00:27:26 -0500
From: Anshuman Khandual <khandual@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org
Cc: peterz@infradead.org, akpm@linux-foundation.org, tglx@linutronix.de,
        james.hogan@imgtec.com, avagin@openvz.org, Paul.Clothier@imgtec.com,
        palves@redhat.com, oleg@redhat.com, dhowells@redhat.com,
        davej@redhat.com, davem@davemloft.net, mikey@neuling.org,
        benh@kernel.crashing.org, sukadev@linux.vnet.ibm.com,
        mpe@ellerman.id.au, sam.bobroff@au1.ibm.com
Subject: [PATCH V4 7/8] powerpc, ptrace: Enable support for miscellaneous debug registers
Date: Tue, 11 Nov 2014 10:56:36 +0530
Message-Id: <1415683597-22819-8-git-send-email-khandual@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1415683597-22819-1-git-send-email-khandual@linux.vnet.ibm.com>
References: <1415683597-22819-1-git-send-email-khandual@linux.vnet.ibm.com>
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14111105-0025-0000-0000-00000079DDCA
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
 arch/powerpc/kernel/ptrace.c        | 102 ++++++++++++++++++++++++++++++++++++
 2 files changed, 103 insertions(+)

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
index b279947..61a2581 100644
--- a/arch/powerpc/kernel/ptrace.c
+++ b/arch/powerpc/kernel/ptrace.c
@@ -1327,6 +1327,97 @@ static int tm_cvmx_set(struct task_struct *target,
 #endif	/* CONFIG_PPC_TRANSACTIONAL_MEM */
 
 /*
+ * get_misc_dbg
+ *
+ * This function gets miscellaneous debug registers
+ * which includes DSCR, PPR and TAR.
+ *
+ * Userspace intarface buffer layout:
+ *
+ * struct {
+ *	unsigned long dscr;
+ *	unsigned long ppr;
+ *	unsigned long tar;
+ * };
+ */
+static int get_misc_dbg(struct task_struct *target,
+			const struct user_regset *regset, unsigned int pos,
+			unsigned int count, void *kbuf, void __user *ubuf)
+{
+	int ret;
+
+	/* Build test */
+	BUILD_BUG_ON(TSO(dscr) + 2 * sizeof(unsigned long) != TSO(ppr));
+	BUILD_BUG_ON(TSO(ppr) + sizeof(unsigned long) != TSO(tar));
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
+	/* TAR register */
+	if (!ret)
+		ret = user_regset_copyout(&pos, &count, &kbuf, &ubuf,
+						&target->thread.tar,
+						2 * sizeof(unsigned long),
+						3 * sizeof(unsigned long));
+	return ret;
+}
+
+/*
+ * set_misc_dbg
+ *
+ * This function sets miscellaneous debug registers
+ * which includes DSCR, PPR and TAR.
+ *
+ * Userspace intarface buffer layout:
+ *
+ * struct {
+ *	unsigned long dscr;
+ *	unsigned long ppr;
+ *	unsigned long tar;
+ * };
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
+	BUILD_BUG_ON(TSO(ppr) + sizeof(unsigned long) != TSO(tar));
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
+
+	/* TAR register */
+	if (!ret)
+		ret = user_regset_copyin(&pos, &count, &kbuf, &ubuf,
+						&target->thread.tar,
+						2 * sizeof(unsigned long),
+						3 * sizeof(unsigned long));
+	return ret;
+}
+
+/*
  * These are our native regset flavors.
  */
 enum powerpc_regset {
@@ -1347,6 +1438,7 @@ enum powerpc_regset {
 	REGSET_TM_CFPR,		/* TM checkpointed FPR registers */
 	REGSET_TM_CVMX,		/* TM checkpointed VMX registers */
 #endif
+	REGSET_MISC		/* Miscellaneous debug registers */
 };
 
 static const struct user_regset native_regsets[] = {
@@ -1403,6 +1495,11 @@ static const struct user_regset native_regsets[] = {
 		.active = tm_cvmx_active, .get = tm_cvmx_get, .set = tm_cvmx_set
 	},
 #endif
+	[REGSET_MISC] = {
+		.core_note_type = NT_PPC_MISC, .n = ELF_NMISCREG,
+		.size = sizeof(u64), .align = sizeof(u64),
+		.get = get_misc_dbg, .set = set_misc_dbg
+	},
 };
 
 static const struct user_regset_view user_ppc_native_view = {
@@ -1646,6 +1743,11 @@ static const struct user_regset compat_regsets[] = {
 		.active = tm_cvmx_active, .get = tm_cvmx_get, .set = tm_cvmx_set
 	},
 #endif
+	[REGSET_MISC] = {
+		.core_note_type = NT_PPC_MISC, .n = ELF_NMISCREG,
+		.size = sizeof(u64), .align = sizeof(u64),
+		.get = get_misc_dbg, .set = set_misc_dbg
+	},
 };
 
 static const struct user_regset_view user_ppc_compat_view = {
-- 
1.9.3

