Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932957Ab3DBQXz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Apr 2013 12:23:55 -0400
Received: from moutng.kundenserver.de ([212.227.17.8]:53580 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932919Ab3DBQXu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Apr 2013 12:23:50 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Greg KH <greg@kroah.com>
Cc: linux-usb@vger.kernel.org, Manjunath Goudar <manjunath.goudar@linaro.org>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Alan Stern <stern@rowland.harvard.edu>, Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH V5 5/6] USB: EHCI: make ehci-msm a separate driver
Date: Tue,  2 Apr 2013 18:24:03 +0200
Message-Id: <1364919844-1726-6-git-send-email-arnd@arndb.de>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1364919844-1726-1-git-send-email-arnd@arndb.de>
References: <1364919844-1726-1-git-send-email-arnd@arndb.de>
X-Provags-ID: V02:K0:QxR5QLczzS9oMECpFJ6XVp8FXCQlzRyRWq/k7C4USJW
 tDTk6hP/oBJqF8nkMVjctZAcvwzxd8wr/lPqE72PZsre/n5eku
 38SJVipCzoFqFhh114NXYp7iv8w+7cc91FlL0voupVpxTjMMEN
 TRuzPsBDmHGHFllvzeXg4HcwP6hPKMbDscHIls6lgV5ggbdr+t
 jl3bdTurbFJkL0nZK3g+CW98TvUsPbgmjhdyvgDRQZfbNqkqkX
 8+RpjFqrCndvANQnsxbROrccmEzBpkwkhfEmNFG5KUFeRdlc18
 W1KRy3gJ3cJmSXfS5MQaUQrug/z2ACpxT6YfIwkJs7fC7aBM83
 SLPssJpy+5/yamA6ychcEoXcRuuH9mUc6BFJH5uG4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Manjunath Goudar <manjunath.goudar@linaro.org>

Separate the  Qualcomm QSD/MSM on-chip host controller driver from
ehci-hcd host code so that it can be built as a separate driver module.
This work is part of enabling multi-platform kernels on ARM;
however, note that other changes are still needed before Qualcomm QSD/MSM
can be booted with a multi-platform kernel, which is not expected before
3.11.

With the infrastructure added by Alan Stern in patch 3e0232039
"USB: EHCI: prepare to make ehci-hcd a library module", we can
avoid this problem by turning a bus glue into a separate
module, as we do here for the msm bus glue.

In V5 (arnd):
 - add FIXME about missing usb_add_hcd() or usb_remove_hcd() calls

In V3:
 - Detailed commit message added here describing why this patch is required.
 - Arranged  #include's in alphabetical order.
 - driver.name initialized hcd_name[] = "ehci-msm" in platform_driver
   structure initialization instead of "msm-ehci", which was the reason
   why it broke in EHCI USB testing

In V2:
Tegra patch related changes removed from this patch.

Signed-off-by: Manjunath Goudar <manjunath.goudar@linaro.org>
Acked-by: Alan Stern <stern@rowland.harvard.edu>
Acked-by: David Brown <davidb@codeaurora.org>
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 drivers/usb/host/Kconfig    |  2 +-
 drivers/usb/host/Makefile   |  1 +
 drivers/usb/host/ehci-hcd.c |  6 +--
 drivers/usb/host/ehci-msm.c | 89 +++++++++++++++++++++------------------------
 4 files changed, 44 insertions(+), 54 deletions(-)

diff --git a/drivers/usb/host/Kconfig b/drivers/usb/host/Kconfig
index f6f7872..b9cdbbb 100644
--- a/drivers/usb/host/Kconfig
+++ b/drivers/usb/host/Kconfig
@@ -191,7 +191,7 @@ config USB_EHCI_HCD_AT91
           Atmel chips.
 
 config USB_EHCI_MSM
