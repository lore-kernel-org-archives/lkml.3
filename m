Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932261Ab3BGRg7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Feb 2013 12:36:59 -0500
Received: from mail-da0-f41.google.com ([209.85.210.41]:63498 "EHLO
	mail-da0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932193Ab3BGRg5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Feb 2013 12:36:57 -0500
From: manjunath.goudar@linaro.org
To: linux-usb@vger.kernel.org
Cc: linux-arm-kernel@lists.infradead.org, patches@linaro.org,
        stern@rowland.harvard.edu, arnd@linaro.org, gregkh@linuxfoundation.org,
        Manjunath Goudar <manjunath.goudar@linaro.org>,
        Greg KH <greg@kroah.com>, Wan ZongShun <mcuos.com@gmail.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 10/10] USB: EHCI: make ehci-w90X900 a separate driver
Date: Thu,  7 Feb 2013 23:04:07 +0530
Message-Id: <5113e637.c84e420a.08c3.ffffbf20@mx.google.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1360258447-27247-1-git-send-email-yes>
References: <yes>
 <1360258447-27247-1-git-send-email-yes>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Manjunath Goudar <manjunath.goudar@linaro.org>

Separate the Nuvoton On-Chip host controller driver from ehci-hcd host code
into its own driver module.

Signed-off-by: Manjunath Goudar <manjunath.goudar@linaro.org>
Cc: Greg KH <greg@kroah.com>
Cc: Alan Stern <stern@rowland.harvard.edu>
Cc: Wan ZongShun <mcuos.com@gmail.com>
Cc: linux-usb@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
---
 drivers/usb/host/Kconfig        |    2 +-
 drivers/usb/host/Makefile       |    1 +
 drivers/usb/host/ehci-hcd.c     |    6 +--
 drivers/usb/host/ehci-w90x900.c |   90 +++++++++++++++++----------------------
 4 files changed, 43 insertions(+), 56 deletions(-)

diff --git a/drivers/usb/host/Kconfig b/drivers/usb/host/Kconfig
index 8d18a6c..1b5e30b 100644
--- a/drivers/usb/host/Kconfig
+++ b/drivers/usb/host/Kconfig
@@ -245,7 +245,7 @@ config USB_EHCI_MV
 	  only be EHCI host. OTG is controller that can switch to host mode.
 
 config USB_W90X900_EHCI
-	bool "W90X900(W90P910) EHCI support"
+	 tristate "W90X900(W90P910) EHCI support"
 	depends on USB_EHCI_HCD && ARCH_W90X900
 	---help---
 		Enables support for the W90X900 USB controller
diff --git a/drivers/usb/host/Makefile b/drivers/usb/host/Makefile
index 6c1d0e0..74db4d4 100644
--- a/drivers/usb/host/Makefile
+++ b/drivers/usb/host/Makefile
@@ -36,6 +36,7 @@ obj-$(CONFIG_USB_EHCI_S5P)      += ehci-s5p.o
 obj-$(CONFIG_USB_EHCI_MV)       += ehci-mv.o
 obj-$(CONFIG_USB_EHCI_HCD_VT8500)+= ehci-vt8500.o
 obj-$(CONFIG_USB_EHCI_MSM)      += ehci-msm.o
+obj-$(CONFIG_USB_W90X900_EHCI)  += ehci-w90x900.o
 obj-$(CONFIG_USB_ISP116X_HCD)	+= isp116x-hcd.o
 obj-$(CONFIG_USB_ISP1362_HCD)	+= isp1362-hcd.o
 obj-$(CONFIG_USB_OHCI_HCD)	+= ohci-hcd.o
diff --git a/drivers/usb/host/ehci-hcd.c b/drivers/usb/host/ehci-hcd.c
index d44115b..84ed7d7 100644
--- a/drivers/usb/host/ehci-hcd.c
+++ b/drivers/usb/host/ehci-hcd.c
@@ -1267,11 +1267,6 @@ MODULE_LICENSE ("GPL");
 #define XILINX_OF_PLATFORM_DRIVER	ehci_hcd_xilinx_of_driver
 #endif
 
-#ifdef CONFIG_USB_W90X900_EHCI
-#include "ehci-w90x900.c"
-#define	PLATFORM_DRIVER		ehci_hcd_w90x900_driver
-#endif
-
 #ifdef CONFIG_USB_OCTEON_EHCI
 #include "ehci-octeon.c"
 #define PLATFORM_DRIVER		ehci_octeon_driver
