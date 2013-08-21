Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752491Ab3HUFuV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Aug 2013 01:50:21 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:46920 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751964Ab3HUFr1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Aug 2013 01:47:27 -0400
From: Kishon Vijay Abraham I <kishon@ti.com>
To: <gregkh@linuxfoundation.org>, <kyungmin.park@samsung.com>, <balbi@ti.com>,
        <kishon@ti.com>, <jg1.han@samsung.com>, <s.nawrocki@samsung.com>,
        <kgene.kim@samsung.com>, <stern@rowland.harvard.edu>,
        <broonie@kernel.org>, <tomasz.figa@gmail.com>, <arnd@arndb.de>
CC: <grant.likely@linaro.org>, <tony@atomide.com>, <swarren@nvidia.com>,
        <devicetree@vger.kernel.org>, <linux-doc@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux-samsung-soc@vger.kernel.org>, <linux-omap@vger.kernel.org>,
        <linux-usb@vger.kernel.org>, <linux-media@vger.kernel.org>,
        <linux-fbdev@vger.kernel.org>, <akpm@linux-foundation.org>,
        <balajitk@ti.com>, <george.cherian@ti.com>, <nsekhar@ti.com>,
        <linux@arm.linux.org.uk>
Subject: [PATCH v11 3/8] usb: phy: twl4030: use the new generic PHY framework
Date: Wed, 21 Aug 2013 11:16:08 +0530
Message-ID: <1377063973-22044-4-git-send-email-kishon@ti.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1377063973-22044-1-git-send-email-kishon@ti.com>
References: <1377063973-22044-1-git-send-email-kishon@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Used the generic PHY framework API to create the PHY. For powering on
and powering off the PHY, power_on and power_off ops are used. Once the
MUSB OMAP glue is adapted to the new framework, the suspend and resume
ops of usb phy library will be removed. Also twl4030-usb driver is moved
to drivers/phy/.

However using the old usb phy library cannot be completely removed
because otg is intertwined with phy and moving to the new
framework completely will break otg. Once we have a separate otg state machine,
we can get rid of the usb phy library.

Signed-off-by: Kishon Vijay Abraham I <kishon@ti.com>
Acked-by: Felipe Balbi <balbi@ti.com>
Reviewed-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
---
 drivers/phy/Kconfig                     |   11 ++++++
 drivers/phy/Makefile                    |    1 +
 drivers/{usb => }/phy/phy-twl4030-usb.c |   56 +++++++++++++++++++++++++++++--
 drivers/usb/phy/Kconfig                 |    9 -----
 drivers/usb/phy/Makefile                |    1 -
 include/linux/i2c/twl.h                 |    2 ++
 6 files changed, 67 insertions(+), 13 deletions(-)
 rename drivers/{usb => }/phy/phy-twl4030-usb.c (95%)

diff --git a/drivers/phy/Kconfig b/drivers/phy/Kconfig
index 38c3477..ac239ac 100644
--- a/drivers/phy/Kconfig
+++ b/drivers/phy/Kconfig
@@ -27,4 +27,15 @@ config OMAP_USB2
 	  The USB OTG controller communicates with the comparator using this
 	  driver.
 
+config TWL4030_USB
+	tristate "TWL4030 USB Transceiver Driver"
+	depends on TWL4030_CORE && REGULATOR_TWL4030 && USB_MUSB_OMAP2PLUS
+	select GENERIC_PHY
+	select USB_PHY
+	help
+	  Enable this to support the USB OTG transceiver on TWL4030
+	  family chips (including the TWL5030 and TPS659x0 devices).
+	  This transceiver supports high and full speed devices plus,
+	  in host mode, low speed.
+
 endmenu
diff --git a/drivers/phy/Makefile b/drivers/phy/Makefile
index ed5b088..0dd8a98 100644
--- a/drivers/phy/Makefile
+++ b/drivers/phy/Makefile
@@ -4,3 +4,4 @@
 
 obj-$(CONFIG_GENERIC_PHY)	+= phy-core.o
 obj-$(CONFIG_OMAP_USB2)		+= phy-omap-usb2.o
