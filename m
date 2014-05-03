Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751245AbaECJjU (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 May 2014 05:39:20 -0400
Received: from www.linutronix.de ([62.245.132.108]:45424 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750831AbaECJjS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 May 2014 05:39:18 -0400
Date: Sat, 3 May 2014 11:39:31 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Ingo Molnar <mingo@kernel.org>, "H. Peter Anvin" <hpa@zytor.com>
Subject: [GIT pull] irq updates for 3.15
Message-ID: <alpine.DEB.2.02.1405031131340.6261@ionos.tec.linutronix.de>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

please pull the latest irq-urgent-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git irq-urgent-for-linus

This udpate delivers:

* A fix for dynamic interrupt allocation on x86 which is required to
  exclude the GSI interrupts from the dynamic allocatable range. This
  was detected with the newfangled tablet SoCs which have GPIOs and
  therefor allocate a range of interrupts. The MSI allocations already
  excluded the GSI range, so we never noticed before.

* The last missing set_irq_affinity() repair, which was delayed due to
  testing issues

* A few bug fixes for the armada SoC interrupt controller

* A memory allocation fix for the TI crossbar interrupt controller

* A trivial kernel-doc warning fix

Thanks,

	tglx

------------------>
Dan Carpenter (1):
      irqchip: irq-crossbar: Not allocating enough memory

Neil Greatorex (1):
      irqchip: armada-370-xp: Fix releasing of MSIs

Randy Dunlap (1):
      linux/interrupt.h: fix new kernel-doc warnings

Thomas Gleixner (2):
      genirq: x86: Ensure that dynamic irq allocation does not conflict
      irqchip: armanda: Sanitize set_irq_affinity()

Thomas Petazzoni (2):
      irqchip: armada-370-xp: fix invalid cast of signed value into unsigned variable
      irqchip: armada-370-xp: implement the ->check_device() msi_chip operation


 arch/x86/kernel/apic/io_apic.c      |    5 ++++
 drivers/irqchip/irq-armada-370-xp.c |   54 +++++++++++++----------------------
 drivers/irqchip/irq-crossbar.c      |    2 +-
 include/linux/interrupt.h           |    4 +--
 include/linux/irq.h                 |    2 ++
 kernel/irq/irqdesc.c                |    7 +++++
 kernel/softirq.c                    |    5 ++++
 7 files changed, 42 insertions(+), 37 deletions(-)

diff --git a/arch/x86/kernel/apic/io_apic.c b/arch/x86/kernel/apic/io_apic.c
index 6ad4658..d23aa82 100644
--- a/arch/x86/kernel/apic/io_apic.c
+++ b/arch/x86/kernel/apic/io_apic.c
@@ -3425,6 +3425,11 @@ int get_nr_irqs_gsi(void)
 	return nr_irqs_gsi;
 }
 
+unsigned int arch_dynirq_lower_bound(unsigned int from)
+{
+	return from < nr_irqs_gsi ? nr_irqs_gsi : from;
+}
+
 int __init arch_probe_nr_irqs(void)
 {
 	int nr;
diff --git a/drivers/irqchip/irq-armada-370-xp.c b/drivers/irqchip/irq-armada-370-xp.c
index 41be897..3899ba7 100644
--- a/drivers/irqchip/irq-armada-370-xp.c
+++ b/drivers/irqchip/irq-armada-370-xp.c
@@ -41,6 +41,7 @@
 #define ARMADA_370_XP_INT_SET_ENABLE_OFFS	(0x30)
 #define ARMADA_370_XP_INT_CLEAR_ENABLE_OFFS	(0x34)
 #define ARMADA_370_XP_INT_SOURCE_CTL(irq)	(0x100 + irq*4)
+#define ARMADA_370_XP_INT_SOURCE_CPU_MASK	0xF
 
 #define ARMADA_370_XP_CPU_INTACK_OFFS		(0x44)
 #define ARMADA_375_PPI_CAUSE			(0x10)
@@ -132,8 +133,7 @@ static int armada_370_xp_setup_msi_irq(struct msi_chip *chip,
 				       struct msi_desc *desc)
 {
 	struct msi_msg msg;
-	irq_hw_number_t hwirq;
-	int virq;
+	int virq, hwirq;
 
 	hwirq = armada_370_xp_alloc_msi();
 	if (hwirq < 0)
@@ -159,8 +159,19 @@ static void armada_370_xp_teardown_msi_irq(struct msi_chip *chip,
 					   unsigned int irq)
 {
 	struct irq_data *d = irq_get_irq_data(irq);
+	unsigned long hwirq = d->hwirq;
+
 	irq_dispose_mapping(irq);
-	armada_370_xp_free_msi(d->hwirq);
+	armada_370_xp_free_msi(hwirq);
+}
+
+static int armada_370_xp_check_msi_device(struct msi_chip *chip, struct pci_dev *dev,
+					  int nvec, int type)
+{
+	/* We support MSI, but not MSI-X */
+	if (type == PCI_CAP_ID_MSI)
+		return 0;
+	return -EINVAL;
 }
 
 static struct irq_chip armada_370_xp_msi_irq_chip = {
@@ -201,6 +212,7 @@ static int armada_370_xp_msi_init(struct device_node *node,
 
 	msi_chip->setup_irq = armada_370_xp_setup_msi_irq;
 	msi_chip->teardown_irq = armada_370_xp_teardown_msi_irq;
+	msi_chip->check_device = armada_370_xp_check_msi_device;
 	msi_chip->of_node = node;
 
 	armada_370_xp_msi_domain =
@@ -244,35 +256,18 @@ static DEFINE_RAW_SPINLOCK(irq_controller_lock);
 static int armada_xp_set_affinity(struct irq_data *d,
 				  const struct cpumask *mask_val, bool force)
 {
-	unsigned long reg;
-	unsigned long new_mask = 0;
-	unsigned long online_mask = 0;
-	unsigned long count = 0;
 	irq_hw_number_t hwirq = irqd_to_hwirq(d);
+	unsigned long reg, mask;
 	int cpu;
 
-	for_each_cpu(cpu, mask_val) {
-		new_mask |= 1 << cpu_logical_map(cpu);
-		count++;
-	}
-
-	/*
-	 * Forbid mutlicore interrupt affinity
-	 * This is required since the MPIC HW doesn't limit
-	 * several CPUs from acknowledging the same interrupt.
-	 */
-	if (count > 1)
-		return -EINVAL;
-
-	for_each_cpu(cpu, cpu_online_mask)
-		online_mask |= 1 << cpu_logical_map(cpu);
+	/* Select a single core from the affinity mask which is online */
+	cpu = cpumask_any_and(mask_val, cpu_online_mask);
+	mask = 1UL << cpu_logical_map(cpu);
 
 	raw_spin_lock(&irq_controller_lock);
-
 	reg = readl(main_int_base + ARMADA_370_XP_INT_SOURCE_CTL(hwirq));
-	reg = (reg & (~online_mask)) | new_mask;
+	reg = (reg & (~ARMADA_370_XP_INT_SOURCE_CPU_MASK)) | mask;
 	writel(reg, main_int_base + ARMADA_370_XP_INT_SOURCE_CTL(hwirq));
-
 	raw_spin_unlock(&irq_controller_lock);
 
 	return 0;
@@ -494,15 +489,6 @@ static int __init armada_370_xp_mpic_of_init(struct device_node *node,
 
 #ifdef CONFIG_SMP
 	armada_xp_mpic_smp_cpu_init();
-
-	/*
-	 * Set the default affinity from all CPUs to the boot cpu.
-	 * This is required since the MPIC doesn't limit several CPUs
-	 * from acknowledging the same interrupt.
-	 */
-	cpumask_clear(irq_default_affinity);
-	cpumask_set_cpu(smp_processor_id(), irq_default_affinity);
-
 #endif
 
 	armada_370_xp_msi_init(node, main_int_res.start);
diff --git a/drivers/irqchip/irq-crossbar.c b/drivers/irqchip/irq-crossbar.c
index fc817d2..3d15d16 100644
--- a/drivers/irqchip/irq-crossbar.c
+++ b/drivers/irqchip/irq-crossbar.c
@@ -107,7 +107,7 @@ static int __init crossbar_of_init(struct device_node *node)
 	int i, size, max, reserved = 0, entry;
 	const __be32 *irqsr;
 
-	cb = kzalloc(sizeof(struct cb_device *), GFP_KERNEL);
+	cb = kzalloc(sizeof(*cb), GFP_KERNEL);
 
 	if (!cb)
 		return -ENOMEM;
diff --git a/include/linux/interrupt.h b/include/linux/interrupt.h
index 8834a7e..97ac926 100644
--- a/include/linux/interrupt.h
+++ b/include/linux/interrupt.h
@@ -210,7 +210,7 @@ extern int __irq_set_affinity(unsigned int irq, const struct cpumask *cpumask,
 /**
  * irq_set_affinity - Set the irq affinity of a given irq
  * @irq:	Interrupt to set affinity
- * @mask:	cpumask
+ * @cpumask:	cpumask
  *
  * Fails if cpumask does not contain an online CPU
  */
@@ -223,7 +223,7 @@ irq_set_affinity(unsigned int irq, const struct cpumask *cpumask)
 /**
  * irq_force_affinity - Force the irq affinity of a given irq
  * @irq:	Interrupt to set affinity
- * @mask:	cpumask
+ * @cpumask:	cpumask
  *
  * Same as irq_set_affinity, but without checking the mask against
  * online cpus.
diff --git a/include/linux/irq.h b/include/linux/irq.h
index 10a0b1a..5c57efb 100644
--- a/include/linux/irq.h
+++ b/include/linux/irq.h
@@ -603,6 +603,8 @@ static inline u32 irq_get_trigger_type(unsigned int irq)
 	return d ? irqd_get_trigger_type(d) : 0;
 }
 
+unsigned int arch_dynirq_lower_bound(unsigned int from);
+
 int __irq_alloc_descs(int irq, unsigned int from, unsigned int cnt, int node,
 		struct module *owner);
 
diff --git a/kernel/irq/irqdesc.c b/kernel/irq/irqdesc.c
index a7174617..bb07f29 100644
--- a/kernel/irq/irqdesc.c
+++ b/kernel/irq/irqdesc.c
@@ -363,6 +363,13 @@ __irq_alloc_descs(int irq, unsigned int from, unsigned int cnt, int node,
 		if (from > irq)
 			return -EINVAL;
 		from = irq;
+	} else {
+		/*
+		 * For interrupts which are freely allocated the
+		 * architecture can force a lower bound to the @from
+		 * argument. x86 uses this to exclude the GSI space.
+		 */
+		from = arch_dynirq_lower_bound(from);
 	}
 
 	mutex_lock(&sparse_irq_lock);
diff --git a/kernel/softirq.c b/kernel/softirq.c
index b50990a..33e4648 100644
--- a/kernel/softirq.c
+++ b/kernel/softirq.c
@@ -779,3 +779,8 @@ int __init __weak arch_early_irq_init(void)
 {
 	return 0;
 }
+
+unsigned int __weak arch_dynirq_lower_bound(unsigned int from)
+{
+	return from;
+}
