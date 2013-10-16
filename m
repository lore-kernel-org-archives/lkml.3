Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759125Ab3JPCHQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Oct 2013 22:07:16 -0400
Received: from e35.co.us.ibm.com ([32.97.110.153]:33118 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758585Ab3JPCHK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Oct 2013 22:07:10 -0400
From: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: <linux-kernel@vger.kernel.org>, linuxppc-dev@ozlabs.org,
        Stephane Eranian <eranian@google.com>,
        Michael Ellerman <michaele@au1.ibm.com>,
        Paul Mackerras <paulus@samba.org>,
        Anshuman Khandual <khandual@linux.vnet.ibm.com>
Subject: [PATCH 02/10][v6] powerpc/Power7: detect load/store instructions
Date: Tue, 15 Oct 2013 19:06:34 -0700
Message-Id: <1381889202-16826-3-git-send-email-sukadev@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1381889202-16826-1-git-send-email-sukadev@linux.vnet.ibm.com>
References: <1381889202-16826-1-git-send-email-sukadev@linux.vnet.ibm.com>
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13101602-6688-0000-0000-00000293B355
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Implement instr_is_load_store_2_06() to detect whether a given instruction
is one of the fixed-point or floating-point load/store instructions in the
POWER Instruction Set Architecture v2.06.

This function will be used in a follow-on patch to save memory hierarchy
information of the load/store on a Power7 system. (Power8 systems set some
bits in the SIER to identify load/store operations and hence don't need a
similar functionality).

Based on optimized code from Michael Ellerman and comments from Tom Musta.

Signed-off-by: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
---
Changelog[v6]
	- [Michael Ellerman, Tom Musta]: Optmize the implementation to
	  avoid for loop.

 arch/powerpc/include/asm/code-patching.h |    1 +
 arch/powerpc/lib/code-patching.c         |   45 ++++++++++++++++++++++++++++++
 2 files changed, 46 insertions(+)

diff --git a/arch/powerpc/include/asm/code-patching.h b/arch/powerpc/include/asm/code-patching.h
index a6f8c7a..9cc3ef1 100644
--- a/arch/powerpc/include/asm/code-patching.h
+++ b/arch/powerpc/include/asm/code-patching.h
@@ -34,6 +34,7 @@ int instr_is_branch_to_addr(const unsigned int *instr, unsigned long addr);
 unsigned long branch_target(const unsigned int *instr);
 unsigned int translate_branch(const unsigned int *dest,
 			      const unsigned int *src);
+int instr_is_load_store_2_06(const unsigned int *instr);
 
 static inline unsigned long ppc_function_entry(void *func)
 {
diff --git a/arch/powerpc/lib/code-patching.c b/arch/powerpc/lib/code-patching.c
index 2bc9db3..49fb9d7 100644
--- a/arch/powerpc/lib/code-patching.c
+++ b/arch/powerpc/lib/code-patching.c
@@ -159,6 +159,51 @@ unsigned int translate_branch(const unsigned int *dest, const unsigned int *src)
 	return 0;
 }
 
+/*
+ * Determine if the op code in the instruction corresponds to a load or
+ * store instruction. Ignore the vector load instructions like evlddepx,
+ * evstddepx for now.
+ *
+ * This function is valid for POWER ISA 2.06.
+ *
+ * Reference:	PowerISA_V2.06B_Public.pdf, Sections 3.3.2 through 3.3.6
+ *		and 4.6.2 through 4.6.4, Appendix F (Opcode Maps).
+ */
+int instr_is_load_store_2_06(const unsigned int *instr)
+{
+	unsigned int op, upper, lower;
+
+	op = instr_opcode(*instr);
+
+	if ((op >= 32 && op <= 58) || (op == 61 || op == 62))
+		return true;
+
+	if (op != 31)
+		return false;
+
+	upper = op >> 5;
+	lower = op & 0x1f;
+
+	/* Short circuit as many misses as we can */
+	if (lower < 3 || lower > 23)
+		return false;
+
+	if (lower == 3) {
+		if (upper >= 16)
+			return true;
+
+		return false;
+	}
+
+	if (lower == 7 || lower == 12)
+		return true;
+
+	if (lower >= 20) /* && lower <= 23 (implicit) */
+		return true;
+
+	return false;
+}
+
 
 #ifdef CONFIG_CODE_PATCHING_SELFTEST
 
-- 
1.7.9.5

