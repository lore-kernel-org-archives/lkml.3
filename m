Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756423AbaEPIiX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 May 2014 04:38:23 -0400
Received: from ar-005-i191.relay.mailchannels.net ([162.253.144.73]:60734 "EHLO
	relay.mailchannels.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755619AbaEPIiT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 May 2014 04:38:19 -0400
X-Sender-Id: totalchoicehosting|x-authuser|billaue
X-Sender-Id: totalchoicehosting|x-authuser|billaue
X-MailChannels-SenderId: totalchoicehosting%7Cx-authuser%7Cbillaue
X-MailChannels-Auth-Id: totalchoicehosting
X-MC-Relay: Neutral
From: Eli Billauer <eli.billauer@gmail.com>
To: gregkh@linuxfoundation.org
Cc: devel@driverdev.osuosl.org, tj@kernel.org, linux-kernel@vger.kernel.org,
        Eli Billauer <eli.billauer@gmail.com>
Subject: [PATCH 4/5] staging: xillybus: Use devm_ API on probe and remove
Date: Fri, 16 May 2014 11:26:38 +0300
Message-Id: <1400228799-8832-5-git-send-email-eli.billauer@gmail.com>
X-Mailer: git-send-email 1.7.2.3
In-Reply-To: <1400228799-8832-1-git-send-email-eli.billauer@gmail.com>
References: <1400228799-8832-1-git-send-email-eli.billauer@gmail.com>
X-AuthUser: billaue
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Suggested-by: Baruch Siach <baruch@tkos.co.il>
Signed-off-by: Eli Billauer <eli.billauer@gmail.com>
---
 drivers/staging/xillybus/xillybus.h      |    1 -
 drivers/staging/xillybus/xillybus_core.c |    2 +-
 drivers/staging/xillybus/xillybus_of.c   |   47 ++++-----------------
 drivers/staging/xillybus/xillybus_pcie.c |   65 ++++++++----------------------
 4 files changed, 27 insertions(+), 88 deletions(-)

diff --git a/drivers/staging/xillybus/xillybus.h b/drivers/staging/xillybus/xillybus.h
index e5e91d6..78a749a 100644
--- a/drivers/staging/xillybus/xillybus.h
+++ b/drivers/staging/xillybus/xillybus.h
@@ -116,7 +116,6 @@ struct xilly_endpoint {
 	 */
 	struct pci_dev *pdev;
 	struct device *dev;
-	struct resource res; /* OF devices only */
 	struct xilly_endpoint_hardware *ephw;
 
 	struct list_head ep_list;
diff --git a/drivers/staging/xillybus/xillybus_core.c b/drivers/staging/xillybus/xillybus_core.c
index b0a6696..fe8f9d2 100644
--- a/drivers/staging/xillybus/xillybus_core.c
+++ b/drivers/staging/xillybus/xillybus_core.c
@@ -2094,7 +2094,7 @@ struct xilly_endpoint *xillybus_init_endpoint(struct pci_dev *pdev,
 {
 	struct xilly_endpoint *endpoint;
 
-	endpoint = kzalloc(sizeof(*endpoint), GFP_KERNEL);
+	endpoint = devm_kzalloc(dev, sizeof(*endpoint), GFP_KERNEL);
 	if (!endpoint) {
 		dev_err(dev, "Failed to allocate memory. Aborting.\n");
 		return NULL;
diff --git a/drivers/staging/xillybus/xillybus_of.c b/drivers/staging/xillybus/xillybus_of.c
index 23a609b..46ea010 100644
--- a/drivers/staging/xillybus/xillybus_of.c
+++ b/drivers/staging/xillybus/xillybus_of.c
@@ -19,6 +19,7 @@
 #include <linux/of_address.h>
 #include <linux/of_device.h>
 #include <linux/of_platform.h>
+#include <linux/err.h>
 #include "xillybus.h"
 
 MODULE_DESCRIPTION("Xillybus driver for Open Firmware");
@@ -123,6 +124,7 @@ static int xilly_drv_probe(struct platform_device *op)
 	struct xilly_endpoint *endpoint;
 	int rc = 0;
 	int irq;
+	struct resource res;
 	struct xilly_endpoint_hardware *ephw = &of_hw;
 
 	if (of_property_read_bool(dev->of_node, "dma-coherent"))
@@ -135,38 +137,26 @@ static int xilly_drv_probe(struct platform_device *op)
 
 	dev_set_drvdata(dev, endpoint);
 
-	rc = of_address_to_resource(dev->of_node, 0, &endpoint->res);
+	rc = of_address_to_resource(dev->of_node, 0, &res);
 	if (rc) {
 		dev_warn(endpoint->dev,
 			 "Failed to obtain device tree resource\n");
-		goto failed_request_regions;
+		return rc;
 	}
 
-	if  (!request_mem_region(endpoint->res.start,
-				 resource_size(&endpoint->res), xillyname)) {
-		dev_err(endpoint->dev,
-			"request_mem_region failed. Aborting.\n");
-		rc = -EBUSY;
-		goto failed_request_regions;
-	}
+	endpoint->registers = devm_ioremap_resource(dev, &res);
 
-	endpoint->registers = of_iomap(dev->of_node, 0);
-	if (!endpoint->registers) {
-		dev_err(endpoint->dev,
-			"Failed to map I/O memory. Aborting.\n");
-		rc = -EIO;
-		goto failed_iomap0;
-	}
+	if (IS_ERR(endpoint->registers))
+		return PTR_ERR(endpoint->registers);
 
 	irq = irq_of_parse_and_map(dev->of_node, 0);
 
-	rc = request_irq(irq, xillybus_isr, 0, xillyname, endpoint);
+	rc = devm_request_irq(dev, irq, xillybus_isr, 0, xillyname, endpoint);
 
 	if (rc) {
 		dev_err(endpoint->dev,
 			"Failed to register IRQ handler. Aborting.\n");
-		rc = -ENODEV;
-		goto failed_register_irq;
+		return -ENODEV;
 	}
 
 	rc = xillybus_endpoint_discovery(endpoint);
@@ -174,18 +164,8 @@ static int xilly_drv_probe(struct platform_device *op)
 	if (!rc)
 		return 0;
 
-	free_irq(irq, endpoint);
-
-failed_register_irq:
-	iounmap(endpoint->registers);
-failed_iomap0:
-	release_mem_region(endpoint->res.start,
-			   resource_size(&endpoint->res));
-
-failed_request_regions:
 	xillybus_do_cleanup(&endpoint->cleanup, endpoint);
 
-	kfree(endpoint);
 	return rc;
 }
 
@@ -193,20 +173,11 @@ static int xilly_drv_remove(struct platform_device *op)
 {
 	struct device *dev = &op->dev;
 	struct xilly_endpoint *endpoint = dev_get_drvdata(dev);
-	int irq = irq_of_parse_and_map(dev->of_node, 0);
 
 	xillybus_endpoint_remove(endpoint);
 
-	free_irq(irq, endpoint);
-
-	iounmap(endpoint->registers);
-	release_mem_region(endpoint->res.start,
-			   resource_size(&endpoint->res));
-
 	xillybus_do_cleanup(&endpoint->cleanup, endpoint);
 
-	kfree(endpoint);
-
 	return 0;
 }
 
diff --git a/drivers/staging/xillybus/xillybus_pcie.c b/drivers/staging/xillybus/xillybus_pcie.c
index 51426d8..a4fe51c 100644
--- a/drivers/staging/xillybus/xillybus_pcie.c
+++ b/drivers/staging/xillybus/xillybus_pcie.c
@@ -141,38 +141,32 @@ static int xilly_probe(struct pci_dev *pdev,
 
 	pci_set_drvdata(pdev, endpoint);
 
-	rc = pci_enable_device(pdev);
-
-	/* L0s has caused packet drops. No power saving, thank you. */
-
-	pci_disable_link_state(pdev, PCIE_LINK_STATE_L0S);
+	rc = pcim_enable_device(pdev);
 
 	if (rc) {
 		dev_err(endpoint->dev,
-			"pci_enable_device() failed. Aborting.\n");
-		goto no_enable;
+			"pcim_enable_device() failed. Aborting.\n");
+		return rc;
 	}
 
+	/* L0s has caused packet drops. No power saving, thank you. */
+
+	pci_disable_link_state(pdev, PCIE_LINK_STATE_L0S);
+
 	if (!(pci_resource_flags(pdev, 0) & IORESOURCE_MEM)) {
 		dev_err(endpoint->dev,
 			"Incorrect BAR configuration. Aborting.\n");
-		rc = -ENODEV;
-		goto bad_bar;
+		return -ENODEV;
 	}
 
-	rc = pci_request_regions(pdev, xillyname);
+	rc = pcim_iomap_regions(pdev, 0x01, xillyname);
 	if (rc) {
 		dev_err(endpoint->dev,
-			"pci_request_regions() failed. Aborting.\n");
-		goto failed_request_regions;
+			"pcim_iomap_regions() failed. Aborting.\n");
+		return rc;
 	}
 
-	endpoint->registers = pci_iomap(pdev, 0, 128);
-	if (!endpoint->registers) {
-		dev_err(endpoint->dev, "Failed to map BAR 0. Aborting.\n");
-		rc = -EIO;
-		goto failed_iomap0;
-	}
+	endpoint->registers = pcim_iomap_table(pdev)[0];
 
 	pci_set_master(pdev);
 
@@ -180,16 +174,15 @@ static int xilly_probe(struct pci_dev *pdev,
 	if (pci_enable_msi(pdev)) {
 		dev_err(endpoint->dev,
 			"Failed to enable MSI interrupts. Aborting.\n");
-		rc = -ENODEV;
-		goto failed_enable_msi;
+		return -ENODEV;
 	}
-	rc = request_irq(pdev->irq, xillybus_isr, 0, xillyname, endpoint);
+	rc = devm_request_irq(&pdev->dev, pdev->irq, xillybus_isr, 0,
+			      xillyname, endpoint);
 
 	if (rc) {
 		dev_err(endpoint->dev,
 			"Failed to register MSI handler. Aborting.\n");
-		rc = -ENODEV;
-		goto failed_register_msi;
+		return -ENODEV;
 	}
 
 	/*
@@ -203,8 +196,7 @@ static int xilly_probe(struct pci_dev *pdev,
 		endpoint->dma_using_dac = 0;
 	else {
 		dev_err(endpoint->dev, "Failed to set DMA mask. Aborting.\n");
-		rc = -ENODEV;
-		goto failed_dmamask;
+		return -ENODEV;
 	}
 
 	rc = xillybus_endpoint_discovery(endpoint);
@@ -212,22 +204,8 @@ static int xilly_probe(struct pci_dev *pdev,
 	if (!rc)
 		return 0;
 
-failed_dmamask:
-	free_irq(pdev->irq, endpoint);
-failed_register_msi:
-	pci_disable_msi(pdev);
-failed_enable_msi:
-	/* pci_clear_master(pdev); Nobody else seems to do this */
-	pci_iounmap(pdev, endpoint->registers);
-failed_iomap0:
-	pci_release_regions(pdev);
-failed_request_regions:
-bad_bar:
-	pci_disable_device(pdev);
-no_enable:
 	xillybus_do_cleanup(&endpoint->cleanup, endpoint);
 
-	kfree(endpoint);
 	return rc;
 }
 
@@ -237,16 +215,7 @@ static void xilly_remove(struct pci_dev *pdev)
 
 	xillybus_endpoint_remove(endpoint);
 
-	free_irq(pdev->irq, endpoint);
-
-	pci_disable_msi(pdev);
-	pci_iounmap(pdev, endpoint->registers);
-	pci_release_regions(pdev);
-	pci_disable_device(pdev);
-
 	xillybus_do_cleanup(&endpoint->cleanup, endpoint);
-
-	kfree(endpoint);
 }
 
 MODULE_DEVICE_TABLE(pci, xillyids);
-- 
1.7.2.3

