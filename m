Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754407Ab3C1Vyt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Mar 2013 17:54:49 -0400
Received: from moutng.kundenserver.de ([212.227.126.186]:59379 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754096Ab3C1Vyq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Mar 2013 17:54:46 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: linux-usb@vger.kernel.org, Manjunath Goudar <manjunath.goudar@linaro.org>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Greg KH <greg@kroah.com>, Kukjin Kim <kgene.kim@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>, Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH v3 3/7] USB: EHCI: make ehci-s5p a separate driver
Date: Thu, 28 Mar 2013 22:55:01 +0100
Message-Id: <1364507705-22012-4-git-send-email-arnd@arndb.de>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1364507705-22012-1-git-send-email-arnd@arndb.de>
References: <1364507705-22012-1-git-send-email-arnd@arndb.de>
X-Provags-ID: V02:K0:T8sJ/Avv5Nc/AY/xrY41GlS1jqGk3ZLlJ8xMIuHG1bF
 aab7ghWTT7wyr9WiZhAPs3RRbDizcnRQ8pIMsPWOpWml48xvLc
 4NwTbmsr7Agf1ZKEYe4UzjXIumncZfCIDZL1cd0UDt6OEizXj6
 wLTpAou2OQ4CDTfgvO47odSPEik/Ro+akPSdMkgt/0tsCII63b
 zwdTCTtTgzdmNOO4dUXSfD3jcjOKKxAeoNv5iETxK/gX1chZkr
 KhqBPDzX1XEDiBet3JjOVMHjRVg8TiByIg01dHUsa+8nDQ6DuJ
 7JOIaAGA2Ai6xSu9NTjRXxXu8DIWNkfEXToCrobiUDyF3+IFbj
 h/nL1hH2LvQHCE5zGLBVi3cGZf4D/B0VeXGr2T0Mn
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Manjunath Goudar <manjunath.goudar@linaro.org>

Separate the  Samsung S5P/EXYNOS host controller driver from ehci-hcd
host code so that it can be built as a separate driver module.
This work is part of enabling multi-platform kernels on ARM;
however, note that other changes are still needed before S5P/EXYNOS can
be booted with a multi-platform kernel. We currently expect those
to get merged for 3.10.

With the infrastructure added by Alan Stern in patch 3e0232039
"USB: EHCI: prepare to make ehci-hcd a library module", we can
avoid this problem by turning a bus glue into a separate
module, as we do here for the s5p bus glue.

In V3:
 -Detail commit message added here,why this patch is required.
 -MODULE_LICENSE is GPL v2.
 -Added .extra_priv_size to eliminate the separate allocation of the s5p_ehci_hcd structure
  and removed .reset function pointer initialization.
 -Arranged  #include's in alphabetical order.
 -After using extra_priv_size initialization,struct usb_hcd *hcd is redundant that's why removed
  from the prob function.
 -Eliminated s5p_ehci_phy_enable,contents of statements moved into the s5p_ehci_probe
 -Eliminated s5p_ehci_phy_disable, contents of statements moved into the s5p_ehci_remove.

In V2:
Tegra patch related changes removed from this patch.

Signed-off-by: Manjunath Goudar <manjunath.goudar@linaro.org>
Acked-by: Jingoo Han <jg1.han@samsung.com>
Cc: Greg KH <greg@kroah.com>
Cc: Alan Stern <stern@rowland.harvard.edu>
Cc: Kukjin Kim <kgene.kim@samsung.com>
Cc: Kyungmin Park <kyungmin.park@samsung.com>
Cc: Grant Likely <grant.likely@secretlab.ca>
Cc: Rob Herring <rob.herring@calxeda.com>
Cc: linux-usb@vger.kernel.org
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 drivers/usb/host/Kconfig    |   5 +-
 drivers/usb/host/Makefile   |   1 +
 drivers/usb/host/ehci-hcd.c |   6 +-
 drivers/usb/host/ehci-s5p.c | 153 ++++++++++++++++++++++----------------------
 4 files changed, 82 insertions(+), 83 deletions(-)

