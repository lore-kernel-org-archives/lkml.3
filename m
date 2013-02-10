Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760968Ab3BJS71 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Feb 2013 13:59:27 -0500
Received: from mail-pb0-f45.google.com ([209.85.160.45]:58783 "EHLO
	mail-pb0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760872Ab3BJS7Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Feb 2013 13:59:24 -0500
From: manjunath.goudar@linaro.org
To: linux-usb@vger.kernel.org
Cc: linux-arm-kernel@lists.infradead.org, patches@linaro.org,
        stern@rowland.harvard.edu, arnd@linaro.org, gregkh@linuxfoundation.org,
        Manjunath Goudar <manjunath.goudar@linaro.org>,
        Greg KH <greg@kroah.com>, Tony Prisk <linux@prisktech.co.nz>,
        Alexey Charkov <alchark@gmail.com>, linux-kernel@vger.kernel.org
Subject: [PATCH 5/8] USB: EHCI: make ehci-vt8500 a separate driver
Date: Mon, 11 Feb 2013 00:28:14 +0530
Message-Id: <5117ee0a.860e440a.097c.351c@mx.google.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1360522697-22902-1-git-send-email-y>
References: <y>
 <1360522697-22902-1-git-send-email-y>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Manjunath Goudar <manjunath.goudar@linaro.org>

Separate the vt8500 host controller driver from ehci-hcd host code
into its own driver module.

Signed-off-by: Manjunath Goudar <manjunath.goudar@linaro.org>
Cc: Greg KH <greg@kroah.com>
Cc: Alan Stern <stern@rowland.harvard.edu>
Cc: Tony Prisk <linux@prisktech.co.nz>
Cc: Alexey Charkov <alchark@gmail.com>
Cc: linux-usb@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
---
 drivers/usb/host/Kconfig       |    8 +++++
 drivers/usb/host/Makefile      |    1 +
 drivers/usb/host/ehci-hcd.c    |    5 ---
 drivers/usb/host/ehci-vt8500.c |   73 ++++++++++++++++++----------------------
 4 files changed, 42 insertions(+), 45 deletions(-)

diff --git a/drivers/usb/host/Kconfig b/drivers/usb/host/Kconfig
index 2aa4ece..4e15b87 100644
--- a/drivers/usb/host/Kconfig
+++ b/drivers/usb/host/Kconfig
@@ -162,6 +162,14 @@ config USB_EHCI_HCD_OMAP
 	  Enables support for the on-chip EHCI controller on
 	  OMAP3 and later chips.
 
+config USB_EHCI_HCD_VT8500
+        tristate "Support for VT8500 on-chip EHCI USB controller"
+        depends on USB_EHCI_HCD && ARCH_VT8500
+        default y
+        ---help---
+          Enables support for the on-chip EHCI controller on
+          VT8500 chips.
+
 config USB_EHCI_HCD_SPEAR
         tristate "Support for ST SPEAr on-chip EHCI USB controller"
         depends on USB_EHCI_HCD && PLAT_SPEAR
diff --git a/drivers/usb/host/Makefile b/drivers/usb/host/Makefile
index d593017..1fe0579 100644
--- a/drivers/usb/host/Makefile
+++ b/drivers/usb/host/Makefile
@@ -32,6 +32,7 @@ obj-$(CONFIG_USB_OXU210HP_HCD)	+= oxu210hp-hcd.o
 obj-$(CONFIG_USB_EHCI_HCD_AT91) += ehci-atmel.o
 obj-$(CONFIG_USB_EHCI_S5P)      += ehci-s5p.o
 obj-$(CONFIG_USB_EHCI_MV)       += ehci-mv.o
+obj-$(CONFIG_USB_EHCI_HCD_VT8500)+= ehci-vt8500.o
 obj-$(CONFIG_USB_ISP116X_HCD)	+= isp116x-hcd.o
 obj-$(CONFIG_USB_ISP1362_HCD)	+= isp1362-hcd.o
 obj-$(CONFIG_USB_OHCI_HCD)	+= ohci-hcd.o
diff --git a/drivers/usb/host/ehci-hcd.c b/drivers/usb/host/ehci-hcd.c
index d133f6d..3dacac0 100644
--- a/drivers/usb/host/ehci-hcd.c
+++ b/drivers/usb/host/ehci-hcd.c
@@ -1287,11 +1287,6 @@ MODULE_LICENSE ("GPL");
 #define PLATFORM_DRIVER		ehci_octeon_driver
 #endif
 
-#ifdef CONFIG_ARCH_VT8500
-#include "ehci-vt8500.c"
-#define	PLATFORM_DRIVER		vt8500_ehci_driver
-#endif
-
 #ifdef CONFIG_USB_EHCI_MSM
 #include "ehci-msm.c"
 #define PLATFORM_DRIVER		ehci_msm_driver
diff --git a/drivers/usb/host/ehci-vt8500.c b/drivers/usb/host/ehci-vt8500.c
index 11695d5..98d65bd 100644
--- a/drivers/usb/host/ehci-vt8500.c
+++ b/drivers/usb/host/ehci-vt8500.c
@@ -16,52 +16,25 @@
  *
  */
 
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/usb.h>
+#include <linux/usb/hcd.h>
+#include <linux/io.h>
+#include <linux/dma-mapping.h>
 #include <linux/of.h>
 #include <linux/platform_device.h>
 
-static const struct hc_driver vt8500_ehci_hc_driver = {
-	.description		= hcd_name,
-	.product_desc		= "VT8500 EHCI",
-	.hcd_priv_size		= sizeof(struct ehci_hcd),
+#include "ehci.h"
 
-	/*
-	 * generic hardware linkage
-	 */
-	.irq			= ehci_irq,
-	.flags			= HCD_MEMORY | HCD_USB2,
-
-	/*
-	 * basic lifecycle operations
-	 */
-	.reset			= ehci_setup,
-	.start			= ehci_run,
-	.stop			= ehci_stop,
-	.shutdown		= ehci_shutdown,
+#define DRIVER_DESC "vt8500 On-Chip EHCI Host driver"
 
-	/*
-	 * managing i/o requests and associated device resources
-	 */
-	.urb_enqueue		= ehci_urb_enqueue,
-	.urb_dequeue		= ehci_urb_dequeue,
-	.endpoint_disable	= ehci_endpoint_disable,
-	.endpoint_reset		= ehci_endpoint_reset,
+static const char hcd_name[] = "ehci-vt8500";
 
-	/*
-	 * scheduling support
-	 */
-	.get_frame_number	= ehci_get_frame,
+static struct hc_driver __read_mostly vt8500_ehci_hc_driver;
 
-	/*
-	 * root hub support
-	 */
-	.hub_status_data	= ehci_hub_status_data,
-	.hub_control		= ehci_hub_control,
-	.bus_suspend		= ehci_bus_suspend,
-	.bus_resume		= ehci_bus_resume,
-	.relinquish_port	= ehci_relinquish_port,
-	.port_handed_over	= ehci_port_handed_over,
-
-	.clear_tt_buffer_complete	= ehci_clear_tt_buffer_complete,
+static const struct ehci_driver_overrides ehci_vt8500_overrides __initdata = {
+	.reset = ehci_setup,
 };
 
 static u64 vt8500_ehci_dma_mask = DMA_BIT_MASK(32);
@@ -140,11 +113,31 @@ static struct platform_driver vt8500_ehci_driver = {
 	.remove		= vt8500_ehci_drv_remove,
 	.shutdown	= usb_hcd_platform_shutdown,
 	.driver = {
-		.name	= "vt8500-ehci",
+		.name	= hcd_name,
 		.owner	= THIS_MODULE,
 		.of_match_table = of_match_ptr(vt8500_ehci_ids),
 	}
 };
 
+static int __init ehci_vt8500_init(void)
+{
+	if (usb_disabled())
+		return -ENODEV;
+
+	pr_info("%s: " DRIVER_DESC "\n", hcd_name);
+	ehci_init_driver(&vt8500_ehci_hc_driver, &ehci_vt8500_overrides);
+	return platform_driver_register(&vt8500_ehci_driver);
+}
+module_init(ehci_vt8500_init);
+
+static void __exit ehci_vt8500_cleanup(void)
+{
+	platform_driver_unregister(&vt8500_ehci_driver);
+}
+module_exit(ehci_vt8500_cleanup);
+
+MODULE_DESCRIPTION(DRIVER_DESC);
+MODULE_AUTHOR("Alexey Charkov");
+MODULE_LICENSE("GPL v2");
 MODULE_ALIAS("platform:vt8500-ehci");
 MODULE_DEVICE_TABLE(of, vt8500_ehci_ids);
-- 
1.7.9.5

