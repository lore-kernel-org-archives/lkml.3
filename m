Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758174Ab3JQRVV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Oct 2013 13:21:21 -0400
Received: from e9.ny.us.ibm.com ([32.97.182.139]:41666 "EHLO e9.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754994Ab3JQRVU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Oct 2013 13:21:20 -0400
Date: Thu, 17 Oct 2013 10:20:50 -0700
From: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
To: David Laight <David.Laight@aculab.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Michael Ellerman <michaele@au1.ibm.com>, linux-kernel@vger.kernel.org,
        Stephane Eranian <eranian@google.com>, linuxppc-dev@ozlabs.org,
        Paul Mackerras <paulus@samba.org>,
        Anshuman Khandual <khandual@linux.vnet.ibm.com>
Subject: Re: [PATCH 02/10][v6] powerpc/Power7: detect load/store instructions
Message-ID: <20131017172050.GB9229@us.ibm.com>
References: <1381889202-16826-1-git-send-email-sukadev@linux.vnet.ibm.com>
 <1381889202-16826-3-git-send-email-sukadev@linux.vnet.ibm.com>
 <AE90C24D6B3A694183C094C60CF0A2F6026B738E@saturn3.aculab.com>
 <20131016152742.GB25073@us.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131016152742.GB25073@us.ibm.com>
X-Operating-System: Linux 2.0.32 on an i486
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13101717-7182-0000-0000-000008C8C883
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

| 
| How about I add this to the function header ?
| 
|  * Please use the table in Appendix F (opcode maps) to determine
|  * events selected by this function.

Here is the updated patch with the comment.
---

>From 38d1f9ac67a7f50db593e5875a8de6a2ecbea8e0 Mon Sep 17 00:00:00 2001
From: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
Date: Fri, 23 Aug 2013 18:35:02 -0700
Subject: [PATCH 6/10][v6] powerpc/Power7: detect load/store instructions

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
	- [David Laight, Anshuman Khandual] Add a comment in function
	  header to help better understand which instructions are selected
	  by the instr_is_load_store_2_06().
	- [Michael Ellerman, Tom Musta]: Optmize the implementation to
	  avoid for loop.

 arch/powerpc/include/asm/code-patching.h |    1 +
 arch/powerpc/lib/code-patching.c         |   48 ++++++++++++++++++++++++++++++
 2 files changed, 49 insertions(+)

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
index 2bc9db3..84571aa 100644
--- a/arch/powerpc/lib/code-patching.c
+++ b/arch/powerpc/lib/code-patching.c
@@ -159,6 +159,54 @@ unsigned int translate_branch(const unsigned int *dest, const unsigned int *src)
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
+ *
+ *		Use the tables in Appendix F (Opcode Maps) to identify
+ *		instructions selected by this function.
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

