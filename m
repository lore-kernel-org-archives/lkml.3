Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754983AbaEEH5E (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2014 03:57:04 -0400
Received: from e28smtp02.in.ibm.com ([122.248.162.2]:59646 "EHLO
	e28smtp02.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754840AbaEEH5C (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2014 03:57:02 -0400
From: Anshuman Khandual <khandual@linux.vnet.ibm.com>
To: linuxppc-dev@ozlabs.org, linux-kernel@vger.kernel.org
Cc: michael@ellerman.id.au, mikey@neuling.org, avagin@openvz.org,
        oleg@redhat.com, roland@redhat.com, palves@redhat.com,
        Anshuman Khandual <khandual@linux.vnet.ibm.com>
Subject: [PATCH V2 3/3] powerpc, ptrace: Enable support for miscellaneous registers
Date: Mon,  5 May 2014 13:24:29 +0530
Message-Id: <1399276469-13541-4-git-send-email-khandual@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1399276469-13541-1-git-send-email-khandual@linux.vnet.ibm.com>
References: <1399276469-13541-1-git-send-email-khandual@linux.vnet.ibm.com>
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14050507-5816-0000-0000-00000DD720C1
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
index 92faded..3332dd8 100644
--- a/arch/powerpc/kernel/ptrace.c
+++ b/arch/powerpc/kernel/ptrace.c
@@ -1054,6 +1054,76 @@ static int tm_cvmx_set(struct task_struct *target, const struct user_regset *reg
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
@@ -1074,6 +1144,7 @@ enum powerpc_regset {
 	REGSET_TM_CFPR,		/* TM checkpointed FPR */
 	REGSET_TM_CVMX,		/* TM checkpointed VMX */
 #endif
+	REGSET_MISC		/* Miscellaneous */
 };
 
 static const struct user_regset native_regsets[] = {
@@ -1130,6 +1201,11 @@ static const struct user_regset native_regsets[] = {
 		.get = tm_cvmx_get, .set = tm_cvmx_set
 	},
 #endif
+	[REGSET_MISC] = {
+		.core_note_type = NT_PPC_MISC, .n = 3,
+		.size = sizeof(u64), .align = sizeof(u64),
+		.get = misc_get, .set = misc_set
+	},
 };
 
 static const struct user_regset_view user_ppc_native_view = {
@@ -1459,6 +1535,11 @@ static const struct user_regset compat_regsets[] = {
 		.get = tm_cvmx_get, .set = tm_cvmx_set
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

