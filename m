Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752409AbaJ1QTB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2014 12:19:01 -0400
Received: from mail1.bemta14.messagelabs.com ([193.109.254.109]:14401 "EHLO
	mail1.bemta14.messagelabs.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751722AbaJ1QS5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Oct 2014 12:18:57 -0400
X-Greylist: delayed 378 seconds by postgrey-1.27 at vger.kernel.org; Tue, 28 Oct 2014 12:18:56 EDT
X-Env-Sender: Johannes.Thumshirn@men.de
X-Msg-Ref: server-10.tower-193.messagelabs.com!1414512755!16011500!1
X-Originating-IP: [80.255.6.145]
X-StarScan-Received: 
X-StarScan-Version: 6.12.3; banners=-,-,-
X-VirusChecked: Checked
X-PGP-Universal: processed;
	by keys.men.de on Tue, 28 Oct 2014 17:12:35 +0100
From: Johannes Thumshirn <johannes.thumshirn@men.de>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC: Bjorn Helgaas <bhelgaas@google.com>,
        Andreas Werner <andreas.werner@men.de>, <linux-kernel@vger.kernel.org>,
        Johannes Thumshirn <johannes.thumshirn@men.de>
Subject: [PATCH] mcb: mcb-pci: Only remap the 1st 0x200 bytes of BAR 0
Date: Tue, 28 Oct 2014 17:11:32 +0100
Message-ID: <1414512692-1433-1-git-send-email-johannes.thumshirn@men.de>
X-Mailer: git-send-email 1.9.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [192.1.1.31]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently it is not possible to have a kernel with built-in MCB attached
devices. This results out of the fact that mcb-pci requests PCI BAR 0, then
parses the chameleon table and calls the driver's probe function before
releasing BAR 0 again. When building the kernel with modules this is not a
problem (and therefore it wasn't detected by my tests yet).

A solution is to only remap the 1st 0x200 bytes of a Chameleon PCI device.
0x200 bytes is the maximum size of a Chameleon v2 Table.

Also this patch stops disabling the PCI device on successful registration of MCB
devices.

Signed-off-by: Johannes Thumshirn <johannes.thumshirn@men.de>
Suggested-by: Bjorn Helgaas <bhelgaas@google.com>
---
 drivers/mcb/mcb-internal.h |  1 +
 drivers/mcb/mcb-pci.c      | 27 ++++++++++++++++++---------
 2 files changed, 19 insertions(+), 9 deletions(-)

diff --git a/drivers/mcb/mcb-internal.h b/drivers/mcb/mcb-internal.h
index f956ef2..fb7493d 100644
--- a/drivers/mcb/mcb-internal.h
+++ b/drivers/mcb/mcb-internal.h
@@ -7,6 +7,7 @@
 #define PCI_DEVICE_ID_MEN_CHAMELEON	0x4d45
 #define CHAMELEON_FILENAME_LEN		12
 #define CHAMELEONV2_MAGIC		0xabce
+#define CHAM_HEADER_SIZE		0x200

 enum chameleon_descriptor_type {
 	CHAMELEON_DTYPE_GENERAL = 0x0,
diff --git a/drivers/mcb/mcb-pci.c b/drivers/mcb/mcb-pci.c
index b591819..5e1bd5d 100644
--- a/drivers/mcb/mcb-pci.c
+++ b/drivers/mcb/mcb-pci.c
@@ -17,6 +17,7 @@

 struct priv {
 	struct mcb_bus *bus;
+	phys_addr_t mapbase;
 	void __iomem *base;
 };

@@ -31,8 +32,8 @@ static int mcb_pci_get_irq(struct mcb_device *mdev)

 static int mcb_pci_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 {
+	struct resource *res;
 	struct priv *priv;
-	phys_addr_t mapbase;
 	int ret;
 	int num_cells;
 	unsigned long flags;
@@ -47,19 +48,21 @@ static int mcb_pci_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 		return -ENODEV;
 	}

-	mapbase = pci_resource_start(pdev, 0);
-	if (!mapbase) {
+	priv->mapbase = pci_resource_start(pdev, 0);
+	if (!priv->mapbase) {
 		dev_err(&pdev->dev, "No PCI resource\n");
 		goto err_start;
 	}

-	ret = pci_request_region(pdev, 0, KBUILD_MODNAME);
-	if (ret) {
-		dev_err(&pdev->dev, "Failed to request PCI BARs\n");
+	res = request_mem_region(priv->mapbase, CHAM_HEADER_SIZE,
+				 KBUILD_MODNAME);
+	if (IS_ERR(res)) {
+		dev_err(&pdev->dev, "Failed to request PCI memory\n");
+		ret = PTR_ERR(res);
 		goto err_start;
 	}

-	priv->base = pci_iomap(pdev, 0, 0);
+	priv->base = ioremap(priv->mapbase, CHAM_HEADER_SIZE);
 	if (!priv->base) {
 		dev_err(&pdev->dev, "Cannot ioremap\n");
 		ret = -ENOMEM;
@@ -84,7 +87,7 @@ static int mcb_pci_probe(struct pci_dev *pdev, const struct pci_device_id *id)

 	priv->bus->get_irq = mcb_pci_get_irq;

-	ret = chameleon_parse_cells(priv->bus, mapbase, priv->base);
+	ret = chameleon_parse_cells(priv->bus, priv->mapbase, priv->base);
 	if (ret < 0)
 		goto err_drvdata;
 	num_cells = ret;
@@ -93,8 +96,10 @@ static int mcb_pci_probe(struct pci_dev *pdev, const struct pci_device_id *id)

 	mcb_bus_add_devices(priv->bus);

+	return 0;
+
 err_drvdata:
-	pci_iounmap(pdev, priv->base);
+	iounmap(priv->base);
 err_ioremap:
 	pci_release_region(pdev, 0);
 err_start:
@@ -107,6 +112,10 @@ static void mcb_pci_remove(struct pci_dev *pdev)
 	struct priv *priv = pci_get_drvdata(pdev);

 	mcb_release_bus(priv->bus);
+
+	iounmap(priv->base);
+	release_region(priv->mapbase, CHAM_HEADER_SIZE);
+	pci_disable_device(pdev);
 }

 static const struct pci_device_id mcb_pci_tbl[] = {
--
1.9.1