@@ -1314,6 +1309,7 @@ MODULE_LICENSE ("GPL");
 	!IS_ENABLED(CONFIG_USB_EHCI_MV) && \
 	!IS_ENABLED(CONFIG_ARCH_VT8500) && \
 	!IS_ENABLED(CONFIG_USB_EHCI_MSM) && \
+	!IS_ENABLED(CONFIG_USB_W90X900_EHCI) && \
 	!defined(PS3_SYSTEM_BUS_DRIVER) && \
 	!defined(OF_PLATFORM_DRIVER) && \
 	!defined(XILINX_OF_PLATFORM_DRIVER)
diff --git a/drivers/usb/host/ehci-w90x900.c b/drivers/usb/host/ehci-w90x900.c
index 59e0e24..0b677ec 100644
--- a/drivers/usb/host/ehci-w90x900.c
+++ b/drivers/usb/host/ehci-w90x900.c
@@ -13,11 +13,31 @@
 
 #include <linux/platform_device.h>
 
+#include <linux/dma-mapping.h>
+#include <linux/of.h>
+#include <linux/platform_device.h>
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/usb.h>
+#include <linux/usb/hcd.h>
+#include <linux/io.h>
+#include "ehci.h"
+
 /* enable phy0 and phy1 for w90p910 */
 #define	ENPHY		(0x01<<8)
 #define PHY0_CTR	(0xA4)
 #define PHY1_CTR	(0xA8)
 
+#define DRIVER_DESC "Nuvoton w90x900 On-Chip EHCI Host driver"
+
+static const char hcd_name[] = "ehci-w90x900";
+
+static struct hc_driver __read_mostly ehci_w90x900_hc_driver;
+
+static const struct ehci_driver_overrides ehci_w90X900_overrides __initdata = {
+	.reset = ehci_setup,
+};
+
 static int usb_w90x900_probe(const struct hc_driver *driver,
 		      struct platform_device *pdev)
 {
@@ -99,54 +119,6 @@ void usb_w90x900_remove(struct usb_hcd *hcd, struct platform_device *pdev)
 	usb_put_hcd(hcd);
 }
 
-static const struct hc_driver ehci_w90x900_hc_driver = {
-	.description = hcd_name,
-	.product_desc = "Nuvoton w90x900 EHCI Host Controller",
-	.hcd_priv_size = sizeof(struct ehci_hcd),
-
-	/*
-	 * generic hardware linkage
-	 */
-	.irq = ehci_irq,
-	.flags = HCD_USB2|HCD_MEMORY,
-
-	/*
-	 * basic lifecycle operations
-	 */
-	.reset = ehci_setup,
-	.start = ehci_run,
-
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
-#ifdef	CONFIG_PM
-	.bus_suspend = ehci_bus_suspend,
-	.bus_resume = ehci_bus_resume,
-#endif
-	.relinquish_port	= ehci_relinquish_port,
-	.port_handed_over	= ehci_port_handed_over,
-
-	.clear_tt_buffer_complete = ehci_clear_tt_buffer_complete,
-};
-
 static int ehci_w90x900_probe(struct platform_device *pdev)
 {
 	if (usb_disabled())
@@ -168,12 +140,30 @@ static struct platform_driver ehci_hcd_w90x900_driver = {
 	.probe  = ehci_w90x900_probe,
 	.remove = ehci_w90x900_remove,
 	.driver = {
-		.name = "w90x900-ehci",
+		.name = hcd_name,
 		.owner = THIS_MODULE,
 	},
 };
 
+static int __init ehci_w90X900_init(void)
+{
+	if (usb_disabled())
+		return -ENODEV;
+
+	pr_info("%s: " DRIVER_DESC "\n", hcd_name);
+
+	ehci_init_driver(&ehci_w90x900_hc_driver, &ehci_w90X900_overrides);
+	return platform_driver_register(&ehci_hcd_w90x900_driver);
+}
+module_init(ehci_w90X900_init);
+
+static void __exit ehci_w90X900_cleanup(void)
+{
+	platform_driver_unregister(&ehci_hcd_w90x900_driver);
+}
+module_exit(ehci_w90X900_cleanup);
+
 MODULE_AUTHOR("Wan ZongShun <mcuos.com@gmail.com>");
-MODULE_DESCRIPTION("w90p910 usb ehci driver!");
+MODULE_DESCRIPTION(DRIVER_DESC);
 MODULE_LICENSE("GPL");
 MODULE_ALIAS("platform:w90p910-ehci");
-- 
1.7.9.5

