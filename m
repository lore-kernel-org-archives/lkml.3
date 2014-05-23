Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753522AbaEWPR7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 May 2014 11:17:59 -0400
Received: from e28smtp03.in.ibm.com ([122.248.162.3]:40816 "EHLO
	e28smtp03.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753491AbaEWPRn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 May 2014 11:17:43 -0400
From: Anshuman Khandual <khandual@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org,
        peterz@infradead.org, akpm@linux-foundation.org, tglx@linutronix.de
Cc: davem@davemloft.net, Paul.Clothier@imgtec.com, james.hogan@imgtec.com,
        avagin@openvz.org, oleg@redhat.com, palves@redhat.com,
        dhowells@redhat.com, davej@redhat.com, mikey@neuling.org,
        benh@kernel.crashing.org
Subject: [PATCH V3 3/3] powerpc, ptrace: Enable support for miscellaneous registers
Date: Fri, 23 May 2014 20:45:38 +0530
Message-Id: <1400858138-3939-4-git-send-email-khandual@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1400858138-3939-1-git-send-email-khandual@linux.vnet.ibm.com>
References: <1400858138-3939-1-git-send-email-khandual@linux.vnet.ibm.com>
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14052315-3864-0000-0000-00000E617844
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch enables get and set of miscellaneous registers through ptrace
PTRACE_GETREGSET/PTRACE_SETREGSET interface by implementing new powerpc
specific register set REGSET_MISC support corresponding to the new ELF
core note NT_PPC_MISC added previously in this regard.

Signed-off-by: Anshuman Khandual <khandual@linux.vnet.ibm.com>
---
 arch/powerpc/kernel/ptrace.c | 81 ++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 81 insertions(+)

diff --git a/arch/powerpc/kernel/ptrace.c b/arch/powerpc/kernel/ptrace.c
index 17642ef..63b883a 100644
--- a/arch/powerpc/kernel/ptrace.c
+++ b/arch/powerpc/kernel/ptrace.c
@@ -1149,6 +1149,76 @@ static int tm_cvmx_set(struct task_struct *target, const struct user_regset *reg
 #endif	/* CONFIG_PPC_TRANSACTIONAL_MEM */
 
 /*
+ * Miscellaneous Registers
+ *
+ * struct {
+ * 	unsigned long dscr;
+ *	unsigned long ppr;
+ * 	unsigned long tar;
+ * };
+ */
+static int misc_get(struct task_struct *target, const struct user_regset *regset,
+		   unsigned int pos, unsigned int count,
+		   void *kbuf, void __user *ubuf)
+{
+	int ret;
+
+	/* DSCR register */
+	ret = user_regset_copyout(&pos, &count, &kbuf, &ubuf,
+					&target->thread.dscr, 0,
+					sizeof(unsigned long));
+
+	BUILD_BUG_ON(offsetof(struct thread_struct, dscr) + sizeof(unsigned long) +
+				sizeof(unsigned long) != offsetof(struct thread_struct, ppr));
+
+	/* PPR register */
+	if (!ret)
+		ret = user_regset_copyout(&pos, &count, &kbuf, &ubuf,
+					  &target->thread.ppr, sizeof(unsigned long),
+					  2 * sizeof(unsigned long));
+
+	BUILD_BUG_ON(offsetof(struct thread_struct, ppr) + sizeof(unsigned long)
+						!= offsetof(struct thread_struct, tar));
+	/* TAR register */
+	if (!ret)
+		ret = user_regset_copyout(&pos, &count, &kbuf, &ubuf,
+					  &target->thread.tar, 2 * sizeof(unsigned long),
+					  3 * sizeof(unsigned long));
+	return ret;
+}
+
+static int misc_set(struct task_struct *target, const struct user_regset *regset,
+		   unsigned int pos, unsigned int count,
+		   const void *kbuf, const void __user *ubuf)
+{
+	int ret;
+
+	/* DSCR register */
+	ret = user_regset_copyin(&pos, &count, &kbuf, &ubuf,
+					&target->thread.dscr, 0,
+					sizeof(unsigned long));
+
+	BUILD_BUG_ON(offsetof(struct thread_struct, dscr) + sizeof(unsigned long) +
+			sizeof(unsigned long) != offsetof(struct thread_struct, ppr));
+
+	/* PPR register */
+	if (!ret)
+		ret = user_regset_copyin(&pos, &count, &kbuf, &ubuf,
+						&target->thread.ppr, sizeof(unsigned long),
+						2 * sizeof(unsigned long));
+
+	BUILD_BUG_ON(offsetof(struct thread_struct, ppr) + sizeof(unsigned long)
+						!= offsetof(struct thread_struct, tar));
+
+	/* TAR register */
+	if (!ret)
+		ret = user_regset_copyin(&pos, &count, &kbuf, &ubuf,
+						&target->thread.tar, 2 * sizeof(unsigned long),
+						3 * sizeof(unsigned long));
+	return ret;
+}
+
+/*
  * These are our native regset flavors.
  */
 enum powerpc_regset {
@@ -1169,6 +1239,7 @@ enum powerpc_regset {
 	REGSET_TM_CFPR,		/* TM checkpointed FPR */
 	REGSET_TM_CVMX,		/* TM checkpointed VMX */
 #endif
+	REGSET_MISC		/* Miscellaneous */
 };
 
 static const struct user_regset native_regsets[] = {
@@ -1225,6 +1296,11 @@ static const struct user_regset native_regsets[] = {
 		.active = tm_cvmx_active, .get = tm_cvmx_get, .set = tm_cvmx_set
 	},
 #endif
+	[REGSET_MISC] = {
+		.core_note_type = NT_PPC_MISC, .n = 3,
+		.size = sizeof(u64), .align = sizeof(u64),
+		.get = misc_get, .set = misc_set
+	},
 };
 
 static const struct user_regset_view user_ppc_native_view = {
@@ -1566,6 +1642,11 @@ static const struct user_regset compat_regsets[] = {
 		.active = tm_cvmx_active, .get = tm_cvmx_get, .set = tm_cvmx_set
 	},
 #endif
+	[REGSET_MISC] = {
+		.core_note_type = NT_PPC_MISC, .n = 3,
+		.size = sizeof(u64), .align = sizeof(u64),
+		.get = misc_get, .set = misc_set
+	},
 };
 
 static const struct user_regset_view user_ppc_compat_view = {
-- 
1.7.11.7

