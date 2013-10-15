Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933943Ab3JOUmB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Oct 2013 16:42:01 -0400
Received: from mail-wg0-f41.google.com ([74.125.82.41]:55826 "EHLO
	mail-wg0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933946Ab3JOUji (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Oct 2013 16:39:38 -0400
From: Grant Likely <grant.likely@linaro.org>
To: devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Grant Likely <grant.likely@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Russell King <linux@arm.linux.org.uk>, Michal Simek <monstr@monstr.eu>,
        Ralf Baechle <ralf@linux-mips.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>
Subject: [RFC 3/9] of/irq: simplify args to irq_create_of_mapping
Date: Tue, 15 Oct 2013 21:39:17 +0100
Message-Id: <1381869563-16083-4-git-send-email-grant.likely@linaro.org>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1381869563-16083-1-git-send-email-grant.likely@linaro.org>
References: <1381869563-16083-1-git-send-email-grant.likely@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

All the callers of irq_create_of_mapping() pass the contents of a struct
of_phandle_args structure to the function. Since all the callers already
have an of_phandle_args pointer, why not pass it directly to
irq_create_of_mapping()?

Signed-off-by: Grant Likely <grant.likely@linaro.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Russell King <linux@arm.linux.org.uk>
Cc: Michal Simek <monstr@monstr.eu>
Cc: Ralf Baechle <ralf@linux-mips.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
---
 arch/arm/mach-integrator/pci_v3.c              |  2 +-
 arch/microblaze/pci/pci-common.c               |  2 +-
 arch/mips/pci/fixup-lantiq.c                   |  2 +-
 arch/mips/pci/pci-rt3883.c                     |  2 +-
 arch/powerpc/kernel/pci-common.c               |  2 +-
 arch/powerpc/platforms/cell/celleb_scc_pciex.c |  2 +-
 arch/powerpc/platforms/cell/celleb_scc_sio.c   |  2 +-
 arch/powerpc/platforms/cell/spider-pic.c       |  7 ++-----
 arch/powerpc/platforms/cell/spu_manage.c       |  3 +--
 arch/powerpc/platforms/fsl_uli1575.c           |  2 +-
 arch/powerpc/platforms/pseries/event_sources.c |  3 +--
 arch/x86/kernel/devicetree.c                   |  2 +-
 drivers/of/irq.c                               |  2 +-
 drivers/pci/host/pci-mvebu.c                   |  2 +-
 include/linux/of_irq.h                         |  4 +---
 kernel/irq/irqdomain.c                         | 13 ++++++-------
 16 files changed, 22 insertions(+), 30 deletions(-)

diff --git a/arch/arm/mach-integrator/pci_v3.c b/arch/arm/mach-integrator/pci_v3.c
index 2d6b4da..bb3aeb3 100644
--- a/arch/arm/mach-integrator/pci_v3.c
+++ b/arch/arm/mach-integrator/pci_v3.c
@@ -847,7 +847,7 @@ static int __init pci_v3_map_irq_dt(const struct pci_dev *dev, u8 slot, u8 pin)
 		return 0;
 	}
 
-	return irq_create_of_mapping(oirq.np, oirq.args, oirq.args_count);
+	return irq_create_of_mapping(&oirq);
 }
 
 static int __init pci_v3_dtprobe(struct platform_device *pdev,
diff --git a/arch/microblaze/pci/pci-common.c b/arch/microblaze/pci/pci-common.c
index c9302c4..60b386c 100644
--- a/arch/microblaze/pci/pci-common.c
+++ b/arch/microblaze/pci/pci-common.c
@@ -246,7 +246,7 @@ int pci_read_irq_line(struct pci_dev *pci_dev)
 			 oirq.args_count, oirq.args[0], oirq.args[1],
 			 of_node_full_name(oirq.np));
 
