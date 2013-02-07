Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932148Ab3BGRfr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Feb 2013 12:35:47 -0500
Received: from mail-da0-f51.google.com ([209.85.210.51]:49752 "EHLO
	mail-da0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759192Ab3BGRfq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Feb 2013 12:35:46 -0500
From: manjunath.goudar@linaro.org
To: linux-usb@vger.kernel.org
Cc: linux-arm-kernel@lists.infradead.org, patches@linaro.org,
        stern@rowland.harvard.edu, arnd@linaro.org, gregkh@linuxfoundation.org,
        Manjunath Goudar <manjunath.goudar@linaro.org>,
        Greg KH <greg@kroah.com>, Jason Cooper <jason@lakedaemon.net>,
        Andrew Lunn <andrew@lunn.ch>, Russell King <linux@arm.linux.org.uk>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 04/10] USB: EHCI: make ehci-orion a separate driver
Date: Thu,  7 Feb 2013 23:04:01 +0530
Message-Id: <5113e5f0.c84e420a.08c3.ffffbe9a@mx.google.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1360258447-27247-1-git-send-email-yes>
References: <yes>
 <1360258447-27247-1-git-send-email-yes>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Manjunath Goudar <manjunath.goudar@linaro.org>

Separate the Marvell Orion host controller driver from ehci-hcd host code
into its own driver module.

Signed-off-by: Manjunath Goudar <manjunath.goudar@linaro.org>
Cc: Greg KH <greg@kroah.com>
Cc: Alan Stern <stern@rowland.harvard.edu>
Cc: Jason Cooper <jason@lakedaemon.net>
Cc: Andrew Lunn <andrew@lunn.ch>
Cc: Russell King <linux@arm.linux.org.uk>
Cc: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org
---
 drivers/usb/host/Kconfig      |    7 +++
 drivers/usb/host/Makefile     |    1 +
 drivers/usb/host/ehci-hcd.c   |   27 +++++-------
 drivers/usb/host/ehci-orion.c |   98 +++++++++++++++++++++--------------------
 4 files changed, 69 insertions(+), 64 deletions(-)

diff --git a/drivers/usb/host/Kconfig b/drivers/usb/host/Kconfig
index 4413075..3689b7b 100644
--- a/drivers/usb/host/Kconfig
+++ b/drivers/usb/host/Kconfig
@@ -169,6 +169,13 @@ config USB_EHCI_HCD_SPEAR
         ---help---
           Enables support for the on-chip EHCI controller on
           ST spear chips.
+config USB_EHCI_HCD_ORION
+        tristate  "Support for Marvell Orion on-chip EHCI USB controller"
+        depends on USB_EHCI_HCD && PLAT_ORION
+        default y
+        ---help---
+          Enables support for the on-chip EHCI controller on
+          Morvell Orion chips.
 
 config USB_EHCI_MSM
 	bool "Support for MSM on-chip EHCI USB controller"
diff --git a/drivers/usb/host/Makefile b/drivers/usb/host/Makefile
index c97f4ab..23b07dd 100644
--- a/drivers/usb/host/Makefile
+++ b/drivers/usb/host/Makefile
@@ -29,6 +29,7 @@ obj-$(CONFIG_USB_EHCI_HCD_PLATFORM)	+= ehci-platform.o
 obj-$(CONFIG_USB_EHCI_MXC)	+= ehci-mxc.o
 obj-$(CONFIG_USB_EHCI_HCD_OMAP) += ehci-omap.o
 obj-$(CONFIG_USB_EHCI_HCD_SPEAR)+= ehci-spear.o
+obj-$(CONFIG_USB_EHCI_HCD_ORION)+= ehci-orion.o
 obj-$(CONFIG_USB_OXU210HP_HCD)	+= oxu210hp-hcd.o
 obj-$(CONFIG_USB_ISP116X_HCD)	+= isp116x-hcd.o
 obj-$(CONFIG_USB_ISP1362_HCD)	+= isp1362-hcd.o
diff --git a/drivers/usb/host/ehci-hcd.c b/drivers/usb/host/ehci-hcd.c
index 68cea63..5a19a57 100644
--- a/drivers/usb/host/ehci-hcd.c
+++ b/drivers/usb/host/ehci-hcd.c
@@ -155,7 +155,7 @@ static inline unsigned ehci_read_frame_index(struct ehci_hcd *ehci)
  * before driver shutdown. But it also seems to be caused by bugs in cardbus
  * bridge shutdown:  shutting down the bridge before the devices using it.
  */
