Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760522Ab3BJS7D (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Feb 2013 13:59:03 -0500
Received: from mail-pa0-f49.google.com ([209.85.220.49]:48159 "EHLO
	mail-pa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756475Ab3BJS7A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Feb 2013 13:59:00 -0500
From: manjunath.goudar@linaro.org
To: linux-usb@vger.kernel.org
Cc: linux-arm-kernel@lists.infradead.org, patches@linaro.org,
        stern@rowland.harvard.edu, arnd@linaro.org, gregkh@linuxfoundation.org,
        Manjunath Goudar <manjunath.goudar@linaro.org>,
        Greg KH <greg@kroah.com>, Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>,
        Andrew Victor <linux@maxim.org.za>,
        Nicolas Ferre <nicolas.ferre@atmel.com>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 2/8] USB: EHCI: make ehci-atmel a separate driver
Date: Mon, 11 Feb 2013 00:28:11 +0530
Message-Id: <5117edf3.860e440a.097c.3513@mx.google.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1360522697-22902-1-git-send-email-y>
References: <y>
 <1360522697-22902-1-git-send-email-y>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Manjunath Goudar <manjunath.goudar@linaro.org>

Separate the Atmel host controller driver from ehci-hcd host code
into its own driver module.

Signed-off-by: Manjunath Goudar <manjunath.goudar@linaro.org>
Cc: Alan Stern <stern@rowland.harvard.edu>
Cc: Greg KH <greg@kroah.com>
Cc: Grant Likely <grant.likely@secretlab.ca>
Cc: Rob Herring <rob.herring@calxeda.com>
Cc: Andrew Victor <linux@maxim.org.za>
Cc: Nicolas Ferre <nicolas.ferre@atmel.com>
Cc: Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>
Cc: linux-usb@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
---
 drivers/usb/host/Kconfig      |    8 +++++
 drivers/usb/host/Makefile     |    1 +
 drivers/usb/host/ehci-atmel.c |   77 ++++++++++++++++++++++-------------------
 drivers/usb/host/ehci-hcd.c   |   10 ++----
 drivers/usb/host/ehci.h       |    2 +-
 5 files changed, 54 insertions(+), 44 deletions(-)

diff --git a/drivers/usb/host/Kconfig b/drivers/usb/host/Kconfig
index 15e8032..1ef37d7 100644
--- a/drivers/usb/host/Kconfig
+++ b/drivers/usb/host/Kconfig
@@ -170,6 +170,14 @@ config USB_EHCI_HCD_SPEAR
           Enables support for the on-chip EHCI controller on
           ST SPEAr chips.
 
+config USB_EHCI_HCD_AT91
+        tristate  "Support for Atmel on-chip EHCI USB controller"
+        depends on USB_EHCI_HCD && ARCH_AT91
+        default y
+        ---help---
+          Enables support for the on-chip EHCI controller on
+          Atmel chips.
+
 config USB_EHCI_MSM
 	bool "Support for MSM on-chip EHCI USB controller"
 	depends on USB_EHCI_HCD && ARCH_MSM
diff --git a/drivers/usb/host/Makefile b/drivers/usb/host/Makefile
index c8fcde9..b301243 100644
--- a/drivers/usb/host/Makefile
+++ b/drivers/usb/host/Makefile
@@ -29,6 +29,7 @@ obj-$(CONFIG_USB_EHCI_HCD_PLATFORM)	+= ehci-platform.o
 obj-$(CONFIG_USB_EHCI_MXC)	+= ehci-mxc.o
 obj-$(CONFIG_USB_EHCI_HCD_SPEAR)+= ehci-spear.o
 obj-$(CONFIG_USB_OXU210HP_HCD)	+= oxu210hp-hcd.o
+obj-$(CONFIG_USB_EHCI_HCD_AT91) += ehci-atmel.o
 obj-$(CONFIG_USB_ISP116X_HCD)	+= isp116x-hcd.o
 obj-$(CONFIG_USB_ISP1362_HCD)	+= isp1362-hcd.o
 obj-$(CONFIG_USB_OHCI_HCD)	+= ohci-hcd.o
diff --git a/drivers/usb/host/ehci-atmel.c b/drivers/usb/host/ehci-atmel.c
index 27639487..e6a50f0 100644
--- a/drivers/usb/host/ehci-atmel.c
+++ b/drivers/usb/host/ehci-atmel.c
@@ -15,6 +15,19 @@
 #include <linux/platform_device.h>
 #include <linux/of.h>
 #include <linux/of_platform.h>
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/usb.h>
+#include <linux/usb/hcd.h>
+#include <linux/io.h>
+#include <linux/dma-mapping.h>
+
+#include "ehci.h"
+
+#define DRIVER_DESC "EHCI atmel driver"
+
+static const char hcd_name[] = "ehci-atmel";
+static struct hc_driver __read_mostly ehci_atmel_hc_driver;
 
 /* interface and function clocks */
 static struct clk *iclk, *fclk;
@@ -60,41 +73,6 @@ static int ehci_atmel_setup(struct usb_hcd *hcd)
 	return ehci_setup(hcd);
 }
 
