Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754585Ab3C1VzK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Mar 2013 17:55:10 -0400
Received: from moutng.kundenserver.de ([212.227.126.171]:55764 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754413Ab3C1VzE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Mar 2013 17:55:04 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: linux-usb@vger.kernel.org, Manjunath Goudar <manjunath.goudar@linaro.org>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Greg KH <greg@kroah.com>, Andrew Victor <linux@maxim.org.za>,
        Nicolas Ferre <nicolas.ferre@atmel.com>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH v3 5/7] USB: EHCI: make ehci-atmel a separate driver
Date: Thu, 28 Mar 2013 22:55:03 +0100
Message-Id: <1364507705-22012-6-git-send-email-arnd@arndb.de>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1364507705-22012-1-git-send-email-arnd@arndb.de>
References: <1364507705-22012-1-git-send-email-arnd@arndb.de>
X-Provags-ID: V02:K0:oEK0KX2zDDI3ntOZHmcDBmr0KMhNP52LHgMB+P2ThQV
 AOYnT96+TSQUq2+crPxNxMZaUumAZtP5GWN8vrq5SB6Mp0tQCk
 BoQD8o+KfPpGglz2KWHUL9vcffkLyzQukHAjAZ2Rc9YT0eliUq
 6EcLOYsAQ4gGgwNxGdwbdy9wctI0D8DVgxJbG0q0XF7rwxF7dG
 mOUq8jzs3Xv3DWpOudzWgVgE/y44eLVDLcc/vozBnOlaiZbcud
 f50K+dPLExQ3UtkFlJDfAuq+J3blLT25Oy87/ZzoshEDPxXX68
 QgdCoqLtserVMEOlLeS/gbULSTItfQcr+tLnHv24HudnrDGPLF
 dHVP2KFP5QT7WjwXOQc0Ue1hRRgODkEPFdvpbwJhg
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Manjunath Goudar <manjunath.goudar@linaro.org>

Separate the Atmel host controller driver from ehci-hcd host code
so that it can be built as a separate driver module.
This work is part of enabling multi-platform kernels on ARM;
however, note that other changes are still needed before Atmel can be
booted with a multi-platform kernel. This is currently planned for
Linux-3.11.

With the infrastructure added by Alan Stern in patch 3e0232039
"USB: EHCI: prepare to make ehci-hcd a library module", we can
avoid this problem by turning a bus glue into a separate
module, as we do here for the Atmel bus glue.

In V3:
 -Detailed commit message added here about why this patch is required.
 -Replaced hcd_name string "ehci-atmel" to "atmel-ehci".
 -In Makefile inserted Blank line that separates the EHCI drivers from the following non-EHCI drivers.
 -Export ehci_shutdown symbol as it is needed by the Atmel driver.
 -Eliminated ehci_atmel_setup routine beacuse hcd registers
  directly setting in ehci_atmel_drv_probe function.

In V2:
Resolved below compiler error.
drivers/usb/host/ehci-atmel.c: In function 'ehci_atmel_drv_remove':
drivers/usb/host/ehci-atmel.c:167: error: implicit declaration of function 'ehci_shutdown'

Signed-off-by: Manjunath Goudar <manjunath.goudar@linaro.org>
Cc: Alan Stern <stern@rowland.harvard.edu>
Cc: Greg KH <greg@kroah.com>
Cc: Andrew Victor <linux@maxim.org.za>
Cc: Nicolas Ferre <nicolas.ferre@atmel.com>
Cc: Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>
Cc: linux-usb@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 drivers/usb/host/Kconfig      |  8 ++++
 drivers/usb/host/Makefile     |  1 +
 drivers/usb/host/ehci-atmel.c | 85 ++++++++++++++++++++-----------------------
 drivers/usb/host/ehci-hcd.c   |  6 +--
 4 files changed, 50 insertions(+), 50 deletions(-)