+obj-$(CONFIG_TWL4030_USB)	+= phy-twl4030-usb.o
diff --git a/drivers/usb/phy/phy-twl4030-usb.c b/drivers/phy/phy-twl4030-usb.c
similarity index 95%
rename from drivers/usb/phy/phy-twl4030-usb.c
rename to drivers/phy/phy-twl4030-usb.c
index 8f78d2d..494f107 100644
--- a/drivers/usb/phy/phy-twl4030-usb.c
+++ b/drivers/phy/phy-twl4030-usb.c
@@ -33,6 +33,7 @@
 #include <linux/io.h>
 #include <linux/delay.h>
 #include <linux/usb/otg.h>
+#include <linux/phy/phy.h>
 #include <linux/usb/musb-omap.h>
 #include <linux/usb/ulpi.h>
 #include <linux/i2c/twl.h>
@@ -431,6 +432,14 @@ static void twl4030_phy_suspend(struct twl4030_usb *twl, int controller_off)
 	dev_dbg(twl->dev, "%s\n", __func__);
 }
 
+static int twl4030_phy_power_off(struct phy *phy)
+{
+	struct twl4030_usb *twl = phy_get_drvdata(phy);
+
+	twl4030_phy_suspend(twl, 0);
+	return 0;
+}
+
 static void __twl4030_phy_resume(struct twl4030_usb *twl)
 {
 	twl4030_phy_power(twl, 1);
@@ -459,6 +468,14 @@ static void twl4030_phy_resume(struct twl4030_usb *twl)
 	}
 }
 
+static int twl4030_phy_power_on(struct phy *phy)
+{
+	struct twl4030_usb *twl = phy_get_drvdata(phy);
+
+	twl4030_phy_resume(twl);
+	return 0;
+}
+
 static int twl4030_usb_ldo_init(struct twl4030_usb *twl)
 {
 	/* Enable writing to power configuration registers */
@@ -602,13 +619,22 @@ static int twl4030_usb_phy_init(struct usb_phy *phy)
 	status = twl4030_usb_linkstat(twl);
 	twl->linkstat = status;
 
-	if (status == OMAP_MUSB_ID_GROUND || status == OMAP_MUSB_VBUS_VALID)
+	if (status == OMAP_MUSB_ID_GROUND || status == OMAP_MUSB_VBUS_VALID) {
 		omap_musb_mailbox(twl->linkstat);
+		twl4030_phy_resume(twl);
+	}
 
 	sysfs_notify(&twl->dev->kobj, NULL, "vbus");
 	return 0;
 }
 
+static int twl4030_phy_init(struct phy *phy)
+{
+	struct twl4030_usb *twl = phy_get_drvdata(phy);
+
+	return twl4030_usb_phy_init(&twl->phy);
+}
+
 static int twl4030_set_suspend(struct usb_phy *x, int suspend)
 {
 	struct twl4030_usb *twl = phy_to_twl(x);
@@ -646,13 +672,23 @@ static int twl4030_set_host(struct usb_otg *otg, struct usb_bus *host)
 	return 0;
 }
 
