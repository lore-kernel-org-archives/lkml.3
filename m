Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932083AbaDBHFC (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Apr 2014 03:05:02 -0400
Received: from e23smtp06.au.ibm.com ([202.81.31.148]:56404 "EHLO
	e23smtp06.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757929AbaDBHFA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Apr 2014 03:05:00 -0400
From: Anshuman Khandual <khandual@linux.vnet.ibm.com>
To: linuxppc-dev@ozlabs.org, linux-kernel@vger.kernel.org
Cc: avagin@openvz.org, oleg@redhat.com, roland@redhat.com, mikey@neuling.org,
        benh@kernel.crashing.org,
        Anshuman Khandual <khandual@linux.vnet.ibm.com>
Subject: [PATCH 3/3] powerpc, ptrace: Add new ptrace request macro for miscellaneous registers
Date: Wed,  2 Apr 2014 12:32:24 +0530
Message-Id: <1396422144-11032-4-git-send-email-khandual@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1396422144-11032-1-git-send-email-khandual@linux.vnet.ibm.com>
References: <1396422144-11032-1-git-send-email-khandual@linux.vnet.ibm.com>
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14040207-7014-0000-0000-0000049BD023
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds following new set of ptrace request macros for miscellaneous
registers expanding the existing ptrace ABI on PowerPC.

	/* Miscellaneous registers */
	PTRACE_GETMSCREGS
	PTRACE_SETMSCREGS

Signed-off-by: Anshuman Khandual <khandual@linux.vnet.ibm.com>
---
 arch/powerpc/include/uapi/asm/ptrace.h | 10 ++++
 arch/powerpc/kernel/ptrace.c           | 91 +++++++++++++++++++++++++++++++++-
 2 files changed, 100 insertions(+), 1 deletion(-)

diff --git a/arch/powerpc/include/uapi/asm/ptrace.h b/arch/powerpc/include/uapi/asm/ptrace.h
index 1a12c36..bce1055 100644
--- a/arch/powerpc/include/uapi/asm/ptrace.h
+++ b/arch/powerpc/include/uapi/asm/ptrace.h
@@ -241,6 +241,16 @@ struct pt_regs {
 #define PTRACE_GETTM_CVMXREGS	0x76
 #define PTRACE_SETTM_CVMXREGS	0x77
 
+/* Miscellaneous registers */
+#define PTRACE_GETMSCREGS      0x78
+#define PTRACE_SETMSCREGS      0x79
+
+/*
+ * XXX: A note to application developers. The existing data layout
+ * of the above four ptrace requests can change when new registers
+ * are available for each category in forthcoming processors.
+ */
+
 #ifndef __ASSEMBLY__
 
 struct ppc_debug_info {
diff --git a/arch/powerpc/kernel/ptrace.c b/arch/powerpc/kernel/ptrace.c
index 9fbcb6a..2893958 100644
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
+		     		sizeof(unsigned long) != offsetof(struct thread_struct, ppr));
+
+	/* PPR register */
+	if (!ret)
+		ret = user_regset_copyout(&pos, &count, &kbuf, &ubuf,
+					  &target->thread.ppr, sizeof(unsigned long),
+					  2 * sizeof(unsigned long));
+
+	BUILD_BUG_ON(offsetof(struct thread_struct, ppr) + sizeof(unsigned long)
+		     			!= offsetof(struct thread_struct, tar));
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
+		     	sizeof(unsigned long) != offsetof(struct thread_struct, ppr));
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
@@ -1072,8 +1142,9 @@ enum powerpc_regset {
 	REGSET_TM_SPR,		/* TM specific SPR */
 	REGSET_TM_CGPR,		/* TM checkpointed GPR */
 	REGSET_TM_CFPR,		/* TM checkpointed FPR */
-	REGSET_TM_CVMX		/* TM checkpointed VMX */
+	REGSET_TM_CVMX,		/* TM checkpointed VMX */
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
@@ -1320,6 +1396,11 @@ static const struct user_regset compat_regsets[] = {
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
@@ -2269,6 +2350,14 @@ long arch_ptrace(struct task_struct *child, long request,
 		return copy_regset_from_user(child, &user_ppc_native_view,
 					   REGSET_TM_CVMX, 0, (33 * sizeof(vector128) + sizeof(u32)), datavp);
 #endif /* CONFIG_PPC_TRANSACTIONAL_MEM */
+	case PTRACE_GETMSCREGS:
+		return copy_regset_to_user(child, &user_ppc_native_view,
+					REGSET_MISC, 0, 3 * sizeof(u64),
+					datavp);
+	case PTRACE_SETMSCREGS:
+		return copy_regset_from_user(child, &user_ppc_native_view,
+					REGSET_MISC, 0, 3 * sizeof(u64),
+					datavp);
 	default:
 		ret = ptrace_request(child, request, addr, data);
 		break;
-- 
1.7.11.7

