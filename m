Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754920Ab3CONzy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Mar 2013 09:55:54 -0400
Received: from multi.imgtec.com ([194.200.65.239]:35783 "EHLO multi.imgtec.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754460Ab3CONzN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Mar 2013 09:55:13 -0400
From: James Hogan <james.hogan@imgtec.com>
To: <linux-kernel@vger.kernel.org>
CC: James Hogan <james.hogan@imgtec.com>
Subject: [PATCH 1/3] metag: smp: copy cache partition and enable GCOn
Date: Fri, 15 Mar 2013 13:55:01 +0000
Message-ID: <1363355703-23654-2-git-send-email-james.hogan@imgtec.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1363355703-23654-1-git-send-email-james.hogan@imgtec.com>
References: <1363355703-23654-1-git-send-email-james.hogan@imgtec.com>
MIME-Version: 1.0
Content-Type: text/plain
X-SEF-Processed: 7_3_0_01181__2013_03_15_13_55_10
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When starting an SMP hardware thread, copy the cache partition
configuration so that the threads share the same cache partitions. Also
enable the GCOn bit if running in the local half of the virtual address
space to enable coherency of shared local cache partitions. An atomic
unlock system event is executed by the new cpu before any memory is read
to ensure that any writes made by the boot cpu prior to full coherency
taking effect are visible to the new cpu.

This is to allow SMP to work even when the bootloader hasn't configured
the caches for coherency. A log message is printed to describe the cache
partition changes so that the user is aware of potential unintentional
cache wastage if they've configured the cache partitions in the wrong
way.

Signed-off-by: James Hogan <james.hogan@imgtec.com>
---
 arch/metag/include/asm/metag_mem.h |   3 +
 arch/metag/kernel/head.S           |   8 +++
 arch/metag/kernel/smp.c            | 115 +++++++++++++++++++++++++++++++++++++
 3 files changed, 126 insertions(+)

diff --git a/arch/metag/include/asm/metag_mem.h b/arch/metag/include/asm/metag_mem.h
index 3f7b54d..aa5a076 100644
--- a/arch/metag/include/asm/metag_mem.h
+++ b/arch/metag/include/asm/metag_mem.h
@@ -700,6 +700,9 @@
 #define     SYSC_xCPARTG_AND_S    8
 #define     SYSC_xCPARTL_OR_BITS  0x000F0000 /* Ors into top 4 bits */
 #define     SYSC_xCPARTL_OR_S     16
+#ifdef METAC_2_1
+#define     SYSC_DCPART_GCON_BIT  0x00100000 /* Coherent shared local */
+#endif /* METAC_2_1 */
 #define     SYSC_xCPARTG_OR_BITS  0x0F000000 /* Ors into top 4 bits */
 #define     SYSC_xCPARTG_OR_S     24
 #define     SYSC_CWRMODE_BIT      0x80000000 /* Write cache mode bit */
diff --git a/arch/metag/kernel/head.S b/arch/metag/kernel/head.S
index 969dffa..713f71d 100644
--- a/arch/metag/kernel/head.S
+++ b/arch/metag/kernel/head.S
@@ -1,6 +1,7 @@
 	! Copyright 2005,2006,2007,2009 Imagination Technologies
 
 #include <linux/init.h>
+#include <asm/metag_mem.h>
 #include <generated/asm-offsets.h>
 #undef __exit
 
@@ -48,6 +49,13 @@ __exit:
 	.global _secondary_startup
 	.type _secondary_startup,function
 _secondary_startup:
+#if CONFIG_PAGE_OFFSET < LINGLOBAL_BASE
+	! In case GCOn has just been turned on we need to fence any writes that
+	! the boot thread might have performed prior to coherency taking effect.
+	MOVT	D0Re0,#HI(LINSYSEVENT_WR_ATOMIC_UNLOCK)
+	MOV	D1Re0,#0
+	SETD	[D0Re0], D1Re0
+#endif
 	MOVT	A0StP,#HI(_secondary_data_stack)
 	ADD	A0StP,A0StP,#LO(_secondary_data_stack)
 	GETD	A0StP,[A0StP]
diff --git a/arch/metag/kernel/smp.c b/arch/metag/kernel/smp.c
index 4b6d1f14..4e7751a 100644
--- a/arch/metag/kernel/smp.c
+++ b/arch/metag/kernel/smp.c
@@ -28,6 +28,8 @@
 #include <asm/cachepart.h>
 #include <asm/core_reg.h>
 #include <asm/cpu.h>
+#include <asm/global_lock.h>
+#include <asm/metag_mem.h>
 #include <asm/mmu_context.h>
 #include <asm/pgtable.h>
 #include <asm/pgalloc.h>
@@ -37,6 +39,9 @@
 #include <asm/hwthread.h>
 #include <asm/traps.h>
 
+#define SYSC_DCPART(n)	(SYSC_DCPART0 + SYSC_xCPARTn_STRIDE * (n))
+#define SYSC_ICPART(n)	(SYSC_ICPART0 + SYSC_xCPARTn_STRIDE * (n))
+
 DECLARE_PER_CPU(PTBI, pTBI);
 
 void *secondary_data_stack;
@@ -99,6 +104,114 @@ int __cpuinit boot_secondary(unsigned int thread, struct task_struct *idle)
 	return 0;
 }
 
