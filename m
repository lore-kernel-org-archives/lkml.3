Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965806Ab3GSMfB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Jul 2013 08:35:01 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:53906 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965646Ab3GSMe6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Jul 2013 08:34:58 -0400
From: George Cherian <george.cherian@ti.com>
To: <linux-usb@vger.kernel.org>
CC: <balbi@ti.com>, <linux-kernel@vger.kernel.org>,
        <gregkh@linuxfoundation.org>, <linux-omap@vger.kernel.org>,
        <kishon@ti.com>, <bigeasy@linutronix.de>,
        George Cherian <george.cherian@ti.com>
Subject: [PATCH v2 2/4] phy: phy-amxxxx-usb: Add PHY driver for amxxxx platform
Date: Fri, 19 Jul 2013 18:04:35 +0530
Message-ID: <1374237277-17769-3-git-send-email-george.cherian@ti.com>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1374237277-17769-1-git-send-email-george.cherian@ti.com>
References: <1374237277-17769-1-git-send-email-george.cherian@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adds phy driver support for am33xx platform, the host/device
peripheral controller shall get this phy object to control the phy
operations.

Signed-off-by: George Cherian <george.cherian@ti.com>
---
 drivers/phy/Kconfig          |  12 +++
 drivers/phy/Makefile         |   1 +
 drivers/phy/phy-amxxxx-usb.c | 222 +++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 235 insertions(+)
 create mode 100644 drivers/phy/phy-amxxxx-usb.c

diff --git a/drivers/phy/Kconfig b/drivers/phy/Kconfig
index 5f85909..55087ab 100644
--- a/drivers/phy/Kconfig
+++ b/drivers/phy/Kconfig
@@ -11,3 +11,15 @@ menuconfig GENERIC_PHY
 	  devices present in the kernel. This layer will have the generic
 	  API by which phy drivers can create PHY using the phy framework and
 	  phy users can obtain reference to the PHY.
+if GENERIC_PHY
+
+config PHY_AMXXXX_USB
+	tristate "AMXXXX USB2 PHY Driver"
+	depends on SOC_AM33XX
+	help
+	  Enable this to support the transceiver that is part of SOC. This
+	  phy supports all LS/FS/HS speed and also supports OTG functionality.
+	  The USB OTG controller communicates with this phy through stand UTMI
+	  interface.
+
+endif
diff --git a/drivers/phy/Makefile b/drivers/phy/Makefile
index 9e9560f..471c525 100644
--- a/drivers/phy/Makefile
+++ b/drivers/phy/Makefile
@@ -3,3 +3,4 @@
 #
 
 obj-$(CONFIG_GENERIC_PHY)	+= phy-core.o
