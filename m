Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752204AbaKKPv6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2014 10:51:58 -0500
Received: from foss-mx-na.foss.arm.com ([217.140.108.86]:56167 "EHLO
	foss-mx-na.foss.arm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751460AbaKKPs2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2014 10:48:28 -0500
From: Marc Zyngier <marc.zyngier@arm.com>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Jiang Liu <jiang.liu@linux.intel.com>,
        Thomas Gleixner <tglx@linutronix.de>
Cc: Bjorn Helgaas <bhelgaas@google.com>,
        Yingjoe Chen <yingjoe.chen@mediatek.com>,
        Will Deacon <will.deacon@arm.com>,
        Catalin marinas <catalin.marinas@arm.com>,
        Mark Rutland <mark.rutland@arm.com>
Subject: [PATCH 05/15] irqchip: GICv3: rework redistributor structure
Date: Tue, 11 Nov 2014 15:48:03 +0000
Message-Id: <1415720893-13371-6-git-send-email-marc.zyngier@arm.com>
X-Mailer: git-send-email 2.0.4
In-Reply-To: <1415720893-13371-1-git-send-email-marc.zyngier@arm.com>
References: <1415720893-13371-1-git-send-email-marc.zyngier@arm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The basic GICv3 driver has almost no use for the redistributor
(other than the basic per-CPU interrupts), but the ITS needs
a lot more from them.

As such, rework the set of data structures. The behaviour of the
GICv3 driver is otherwise unaffected.

Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
---
 drivers/irqchip/irq-gic-v3.c       | 73 +++++++++++++++++++++++---------------
 include/linux/irqchip/arm-gic-v3.h | 15 ++++++++
 2 files changed, 59 insertions(+), 29 deletions(-)

diff --git a/drivers/irqchip/irq-gic-v3.c b/drivers/irqchip/irq-gic-v3.c
index a2770b6..c2cb081 100644
--- a/drivers/irqchip/irq-gic-v3.c
+++ b/drivers/irqchip/irq-gic-v3.c
@@ -34,20 +34,25 @@
 #include "irq-gic-common.h"
 #include "irqchip.h"
 
+struct redist_region {
+	void __iomem		*redist_base;
+	phys_addr_t		phys_base;
+};
+
 struct gic_chip_data {
 	void __iomem		*dist_base;
-	void __iomem		**redist_base;
-	void __iomem * __percpu	*rdist;
+	struct redist_region	*redist_regions;
+	struct rdists		rdists;
 	struct irq_domain	*domain;
 	u64			redist_stride;
-	u32			redist_regions;
+	u32			nr_redist_regions;
 	unsigned int		irq_nr;
 };
 
 static struct gic_chip_data gic_data __read_mostly;
 
-#define gic_data_rdist()		(this_cpu_ptr(gic_data.rdist))
-#define gic_data_rdist_rd_base()	(*gic_data_rdist())
+#define gic_data_rdist()		(this_cpu_ptr(gic_data.rdists.rdist))
+#define gic_data_rdist_rd_base()	(gic_data_rdist()->rd_base)
 #define gic_data_rdist_sgi_base()	(gic_data_rdist_rd_base() + SZ_64K)
 
 /* Our default, arbitrary priority value. Linux only uses one anyway. */
@@ -333,8 +338,8 @@ static int gic_populate_rdist(void)
 	       MPIDR_AFFINITY_LEVEL(mpidr, 1) << 8 |
 	       MPIDR_AFFINITY_LEVEL(mpidr, 0));
 
