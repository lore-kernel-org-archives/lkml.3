Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751885AbaH2WPA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Aug 2014 18:15:00 -0400
Received: from mail-qc0-f202.google.com ([209.85.216.202]:60175 "EHLO
	mail-qc0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751813AbaH2WO4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Aug 2014 18:14:56 -0400
From: Andrew Bresticker <abrestic@chromium.org>
To: Ralf Baechle <ralf@linux-mips.org>, Rob Herring <robh+dt@kernel.org>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>
Cc: Andrew Bresticker <abrestic@chromium.org>,
        Jeffrey Deans <jeffrey.deans@imgtec.com>,
        Markos Chandras <markos.chandras@imgtec.com>,
        Paul Burton <paul.burton@imgtec.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Jason Cooper <jason@lakedaemon.net>, linux-mips@linux-mips.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 12/12] MIPS: Malta: Map GIC local interrupts
Date: Fri, 29 Aug 2014 15:14:39 -0700
Message-Id: <1409350479-19108-13-git-send-email-abrestic@chromium.org>
X-Mailer: git-send-email 2.1.0.rc2.206.gedb03e5
In-Reply-To: <1409350479-19108-1-git-send-email-abrestic@chromium.org>
References: <1409350479-19108-1-git-send-email-abrestic@chromium.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now that the GIC driver properly supports local interrupts, extend
the static interrupt mapping to include the GIC timer and watchdog
and fix up the GIC interrupt setup and handling so that the local
interrupts are properly handled.  Note that ipi_map is also renamed
to gic_irq_map since it is now also used to track mapping of non-IPI
interrupts to CPUs.

Signed-off-by: Andrew Bresticker <abrestic@chromium.org>
---
 arch/mips/mti-malta/malta-int.c | 44 +++++++++++++++++++++++++++++++----------
 1 file changed, 34 insertions(+), 10 deletions(-)

diff --git a/arch/mips/mti-malta/malta-int.c b/arch/mips/mti-malta/malta-int.c
index e4f43ba..16b1473 100644
--- a/arch/mips/mti-malta/malta-int.c
+++ b/arch/mips/mti-malta/malta-int.c
@@ -38,7 +38,7 @@
 #include <asm/rtlx.h>
 
 static unsigned long _msc01_biu_base;
-static unsigned int ipi_map[NR_CPUS];
+static unsigned int gic_irq_map[NR_CPUS];
 
 static DEFINE_RAW_SPINLOCK(mips_irq_lock);
 
@@ -129,8 +129,8 @@ static void malta_hw0_irqdispatch(void)
 
 static void malta_ipi_irqdispatch(void)
 {
-#ifdef CONFIG_MIPS_GIC_IPI
 	unsigned long irq;
+#ifdef CONFIG_MIPS_GIC_IPI
 	DECLARE_BITMAP(pending, GIC_NUM_INTRS);
 
 	gic_get_int_mask(pending, ipi_ints);
@@ -143,8 +143,12 @@ static void malta_ipi_irqdispatch(void)
 		irq = find_next_bit(pending, GIC_NUM_INTRS, irq + 1);
 	}
 #endif
-	if (gic_compare_int())
-		do_IRQ(MIPS_GIC_IRQ_BASE);
+	irq = gic_get_local_int();
+	while (irq < GIC_NUM_LOCAL_INTRS) {
+		do_IRQ(MIPS_GIC_LOCAL_IRQ_BASE + irq);
+
+		irq = gic_get_local_int();
+	}
 }
 
 static void corehi_irqdispatch(void)
@@ -288,7 +292,7 @@ asmlinkage void plat_irq_dispatch(void)
 
 	if (irq == MIPSCPU_INT_I8259A)
 		malta_hw0_irqdispatch();
-	else if (gic_present && ((1 << irq) & ipi_map[smp_processor_id()]))
+	else if (gic_present && ((1 << irq) & gic_irq_map[smp_processor_id()]))
 		malta_ipi_irqdispatch();
 	else
 		do_IRQ(MIPS_CPU_IRQ_BASE + irq);
@@ -408,7 +412,7 @@ static int msc_nr_eicirqs __initdata = ARRAY_SIZE(msc_eicirqmap);
 #define GIC_CPU_NMI GIC_MAP_TO_NMI_MSK
 #define X GIC_UNUSED
 