-static int handshake (struct ehci_hcd *ehci, void __iomem *ptr,
+int handshake(struct ehci_hcd *ehci, void __iomem *ptr,
 		      u32 mask, u32 done, int usec)
 {
 	u32	result;
@@ -172,9 +172,9 @@ static int handshake (struct ehci_hcd *ehci, void __iomem *ptr,
 	} while (usec > 0);
 	return -ETIMEDOUT;
 }
-
+EXPORT_SYMBOL_GPL(handshake);
 /* check TDI/ARC silicon is in host mode */
-static int tdi_in_host_mode (struct ehci_hcd *ehci)
+static int tdi_in_host_mode(struct ehci_hcd *ehci)
 {
 	u32		tmp;
 
@@ -186,7 +186,7 @@ static int tdi_in_host_mode (struct ehci_hcd *ehci)
  * Force HC to halt state from unknown (EHCI spec section 2.3).
  * Must be called with interrupts enabled and the lock not held.
  */
-static int ehci_halt (struct ehci_hcd *ehci)
+int ehci_halt(struct ehci_hcd *ehci)
 {
 	u32	temp;
 
@@ -215,9 +215,9 @@ static int ehci_halt (struct ehci_hcd *ehci)
 	return handshake(ehci, &ehci->regs->status,
 			  STS_HALT, STS_HALT, 16 * 125);
 }
-
+EXPORT_SYMBOL_GPL(ehci_halt);
 /* put TDI/ARC silicon into EHCI mode */
-static void tdi_reset (struct ehci_hcd *ehci)
+void tdi_reset(struct ehci_hcd *ehci)
 {
 	u32		tmp;
 
@@ -231,12 +231,12 @@ static void tdi_reset (struct ehci_hcd *ehci)
 		tmp |= USBMODE_BE;
 	ehci_writel(ehci, tmp, &ehci->regs->usbmode);
 }
-
+EXPORT_SYMBOL_GPL(tdi_reset);
 /*
  * Reset a non-running (STS_HALT == 1) controller.
  * Must be called with interrupts enabled and the lock not held.
  */
-static int ehci_reset (struct ehci_hcd *ehci)
+int ehci_reset(struct ehci_hcd *ehci)
 {
 	int	retval;
 	u32	command = ehci_readl(ehci, &ehci->regs->command);
@@ -272,7 +272,7 @@ static int ehci_reset (struct ehci_hcd *ehci)
 			ehci->resuming_ports = 0;
 	return retval;
 }
-
+EXPORT_SYMBOL_GPL(ehci_reset);
 /*
  * Idle the controller (turn off the schedules).
  * Must be called with interrupts enabled and the lock not held.
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
@@ -1267,11 +1267,6 @@ MODULE_LICENSE ("GPL");
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
diff --git a/drivers/usb/host/ehci-orion.c b/drivers/usb/host/ehci-orion.c
index 914a3ec..de4dde2 100644
--- a/drivers/usb/host/ehci-orion.c
+++ b/drivers/usb/host/ehci-orion.c
@@ -8,6 +8,17 @@
  * warranty of any kind, whether express or implied.
  */
 
+#include <linux/usb.h>
+#include <linux/usb/hcd.h>
+#include <linux/io.h>
+
+#include <linux/slab.h>
+#include <linux/usb/ulpi.h>
+#include <linux/regulator/consumer.h>
+#include <linux/pm_runtime.h>
+#include <linux/gpio.h>
+
+
 #include <linux/kernel.h>
 #include <linux/module.h>
 #include <linux/platform_device.h>
@@ -17,6 +28,9 @@
 #include <linux/of.h>
 #include <linux/of_device.h>
 #include <linux/of_irq.h>
+#include <linux/dma-mapping.h>
+#include "ehci.h"
+
 
 #define rdl(off)	__raw_readl(hcd->regs + (off))
 #define wrl(off, val)	__raw_writel((val), hcd->regs + (off))
@@ -34,6 +48,17 @@
 #define USB_PHY_IVREF_CTRL	0x440
 #define USB_PHY_TST_GRP_CTRL	0x450
 
+#define DRIVER_DESC "EHCI orion driver"
+
+static const char hcd_name[] = "ehci-orion";
+
+static struct hc_driver __read_mostly ehci_orion_hc_driver;
+
+static const struct ehci_driver_overrides orion_overrides __initdata = {
+	.reset = ehci_setup,
+};
+
+
 /*
  * Implement Orion USB controller specification guidelines
  */
@@ -104,51 +129,6 @@ static void orion_usb_phy_v1_setup(struct usb_hcd *hcd)
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
@@ -323,8 +303,6 @@ static int __exit ehci_orion_drv_remove(struct platform_device *pdev)
 	return 0;
 }
 
-MODULE_ALIAS("platform:orion-ehci");
-
 static const struct of_device_id ehci_orion_dt_ids[] = {
 	{ .compatible = "marvell,orion-ehci", },
 	{},
@@ -336,8 +314,32 @@ static struct platform_driver ehci_orion_driver = {
 	.remove		= __exit_p(ehci_orion_drv_remove),
 	.shutdown	= usb_hcd_platform_shutdown,
 	.driver = {
-		.name	= "orion-ehci",
+		.name	= hcd_name,
 		.owner  = THIS_MODULE,
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
+	ehci_init_driver(&ehci_orion_hc_driver, &orion_overrides);
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
+MODULE_ALIAS("platform:ehci-orion");
+MODULE_AUTHOR("Tzachi Perelstein");
+MODULE_LICENSE("GPL");
+
-- 
1.7.9.5

