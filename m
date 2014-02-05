Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932309AbaBEGwY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Feb 2014 01:52:24 -0500
Received: from mail-pa0-f43.google.com ([209.85.220.43]:52089 "EHLO
	mail-pa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932240AbaBEGvy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Feb 2014 01:51:54 -0500
From: Magnus Damm <magnus.damm@gmail.com>
To: linux-pci@vger.kernel.org
Cc: linux-sh@vger.kernel.org, linux-kernel@vger.kernel.org,
        valentine.barshak@cogentembedded.com, horms@verge.net.au,
        bhelgaas@google.com, Magnus Damm <magnus.damm@gmail.com>,
        ben.dooks@codethink.co.uk
Date: Wed, 05 Feb 2014 15:52:54 +0900
Message-Id: <20140205065254.29445.77939.sendpatchset@w520>
In-Reply-To: <20140205065243.29445.76593.sendpatchset@w520>
References: <20140205065243.29445.76593.sendpatchset@w520>
Subject: [PATCH 01/04] PCI: rcar: Register each instance independently
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Magnus Damm <damm@opensource.se>

Convert the code to allow per-device probe() like other device
drivers. This also delays driver registration due to change from
subsys_initcall() to regular module_platform_driver().

Signed-off-by: Magnus Damm <damm@opensource.se>
---

 drivers/pci/host/pci-rcar-gen2.c |   74 ++++++++------------------------------
 1 file changed, 16 insertions(+), 58 deletions(-)

--- 0001/drivers/pci/host/pci-rcar-gen2.c
+++ work/drivers/pci/host/pci-rcar-gen2.c	2014-02-04 16:38:46.000000000 +0900
@@ -74,9 +74,6 @@
 
 #define RCAR_PCI_UNIT_REV_REG		(RCAR_AHBPCI_PCICOM_OFFSET + 0x48)
 
-/* Number of internal PCI controllers */
-#define RCAR_PCI_NR_CONTROLLERS		3
-
 struct rcar_pci_priv {
 	struct device *dev;
 	void __iomem *reg;
@@ -228,6 +225,8 @@ static int __init rcar_pci_setup(int nr,
 	pci_add_resource(&sys->resources, &priv->io_res);
 	pci_add_resource(&sys->resources, &priv->mem_res);
 
+	/* Setup bus number based on platform device id */
+	sys->busnr = to_platform_device(priv->dev)->id;
 	return 1;
 }
 
@@ -236,48 +235,12 @@ static struct pci_ops rcar_pci_ops = {
 	.write	= rcar_pci_write_config,
 };
 
-static struct hw_pci rcar_hw_pci __initdata = {
-	.map_irq	= rcar_pci_map_irq,
-	.ops		= &rcar_pci_ops,
-	.setup		= rcar_pci_setup,
-};
-
-static int rcar_pci_count __initdata;
-
-static int __init rcar_pci_add_controller(struct rcar_pci_priv *priv)
-{
-	void **private_data;
-	int count;
-
-	if (rcar_hw_pci.nr_controllers < rcar_pci_count)
-		goto add_priv;
-
-	/* (Re)allocate private data pointer array if needed */
-	count = rcar_pci_count + RCAR_PCI_NR_CONTROLLERS;
-	private_data = kzalloc(count * sizeof(void *), GFP_KERNEL);
-	if (!private_data)
-		return -ENOMEM;
-
-	rcar_pci_count = count;
-	if (rcar_hw_pci.private_data) {
-		memcpy(private_data, rcar_hw_pci.private_data,
-		       rcar_hw_pci.nr_controllers * sizeof(void *));
-		kfree(rcar_hw_pci.private_data);
-	}
-
-	rcar_hw_pci.private_data = private_data;
-
-add_priv:
-	/* Add private data pointer to the array */
-	rcar_hw_pci.private_data[rcar_hw_pci.nr_controllers++] = priv;
-	return 0;
-}
-
-static int __init rcar_pci_probe(struct platform_device *pdev)
+static int rcar_pci_probe(struct platform_device *pdev)
 {
 	struct resource *cfg_res, *mem_res;
 	struct rcar_pci_priv *priv;
 	void __iomem *reg;
+	struct hw_pci hw;
 
 	cfg_res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
 	reg = devm_ioremap_resource(&pdev->dev, cfg_res);
@@ -308,31 +271,26 @@ static int __init rcar_pci_probe(struct
 	priv->reg = reg;
 	priv->dev = &pdev->dev;
 
-	return rcar_pci_add_controller(priv);
+	memset(&hw, 0, sizeof(hw));
+	hw.nr_controllers = 1;
+	hw.private_data = (void **)&priv;
+	hw.map_irq = rcar_pci_map_irq;
+	hw.ops = &rcar_pci_ops;
+	hw.setup = rcar_pci_setup;
+	pci_common_init_dev(&pdev->dev, &hw);
+	return 0;
 }
 
 static struct platform_driver rcar_pci_driver = {
 	.driver = {
 		.name = "pci-rcar-gen2",
+		.owner = THIS_MODULE,
+		.suppress_bind_attrs = true,
 	},
+	.probe = rcar_pci_probe,
 };
 
-static int __init rcar_pci_init(void)
-{
-	int retval;
-
-	retval = platform_driver_probe(&rcar_pci_driver, rcar_pci_probe);
-	if (!retval)
-		pci_common_init(&rcar_hw_pci);
-
-	/* Private data pointer array is not needed any more */
-	kfree(rcar_hw_pci.private_data);
-	rcar_hw_pci.private_data = NULL;
-
-	return retval;
-}
-
-subsys_initcall(rcar_pci_init);
+module_platform_driver(rcar_pci_driver);
 
 MODULE_LICENSE("GPL v2");
 MODULE_DESCRIPTION("Renesas R-Car Gen2 internal PCI");
