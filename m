Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755734AbaGJBHf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2014 21:07:35 -0400
Received: from mail-pa0-f73.google.com ([209.85.220.73]:62035 "EHLO
	mail-pa0-f73.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751431AbaGJBFy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2014 21:05:54 -0400
From: Andrew Bresticker <abrestic@chromium.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Mathias Nyman <mathias.nyman@intel.com>,
        Alan Stern <stern@rowland.harvard.edu>,
        Julius Werner <jwerner@chromium.org>, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc: linux-tegra@vger.kernel.org, Andrew Bresticker <abrestic@chromium.org>
Subject: [PATCH 1/4] xhci: Introduce xhci_init_driver()
Date: Wed,  9 Jul 2014 18:05:47 -0700
Message-Id: <1404954350-26343-2-git-send-email-abrestic@chromium.org>
X-Mailer: git-send-email 2.0.0.526.g5318336
In-Reply-To: <1404954350-26343-1-git-send-email-abrestic@chromium.org>
References: <1404954350-26343-1-git-send-email-abrestic@chromium.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since the struct hc_driver is mostly the same across the xhci-pci,
xhci-plat, and the upcoming xhci-tegra driver, introduce the function
xhci_init_driver() which will populate the hc_driver with the default
xHCI operations.  The caller must supply a setup function which will
be used as the hc_driver's reset callback.

Signed-off-by: Andrew Bresticker <abrestic@chromium.org>
---
 drivers/usb/host/xhci-pci.c  | 69 +++++---------------------------------------
 drivers/usb/host/xhci-plat.c | 60 +++-----------------------------------
 drivers/usb/host/xhci.c      | 68 +++++++++++++++++++++++++++++++++++++++++++
 drivers/usb/host/xhci.h      |  1 +
 4 files changed, 80 insertions(+), 118 deletions(-)

diff --git a/drivers/usb/host/xhci-pci.c b/drivers/usb/host/xhci-pci.c
index e20520f..97648e4 100644
--- a/drivers/usb/host/xhci-pci.c
+++ b/drivers/usb/host/xhci-pci.c
@@ -40,6 +40,8 @@
 
 static const char hcd_name[] = "xhci_hcd";
 
+static struct hc_driver __read_mostly xhci_pci_hc_driver;
+
 /* called after powerup, by probe or system-pm "wakeup" */
 static int xhci_pci_reinit(struct xhci_hcd *xhci, struct pci_dev *pdev)
 {
@@ -313,68 +315,6 @@ static int xhci_pci_resume(struct usb_hcd *hcd, bool hibernated)
 }
 #endif /* CONFIG_PM */
 
-static const struct hc_driver xhci_pci_hc_driver = {
-	.description =		hcd_name,
-	.product_desc =		"xHCI Host Controller",
-	.hcd_priv_size =	sizeof(struct xhci_hcd *),
-
-	/*
-	 * generic hardware linkage
-	 */
-	.irq =			xhci_irq,
-	.flags =		HCD_MEMORY | HCD_USB3 | HCD_SHARED,
-
-	/*
-	 * basic lifecycle operations
-	 */
-	.reset =		xhci_pci_setup,
-	.start =		xhci_run,
-#ifdef CONFIG_PM
-	.pci_suspend =          xhci_pci_suspend,
-	.pci_resume =           xhci_pci_resume,
-#endif
-	.stop =			xhci_stop,
-	.shutdown =		xhci_shutdown,
-
-	/*
-	 * managing i/o requests and associated device resources
-	 */
-	.urb_enqueue =		xhci_urb_enqueue,
-	.urb_dequeue =		xhci_urb_dequeue,
-	.alloc_dev =		xhci_alloc_dev,
-	.free_dev =		xhci_free_dev,
-	.alloc_streams =	xhci_alloc_streams,
-	.free_streams =		xhci_free_streams,
-	.add_endpoint =		xhci_add_endpoint,
-	.drop_endpoint =	xhci_drop_endpoint,
-	.endpoint_reset =	xhci_endpoint_reset,
-	.check_bandwidth =	xhci_check_bandwidth,
-	.reset_bandwidth =	xhci_reset_bandwidth,
-	.address_device =	xhci_address_device,
-	.enable_device =	xhci_enable_device,
-	.update_hub_device =	xhci_update_hub_device,
-	.reset_device =		xhci_discover_or_reset_device,
-
-	/*
-	 * scheduling support
-	 */
-	.get_frame_number =	xhci_get_frame,
-
-	/* Root hub support */
-	.hub_control =		xhci_hub_control,
-	.hub_status_data =	xhci_hub_status_data,
-	.bus_suspend =		xhci_bus_suspend,
-	.bus_resume =		xhci_bus_resume,
-	/*
-	 * call back when device connected and addressed
-	 */
-	.update_device =        xhci_update_device,
-	.set_usb2_hw_lpm =	xhci_set_usb2_hardware_lpm,
-	.enable_usb3_lpm_timeout =	xhci_enable_usb3_lpm_timeout,
-	.disable_usb3_lpm_timeout =	xhci_disable_usb3_lpm_timeout,
-	.find_raw_port_number =	xhci_find_raw_port_number,
-};
-
 /*-------------------------------------------------------------------------*/
 
 /* PCI driver selection metadata; PCI hotplugging uses this */
@@ -406,6 +346,11 @@ static struct pci_driver xhci_pci_driver = {
 
 int __init xhci_register_pci(void)
 {
+	xhci_init_driver(&xhci_pci_hc_driver, xhci_pci_setup);
+#ifdef CONFIG_PM
+	xhci_pci_hc_driver.pci_suspend = xhci_pci_suspend;
+	xhci_pci_hc_driver.pci_resume = xhci_pci_resume;
+#endif
 	return pci_register_driver(&xhci_pci_driver);
 }
 
diff --git a/drivers/usb/host/xhci-plat.c b/drivers/usb/host/xhci-plat.c
index 29d8adb..49799db 100644
--- a/drivers/usb/host/xhci-plat.c
+++ b/drivers/usb/host/xhci-plat.c
@@ -21,6 +21,8 @@
 #include "xhci.h"
 #include "xhci-mvebu.h"
 
+static struct hc_driver __read_mostly xhci_plat_hc_driver;
+
 static void xhci_plat_quirks(struct device *dev, struct xhci_hcd *xhci)
 {
 	/*
@@ -37,61 +39,6 @@ static int xhci_plat_setup(struct usb_hcd *hcd)
 	return xhci_gen_setup(hcd, xhci_plat_quirks);
 }
 
-static int xhci_plat_start(struct usb_hcd *hcd)
-{
-	return xhci_run(hcd);
-}
-
-static const struct hc_driver xhci_plat_xhci_driver = {
-	.description =		"xhci-hcd",
-	.product_desc =		"xHCI Host Controller",
-	.hcd_priv_size =	sizeof(struct xhci_hcd *),
-
-	/*
-	 * generic hardware linkage
-	 */
-	.irq =			xhci_irq,
-	.flags =		HCD_MEMORY | HCD_USB3 | HCD_SHARED,
-
-	/*
-	 * basic lifecycle operations
-	 */
-	.reset =		xhci_plat_setup,
-	.start =		xhci_plat_start,
-	.stop =			xhci_stop,
-	.shutdown =		xhci_shutdown,
-
-	/*
-	 * managing i/o requests and associated device resources
-	 */
-	.urb_enqueue =		xhci_urb_enqueue,
-	.urb_dequeue =		xhci_urb_dequeue,
-	.alloc_dev =		xhci_alloc_dev,
-	.free_dev =		xhci_free_dev,
-	.alloc_streams =	xhci_alloc_streams,
-	.free_streams =		xhci_free_streams,
-	.add_endpoint =		xhci_add_endpoint,
-	.drop_endpoint =	xhci_drop_endpoint,
-	.endpoint_reset =	xhci_endpoint_reset,
-	.check_bandwidth =	xhci_check_bandwidth,
-	.reset_bandwidth =	xhci_reset_bandwidth,
-	.address_device =	xhci_address_device,
-	.enable_device =	xhci_enable_device,
-	.update_hub_device =	xhci_update_hub_device,
-	.reset_device =		xhci_discover_or_reset_device,
-
-	/*
-	 * scheduling support
-	 */
-	.get_frame_number =	xhci_get_frame,
-
-	/* Root hub support */
-	.hub_control =		xhci_hub_control,
-	.hub_status_data =	xhci_hub_status_data,
-	.bus_suspend =		xhci_bus_suspend,
-	.bus_resume =		xhci_bus_resume,
-};
-
 static int xhci_plat_probe(struct platform_device *pdev)
 {
 	const struct hc_driver	*driver;
@@ -105,7 +52,7 @@ static int xhci_plat_probe(struct platform_device *pdev)
 	if (usb_disabled())
 		return -ENODEV;
 
-	driver = &xhci_plat_xhci_driver;
+	driver = &xhci_plat_hc_driver;
 
 	irq = platform_get_irq(pdev, 0);
 	if (irq < 0)
@@ -288,6 +235,7 @@ MODULE_ALIAS("platform:xhci-hcd");
 
 int xhci_register_plat(void)
 {
+	xhci_init_driver(&xhci_plat_hc_driver, xhci_plat_setup);
 	return platform_driver_register(&usb_xhci_driver);
 }
 
diff --git a/drivers/usb/host/xhci.c b/drivers/usb/host/xhci.c
index 7436d5f..8de75b7 100644
--- a/drivers/usb/host/xhci.c
+++ b/drivers/usb/host/xhci.c
@@ -4873,6 +4873,74 @@ error:
 	return retval;
 }
 
+static const struct hc_driver xhci_hc_driver = {
+	.description =		"xhci-hcd",
+	.product_desc =		"xHCI Host Controller",
+	.hcd_priv_size =	sizeof(struct xhci_hcd *),
+
+	/*
+	 * generic hardware linkage
+	 */
+	.irq =			xhci_irq,
+	.flags =		HCD_MEMORY | HCD_USB3 | HCD_SHARED,
+
+	/*
+	 * basic lifecycle operations
+	 */
+	.reset =		NULL, /* set in xhci_init_driver() */
+	.start =		xhci_run,
+	.stop =			xhci_stop,
+	.shutdown =		xhci_shutdown,
+
+	/*
+	 * managing i/o requests and associated device resources
+	 */
+	.urb_enqueue =		xhci_urb_enqueue,
+	.urb_dequeue =		xhci_urb_dequeue,
+	.alloc_dev =		xhci_alloc_dev,
+	.free_dev =		xhci_free_dev,
+	.alloc_streams =	xhci_alloc_streams,
+	.free_streams =		xhci_free_streams,
+	.add_endpoint =		xhci_add_endpoint,
+	.drop_endpoint =	xhci_drop_endpoint,
+	.endpoint_reset =	xhci_endpoint_reset,
+	.check_bandwidth =	xhci_check_bandwidth,
+	.reset_bandwidth =	xhci_reset_bandwidth,
+	.address_device =	xhci_address_device,
+	.enable_device =	xhci_enable_device,
+	.update_hub_device =	xhci_update_hub_device,
+	.reset_device =		xhci_discover_or_reset_device,
+
+	/*
+	 * scheduling support
+	 */
+	.get_frame_number =	xhci_get_frame,
+
+	/*
+	 * root hub support
+	 */
+	.hub_control =		xhci_hub_control,
+	.hub_status_data =	xhci_hub_status_data,
+	.bus_suspend =		xhci_bus_suspend,
+	.bus_resume =		xhci_bus_resume,
+
+	/*
+	 * call back when device connected and addressed
+	 */
+	.update_device =        xhci_update_device,
+	.set_usb2_hw_lpm =	xhci_set_usb2_hardware_lpm,
+	.enable_usb3_lpm_timeout =	xhci_enable_usb3_lpm_timeout,
+	.disable_usb3_lpm_timeout =	xhci_disable_usb3_lpm_timeout,
+	.find_raw_port_number =	xhci_find_raw_port_number,
+};
+
+void xhci_init_driver(struct hc_driver *drv, int (*setup_fn)(struct usb_hcd *))
+{
+	*drv = xhci_hc_driver;
+	drv->reset = setup_fn;
+}
+EXPORT_SYMBOL_GPL(xhci_init_driver);
+
 MODULE_DESCRIPTION(DRIVER_DESC);
 MODULE_AUTHOR(DRIVER_AUTHOR);
 MODULE_LICENSE("GPL");
diff --git a/drivers/usb/host/xhci.h b/drivers/usb/host/xhci.h
index 9ffecd5..0d9b2cf 100644
--- a/drivers/usb/host/xhci.h
+++ b/drivers/usb/host/xhci.h
@@ -1760,6 +1760,7 @@ int xhci_run(struct usb_hcd *hcd);
 void xhci_stop(struct usb_hcd *hcd);
 void xhci_shutdown(struct usb_hcd *hcd);
 int xhci_gen_setup(struct usb_hcd *hcd, xhci_get_quirks_t get_quirks);
+void xhci_init_driver(struct hc_driver *drv, int (*setup_fn)(struct usb_hcd *));
 
 #ifdef	CONFIG_PM
 int xhci_suspend(struct xhci_hcd *xhci);
-- 
2.0.0.526.g5318336

