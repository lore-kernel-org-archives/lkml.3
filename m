Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755369Ab3DWFng (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Apr 2013 01:43:36 -0400
Received: from e28smtp06.in.ibm.com ([122.248.162.6]:47561 "EHLO
	e28smtp06.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754857Ab3DWFnL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Apr 2013 01:43:11 -0400
From: Anshuman Khandual <khandual@linux.vnet.ibm.com>
To: linuxppc-dev@ozlabs.org, linux-kernel@vger.kernel.org
Cc: michael@ellerman.id.au, mikey@neuling.org
Subject: [PATCH V4 2/5] powerpc, perf: Add basic assembly code to read BHRB entries on POWER8
Date: Tue, 23 Apr 2013 11:12:41 +0530
Message-Id: <1366695764-3073-3-git-send-email-khandual@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1366695764-3073-1-git-send-email-khandual@linux.vnet.ibm.com>
References: <1366695764-3073-1-git-send-email-khandual@linux.vnet.ibm.com>
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13042305-9574-0000-0000-000007918F20
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds the basic assembly code to read BHRB buffer. BHRB entries
are valid only after a PMU interrupt has happened (when MMCR0[PMAO]=1)
and BHRB has been freezed. BHRB read should not be attempted when it is
still enabled (MMCR0[PMAE]=1) and getting updated, as this can produce
non-deterministic results.

Signed-off-by: Anshuman Khandual <khandual@linux.vnet.ibm.com>
---
 arch/powerpc/perf/Makefile |  2 +-
 arch/powerpc/perf/bhrb.S   | 44 ++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 45 insertions(+), 1 deletion(-)
 create mode 100644 arch/powerpc/perf/bhrb.S

diff --git a/arch/powerpc/perf/Makefile b/arch/powerpc/perf/Makefile
index 472db18..510fae1 100644
--- a/arch/powerpc/perf/Makefile
+++ b/arch/powerpc/perf/Makefile
@@ -2,7 +2,7 @@ subdir-ccflags-$(CONFIG_PPC_WERROR) := -Werror
 
 obj-$(CONFIG_PERF_EVENTS)	+= callchain.o
 
-obj-$(CONFIG_PPC_PERF_CTRS)	+= core-book3s.o
+obj-$(CONFIG_PPC_PERF_CTRS)	+= core-book3s.o bhrb.o
 obj64-$(CONFIG_PPC_PERF_CTRS)	+= power4-pmu.o ppc970-pmu.o power5-pmu.o \
 				   power5+-pmu.o power6-pmu.o power7-pmu.o \
 				   power8-pmu.o
diff --git a/arch/powerpc/perf/bhrb.S b/arch/powerpc/perf/bhrb.S
new file mode 100644
index 0000000..d85f9a5
--- /dev/null
+++ b/arch/powerpc/perf/bhrb.S
@@ -0,0 +1,44 @@
+/*
+ * Basic assembly code to read BHRB entries
+ *
+ * Copyright 2013 Anshuman Khandual, IBM Corporation.
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * as published by the Free Software Foundation; either version
+ * 2 of the License, or (at your option) any later version.
+ */
+#include <asm/ppc_asm.h>
+#include <asm/ppc-opcode.h>
+
+	.text
+
+.balign 8
+
+/* r3 = n  (where n = [0-31])
+ * The maximum number of BHRB entries supported with PPC_MFBHRBE instruction
+ * is 1024. We have limited number of table entries here as POWER8 implements
+ * 32 BHRB entries.
+ */
+
+/* .global read_bhrb */
+_GLOBAL(read_bhrb)
+	cmpldi	r3,31
+	bgt	1f
+	ld	r4,bhrb_table@got(r2)
+	sldi	r3,r3,3
+	add	r3,r4,r3
+	mtctr	r3
+	bctr
+1:	li	r3,0
+	blr
+
+#define MFBHRB_TABLE1(n) PPC_MFBHRBE(R3,n); blr
+#define MFBHRB_TABLE2(n) MFBHRB_TABLE1(n); MFBHRB_TABLE1(n+1)
+#define MFBHRB_TABLE4(n) MFBHRB_TABLE2(n); MFBHRB_TABLE2(n+2)
+#define MFBHRB_TABLE8(n) MFBHRB_TABLE4(n); MFBHRB_TABLE4(n+4)
+#define MFBHRB_TABLE16(n) MFBHRB_TABLE8(n); MFBHRB_TABLE8(n+8)
+#define MFBHRB_TABLE32(n) MFBHRB_TABLE16(n); MFBHRB_TABLE16(n+16)
+
+bhrb_table:
+	MFBHRB_TABLE32(0)
-- 
1.7.11.7

