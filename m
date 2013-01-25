Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755764Ab3AYCUe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jan 2013 21:20:34 -0500
Received: from bear.ext.ti.com ([192.94.94.41]:45385 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754372Ab3AYCU2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jan 2013 21:20:28 -0500
From: Kishon Vijay Abraham I <kishon@ti.com>
To: <rob.herring@calxeda.com>, <rob@landley.net>, <tony@atomide.com>,
        <balbi@ti.com>, <b-cousson@ti.com>, <linux-usb@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <linux-omap@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-doc@vger.kernel.org>,
        <devicetree-discuss@lists.ozlabs.org>
CC: <grant.likely@secretlab.ca>, <linux@arm.linux.org.uk>,
        <gregkh@linuxfoundation.org>, <kishon@ti.com>
Subject: [PATCH v3 4/4] drivers: usb: start using the control module driver
Date: Fri, 25 Jan 2013 07:49:51 +0530
Message-ID: <1359080391-5120-5-git-send-email-kishon@ti.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1359080391-5120-1-git-send-email-kishon@ti.com>
References: <1359080391-5120-1-git-send-email-kishon@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Start using the control module driver for powering on the PHY and for
writing to the mailbox instead of writing to the control module
registers on their own.

Signed-off-by: Kishon Vijay Abraham I <kishon@ti.com>
---
 Documentation/devicetree/bindings/usb/omap-usb.txt |    4 ++
 Documentation/devicetree/bindings/usb/usb-phy.txt  |    7 +-
 arch/arm/mach-omap2/omap_hwmod_44xx_data.c         |   13 ----
 drivers/usb/musb/Kconfig                           |    1 +
 drivers/usb/musb/omap2430.c                        |   68 +++++++-------------
 drivers/usb/musb/omap2430.h                        |    9 ---
 drivers/usb/phy/Kconfig                            |    1 +
 drivers/usb/phy/omap-usb2.c                        |   41 +++---------
 include/linux/usb/omap_usb.h                       |    4 +-
 9 files changed, 40 insertions(+), 108 deletions(-)

diff --git a/Documentation/devicetree/bindings/usb/omap-usb.txt b/Documentation/devicetree/bindings/usb/omap-usb.txt
index 2d8c6c4..704b684 100644
--- a/Documentation/devicetree/bindings/usb/omap-usb.txt
+++ b/Documentation/devicetree/bindings/usb/omap-usb.txt
@@ -3,6 +3,9 @@ OMAP GLUE AND OTHER OMAP SPECIFIC COMPONENTS
 OMAP MUSB GLUE
  - compatible : Should be "ti,omap4-musb" or "ti,omap3-musb"
  - ti,hwmods : must be "usb_otg_hs"
+ - ti,has_mailbox : to specify that omap uses an external mailbox
+   (in control module) to communicate with the musb core during device connect
+   and disconnect.
  - multipoint : Should be "1" indicating the musb controller supports
    multipoint. This is a MUSB configuration-specific setting.
  - num_eps : Specifies the number of endpoints. This is also a
@@ -24,6 +27,7 @@ SOC specific device node entry
 usb_otg_hs: usb_otg_hs@4a0ab000 {
 	compatible = "ti,omap4-musb";
 	ti,hwmods = "usb_otg_hs";
+	ti,has_mailbox;
 	multipoint = <1>;
 	num_eps = <16>;
 	ram_bits = <12>;
diff --git a/Documentation/devicetree/bindings/usb/usb-phy.txt b/Documentation/devicetree/bindings/usb/usb-phy.txt
index 2466b6f..48761a2 100644
--- a/Documentation/devicetree/bindings/usb/usb-phy.txt
+++ b/Documentation/devicetree/bindings/usb/usb-phy.txt
@@ -4,9 +4,7 @@ OMAP USB2 PHY
 
 Required properties:
  - compatible: Should be "ti,omap-usb2"
- - reg : Address and length of the register set for the device. Also
-add the address of control module dev conf register until a driver for
-control module is added
+ - reg : Address and length of the register set for the device.
 
 Optional properties:
  - ctrl_module : phandle of the control module used by PHY driver to power on
@@ -16,7 +14,6 @@ This is usually a subnode of ocp2scp to which it is connected.
 
 usb2phy@4a0ad080 {
 	compatible = "ti,omap-usb2";
-	reg = <0x4a0ad080 0x58>,
-	      <0x4a002300 0x4>;
+	reg = <0x4a0ad080 0x58>;
 	ctrl_module = <&omap_control_usb>;
 };
diff --git a/arch/arm/mach-omap2/omap_hwmod_44xx_data.c b/arch/arm/mach-omap2/omap_hwmod_44xx_data.c
index 129d508..103f4ba 100644
--- a/arch/arm/mach-omap2/omap_hwmod_44xx_data.c
+++ b/arch/arm/mach-omap2/omap_hwmod_44xx_data.c
@@ -2698,13 +2698,6 @@ static struct resource omap44xx_usb_phy_and_pll_addrs[] = {
 		.end		= 0x4a0ae000,
 		.flags		= IORESOURCE_MEM,
 	},
-	{
-		/* XXX: Remove this once control module driver is in place */
-		.name		= "ctrl_dev",
-		.start		= 0x4a002300,
-		.end		= 0x4a002303,
-		.flags		= IORESOURCE_MEM,
-	},
 	{ }
 };
 
@@ -6152,12 +6145,6 @@ static struct omap_hwmod_addr_space omap44xx_usb_otg_hs_addrs[] = {
 		.pa_end		= 0x4a0ab7ff,
 		.flags		= ADDR_TYPE_RT
 	},
-	{
-		/* XXX: Remove this once control module driver is in place */
-		.pa_start	= 0x4a00233c,
-		.pa_end		= 0x4a00233f,
-		.flags		= ADDR_TYPE_RT
-	},
 	{ }
 };
 