-static struct gic_intr_map gic_intr_map[GIC_NUM_INTRS] = {
+static struct gic_intr_map gic_intr_map[GIC_NUM_INTRS + GIC_NUM_LOCAL_INTRS] = {
 	{ X, X,		   X,		X,		0 },
 	{ X, X,		   X,		X,		0 },
 	{ X, X,		   X,		X,		0 },
@@ -425,7 +429,10 @@ static struct gic_intr_map gic_intr_map[GIC_NUM_INTRS] = {
 	{ 0, GIC_CPU_NMI,  GIC_POL_POS, GIC_TRIG_LEVEL, GIC_FLAG_TRANSPARENT },
 	{ 0, GIC_CPU_NMI,  GIC_POL_POS, GIC_TRIG_LEVEL, GIC_FLAG_TRANSPARENT },
 	{ X, X,		   X,		X,		0 },
-	/* The remainder of this table is initialised by fill_ipi_map */
+	/*
+	 * The remainder of this table is initialised by fill_ipi_map and
+	 * fill_local_irq_map
+	 */
 };
 #undef X
 
@@ -438,7 +445,7 @@ static void __init fill_ipi_map1(int baseintr, int cpu, int cpupin)
 	gic_intr_map[intr].polarity = GIC_POL_POS;
 	gic_intr_map[intr].trigtype = GIC_TRIG_EDGE;
 	gic_intr_map[intr].flags = 0;
-	ipi_map[cpu] |= (1 << (cpupin + 2));
+	gic_irq_map[cpu] |= (1 << (cpupin + 2));
 	bitmap_set(ipi_ints, intr, 1);
 }
 
@@ -453,6 +460,22 @@ static void __init fill_ipi_map(void)
 }
 #endif
 
+static void __init fill_local_irq_map(void)
+{
+	int i;
+
+	for (i = 0; i < GIC_NUM_LOCAL_INTRS; i++) {
+		int intr = i + GIC_NUM_INTRS;
+
+		gic_intr_map[intr].cpunum = 0;
+		gic_intr_map[intr].pin = GIC_CPU_INT2;
+		gic_intr_map[intr].flags = 0;
+	}
+
+	for (i = 0; i < NR_CPUS; i++)
+		gic_irq_map[i] |= 1 << (GIC_CPU_INT2 + 2);
+}
+
 void __init arch_init_ipiirq(int irq, struct irqaction *action)
 {
 	setup_irq(irq, action);
@@ -533,6 +556,7 @@ void __init arch_init_irq(void)
 		gic_resched_int_base = gic_call_int_base - nr_cpu_ids;
 		fill_ipi_map();
 #endif
+		fill_local_irq_map();
 		gic_init(GIC_BASE_ADDR, GIC_ADDRSPACE_SZ, gic_intr_map,
 				ARRAY_SIZE(gic_intr_map), MIPS_GIC_IRQ_BASE);
 		if (!mips_cm_present()) {
@@ -542,8 +566,7 @@ void __init arch_init_irq(void)
 				(i | (0x1 << MSC01_SC_CFG_GICENA_SHF));
 			pr_debug("GIC Enabled\n");
 		}
-#if defined(CONFIG_MIPS_GIC_IPI)
-		/* set up ipi interrupts */
+		/* set up ipi and local interrupts */
 		if (cpu_has_vint) {
 			set_vi_handler(MIPSCPU_INT_IPI0, malta_ipi_irqdispatch);
 			set_vi_handler(MIPSCPU_INT_IPI1, malta_ipi_irqdispatch);
@@ -557,6 +580,7 @@ void __init arch_init_irq(void)
 		write_c0_status(0x1100dc00);
 		pr_info("CPU%d: status register frc %08x\n",
 			smp_processor_id(), read_c0_status());
+#if defined(CONFIG_MIPS_GIC_IPI)
 		for (i = 0; i < nr_cpu_ids; i++) {
 			arch_init_ipiirq(MIPS_GIC_IRQ_BASE +
 					 GIC_RESCHED_INT(i), &irq_resched);
-- 
2.1.0.rc2.206.gedb03e5

