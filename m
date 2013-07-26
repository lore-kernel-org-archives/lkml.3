Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759631Ab3GZUQM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jul 2013 16:16:12 -0400
Received: from www.linutronix.de ([62.245.132.108]:38967 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753645Ab3GZUQH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jul 2013 16:16:07 -0400
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To: balbi@ti.com
Cc: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        george.cherian@ti.com,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Subject: [PATCH 1/4] usb: phy: rename nop_usb_xceiv => usb_phy_gen_xceiv
Date: Fri, 26 Jul 2013 22:15:54 +0200
Message-Id: <1374869757-923-2-git-send-email-bigeasy@linutronix.de>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1374869757-923-1-git-send-email-bigeasy@linutronix.de>
References: <1374869757-923-1-git-send-email-bigeasy@linutronix.de>
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001,URIBL_BLOCKED=0.001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The "nop" driver isn't a do-nothing-stub but supports a couple functions
like clock on/off or is able to use a voltage regulator. This patch
simply renames the driver to "generic" since it is easy possible to
extend it by a simple function istead of writing a complete driver.

Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
---
 arch/arm/mach-omap2/board-omap3beagle.c      |  2 +-
 arch/arm/mach-omap2/board-omap3evm.c         |  2 +-
 arch/arm/mach-omap2/board-omap3pandora.c     |  2 +-
 arch/arm/mach-omap2/usb-host.c               |  8 +++---
 drivers/usb/dwc3/dwc3-exynos.c               |  6 ++--
 drivers/usb/dwc3/dwc3-pci.c                  |  6 ++--
 drivers/usb/phy/Makefile                     |  2 +-
 drivers/usb/phy/{phy-nop.c => phy-generic.c} | 42 ++++++++++++++--------------
 include/linux/usb/nop-usb-xceiv.h            |  2 +-
 9 files changed, 36 insertions(+), 36 deletions(-)
 rename drivers/usb/phy/{phy-nop.c => phy-generic.c} (84%)

diff --git a/arch/arm/mach-omap2/board-omap3beagle.c b/arch/arm/mach-omap2/board-omap3beagle.c
index 04c1165..f595b23 100644
--- a/arch/arm/mach-omap2/board-omap3beagle.c
+++ b/arch/arm/mach-omap2/board-omap3beagle.c
@@ -279,7 +279,7 @@ static struct regulator_consumer_supply beagle_vsim_supply[] = {
 static struct gpio_led gpio_leds[];
 
 /* PHY's VCC regulator might be added later, so flag that we need it */
-static struct nop_usb_xceiv_platform_data hsusb2_phy_data = {
+static struct usb_phy_gen_xceiv_platform_data hsusb2_phy_data = {
 	.needs_vcc = true,
 };
 
diff --git a/arch/arm/mach-omap2/board-omap3evm.c b/arch/arm/mach-omap2/board-omap3evm.c
index 8c02626..5d98ef0 100644
--- a/arch/arm/mach-omap2/board-omap3evm.c
+++ b/arch/arm/mach-omap2/board-omap3evm.c
@@ -468,7 +468,7 @@ struct wl12xx_platform_data omap3evm_wlan_data __initdata = {
 static struct regulator_consumer_supply omap3evm_vaux2_supplies[] = {
 	REGULATOR_SUPPLY("VDD_CSIPHY1", "omap3isp"),	/* OMAP ISP */
 	REGULATOR_SUPPLY("VDD_CSIPHY2", "omap3isp"),	/* OMAP ISP */
-	REGULATOR_SUPPLY("vcc", "nop_usb_xceiv.2"),	/* hsusb port 2 */
+	REGULATOR_SUPPLY("vcc", "usb_phy_gen_xceiv.2"),	/* hsusb port 2 */
 	REGULATOR_SUPPLY("vaux2", NULL),
 };
 
diff --git a/arch/arm/mach-omap2/board-omap3pandora.c b/arch/arm/mach-omap2/board-omap3pandora.c
index b1547a0..d2b455e 100644
--- a/arch/arm/mach-omap2/board-omap3pandora.c
+++ b/arch/arm/mach-omap2/board-omap3pandora.c
@@ -352,7 +352,7 @@ static struct regulator_consumer_supply pandora_vcc_lcd_supply[] = {
 };
 
 static struct regulator_consumer_supply pandora_usb_phy_supply[] = {
-	REGULATOR_SUPPLY("vcc", "nop_usb_xceiv.2"),	/* hsusb port 2 */
+	REGULATOR_SUPPLY("vcc", "usb_phy_gen_xceiv.2"),	/* hsusb port 2 */
 };
 
 /* ads7846 on SPI and 2 nub controllers on I2C */
diff --git a/arch/arm/mach-omap2/usb-host.c b/arch/arm/mach-omap2/usb-host.c
index 2eb19d4..b54bd06 100644
--- a/arch/arm/mach-omap2/usb-host.c
+++ b/arch/arm/mach-omap2/usb-host.c
@@ -349,7 +349,7 @@ static struct fixed_voltage_config hsusb_reg_config = {
 	/* .init_data filled later */
 };
 
-static const char *nop_name = "nop_usb_xceiv"; /* NOP PHY driver */
+static const char *nop_name = "usb_phy_gen_xceiv"; /* NOP PHY driver */
 static const char *reg_name = "reg-fixed-voltage"; /* Regulator driver */
 
 /**
@@ -460,9 +460,9 @@ int usbhs_init_phys(struct usbhs_phy_data *phy, int num_phys)
 		pdevinfo.name = nop_name;
 		pdevinfo.id = phy->port;
 		pdevinfo.data = phy->platform_data;
-		pdevinfo.size_data = sizeof(struct nop_usb_xceiv_platform_data);
-
-		scnprintf(phy_id, MAX_STR, "nop_usb_xceiv.%d",
+		pdevinfo.size_data =
+			sizeof(struct usb_phy_gen_xceiv_platform_data);
+		scnprintf(phy_id, MAX_STR, "usb_phy_gen_xceiv.%d",
 					phy->port);
 		pdev = platform_device_register_full(&pdevinfo);
 		if (IS_ERR(pdev)) {
diff --git a/drivers/usb/dwc3/dwc3-exynos.c b/drivers/usb/dwc3/dwc3-exynos.c
index 9a8a5e1..1a83fb3 100644
--- a/drivers/usb/dwc3/dwc3-exynos.c
+++ b/drivers/usb/dwc3/dwc3-exynos.c
@@ -38,13 +38,13 @@ struct dwc3_exynos {
 
 static int dwc3_exynos_register_phys(struct dwc3_exynos *exynos)
 {
-	struct nop_usb_xceiv_platform_data pdata;
+	struct usb_phy_gen_xceiv_platform_data pdata;
 	struct platform_device	*pdev;
 	int			ret;
 
 	memset(&pdata, 0x00, sizeof(pdata));
 
-	pdev = platform_device_alloc("nop_usb_xceiv", PLATFORM_DEVID_AUTO);
+	pdev = platform_device_alloc("usb_phy_gen_xceiv", PLATFORM_DEVID_AUTO);
 	if (!pdev)
 		return -ENOMEM;
 
@@ -55,7 +55,7 @@ static int dwc3_exynos_register_phys(struct dwc3_exynos *exynos)
 	if (ret)
 		goto err1;
 
-	pdev = platform_device_alloc("nop_usb_xceiv", PLATFORM_DEVID_AUTO);
+	pdev = platform_device_alloc("usb_phy_gen_xceiv", PLATFORM_DEVID_AUTO);
 	if (!pdev) {
 		ret = -ENOMEM;
 		goto err1;
diff --git a/drivers/usb/dwc3/dwc3-pci.c b/drivers/usb/dwc3/dwc3-pci.c
index 5d746e5..12b8276 100644
--- a/drivers/usb/dwc3/dwc3-pci.c
+++ b/drivers/usb/dwc3/dwc3-pci.c
@@ -38,13 +38,13 @@ struct dwc3_pci {
 
 static int dwc3_pci_register_phys(struct dwc3_pci *glue)
 {
-	struct nop_usb_xceiv_platform_data pdata;
+	struct usb_phy_gen_xceiv_platform_data pdata;
 	struct platform_device	*pdev;
 	int			ret;
 
 	memset(&pdata, 0x00, sizeof(pdata));
 
-	pdev = platform_device_alloc("nop_usb_xceiv", 0);
+	pdev = platform_device_alloc("usb_phy_gen_xceiv", 0);
 	if (!pdev)
 		return -ENOMEM;
 
@@ -55,7 +55,7 @@ static int dwc3_pci_register_phys(struct dwc3_pci *glue)
 	if (ret)
 		goto err1;
 
-	pdev = platform_device_alloc("nop_usb_xceiv", 1);
+	pdev = platform_device_alloc("usb_phy_gen_xceiv", 1);
 	if (!pdev) {
 		ret = -ENOMEM;
 		goto err1;
diff --git a/drivers/usb/phy/Makefile b/drivers/usb/phy/Makefile
index 070eca3..24c5816 100644
--- a/drivers/usb/phy/Makefile
+++ b/drivers/usb/phy/Makefile
@@ -14,7 +14,7 @@ phy-fsl-usb2-objs			:= phy-fsl-usb.o phy-fsm-usb.o
 obj-$(CONFIG_FSL_USB2_OTG)		+= phy-fsl-usb2.o
 obj-$(CONFIG_ISP1301_OMAP)		+= phy-isp1301-omap.o
 obj-$(CONFIG_MV_U3D_PHY)		+= phy-mv-u3d-usb.o
-obj-$(CONFIG_NOP_USB_XCEIV)		+= phy-nop.o
+obj-$(CONFIG_NOP_USB_XCEIV)		+= phy-generic.o
 obj-$(CONFIG_OMAP_CONTROL_USB)		+= phy-omap-control.o
 obj-$(CONFIG_OMAP_USB2)			+= phy-omap-usb2.o
 obj-$(CONFIG_OMAP_USB3)			+= phy-omap-usb3.o
diff --git a/drivers/usb/phy/phy-nop.c b/drivers/usb/phy/phy-generic.c
similarity index 84%
rename from drivers/usb/phy/phy-nop.c
rename to drivers/usb/phy/phy-generic.c
index 55445e5d..57a0bf0 100644
--- a/drivers/usb/phy/phy-nop.c
+++ b/drivers/usb/phy/phy-generic.c
@@ -36,7 +36,7 @@
 #include <linux/regulator/consumer.h>
 #include <linux/of.h>
 
-struct nop_usb_xceiv {
+struct usb_phy_gen_xceiv {
 	struct usb_phy phy;
 	struct device *dev;
 	struct clk *clk;
@@ -50,9 +50,9 @@ void usb_nop_xceiv_register(void)
 {
 	if (pd)
 		return;
-	pd = platform_device_register_simple("nop_usb_xceiv", -1, NULL, 0);
+	pd = platform_device_register_simple("usb_phy_gen_xceiv", -1, NULL, 0);
 	if (!pd) {
-		printk(KERN_ERR "Unable to register usb nop transceiver\n");
+		pr_err("Unable to register generic usb transceiver\n");
 		return;
 	}
 }
@@ -72,7 +72,7 @@ static int nop_set_suspend(struct usb_phy *x, int suspend)
 
 static int nop_init(struct usb_phy *phy)
 {
-	struct nop_usb_xceiv *nop = dev_get_drvdata(phy->dev);
+	struct usb_phy_gen_xceiv *nop = dev_get_drvdata(phy->dev);
 
 	if (!IS_ERR(nop->vcc)) {
 		if (regulator_enable(nop->vcc))
@@ -93,7 +93,7 @@ static int nop_init(struct usb_phy *phy)
 
 static void nop_shutdown(struct usb_phy *phy)
 {
-	struct nop_usb_xceiv *nop = dev_get_drvdata(phy->dev);
+	struct usb_phy_gen_xceiv *nop = dev_get_drvdata(phy->dev);
 
 	if (!IS_ERR(nop->reset)) {
 		/* Assert RESET */
@@ -139,11 +139,11 @@ static int nop_set_host(struct usb_otg *otg, struct usb_bus *host)
 	return 0;
 }
 
-static int nop_usb_xceiv_probe(struct platform_device *pdev)
+static int usb_phy_gen_xceiv_probe(struct platform_device *pdev)
 {
 	struct device *dev = &pdev->dev;
-	struct nop_usb_xceiv_platform_data *pdata = pdev->dev.platform_data;
-	struct nop_usb_xceiv	*nop;
+	struct usb_phy_gen_xceiv_platform_data *pdata = pdev->dev.platform_data;
+	struct usb_phy_gen_xceiv	*nop;
 	enum usb_phy_type	type = USB_PHY_TYPE_USB2;
 	int err;
 	u32 clk_rate = 0;
@@ -245,9 +245,9 @@ static int nop_usb_xceiv_probe(struct platform_device *pdev)
 	return err;
 }
 
-static int nop_usb_xceiv_remove(struct platform_device *pdev)
+static int usb_phy_gen_xceiv_remove(struct platform_device *pdev)
 {
-	struct nop_usb_xceiv *nop = platform_get_drvdata(pdev);
+	struct usb_phy_gen_xceiv *nop = platform_get_drvdata(pdev);
 
 	if (!IS_ERR(nop->clk))
 		clk_unprepare(nop->clk);
@@ -264,29 +264,29 @@ static const struct of_device_id nop_xceiv_dt_ids[] = {
 
 MODULE_DEVICE_TABLE(of, nop_xceiv_dt_ids);
 
-static struct platform_driver nop_usb_xceiv_driver = {
-	.probe		= nop_usb_xceiv_probe,
-	.remove		= nop_usb_xceiv_remove,
+static struct platform_driver usb_phy_gen_xceiv_driver = {
+	.probe		= usb_phy_gen_xceiv_probe,
+	.remove		= usb_phy_gen_xceiv_remove,
 	.driver		= {
-		.name	= "nop_usb_xceiv",
+		.name	= "usb_phy_gen_xceiv",
 		.owner	= THIS_MODULE,
 		.of_match_table = nop_xceiv_dt_ids,
 	},
 };
 
-static int __init nop_usb_xceiv_init(void)
+static int __init usb_phy_gen_xceiv_init(void)
 {
-	return platform_driver_register(&nop_usb_xceiv_driver);
+	return platform_driver_register(&usb_phy_gen_xceiv_driver);
 }
-subsys_initcall(nop_usb_xceiv_init);
+subsys_initcall(usb_phy_gen_xceiv_init);
 
-static void __exit nop_usb_xceiv_exit(void)
+static void __exit usb_phy_gen_xceiv_exit(void)
 {
-	platform_driver_unregister(&nop_usb_xceiv_driver);
+	platform_driver_unregister(&usb_phy_gen_xceiv_driver);
 }
-module_exit(nop_usb_xceiv_exit);
+module_exit(usb_phy_gen_xceiv_exit);
 
-MODULE_ALIAS("platform:nop_usb_xceiv");
+MODULE_ALIAS("platform:usb_phy_gen_xceiv");
 MODULE_AUTHOR("Texas Instruments Inc");
 MODULE_DESCRIPTION("NOP USB Transceiver driver");
 MODULE_LICENSE("GPL");
diff --git a/include/linux/usb/nop-usb-xceiv.h b/include/linux/usb/nop-usb-xceiv.h
index 148d351..11d85b9 100644
--- a/include/linux/usb/nop-usb-xceiv.h
+++ b/include/linux/usb/nop-usb-xceiv.h
@@ -3,7 +3,7 @@
 
 #include <linux/usb/otg.h>
 
-struct nop_usb_xceiv_platform_data {
+struct usb_phy_gen_xceiv_platform_data {
 	enum usb_phy_type type;
 	unsigned long clk_rate;
 
-- 
1.8.3.2

