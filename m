Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751539Ab3JUUjO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Oct 2013 16:39:14 -0400
Received: from dukecmmtar03.coxmail.com ([68.99.120.44]:44962 "EHLO
	dukecmmtar03.coxmail.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751079Ab3JUUjM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Oct 2013 16:39:12 -0400
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: linux-usb@vger.kernel.org
Subject: [PATCH 2/2 v5] usb: ohci: remove ep93xx bus glue platform driver
Date: Mon, 21 Oct 2013 13:39:04 -0700
User-Agent: KMail/1.9.9
Cc: stern@rowland.harvard.edu, Ryan Mallon <rmallon@gmail.com>,
        Lennert Buytenhek <buytenh@wantstofly.org>, gregkh@linuxfoundation.org,
        olof@lixom.net, Russell King <linux@arm.linux.org.uk>,
        ARM Kernel <linux-arm-kernel@lists.infradead.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <201310211339.05184.hartleys@visionengravers.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Convert ep93xx to use the OHCI platform driver and remove the
ohci-ep93xx bus glue driver.

Enable CONFIG_OHCI_HCD_PLATFORM in the ep93xx_defconfig so that USB
is still enabled by default on the EP93xx platform.

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
Acked-by: Alan Stern <stern@rowland.harvard.edu>
Cc: Ryan Mallon <rmallon@gmail.com>
Cc: Lennert Buytenhek <kernel@wantstofly.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Olof Johansson <olof@lixom.net>
Cc: Russell King <linux@arm.linux.org.uk>
---
v5: rebase to usb-next (patch 1/2 has already been applied)

v4: propagate errno from clk_enable() in ep93xx_ohci_power_on().

v3: split patch to refresh the ep93xx_defconfig before removing
    ohci-ep93xx.c in favor of the Generic OHCI driver for a
    platform device.

v2: Use the (*power_off) callback for (*power_suspend), as
    suggested by Alan Stern.
    Remove the Kconfig change to USB_OHCI_HCD_PLATFORM and
    refresh the ep93xx_defconfig to enable this option, as
    suggested by Alan Stern.

 arch/arm/configs/ep93xx_defconfig |   1 +
 arch/arm/mach-ep93xx/clock.c      |   2 +-
 arch/arm/mach-ep93xx/core.c       |  39 +++++++--
 drivers/usb/host/Kconfig          |   8 --
 drivers/usb/host/Makefile         |   1 -
 drivers/usb/host/ohci-ep93xx.c    | 174 --------------------------------------
 6 files changed, 36 insertions(+), 189 deletions(-)
 delete mode 100644 drivers/usb/host/ohci-ep93xx.c

diff --git a/arch/arm/configs/ep93xx_defconfig b/arch/arm/configs/ep93xx_defconfig
index 8eccbcb..6ac5ea7 100644
--- a/arch/arm/configs/ep93xx_defconfig
+++ b/arch/arm/configs/ep93xx_defconfig
@@ -83,6 +83,7 @@ CONFIG_USB=y
 CONFIG_USB_DEBUG=y
 CONFIG_USB_DYNAMIC_MINORS=y
 CONFIG_USB_OHCI_HCD=y
+CONFIG_USB_OHCI_HCD_PLATFORM=y
 CONFIG_USB_STORAGE=y
 CONFIG_USB_SERIAL=y
 CONFIG_USB_SERIAL_CONSOLE=y
diff --git a/arch/arm/mach-ep93xx/clock.c b/arch/arm/mach-ep93xx/clock.c
index c95dbce..39ef3b6 100644
--- a/arch/arm/mach-ep93xx/clock.c
+++ b/arch/arm/mach-ep93xx/clock.c
@@ -212,7 +212,7 @@ static struct clk_lookup clocks[] = {
 	INIT_CK(NULL,			"hclk",		&clk_h),
 	INIT_CK(NULL,			"apb_pclk",	&clk_p),
 	INIT_CK(NULL,			"pll2",		&clk_pll2),
-	INIT_CK("ep93xx-ohci",		NULL,		&clk_usb_host),
+	INIT_CK("ohci-platform",	NULL,		&clk_usb_host),
 	INIT_CK("ep93xx-keypad",	NULL,		&clk_keypad),
 	INIT_CK("ep93xx-fb",		NULL,		&clk_video),
 	INIT_CK("ep93xx-spi.0",		NULL,		&clk_spi),
diff --git a/arch/arm/mach-ep93xx/core.c b/arch/arm/mach-ep93xx/core.c
index 3f12b88..d95ee28a 100644
--- a/arch/arm/mach-ep93xx/core.c
+++ b/arch/arm/mach-ep93xx/core.c
@@ -36,6 +36,7 @@
 #include <linux/export.h>
 #include <linux/irqchip/arm-vic.h>
 #include <linux/reboot.h>
+#include <linux/usb/ohci_pdriver.h>
 
 #include <mach/hardware.h>
 #include <linux/platform_data/video-ep93xx.h>
@@ -297,25 +298,53 @@ static struct platform_device ep93xx_rtc_device = {
 	.resource	= ep93xx_rtc_resource,
 };
 
+/*************************************************************************
+ * EP93xx OHCI USB Host
+ *************************************************************************/
+
+static struct clk *ep93xx_ohci_host_clock;
+
+static int ep93xx_ohci_power_on(struct platform_device *pdev)
+{
+	if (!ep93xx_ohci_host_clock) {
+		ep93xx_ohci_host_clock = devm_clk_get(&pdev->dev, NULL);
+		if (IS_ERR(ep93xx_ohci_host_clock))
+			return PTR_ERR(ep93xx_ohci_host_clock);
+	}
+
+	return clk_enable(ep93xx_ohci_host_clock);
+}
+
+static void ep93xx_ohci_power_off(struct platform_device *pdev)
+{
+	clk_disable(ep93xx_ohci_host_clock);
+}
+
+static struct usb_ohci_pdata ep93xx_ohci_pdata = {
+	.power_on	= ep93xx_ohci_power_on,
+	.power_off	= ep93xx_ohci_power_off,
+	.power_suspend	= ep93xx_ohci_power_off,
+};
 
 static struct resource ep93xx_ohci_resources[] = {
 	DEFINE_RES_MEM(EP93XX_USB_PHYS_BASE, 0x1000),
 	DEFINE_RES_IRQ(IRQ_EP93XX_USB),
 };
 
+static u64 ep93xx_ohci_dma_mask = DMA_BIT_MASK(32);
 
 static struct platform_device ep93xx_ohci_device = {
-	.name		= "ep93xx-ohci",
+	.name		= "ohci-platform",
 	.id		= -1,
+	.num_resources	= ARRAY_SIZE(ep93xx_ohci_resources),
+	.resource	= ep93xx_ohci_resources,
 	.dev		= {
-		.dma_mask		= &ep93xx_ohci_device.dev.coherent_dma_mask,
+		.dma_mask		= &ep93xx_ohci_dma_mask,
 		.coherent_dma_mask	= DMA_BIT_MASK(32),
+		.platform_data		= &ep93xx_ohci_pdata,
 	},
-	.num_resources	= ARRAY_SIZE(ep93xx_ohci_resources),
-	.resource	= ep93xx_ohci_resources,
 };
 
-
 /*************************************************************************
  * EP93xx physmap'ed flash
  *************************************************************************/
diff --git a/drivers/usb/host/Kconfig b/drivers/usb/host/Kconfig
index 80e72fb..a9707da 100644
--- a/drivers/usb/host/Kconfig
+++ b/drivers/usb/host/Kconfig
@@ -396,14 +396,6 @@ config USB_OHCI_HCD_LPC32XX
           Enables support for the on-chip OHCI controller on
           NXP chips.
 
-config USB_OHCI_HCD_EP93XX
-	tristate "Support for EP93XX on-chip OHCI USB controller"
-	depends on USB_OHCI_HCD && ARCH_EP93XX
-	default y
-	---help---
-	  Enables support for the on-chip OHCI controller on
-	  EP93XX chips.
-
 config USB_OHCI_HCD_PXA27X
 	tristate "Support for PXA27X/PXA3XX on-chip OHCI USB controller"
 	depends on USB_OHCI_HCD && (PXA27x || PXA3xx)
diff --git a/drivers/usb/host/Makefile b/drivers/usb/host/Makefile
index 9dc11c2..01e879e 100644
--- a/drivers/usb/host/Makefile
+++ b/drivers/usb/host/Makefile
@@ -54,7 +54,6 @@ obj-$(CONFIG_USB_OHCI_HCD_SPEAR)	+= ohci-spear.o
 obj-$(CONFIG_USB_OHCI_HCD_AT91)	+= ohci-at91.o
 obj-$(CONFIG_USB_OHCI_HCD_S3C2410)	+= ohci-s3c2410.o
 obj-$(CONFIG_USB_OHCI_HCD_LPC32XX)	+= ohci-nxp.o
-obj-$(CONFIG_USB_OHCI_HCD_EP93XX)	+= ohci-ep93xx.o
 obj-$(CONFIG_USB_OHCI_HCD_PXA27X)	+= ohci-pxa27x.o
 
 obj-$(CONFIG_USB_UHCI_HCD)	+= uhci-hcd.o
diff --git a/drivers/usb/host/ohci-ep93xx.c b/drivers/usb/host/ohci-ep93xx.c
deleted file mode 100644
index 492f681..0000000
--- a/drivers/usb/host/ohci-ep93xx.c
+++ /dev/null
@@ -1,174 +0,0 @@
-/*
- * OHCI HCD (Host Controller Driver) for USB.
- *
- * (C) Copyright 1999 Roman Weissgaerber <weissg@vienna.at>
- * (C) Copyright 2000-2002 David Brownell <dbrownell@users.sourceforge.net>
- * (C) Copyright 2002 Hewlett-Packard Company
- *
- * Bus Glue for ep93xx.
- *
- * Written by Christopher Hoover <ch@hpl.hp.com>
- * Based on fragments of previous driver by Russell King et al.
- *
- * Modified for LH7A404 from ohci-sa1111.c
- *  by Durgesh Pattamatta <pattamattad@sharpsec.com>
- *
- * Modified for pxa27x from ohci-lh7a404.c
- *  by Nick Bane <nick@cecomputing.co.uk> 26-8-2004
- *
- * Modified for ep93xx from ohci-pxa27x.c
- *  by Lennert Buytenhek <buytenh@wantstofly.org> 28-2-2006
- *  Based on an earlier driver by Ray Lehtiniemi
- *
- * This file is licenced under the GPL.
- */
-
-#include <linux/clk.h>
-#include <linux/device.h>
-#include <linux/io.h>
-#include <linux/kernel.h>
-#include <linux/module.h>
-#include <linux/platform_device.h>
-#include <linux/signal.h>
-#include <linux/usb.h>
-#include <linux/usb/hcd.h>
-
-#include "ohci.h"
-
-#define DRIVER_DESC "OHCI EP93xx driver"
-
-static const char hcd_name[] = "ohci-ep93xx";
-
-static struct hc_driver __read_mostly ohci_ep93xx_hc_driver;
-
-static struct clk *usb_host_clock;
-
-static int ohci_hcd_ep93xx_drv_probe(struct platform_device *pdev)
-{
-	struct usb_hcd *hcd;
-	struct resource *res;
-	int irq;
-	int ret;
-
-	if (usb_disabled())
-		return -ENODEV;
-
-	irq = platform_get_irq(pdev, 0);
-	if (irq < 0)
-		return irq;
-
-	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
-	if (!res)
-		return -ENXIO;
-
-	hcd = usb_create_hcd(&ohci_ep93xx_hc_driver, &pdev->dev, "ep93xx");
-	if (!hcd)
-		return -ENOMEM;
-
-	hcd->rsrc_start = res->start;
-	hcd->rsrc_len = resource_size(res);
-
-	hcd->regs = devm_ioremap_resource(&pdev->dev, res);
-	if (IS_ERR(hcd->regs)) {
-		ret = PTR_ERR(hcd->regs);
-		goto err_put_hcd;
-	}
-
-	usb_host_clock = devm_clk_get(&pdev->dev, NULL);
-	if (IS_ERR(usb_host_clock)) {
-		ret = PTR_ERR(usb_host_clock);
-		goto err_put_hcd;
-	}
-
-	clk_enable(usb_host_clock);
-
-	ret = usb_add_hcd(hcd, irq, 0);
-	if (ret)
-		goto err_clk_disable;
-
-	return 0;
-
-err_clk_disable:
-	clk_disable(usb_host_clock);
-err_put_hcd:
-	usb_put_hcd(hcd);
-
-	return ret;
-}
-
-static int ohci_hcd_ep93xx_drv_remove(struct platform_device *pdev)
-{
-	struct usb_hcd *hcd = platform_get_drvdata(pdev);
-
-	usb_remove_hcd(hcd);
-	clk_disable(usb_host_clock);
-	usb_put_hcd(hcd);
-
-	return 0;
-}
-
-#ifdef CONFIG_PM
-static int ohci_hcd_ep93xx_drv_suspend(struct platform_device *pdev, pm_message_t state)
-{
-	struct usb_hcd *hcd = platform_get_drvdata(pdev);
-	struct ohci_hcd *ohci = hcd_to_ohci(hcd);
-
-	if (time_before(jiffies, ohci->next_statechange))
-		msleep(5);
-	ohci->next_statechange = jiffies;
-
-	clk_disable(usb_host_clock);
-	return 0;
-}
-
-static int ohci_hcd_ep93xx_drv_resume(struct platform_device *pdev)
-{
-	struct usb_hcd *hcd = platform_get_drvdata(pdev);
-	struct ohci_hcd *ohci = hcd_to_ohci(hcd);
-
-	if (time_before(jiffies, ohci->next_statechange))
-		msleep(5);
-	ohci->next_statechange = jiffies;
-
-	clk_enable(usb_host_clock);
-
-	ohci_resume(hcd, false);
-	return 0;
-}
-#endif
-
-static struct platform_driver ohci_hcd_ep93xx_driver = {
-	.probe		= ohci_hcd_ep93xx_drv_probe,
-	.remove		= ohci_hcd_ep93xx_drv_remove,
-	.shutdown	= usb_hcd_platform_shutdown,
-#ifdef CONFIG_PM
-	.suspend	= ohci_hcd_ep93xx_drv_suspend,
-	.resume		= ohci_hcd_ep93xx_drv_resume,
-#endif
-	.driver		= {
-		.name	= "ep93xx-ohci",
-		.owner	= THIS_MODULE,
-	},
-};
-
-static int __init ohci_ep93xx_init(void)
-{
-	if (usb_disabled())
-		return -ENODEV;
-
-	pr_info("%s: " DRIVER_DESC "\n", hcd_name);
-
-	ohci_init_driver(&ohci_ep93xx_hc_driver, NULL);
-	return platform_driver_register(&ohci_hcd_ep93xx_driver);
-}
-module_init(ohci_ep93xx_init);
-
-static void __exit ohci_ep93xx_cleanup(void)
-{
-	platform_driver_unregister(&ohci_hcd_ep93xx_driver);
-}
-module_exit(ohci_ep93xx_cleanup);
-
-MODULE_DESCRIPTION(DRIVER_DESC);
-MODULE_LICENSE("GPL");
-MODULE_ALIAS("platform:ep93xx-ohci");
-- 
1.8.3.2

