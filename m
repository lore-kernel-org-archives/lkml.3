Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756784Ab3BAL7E (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Feb 2013 06:59:04 -0500
Received: from multi.imgtec.com ([194.200.65.239]:31914 "EHLO multi.imgtec.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756283Ab3BAL6U (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Feb 2013 06:58:20 -0500
From: James Hogan <james.hogan@imgtec.com>
To: <linux-kernel@vger.kernel.org>
CC: James Hogan <james.hogan@imgtec.com>
Subject: [PATCH 6/6] metag: protect more non-MMU memory regions
Date: Fri, 1 Feb 2013 11:49:10 +0000
Message-ID: <1359719350-24560-7-git-send-email-james.hogan@imgtec.com>
X-Mailer: git-send-email 1.7.7.6
In-Reply-To: <1359719350-24560-1-git-send-email-james.hogan@imgtec.com>
References: <1359719350-24560-1-git-send-email-james.hogan@imgtec.com>
MIME-Version: 1.0
Content-Type: text/plain
X-SEF-Processed: 7_3_0_01181__2013_02_01_11_58_17
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rename setup_txprivext() to setup_priv() and add initialisation of some
more per-thread privilege protection registers:

 - TxPRIVSYSR: 0x04400000-0x047fffff
               0x05000000-0x07ffffff
               0x84000000-0x87ffffff
 - TxPIOREG:   0x02000000-0x02ffffff
               0x04800000-0x048fffff
 - TxSYREG:    0x04000000-0x04000fff (except write fetch system event)

Signed-off-by: James Hogan <james.hogan@imgtec.com>
---
 arch/metag/include/asm/processor.h |    2 +-
 arch/metag/kernel/setup.c          |   45 ++++++++++++++++++++++++++++++++----
 arch/metag/kernel/smp.c            |    2 +-
 3 files changed, 42 insertions(+), 7 deletions(-)

diff --git a/arch/metag/include/asm/processor.h b/arch/metag/include/asm/processor.h
index b7e2528..9b029a7 100644
--- a/arch/metag/include/asm/processor.h
+++ b/arch/metag/include/asm/processor.h
@@ -154,7 +154,7 @@ unsigned long get_wchan(struct task_struct *p);
 
 #define cpu_relax()     barrier()
 
-extern void setup_txprivext(void);
+extern void setup_priv(void);
 
 static inline unsigned int hard_processor_id(void)
 {
diff --git a/arch/metag/kernel/setup.c b/arch/metag/kernel/setup.c
index dcb1d6d..9803ca4 100644
--- a/arch/metag/kernel/setup.c
+++ b/arch/metag/kernel/setup.c
@@ -35,6 +35,7 @@
 #include <asm/hwthread.h>
 #include <asm/l2cache.h>
 #include <asm/mach/arch.h>
+#include <asm/metag_mem.h>
 #include <asm/metag_regs.h>
 #include <asm/mmu.h>
 #include <asm/mmzone.h>
@@ -75,6 +76,32 @@
 			 META2_PRIV			| \
 			 UNALIGNED_PRIV)
 
+/*
+ * Protect access to:
+ * 0x06000000-0x07ffffff Direct mapped region
+ * 0x05000000-0x05ffffff MMU table region (Meta1)
+ * 0x04400000-0x047fffff Cache flush region
+ * 0x84000000-0x87ffffff Core cache memory region (Meta2)
+ *
+ * Allow access to:
+ * 0x80000000-0x81ffffff Core code memory region (Meta2)
+ */
+#ifdef CONFIG_METAG_META12
+#define PRIVSYSR_BITS	TXPRIVSYSR_ALL_BITS
+#else
+#define PRIVSYSR_BITS	(TXPRIVSYSR_ALL_BITS & ~TXPRIVSYSR_CORECODE_BIT)
+#endif
+
+/* Protect all 0x02xxxxxx and 0x048xxxxx. */
+#define PIOREG_BITS	0xffffffff
+
+/*
+ * Protect all 0x04000xx0 (system events)
+ * except write combiner flush and write fence (system events 4 and 5).
+ */
+#define PSYREG_BITS	0xfffffffb
+
+
 extern char _heap_start[];
 
 #ifdef CONFIG_METAG_BUILTIN_DTB
@@ -371,7 +398,7 @@ void __init setup_arch(char **cmdline_p)
 
 	paging_init(heap_end);
 
-	setup_txprivext();
+	setup_priv();
 
 	/* Setup the boot cpu's mapping. The rest will be setup below. */
 	cpu_2_hwthread_id[smp_processor_id()] = hard_processor_id();
@@ -531,13 +558,21 @@ void __init metag_start_kernel(char *args)
 	start_kernel();
 }
 
-/*
- * Setup TXPRIVEXT register to be prevent userland from touching our
- * precious registers.
+/**
+ * setup_priv() - Set up privilege protection registers.
+ *
+ * Set up privilege protection registers such as TXPRIVEXT to prevent userland
+ * from touching our precious registers and sensitive memory areas.
  */
-void setup_txprivext(void)
+void setup_priv(void)
 {
+	unsigned int offset = hard_processor_id() << TXPRIVREG_STRIDE_S;
+
 	__core_reg_set(TXPRIVEXT, PRIV_BITS);
+
+	metag_out32(PRIVSYSR_BITS, T0PRIVSYSR + offset);
+	metag_out32(PIOREG_BITS,   T0PIOREG   + offset);
+	metag_out32(PSYREG_BITS,   T0PSYREG   + offset);
 }
 
 PTBI pTBI_get(unsigned int cpu)
diff --git a/arch/metag/kernel/smp.c b/arch/metag/kernel/smp.c
index d116312..4b6d1f14 100644
--- a/arch/metag/kernel/smp.c
+++ b/arch/metag/kernel/smp.c
@@ -268,7 +268,7 @@ asmlinkage void secondary_start_kernel(void)
 
 	preempt_disable();
 
-	setup_txprivext();
+	setup_priv();
 
 	/*
 	 * Enable local interrupts.
-- 
1.7.7.6


