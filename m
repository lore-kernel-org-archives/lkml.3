Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760854Ab3BJS7T (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Feb 2013 13:59:19 -0500
Received: from mail-pb0-f46.google.com ([209.85.160.46]:50657 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759393Ab3BJS7Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Feb 2013 13:59:16 -0500
From: manjunath.goudar@linaro.org
To: linux-usb@vger.kernel.org
Cc: linux-arm-kernel@lists.infradead.org, patches@linaro.org,
        stern@rowland.harvard.edu, arnd@linaro.org, gregkh@linuxfoundation.org,
        Manjunath Goudar <manjunath.goudar@linaro.org>,
        Greg KH <greg@kroah.com>, Jason Cooper <jason@lakedaemon.net>,
        Andrew Lunn <andrew@lunn.ch>, linux-kernel@vger.kernel.org
Subject: [PATCH 4/8] USB: EHCI: make ehci-mv a separate driver
Date: Mon, 11 Feb 2013 00:28:13 +0530
Message-Id: <5117ee03.860e440a.097c.3519@mx.google.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1360522697-22902-1-git-send-email-y>
References: <y>
 <1360522697-22902-1-git-send-email-y>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Manjunath Goudar <manjunath.goudar@linaro.org>

Separate the mv(marvell) host controller driver from ehci-hcd host code
into its own driver module.

Signed-off-by: Manjunath Goudar <manjunath.goudar@linaro.org>
Cc: Greg KH <greg@kroah.com>
Cc: Alan Stern <stern@rowland.harvard.edu>
Cc: Jason Cooper <jason@lakedaemon.net>
Cc: Andrew Lunn <andrew@lunn.ch>
Cc: linux-usb@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
---
 drivers/usb/host/Kconfig    |    2 +-
 drivers/usb/host/Makefile   |    1 +
 drivers/usb/host/ehci-hcd.c |    6 +---
 drivers/usb/host/ehci-mv.c  |   80 ++++++++++++++++++++-----------------------
 4 files changed, 40 insertions(+), 49 deletions(-)

diff --git a/drivers/usb/host/Kconfig b/drivers/usb/host/Kconfig
index 8ffbafa..2aa4ece 100644
--- a/drivers/usb/host/Kconfig
+++ b/drivers/usb/host/Kconfig
@@ -221,7 +221,7 @@ config USB_EHCI_S5P
 	 Enable support for the S5P SOC's on-chip EHCI controller.
 
 config USB_EHCI_MV
-	bool "EHCI support for Marvell on-chip controller"
+	tristate "EHCI support for Marvell on-chip controller"
 	depends on USB_EHCI_HCD && (ARCH_PXA || ARCH_MMP)
 	select USB_EHCI_ROOT_HUB_TT
 	---help---
diff --git a/drivers/usb/host/Makefile b/drivers/usb/host/Makefile
index 77e0331..d593017 100644
--- a/drivers/usb/host/Makefile
+++ b/drivers/usb/host/Makefile
@@ -31,6 +31,7 @@ obj-$(CONFIG_USB_EHCI_HCD_SPEAR)+= ehci-spear.o
 obj-$(CONFIG_USB_OXU210HP_HCD)	+= oxu210hp-hcd.o
 obj-$(CONFIG_USB_EHCI_HCD_AT91) += ehci-atmel.o
 obj-$(CONFIG_USB_EHCI_S5P)      += ehci-s5p.o
+obj-$(CONFIG_USB_EHCI_MV)       += ehci-mv.o
 obj-$(CONFIG_USB_ISP116X_HCD)	+= isp116x-hcd.o
 obj-$(CONFIG_USB_ISP1362_HCD)	+= isp1362-hcd.o
 obj-$(CONFIG_USB_OHCI_HCD)	+= ohci-hcd.o
diff --git a/drivers/usb/host/ehci-hcd.c b/drivers/usb/host/ehci-hcd.c
index 22c50fb..d133f6d 100644
--- a/drivers/usb/host/ehci-hcd.c
+++ b/drivers/usb/host/ehci-hcd.c
@@ -1317,11 +1317,6 @@ MODULE_LICENSE ("GPL");
 #define PLATFORM_DRIVER		ehci_grlib_driver
 #endif
 
-#ifdef CONFIG_USB_EHCI_MV
-#include "ehci-mv.c"
-#define        PLATFORM_DRIVER         ehci_mv_driver
-#endif
-
 #ifdef CONFIG_MIPS_SEAD3
 #include "ehci-sead3.c"
 #define	PLATFORM_DRIVER		ehci_hcd_sead3_driver
@@ -1335,6 +1330,7 @@ MODULE_LICENSE ("GPL");
 	!IS_ENABLED(CONFIG_PLAT_SPEAR) && \
 	!IS_ENABLED(CONFIG_ARCH_AT91) && \
 	!IS_ENABLED(CONFIG_USB_EHCI_S5P) && \
+	!IS_ENABLED(CONFIG_USB_EHCI_MV) && \
 	!defined(PS3_SYSTEM_BUS_DRIVER) && \
 	!defined(OF_PLATFORM_DRIVER) && \
 	!defined(XILINX_OF_PLATFORM_DRIVER)
diff --git a/drivers/usb/host/ehci-mv.c b/drivers/usb/host/ehci-mv.c
index 3065809..67de419 100644
--- a/drivers/usb/host/ehci-mv.c
+++ b/drivers/usb/host/ehci-mv.c
@@ -17,7 +17,18 @@
 #include <linux/usb/otg.h>
 #include <linux/platform_data/mv_usb.h>
 
+#include <linux/usb.h>
+#include <linux/usb/hcd.h>
+#include <linux/io.h>
+#include <linux/dma-mapping.h>
+
+#include "ehci.h"
+
+#define DRIVER_DESC "EHCI mv driver"
+
 #define CAPLENGTH_MASK         (0xff)
+static const char hcd_name[] = "ehci-mv";
+static struct hc_driver __read_mostly mv_ehci_hc_driver;
 
 struct ehci_hcd_mv {
 	struct usb_hcd *hcd;
@@ -95,48 +106,6 @@ static int mv_ehci_reset(struct usb_hcd *hcd)
 	return retval;
 }
 
-static const struct hc_driver mv_ehci_hc_driver = {
-	.description = hcd_name,
-	.product_desc = "Marvell EHCI",
-	.hcd_priv_size = sizeof(struct ehci_hcd),
-
-	/*
-	 * generic hardware linkage
-	 */
-	.irq = ehci_irq,
-	.flags = HCD_MEMORY | HCD_USB2,
-
-	/*
-	 * basic lifecycle operations
-	 */
-	.reset = mv_ehci_reset,
-	.start = ehci_run,
-	.stop = ehci_stop,
-	.shutdown = ehci_shutdown,
-
-	/*
-	 * managing i/o requests and associated device resources
-	 */
-	.urb_enqueue = ehci_urb_enqueue,
-	.urb_dequeue = ehci_urb_dequeue,
-	.endpoint_disable = ehci_endpoint_disable,
-	.endpoint_reset = ehci_endpoint_reset,
-	.clear_tt_buffer_complete = ehci_clear_tt_buffer_complete,
-
-	/*
-	 * scheduling support
-	 */
-	.get_frame_number = ehci_get_frame,
-
-	/*
-	 * root hub support
-	 */
-	.hub_status_data = ehci_hub_status_data,
-	.hub_control = ehci_hub_control,
-	.bus_suspend = ehci_bus_suspend,
-	.bus_resume = ehci_bus_resume,
-};
-
 static int mv_ehci_probe(struct platform_device *pdev)
 {
 	struct mv_usb_platform_data *pdata = pdev->dev.platform_data;
@@ -350,8 +319,33 @@ static struct platform_driver ehci_mv_driver = {
 	.remove = mv_ehci_remove,
 	.shutdown = mv_ehci_shutdown,
 	.driver = {
-		   .name = "mv-ehci",
+		   .name = hcd_name,
 		   .bus = &platform_bus_type,
 		   },
 	.id_table = ehci_id_table,
 };
+static const struct ehci_driver_overrides mv_overrides __initdata = {
+	.reset = mv_ehci_reset,
+};
+
+static int __init ehci_mv_init(void)
+{
+	if (usb_disabled())
+		return -ENODEV;
+
+	pr_info("%s: " DRIVER_DESC "\n", hcd_name);
+	ehci_init_driver(&mv_ehci_hc_driver, &mv_overrides);
+	return platform_driver_register(&ehci_mv_driver);
+}
+module_init(ehci_mv_init);
+
+static void __exit ehci_mv_cleanup(void)
+{
+	platform_driver_unregister(&ehci_mv_driver);
+}
+module_exit(ehci_mv_cleanup);
+
+MODULE_DESCRIPTION(DRIVER_DESC);
+MODULE_ALIAS("platform:ehci-mv");
+MODULE_AUTHOR("Marvell");
+MODULE_LICENSE("GPL");
-- 
1.7.9.5

