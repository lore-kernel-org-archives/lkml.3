Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755930Ab3HBTYW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Aug 2013 15:24:22 -0400
Received: from www.linutronix.de ([62.245.132.108]:50744 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755848Ab3HBTYS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Aug 2013 15:24:18 -0400
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To: Felipe Balbi <balbi@ti.com>
Cc: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        george.cherian@ti.com,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Subject: [PATCH 2/5] usb: phy: Add AM335x PHY driver
Date: Fri,  2 Aug 2013 21:24:07 +0200
Message-Id: <1375471450-31154-3-git-send-email-bigeasy@linutronix.de>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1375471450-31154-1-git-send-email-bigeasy@linutronix.de>
References: <1375471450-31154-1-git-send-email-bigeasy@linutronix.de>
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001,URIBL_BLOCKED=0.001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This driver is a redo of my earlier attempt. It uses parts of the
generic PHY driver and uses the new control driver for the register
the phy needs to power on/off the phy. It also enables easy access for
the wakeup register which is not yet implemented.
The difference between the omap attempt is:
- no static holding variable
- one global visible function which exports a struct with callbacks to
  access the "control" registers.

Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
---
 drivers/usb/phy/Kconfig              |  12 ++++
 drivers/usb/phy/Makefile             |   2 +
 drivers/usb/phy/am35x-phy-control.h  |  21 ++++++
 drivers/usb/phy/phy-am335x-control.c | 136 +++++++++++++++++++++++++++++++++++
 drivers/usb/phy/phy-am335x.c         |  99 +++++++++++++++++++++++++
 5 files changed, 270 insertions(+)
 create mode 100644 drivers/usb/phy/am35x-phy-control.h
 create mode 100644 drivers/usb/phy/phy-am335x-control.c
 create mode 100644 drivers/usb/phy/phy-am335x.c

diff --git a/drivers/usb/phy/Kconfig b/drivers/usb/phy/Kconfig
index f5ea339..f41c3e1 100644
--- a/drivers/usb/phy/Kconfig
+++ b/drivers/usb/phy/Kconfig
@@ -86,6 +86,18 @@ config OMAP_USB3
 	  This driver interacts with the "OMAP Control USB Driver" to power
 	  on/off the PHY.
 
+config AM335X_CONTROL_USB
+	tristate
+
+config AM335X_PHY_USB
+	tristate "AM335x USB PHY Driver"
+	select USB_PHY
+	select AM335X_CONTROL_USB
+	select NOP_USB_XCEIV
+	help
+	  This driver provides PHY support for that phy which part for the
+	  AM335x SoC.
+
 config SAMSUNG_USBPHY
 	tristate
 	help
diff --git a/drivers/usb/phy/Makefile b/drivers/usb/phy/Makefile
index 24c5816..dae321d 100644
--- a/drivers/usb/phy/Makefile
+++ b/drivers/usb/phy/Makefile
@@ -16,6 +16,8 @@ obj-$(CONFIG_ISP1301_OMAP)		+= phy-isp1301-omap.o
 obj-$(CONFIG_MV_U3D_PHY)		+= phy-mv-u3d-usb.o
 obj-$(CONFIG_NOP_USB_XCEIV)		+= phy-generic.o
 obj-$(CONFIG_OMAP_CONTROL_USB)		+= phy-omap-control.o
+obj-$(CONFIG_AM335X_CONTROL_USB)	+= phy-am335x-control.o
+obj-$(CONFIG_AM335X_PHY_USB)		+= phy-am335x.o
 obj-$(CONFIG_OMAP_USB2)			+= phy-omap-usb2.o
 obj-$(CONFIG_OMAP_USB3)			+= phy-omap-usb3.o
 obj-$(CONFIG_SAMSUNG_USBPHY)		+= phy-samsung-usb.o
diff --git a/drivers/usb/phy/am35x-phy-control.h b/drivers/usb/phy/am35x-phy-control.h
new file mode 100644
index 0000000..b96594d
--- /dev/null
+++ b/drivers/usb/phy/am35x-phy-control.h
@@ -0,0 +1,21 @@
+#ifndef _AM335x_PHY_CONTROL_H_
+#define _AM335x_PHY_CONTROL_H_
+
+struct phy_control {
+	void (*phy_power)(struct phy_control *phy_ctrl, u32 id, bool on);
+	void (*phy_wkup)(struct phy_control *phy_ctrl, u32 id, bool on);
+};
+
+static inline void phy_ctrl_power(struct phy_control *phy_ctrl, u32 id, bool on)
+{
+	phy_ctrl->phy_power(phy_ctrl, id, on);
+}
+
+static inline void phy_ctrl_wkup(struct phy_control *phy_ctrl, u32 id, bool on)
+{
+	phy_ctrl->phy_wkup(phy_ctrl, id, on);
+}
+
+struct phy_control *am335x_get_phy_control(struct device *dev);
+
+#endif
diff --git a/drivers/usb/phy/phy-am335x-control.c b/drivers/usb/phy/phy-am335x-control.c
new file mode 100644
index 0000000..35494f1
--- /dev/null
+++ b/drivers/usb/phy/phy-am335x-control.c
@@ -0,0 +1,136 @@
+#include <linux/module.h>
+#include <linux/platform_device.h>
+#include <linux/of.h>
+#include <linux/io.h>
+
+struct phy_control {
+	void (*phy_power)(struct phy_control *phy_ctrl, u32 id, bool on);
+	void (*phy_wkup)(struct phy_control *phy_ctrl, u32 id, bool on);
+};
+
+struct am335x_control_usb {
+	struct device *dev;
+	void __iomem *phy_reg;
+	void __iomem *wkup;
+	spinlock_t lock;
+	struct phy_control phy_ctrl;
+};
+
+#define AM335X_USB0_CTRL		0x0
+#define AM335X_USB1_CTRL		0x8
+#define AM335x_USB_WKUP			0x0
+
+#define USBPHY_CM_PWRDN		(1 << 0)
+#define USBPHY_OTG_PWRDN	(1 << 1)
+#define USBPHY_OTGVDET_EN	(1 << 19)
+#define USBPHY_OTGSESSEND_EN	(1 << 20)
+
+static void am335x_phy_power(struct phy_control *phy_ctrl, u32 id, bool on)
+{
+	struct am335x_control_usb *usb_ctrl;
+	u32 val;
+	u32 reg;
+
+	usb_ctrl = container_of(phy_ctrl, struct am335x_control_usb, phy_ctrl);
+
+	switch (id) {
+	case 0:
+		reg = AM335X_USB0_CTRL;
+		break;
+	case 1:
+		reg = AM335X_USB1_CTRL;
+		break;
+	default:
+		__WARN();
+		 return;
+	}
+
+	val = readl(usb_ctrl->phy_reg + reg);
+	if (on) {
+		val &= ~(USBPHY_CM_PWRDN | USBPHY_OTG_PWRDN);
+		val |= USBPHY_OTGVDET_EN | USBPHY_OTGSESSEND_EN;
+	} else {
+		val |= USBPHY_CM_PWRDN | USBPHY_OTG_PWRDN;
+	}
+
+	writel(val, usb_ctrl->phy_reg + reg);
+}
+
+static const struct phy_control ctrl_am335x = {
+	.phy_power = am335x_phy_power,
+};
+
+static const struct of_device_id omap_control_usb_id_table[] = {
+	{ .compatible = "ti,am335x-usb-ctrl-module", .data = &ctrl_am335x },
+	{}
+};
+MODULE_DEVICE_TABLE(of, omap_control_usb_id_table);
+
+static struct platform_driver am335x_control_driver;
+static int match(struct device *dev, void *data)
+{
+	struct device_node *node = (struct device_node *)data;
+	return dev->of_node == node &&
+		dev->driver == &am335x_control_driver.driver;
+}
+
+struct phy_control *am335x_get_phy_control(struct device *dev)
+{
+	struct device_node *node;
+	struct am335x_control_usb *ctrl_usb;
+
+	node = of_parse_phandle(dev->of_node, "ti,ctrl_mod", 0);
+	if (!node)
+		return NULL;
+
+	dev = bus_find_device(&platform_bus_type, NULL, node, match);
+	ctrl_usb = dev_get_drvdata(dev);
+	if (!ctrl_usb)
+		return NULL;
+	return &ctrl_usb->phy_ctrl;
+}
+EXPORT_SYMBOL_GPL(am335x_get_phy_control);
+
+static int am335x_control_usb_probe(struct platform_device *pdev)
+{
+	struct resource	*res;
+	struct am335x_control_usb *ctrl_usb;
+	const struct of_device_id *of_id;
+	const struct phy_control *phy_ctrl;
+
+	of_id = of_match_node(omap_control_usb_id_table, pdev->dev.of_node);
+	if (!of_id)
+		return -EINVAL;
+
+	phy_ctrl = of_id->data;
+
+	ctrl_usb = devm_kzalloc(&pdev->dev, sizeof(*ctrl_usb), GFP_KERNEL);
+	if (!ctrl_usb) {
+		dev_err(&pdev->dev, "unable to alloc memory for control usb\n");
+		return -ENOMEM;
+	}
+
+	ctrl_usb->dev = &pdev->dev;
+
+	res = platform_get_resource_byname(pdev, IORESOURCE_MEM, "phy_ctrl");
+	ctrl_usb->phy_reg = devm_ioremap_resource(&pdev->dev, res);
+	if (IS_ERR(ctrl_usb->phy_reg))
+		return PTR_ERR(ctrl_usb->phy_reg);
+	spin_lock_init(&ctrl_usb->lock);
+	ctrl_usb->phy_ctrl = *phy_ctrl;
+
+	dev_set_drvdata(ctrl_usb->dev, ctrl_usb);
+	return 0;
+}
+
+static struct platform_driver am335x_control_driver = {
+	.probe		= am335x_control_usb_probe,
+	.driver		= {
+		.name	= "am335x-control-usb",
+		.owner	= THIS_MODULE,
+		.of_match_table = of_match_ptr(omap_control_usb_id_table),
+	},
+};
+
+module_platform_driver(am335x_control_driver);
+MODULE_LICENSE("GPL v2");
diff --git a/drivers/usb/phy/phy-am335x.c b/drivers/usb/phy/phy-am335x.c
new file mode 100644
index 0000000..c4d614d
--- /dev/null
+++ b/drivers/usb/phy/phy-am335x.c
@@ -0,0 +1,99 @@
+#include <linux/module.h>
+#include <linux/platform_device.h>
+#include <linux/dma-mapping.h>
+#include <linux/usb/otg.h>
+#include <linux/usb/usb_phy_gen_xceiv.h>
+#include <linux/slab.h>
+#include <linux/clk.h>
+#include <linux/regulator/consumer.h>
+#include <linux/of.h>
+#include <linux/of_address.h>
+
+#include "am35x-phy-control.h"
+#include "phy-generic.h"
+
+struct am335x_phy {
+	struct usb_phy_gen_xceiv usb_phy_gen;
+	struct phy_control *phy_ctrl;
+	int id;
+};
+
+static int am335x_init(struct usb_phy *phy)
+{
+	struct am335x_phy *am_phy = dev_get_drvdata(phy->dev);
+
+	phy_ctrl_power(am_phy->phy_ctrl, am_phy->id, true);
+	return 0;
+}
+
+static void am335x_shutdown(struct usb_phy *phy)
+{
+	struct am335x_phy *am_phy = dev_get_drvdata(phy->dev);
+
+	phy_ctrl_power(am_phy->phy_ctrl, am_phy->id, false);
+}
+
+static int am335x_phy_probe(struct platform_device *pdev)
+{
+	struct am335x_phy *am_phy;
+	struct device *dev = &pdev->dev;
+	int ret;
+
+	am_phy = devm_kzalloc(dev, sizeof(*am_phy), GFP_KERNEL);
+	if (!am_phy)
+		return -ENOMEM;
+
+	am_phy->phy_ctrl = am335x_get_phy_control(dev);
+	if (!am_phy->phy_ctrl)
+		return -EPROBE_DEFER;
+	am_phy->id = of_alias_get_id(pdev->dev.of_node, "phy");
+	if (am_phy->id < 0) {
+		dev_err(&pdev->dev, "Missing PHY id: %d\n", am_phy->id);
+		return am_phy->id;
+	}
+
+	ret = usb_phy_gen_create_phy(dev, &am_phy->usb_phy_gen,
+			USB_PHY_TYPE_USB2, 0, false, false);
+	if (ret)
+		return ret;
+
+	ret = usb_add_phy_dev(&am_phy->usb_phy_gen.phy);
+	if (ret)
+		goto err_add;
+	am_phy->usb_phy_gen.phy.init = am335x_init;
+	am_phy->usb_phy_gen.phy.shutdown = am335x_shutdown;
+
+	platform_set_drvdata(pdev, am_phy);
+	return 0;
+
+err_add:
+	usb_phy_gen_cleanup_phy(&am_phy->usb_phy_gen);
+	return ret;
+}
+
+static int am335x_phy_remove(struct platform_device *pdev)
+{
+	struct am335x_phy *am_phy = platform_get_drvdata(pdev);
+
+	usb_remove_phy(&am_phy->usb_phy_gen.phy);
+	return 0;
+}
+
+static const struct of_device_id am335x_phy_ids[] = {
+	{ .compatible = "ti,am335x-usb-phy" },
+	{ }
+};
+MODULE_DEVICE_TABLE(of, am335x_phy_ids);
+
+static struct platform_driver am335x_phy_driver = {
+	.probe          = am335x_phy_probe,
+	.remove         = am335x_phy_remove,
+	.driver         = {
+		.name   = "am335x-phy-driver",
+		.owner  = THIS_MODULE,
+		.of_match_table = of_match_ptr(am335x_phy_ids),
+	},
+};
+
+module_platform_driver(am335x_phy_driver);
+MODULE_LICENSE("GPL v2");
-- 
1.8.3.2