diff --git a/drivers/usb/host/Kconfig b/drivers/usb/host/Kconfig
index 01c1acb..8c564aa 100644
--- a/drivers/usb/host/Kconfig
+++ b/drivers/usb/host/Kconfig
@@ -181,6 +181,14 @@ config USB_EHCI_HCD_SPEAR
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
index 3d895b5..368d3eb 100644
--- a/drivers/usb/host/Makefile
+++ b/drivers/usb/host/Makefile
@@ -31,6 +31,7 @@ obj-$(CONFIG_USB_EHCI_HCD_OMAP)	+= ehci-omap.o
 obj-$(CONFIG_USB_EHCI_HCD_ORION)	+= ehci-orion.o
 obj-$(CONFIG_USB_EHCI_HCD_SPEAR)	+= ehci-spear.o
 obj-$(CONFIG_USB_EHCI_S5P)	+= ehci-s5p.o
+obj-$(CONFIG_USB_EHCI_HCD_AT91) += ehci-atmel.o
 
 obj-$(CONFIG_USB_OXU210HP_HCD)	+= oxu210hp-hcd.o
 obj-$(CONFIG_USB_ISP116X_HCD)	+= isp116x-hcd.o
diff --git a/drivers/usb/host/ehci-atmel.c b/drivers/usb/host/ehci-atmel.c
index f3beac4..9ce1217 100644
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
@@ -50,51 +63,6 @@ static void atmel_stop_ehci(struct platform_device *pdev)
 
 /*-------------------------------------------------------------------------*/
 
-static int ehci_atmel_setup(struct usb_hcd *hcd)
-{
-	struct ehci_hcd *ehci = hcd_to_ehci(hcd);
-
-	/* registers start at offset 0x0 */
-	ehci->caps = hcd->regs;
-
-	return ehci_setup(hcd);
-}
-
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
@@ -102,6 +70,7 @@ static int ehci_atmel_drv_probe(struct platform_device *pdev)
 	struct usb_hcd *hcd;
 	const struct hc_driver *driver = &ehci_atmel_hc_driver;
 	struct resource *res;
+	struct ehci_hcd *ehci;
 	int irq;
 	int retval;
 
@@ -162,6 +131,10 @@ static int ehci_atmel_drv_probe(struct platform_device *pdev)
 		goto fail_request_resource;
 	}
 
+	ehci = hcd_to_ehci(hcd);
+	/* registers start at offset 0x0 */
+	ehci->caps = hcd->regs;
+
 	atmel_start_ehci(pdev);
 
 	retval = usb_add_hcd(hcd, irq, IRQF_SHARED);
@@ -213,3 +186,25 @@ static struct platform_driver ehci_atmel_driver = {
 		.of_match_table	= of_match_ptr(atmel_ehci_dt_ids),
 	},
 };
+
+static int __init ehci_atmel_init(void)
+{
+	if (usb_disabled())
+		return -ENODEV;
+
+	pr_info("%s: " DRIVER_DESC "\n", hcd_name);
+	ehci_init_driver(&ehci_atmel_hc_driver, NULL);
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
+MODULE_ALIAS("platform:atmel-ehci");
+MODULE_AUTHOR("Nicolas Ferre");
+MODULE_LICENSE("GPL");
diff --git a/drivers/usb/host/ehci-hcd.c b/drivers/usb/host/ehci-hcd.c
index 1c9aa17..efc641c 100644
--- a/drivers/usb/host/ehci-hcd.c
+++ b/drivers/usb/host/ehci-hcd.c
@@ -1255,11 +1255,6 @@ MODULE_LICENSE ("GPL");
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
@@ -1308,6 +1303,7 @@ MODULE_LICENSE ("GPL");
 	!IS_ENABLED(CONFIG_USB_EHCI_HCD_ORION) && \
 	!IS_ENABLED(CONFIG_USB_EHCI_HCD_SPEAR) && \
 	!IS_ENABLED(CONFIG_USB_EHCI_S5P) && \
+	!IS_ENABLED(CONFIG_USB_EHCI_HCD_AT91) && \
 	!defined(PLATFORM_DRIVER) && \
 	!defined(PS3_SYSTEM_BUS_DRIVER) && \
 	!defined(OF_PLATFORM_DRIVER) && \
-- 
1.8.1.2

