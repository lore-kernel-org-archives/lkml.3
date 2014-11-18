Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755197AbaKRSz6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Nov 2014 13:55:58 -0500
Received: from foss-mx-na.foss.arm.com ([217.140.108.86]:60691 "EHLO
	foss-mx-na.foss.arm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932079AbaKRSxf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Nov 2014 13:53:35 -0500
From: Marc Zyngier <marc.zyngier@arm.com>
To: Thomas Gleixner <tglx@linutronix.de>, Jason Cooper <jason@lakedaemon.net>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Jiang Liu <jiang.liu@linux.intel.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Yingjoe Chen <yingjoe.chen@mediatek.com>,
        Will Deacon <will.deacon@arm.com>,
        Catalin marinas <catalin.marinas@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Suravee Suthikulpanit <Suravee.Suthikulpanit@amd.com>,
        Robert Richter <robert.richter@caviumnetworks.com>,
        "Yun Wu (Abel)" <wuyun.wu@huawei.com>
Subject: [PATCH v2 05/13] irqchip: GICv3: ITS: irqchip implementation
Date: Tue, 18 Nov 2014 18:53:00 +0000
Message-Id: <1416336788-22634-6-git-send-email-marc.zyngier@arm.com>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <1416336788-22634-1-git-send-email-marc.zyngier@arm.com>
References: <1416336788-22634-1-git-send-email-marc.zyngier@arm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The usual methods that are used to present an irqchip to the rest
of the kernel

Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
---
 drivers/irqchip/irq-gic-v3-its.c | 77 ++++++++++++++++++++++++++++++++++++++++
 1 file changed, 77 insertions(+)

diff --git a/drivers/irqchip/irq-gic-v3-its.c b/drivers/irqchip/irq-gic-v3-its.c
index a5ab12c..d24bebd 100644
--- a/drivers/irqchip/irq-gic-v3-its.c
+++ b/drivers/irqchip/irq-gic-v3-its.c
@@ -40,6 +40,8 @@
 
 #define ITS_FLAGS_CMDQ_NEEDS_FLUSHING		(1 << 0)
 
+#define RDIST_FLAGS_PROPBASE_NEEDS_FLUSHING	(1 << 0)
+
 /*
  * Collection structure - just an ID, and a redistributor address to
  * ping. We use one per CPU as a bag of interrupts assigned to this
@@ -509,3 +511,78 @@ static void its_send_invall(struct its_node *its, struct its_collection *col)
 
 	its_send_single_command(its, its_build_invall_cmd, &desc);
 }
+
+/*
+ * irqchip functions - assumes MSI, mostly.
+ */
+
+static inline u32 its_get_event_id(struct irq_data *d)
+{
+	struct its_device *its_dev = irq_data_get_irq_chip_data(d);
+	return d->hwirq - its_dev->lpi_base;
+}
+
+static void lpi_set_config(struct irq_data *d, bool enable)
+{
+	struct its_device *its_dev = irq_data_get_irq_chip_data(d);
+	irq_hw_number_t hwirq = d->hwirq;
+	u32 id = its_get_event_id(d);
+	u8 *cfg = page_address(gic_rdists->prop_page) + hwirq - 8192;
+
+	if (enable)
+		*cfg |= LPI_PROP_ENABLED;
+	else
+		*cfg &= ~LPI_PROP_ENABLED;
+
+	/*
+	 * Make the above write visible to the redistributors.
+	 * And yes, we're flushing exactly: One. Single. Byte.
+	 * Humpf...
+	 */
+	if (gic_rdists->flags & RDIST_FLAGS_PROPBASE_NEEDS_FLUSHING)
+		__flush_dcache_area(cfg, sizeof(*cfg));
+	else
+		dsb(ishst);
+	its_send_inv(its_dev, id);
+}
+
+static void its_mask_irq(struct irq_data *d)
+{
+	lpi_set_config(d, false);
+}
+
+static void its_unmask_irq(struct irq_data *d)
+{
+	lpi_set_config(d, true);
+}
+
+static void its_eoi_irq(struct irq_data *d)
+{
+	gic_write_eoir(d->hwirq);
+}
+
+static int its_set_affinity(struct irq_data *d, const struct cpumask *mask_val,
+			    bool force)
+{
+	unsigned int cpu = cpumask_any_and(mask_val, cpu_online_mask);
+	struct its_device *its_dev = irq_data_get_irq_chip_data(d);
+	struct its_collection *target_col;
+	u32 id = its_get_event_id(d);
+
+	if (cpu >= nr_cpu_ids)
+		return -EINVAL;
+
+	target_col = &its_dev->its->collections[cpu];
+	its_send_movi(its_dev, target_col, id);
+	its_dev->collection = target_col;
+
+	return IRQ_SET_MASK_OK_DONE;
+}
+
+static struct irq_chip its_irq_chip = {
+	.name			= "ITS",
+	.irq_mask		= its_mask_irq,
+	.irq_unmask		= its_unmask_irq,
+	.irq_eoi		= its_eoi_irq,
+	.irq_set_affinity	= its_set_affinity,
+};
-- 
2.1.3