+/**
+ * describe_cachepart_change: describe a change to cache partitions.
+ * @thread:	Hardware thread number.
+ * @label:	Label of cache type, e.g. "dcache" or "icache".
+ * @sz:		Total size of the cache.
+ * @old:	Old cache partition configuration (*CPART* register).
+ * @new:	New cache partition configuration (*CPART* register).
+ *
+ * If the cache partition has changed, prints a message to the log describing
+ * those changes.
+ */
+static __cpuinit void describe_cachepart_change(unsigned int thread,
+						const char *label,
+						unsigned int sz,
+						unsigned int old,
+						unsigned int new)
+{
+	unsigned int lor1, land1, gor1, gand1;
+	unsigned int lor2, land2, gor2, gand2;
+	unsigned int diff = old ^ new;
+
+	if (!diff)
+		return;
+
+	pr_info("Thread %d: %s partition changed:", thread, label);
+	if (diff & (SYSC_xCPARTL_OR_BITS | SYSC_xCPARTL_AND_BITS)) {
+		lor1   = (old & SYSC_xCPARTL_OR_BITS)  >> SYSC_xCPARTL_OR_S;
+		lor2   = (new & SYSC_xCPARTL_OR_BITS)  >> SYSC_xCPARTL_OR_S;
+		land1  = (old & SYSC_xCPARTL_AND_BITS) >> SYSC_xCPARTL_AND_S;
+		land2  = (new & SYSC_xCPARTL_AND_BITS) >> SYSC_xCPARTL_AND_S;
+		pr_cont(" L:%#x+%#x->%#x+%#x",
+			(lor1 * sz) >> 4,
+			((land1 + 1) * sz) >> 4,
+			(lor2 * sz) >> 4,
+			((land2 + 1) * sz) >> 4);
+	}
+	if (diff & (SYSC_xCPARTG_OR_BITS | SYSC_xCPARTG_AND_BITS)) {
+		gor1   = (old & SYSC_xCPARTG_OR_BITS)  >> SYSC_xCPARTG_OR_S;
+		gor2   = (new & SYSC_xCPARTG_OR_BITS)  >> SYSC_xCPARTG_OR_S;
+		gand1  = (old & SYSC_xCPARTG_AND_BITS) >> SYSC_xCPARTG_AND_S;
+		gand2  = (new & SYSC_xCPARTG_AND_BITS) >> SYSC_xCPARTG_AND_S;
+		pr_cont(" G:%#x+%#x->%#x+%#x",
+			(gor1 * sz) >> 4,
+			((gand1 + 1) * sz) >> 4,
+			(gor2 * sz) >> 4,
+			((gand2 + 1) * sz) >> 4);
+	}
+	if (diff & SYSC_CWRMODE_BIT)
+		pr_cont(" %sWR",
+			(new & SYSC_CWRMODE_BIT) ? "+" : "-");
+	if (diff & SYSC_DCPART_GCON_BIT)
+		pr_cont(" %sGCOn",
+			(new & SYSC_DCPART_GCON_BIT) ? "+" : "-");
+	pr_cont("\n");
+}
+
+/**
+ * setup_smp_cache: ensure cache coherency for new SMP thread.
+ * @thread:	New hardware thread number.
+ *
+ * Ensures that coherency is enabled and that the threads share the same cache
+ * partitions.
+ */
+static __cpuinit void setup_smp_cache(unsigned int thread)
+{
+	unsigned int this_thread, lflags;
+	unsigned int dcsz, dcpart_this, dcpart_old, dcpart_new;
+	unsigned int icsz, icpart_old, icpart_new;
+
+	/*
+	 * Copy over the current thread's cache partition configuration to the
+	 * new thread so that they share cache partitions.
+	 */
+	__global_lock2(lflags);
+	this_thread = hard_processor_id();
+	/* Share dcache partition */
+	dcpart_this = metag_in32(SYSC_DCPART(this_thread));
+	dcpart_old = metag_in32(SYSC_DCPART(thread));
+	dcpart_new = dcpart_this;
+#if PAGE_OFFSET < LINGLOBAL_BASE
+	/*
+	 * For the local data cache to be coherent the threads must also have
+	 * GCOn enabled.
+	 */
+	dcpart_new |= SYSC_DCPART_GCON_BIT;
+	metag_out32(dcpart_new, SYSC_DCPART(this_thread));
+#endif
+	metag_out32(dcpart_new, SYSC_DCPART(thread));
+	/* Share icache partition too */
+	icpart_new = metag_in32(SYSC_ICPART(this_thread));
+	icpart_old = metag_in32(SYSC_ICPART(thread));
+	metag_out32(icpart_new, SYSC_ICPART(thread));
+	__global_unlock2(lflags);
+
+	/*
+	 * Log if the cache partitions were altered so the user is aware of any
+	 * potential unintentional cache wastage.
+	 */
+	dcsz = get_dcache_size();
+	icsz = get_dcache_size();
+	describe_cachepart_change(this_thread, "dcache", dcsz,
+				  dcpart_this, dcpart_new);
+	describe_cachepart_change(thread, "dcache", dcsz,
+				  dcpart_old, dcpart_new);
+	describe_cachepart_change(thread, "icache", icsz,
+				  icpart_old, icpart_new);
+}
+
 int __cpuinit __cpu_up(unsigned int cpu, struct task_struct *idle)
 {
 	unsigned int thread = cpu_2_hwthread_id[cpu];
@@ -108,6 +221,8 @@ int __cpuinit __cpu_up(unsigned int cpu, struct task_struct *idle)
 
 	flush_tlb_all();
 
+	setup_smp_cache(thread);
+
 	/*
 	 * Tell the secondary CPU where to find its idle thread's stack.
 	 */
-- 
1.8.1.2