diff --git a/drivers/usb/musb/Kconfig b/drivers/usb/musb/Kconfig
index 23a0b7f..de6e5ce 100644
--- a/drivers/usb/musb/Kconfig
+++ b/drivers/usb/musb/Kconfig
@@ -11,6 +11,7 @@ config USB_MUSB_HDRC
 	select NOP_USB_XCEIV if (SOC_TI81XX || SOC_AM33XX)
 	select TWL4030_USB if MACH_OMAP_3430SDP
 	select TWL6030_USB if MACH_OMAP_4430SDP || MACH_OMAP4_PANDA
+	select OMAP_CONTROL_USB if MACH_OMAP_4430SDP || MACH_OMAP4_PANDA
 	select USB_OTG_UTILS
 	help
 	  Say Y here if your system has a dual role high speed USB
diff --git a/drivers/usb/musb/omap2430.c b/drivers/usb/musb/omap2430.c
index da00af4..88a601b 100644
--- a/drivers/usb/musb/omap2430.c
+++ b/drivers/usb/musb/omap2430.c
@@ -37,6 +37,7 @@
 #include <linux/err.h>
 #include <linux/delay.h>
 #include <linux/usb/musb-omap.h>
+#include <linux/usb/omap_control_usb.h>
 
 #include "musb_core.h"
 #include "omap2430.h"
@@ -46,7 +47,7 @@ struct omap2430_glue {
 	struct platform_device	*musb;
 	enum omap_musb_vbus_id_status status;
 	struct work_struct	omap_musb_mailbox_work;
-	u32 __iomem		*control_otghs;
+	struct device		*control_otghs;
 };
 #define glue_to_musb(g)		platform_get_drvdata(g->musb)
 
@@ -54,26 +55,6 @@ struct omap2430_glue		*_glue;
 
 static struct timer_list musb_idle_timer;
 
