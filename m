Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932261AbaKXOgD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Nov 2014 09:36:03 -0500
Received: from foss-mx-na.foss.arm.com ([217.140.108.86]:38052 "EHLO
	foss-mx-na.foss.arm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932241AbaKXOf6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Nov 2014 09:35:58 -0500
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
Subject: [PATCH v3 10/13] irqchip: GICv3: ITS: DT probing and initialization
Date: Mon, 24 Nov 2014 14:35:17 +0000
Message-Id: <1416839720-18400-11-git-send-email-marc.zyngier@arm.com>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <1416839720-18400-1-git-send-email-marc.zyngier@arm.com>
References: <1416839720-18400-1-git-send-email-marc.zyngier@arm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add the code that probes the ITS from the device tree,
and initialize it.

Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
---
 drivers/irqchip/irq-gic-v3-its.c | 169 +++++++++++++++++++++++++++++++++++++++
 1 file changed, 169 insertions(+)

diff --git a/drivers/irqchip/irq-gic-v3-its.c b/drivers/irqchip/irq-gic-v3-its.c
index 532c6df..e9d1615 100644
--- a/drivers/irqchip/irq-gic-v3-its.c
+++ b/drivers/irqchip/irq-gic-v3-its.c
@@ -1231,3 +1231,172 @@ static const struct irq_domain_ops its_domain_ops = {
 	.alloc			= its_irq_domain_alloc,
 	.free			= its_irq_domain_free,
 };
+
+static int its_probe(struct device_node *node, struct irq_domain *parent)
+{
+	struct resource res;
+	struct its_node *its;
+	void __iomem *its_base;
+	u32 val;
+	u64 baser, tmp;
+	int err;
+
+	err = of_address_to_resource(node, 0, &res);
+	if (err) {
+		pr_warn("%s: no regs?\n", node->full_name);
+		return -ENXIO;
+	}
+
+	its_base = ioremap(res.start, resource_size(&res));
+	if (!its_base) {
+		pr_warn("%s: unable to map registers\n", node->full_name);
+		return -ENOMEM;
+	}
+
+	val = readl_relaxed(its_base + GITS_PIDR2) & GIC_PIDR2_ARCH_MASK;
+	if (val != 0x30 && val != 0x40) {
+		pr_warn("%s: no ITS detected, giving up\n", node->full_name);
+		err = -ENODEV;
+		goto out_unmap;
+	}
+
+	pr_info("ITS: %s\n", node->full_name);
+
+	its = kzalloc(sizeof(*its), GFP_KERNEL);
+	if (!its) {
+		err = -ENOMEM;
+		goto out_unmap;
+	}
+
+	raw_spin_lock_init(&its->lock);
+	INIT_LIST_HEAD(&its->entry);
+	INIT_LIST_HEAD(&its->its_device_list);
+	its->base = its_base;
+	its->phys_base = res.start;
+	its->msi_chip.of_node = node;
+	its->ite_size = ((readl_relaxed(its_base + GITS_TYPER) >> 4) & 0xf) + 1;
+
+	its->cmd_base = kzalloc(ITS_CMD_QUEUE_SZ, GFP_KERNEL);
+	if (!its->cmd_base) {
+		err = -ENOMEM;
+		goto out_free_its;
+	}
+	its->cmd_write = its->cmd_base;
+
+	err = its_alloc_tables(its);
+	if (err)
+		goto out_free_cmd;
+
+	err = its_alloc_collections(its);
+	if (err)
+		goto out_free_tables;
+
+	baser = (virt_to_phys(its->cmd_base)	|
+		 GITS_CBASER_WaWb		|
+		 GITS_CBASER_InnerShareable	|
+		 (ITS_CMD_QUEUE_SZ / SZ_4K - 1)	|
+		 GITS_CBASER_VALID);
+
+	writeq_relaxed(baser, its->base + GITS_CBASER);
+	tmp = readq_relaxed(its->base + GITS_CBASER);
+	writeq_relaxed(0, its->base + GITS_CWRITER);
+	writel_relaxed(1, its->base + GITS_CTLR);
+
+	if ((tmp ^ baser) & GITS_BASER_SHAREABILITY_MASK) {
+		pr_info("ITS: using cache flushing for cmd queue\n");
+		its->flags |= ITS_FLAGS_CMDQ_NEEDS_FLUSHING;
+	}
+
+	if (of_property_read_bool(its->msi_chip.of_node, "msi-controller")) {
+		its->domain = irq_domain_add_tree(NULL, &its_domain_ops, its);
+		if (!its->domain) {
+			err = -ENOMEM;
+			goto out_free_tables;
+		}
+
+		its->domain->parent = parent;
+
+		its->msi_chip.domain = pci_msi_create_irq_domain(node,
+								 &its_pci_msi_domain_info,
+								 its->domain);
+		if (!its->msi_chip.domain) {
+			err = -ENOMEM;
+			goto out_free_domains;
+		}
+
+		err = of_pci_msi_chip_add(&its->msi_chip);
+		if (err)
+			goto out_free_domains;
+	}
+
+	spin_lock(&its_lock);
+	list_add(&its->entry, &its_nodes);
+	spin_unlock(&its_lock);
+
+	return 0;
+
+out_free_domains:
+	if (its->msi_chip.domain)
+		irq_domain_remove(its->msi_chip.domain);
+	if (its->domain)
+		irq_domain_remove(its->domain);
+out_free_tables:
+	its_free_tables(its);
+out_free_cmd:
+	kfree(its->cmd_base);
+out_free_its:
+	kfree(its);
+out_unmap:
+	iounmap(its_base);
+	pr_err("ITS: failed probing %s (%d)\n", node->full_name, err);
+	return err;
+}
+
+static bool gic_rdists_supports_plpis(void)
+{
+	return !!(readl_relaxed(gic_data_rdist_rd_base() + GICR_TYPER) & GICR_TYPER_PLPIS);
+}
+
+int its_cpu_init(void)
+{
+	if (!gic_rdists_supports_plpis()) {
+		pr_info("CPU%d: LPIs not supported\n", smp_processor_id());
+		return -ENXIO;
+	}
+
+	if (!list_empty(&its_nodes)) {
+		its_cpu_init_lpis();
+		its_cpu_init_collection();
+	}
+
+	return 0;
+}
+
+static struct of_device_id its_device_id[] = {
+	{	.compatible	= "arm,gic-v3-its",	},
+	{},
+};
+
+int its_init(struct device_node *node, struct rdists *rdists,
+	     struct irq_domain *parent_domain)
+{
+	struct device_node *np;
+
+	for (np = of_find_matching_node(node, its_device_id); np;
+	     np = of_find_matching_node(np, its_device_id)) {
+		its_probe(np, parent_domain);
+	}
+
+	if (list_empty(&its_nodes)) {
+		pr_warn("ITS: No ITS available, not enabling LPIs\n");
+		return -ENXIO;
+	}
+
+	gic_rdists = rdists;
+	gic_root_node = node;
+
+	its_alloc_lpi_tables();
+	its_lpi_init(rdists->id_bits);
+
+	return 0;
+}
-- 
2.1.3