+static const struct phy_ops ops = {
+	.init		= twl4030_phy_init,
+	.power_on	= twl4030_phy_power_on,
+	.power_off	= twl4030_phy_power_off,
+	.owner		= THIS_MODULE,
+};
+
 static int twl4030_usb_probe(struct platform_device *pdev)
 {
 	struct twl4030_usb_data *pdata = pdev->dev.platform_data;
 	struct twl4030_usb	*twl;
+	struct phy		*phy;
 	int			status, err;
 	struct usb_otg		*otg;
 	struct device_node	*np = pdev->dev.of_node;
+	struct phy_provider	*phy_provider;
+	struct phy_init_data	*init_data = NULL;
 
 	twl = devm_kzalloc(&pdev->dev, sizeof *twl, GFP_KERNEL);
 	if (!twl)
@@ -661,9 +697,10 @@ static int twl4030_usb_probe(struct platform_device *pdev)
 	if (np)
 		of_property_read_u32(np, "usb_mode",
 				(enum twl4030_usb_mode *)&twl->usb_mode);
-	else if (pdata)
+	else if (pdata) {
 		twl->usb_mode = pdata->usb_mode;
-	else {
+		init_data = pdata->init_data;
+	} else {
 		dev_err(&pdev->dev, "twl4030 initialized without pdata\n");
 		return -EINVAL;
 	}
@@ -689,6 +726,19 @@ static int twl4030_usb_probe(struct platform_device *pdev)
 	otg->set_host		= twl4030_set_host;
 	otg->set_peripheral	= twl4030_set_peripheral;
 
+	phy_provider = devm_of_phy_provider_register(twl->dev,
+		of_phy_simple_xlate);
+	if (IS_ERR(phy_provider))
+		return PTR_ERR(phy_provider);
+
+	phy = devm_phy_create(twl->dev, &ops, init_data);
+	if (IS_ERR(phy)) {
+		dev_dbg(&pdev->dev, "Failed to create PHY\n");
+		return PTR_ERR(phy);
+	}
+
+	phy_set_drvdata(phy, twl);
+
 	/* init spinlock for workqueue */
 	spin_lock_init(&twl->lock);
 
diff --git a/drivers/usb/phy/Kconfig b/drivers/usb/phy/Kconfig
index 7813238..1e05b1d 100644
--- a/drivers/usb/phy/Kconfig
+++ b/drivers/usb/phy/Kconfig
@@ -102,15 +102,6 @@ config SAMSUNG_USB3PHY
 	  Enable this to support Samsung USB 3.0 (Super Speed) phy controller
 	  for samsung SoCs.
 
-config TWL4030_USB
-	tristate "TWL4030 USB Transceiver Driver"
-	depends on TWL4030_CORE && REGULATOR_TWL4030 && USB_MUSB_OMAP2PLUS
-	help
-	  Enable this to support the USB OTG transceiver on TWL4030
-	  family chips (including the TWL5030 and TPS659x0 devices).
-	  This transceiver supports high and full speed devices plus,
-	  in host mode, low speed.
-
 config TWL6030_USB
 	tristate "TWL6030 USB Transceiver Driver"
 	depends on TWL4030_CORE && OMAP_USB2 && USB_MUSB_OMAP2PLUS
diff --git a/drivers/usb/phy/Makefile b/drivers/usb/phy/Makefile
index 56d2b03..7bcc9ed0 100644
--- a/drivers/usb/phy/Makefile
+++ b/drivers/usb/phy/Makefile
@@ -20,7 +20,6 @@ obj-$(CONFIG_OMAP_USB3)			+= phy-omap-usb3.o
 obj-$(CONFIG_SAMSUNG_USBPHY)		+= phy-samsung-usb.o
 obj-$(CONFIG_SAMSUNG_USB2PHY)		+= phy-samsung-usb2.o
 obj-$(CONFIG_SAMSUNG_USB3PHY)		+= phy-samsung-usb3.o
-obj-$(CONFIG_TWL4030_USB)		+= phy-twl4030-usb.o
 obj-$(CONFIG_TWL6030_USB)		+= phy-twl6030-usb.o
 obj-$(CONFIG_USB_EHCI_TEGRA)		+= phy-tegra-usb.o
 obj-$(CONFIG_USB_GPIO_VBUS)		+= phy-gpio-vbus-usb.o
diff --git a/include/linux/i2c/twl.h b/include/linux/i2c/twl.h
index 81cbbdb..673a3ce 100644
--- a/include/linux/i2c/twl.h
+++ b/include/linux/i2c/twl.h
@@ -26,6 +26,7 @@
 #define __TWL_H_
 
 #include <linux/types.h>
+#include <linux/phy/phy.h>
 #include <linux/input/matrix_keypad.h>
 
 /*
@@ -615,6 +616,7 @@ enum twl4030_usb_mode {
 struct twl4030_usb_data {
 	enum twl4030_usb_mode	usb_mode;
 	unsigned long		features;
+	struct phy_init_data	*init_data;
 
 	int		(*phy_init)(struct device *dev);
 	int		(*phy_exit)(struct device *dev);
-- 
1.7.10.4

