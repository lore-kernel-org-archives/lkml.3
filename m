Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751152Ab3HSRgn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Aug 2013 13:36:43 -0400
Received: from mail-qa0-f73.google.com ([209.85.216.73]:61142 "EHLO
	mail-qa0-f73.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750864Ab3HSRgm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Aug 2013 13:36:42 -0400
From: Shawn Nematbakhsh <shawnn@chromium.org>
To: linux-usb@vger.kernel.org
Cc: sarah.a.sharp@linux.intel.com, gregkh@linuxfoundation.org,
        linux-kernel@vger.kernel.org, jwerner@chromium.org,
        shawnn@chromium.org, stern@rowland.harvard.edu
Subject: [PATCH v2] usb: xhci: Disable runtime PM suspend for quirky controllers
Date: Mon, 19 Aug 2013 10:36:13 -0700
Message-Id: <1376933773-4343-1-git-send-email-shawnn@chromium.org>
X-Mailer: git-send-email 1.8.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If a USB controller with XHCI_RESET_ON_RESUME goes to runtime suspend,
a reset will be performed upon runtime resume. Any previously suspended
devices attached to the controller will be re-enumerated at this time.
This will cause problems, for example, if an open system call on the
device triggered the resume (the open call will fail).

Note that this change is only relevant when persist_enabled is not set
for USB devices.

Signed-off-by: Shawn Nematbakhsh <shawnn@chromium.org>
---
Changes since v1:
- Only disable runtime suspend when devices are connected.
- Skip this change if CONFIG_USB_DEFAULT_PERSIST is enabled.
---

Change-Id: I964e5bdfec09d03fac8656aaf566bc48d34ef0f9
---
 drivers/usb/host/xhci.c | 22 ++++++++++++++++++++++
 1 file changed, 22 insertions(+)

diff --git a/drivers/usb/host/xhci.c b/drivers/usb/host/xhci.c
index 9478caa..8adbab2 100644
--- a/drivers/usb/host/xhci.c
+++ b/drivers/usb/host/xhci.c
@@ -3581,10 +3581,21 @@ void xhci_free_dev(struct usb_hcd *hcd, struct usb_device *udev)
 {
 	struct xhci_hcd *xhci = hcd_to_xhci(hcd);
 	struct xhci_virt_device *virt_dev;
+	struct device *dev = hcd->self.controller;
 	unsigned long flags;
 	u32 state;
 	int i, ret;
 
+#ifndef CONFIG_USB_DEFAULT_PERSIST
+	/*
+	 * We called pm_runtime_get_noresume when the device was attached.
+	 * Decrement the counter here to allow controller to runtime suspend
+	 * if no devices remain.
+	 */
+	if (xhci->quirks & XHCI_RESET_ON_RESUME)
+		pm_runtime_put_noidle(dev);
+#endif
+
 	ret = xhci_check_args(hcd, udev, NULL, 0, true, __func__);
 	/* If the host is halted due to driver unload, we still need to free the
 	 * device.
@@ -3656,6 +3667,7 @@ static int xhci_reserve_host_control_ep_resources(struct xhci_hcd *xhci)
 int xhci_alloc_dev(struct usb_hcd *hcd, struct usb_device *udev)
 {
 	struct xhci_hcd *xhci = hcd_to_xhci(hcd);
+	struct device *dev = hcd->self.controller;
 	unsigned long flags;
 	int timeleft;
 	int ret;
@@ -3708,6 +3720,16 @@ int xhci_alloc_dev(struct usb_hcd *hcd, struct usb_device *udev)
 		goto disable_slot;
 	}
 	udev->slot_id = xhci->slot_id;
+
+#ifndef CONFIG_USB_DEFAULT_PERSIST
+	/*
+	 * If resetting upon resume, we can't put the controller into runtime
+	 * suspend if there is a device attached.
+	 */
+	if (xhci->quirks & XHCI_RESET_ON_RESUME)
+		pm_runtime_get_noresume(dev);
+#endif
+
 	/* Is this a LS or FS device under a HS hub? */
 	/* Hub or peripherial? */
 	return 1;
-- 
1.7.12.4

