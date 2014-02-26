Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752918AbaBZQaE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Feb 2014 11:30:04 -0500
Received: from mail1.bemta3.messagelabs.com ([195.245.230.162]:18200 "EHLO
	mail1.bemta3.messagelabs.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752038AbaBZQ3e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Feb 2014 11:29:34 -0500
X-Env-Sender: Johannes.Thumshirn@men.de
X-Msg-Ref: server-11.tower-38.messagelabs.com!1393432170!2581828!1
X-Originating-IP: [80.255.6.145]
X-StarScan-Received: 
X-StarScan-Version: 6.9.16; banners=-,-,-
X-VirusChecked: Checked
X-PGP-Universal: processed;
	by keys.men.de on Wed, 26 Feb 2014 17:29:31 +0100
From: Johannes Thumshirn <johannes.thumshirn@men.de>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jonathan Cameron <jic23@kernel.org>
CC: <linux-iio@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Johannes Thumshirn <johannes.thumshirn@men.de>
Subject: [PATCH v3 2/3] mcb: Add PCI carrier for MEN Chameleon Bus
Date: Wed, 26 Feb 2014 17:29:06 +0100
Message-ID: <1393432147-31355-3-git-send-email-johannes.thumshirn@men.de>
X-Mailer: git-send-email 1.8.5.4
In-Reply-To: <1393432147-31355-1-git-send-email-johannes.thumshirn@men.de>
References: <1393432147-31355-1-git-send-email-johannes.thumshirn@men.de>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [192.1.1.31]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add support for MCB over PCI devices. Both PCI attached on-board Chameleon FPGAs
as well as CompactPCI based MCB carrier cards are supported with this driver.

Signed-off-by: Johannes Thumshirn <johannes.thumshirn@men.de>
---
 drivers/mcb/Kconfig        |  14 ++++++
 drivers/mcb/Makefile       |   2 +
 drivers/mcb/mcb-internal.h |   2 +
 drivers/mcb/mcb-pci.c      | 114 +++++++++++++++++++++++++++++++++++++++++++++
 4 files changed, 132 insertions(+)
 create mode 100644 drivers/mcb/mcb-pci.c

diff --git a/drivers/mcb/Kconfig b/drivers/mcb/Kconfig
index 44c82d6..b8f5d46 100644
--- a/drivers/mcb/Kconfig
+++ b/drivers/mcb/Kconfig
@@ -13,3 +13,17 @@ menuconfig MCB
 	   for these devices.
 
 	   If build as a module, the module is called mcb.ko
+
+if MCB
+config MCB_PCI
+	   tristate "PCI based MCB carrier"
+	   default m
+	   help
+
+	   This is a MCB carrier on a PCI device. Both PCI attached on-board
+	   FPGAs as well as CompactPCI attached MCB FPGAs are supported with
+	   this driver.
+
+	   If build as a module, the module is called mcb-pci.ko
+
+endif # MCB
diff --git a/drivers/mcb/Makefile b/drivers/mcb/Makefile
index 2d9a751..1ae1413 100644
--- a/drivers/mcb/Makefile
+++ b/drivers/mcb/Makefile
@@ -3,3 +3,5 @@ obj-$(CONFIG_MCB) += mcb.o
 
 mcb-y += mcb-core.o
 mcb-y += mcb-parse.o
+
+obj-$(CONFIG_MCB_PCI) += mcb-pci.o
diff --git a/drivers/mcb/mcb-internal.h b/drivers/mcb/mcb-internal.h
index db22777..f956ef2 100644
--- a/drivers/mcb/mcb-internal.h
+++ b/drivers/mcb/mcb-internal.h
@@ -3,6 +3,8 @@
 
 #include <linux/types.h>
 
+#define PCI_VENDOR_ID_MEN		0x1a88
+#define PCI_DEVICE_ID_MEN_CHAMELEON	0x4d45
 #define CHAMELEON_FILENAME_LEN		12
 #define CHAMELEONV2_MAGIC		0xabce
 
diff --git a/drivers/mcb/mcb-pci.c b/drivers/mcb/mcb-pci.c
new file mode 100644
index 0000000..99c742c
--- /dev/null
+++ b/drivers/mcb/mcb-pci.c
@@ -0,0 +1,114 @@
+/*
+ * MEN Chameleon Bus.
+ *
+ * Copyright (C) 2014 MEN Mikroelektronik GmbH (www.men.de)
+ * Author: Johannes Thumshirn <johannes.thumshirn@men.de>
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of the GNU General Public License as published by the Free
+ * Software Foundation; version 2 of the License.
+ */
+
+#include <linux/module.h>
+#include <linux/pci.h>
+#include <linux/mcb.h>
+
+#include "mcb-internal.h"
+
+struct priv {
+	struct mcb_bus *bus;
+	void __iomem *base;
+};
+
+static int mcb_pci_probe(struct pci_dev *pdev, const struct pci_device_id *id)
+{
+	struct priv *priv;
+	phys_addr_t mapbase;
+	int ret;
+	int num_cells;
+	unsigned long flags;
+
+	priv = devm_kzalloc(&pdev->dev, sizeof(struct priv), GFP_KERNEL);
+	if (!priv)
+		return -ENOMEM;
+
+	ret = pci_enable_device(pdev);
+	if (ret) {
+		dev_err(&pdev->dev, "Failed to enable PCI device\n");
+		return -ENODEV;
+	}
+
+	mapbase = pci_resource_start(pdev, 0);
+	if (!mapbase) {
+		dev_err(&pdev->dev, "No PCI resource\n");
+		goto err_start;
+	}
+
+	ret = pci_request_region(pdev, 0, KBUILD_MODNAME);
+	if (ret) {
+		dev_err(&pdev->dev, "Failed to request PCI BARs\n");
+		goto err_start;
+	}
+
+	priv->base = pci_iomap(pdev, 0, 0);
+	if (!priv->base) {
+		dev_err(&pdev->dev, "Cannot ioremap\n");
+		ret = -ENOMEM;
+		goto err_ioremap;
+	}
+
+	flags = pci_resource_flags(pdev, 0);
+	if (flags & IORESOURCE_IO) {
+		ret = -ENOTSUPP;
+		dev_err(&pdev->dev,
+			"IO mapped PCI devices are not supported\n");
+		goto err_ioremap;
+	}
+
+	pci_set_drvdata(pdev, priv);
+
+	priv->bus = mcb_alloc_bus();
+
+	ret = chameleon_parse_cells(priv->bus, mapbase, priv->base);
+	if (ret < 0)
+		goto err_drvdata;
+	num_cells = ret;
+
+	dev_dbg(&pdev->dev, "Found %d cells\n", num_cells);
+
+	mcb_bus_add_devices(priv->bus);
+
+err_drvdata:
+	pci_iounmap(pdev, priv->base);
+err_ioremap:
+	pci_release_region(pdev, 0);
+err_start:
+	pci_disable_device(pdev);
+	return ret;
+}
+
+static void mcb_pci_remove(struct pci_dev *pdev)
+{
+	struct priv *priv = pci_get_drvdata(pdev);
+
+	mcb_release_bus(priv->bus);
+}
+
+static const struct pci_device_id mcb_pci_tbl[] = {
+	{ PCI_DEVICE(PCI_VENDOR_ID_MEN, PCI_DEVICE_ID_MEN_CHAMELEON) },
+	{ 0 },
+};
+MODULE_DEVICE_TABLE(pci, mcb_pci_tbl);
+
+static struct pci_driver mcb_pci_driver = {
+	.name = "mcb-pci",
+	.id_table = mcb_pci_tbl,
+	.probe = mcb_pci_probe,
+	.remove = mcb_pci_remove,
+};
+
+module_pci_driver(mcb_pci_driver);
+
+MODULE_AUTHOR("Johannes Thumshirn <johannes.thumshirn@men.de>");
+MODULE_LICENSE("GPL");
+MODULE_DESCRIPTION("MCB over PCI support");
-- 
1.8.5.4