-	bool "Support for MSM on-chip EHCI USB controller"
+	tristate "Support for Qualcomm QSD/MSM on-chip EHCI USB controller"
 	depends on USB_EHCI_HCD && ARCH_MSM
 	select USB_EHCI_ROOT_HUB_TT
 	select USB_MSM_OTG
diff --git a/drivers/usb/host/Makefile b/drivers/usb/host/Makefile
index 368d3eb..4fb73c1 100644
--- a/drivers/usb/host/Makefile
+++ b/drivers/usb/host/Makefile
@@ -32,6 +32,7 @@ obj-$(CONFIG_USB_EHCI_HCD_ORION)	+= ehci-orion.o
 obj-$(CONFIG_USB_EHCI_HCD_SPEAR)	+= ehci-spear.o
 obj-$(CONFIG_USB_EHCI_S5P)	+= ehci-s5p.o
 obj-$(CONFIG_USB_EHCI_HCD_AT91) += ehci-atmel.o
+obj-$(CONFIG_USB_EHCI_MSM)	+= ehci-msm.o
 
 obj-$(CONFIG_USB_OXU210HP_HCD)	+= oxu210hp-hcd.o
 obj-$(CONFIG_USB_ISP116X_HCD)	+= isp116x-hcd.o
diff --git a/drivers/usb/host/ehci-hcd.c b/drivers/usb/host/ehci-hcd.c
index ccc78ab..2e0c2bd 100644
--- a/drivers/usb/host/ehci-hcd.c
+++ b/drivers/usb/host/ehci-hcd.c
@@ -1259,11 +1259,6 @@ MODULE_LICENSE ("GPL");
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
@@ -1303,6 +1298,7 @@ MODULE_LICENSE ("GPL");
 	!IS_ENABLED(CONFIG_USB_EHCI_HCD_SPEAR) && \
 	!IS_ENABLED(CONFIG_USB_EHCI_S5P) && \
 	!IS_ENABLED(CONFIG_USB_EHCI_HCD_AT91) && \
+	!IS_ENABLED(CONFIG_USB_EHCI_MSM) && \
 	!defined(PLATFORM_DRIVER) && \
 	!defined(PS3_SYSTEM_BUS_DRIVER) && \
 	!defined(OF_PLATFORM_DRIVER) && \
diff --git a/drivers/usb/host/ehci-msm.c b/drivers/usb/host/ehci-msm.c
index 88a49c8..93f062c 100644
--- a/drivers/usb/host/ehci-msm.c
+++ b/drivers/usb/host/ehci-msm.c
@@ -22,16 +22,26 @@
  * along with this program; if not, you can find it at http://www.fsf.org
  */
 
-#include <linux/platform_device.h>
 #include <linux/clk.h>
 #include <linux/err.h>
+#include <linux/io.h>
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/platform_device.h>
 #include <linux/pm_runtime.h>
-
 #include <linux/usb/otg.h>
 #include <linux/usb/msm_hsusb_hw.h>
+#include <linux/usb.h>
+#include <linux/usb/hcd.h>
+
+#include "ehci.h"
 
 #define MSM_USB_BASE (hcd->regs)
 
+#define DRIVER_DESC "Qualcomm On-Chip EHCI Host Controller"
+
+static const char hcd_name[] = "ehci-msm";
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
@@ -165,6 +129,8 @@ static int ehci_msm_probe(struct platform_device *pdev)
 	pm_runtime_no_callbacks(&pdev->dev);
 	pm_runtime_enable(&pdev->dev);
 
+	/* FIXME: need to call usb_add_hcd() here? */
+
 	return 0;
 
 put_hcd:
@@ -183,6 +149,8 @@ static int ehci_msm_remove(struct platform_device *pdev)
 
 	otg_set_host(phy->otg, NULL);
 
+	/* FIXME: need to call usb_remove_hcd() here? */
+
 	usb_put_hcd(hcd);
 
 	return 0;
@@ -226,3 +194,28 @@ static struct platform_driver ehci_msm_driver = {
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
1.8.1.2