-/**
- * omap4_usb_phy_mailbox - write to usb otg mailbox
- * @glue: struct omap2430_glue *
- * @val: the value to be written to the mailbox
- *
- * On detection of a device (ID pin is grounded), this API should be called
- * to set AVALID, VBUSVALID and ID pin is grounded.
- *
- * When OMAP is connected to a host (OMAP in device mode), this API
- * is called to set AVALID, VBUSVALID and ID pin in high impedance.
- *
- * XXX: This function will be removed once we have a seperate driver for
- * control module
- */
-static void omap4_usb_phy_mailbox(struct omap2430_glue *glue, u32 val)
-{
-	if (glue->control_otghs)
-		writel(val, glue->control_otghs);
-}
-
 static void musb_do_idle(unsigned long _musb)
 {
 	struct musb	*musb = (void *)_musb;
@@ -269,7 +250,6 @@ EXPORT_SYMBOL_GPL(omap_musb_mailbox);
 
 static void omap_musb_set_mailbox(struct omap2430_glue *glue)
 {
-	u32 val;
 	struct musb *musb = glue_to_musb(glue);
 	struct device *dev = musb->controller;
 	struct musb_hdrc_platform_data *pdata = dev->platform_data;
@@ -285,8 +265,8 @@ static void omap_musb_set_mailbox(struct omap2430_glue *glue)
 		musb->xceiv->last_event = USB_EVENT_ID;
 		if (musb->gadget_driver) {
 			pm_runtime_get_sync(dev);
-			val = AVALID | VBUSVALID;
-			omap4_usb_phy_mailbox(glue, val);
+			omap_control_usb_set_mode(glue->control_otghs,
+				USB_MODE_HOST);
 			omap2430_musb_set_vbus(musb, 1);
 		}
 		break;
@@ -299,8 +279,7 @@ static void omap_musb_set_mailbox(struct omap2430_glue *glue)
 		musb->xceiv->last_event = USB_EVENT_VBUS;
 		if (musb->gadget_driver)
 			pm_runtime_get_sync(dev);
-		val = IDDIG | AVALID | VBUSVALID;
-		omap4_usb_phy_mailbox(glue, val);
+		omap_control_usb_set_mode(glue->control_otghs, USB_MODE_DEVICE);
 		break;
 
 	case OMAP_MUSB_ID_FLOAT:
@@ -317,8 +296,8 @@ static void omap_musb_set_mailbox(struct omap2430_glue *glue)
 			if (musb->xceiv->otg->set_vbus)
 				otg_set_vbus(musb->xceiv->otg, 0);
 		}
-		val = SESSEND | IDDIG;
-		omap4_usb_phy_mailbox(glue, val);
+		omap_control_usb_set_mode(glue->control_otghs,
+			USB_MODE_DISCONNECT);
 		break;
 	default:
 		dev_dbg(dev, "ID float\n");
@@ -415,7 +394,6 @@ err1:
 static void omap2430_musb_enable(struct musb *musb)
 {
 	u8		devctl;
-	u32		val;
 	unsigned long timeout = jiffies + msecs_to_jiffies(1000);
 	struct device *dev = musb->controller;
 	struct omap2430_glue *glue = dev_get_drvdata(dev->parent);
@@ -425,8 +403,7 @@ static void omap2430_musb_enable(struct musb *musb)
 	switch (glue->status) {
 
 	case OMAP_MUSB_ID_GROUND:
-		val = AVALID | VBUSVALID;
-		omap4_usb_phy_mailbox(glue, val);
+		omap_control_usb_set_mode(glue->control_otghs, USB_MODE_HOST);
 		if (data->interface_type != MUSB_INTERFACE_UTMI)
 			break;
 		devctl = musb_readb(musb->mregs, MUSB_DEVCTL);
@@ -445,8 +422,7 @@ static void omap2430_musb_enable(struct musb *musb)
 		break;
 
 	case OMAP_MUSB_VBUS_VALID:
-		val = IDDIG | AVALID | VBUSVALID;
-		omap4_usb_phy_mailbox(glue, val);
+		omap_control_usb_set_mode(glue->control_otghs, USB_MODE_DEVICE);
 		break;
 
 	default:
@@ -456,14 +432,12 @@ static void omap2430_musb_enable(struct musb *musb)
 
 static void omap2430_musb_disable(struct musb *musb)
 {
-	u32 val;
 	struct device *dev = musb->controller;
 	struct omap2430_glue *glue = dev_get_drvdata(dev->parent);
 
-	if (glue->status != OMAP_MUSB_UNKNOWN) {
-		val = SESSEND | IDDIG;
-		omap4_usb_phy_mailbox(glue, val);
-	}
+	if (glue->status != OMAP_MUSB_UNKNOWN)
+		omap_control_usb_set_mode(glue->control_otghs,
+			USB_MODE_DISCONNECT);
 }
 
 static int omap2430_musb_exit(struct musb *musb)
@@ -498,7 +472,6 @@ static int omap2430_probe(struct platform_device *pdev)
 	struct omap2430_glue		*glue;
 	struct device_node		*np = pdev->dev.of_node;
 	struct musb_hdrc_config		*config;
-	struct resource			*res;
 	int				ret = -ENOMEM;
 
 	glue = devm_kzalloc(&pdev->dev, sizeof(*glue), GFP_KERNEL);
@@ -521,12 +494,6 @@ static int omap2430_probe(struct platform_device *pdev)
 	glue->musb			= musb;
 	glue->status			= OMAP_MUSB_UNKNOWN;
 
-	res = platform_get_resource(pdev, IORESOURCE_MEM, 1);
-
-	glue->control_otghs = devm_request_and_ioremap(&pdev->dev, res);
-	if (glue->control_otghs == NULL)
-		dev_dbg(&pdev->dev, "Failed to obtain control memory\n");
-
 	if (np) {
 		pdata = devm_kzalloc(&pdev->dev, sizeof(*pdata), GFP_KERNEL);
 		if (!pdata) {
@@ -558,11 +525,22 @@ static int omap2430_probe(struct platform_device *pdev)
 		of_property_read_u32(np, "ram_bits", (u32 *)&config->ram_bits);
 		of_property_read_u32(np, "power", (u32 *)&pdata->power);
 		config->multipoint = of_property_read_bool(np, "multipoint");
+		pdata->has_mailbox = of_property_read_bool(np,
+		    "ti,has_mailbox");
 
 		pdata->board_data	= data;
 		pdata->config		= config;
 	}
 
+	if (pdata->has_mailbox) {
+		glue->control_otghs = omap_get_control_dev();
+		if (IS_ERR(glue->control_otghs)) {
+			dev_vdbg(&pdev->dev, "Failed to get control device\n");
+			return -ENODEV;
+		}
+	} else {
+		glue->control_otghs = ERR_PTR(-ENODEV);
+	}
 	pdata->platform_ops		= &omap2430_ops;
 
 	platform_set_drvdata(pdev, glue);
diff --git a/drivers/usb/musb/omap2430.h b/drivers/usb/musb/omap2430.h
index 8ef6566..1b5e83a 100644
--- a/drivers/usb/musb/omap2430.h
+++ b/drivers/usb/musb/omap2430.h
@@ -49,13 +49,4 @@
 #define OTG_FORCESTDBY		0x414
 #	define	ENABLEFORCE		(1 << 0)
 
-/*
- * Control Module bit definitions
- * XXX: Will be removed once we have a driver for control module.
- */
-#define	AVALID				BIT(0)
-#define	BVALID				BIT(1)
-#define	VBUSVALID			BIT(2)
-#define	SESSEND				BIT(3)
-#define	IDDIG				BIT(4)
 #endif	/* __MUSB_OMAP243X_H__ */
diff --git a/drivers/usb/phy/Kconfig b/drivers/usb/phy/Kconfig
index 65b6a80..fe6f616 100644
--- a/drivers/usb/phy/Kconfig
+++ b/drivers/usb/phy/Kconfig
@@ -8,6 +8,7 @@ config OMAP_USB2
 	tristate "OMAP USB2 PHY Driver"
 	depends on ARCH_OMAP2PLUS
 	select USB_OTG_UTILS
+	select OMAP_CONTROL_USB
 	help
 	  Enable this to support the transceiver that is part of SOC. This
 	  driver takes care of all the PHY functionality apart from comparator.
diff --git a/drivers/usb/phy/omap-usb2.c b/drivers/usb/phy/omap-usb2.c
index 26ae8f4..c2b4c8e 100644
--- a/drivers/usb/phy/omap-usb2.c
+++ b/drivers/usb/phy/omap-usb2.c
@@ -27,6 +27,7 @@
 #include <linux/err.h>
 #include <linux/pm_runtime.h>
 #include <linux/delay.h>
+#include <linux/usb/omap_control_usb.h>
 
 /**
  * omap_usb2_set_comparator - links the comparator present in the sytem with
@@ -52,29 +53,6 @@ int omap_usb2_set_comparator(struct phy_companion *comparator)
 }
 EXPORT_SYMBOL_GPL(omap_usb2_set_comparator);
 
-/**
- * omap_usb_phy_power - power on/off the phy using control module reg
- * @phy: struct omap_usb *
- * @on: 0 or 1, based on powering on or off the PHY
- *
- * XXX: Remove this function once control module driver gets merged
- */
-static void omap_usb_phy_power(struct omap_usb *phy, int on)
-{
-	u32 val;
-
-	if (on) {
-		val = readl(phy->control_dev);
-		if (val & PHY_PD) {
-			writel(~PHY_PD, phy->control_dev);
-			/* XXX: add proper documentation for this delay */
-			mdelay(200);
-		}
-	} else {
-		writel(PHY_PD, phy->control_dev);
-	}
-}
-
 static int omap_usb_set_vbus(struct usb_otg *otg, bool enabled)
 {
 	struct omap_usb *phy = phy_to_omapusb(otg->phy);
@@ -124,7 +102,7 @@ static int omap_usb2_suspend(struct usb_phy *x, int suspend)
 	struct omap_usb *phy = phy_to_omapusb(x);
 
 	if (suspend && !phy->is_suspended) {
-		omap_usb_phy_power(phy, 0);
+		omap_control_usb_phy_power(phy->control_dev, 0);
 		pm_runtime_put_sync(phy->dev);
 		phy->is_suspended = 1;
 	} else if (!suspend && phy->is_suspended) {
@@ -134,7 +112,7 @@ static int omap_usb2_suspend(struct usb_phy *x, int suspend)
 									ret);
 			return ret;
 		}
-		omap_usb_phy_power(phy, 1);
+		omap_control_usb_phy_power(phy->control_dev, 1);
 		phy->is_suspended = 0;
 	}
 
@@ -145,7 +123,6 @@ static int omap_usb2_probe(struct platform_device *pdev)
 {
 	struct omap_usb			*phy;
 	struct usb_otg			*otg;
-	struct resource			*res;
 
 	phy = devm_kzalloc(&pdev->dev, sizeof(*phy), GFP_KERNEL);
 	if (!phy) {
@@ -166,16 +143,14 @@ static int omap_usb2_probe(struct platform_device *pdev)
 	phy->phy.set_suspend	= omap_usb2_suspend;
 	phy->phy.otg		= otg;
 
-	res = platform_get_resource(pdev, IORESOURCE_MEM, 1);
-
-	phy->control_dev = devm_request_and_ioremap(&pdev->dev, res);
-	if (phy->control_dev == NULL) {
-		dev_err(&pdev->dev, "Failed to obtain io memory\n");
-		return -ENXIO;
+	phy->control_dev = omap_get_control_dev();
+	if (IS_ERR(phy->control_dev)) {
+		dev_dbg(&pdev->dev, "Failed to get control device\n");
+		return -ENODEV;
 	}
 
 	phy->is_suspended	= 1;
-	omap_usb_phy_power(phy, 0);
+	omap_control_usb_phy_power(phy->control_dev, 0);
 
 	otg->set_host		= omap_usb_set_host;
 	otg->set_peripheral	= omap_usb_set_peripheral;
diff --git a/include/linux/usb/omap_usb.h b/include/linux/usb/omap_usb.h
index 0ea17f8..3db9b53 100644
--- a/include/linux/usb/omap_usb.h
+++ b/include/linux/usb/omap_usb.h
@@ -25,13 +25,11 @@ struct omap_usb {
 	struct usb_phy		phy;
 	struct phy_companion	*comparator;
 	struct device		*dev;
-	u32 __iomem		*control_dev;
+	struct device		*control_dev;
 	struct clk		*wkupclk;
 	u8			is_suspended:1;
 };
 
-#define	PHY_PD	0x1
-
 #define	phy_to_omapusb(x)	container_of((x), struct omap_usb, phy)
 
 #if defined(CONFIG_OMAP_USB2) || defined(CONFIG_OMAP_USB2_MODULE)
-- 
1.7.9.5

