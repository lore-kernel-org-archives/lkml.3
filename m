Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761029Ab3BJS7f (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Feb 2013 13:59:35 -0500
Received: from mail-pb0-f42.google.com ([209.85.160.42]:49709 "EHLO
	mail-pb0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760872Ab3BJS7c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Feb 2013 13:59:32 -0500
From: manjunath.goudar@linaro.org
To: linux-usb@vger.kernel.org
Cc: linux-arm-kernel@lists.infradead.org, patches@linaro.org,
        stern@rowland.harvard.edu, arnd@linaro.org, gregkh@linuxfoundation.org,
        Manjunath Goudar <manjunath.goudar@linaro.org>,
        Greg KH <greg@kroah.com>, David Brown <davidb@codeaurora.org>,
        Daniel Walker <dwalker@fifo99.com>,
        Bryan Huntsman <bryanh@codeaurora.org>,
        Brian Swetland <swetland@google.com>, linux-kernel@vger.kernel.org
Subject: [PATCH 6/8] USB: EHCI: make ehci-msm a separate driver
Date: Mon, 11 Feb 2013 00:28:15 +0530
Message-Id: <5117ee12.860e440a.097c.3521@mx.google.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1360522697-22902-1-git-send-email-y>
References: <y>
 <1360522697-22902-1-git-send-email-y>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Manjunath Goudar <manjunath.goudar@linaro.org>

Separate the Qualcomm On-Chip host controller driver from ehci-hcd host code
into its own driver module.

Signed-off-by: Manjunath Goudar <manjunath.goudar@linaro.org>
Cc: Greg KH <greg@kroah.com>
Cc: Alan Stern <stern@rowland.harvard.edu>
Cc: David Brown <davidb@codeaurora.org>
Cc: Daniel Walker <dwalker@fifo99.com>
Cc: Bryan Huntsman <bryanh@codeaurora.org>
Cc: Brian Swetland <swetland@google.com>
Cc: linux-usb@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
---
 drivers/usb/host/Kconfig    |    4 +-
 drivers/usb/host/Makefile   |    1 +
 drivers/usb/host/ehci-hcd.c |    7 +---
 drivers/usb/host/ehci-msm.c |   85 +++++++++++++++++++------------------------
 4 files changed, 42 insertions(+), 55 deletions(-)

diff --git a/drivers/usb/host/Kconfig b/drivers/usb/host/Kconfig
index 4e15b87..751290d 100644
--- a/drivers/usb/host/Kconfig
+++ b/drivers/usb/host/Kconfig
@@ -187,7 +187,7 @@ config USB_EHCI_HCD_AT91
           Atmel chips.
 
 config USB_EHCI_MSM
-	bool "Support for MSM on-chip EHCI USB controller"
+	tristate "Support for MSM on-chip EHCI USB controller"
 	depends on USB_EHCI_HCD && ARCH_MSM
 	select USB_EHCI_ROOT_HUB_TT
 	select USB_MSM_OTG
@@ -203,7 +203,7 @@ config USB_EHCI_TEGRA
        boolean "NVIDIA Tegra HCD support"
        depends on USB_EHCI_HCD && ARCH_TEGRA
        select USB_EHCI_ROOT_HUB_TT
-       help
+      --- help---
          This driver enables support for the internal USB Host Controllers
          found in NVIDIA Tegra SoCs. The controllers are EHCI compliant.
 
diff --git a/drivers/usb/host/Makefile b/drivers/usb/host/Makefile
index 1fe0579..75d98b9 100644
--- a/drivers/usb/host/Makefile
+++ b/drivers/usb/host/Makefile
@@ -33,6 +33,7 @@ obj-$(CONFIG_USB_EHCI_HCD_AT91) += ehci-atmel.o
 obj-$(CONFIG_USB_EHCI_S5P)      += ehci-s5p.o
 obj-$(CONFIG_USB_EHCI_MV)       += ehci-mv.o
 obj-$(CONFIG_USB_EHCI_HCD_VT8500)+= ehci-vt8500.o
+obj-$(CONFIG_USB_EHCI_MSM)      += ehci-msm.o
 obj-$(CONFIG_USB_ISP116X_HCD)	+= isp116x-hcd.o
 obj-$(CONFIG_USB_ISP1362_HCD)	+= isp1362-hcd.o
 obj-$(CONFIG_USB_OHCI_HCD)	+= ohci-hcd.o
diff --git a/drivers/usb/host/ehci-hcd.c b/drivers/usb/host/ehci-hcd.c
index 3dacac0..db5f0ce 100644
--- a/drivers/usb/host/ehci-hcd.c
+++ b/drivers/usb/host/ehci-hcd.c
@@ -1287,11 +1287,6 @@ MODULE_LICENSE ("GPL");
 #define PLATFORM_DRIVER		ehci_octeon_driver
 #endif
 
-#ifdef CONFIG_USB_EHCI_MSM
-#include "ehci-msm.c"
-#define PLATFORM_DRIVER		ehci_msm_driver
-#endif
-
 #ifdef CONFIG_TILE_USB
 #include "ehci-tilegx.c"
 #define	PLATFORM_DRIVER		ehci_hcd_tilegx_driver
@@ -1326,6 +1321,8 @@ MODULE_LICENSE ("GPL");
 	!IS_ENABLED(CONFIG_ARCH_AT91) && \
 	!IS_ENABLED(CONFIG_USB_EHCI_S5P) && \
 	!IS_ENABLED(CONFIG_USB_EHCI_MV) && \
+	!IS_ENABLED(CONFIG_ARCH_VT8500) && \
+	!IS_ENABLED(CONFIG_USB_EHCI_MSM) && \
 	!defined(PS3_SYSTEM_BUS_DRIVER) && \
 	!defined(OF_PLATFORM_DRIVER) && \
 	!defined(XILINX_OF_PLATFORM_DRIVER)
diff --git a/drivers/usb/host/ehci-msm.c b/drivers/usb/host/ehci-msm.c
index 88a49c8..a9a0357 100644
--- a/drivers/usb/host/ehci-msm.c
+++ b/drivers/usb/host/ehci-msm.c
@@ -26,12 +26,22 @@
 #include <linux/clk.h>
 #include <linux/err.h>
 #include <linux/pm_runtime.h>
-
 #include <linux/usb/otg.h>
 #include <linux/usb/msm_hsusb_hw.h>
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/usb.h>
+#include <linux/usb/hcd.h>
+#include <linux/io.h>
+
+#include "ehci.h"
 
 #define MSM_USB_BASE (hcd->regs)
 
+#define DRIVER_DESC "Qualcomm On-Chip EHCI Host Controller"
+
+static const char hcd_name[] = "msm_hsusb_host";
+static struct hc_driver __read_mostly msm_hc_driver;
 static struct usb_phy *phy;
 
 static int ehci_msm_reset(struct usb_hcd *hcd)
@@ -56,52 +66,6 @@ static int ehci_msm_reset(struct usb_hcd *hcd)
 	return 0;
 }
 
-static struct hc_driver msm_hc_driver = {
-	.description		= hcd_name,
-	.product_desc		= "Qualcomm On-Chip EHCI Host Controller",
-	.hcd_priv_size		= sizeof(struct ehci_hcd),
-
-	/*
-	 * generic hardware linkage
-	 */
-	.irq			= ehci_irq,
-	.flags			= HCD_USB2 | HCD_MEMORY,
-
-	.reset			= ehci_msm_reset,
-	.start			= ehci_run,
-
-	.stop			= ehci_stop,
-	.shutdown		= ehci_shutdown,
-
-	/*
-	 * managing i/o requests and associated device resources
-	 */
-	.urb_enqueue		= ehci_urb_enqueue,
-	.urb_dequeue		= ehci_urb_dequeue,
-	.endpoint_disable	= ehci_endpoint_disable,
-	.endpoint_reset		= ehci_endpoint_reset,
-	.clear_tt_buffer_complete = ehci_clear_tt_buffer_complete,
-
-	/*
-	 * scheduling support
-	 */
-	.get_frame_number	= ehci_get_frame,
-
-	/*
-	 * root hub support
-	 */
-	.hub_status_data	= ehci_hub_status_data,
-	.hub_control		= ehci_hub_control,
-	.relinquish_port	= ehci_relinquish_port,
-	.port_handed_over	= ehci_port_handed_over,
-
-	/*
-	 * PM support
-	 */
-	.bus_suspend		= ehci_bus_suspend,
-	.bus_resume		= ehci_bus_resume,
-};
-
 static int ehci_msm_probe(struct platform_device *pdev)
 {
 	struct usb_hcd *hcd;
@@ -222,7 +186,32 @@ static struct platform_driver ehci_msm_driver = {
 	.probe	= ehci_msm_probe,
 	.remove	= ehci_msm_remove,
 	.driver = {
-		   .name = "msm_hsusb_host",
+		   .name = hcd_name,
 		   .pm = &ehci_msm_dev_pm_ops,
 	},
 };
+
+static const struct ehci_driver_overrides msm_overrides __initdata = {
+	.reset = ehci_msm_reset,
+};
+
+static int __init ehci_msm_init(void)
+{
+	if (usb_disabled())
+		return -ENODEV;
+
+	pr_info("%s: " DRIVER_DESC "\n", hcd_name);
+	ehci_init_driver(&msm_hc_driver, &msm_overrides);
+	return platform_driver_register(&ehci_msm_driver);
+}
+module_init(ehci_msm_init);
+
+static void __exit ehci_msm_cleanup(void)
+{
+	platform_driver_unregister(&ehci_msm_driver);
+}
+module_exit(ehci_msm_cleanup);
+
+MODULE_DESCRIPTION(DRIVER_DESC);
+MODULE_ALIAS("platform:msm-ehci");
+MODULE_LICENSE("GPL");
-- 
1.7.9.5