-		virq = irq_create_of_mapping(oirq.np, oirq.args, oirq.args_count);
+		virq = irq_create_of_mapping(&oirq);
 	}
 	if (!virq) {
 		pr_debug(" Failed to map !\n");
diff --git a/arch/mips/pci/fixup-lantiq.c b/arch/mips/pci/fixup-lantiq.c
index 81ff0b5..aef60e7 100644
--- a/arch/mips/pci/fixup-lantiq.c
+++ b/arch/mips/pci/fixup-lantiq.c
@@ -33,7 +33,7 @@ int __init pcibios_map_irq(const struct pci_dev *dev, u8 slot, u8 pin)
 			slot, pin);
 		return 0;
 	}
-	irq = irq_create_of_mapping(dev_irq.np, dev_irq.args, dev_irq.args_count);
+	irq = irq_create_of_mapping(&dev_irq);
 	dev_info(&dev->dev, "SLOT:%d PIN:%d IRQ:%d\n", slot, pin, irq);
 	return irq;
 }
diff --git a/arch/mips/pci/pci-rt3883.c b/arch/mips/pci/pci-rt3883.c
index 0f08a5b..eadc431 100644
--- a/arch/mips/pci/pci-rt3883.c
+++ b/arch/mips/pci/pci-rt3883.c
@@ -594,7 +594,7 @@ int __init pcibios_map_irq(const struct pci_dev *dev, u8 slot, u8 pin)
 		return 0;
 	}
 
-	irq = irq_create_of_mapping(dev_irq.np, dev_irq.args, dev_irq.args_count);
+	irq = irq_create_of_mapping(&dev_irq);
 
 	if (irq == 0)
 		pr_crit("pci %s: no irq found for pin %u\n",
diff --git a/arch/powerpc/kernel/pci-common.c b/arch/powerpc/kernel/pci-common.c
index 96c4623..a1e3e40 100644
--- a/arch/powerpc/kernel/pci-common.c
+++ b/arch/powerpc/kernel/pci-common.c
@@ -266,7 +266,7 @@ static int pci_read_irq_line(struct pci_dev *pci_dev)
 			 oirq.args_count, oirq.args[0], oirq.args[1],
 			 of_node_full_name(oirq.np));
 
