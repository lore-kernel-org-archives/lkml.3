Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757122Ab3DPM5I (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Apr 2013 08:57:08 -0400
Received: from e28smtp01.in.ibm.com ([122.248.162.1]:35668 "EHLO
	e28smtp01.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756059Ab3DPM5B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Apr 2013 08:57:01 -0400
From: Anshuman Khandual <khandual@linux.vnet.ibm.com>
To: linuxppc-dev@ozlabs.org, linux-kernel@vger.kernel.org
Cc: michael@ellerman.id.au, mikey@neuling.org
Subject: [PATCH 2/5] powerpc, perf: Add basic assembly code to read BHRB entries on POWER8
Date: Tue, 16 Apr 2013 18:26:37 +0530
Message-Id: <1366117000-10979-3-git-send-email-khandual@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1366117000-10979-1-git-send-email-khandual@linux.vnet.ibm.com>
References: <1366117000-10979-1-git-send-email-khandual@linux.vnet.ibm.com>
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13041612-4790-0000-0000-000007E07B91
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Anshuman Khandual <khandual@linux.vnet.ibm.com>
---
 arch/powerpc/perf/Makefile |  2 +-
 arch/powerpc/perf/bhrb.S   | 34 ++++++++++++++++++++++++++++++++++
 2 files changed, 35 insertions(+), 1 deletion(-)
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
index 0000000..cffb815
--- /dev/null
+++ b/arch/powerpc/perf/bhrb.S
@@ -0,0 +1,34 @@
+#include <asm/ppc_asm.h>
+#include <asm/ppc-opcode.h>
+
+	.text
+
+.balign 8
+
+/* r3 = n  (where n = [0-1023])
+ * The maximum number of BHRB entries supported with PPC_MFBHRBE instruction
+ * is 1024. We have limited number of table entries here as POWER8 implements
+ * 32 BHRB entries.
+ */
+
+/* .global read_bhrb */
+_GLOBAL(read_bhrb)
+	cmpldi	r3,1023
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

