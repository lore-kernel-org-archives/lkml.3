Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933995Ab3JOUj5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Oct 2013 16:39:57 -0400
Received: from mail-wg0-f52.google.com ([74.125.82.52]:34969 "EHLO
	mail-wg0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933957Ab3JOUjl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Oct 2013 16:39:41 -0400
From: Grant Likely <grant.likely@linaro.org>
To: devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Grant Likely <grant.likely@linaro.org>,
        Russell King <linux@arm.linux.org.uk>, Michal Simek <monstr@monstr.eu>,
        Ralf Baechle <ralf@linux-mips.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>
Subject: [RFC 7/9] of/irq: Create of_irq_parse_and_map_pci() to consolidate arch code.
Date: Tue, 15 Oct 2013 21:39:21 +0100
Message-Id: <1381869563-16083-8-git-send-email-grant.likely@linaro.org>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1381869563-16083-1-git-send-email-grant.likely@linaro.org>
References: <1381869563-16083-1-git-send-email-grant.likely@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Several architectures open code effectively the same code block for
finding and mapping PCI irqs. This patch consolidates it down to a
single function.

Signed-off-by: Grant Likely <grant.likely@linaro.org>
Cc: Russell King <linux@arm.linux.org.uk>
Cc: Michal Simek <monstr@monstr.eu>
Cc: Ralf Baechle <ralf@linux-mips.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
---
 arch/arm/mach-integrator/pci_v3.c | 17 +----------------
 arch/mips/pci/fixup-lantiq.c      | 12 +-----------
 arch/mips/pci/pci-rt3883.c        | 22 +---------------------
 arch/x86/kernel/devicetree.c      |  7 +------
 drivers/of/of_pci_irq.c           | 25 +++++++++++++++++++++++++
 drivers/pci/host/pci-mvebu.c      | 14 +-------------
 include/linux/of_pci.h            |  1 +
 7 files changed, 31 insertions(+), 67 deletions(-)

diff --git a/arch/arm/mach-integrator/pci_v3.c b/arch/arm/mach-integrator/pci_v3.c
index bb3aeb3..a87e510 100644
--- a/arch/arm/mach-integrator/pci_v3.c
+++ b/arch/arm/mach-integrator/pci_v3.c
@@ -835,21 +835,6 @@ static struct hw_pci pci_v3 __initdata = {
 
 #ifdef CONFIG_OF
 
-static int __init pci_v3_map_irq_dt(const struct pci_dev *dev, u8 slot, u8 pin)
-{
-	struct of_phandle_args oirq;
-	int ret;
-
-	ret = of_irq_parse_pci(dev, &oirq);
-	if (ret) {
-		dev_err(&dev->dev, "of_irq_parse_pci() %d\n", ret);
-		/* Proper return code 0 == NO_IRQ */
-		return 0;
-	}
-
-	return irq_create_of_mapping(&oirq);
-}
-
 static int __init pci_v3_dtprobe(struct platform_device *pdev,
 				struct device_node *np)
 {
@@ -918,7 +903,7 @@ static int __init pci_v3_dtprobe(struct platform_device *pdev,
 		return -EINVAL;
 	}
 
-	pci_v3.map_irq = pci_v3_map_irq_dt;
+	pci_v3.map_irq = of_irq_parse_and_map_pci;
 	pci_common_init_dev(&pdev->dev, &pci_v3);
 
 	return 0;
diff --git a/arch/mips/pci/fixup-lantiq.c b/arch/mips/pci/fixup-lantiq.c
index aef60e7..c2ce41e 100644
--- a/arch/mips/pci/fixup-lantiq.c
+++ b/arch/mips/pci/fixup-lantiq.c
@@ -25,15 +25,5 @@ int pcibios_plat_dev_init(struct pci_dev *dev)
 
 int __init pcibios_map_irq(const struct pci_dev *dev, u8 slot, u8 pin)
 {
-	struct of_phandle_args dev_irq;
-	int irq;
-
-	if (of_irq_parse_pci(dev, &dev_irq)) {
-		dev_err(&dev->dev, "trying to map irq for unknown slot:%d pin:%d\n",
-			slot, pin);
-		return 0;
-	}
-	irq = irq_create_of_mapping(&dev_irq);
-	dev_info(&dev->dev, "SLOT:%d PIN:%d IRQ:%d\n", slot, pin, irq);
-	return irq;
+	return of_irq_parse_and_map_pci(dev, slot, pin);
 }
diff --git a/arch/mips/pci/pci-rt3883.c b/arch/mips/pci/pci-rt3883.c
index eadc431..adeff2b 100644
--- a/arch/mips/pci/pci-rt3883.c
+++ b/arch/mips/pci/pci-rt3883.c
@@ -583,27 +583,7 @@ err_put_intc_node:
 
 int __init pcibios_map_irq(const struct pci_dev *dev, u8 slot, u8 pin)
 {
-	struct of_phandle_args dev_irq;
-	int err;
-	int irq;
-
-	err = of_irq_parse_pci(dev, &dev_irq);
-	if (err) {
-		pr_err("pci %s: unable to get irq map, err=%d\n",
-		       pci_name((struct pci_dev *) dev), err);
-		return 0;
-	}
-
-	irq = irq_create_of_mapping(&dev_irq);
-
-	if (irq == 0)
-		pr_crit("pci %s: no irq found for pin %u\n",
-			pci_name((struct pci_dev *) dev), pin);
-	else
-		pr_info("pci %s: using irq %d for pin %u\n",
-			pci_name((struct pci_dev *) dev), irq, pin);
-
-	return irq;
+	return of_irq_parse_and_map_pci(dev, slot, pin);
 }
 
 int pcibios_plat_dev_init(struct pci_dev *dev)
diff --git a/arch/x86/kernel/devicetree.c b/arch/x86/kernel/devicetree.c
index d39948f..69c826a 100644
--- a/arch/x86/kernel/devicetree.c
+++ b/arch/x86/kernel/devicetree.c
@@ -105,7 +105,6 @@ struct device_node *pcibios_get_phb_of_node(struct pci_bus *bus)
 
 static int x86_of_pci_irq_enable(struct pci_dev *dev)
 {
-	struct of_phandle_args oirq;
 	u32 virq;
 	int ret;
 	u8 pin;
@@ -116,11 +115,7 @@ static int x86_of_pci_irq_enable(struct pci_dev *dev)
 	if (!pin)
 		return 0;
 
-	ret = of_irq_parse_pci(dev, &oirq);
-	if (ret)
-		return ret;
-
-	virq = irq_create_of_mapping(&oirq);
+	virq = of_irq_parse_and_map_pci(dev, 0, 0);
 	if (virq == 0)
 		return -EINVAL;
 	dev->irq = virq;
diff --git a/drivers/of/of_pci_irq.c b/drivers/of/of_pci_irq.c
index 303afeb..8e92acd 100644
--- a/drivers/of/of_pci_irq.c
+++ b/drivers/of/of_pci_irq.c
@@ -94,3 +94,28 @@ int of_irq_parse_pci(const struct pci_dev *pdev, struct of_phandle_args *out_irq
 	return of_irq_parse_raw(laddr, out_irq);
 }
 EXPORT_SYMBOL_GPL(of_irq_parse_pci);
+
+/**
+ * of_irq_parse_and_map_pci() - Decode a PCI irq from the device tree and map to a virq
+ * @dev: The pci device needing an irq
+ * @slot: PCI slot number; passed when used as map_irq callback. Unused
+ * @pin: PCI irq pin number; passed when used as map_irq callback. Unused
+ *
+ * @slot and @pin are unused, but included in the function so that this
+ * function can be used directly as the map_irq callback to pci_fixup_irqs().
+ */
+int of_irq_parse_and_map_pci(const struct pci_dev *dev, u8 slot, u8 pin)
+{
+	struct of_phandle_args oirq;
+	int ret;
+
+	ret = of_irq_parse_pci(dev, &oirq);
+	if (ret) {
+		dev_err(&dev->dev, "of_irq_parse_pci() failed with rc=%d\n", ret);
+		return 0; /* Proper return code 0 == NO_IRQ */
+	}
+
+	return irq_create_of_mapping(&oirq);
+}
+EXPORT_SYMBOL_GPL(of_irq_parse_and_map_pci);
+
diff --git a/drivers/pci/host/pci-mvebu.c b/drivers/pci/host/pci-mvebu.c
index 3a8d01e..07ddb3a 100644
--- a/drivers/pci/host/pci-mvebu.c
+++ b/drivers/pci/host/pci-mvebu.c
@@ -645,18 +645,6 @@ static int __init mvebu_pcie_setup(int nr, struct pci_sys_data *sys)
 	return 1;
 }
 
-static int __init mvebu_pcie_map_irq(const struct pci_dev *dev, u8 slot, u8 pin)
-{
-	struct of_phandle_args oirq;
-	int ret;
-
-	ret = of_irq_parse_pci(dev, &oirq);
-	if (ret)
-		return ret;
-
-	return irq_create_of_mapping(&oirq);
-}
-
 static struct pci_bus *mvebu_pcie_scan_bus(int nr, struct pci_sys_data *sys)
 {
 	struct mvebu_pcie *pcie = sys_to_pcie(sys);
@@ -705,7 +693,7 @@ static void __init mvebu_pcie_enable(struct mvebu_pcie *pcie)
 	hw.private_data   = (void **)&pcie;
 	hw.setup          = mvebu_pcie_setup;
 	hw.scan           = mvebu_pcie_scan_bus;
-	hw.map_irq        = mvebu_pcie_map_irq;
+	hw.map_irq        = of_irq_parse_and_map_pci;
 	hw.ops            = &mvebu_pcie_ops;
 	hw.align_resource = mvebu_pcie_align_resource;
 
diff --git a/include/linux/of_pci.h b/include/linux/of_pci.h
index f297237..1a1f5ff 100644
--- a/include/linux/of_pci.h
+++ b/include/linux/of_pci.h
@@ -7,6 +7,7 @@
 struct pci_dev;
 struct of_phandle_args;
 int of_irq_parse_pci(const struct pci_dev *pdev, struct of_phandle_args *out_irq);
+int of_irq_parse_and_map_pci(const struct pci_dev *dev, u8 slot, u8 pin);
 
 struct device_node;
 struct device_node *of_pci_find_child_device(struct device_node *parent,
-- 
1.8.1.2