+obj-$(CONFIG_PHY_AMXXXX_USB)	+= phy-amxxxx-usb.o
diff --git a/drivers/phy/phy-amxxxx-usb.c b/drivers/phy/phy-amxxxx-usb.c
new file mode 100644
index 0000000..d0b0749
--- /dev/null
+++ b/drivers/phy/phy-amxxxx-usb.c
@@ -0,0 +1,222 @@
+/*
+ * phy-amxxxx-usb.c - USB PHY, talking to usb controller in AMXXX.
+ *
+ * Copyright (C) 2013 Texas Instruments Incorporated - http://www.ti.com
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * Author: George Cherian <george.cherian@ti.com>
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ */
+
+#include <linux/module.h>
+#include <linux/platform_device.h>
+#include <linux/of.h>
+#include <linux/usb/otg.h>
+#include <linux/clk.h>
+#include <linux/pm_runtime.h>
+#include <linux/usb/omap_control_usb.h>
+#include <linux/phy/phy.h>
+
+struct amxxxx_usb {
+	struct usb_phy	phy;
+	struct device	*dev;
+	struct device	*control_dev;
+	struct clk	*optclk;
+	u32		id;
+};
+
+#define phy_to_amxxxxphy(x)	container_of((x), struct amxxxx_phy, phy)
+
+
+static int amxxxx_usb_set_host(struct usb_otg *otg, struct usb_bus *host)
+{
+	struct usb_phy	*phy = otg->phy;
+
+	otg->host = host;
+	if (!host)
+		phy->state = OTG_STATE_UNDEFINED;
+
+	return 0;
+}
+
+static int amxxxx_usb_set_peripheral(struct usb_otg *otg,
+		struct usb_gadget *gadget)
+{
+	struct usb_phy	*phy = otg->phy;
+
+	otg->gadget = gadget;
+	if (!gadget)
+		phy->state = OTG_STATE_UNDEFINED;
+
+	return 0;
+}
+
+
+
+static int amxxxx_usb_power_off(struct phy *x)
+{
+	struct amxxxx_usb *phy = phy_get_drvdata(x);
+
+	omap_control_am335x_phy_power(phy->control_dev, 0, phy->id);
+
+	return 0;
+}
+
+static int amxxxx_usb_power_on(struct phy *x)
+{
+	struct amxxxx_usb *phy = phy_get_drvdata(x);
+
+	omap_control_am335x_phy_power(phy->control_dev, 1, phy->id);
+
+	return 0;
+}
+
+static struct phy_ops ops = {
+	.power_on	= amxxxx_usb_power_on,
+	.power_off	= amxxxx_usb_power_off,
+	.owner		= THIS_MODULE,
+};
+
+static int amxxxx_usb2_probe(struct platform_device *pdev)
+{
+	struct device_node *np = pdev->dev.of_node;
+	struct amxxxx_usb			*phy;
+	struct phy			*generic_phy;
+	struct usb_otg			*otg;
+	struct phy_provider		*phy_provider;
+
+	phy = devm_kzalloc(&pdev->dev, sizeof(*phy), GFP_KERNEL);
+
+	otg = devm_kzalloc(&pdev->dev, sizeof(*otg), GFP_KERNEL);
+
+	phy->dev		= &pdev->dev;
+
+	if (np)
+		of_property_read_u32(np, "id", &phy->id);
+
+	phy->phy.dev		= phy->dev;
+	phy->phy.label		= "amxxxx-usb2";
+	phy->phy.otg		= otg;
+	phy->phy.type		= USB_PHY_TYPE_USB2;
+
+	phy_provider = devm_of_phy_provider_register(phy->dev,
+			of_phy_simple_xlate);
+	if (IS_ERR(phy_provider))
+		return PTR_ERR(phy_provider);
+
+	phy->control_dev = omap_get_control_dev();
+	if (IS_ERR(phy->control_dev)) {
+		dev_dbg(&pdev->dev, "Failed to get control device\n");
+		return -ENODEV;
+	}
+
+	omap_control_am335x_phy_power(phy->control_dev, 0, phy->id);
+
+	otg->set_host		= amxxxx_usb_set_host;
+	otg->set_peripheral	= amxxxx_usb_set_peripheral;
+	otg->phy		= &phy->phy;
+
+	platform_set_drvdata(pdev, phy);
+	pm_runtime_enable(phy->dev);
+
+	generic_phy = devm_phy_create(phy->dev, 0, &ops, "amxxxx-usb2");
+	if (IS_ERR(generic_phy))
+		return PTR_ERR(generic_phy);
+
+	phy_set_drvdata(generic_phy, phy);
+
+	phy->optclk = devm_clk_get(phy->dev, "usbotg_fck");
+	if (IS_ERR(phy->optclk))
+		dev_err(&pdev->dev, "unable to get usbotg_fck\n");
+	else
+		clk_prepare(phy->optclk);
+
+	device_init_wakeup(&pdev->dev, true);
+	usb_add_phy_dev(&phy->phy);
+
+	return 0;
+}
+
+static int amxxxx_usb2_remove(struct platform_device *pdev)
+{
+	struct amxxxx_usb	*phy = platform_get_drvdata(pdev);
+
+	clk_unprepare(phy->optclk);
+	usb_remove_phy(&phy->phy);
+
+	return 0;
+}
+
+#ifdef CONFIG_PM_RUNTIME
+
+static int amxxxx_usb2_runtime_suspend(struct device *dev)
+{
+	struct platform_device	*pdev = to_platform_device(dev);
+	struct amxxxx_usb	*phy = platform_get_drvdata(pdev);
+
+	omap_control_am335x_phy_power(phy->control_dev, 0, phy->id);
+	if (device_may_wakeup(dev))
+		omap_control_am335x_phy_wkup(phy->control_dev, 1, phy->id);
+	clk_disable(phy->optclk);
+
+	return 0;
+}
+
+static int amxxxx_usb2_runtime_resume(struct device *dev)
+{
+	struct platform_device	*pdev = to_platform_device(dev);
+	struct amxxxx_usb	*phy = platform_get_drvdata(pdev);
+
+
+	omap_control_am335x_phy_power(phy->control_dev, 1, phy->id);
+	if (device_may_wakeup(dev))
+		omap_control_am335x_phy_wkup(phy->control_dev, 0, phy->id);
+	clk_enable(phy->optclk);
+
+	return 0;
+
+}
+
+static const struct dev_pm_ops amxxxx_usb2_pm_ops = {
+	SET_RUNTIME_PM_OPS(amxxxx_usb2_runtime_suspend,
+		amxxxx_usb2_runtime_resume, NULL)
+};
+
+#define DEV_PM_OPS     (&amxxxx_usb2_pm_ops)
+#else
+#define DEV_PM_OPS     NULL
+#endif
+
+#ifdef CONFIG_OF
+static const struct of_device_id amxxxx_usb2_id_table[] = {
+	{ .compatible = "ti,am335x-usb2" },
+	{}
+};
+MODULE_DEVICE_TABLE(of, amxxxx_usb2_id_table);
+#endif
+
+static struct platform_driver amxxxx_usb2_driver = {
+	.probe		= amxxxx_usb2_probe,
+	.remove		= amxxxx_usb2_remove,
+	.driver		= {
+		.name	= "amxxxx-usb2",
+		.owner	= THIS_MODULE,
+		.pm	= DEV_PM_OPS,
+		.of_match_table = of_match_ptr(amxxxx_usb2_id_table),
+	},
+};
+
+module_platform_driver(amxxxx_usb2_driver);
+
+MODULE_ALIAS("platform: amxxxx_usb2");
+MODULE_AUTHOR("Texas Instruments Inc.");
+MODULE_DESCRIPTION("AMXXXX USB2 phy driver");
+MODULE_LICENSE("GPL v2");
-- 
1.8.1.4