diff --git a/drivers/usb/host/Kconfig b/drivers/usb/host/Kconfig
index 12fb83e..01c1acb 100644
--- a/drivers/usb/host/Kconfig
+++ b/drivers/usb/host/Kconfig
@@ -218,10 +218,11 @@ config USB_EHCI_SH
 	  If you use the PCI EHCI controller, this option is not necessary.
 
 config USB_EHCI_S5P
-       boolean "S5P EHCI support"
+       tristate "EHCI support for Samsung S5P/EXYNOS SoC Series"
        depends on USB_EHCI_HCD && PLAT_S5P
        help
-	 Enable support for the S5P SOC's on-chip EHCI controller.
+	Enable support for the Samsung S5Pxxxx and Exynos3/4/5 SOC's
+	on-chip EHCI controller.
 
 config USB_EHCI_MV
 	bool "EHCI support for Marvell on-chip controller"
diff --git a/drivers/usb/host/Makefile b/drivers/usb/host/Makefile
index 3e02471..3d895b5 100644
--- a/drivers/usb/host/Makefile
+++ b/drivers/usb/host/Makefile
@@ -30,6 +30,7 @@ obj-$(CONFIG_USB_EHCI_MXC)	+= ehci-mxc.o
 obj-$(CONFIG_USB_EHCI_HCD_OMAP)	+= ehci-omap.o
 obj-$(CONFIG_USB_EHCI_HCD_ORION)	+= ehci-orion.o
 obj-$(CONFIG_USB_EHCI_HCD_SPEAR)	+= ehci-spear.o
+obj-$(CONFIG_USB_EHCI_S5P)	+= ehci-s5p.o
 
 obj-$(CONFIG_USB_OXU210HP_HCD)	+= oxu210hp-hcd.o
 obj-$(CONFIG_USB_ISP116X_HCD)	+= isp116x-hcd.o
diff --git a/drivers/usb/host/ehci-hcd.c b/drivers/usb/host/ehci-hcd.c
index c8c70a1..8f1f4b4 100644
--- a/drivers/usb/host/ehci-hcd.c
+++ b/drivers/usb/host/ehci-hcd.c
@@ -1284,11 +1284,6 @@ MODULE_LICENSE ("GPL");
 #define PLATFORM_DRIVER		tegra_ehci_driver
 #endif
 
-#ifdef CONFIG_USB_EHCI_S5P
-#include "ehci-s5p.c"
-#define PLATFORM_DRIVER		s5p_ehci_driver
-#endif
-
 #ifdef CONFIG_SPARC_LEON
 #include "ehci-grlib.c"
 #define PLATFORM_DRIVER		ehci_grlib_driver
@@ -1311,6 +1306,7 @@ MODULE_LICENSE ("GPL");
 	!IS_ENABLED(CONFIG_USB_EHCI_HCD_OMAP) && \
 	!IS_ENABLED(CONFIG_USB_EHCI_HCD_ORION) && \
 	!IS_ENABLED(CONFIG_USB_EHCI_HCD_SPEAR) && \
+	!IS_ENABLED(CONFIG_USB_EHCI_S5P) && \
 	!defined(PLATFORM_DRIVER) && \
 	!defined(PS3_SYSTEM_BUS_DRIVER) && \
 	!defined(OF_PLATFORM_DRIVER) && \
diff --git a/drivers/usb/host/ehci-s5p.c b/drivers/usb/host/ehci-s5p.c
index 738490e..f32be6f 100644
--- a/drivers/usb/host/ehci-s5p.c
+++ b/drivers/usb/host/ehci-s5p.c
@@ -13,13 +13,24 @@
  */
 
 #include <linux/clk.h>
+#include <linux/dma-mapping.h>
+#include <linux/io.h>
+#include <linux/kernel.h>
+#include <linux/module.h>
 #include <linux/of.h>
-#include <linux/platform_device.h>
 #include <linux/of_gpio.h>
+#include <linux/platform_device.h>
 #include <linux/platform_data/usb-ehci-s5p.h>
 #include <linux/usb/phy.h>
 #include <linux/usb/samsung_usb_phy.h>
 #include <plat/usb-phy.h>