-		virq = irq_create_of_mapping(oirq.np, oirq.args, oirq.args_count);
+		virq = irq_create_of_mapping(&oirq);
 	}
 	if(virq == NO_IRQ) {
 		pr_debug(" Failed to map !\n");
diff --git a/arch/powerpc/platforms/cell/celleb_scc_pciex.c b/arch/powerpc/platforms/cell/celleb_scc_pciex.c
index e8d34d1..b3ea96d 100644
--- a/arch/powerpc/platforms/cell/celleb_scc_pciex.c
+++ b/arch/powerpc/platforms/cell/celleb_scc_pciex.c
@@ -511,7 +511,7 @@ static __init int celleb_setup_pciex(struct device_node *node,
 		pr_err("PCIEXC:Failed to map irq\n");
 		goto error;
 	}
-	virq = irq_create_of_mapping(oirq.np, oirq.args, oirq.args_count);
+	virq = irq_create_of_mapping(&oirq);
 	if (request_irq(virq, pciex_handle_internal_irq,
 			0, "pciex", (void *)phb)) {
 		pr_err("PCIEXC:Failed to request irq\n");
diff --git a/arch/powerpc/platforms/cell/celleb_scc_sio.c b/arch/powerpc/platforms/cell/celleb_scc_sio.c
index 06046d5..c8eb571 100644
--- a/arch/powerpc/platforms/cell/celleb_scc_sio.c
+++ b/arch/powerpc/platforms/cell/celleb_scc_sio.c
@@ -66,7 +66,7 @@ static int __init txx9_serial_init(void)
 #ifdef CONFIG_SERIAL_TXX9_CONSOLE
 			req.membase = ioremap(req.mapbase, 0x24);
 #endif
-			req.irq = irq_create_of_mapping(irq.np, irq.args, irq.args_count);
+			req.irq = irq_create_of_mapping(&irq);
 			req.flags |= UPF_IOREMAP | UPF_BUGGY_UART
 				/*HAVE_CTS_LINE*/;
 			req.uartclk = 83300000;
diff --git a/arch/powerpc/platforms/cell/spider-pic.c b/arch/powerpc/platforms/cell/spider-pic.c
index 6e842fd..d206804 100644
--- a/arch/powerpc/platforms/cell/spider-pic.c
+++ b/arch/powerpc/platforms/cell/spider-pic.c
@@ -236,11 +236,8 @@ static unsigned int __init spider_find_cascade_and_node(struct spider_pic *pic)
 	 * tree in case the device-tree is ever fixed
 	 */
 	struct of_phandle_args oirq;
-	if (of_irq_parse_one(pic->host->of_node, 0, &oirq) == 0) {
-		virq = irq_create_of_mapping(oirq.np, oirq.args,
-					     oirq.args_count);
-		return virq;
-	}
+	if (of_irq_parse_one(pic->host->of_node, 0, &oirq) == 0)
+		return irq_create_of_mapping(&oirq);
 
 	/* Now do the horrible hacks */
 	tmp = of_get_property(pic->host->of_node, "#interrupt-cells", NULL);
diff --git a/arch/powerpc/platforms/cell/spu_manage.c b/arch/powerpc/platforms/cell/spu_manage.c
index e9eb4f8..c3327f3 100644
--- a/arch/powerpc/platforms/cell/spu_manage.c
+++ b/arch/powerpc/platforms/cell/spu_manage.c
@@ -190,8 +190,7 @@ static int __init spu_map_interrupts(struct spu *spu, struct device_node *np)
 		ret = -EINVAL;
 		pr_debug("  irq %d no 0x%x on %s\n", i, oirq.args[0],
 			 oirq.np->full_name);
-		spu->irqs[i] = irq_create_of_mapping(oirq.np,
-					oirq.args, oirq.args_count);
+		spu->irqs[i] = irq_create_of_mapping(&oirq);
 		if (spu->irqs[i] == NO_IRQ) {
 			pr_debug("spu_new: failed to map it !\n");
 			goto err;
diff --git a/arch/powerpc/platforms/fsl_uli1575.c b/arch/powerpc/platforms/fsl_uli1575.c
index 288226d..8904046 100644
--- a/arch/powerpc/platforms/fsl_uli1575.c
+++ b/arch/powerpc/platforms/fsl_uli1575.c
@@ -334,7 +334,7 @@ static void hpcd_final_uli5288(struct pci_dev *dev)
 	laddr[0] = (hose->first_busno << 16) | (PCI_DEVFN(31, 0) << 8);
 	laddr[1] = laddr[2] = 0;
 	of_irq_parse_raw(hosenode, &pin, 1, laddr, &oirq);
-	dev->irq = irq_create_of_mapping(oirq.np, oirq.args, oirq.args_count);
+	dev->irq = irq_create_of_mapping(&oirq);
 }
 
 DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_AL, 0x1575, hpcd_quirk_uli1575);
diff --git a/arch/powerpc/platforms/pseries/event_sources.c b/arch/powerpc/platforms/pseries/event_sources.c
index 6dcf9cc..18380e8 100644
--- a/arch/powerpc/platforms/pseries/event_sources.c
+++ b/arch/powerpc/platforms/pseries/event_sources.c
@@ -59,8 +59,7 @@ void request_event_sources_irqs(struct device_node *np,
 		     index++) {
 			if (count > 15)
 				break;
-			virqs[count] = irq_create_of_mapping(oirq.np, oirq.args,
-							    oirq.args_count);
+			virqs[count] = irq_create_of_mapping(&oirq);
 			if (virqs[count] == NO_IRQ) {
 				pr_err("event-sources: Unable to allocate "
 				       "interrupt number for %s\n",
diff --git a/arch/x86/kernel/devicetree.c b/arch/x86/kernel/devicetree.c
index 0098698..d39948f 100644
--- a/arch/x86/kernel/devicetree.c
+++ b/arch/x86/kernel/devicetree.c
@@ -120,7 +120,7 @@ static int x86_of_pci_irq_enable(struct pci_dev *dev)
 	if (ret)
 		return ret;
 
-	virq = irq_create_of_mapping(oirq.np, oirq.args, oirq.args_count);
+	virq = irq_create_of_mapping(&oirq);
 	if (virq == 0)
 		return -EINVAL;
 	dev->irq = virq;
diff --git a/drivers/of/irq.c b/drivers/of/irq.c
index a7db38a..84184c4 100644
--- a/drivers/of/irq.c
+++ b/drivers/of/irq.c
@@ -41,7 +41,7 @@ unsigned int irq_of_parse_and_map(struct device_node *dev, int index)
 	if (of_irq_parse_one(dev, index, &oirq))
 		return 0;
 
-	return irq_create_of_mapping(oirq.np, oirq.args, oirq.args_count);
+	return irq_create_of_mapping(&oirq);
 }
 EXPORT_SYMBOL_GPL(irq_of_parse_and_map);
 
diff --git a/drivers/pci/host/pci-mvebu.c b/drivers/pci/host/pci-mvebu.c
index c5e57f8..3a8d01e 100644
--- a/drivers/pci/host/pci-mvebu.c
+++ b/drivers/pci/host/pci-mvebu.c
@@ -654,7 +654,7 @@ static int __init mvebu_pcie_map_irq(const struct pci_dev *dev, u8 slot, u8 pin)
 	if (ret)
 		return ret;
 
-	return irq_create_of_mapping(oirq.np, oirq.args, oirq.args_count);
+	return irq_create_of_mapping(&oirq);
 }
 
 static struct pci_bus *mvebu_pcie_scan_bus(int nr, struct pci_sys_data *sys)
diff --git a/include/linux/of_irq.h b/include/linux/of_irq.h
index 8d9f855..3bbba8d 100644
--- a/include/linux/of_irq.h
+++ b/include/linux/of_irq.h
@@ -37,9 +37,7 @@ extern int of_irq_parse_raw(struct device_node *parent, const __be32 *intspec,
 			  struct of_phandle_args *out_irq);
 extern int of_irq_parse_one(struct device_node *device, int index,
 			  struct of_phandle_args *out_irq);
-extern unsigned int irq_create_of_mapping(struct device_node *controller,
-					  const u32 *intspec,
-					  unsigned int intsize);
+extern unsigned int irq_create_of_mapping(struct of_phandle_args *irq_data);
 extern int of_irq_to_resource(struct device_node *dev, int index,
 			      struct resource *r);
 extern int of_irq_count(struct device_node *dev);
diff --git a/kernel/irq/irqdomain.c b/kernel/irq/irqdomain.c
index 706724e..cf68bb36 100644
--- a/kernel/irq/irqdomain.c
+++ b/kernel/irq/irqdomain.c
@@ -465,27 +465,26 @@ int irq_create_strict_mappings(struct irq_domain *domain, unsigned int irq_base,
 }
 EXPORT_SYMBOL_GPL(irq_create_strict_mappings);
 
-unsigned int irq_create_of_mapping(struct device_node *controller,
-				   const u32 *intspec, unsigned int intsize)
+unsigned int irq_create_of_mapping(struct of_phandle_args *irq_data)
 {
 	struct irq_domain *domain;
 	irq_hw_number_t hwirq;
 	unsigned int type = IRQ_TYPE_NONE;
 	unsigned int virq;
 
-	domain = controller ? irq_find_host(controller) : irq_default_domain;
+	domain = irq_data->np ? irq_find_host(irq_data->np) : irq_default_domain;
 	if (!domain) {
 		pr_warn("no irq domain found for %s !\n",
-			of_node_full_name(controller));
+			of_node_full_name(irq_data->np));
 		return 0;
 	}
 
 	/* If domain has no translation, then we assume interrupt line */
 	if (domain->ops->xlate == NULL)
-		hwirq = intspec[0];
+		hwirq = irq_data->args[0];
 	else {
-		if (domain->ops->xlate(domain, controller, intspec, intsize,
-				     &hwirq, &type))
+		if (domain->ops->xlate(domain, irq_data->np, irq_data->args,
+					irq_data->args_count, &hwirq, &type))
 			return 0;
 	}
 
-- 
1.8.1.2

