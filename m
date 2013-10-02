Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753075Ab3JBAPz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Oct 2013 20:15:55 -0400
Received: from e38.co.us.ibm.com ([32.97.110.159]:50004 "EHLO
	e38.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752568Ab3JBAPd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Oct 2013 20:15:33 -0400
From: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: <linux-kernel@vger.kernel.org>, linuxppc-dev@ozlabs.org,
        Stephane Eranian <eranian@google.com>,
        Michael Ellerman <michaele@au1.ibm.com>,
        Paul Mackerras <paulus@samba.org>,
        Anshuman Khandual <khandual@linux.vnet.ibm.com>
Subject: [PATCH 5/9][v5] powerpc: implement is_instr_load_store().
Date: Tue,  1 Oct 2013 17:15:06 -0700
Message-Id: <1380672911-12812-6-git-send-email-sukadev@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1380672911-12812-1-git-send-email-sukadev@linux.vnet.ibm.com>
References: <1380672911-12812-1-git-send-email-sukadev@linux.vnet.ibm.com>
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13100200-1344-0000-0000-0000021574D9
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Implement is_instr_load_store() to detect whether a given instruction
is one of the fixed-point or floating-point load/store instructions.
This function will be used in a follow-on patch to save memory hierarchy
information of the load/store.

Signed-off-by: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
Reviewed-by: Anshuman Khandual <khandual@linux.vnet.ibm.com>
---
 arch/powerpc/include/asm/code-patching.h |    1 +
 arch/powerpc/lib/code-patching.c         |   90 ++++++++++++++++++++++++++++++
 2 files changed, 91 insertions(+)

diff --git a/arch/powerpc/include/asm/code-patching.h b/arch/powerpc/include/asm/code-patching.h
index a6f8c7a..3e47fe0 100644
--- a/arch/powerpc/include/asm/code-patching.h
+++ b/arch/powerpc/include/asm/code-patching.h
@@ -34,6 +34,7 @@ int instr_is_branch_to_addr(const unsigned int *instr, unsigned long addr);
 unsigned long branch_target(const unsigned int *instr);
 unsigned int translate_branch(const unsigned int *dest,
 			      const unsigned int *src);
+int instr_is_load_store(const unsigned int *instr);
 
 static inline unsigned long ppc_function_entry(void *func)
 {
diff --git a/arch/powerpc/lib/code-patching.c b/arch/powerpc/lib/code-patching.c
index 2bc9db3..7e5dc6f 100644
--- a/arch/powerpc/lib/code-patching.c
+++ b/arch/powerpc/lib/code-patching.c
@@ -159,6 +159,96 @@ unsigned int translate_branch(const unsigned int *dest, const unsigned int *src)
 	return 0;
 }
 
+static unsigned int load_store_xval(const unsigned int instr)
+{
+	return (instr >> 1) & 0x3FF;	/* bits 21..30 */
+}
+
+/*
+ * Values of bits 21:30 of Fixed-point and Floating-point Load and Store
+ * instructions.
+ *
+ * Reference:	PowerISA_V2.06B_Public.pdf, Sections 3.3.2 through 3.3.6 and
+ *		4.6.2 through 4.6.4.
+ */
+#define	x_lbzx		87
+#define	x_lbzux		119
+#define	x_lhzx		279
+#define	x_lhzux		311
+#define	x_lhax		343
+#define	x_lhaux		375
+#define	x_lwzx		23
+#define	x_lwzux		55
+#define	x_lwax		341
+#define	x_lwaux		373
+#define	x_ldx		21
+#define	x_ldux		53
+#define	x_stbx		215
+#define	x_stbux		247
+#define	x_sthx		407
+#define	x_sthux		439
+#define	x_stwx		151
+#define	x_stwux		183
+#define	x_stdx		149
+#define	x_stdux		181
+#define	x_lhbrx		790
+#define	x_lwbrx		534
+#define	x_sthbrx	918
+#define	x_stwbrx	662
+#define	x_ldbrx		532
+#define	x_stdbrx	660
+#define	x_lswi		597
+#define	x_lswx		533
+#define	x_stswi		725
+#define	x_stswx		661
+#define	x_lfsx		535
+#define	x_lfsux		567
+#define	x_lfdx		599
+#define	x_lfdux		631
+#define	x_lfiwax	855
+#define	x_lfiwzx	887
+#define	x_stfsx		663
+#define	x_stfsux	695
+#define	x_stfdx		727
+#define	x_stfdux	759
+#define	x_stfiwax	983
+#define	x_lfdpx		791
+#define	x_stfdpx	919
+
+static unsigned int x_form_load_store[] = {
+	x_lbzx,     x_lbzux,    x_lhzx,     x_lhzux,    x_lhax,
+	x_lhaux,    x_lwzx,     x_lwzux,    x_lwax,     x_lwaux,
+	x_ldx,      x_ldux,     x_stbx,     x_stbux,    x_sthx,
+	x_sthux,    x_stwx,     x_stwux,    x_stdx,     x_stdux,
+	x_lhbrx,    x_lwbrx,    x_sthbrx,   x_stwbrx,   x_ldbrx,
+	x_stdbrx,   x_lswi,     x_lswx,     x_stswi,    x_stswx,
+	x_lfsx,     x_lfsux,    x_lfdx,     x_lfdux,    x_lfiwax,
+	x_lfiwzx,   x_stfsx,    x_stfsux,   x_stfdx,    x_stfdux,
+	x_stfiwax,  x_lfdpx,    x_stfdpx
+};
+
+int instr_is_load_store(const unsigned int *instr)
+{
+	unsigned int op;
+	int i, n;
+
+	op = instr_opcode(*instr);
+
+	if ((op >= 32 && op <= 58) || (op == 61 || op == 62))
+		return 1;
+
+	if (op == 31) {
+		n = sizeof(x_form_load_store) / sizeof(int);
+
+		for (i = 0; i < n; i++) {
+			if (x_form_load_store[i] == load_store_xval(*instr))
+				return 1;
+		}
+	}
+
+	return 0;
+}
+
 
 #ifdef CONFIG_CODE_PATCHING_SELFTEST
 
-- 
1.7.9.5