+#include <linux/usb.h>
+#include <linux/usb/hcd.h>
+#include <linux/usb/otg.h>
+
+#include "ehci.h"
+
+#define DRIVER_DESC "EHCI s5p driver"
 
 #define EHCI_INSNREG00(base)			(base + 0x90)
 #define EHCI_INSNREG00_ENA_INCR16		(0x1 << 25)
@@ -30,65 +41,17 @@
 	(EHCI_INSNREG00_ENA_INCR16 | EHCI_INSNREG00_ENA_INCR8 |	\
 	 EHCI_INSNREG00_ENA_INCR4 | EHCI_INSNREG00_ENA_INCRX_ALIGN)
 
+static const char hcd_name[] = "ehci-s5p";
+static struct hc_driver __read_mostly s5p_ehci_hc_driver;
+
 struct s5p_ehci_hcd {
-	struct device *dev;
-	struct usb_hcd *hcd;
 	struct clk *clk;
 	struct usb_phy *phy;
 	struct usb_otg *otg;
 	struct s5p_ehci_platdata *pdata;
 };
 
-static const struct hc_driver s5p_ehci_hc_driver = {
-	.description		= hcd_name,
-	.product_desc		= "S5P EHCI Host Controller",
-	.hcd_priv_size		= sizeof(struct ehci_hcd),
-
-	.irq			= ehci_irq,
-	.flags			= HCD_MEMORY | HCD_USB2,
-
-	.reset			= ehci_setup,
-	.start			= ehci_run,
-	.stop			= ehci_stop,
-	.shutdown		= ehci_shutdown,
-
-	.get_frame_number	= ehci_get_frame,
-
-	.urb_enqueue		= ehci_urb_enqueue,
-	.urb_dequeue		= ehci_urb_dequeue,
-	.endpoint_disable	= ehci_endpoint_disable,
-	.endpoint_reset		= ehci_endpoint_reset,
-
-	.hub_status_data	= ehci_hub_status_data,
-	.hub_control		= ehci_hub_control,
-	.bus_suspend		= ehci_bus_suspend,
-	.bus_resume		= ehci_bus_resume,
-
-	.relinquish_port	= ehci_relinquish_port,
-	.port_handed_over	= ehci_port_handed_over,
-
-	.clear_tt_buffer_complete	= ehci_clear_tt_buffer_complete,
-};
-
-static void s5p_ehci_phy_enable(struct s5p_ehci_hcd *s5p_ehci)
-{
-	struct platform_device *pdev = to_platform_device(s5p_ehci->dev);
-
-	if (s5p_ehci->phy)
-		usb_phy_init(s5p_ehci->phy);
-	else if (s5p_ehci->pdata->phy_init)
-		s5p_ehci->pdata->phy_init(pdev, USB_PHY_TYPE_HOST);
-}
-
-static void s5p_ehci_phy_disable(struct s5p_ehci_hcd *s5p_ehci)
-{
-	struct platform_device *pdev = to_platform_device(s5p_ehci->dev);
-
-	if (s5p_ehci->phy)
-		usb_phy_shutdown(s5p_ehci->phy);
-	else if (s5p_ehci->pdata->phy_exit)
-		s5p_ehci->pdata->phy_exit(pdev, USB_PHY_TYPE_HOST);
-}
+#define to_s5p_ehci(hcd)      (struct s5p_ehci_hcd *)(hcd_to_ehci(hcd)->priv)
 
 static void s5p_setup_vbus_gpio(struct platform_device *pdev)
 {
@@ -113,9 +76,10 @@ static u64 ehci_s5p_dma_mask = DMA_BIT_MASK(32);
 
 static int s5p_ehci_probe(struct platform_device *pdev)
 {
+	struct usb_hcd *hcd ;
 	struct s5p_ehci_platdata *pdata = pdev->dev.platform_data;
+	const struct hc_driver *driver = &s5p_ehci_hc_driver;
 	struct s5p_ehci_hcd *s5p_ehci;
-	struct usb_hcd *hcd;
 	struct ehci_hcd *ehci;
 	struct resource *res;
 	struct usb_phy *phy;
@@ -153,16 +117,12 @@ static int s5p_ehci_probe(struct platform_device *pdev)
 		s5p_ehci->otg = phy->otg;
 	}
 
-	s5p_ehci->dev = &pdev->dev;
-
-	hcd = usb_create_hcd(&s5p_ehci_hc_driver, &pdev->dev,
-					dev_name(&pdev->dev));
+	hcd = usb_create_hcd(driver, &pdev->dev, dev_name(&pdev->dev));
 	if (!hcd) {
 		dev_err(&pdev->dev, "Unable to create HCD\n");
 		return -ENOMEM;
 	}
 
-	s5p_ehci->hcd = hcd;
 	s5p_ehci->clk = devm_clk_get(&pdev->dev, "usbhost");
 
 	if (IS_ERR(s5p_ehci->clk)) {
@@ -199,9 +159,12 @@ static int s5p_ehci_probe(struct platform_device *pdev)
 	}
 
 	if (s5p_ehci->otg)
-		s5p_ehci->otg->set_host(s5p_ehci->otg, &s5p_ehci->hcd->self);
+		s5p_ehci->otg->set_host(s5p_ehci->otg, &hcd->self);
 
-	s5p_ehci_phy_enable(s5p_ehci);
+	if (s5p_ehci->phy)
+		usb_phy_init(s5p_ehci->phy);
+	else if (s5p_ehci->pdata->phy_init)
+		s5p_ehci->pdata->phy_init(pdev, USB_PHY_TYPE_HOST);
 
 	ehci = hcd_to_ehci(hcd);
 	ehci->caps = hcd->regs;
@@ -220,7 +183,10 @@ static int s5p_ehci_probe(struct platform_device *pdev)
 	return 0;
 
 fail_add_hcd:
-	s5p_ehci_phy_disable(s5p_ehci);
+	if (s5p_ehci->phy)
+		usb_phy_shutdown(s5p_ehci->phy);
+	else if (s5p_ehci->pdata->phy_exit)
+		s5p_ehci->pdata->phy_exit(pdev, USB_PHY_TYPE_HOST);
 fail_io:
 	clk_disable_unprepare(s5p_ehci->clk);
 fail_clk:
@@ -230,15 +196,18 @@ fail_clk:
 
 static int s5p_ehci_remove(struct platform_device *pdev)
 {
-	struct s5p_ehci_hcd *s5p_ehci = platform_get_drvdata(pdev);
-	struct usb_hcd *hcd = s5p_ehci->hcd;
+	struct usb_hcd *hcd = platform_get_drvdata(pdev);
+	struct s5p_ehci_hcd *s5p_ehci = to_s5p_ehci(hcd);
 
 	usb_remove_hcd(hcd);
 
 	if (s5p_ehci->otg)
-		s5p_ehci->otg->set_host(s5p_ehci->otg, &s5p_ehci->hcd->self);
+		s5p_ehci->otg->set_host(s5p_ehci->otg, &hcd->self);
 
-	s5p_ehci_phy_disable(s5p_ehci);
+	if (s5p_ehci->phy)
+		usb_phy_shutdown(s5p_ehci->phy);
+	else if (s5p_ehci->pdata->phy_exit)
+		s5p_ehci->pdata->phy_exit(pdev, USB_PHY_TYPE_HOST);
 
 	clk_disable_unprepare(s5p_ehci->clk);
 
@@ -249,8 +218,7 @@ static int s5p_ehci_remove(struct platform_device *pdev)
 
 static void s5p_ehci_shutdown(struct platform_device *pdev)
 {
-	struct s5p_ehci_hcd *s5p_ehci = platform_get_drvdata(pdev);
-	struct usb_hcd *hcd = s5p_ehci->hcd;
+	struct usb_hcd *hcd = platform_get_drvdata(pdev);
 
 	if (hcd->driver->shutdown)
 		hcd->driver->shutdown(hcd);
@@ -259,17 +227,22 @@ static void s5p_ehci_shutdown(struct platform_device *pdev)
 #ifdef CONFIG_PM
 static int s5p_ehci_suspend(struct device *dev)
 {
-	struct s5p_ehci_hcd *s5p_ehci = dev_get_drvdata(dev);
-	struct usb_hcd *hcd = s5p_ehci->hcd;
+	struct usb_hcd *hcd = dev_get_drvdata(dev);
+	struct s5p_ehci_hcd *s5p_ehci = to_s5p_ehci(hcd);
+	struct platform_device *pdev = to_platform_device(dev);
+
 	bool do_wakeup = device_may_wakeup(dev);
 	int rc;
 
 	rc = ehci_suspend(hcd, do_wakeup);
 
 	if (s5p_ehci->otg)
-		s5p_ehci->otg->set_host(s5p_ehci->otg, &s5p_ehci->hcd->self);
+		s5p_ehci->otg->set_host(s5p_ehci->otg, &hcd->self);
 
-	s5p_ehci_phy_disable(s5p_ehci);
+	if (s5p_ehci->phy)
+		usb_phy_shutdown(s5p_ehci->phy);
+	else if (s5p_ehci->pdata->phy_exit)
+		s5p_ehci->pdata->phy_exit(pdev, USB_PHY_TYPE_HOST);
 
 	clk_disable_unprepare(s5p_ehci->clk);
 
@@ -278,15 +251,19 @@ static int s5p_ehci_suspend(struct device *dev)
 
 static int s5p_ehci_resume(struct device *dev)
 {
-	struct s5p_ehci_hcd *s5p_ehci = dev_get_drvdata(dev);
-	struct usb_hcd *hcd = s5p_ehci->hcd;
+	struct usb_hcd *hcd = dev_get_drvdata(dev);
+	struct  s5p_ehci_hcd *s5p_ehci = to_s5p_ehci(hcd);
+	struct platform_device *pdev = to_platform_device(dev);
 
 	clk_prepare_enable(s5p_ehci->clk);
 
 	if (s5p_ehci->otg)
-		s5p_ehci->otg->set_host(s5p_ehci->otg, &s5p_ehci->hcd->self);
+		s5p_ehci->otg->set_host(s5p_ehci->otg, &hcd->self);
 
-	s5p_ehci_phy_enable(s5p_ehci);
+	if (s5p_ehci->phy)
+		usb_phy_init(s5p_ehci->phy);
+	else if (s5p_ehci->pdata->phy_init)
+		s5p_ehci->pdata->phy_init(pdev, USB_PHY_TYPE_HOST);
 
 	/* DMA burst Enable */
 	writel(EHCI_INSNREG00_ENABLE_DMA_BURST, EHCI_INSNREG00(hcd->regs));
@@ -323,5 +300,29 @@ static struct platform_driver s5p_ehci_driver = {
 		.of_match_table = of_match_ptr(exynos_ehci_match),
 	}
 };
+static const struct ehci_driver_overrides s5p_overrides __initdata = {
+	.extra_priv_size = sizeof(struct s5p_ehci_hcd),
+};
+
+static int __init ehci_s5p_init(void)
+{
+	if (usb_disabled())
+		return -ENODEV;
+
+	pr_info("%s: " DRIVER_DESC "\n", hcd_name);
+	ehci_init_driver(&s5p_ehci_hc_driver, &s5p_overrides);
+	return platform_driver_register(&s5p_ehci_driver);
+}
+module_init(ehci_s5p_init);
+
+static void __exit ehci_s5p_cleanup(void)
+{
+	platform_driver_unregister(&s5p_ehci_driver);
+}
+module_exit(ehci_s5p_cleanup);
 
+MODULE_DESCRIPTION(DRIVER_DESC);
 MODULE_ALIAS("platform:s5p-ehci");
+MODULE_AUTHOR("Jingoo Han");
+MODULE_AUTHOR("Joonyoung Shim");
+MODULE_LICENSE("GPL v2");
-- 
1.8.1.2

