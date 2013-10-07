Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755395Ab3JGKM4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Oct 2013 06:12:56 -0400
Received: from mail-ie0-f174.google.com ([209.85.223.174]:54449 "EHLO
	mail-ie0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755256Ab3JGKMr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Oct 2013 06:12:47 -0400
From: Matt Porter <matt.porter@linaro.org>
To: Felipe Balbi <balbi@ti.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Rob Herring <rob.herring@calxeda.com>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Stephen Warren <swarren@nvidia.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Christian Daudt <bcm@fixthebug.org>
Cc: Paul Zimmerman <paulz@synopsys.com>,
        Linux USB List <linux-usb@vger.kernel.org>,
        Linux ARM Kernel List <linux-arm-kernel@lists.infradead.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Devicetree List <devicetree@vger.kernel.org>,
        Linaro Patches <patches@linaro.org>
Subject: [PATCH 4/5] usb: phy: add Broadcom Kona USB PHY driver
Date: Mon,  7 Oct 2013 06:12:31 -0400
Message-Id: <1381140752-312-5-git-send-email-matt.porter@linaro.org>
X-Mailer: git-send-email 1.8.4
In-Reply-To: <1381140752-312-1-git-send-email-matt.porter@linaro.org>
References: <1381140752-312-1-git-send-email-matt.porter@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add a USB PHY driver for BCM281xx devices. This driver makes use of the
Broadcom Kona USB control driver to control init/shutdown of the PHY.

Signed-off-by: Matt Porter <matt.porter@linaro.org>
Reviewed-by: Markus Mayer <markus.mayer@linaro.org>
Reviewed-by: Tim Kryger <tim.kryger@linaro.org>
---
 .../devicetree/bindings/usb/bcm-kona-usb-phy.txt   | 10 +++
 drivers/usb/phy/Kconfig                            |  7 ++
 drivers/usb/phy/Makefile                           |  1 +
 drivers/usb/phy/phy-bcm-kona-usb2.c                | 99 ++++++++++++++++++++++
 4 files changed, 117 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/usb/bcm-kona-usb-phy.txt
 create mode 100644 drivers/usb/phy/phy-bcm-kona-usb2.c

diff --git a/Documentation/devicetree/bindings/usb/bcm-kona-usb-phy.txt b/Documentation/devicetree/bindings/usb/bcm-kona-usb-phy.txt
new file mode 100644
index 0000000..a935fe2
--- /dev/null
+++ b/Documentation/devicetree/bindings/usb/bcm-kona-usb-phy.txt
@@ -0,0 +1,10 @@
+BROADCOM KONA USB PHY
+
+Required properties:
+ - compatible: brcm,kona-usb2
+
+Example:
+
+	usbphy: usbphy {
+		compatible = "brcm,kona-usb2";
+	};
diff --git a/drivers/usb/phy/Kconfig b/drivers/usb/phy/Kconfig
index 2b7b4f1..d063204 100644
--- a/drivers/usb/phy/Kconfig
+++ b/drivers/usb/phy/Kconfig
@@ -105,6 +105,13 @@ config BCM_KONA_CTRL_USB
 	help
 	  Enable this to support the Broadcom Kona USB control block
 
+config BCM_KONA_PHY_USB2
+	tristate "Broadcom Kona USB2 PHY Driver"
+	select USB_PHY
+	select BCM_KONA_CTRL_USB
+	help
+	  Enable this to support the Broadcom Kona USB 2.0 PHY.
+
 config SAMSUNG_USBPHY
 	tristate
 	help
diff --git a/drivers/usb/phy/Makefile b/drivers/usb/phy/Makefile
index 98c545e..227fba5 100644
--- a/drivers/usb/phy/Makefile
+++ b/drivers/usb/phy/Makefile
@@ -16,6 +16,7 @@ obj-$(CONFIG_OMAP_CONTROL_USB)		+= phy-omap-control.o
 obj-$(CONFIG_AM335X_CONTROL_USB)	+= phy-am335x-control.o
 obj-$(CONFIG_AM335X_PHY_USB)		+= phy-am335x.o
 obj-$(CONFIG_BCM_KONA_CTRL_USB)		+= phy-bcm-kona-ctrl.o
+obj-$(CONFIG_BCM_KONA_PHY_USB2)		+= phy-bcm-kona-usb2.o
 obj-$(CONFIG_OMAP_USB2)			+= phy-omap-usb2.o
 obj-$(CONFIG_OMAP_USB3)			+= phy-omap-usb3.o
 obj-$(CONFIG_SAMSUNG_USBPHY)		+= phy-samsung-usb.o
diff --git a/drivers/usb/phy/phy-bcm-kona-usb2.c b/drivers/usb/phy/phy-bcm-kona-usb2.c
new file mode 100644
index 0000000..21aee4a
--- /dev/null
+++ b/drivers/usb/phy/phy-bcm-kona-usb2.c
@@ -0,0 +1,99 @@
+/*
+ * phy-bcm-kona-control.c - Broadcom Kona USB2 Phy Driver
+ *
+ * Copyright (C) 2013 Linaro Limited
+ * Matt Porter <matt.porter@linaro.org>
+ *
+ * This software is licensed under the terms of the GNU General Public
+ * License version 2, as published by the Free Software Foundation, and
+ * may be copied, distributed, and modified under those terms.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ */
+
+#include <linux/module.h>
+#include <linux/of.h>
+#include <linux/platform_device.h>
+
+#include "bcm-kona-usb.h"
+
+static int bcm_kona_phy_init(struct usb_phy *uphy)
+{
+	struct bcm_kona_usb *phy = dev_get_drvdata(uphy->dev);
+
+	bcm_kona_ctrl_usb_phy_power(phy->ctrl_dev, 1);
+
+	return 0;
+}
+
+static void bcm_kona_phy_shutdown(struct usb_phy *uphy)
+{
+	struct bcm_kona_usb *phy = dev_get_drvdata(uphy->dev);
+
+	bcm_kona_ctrl_usb_phy_power(phy->ctrl_dev, 0);
+}
+
+static int bcm_kona_usb2_probe(struct platform_device *pdev)
+{
+	struct device *dev = &pdev->dev;
+	struct bcm_kona_usb *phy;
+
+	phy = devm_kzalloc(dev, sizeof(*phy), GFP_KERNEL);
+	if (!phy)
+		return -ENOMEM;
+
+	phy->ctrl_dev = bcm_kona_get_ctrl_dev();
+	if (IS_ERR(phy->ctrl_dev)) {
+		dev_dbg(&pdev->dev, "Failed to get control device\n");
+		return -ENODEV;
+	}
+
+	phy->dev		= dev;
+	phy->phy.dev		= phy->dev;
+	phy->phy.label		= "bcm-kona-usb2";
+	phy->phy.init		= bcm_kona_phy_init;
+	phy->phy.shutdown	= bcm_kona_phy_shutdown;
+	phy->phy.type		= USB_PHY_TYPE_USB2;
+
+	platform_set_drvdata(pdev, phy);
+
+	usb_add_phy_dev(&phy->phy);
+
+	return 0;
+}
+
+static int bcm_kona_usb2_remove(struct platform_device *pdev)
+{
+	struct bcm_kona_usb *phy = platform_get_drvdata(pdev);
+
+	usb_remove_phy(&phy->phy);
+
+	return 0;
+}
+
+static const struct of_device_id bcm_kona_usb2_dt_ids[] = {
+	{ .compatible = "brcm,kona-usb2" },
+	{ /* sentinel */ }
+};
+
+MODULE_DEVICE_TABLE(of, bcm_kona_usb2_dt_ids);
+
+static struct platform_driver bcm_kona_usb2_driver = {
+	.probe		= bcm_kona_usb2_probe,
+	.remove		= bcm_kona_usb2_remove,
+	.driver		= {
+		.name	= "bcm-kona-usb2",
+		.owner	= THIS_MODULE,
+		.of_match_table = bcm_kona_usb2_dt_ids,
+	},
+};
+
+module_platform_driver(bcm_kona_usb2_driver);
+
+MODULE_ALIAS("platform:bcm-kona-usb2");
+MODULE_AUTHOR("Matt Porter");
+MODULE_DESCRIPTION("BCM Kona USB 2.0 PHY driver");
+MODULE_LICENSE("GPL v2");
-- 
1.8.4

