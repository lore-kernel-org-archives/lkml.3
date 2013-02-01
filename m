Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756662Ab3BAL7g (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Feb 2013 06:59:36 -0500
Received: from multi.imgtec.com ([194.200.65.239]:31909 "EHLO multi.imgtec.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756140Ab3BAL6U (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Feb 2013 06:58:20 -0500
From: James Hogan <james.hogan@imgtec.com>
To: <linux-kernel@vger.kernel.org>
CC: James Hogan <james.hogan@imgtec.com>
Subject: [PATCH 5/6] metag: make TXPRIVEXT bits explicit
Date: Fri, 1 Feb 2013 11:49:09 +0000
Message-ID: <1359719350-24560-6-git-send-email-james.hogan@imgtec.com>
X-Mailer: git-send-email 1.7.7.6
In-Reply-To: <1359719350-24560-1-git-send-email-james.hogan@imgtec.com>
References: <1359719350-24560-1-git-send-email-james.hogan@imgtec.com>
MIME-Version: 1.0
Content-Type: text/plain
X-SEF-Processed: 7_3_0_01181__2013_02_01_11_58_17
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Define PRIV_BITS using explicit constants from <asm/metag_regs.h> rather
than with a hard coded value. This also adds a couple of missing
definitions for the TXPRIVEXT priv bits for protecting writes to TXTIMER
and the trace registers.

Signed-off-by: James Hogan <james.hogan@imgtec.com>
---
 arch/metag/include/asm/metag_regs.h |    4 ++++
 arch/metag/kernel/setup.c           |   34 +++++++++++++++++++++++++++-------
 2 files changed, 31 insertions(+), 7 deletions(-)

diff --git a/arch/metag/include/asm/metag_regs.h b/arch/metag/include/asm/metag_regs.h
index 022fcad..acf4b8e 100644
--- a/arch/metag/include/asm/metag_regs.h
+++ b/arch/metag/include/asm/metag_regs.h
@@ -414,6 +414,10 @@
 #define TXPRIVEXT_REGNUM 29
 #define     TXPRIVEXT_COPRO_BITS    0xFF000000 /* Co-processor 0-7 */
 #define     TXPRIVEXT_COPRO_S       24
+#ifndef METAC_1_2
+#define     TXPRIVEXT_TXTIMER_BIT   0x00080000 /* TXTIMER   priv */
+#define     TXPRIVEXT_TRACE_BIT     0x00040000 /* TTEXEC|TTCTRL|GTEXEC */
+#endif
 #define     TXPRIVEXT_TXTRIGGER_BIT 0x00020000 /* TXSTAT|TXMASK|TXPOLL */
 #define     TXPRIVEXT_TXGBLCREG_BIT 0x00010000 /* Global common regs */
 #define     TXPRIVEXT_CBPRIV_BIT    0x00008000 /* Mem i/f dump priv */
diff --git a/arch/metag/kernel/setup.c b/arch/metag/kernel/setup.c
index aaebc56..dcb1d6d 100644
--- a/arch/metag/kernel/setup.c
+++ b/arch/metag/kernel/setup.c
@@ -35,6 +35,7 @@
 #include <asm/hwthread.h>
 #include <asm/l2cache.h>
 #include <asm/mach/arch.h>
+#include <asm/metag_regs.h>
 #include <asm/mmu.h>
 #include <asm/mmzone.h>
 #include <asm/processor.h>
@@ -43,18 +44,37 @@
 #include <asm/setup.h>
 #include <asm/traps.h>
 
-/* PRIV protect as many registers as possible. */
-#define DEFAULT_PRIV	0xff0f7f00
-
-/* Enable unaligned access checking. */
-#define UNALIGNED_PRIV	0x00000010
+/* Priv protect as many registers as possible. */
+#define DEFAULT_PRIV	(TXPRIVEXT_COPRO_BITS		| \
+			 TXPRIVEXT_TXTRIGGER_BIT	| \
+			 TXPRIVEXT_TXGBLCREG_BIT	| \
+			 TXPRIVEXT_ILOCK_BIT		| \
+			 TXPRIVEXT_TXITACCYC_BIT	| \
+			 TXPRIVEXT_TXDIVTIME_BIT	| \
+			 TXPRIVEXT_TXAMAREGX_BIT	| \
+			 TXPRIVEXT_TXTIMERI_BIT		| \
+			 TXPRIVEXT_TXSTATUS_BIT		| \
+			 TXPRIVEXT_TXDISABLE_BIT)
+
+/* Meta2 specific bits. */
+#ifdef CONFIG_METAG_META12
+#define META2_PRIV	0
+#else
+#define META2_PRIV	(TXPRIVEXT_TXTIMER_BIT		| \
+			 TXPRIVEXT_TRACE_BIT)
+#endif
 
+/* Unaligned access checking bits. */
 #ifdef CONFIG_METAG_UNALIGNED
-#define PRIV_BITS (DEFAULT_PRIV | UNALIGNED_PRIV)
+#define UNALIGNED_PRIV	TXPRIVEXT_ALIGNREW_BIT
 #else
-#define PRIV_BITS DEFAULT_PRIV
+#define UNALIGNED_PRIV	0
 #endif
 
+#define PRIV_BITS 	(DEFAULT_PRIV			| \
+			 META2_PRIV			| \
+			 UNALIGNED_PRIV)
+
 extern char _heap_start[];
 
 #ifdef CONFIG_METAG_BUILTIN_DTB
-- 
1.7.7.6


