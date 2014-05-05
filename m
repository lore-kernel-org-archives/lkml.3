Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756096AbaEEJNH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2014 05:13:07 -0400
Received: from e28smtp08.in.ibm.com ([122.248.162.8]:51733 "EHLO
	e28smtp08.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755630AbaEEJLD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2014 05:11:03 -0400
From: Anshuman Khandual <khandual@linux.vnet.ibm.com>
To: linuxppc-dev@ozlabs.org, linux-kernel@vger.kernel.org
Cc: michael@ellerman.id.au, mikey@neuling.org, ak@linux.intel.com,
        eranian@google.com, acme@ghostprotocols.net,
        sukadev@linux.vnet.ibm.com, mingo@kernel.org
Subject: [V6 08/11] powerpc, lib: Add new branch analysis support functions
Date: Mon,  5 May 2014 14:39:10 +0530
Message-Id: <1399280953-31442-9-git-send-email-khandual@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1399280953-31442-1-git-send-email-khandual@linux.vnet.ibm.com>
References: <1399280953-31442-1-git-send-email-khandual@linux.vnet.ibm.com>
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14050509-2000-0000-0000-0000111FA6F0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Generic powerpc branch analysis support added in the code patching
library which will help the subsequent patch on SW based filtering
of branch records in perf.

Signed-off-by: Anshuman Khandual <khandual@linux.vnet.ibm.com>
---
 arch/powerpc/include/asm/code-patching.h | 16 +++++++
 arch/powerpc/lib/code-patching.c         | 80 ++++++++++++++++++++++++++++++++
 2 files changed, 96 insertions(+)

diff --git a/arch/powerpc/include/asm/code-patching.h b/arch/powerpc/include/asm/code-patching.h
index 97e02f9..39919d4 100644
--- a/arch/powerpc/include/asm/code-patching.h
+++ b/arch/powerpc/include/asm/code-patching.h
@@ -22,6 +22,16 @@
 #define BRANCH_SET_LINK	0x1
 #define BRANCH_ABSOLUTE	0x2
 
+#define XL_FORM_LR  0x4C000020
+#define XL_FORM_CTR 0x4C000420
+#define XL_FORM_TAR 0x4C000460
+
+#define BO_ALWAYS    0x02800000
+#define BO_CTR       0x02000000
+#define BO_CRBI_OFF  0x00800000
+#define BO_CRBI_ON   0x01800000
+#define BO_CRBI_HINT 0x00400000
+
 unsigned int create_branch(const unsigned int *addr,
 			   unsigned long target, int flags);
 unsigned int create_cond_branch(const unsigned int *addr,
@@ -56,4 +66,10 @@ static inline unsigned long ppc_function_entry(void *func)
 #endif
 }
 
+/* Perf branch filters */
+bool instr_is_return_branch(unsigned int instr);
+bool instr_is_conditional_branch(unsigned int instr);
+bool instr_is_func_call(unsigned int instr);
+bool instr_is_indirect_func_call(unsigned int instr);
+
 #endif /* _ASM_POWERPC_CODE_PATCHING_H */
diff --git a/arch/powerpc/lib/code-patching.c b/arch/powerpc/lib/code-patching.c
index d5edbeb..a06f8b3 100644
--- a/arch/powerpc/lib/code-patching.c
+++ b/arch/powerpc/lib/code-patching.c
@@ -77,6 +77,7 @@ static unsigned int branch_opcode(unsigned int instr)
 	return (instr >> 26) & 0x3F;
 }
 
+/* Forms of branch instruction */
 static int instr_is_branch_iform(unsigned int instr)
 {
 	return branch_opcode(instr) == 18;
@@ -87,6 +88,85 @@ static int instr_is_branch_bform(unsigned int instr)
 	return branch_opcode(instr) == 16;
 }
 
+static int instr_is_branch_xlform(unsigned int instr)
+{
+	return branch_opcode(instr) == 19;
+}
+
+/* Classification of XL-form instruction */
+static int is_xlform_lr(unsigned int instr)
+{
+	return (instr & XL_FORM_LR) == XL_FORM_LR;
+}
+
+/* BO field analysis (B-form or XL-form) */
+static int is_bo_always(unsigned int instr)
+{
+	return (instr & BO_ALWAYS) == BO_ALWAYS;
+}
+
+/* Link bit is set */
+static int is_branch_link_set(unsigned int instr)
+{
+	return (instr & BRANCH_SET_LINK) == BRANCH_SET_LINK;
+}
+
+/* 
+ * Generic software implemented branch filters used
+ * by perf branch stack sampling when PMU does not
+ * process them for some reason.
+ */
+
+/* PERF_SAMPLE_BRANCH_ANY_RETURN */
+bool instr_is_return_branch(unsigned int instr)
+{
+	/*
+	 * Conditional and unconditional branch to LR register
+	 * without seting the link register.
+	 */
+	if (is_xlform_lr(instr) && !is_branch_link_set(instr))
+		return true;
+
+	return false;
+}
+
+/* PERF_SAMPLE_BRANCH_COND */
+bool instr_is_conditional_branch(unsigned int instr)
+{
+	/* I-form instruction - excluded */
+	if (instr_is_branch_iform(instr))
+		return false;
+
+	/* B-form or XL-form instruction */
+	if (instr_is_branch_bform(instr) || instr_is_branch_xlform(instr))  {
+
+		/* Not branch always */
+		if (!is_bo_always(instr))
+			return true;
+	}
+	return false;
+}
+
+/* PERF_SAMPLE_BRANCH_ANY_CALL */
+bool instr_is_func_call(unsigned int instr)
+{
+	/* LR should be set */
+	if (is_branch_link_set(instr))
+		return true;
+
+	return false;
+}
+
+/* PERF_SAMPLE_BRANCH_IND_CALL */
+bool instr_is_indirect_func_call(unsigned int instr)
+{
+	/* XL-form instruction with LR set */
+	if (instr_is_branch_xlform(instr) && is_branch_link_set(instr))
+		return true;
+
+	return false;
+}
+
 int instr_is_relative_branch(unsigned int instr)
 {
 	if (instr & BRANCH_ABSOLUTE)
-- 
1.7.11.7

