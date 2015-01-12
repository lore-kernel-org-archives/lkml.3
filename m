Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751636AbbALP1K (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2015 10:27:10 -0500
Received: from mail1.bemta14.messagelabs.com ([193.109.254.118]:18903 "EHLO
	mail1.bemta14.messagelabs.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751089AbbALP1I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2015 10:27:08 -0500
X-Env-Sender: Johannes.Thumshirn@men.de
X-Msg-Ref: server-10.tower-194.messagelabs.com!1421076424!27226850!1
X-Originating-IP: [80.255.6.145]
X-StarScan-Received: 
X-StarScan-Version: 6.12.5; banners=-,-,-
X-VirusChecked: Checked
X-PGP-Universal: processed;
	by keys.men.de on Mon, 12 Jan 2015 16:27:04 +0100
From: Johannes Thumshirn <johannes.thumshirn@men.de>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Julia Lawall <julia.lawall@lip6.fr>
CC: <kbuild@01.org>, <linux-kernel@vger.kernel.org>,
        Johannes Thumshirn <johannes.thumshirn@men.de>
Subject: [PATCH] mcb: Fix error path of mcb_pci_probe
Date: Mon, 12 Jan 2015 16:26:32 +0100
Message-ID: <1421076392-32597-1-git-send-email-johannes.thumshirn@men.de>
X-Mailer: git-send-email 1.9.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [192.1.1.31]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If a MCB PCI Carrier device is IO mapped insted of memory-mapped (which is
currently unsupported by the upstream driver) the probe function bails out
with -ENOTSUPP.

In this case the memory of the PCI device was not unmapped.
Also rename error label to reflect what will happen at the destination (suggested
by Julia Lawall <julia.lawall@lip6.fr>.

Signed-off-by: Johannes Thumshirn <johannes.thumshirn@men.de>
Reported-by: kbuild test robot <fengguang.wu@intel.com>
---
 drivers/mcb/mcb-pci.c | 18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

diff --git a/drivers/mcb/mcb-pci.c b/drivers/mcb/mcb-pci.c
index 5e1bd5d..0af7361 100644
--- a/drivers/mcb/mcb-pci.c
+++ b/drivers/mcb/mcb-pci.c
@@ -51,7 +51,7 @@ static int mcb_pci_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 	priv->mapbase = pci_resource_start(pdev, 0);
 	if (!priv->mapbase) {
 		dev_err(&pdev->dev, "No PCI resource\n");
-		goto err_start;
+		goto out_disable;
 	}
 
 	res = request_mem_region(priv->mapbase, CHAM_HEADER_SIZE,
@@ -59,14 +59,14 @@ static int mcb_pci_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 	if (IS_ERR(res)) {
 		dev_err(&pdev->dev, "Failed to request PCI memory\n");
 		ret = PTR_ERR(res);
-		goto err_start;
+		goto out_disable;
 	}
 
 	priv->base = ioremap(priv->mapbase, CHAM_HEADER_SIZE);
 	if (!priv->base) {
 		dev_err(&pdev->dev, "Cannot ioremap\n");
 		ret = -ENOMEM;
-		goto err_ioremap;
+		goto out_release;
 	}
 
 	flags = pci_resource_flags(pdev, 0);
@@ -74,7 +74,7 @@ static int mcb_pci_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 		ret = -ENOTSUPP;
 		dev_err(&pdev->dev,
 			"IO mapped PCI devices are not supported\n");
-		goto err_ioremap;
+		goto out_release;
 	}
 
 	pci_set_drvdata(pdev, priv);
@@ -82,14 +82,14 @@ static int mcb_pci_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 	priv->bus = mcb_alloc_bus(&pdev->dev);
 	if (IS_ERR(priv->bus)) {
 		ret = PTR_ERR(priv->bus);
-		goto err_drvdata;
+		goto out_iounmap;
 	}
 
 	priv->bus->get_irq = mcb_pci_get_irq;
 
 	ret = chameleon_parse_cells(priv->bus, priv->mapbase, priv->base);
 	if (ret < 0)
-		goto err_drvdata;
+		goto out_iounmap;
 	num_cells = ret;
 
 	dev_dbg(&pdev->dev, "Found %d cells\n", num_cells);
@@ -98,11 +98,11 @@ static int mcb_pci_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 
 	return 0;
 
-err_drvdata:
+out_iounmap:
 	iounmap(priv->base);
-err_ioremap:
+out_release:
 	pci_release_region(pdev, 0);
-err_start:
+out_disable:
 	pci_disable_device(pdev);
 	return ret;
 }
-- 
1.9.1

