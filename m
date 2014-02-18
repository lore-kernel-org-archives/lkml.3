Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932319AbaBRPkx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Feb 2014 10:40:53 -0500
Received: from mail1.bemta5.messagelabs.com ([195.245.231.137]:32566 "EHLO
	mail1.bemta5.messagelabs.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932104AbaBRPkt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Feb 2014 10:40:49 -0500
X-Greylist: delayed 374 seconds by postgrey-1.27 at vger.kernel.org; Tue, 18 Feb 2014 10:40:48 EST
X-Env-Sender: Johannes.Thumshirn@men.de
X-Msg-Ref: server-9.tower-180.messagelabs.com!1392737673!26169754!1
X-Originating-IP: [80.255.6.145]
X-StarScan-Received: 
X-StarScan-Version: 6.9.16; banners=-,-,-
X-VirusChecked: Checked
X-PGP-Universal: processed;
	by keys.men.de on Tue, 18 Feb 2014 16:34:34 +0100
From: Johannes Thumshirn <johannes.thumshirn@men.de>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jonathan Cameron <jic23@kernel.org>
CC: <linux-iio@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Johannes Thumshirn <johannes.thumshirn@men.de>
Subject: [PATCH 2/3] mcb: Add PCI carrier for MEN Chameleon Bus
Date: Tue, 18 Feb 2014 16:34:13 +0100
Message-ID: <1392737654-22682-3-git-send-email-johannes.thumshirn@men.de>
X-Mailer: git-send-email 1.8.5.4
In-Reply-To: <1392737654-22682-1-git-send-email-johannes.thumshirn@men.de>
References: <1392737654-22682-1-git-send-email-johannes.thumshirn@men.de>
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
 drivers/mcb/Kconfig   |  13 ++++++
 drivers/mcb/Makefile  |   2 +
 drivers/mcb/mcb-pci.c | 108 ++++++++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 123 insertions(+)
 create mode 100644 drivers/mcb/mcb-pci.c

diff --git a/drivers/mcb/Kconfig b/drivers/mcb/Kconfig
index 9e7d6f5..8b058bc 100644
--- a/drivers/mcb/Kconfig
+++ b/drivers/mcb/Kconfig
@@ -14,3 +14,16 @@ menuconfig MCB
 
 	   If build as a module, the module is called mcb.ko
 
+if MCB
+config MCB_PCI
+	   tristate "PCI based MCB carrier"
+	   default m if MCB
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
diff --git a/drivers/mcb/mcb-pci.c b/drivers/mcb/mcb-pci.c
new file mode 100644
index 0000000..0b1eafa
--- /dev/null
+++ b/drivers/mcb/mcb-pci.c
@@ -0,0 +1,108 @@
+#include <linux/module.h>
+#include <linux/pci.h>
+#include <linux/mcb.h>
+
+#include "mcb-internal.h"
+
+static struct mcb_bus *bus;
+struct priv {
+	void __iomem *base;
+};
+
+static int mcb_pci_probe(struct pci_dev *pdev, const struct pci_device_id *id)
+{
+	struct priv *priv;
+	phys_addr_t mapbase;
+	int ret = 0;
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
+	bus = mcb_alloc_bus();
+
+	ret = parse_chameleon_cells(bus, mapbase, priv->base);
+	if (ret < 0)
+		goto err_drvdata;
+	num_cells = ret;
+
+	dev_dbg(&pdev->dev, "Found %d cells\n", num_cells);
+
+	mcb_bus_add_devices(bus);
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
+	mcb_release_bus(bus);
+
+	pci_iounmap(pdev, priv->base);
+	pci_release_region(pdev, 0);
+	pci_disable_device(pdev);
+	pci_set_drvdata(pdev, NULL);
+}
+
+static struct pci_device_id mcb_pci_tbl[] = {
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

