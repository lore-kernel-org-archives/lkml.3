Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754364Ab3C1Vys (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Mar 2013 17:54:48 -0400
Received: from moutng.kundenserver.de ([212.227.126.187]:60486 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753909Ab3C1Vyq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Mar 2013 17:54:46 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: linux-usb@vger.kernel.org, Manjunath Goudar <manjunath.goudar@linaro.org>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Greg KH <greg@kroah.com>, Arnd Bergmann <arnd@arndb.de>,
        Russell King <linux@arm.linux.org.uk>
Subject: [PATCH v3 1/7] USB: EHCI: make ehci-orion a separate driver
Date: Thu, 28 Mar 2013 22:54:59 +0100
Message-Id: <1364507705-22012-2-git-send-email-arnd@arndb.de>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1364507705-22012-1-git-send-email-arnd@arndb.de>
References: <1364507705-22012-1-git-send-email-arnd@arndb.de>
X-Provags-ID: V02:K0:+xoOMmPAH/EUVLi93Wnl2IUGB0NJcv5qzuvw3+bRz9L
 oYijWHeRycjCKzov8z0HLMNX4VJyi05WO30IujOxGqZW+wzwop
 R7noqulayRsWHlXskga0WyonX8HRbf00+7KJ51+fhmTdF2dmW/
 N5x1Vqqr5uDKE+aUpIq5kJvWCs4+D4V4cCI0xAUmHG6BsoKyCk
 3fKsxbvJQp7JTOYLgXKSW9FMXfAXquJlnBqsmydBaExBWDRKtT
 q5L8Wo8PRFdCkFKGXfqk/k7gBNFxysLr6a/SkWybZEwKltaUW1
 nTNsy+YzHnrfnPHJONYFc1B9Bw3q8TVPpexMbyKpC73jAcAl6c
 62TAssDjGrSpkxSmOw0bn5FIkd0QoW8znL1/6J2Ei
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Manjunath Goudar <manjunath.goudar@linaro.org>

Separate the Orion host controller driver from ehci-hcd host
code into its own driver module because of following reason.

With the multiplatform changes in arm-soc tree, it becomes
possible to enable the mvebu platform (which uses
ehci-orion) at the same time as other platforms that require
a conflicting EHCI bus glue. At the moment, this results
in a warning like

drivers/usb/host/ehci-hcd.c:1297:0: warning: "PLATFORM_DRIVER" redefined [enabled by default]
drivers/usb/host/ehci-hcd.c:1277:0: note: this is the location of the previous definition
drivers/usb/host/ehci-orion.c:334:31: warning: 'ehci_orion_driver' defined but not used [-Wunused-variable]

and an ehci driver that only works on one of them.

With the infrastructure added by Alan Stern in patch 3e0232039
"USB: EHCI: prepare to make ehci-hcd a library module", we can
avoid this problem by turning a bus glue into a separate
module, as we do here for the orion bus glue.

An earlier version of this patch was included in 3.9 but caused
a regression there, which has subsequently been fixed.

In V3:
1.More detail provided in commit message regarding this patch.
2.Replaced hcd_name string "ehci-orion" into "orion-ehci".
3.MODULE_LICENSE is GPL v2.
4.In ehci_init_driver calling second argument passed  as NULL instead of
   ehci_orion_overrides because ehci_orion_overrides is removed.

In V2:
Tegra patch related changes removed from this patch.

Signed-off-by: Manjunath Goudar <manjunath.goudar@linaro.org>
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Acked-by: Jason Cooper <jason@lakedaemon.net>
Tested-by: Andrew Lunn <andrew@lunn.ch>
Cc: Greg KH <greg@kroah.com>
Cc: Alan Stern <stern@rowland.harvard.edu>
Cc: Russell King <linux@arm.linux.org.uk>
Cc: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org
---
 drivers/usb/host/Kconfig      | 10 ++++++
 drivers/usb/host/Makefile     |  1 +
 drivers/usb/host/ehci-hcd.c   |  6 +---
 drivers/usb/host/ehci-orion.c | 82 ++++++++++++++++++-------------------------
 4 files changed, 47 insertions(+), 52 deletions(-)

diff --git a/drivers/usb/host/Kconfig b/drivers/usb/host/Kconfig
index 2f68221..d89b7ad 100644
--- a/drivers/usb/host/Kconfig
+++ b/drivers/usb/host/Kconfig
@@ -163,6 +163,16 @@ config USB_EHCI_HCD_OMAP
 	  Enables support for the on-chip EHCI controller on
 	  OMAP3 and later chips.
 
+config USB_EHCI_HCD_ORION
+	tristate  "Support for Marvell EBU on-chip EHCI USB controller"
+	depends on USB_EHCI_HCD && PLAT_ORION
+	default y
+	---help---
+	  Enables support for the on-chip EHCI controller on Marvell's
+	  embedded ARM SoCs, including Orion, Kirkwood, Dove, Armada XP,
+	  Armada 370.  This is different from the EHCI implementation
+	  on Marvell's mobile PXA and MMP SoC, see USB_EHCI_MV for those.
+
 config USB_EHCI_MSM
 	bool "Support for MSM on-chip EHCI USB controller"
 	depends on USB_EHCI_HCD && ARCH_MSM
diff --git a/drivers/usb/host/Makefile b/drivers/usb/host/Makefile
index 56de410..9492f50 100644
--- a/drivers/usb/host/Makefile
+++ b/drivers/usb/host/Makefile
@@ -28,6 +28,7 @@ obj-$(CONFIG_USB_EHCI_PCI)	+= ehci-pci.o
 obj-$(CONFIG_USB_EHCI_HCD_PLATFORM)	+= ehci-platform.o
 obj-$(CONFIG_USB_EHCI_MXC)	+= ehci-mxc.o
 obj-$(CONFIG_USB_EHCI_HCD_OMAP)	+= ehci-omap.o
+obj-$(CONFIG_USB_EHCI_HCD_ORION)	+= ehci-orion.o
 
 obj-$(CONFIG_USB_OXU210HP_HCD)	+= oxu210hp-hcd.o
 obj-$(CONFIG_USB_ISP116X_HCD)	+= isp116x-hcd.o
diff --git a/drivers/usb/host/ehci-hcd.c b/drivers/usb/host/ehci-hcd.c
index b12b97d..1f97268 100644
--- a/drivers/usb/host/ehci-hcd.c
+++ b/drivers/usb/host/ehci-hcd.c
@@ -1249,11 +1249,6 @@ MODULE_LICENSE ("GPL");
 #define XILINX_OF_PLATFORM_DRIVER	ehci_hcd_xilinx_of_driver
 #endif
 
-#ifdef CONFIG_PLAT_ORION
-#include "ehci-orion.c"
-#define	PLATFORM_DRIVER		ehci_orion_driver
-#endif
-
 #ifdef CONFIG_USB_W90X900_EHCI
 #include "ehci-w90x900.c"
 #define	PLATFORM_DRIVER		ehci_hcd_w90x900_driver
@@ -1319,6 +1314,7 @@ MODULE_LICENSE ("GPL");
 	!IS_ENABLED(CONFIG_USB_CHIPIDEA_HOST) && \
 	!IS_ENABLED(CONFIG_USB_EHCI_MXC) && \
 	!IS_ENABLED(CONFIG_USB_EHCI_HCD_OMAP) && \
+	!IS_ENABLED(CONFIG_USB_EHCI_HCD_ORION) && \
 	!defined(PLATFORM_DRIVER) && \
 	!defined(PS3_SYSTEM_BUS_DRIVER) && \
 	!defined(OF_PLATFORM_DRIVER) && \
diff --git a/drivers/usb/host/ehci-orion.c b/drivers/usb/host/ehci-orion.c
index 38c45fb..54c5794 100644
--- a/drivers/usb/host/ehci-orion.c
+++ b/drivers/usb/host/ehci-orion.c
@@ -17,6 +17,12 @@
 #include <linux/of.h>
 #include <linux/of_device.h>
 #include <linux/of_irq.h>
+#include <linux/usb.h>
+#include <linux/usb/hcd.h>
+#include <linux/io.h>
+#include <linux/dma-mapping.h>
+
+#include "ehci.h"
 
 #define rdl(off)	__raw_readl(hcd->regs + (off))
 #define wrl(off, val)	__raw_writel((val), hcd->regs + (off))
@@ -34,6 +40,12 @@
 #define USB_PHY_IVREF_CTRL	0x440
 #define USB_PHY_TST_GRP_CTRL	0x450
 
+#define DRIVER_DESC "EHCI orion driver"
+
+static const char hcd_name[] = "ehci-orion";
+
+static struct hc_driver __read_mostly ehci_orion_hc_driver;
+
 /*
  * Implement Orion USB controller specification guidelines
  */
@@ -104,51 +116,6 @@ static void orion_usb_phy_v1_setup(struct usb_hcd *hcd)
 	wrl(USB_MODE, 0x13);
 }
 
-static const struct hc_driver ehci_orion_hc_driver = {
-	.description = hcd_name,
-	.product_desc = "Marvell Orion EHCI",
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
-	.reset = ehci_setup,
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
-	.relinquish_port = ehci_relinquish_port,
-	.port_handed_over = ehci_port_handed_over,
-
-	.clear_tt_buffer_complete = ehci_clear_tt_buffer_complete,
-};
-
 static void
 ehci_orion_conf_mbus_windows(struct usb_hcd *hcd,
 			     const struct mbus_dram_target_info *dram)
@@ -323,8 +290,6 @@ static int ehci_orion_drv_remove(struct platform_device *pdev)
 	return 0;
 }
 
-MODULE_ALIAS("platform:orion-ehci");
-
 static const struct of_device_id ehci_orion_dt_ids[] = {
 	{ .compatible = "marvell,orion-ehci", },
 	{},
@@ -341,3 +306,26 @@ static struct platform_driver ehci_orion_driver = {
 		.of_match_table = of_match_ptr(ehci_orion_dt_ids),
 	},
 };
+
+static int __init ehci_orion_init(void)
+{
+	if (usb_disabled())
+		return -ENODEV;
+
+	pr_info("%s: " DRIVER_DESC "\n", hcd_name);
+
+	ehci_init_driver(&ehci_orion_hc_driver, NULL);
+	return platform_driver_register(&ehci_orion_driver);
+}
+module_init(ehci_orion_init);
+
+static void __exit ehci_orion_cleanup(void)
+{
+	platform_driver_unregister(&ehci_orion_driver);
+}
+module_exit(ehci_orion_cleanup);
+
+MODULE_DESCRIPTION(DRIVER_DESC);
+MODULE_ALIAS("platform:orion-ehci");
+MODULE_AUTHOR("Tzachi Perelstein");
+MODULE_LICENSE("GPL v2");
-- 
1.8.1.2