-static const struct hc_driver ehci_atmel_hc_driver = {
-	.description		= hcd_name,
-	.product_desc		= "Atmel EHCI UHP HS",
-	.hcd_priv_size		= sizeof(struct ehci_hcd),
-
-	/* generic hardware linkage */
-	.irq			= ehci_irq,
-	.flags			= HCD_MEMORY | HCD_USB2,
-
-	/* basic lifecycle operations */
-	.reset			= ehci_atmel_setup,
-	.start			= ehci_run,
-	.stop			= ehci_stop,
-	.shutdown		= ehci_shutdown,
-
-	/* managing i/o requests and associated device resources */
-	.urb_enqueue		= ehci_urb_enqueue,
-	.urb_dequeue		= ehci_urb_dequeue,
-	.endpoint_disable	= ehci_endpoint_disable,
-	.endpoint_reset		= ehci_endpoint_reset,
-
-	/* scheduling support */
-	.get_frame_number	= ehci_get_frame,
-
-	/* root hub support */
-	.hub_status_data	= ehci_hub_status_data,
-	.hub_control		= ehci_hub_control,
-	.bus_suspend		= ehci_bus_suspend,
-	.bus_resume		= ehci_bus_resume,
-	.relinquish_port	= ehci_relinquish_port,
-	.port_handed_over	= ehci_port_handed_over,
-
-	.clear_tt_buffer_complete	= ehci_clear_tt_buffer_complete,
-};
-
 static u64 at91_ehci_dma_mask = DMA_BIT_MASK(32);
 
 static int ehci_atmel_drv_probe(struct platform_device *pdev)
@@ -210,7 +188,34 @@ static struct platform_driver ehci_atmel_driver = {
 	.remove		= ehci_atmel_drv_remove,
 	.shutdown	= usb_hcd_platform_shutdown,
 	.driver		= {
-		.name	= "atmel-ehci",
+		.name	= hcd_name,
 		.of_match_table	= of_match_ptr(atmel_ehci_dt_ids),
 	},
 };
+
+static const struct ehci_driver_overrides atmel_overrides __initdata = {
+	.reset = ehci_atmel_setup,
+};
+
+static int __init ehci_atmel_init(void)
+{
+	if (usb_disabled())
+		return -ENODEV;
+
+	pr_info("%s: " DRIVER_DESC "\n", hcd_name);
+	ehci_init_driver(&ehci_atmel_hc_driver, &atmel_overrides);
+	return platform_driver_register(&ehci_atmel_driver);
+}
+module_init(ehci_atmel_init);
+
+static void __exit ehci_atmel_cleanup(void)
+{
+	platform_driver_unregister(&ehci_atmel_driver);
+}
+module_exit(ehci_atmel_cleanup);
+
+MODULE_DESCRIPTION(DRIVER_DESC);
+
+MODULE_ALIAS("platform:ehci-atmel");
+MODULE_AUTHOR("Nicolas Ferre");
+MODULE_LICENSE("GPL");
diff --git a/drivers/usb/host/ehci-hcd.c b/drivers/usb/host/ehci-hcd.c
index be7247b..08e9fdf 100644
--- a/drivers/usb/host/ehci-hcd.c
+++ b/drivers/usb/host/ehci-hcd.c
@@ -352,7 +352,7 @@ static void ehci_silence_controller(struct ehci_hcd *ehci)
  * This forcibly disables dma and IRQs, helping kexec and other cases
  * where the next system software may expect clean state.
  */
-static void ehci_shutdown(struct usb_hcd *hcd)
+void ehci_shutdown(struct usb_hcd *hcd)
 {
 	struct ehci_hcd	*ehci = hcd_to_ehci(hcd);
 
@@ -366,7 +366,7 @@ static void ehci_shutdown(struct usb_hcd *hcd)
 
 	hrtimer_cancel(&ehci->hrtimer);
 }
-
+EXPORT_SYMBOL_GPL(ehci_shutdown);
 /*-------------------------------------------------------------------------*/
 
 /*
@@ -1282,11 +1282,6 @@ MODULE_LICENSE ("GPL");
 #define	PLATFORM_DRIVER		ehci_hcd_w90x900_driver
 #endif
 
-#ifdef CONFIG_ARCH_AT91
-#include "ehci-atmel.c"
-#define	PLATFORM_DRIVER		ehci_atmel_driver
-#endif
-
 #ifdef CONFIG_USB_OCTEON_EHCI
 #include "ehci-octeon.c"
 #define PLATFORM_DRIVER		ehci_octeon_driver
@@ -1343,6 +1338,7 @@ MODULE_LICENSE ("GPL");
 	!IS_ENABLED(CONFIG_USB_EHCI_MXC) && \
 	!defined(PLATFORM_DRIVER) && \
 	!IS_ENABLED(CONFIG_PLAT_SPEAR) && \
+	!IS_ENABLED(CONFIG_ARCH_AT91) && \
 	!defined(PS3_SYSTEM_BUS_DRIVER) && \
 	!defined(OF_PLATFORM_DRIVER) && \
 	!defined(XILINX_OF_PLATFORM_DRIVER)
diff --git a/drivers/usb/host/ehci.h b/drivers/usb/host/ehci.h
index 36c3a82..593d3bb 100644
--- a/drivers/usb/host/ehci.h
+++ b/drivers/usb/host/ehci.h
@@ -798,7 +798,7 @@ struct ehci_driver_overrides {
 extern void	ehci_init_driver(struct hc_driver *drv,
 				const struct ehci_driver_overrides *over);
 extern int	ehci_setup(struct usb_hcd *hcd);
-
+extern void ehci_shutdown(struct usb_hcd *hcd);
 #ifdef CONFIG_PM
 extern int	ehci_suspend(struct usb_hcd *hcd, bool do_wakeup);
 extern int	ehci_resume(struct usb_hcd *hcd, bool hibernated);
-- 
1.7.9.5

