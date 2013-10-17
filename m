Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762768Ab3JQUaa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Oct 2013 16:30:30 -0400
Received: from dukecmmtar04.coxmail.com ([68.99.120.47]:46938 "EHLO
	dukecmmtar04.coxmail.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762522Ab3JQUa2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Oct 2013 16:30:28 -0400
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: linux-usb@vger.kernel.org
Subject: [PATCH 2/2 v4] usb: ohci: remove ep93xx bus glue platform driver
Date: Thu, 17 Oct 2013 13:29:11 -0700
User-Agent: KMail/1.9.9
Cc: ARM Kernel <linux-arm-kernel@lists.infradead.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Ryan Mallon <rmallon@gmail.com>, stern@rowland.harvard.edu,
        Lennert Buytenhek <buytenh@wantstofly.org>, gregkh@linuxfoundation.org,
        olof@lixom.net, Russell King <linux@arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <201310171329.12434.hartleys@visionengravers.com>
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
 arch/arm/configs/ep93xx_defconfig |   1 +
 arch/arm/mach-ep93xx/clock.c      |   2 +-
 arch/arm/mach-ep93xx/core.c       |  38 +++++++-
 drivers/usb/host/ohci-ep93xx.c    | 184 --------------------------------------
 drivers/usb/host/ohci-hcd.c       |  18 ----
 5 files changed, 36 insertions(+), 207 deletions(-)
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
index 3f12b88..9408fde 100644
--- a/arch/arm/mach-ep93xx/core.c
+++ b/arch/arm/mach-ep93xx/core.c
@@ -36,6 +36,7 @@
 #include <linux/export.h>
 #include <linux/irqchip/arm-vic.h>
 #include <linux/reboot.h>
+#include <linux/usb/ohci_pdriver.h>
 
 #include <mach/hardware.h>
 #include <linux/platform_data/video-ep93xx.h>
@@ -297,22 +298,51 @@ static struct platform_device ep93xx_rtc_device = {
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
 
 
diff --git a/drivers/usb/host/ohci-ep93xx.c b/drivers/usb/host/ohci-ep93xx.c
deleted file mode 100644
index 84a20d5..0000000
--- a/drivers/usb/host/ohci-ep93xx.c
+++ /dev/null
@@ -1,184 +0,0 @@
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
-#include <linux/signal.h>
-#include <linux/platform_device.h>
-
-static struct clk *usb_host_clock;
-
-static int ohci_ep93xx_start(struct usb_hcd *hcd)
-{
-	struct ohci_hcd *ohci = hcd_to_ohci(hcd);
-	int ret;
-
-	if ((ret = ohci_init(ohci)) < 0)
-		return ret;
-
-	if ((ret = ohci_run(ohci)) < 0) {
-		dev_err(hcd->self.controller, "can't start %s\n",
-			hcd->self.bus_name);
-		ohci_stop(hcd);
-		return ret;
-	}
-
-	return 0;
-}
-
-static struct hc_driver ohci_ep93xx_hc_driver = {
-	.description		= hcd_name,
-	.product_desc		= "EP93xx OHCI",
-	.hcd_priv_size		= sizeof(struct ohci_hcd),
-	.irq			= ohci_irq,
-	.flags			= HCD_USB11 | HCD_MEMORY,
-	.start			= ohci_ep93xx_start,
-	.stop			= ohci_stop,
-	.shutdown		= ohci_shutdown,
-	.urb_enqueue		= ohci_urb_enqueue,
-	.urb_dequeue		= ohci_urb_dequeue,
-	.endpoint_disable	= ohci_endpoint_disable,
-	.get_frame_number	= ohci_get_frame,
-	.hub_status_data	= ohci_hub_status_data,
-	.hub_control		= ohci_hub_control,
-#ifdef CONFIG_PM
-	.bus_suspend		= ohci_bus_suspend,
-	.bus_resume		= ohci_bus_resume,
-#endif
-	.start_port_reset	= ohci_start_port_reset,
-};
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
-	ohci_hcd_init(hcd_to_ohci(hcd));
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
-MODULE_ALIAS("platform:ep93xx-ohci");
diff --git a/drivers/usb/host/ohci-hcd.c b/drivers/usb/host/ohci-hcd.c
index 604cad1..5845c82 100644
--- a/drivers/usb/host/ohci-hcd.c
+++ b/drivers/usb/host/ohci-hcd.c
@@ -1204,11 +1204,6 @@ MODULE_LICENSE ("GPL");
 #define PLATFORM_DRIVER		ohci_hcd_pxa27x_driver
 #endif
 
-#ifdef CONFIG_ARCH_EP93XX
-#include "ohci-ep93xx.c"
-#define EP93XX_PLATFORM_DRIVER	ohci_hcd_ep93xx_driver
-#endif
-
 #ifdef CONFIG_ARCH_AT91
 #include "ohci-at91.c"
 #define AT91_PLATFORM_DRIVER	ohci_hcd_at91_driver
@@ -1344,12 +1339,6 @@ static int __init ohci_hcd_mod_init(void)
 		goto error_exynos;
 #endif
 
-#ifdef EP93XX_PLATFORM_DRIVER
-	retval = platform_driver_register(&EP93XX_PLATFORM_DRIVER);
-	if (retval < 0)
-		goto error_ep93xx;
-#endif
-
 #ifdef AT91_PLATFORM_DRIVER
 	retval = platform_driver_register(&AT91_PLATFORM_DRIVER);
 	if (retval < 0)
@@ -1393,10 +1382,6 @@ static int __init ohci_hcd_mod_init(void)
 	platform_driver_unregister(&AT91_PLATFORM_DRIVER);
  error_at91:
 #endif
-#ifdef EP93XX_PLATFORM_DRIVER
-	platform_driver_unregister(&EP93XX_PLATFORM_DRIVER);
- error_ep93xx:
-#endif
 #ifdef EXYNOS_PLATFORM_DRIVER
 	platform_driver_unregister(&EXYNOS_PLATFORM_DRIVER);
  error_exynos:
@@ -1462,9 +1447,6 @@ static void __exit ohci_hcd_mod_exit(void)
 #ifdef AT91_PLATFORM_DRIVER
 	platform_driver_unregister(&AT91_PLATFORM_DRIVER);
 #endif
-#ifdef EP93XX_PLATFORM_DRIVER
-	platform_driver_unregister(&EP93XX_PLATFORM_DRIVER);
-#endif
 #ifdef EXYNOS_PLATFORM_DRIVER
 	platform_driver_unregister(&EXYNOS_PLATFORM_DRIVER);
 #endif
-- 
1.8.3.2

