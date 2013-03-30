Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756854Ab3C3NEw (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Mar 2013 09:04:52 -0400
Received: from moutng.kundenserver.de ([212.227.126.186]:65179 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755527Ab3C3NEK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Mar 2013 09:04:10 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: linux-usb@vger.kernel.org, Manjunath Goudar <manjunath.goudar@linaro.org>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Greg KH <greg@kroah.com>, Deepak Saxena <dsaxena@linaro.org>,
        Arnd Bergmann <arnd@arndb.de>, Shiraz Hashim <shiraz.hashim@st.com>,
        spear-devel@list.st.com
Subject: [PATCH v4 2/6] USB: EHCI: make ehci-spear a separate driver
Date: Sat, 30 Mar 2013 14:04:19 +0100
Message-Id: <1364648663-29296-3-git-send-email-arnd@arndb.de>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1364648663-29296-1-git-send-email-arnd@arndb.de>
References: <1364648663-29296-1-git-send-email-arnd@arndb.de>
X-Provags-ID: V02:K0:yCzlDMrwgaCsWsRBIRJO22kgtyvp9kuXG7/cqiV0qDU
 lJYzJxgBYWW0Oz5n5YsxgRl0nwu2uD3zhb9x4uSoBbG0sYyvA9
 Wsw6AXB/HUgGgoo2rD94YvS48dEqtNWa7cPxh4JNgkmq1VqKK1
 MUa+AwQmmNidDzpa2aMsa1mXtYPYdGR5qy7+tu3LwSB6Jf4/7O
 UJr1RwEQ8ul1cN8hHGFNF4PuquPs9IGje/uHKtyQhTRGJEOYYO
 iXcjb8p1M646vDRIpBnK1SEUGvUMgFIUpsyg2njUl4+Gieis9N
 P39viVR7b6jRxC8A1R0ysbv9P/n1nUNLD46ez07/rok69A7Zrq
 lhNJTJUa5inTx1Rgdo9dQV2AEjoEdbKCs5exLUQe507B6OsvAO
 hZlyjQ6+TUJ9A==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Manjunath Goudar <manjunath.goudar@linaro.org>

Separate the SPEAr host controller driver from ehci-hcd host code
so that it can be built as a separate driver module.
This work is part of enabling multi-platform kernels on ARM;
however, note that other changes are still needed before SPEAr can be
booted with a multi-platform kernel, but they are queued in the
arm-soc tree for 3.10.

With the infrastructure added by Alan Stern in patch 3e0232039
"USB: EHCI: prepare to make ehci-hcd a library module", we can
avoid this problem by turning a bus glue into a separate
module, as we do here for the SPEAr bus glue.

In V4 (arnd):
 - renamed all 'struct spear_ehci' pointers from 'ehci' to the
   less ambiguous 'sehci'.
 - folded trivial spear_start_ehci/spear_stop_ehci functions into
   callers.
 - brought back initialization of ehci->caps.

In V3:
 - Detailed commit message added here about why this patch is required.
 - Eliminated ehci_spear_setup routine because hcd registers can
   be directly set in the spear_ehci_hcd_drv_probe function.
 - spear_overrides struct initialized.
 - Converted to using .extra_priv_size for allocating spear_ehci,
   and updated all users of that structure.
 - to_spear_ehci() macro modified for spear_ehci.

In V2:
 - Replaced spear as SPEAr everywhere, leaving functions/variables/config options.

Signed-off-by: Deepak Saxena <dsaxena@linaro.org>
Signed-off-by: Manjunath Goudar <manjunath.goudar@linaro.org>
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Acked-by: Viresh Kumar <viresh.linux@gmail.com>
Cc: Greg KH <greg@kroah.com>
Cc: Alan Stern <stern@rowland.harvard.edu>
Cc: Shiraz Hashim <shiraz.hashim@st.com>
Cc: linux-usb@vger.kernel.org
Cc: spear-devel@list.st.com
---
 drivers/usb/host/Kconfig      |   8 +++
 drivers/usb/host/Makefile     |   1 +
 drivers/usb/host/ehci-hcd.c   |   6 +--
 drivers/usb/host/ehci-spear.c | 115 +++++++++++++++++++-----------------------
 4 files changed, 61 insertions(+), 69 deletions(-)

diff --git a/drivers/usb/host/Kconfig b/drivers/usb/host/Kconfig
index e5649c1..4723f79 100644
--- a/drivers/usb/host/Kconfig
+++ b/drivers/usb/host/Kconfig
@@ -174,6 +174,14 @@ config USB_EHCI_HCD_ORION
 	  on Marvell's mobile PXA and MMP SoC, see "EHCI support for
 	  Marvell PXA/MMP USB controller" for those.
 
+config USB_EHCI_HCD_SPEAR
+        tristate "Support for ST SPEAr on-chip EHCI USB controller"
+        depends on USB_EHCI_HCD && PLAT_SPEAR
+        default y
+        ---help---
+          Enables support for the on-chip EHCI controller on
+          ST SPEAr chips.
+
 config USB_EHCI_MSM
 	bool "Support for MSM on-chip EHCI USB controller"
 	depends on USB_EHCI_HCD && ARCH_MSM
diff --git a/drivers/usb/host/Makefile b/drivers/usb/host/Makefile
index 9492f50..3e02471 100644
--- a/drivers/usb/host/Makefile
+++ b/drivers/usb/host/Makefile
@@ -29,6 +29,7 @@ obj-$(CONFIG_USB_EHCI_HCD_PLATFORM)	+= ehci-platform.o
 obj-$(CONFIG_USB_EHCI_MXC)	+= ehci-mxc.o
 obj-$(CONFIG_USB_EHCI_HCD_OMAP)	+= ehci-omap.o
 obj-$(CONFIG_USB_EHCI_HCD_ORION)	+= ehci-orion.o
+obj-$(CONFIG_USB_EHCI_HCD_SPEAR)	+= ehci-spear.o
 
 obj-$(CONFIG_USB_OXU210HP_HCD)	+= oxu210hp-hcd.o
 obj-$(CONFIG_USB_ISP116X_HCD)	+= isp116x-hcd.o
diff --git a/drivers/usb/host/ehci-hcd.c b/drivers/usb/host/ehci-hcd.c
index 1f97268..c8c70a1 100644
--- a/drivers/usb/host/ehci-hcd.c
+++ b/drivers/usb/host/ehci-hcd.c
@@ -1264,11 +1264,6 @@ MODULE_LICENSE ("GPL");
 #define PLATFORM_DRIVER		ehci_octeon_driver
 #endif
 
-#ifdef CONFIG_PLAT_SPEAR
-#include "ehci-spear.c"
-#define PLATFORM_DRIVER		spear_ehci_hcd_driver
-#endif
-
 #ifdef CONFIG_USB_EHCI_MSM
 #include "ehci-msm.c"
 #define PLATFORM_DRIVER		ehci_msm_driver
@@ -1315,6 +1310,7 @@ MODULE_LICENSE ("GPL");
 	!IS_ENABLED(CONFIG_USB_EHCI_MXC) && \
 	!IS_ENABLED(CONFIG_USB_EHCI_HCD_OMAP) && \
 	!IS_ENABLED(CONFIG_USB_EHCI_HCD_ORION) && \
+	!IS_ENABLED(CONFIG_USB_EHCI_HCD_SPEAR) && \
 	!defined(PLATFORM_DRIVER) && \
 	!defined(PS3_SYSTEM_BUS_DRIVER) && \
 	!defined(OF_PLATFORM_DRIVER) && \
diff --git a/drivers/usb/host/ehci-spear.c b/drivers/usb/host/ehci-spear.c
index 210bb67..61ecfb3 100644
--- a/drivers/usb/host/ehci-spear.c
+++ b/drivers/usb/host/ehci-spear.c
@@ -1,5 +1,5 @@
 /*
-* Driver for EHCI HCD on SPEAR SOC
+* Driver for EHCI HCD on SPEAr SOC
 *
 * Copyright (C) 2010 ST Micro Electronics,
 * Deepak Sikri <deepak.sikri@st.com>
@@ -12,71 +12,30 @@
 */
 
 #include <linux/clk.h>
+#include <linux/dma-mapping.h>
+#include <linux/io.h>
 #include <linux/jiffies.h>
+#include <linux/kernel.h>
+#include <linux/module.h>
 #include <linux/of.h>
 #include <linux/platform_device.h>
 #include <linux/pm.h>
+#include <linux/usb.h>
+#include <linux/usb/hcd.h>
 
-struct spear_ehci {
-	struct ehci_hcd ehci;
-	struct clk *clk;
-};
-
-#define to_spear_ehci(hcd)	(struct spear_ehci *)hcd_to_ehci(hcd)
+#include "ehci.h"
 
-static void spear_start_ehci(struct spear_ehci *ehci)
-{
-	clk_prepare_enable(ehci->clk);
-}
+#define DRIVER_DESC "EHCI SPEAr driver"
 
-static void spear_stop_ehci(struct spear_ehci *ehci)
-{
-	clk_disable_unprepare(ehci->clk);
-}
+static const char hcd_name[] = "SPEAr-ehci";
 
-static int ehci_spear_setup(struct usb_hcd *hcd)
-{
-	struct ehci_hcd *ehci = hcd_to_ehci(hcd);
-
-	/* registers start at offset 0x0 */
-	ehci->caps = hcd->regs;
+struct spear_ehci {
+	struct clk *clk;
+};
 
-	return ehci_setup(hcd);
-}
+#define to_spear_ehci(hcd)	(struct spear_ehci *)(hcd_to_ehci(hcd)->priv)
 
-static const struct hc_driver ehci_spear_hc_driver = {
-	.description			= hcd_name,
-	.product_desc			= "SPEAr EHCI",
-	.hcd_priv_size			= sizeof(struct spear_ehci),
-
-	/* generic hardware linkage */
-	.irq				= ehci_irq,
-	.flags				= HCD_MEMORY | HCD_USB2,
-
-	/* basic lifecycle operations */
-	.reset				= ehci_spear_setup,
-	.start				= ehci_run,
-	.stop				= ehci_stop,
-	.shutdown			= ehci_shutdown,
-
-	/* managing i/o requests and associated device resources */
-	.urb_enqueue			= ehci_urb_enqueue,
-	.urb_dequeue			= ehci_urb_dequeue,
-	.endpoint_disable		= ehci_endpoint_disable,
-	.endpoint_reset			= ehci_endpoint_reset,
-
-	/* scheduling support */
-	.get_frame_number		= ehci_get_frame,
-
-	/* root hub support */
-	.hub_status_data		= ehci_hub_status_data,
-	.hub_control			= ehci_hub_control,
-	.bus_suspend			= ehci_bus_suspend,
-	.bus_resume			= ehci_bus_resume,
-	.relinquish_port		= ehci_relinquish_port,
-	.port_handed_over		= ehci_port_handed_over,
-	.clear_tt_buffer_complete	= ehci_clear_tt_buffer_complete,
-};
+static struct hc_driver __read_mostly ehci_spear_hc_driver;
 
 #ifdef CONFIG_PM_SLEEP
 static int ehci_spear_drv_suspend(struct device *dev)
@@ -104,7 +63,7 @@ static u64 spear_ehci_dma_mask = DMA_BIT_MASK(32);
 static int spear_ehci_hcd_drv_probe(struct platform_device *pdev)
 {
 	struct usb_hcd *hcd ;
-	struct spear_ehci *ehci;
+	struct spear_ehci *sehci;
 	struct resource *res;
 	struct clk *usbh_clk;
 	const struct hc_driver *driver = &ehci_spear_hc_driver;
@@ -161,10 +120,13 @@ static int spear_ehci_hcd_drv_probe(struct platform_device *pdev)
 		goto err_put_hcd;
 	}
 
-	ehci = (struct spear_ehci *)hcd_to_ehci(hcd);
-	ehci->clk = usbh_clk;
+	sehci = to_spear_ehci(hcd);
+	sehci->clk = usbh_clk;
+
+	/* registers start at offset 0x0 */
+	hcd_to_ehci(hcd)->caps = hcd->regs;
 
-	spear_start_ehci(ehci);
+	clk_prepare_enable(sehci->clk);
 	retval = usb_add_hcd(hcd, irq, IRQF_SHARED);
 	if (retval)
 		goto err_stop_ehci;
@@ -172,7 +134,7 @@ static int spear_ehci_hcd_drv_probe(struct platform_device *pdev)
 	return retval;
 
 err_stop_ehci:
-	spear_stop_ehci(ehci);
+	clk_disable_unprepare(sehci->clk);
 err_put_hcd:
 	usb_put_hcd(hcd);
 fail:
@@ -184,7 +146,7 @@ fail:
 static int spear_ehci_hcd_drv_remove(struct platform_device *pdev)
 {
 	struct usb_hcd *hcd = platform_get_drvdata(pdev);
-	struct spear_ehci *ehci_p = to_spear_ehci(hcd);
+	struct spear_ehci *sehci = to_spear_ehci(hcd);
 
 	if (!hcd)
 		return 0;
@@ -192,8 +154,8 @@ static int spear_ehci_hcd_drv_remove(struct platform_device *pdev)
 		BUG();
 	usb_remove_hcd(hcd);
 
-	if (ehci_p->clk)
-		spear_stop_ehci(ehci_p);
+	if (sehci->clk)
+		clk_disable_unprepare(sehci->clk);
 	usb_put_hcd(hcd);
 
 	return 0;
@@ -216,4 +178,29 @@ static struct platform_driver spear_ehci_hcd_driver = {
 	}
 };
 
+static const struct ehci_driver_overrides spear_overrides __initdata = {
+	.extra_priv_size = sizeof(struct spear_ehci),
+};
+
+static int __init ehci_spear_init(void)
+{
+	if (usb_disabled())
+		return -ENODEV;
+
+	pr_info("%s: " DRIVER_DESC "\n", hcd_name);
+
+	ehci_init_driver(&ehci_spear_hc_driver, &spear_overrides);
+	return platform_driver_register(&spear_ehci_hcd_driver);
+}
+module_init(ehci_spear_init);
+
+static void __exit ehci_spear_cleanup(void)
+{
+	platform_driver_unregister(&spear_ehci_hcd_driver);
+}
+module_exit(ehci_spear_cleanup);
+
+MODULE_DESCRIPTION(DRIVER_DESC);
 MODULE_ALIAS("platform:spear-ehci");
+MODULE_AUTHOR("Deepak Sikri");
+MODULE_LICENSE("GPL");
-- 
1.8.1.2

