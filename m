Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932237Ab3LDKfz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Dec 2013 05:35:55 -0500
Received: from e28smtp09.in.ibm.com ([122.248.162.9]:47556 "EHLO
	e28smtp09.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755528Ab3LDKdz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Dec 2013 05:33:55 -0500
From: Anshuman Khandual <khandual@linux.vnet.ibm.com>
To: linuxppc-dev@ozlabs.org, linux-kernel@vger.kernel.org
Cc: michael@ellerman.id.au, mikey@neuling.org, sukadev@linux.vnet.ibm.com,
        eranian@google.com, acme@ghostprotocols.net, ak@linux.intel.com,
        mingo@kernel.org
Subject: [PATCH V4 07/10] powerpc, lib: Add new branch instruction analysis support functions
Date: Wed,  4 Dec 2013 16:02:39 +0530
Message-Id: <1386153162-11225-8-git-send-email-khandual@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1386153162-11225-1-git-send-email-khandual@linux.vnet.ibm.com>
References: <1386153162-11225-1-git-send-email-khandual@linux.vnet.ibm.com>
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13120410-2674-0000-0000-00000BC2437C
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Generic powerpc branch instruction analysis support added in the code
patching library which will help the subsequent patch on SW based
filtering of branch records in perf. This patch also converts and
exports some of the existing local static functions through the header
file to be used else where.

Signed-off-by: Anshuman Khandual <khandual@linux.vnet.ibm.com>
---
 arch/powerpc/include/asm/code-patching.h | 30 ++++++++++++++++++
 arch/powerpc/lib/code-patching.c         | 54 ++++++++++++++++++++++++++++++--
 2 files changed, 82 insertions(+), 2 deletions(-)

diff --git a/arch/powerpc/include/asm/code-patching.h b/arch/powerpc/include/asm/code-patching.h
index a6f8c7a..8bab417 100644
--- a/arch/powerpc/include/asm/code-patching.h
+++ b/arch/powerpc/include/asm/code-patching.h
@@ -22,6 +22,36 @@
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
+/* Forms of branch instruction */
+int instr_is_branch_iform(unsigned int instr);
+int instr_is_branch_bform(unsigned int instr);
+int instr_is_branch_xlform(unsigned int instr);
+
+/* Classification of XL-form instruction */
+int is_xlform_lr(unsigned int instr);
+int is_xlform_ctr(unsigned int instr);
+int is_xlform_tar(unsigned int instr);
+
+/* Branch instruction is a call */
+int is_branch_link_set(unsigned int instr);
+
+/* BO field analysis (B-form or XL-form) */
+int is_bo_always(unsigned int instr);
+int is_bo_ctr(unsigned int instr);
+int is_bo_crbi_off(unsigned int instr);
+int is_bo_crbi_on(unsigned int instr);
+int is_bo_crbi_hint(unsigned int instr);
+
 unsigned int create_branch(const unsigned int *addr,
 			   unsigned long target, int flags);
 unsigned int create_cond_branch(const unsigned int *addr,
diff --git a/arch/powerpc/lib/code-patching.c b/arch/powerpc/lib/code-patching.c
index 17e5b23..cb62bd8 100644
--- a/arch/powerpc/lib/code-patching.c
+++ b/arch/powerpc/lib/code-patching.c
@@ -77,16 +77,66 @@ static unsigned int branch_opcode(unsigned int instr)
 	return (instr >> 26) & 0x3F;
 }
 
-static int instr_is_branch_iform(unsigned int instr)
+int instr_is_branch_iform(unsigned int instr)
 {
 	return branch_opcode(instr) == 18;
 }
 
-static int instr_is_branch_bform(unsigned int instr)
+int instr_is_branch_bform(unsigned int instr)
 {
 	return branch_opcode(instr) == 16;
 }
 
+int instr_is_branch_xlform(unsigned int instr)
+{
+	return branch_opcode(instr) == 19;
+}
+
+int is_xlform_lr(unsigned int instr)
+{
+	return (instr & XL_FORM_LR) == XL_FORM_LR;
+}
+
+int is_xlform_ctr(unsigned int instr)
+{
+	return (instr & XL_FORM_CTR) == XL_FORM_CTR;
+}
+
+int is_xlform_tar(unsigned int instr)
+{
+	return (instr & XL_FORM_TAR) == XL_FORM_TAR;
+}
+
+int is_branch_link_set(unsigned int instr)
+{
+	return (instr & BRANCH_SET_LINK) == BRANCH_SET_LINK;
+}
+
+int is_bo_always(unsigned int instr)
+{
+	return (instr & BO_ALWAYS) == BO_ALWAYS;
+}
+
+int is_bo_ctr(unsigned int instr)
+{
+	return (instr & BO_CTR) == BO_CTR;
+}
+
+int is_bo_crbi_off(unsigned int instr)
+{
+	return (instr & BO_CRBI_OFF) == BO_CRBI_OFF;
+}
+
+int is_bo_crbi_on(unsigned int instr)
+{
+	return (instr & BO_CRBI_ON) == BO_CRBI_ON;
+}
+
+int is_bo_crbi_hint(unsigned int instr)
+{
+	return (instr & BO_CRBI_HINT) == BO_CRBI_HINT;
+}
+
 int instr_is_relative_branch(unsigned int instr)
 {
 	if (instr & BRANCH_ABSOLUTE)
-- 
1.7.11.7