-	for (i = 0; i < gic_data.redist_regions; i++) {
-		void __iomem *ptr = gic_data.redist_base[i];
+	for (i = 0; i < gic_data.nr_redist_regions; i++) {
+		void __iomem *ptr = gic_data.redist_regions[i].redist_base;
 		u32 reg;
 
 		reg = readl_relaxed(ptr + GICR_PIDR2) & GIC_PIDR2_ARCH_MASK;
@@ -347,10 +352,13 @@ static int gic_populate_rdist(void)
 		do {
 			typer = readq_relaxed(ptr + GICR_TYPER);
 			if ((typer >> 32) == aff) {
+				u64 offset = ptr - gic_data.redist_regions[i].redist_base;
 				gic_data_rdist_rd_base() = ptr;
-				pr_info("CPU%d: found redistributor %llx @%p\n",
+				gic_data_rdist()->phys_base = gic_data.redist_regions[i].phys_base + offset;
+				pr_info("CPU%d: found redistributor %llx region %d:%pa\n",
 					smp_processor_id(),
-					(unsigned long long)mpidr, ptr);
+					(unsigned long long)mpidr,
+					i, &gic_data_rdist()->phys_base);
 				return 0;
 			}
 
@@ -675,9 +683,10 @@ static const struct irq_domain_ops gic_irq_domain_ops = {
 static int __init gic_of_init(struct device_node *node, struct device_node *parent)
 {
 	void __iomem *dist_base;
-	void __iomem **redist_base;
+	struct redist_region *rdist_regs;
 	u64 redist_stride;
-	u32 redist_regions;
+	u32 nr_redist_regions;
+	u32 typer;
 	u32 reg;
 	int gic_irqs;
 	int err;
@@ -698,48 +707,54 @@ static int __init gic_of_init(struct device_node *node, struct device_node *pare
 		goto out_unmap_dist;
 	}
 
-	if (of_property_read_u32(node, "#redistributor-regions", &redist_regions))
-		redist_regions = 1;
+	if (of_property_read_u32(node, "#redistributor-regions", &nr_redist_regions))
+		nr_redist_regions = 1;
 
-	redist_base = kzalloc(sizeof(*redist_base) * redist_regions, GFP_KERNEL);
-	if (!redist_base) {
+	rdist_regs = kzalloc(sizeof(*rdist_regs) * nr_redist_regions, GFP_KERNEL);
+	if (!rdist_regs) {
 		err = -ENOMEM;
 		goto out_unmap_dist;
 	}
 
-	for (i = 0; i < redist_regions; i++) {
-		redist_base[i] = of_iomap(node, 1 + i);
-		if (!redist_base[i]) {
+	for (i = 0; i < nr_redist_regions; i++) {
+		struct resource res;
+		int ret;
+
+		ret = of_address_to_resource(node, 1 + i, &res);
+		rdist_regs[i].redist_base = of_iomap(node, 1 + i);
+		if (ret || !rdist_regs[i].redist_base) {
 			pr_err("%s: couldn't map region %d\n",
 			       node->full_name, i);
 			err = -ENODEV;
 			goto out_unmap_rdist;
 		}
+		rdist_regs[i].phys_base = res.start;
 	}
 
 	if (of_property_read_u64(node, "redistributor-stride", &redist_stride))
 		redist_stride = 0;
 
 	gic_data.dist_base = dist_base;
-	gic_data.redist_base = redist_base;
-	gic_data.redist_regions = redist_regions;
+	gic_data.redist_regions = rdist_regs;
+	gic_data.nr_redist_regions = nr_redist_regions;
 	gic_data.redist_stride = redist_stride;
 
 	/*
 	 * Find out how many interrupts are supported.
 	 * The GIC only supports up to 1020 interrupt sources (SGI+PPI+SPI)
 	 */
-	gic_irqs = readl_relaxed(gic_data.dist_base + GICD_TYPER) & 0x1f;
-	gic_irqs = (gic_irqs + 1) * 32;
+	typer = readl_relaxed(gic_data.dist_base + GICD_TYPER);
+	gic_data.rdists.id_bits = GICD_TYPER_ID_BITS(typer);
+	gic_irqs = GICD_TYPER_IRQS(typer);
 	if (gic_irqs > 1020)
 		gic_irqs = 1020;
 	gic_data.irq_nr = gic_irqs;
 
 	gic_data.domain = irq_domain_add_tree(node, &gic_irq_domain_ops,
 					      &gic_data);
-	gic_data.rdist = alloc_percpu(typeof(*gic_data.rdist));
+	gic_data.rdists.rdist = alloc_percpu(typeof(*gic_data.rdists.rdist));
 
-	if (WARN_ON(!gic_data.domain) || WARN_ON(!gic_data.rdist)) {
+	if (WARN_ON(!gic_data.domain) || WARN_ON(!gic_data.rdists.rdist)) {
 		err = -ENOMEM;
 		goto out_free;
 	}
@@ -756,12 +771,12 @@ static int __init gic_of_init(struct device_node *node, struct device_node *pare
 out_free:
 	if (gic_data.domain)
 		irq_domain_remove(gic_data.domain);
-	free_percpu(gic_data.rdist);
+	free_percpu(gic_data.rdists.rdist);
 out_unmap_rdist:
-	for (i = 0; i < redist_regions; i++)
-		if (redist_base[i])
-			iounmap(redist_base[i]);
-	kfree(redist_base);
+	for (i = 0; i < nr_redist_regions; i++)
+		if (rdist_regs[i].redist_base)
+			iounmap(rdist_regs[i].redist_base);
+	kfree(rdist_regs);
 out_unmap_dist:
 	iounmap(dist_base);
 	return err;
diff --git a/include/linux/irqchip/arm-gic-v3.h b/include/linux/irqchip/arm-gic-v3.h
index 03a4ea3..040615a 100644
--- a/include/linux/irqchip/arm-gic-v3.h
+++ b/include/linux/irqchip/arm-gic-v3.h
@@ -49,6 +49,10 @@
 #define GICD_CTLR_ENABLE_G1A		(1U << 1)
 #define GICD_CTLR_ENABLE_G1		(1U << 0)
 
+#define GICD_TYPER_ID_BITS(typer)	((((typer) >> 19) & 0x1f) + 1)
+#define GICD_TYPER_IRQS(typer)		((((typer) & 0x1f) + 1) * 32)
+#define GICD_TYPER_LPIS			(1U << 17)
+
 #define GICD_IROUTER_SPI_MODE_ONE	(0U << 31)
 #define GICD_IROUTER_SPI_MODE_ANY	(1U << 31)
 
@@ -189,6 +193,17 @@
 
 #include <linux/stringify.h>
 
+struct rdists {
+	struct {
+		void __iomem	*rd_base;
+		struct page	*pend_page;
+		phys_addr_t	phys_base;
+	} __percpu		*rdist;
+	struct page		*prop_page;
+	int			id_bits;
+	u64			flags;
+};
+
 static inline void gic_write_eoir(u64 irq)
 {
 	asm volatile("msr_s " __stringify(ICC_EOIR1_EL1) ", %0" : : "r" (irq));
-- 
2.0.4

