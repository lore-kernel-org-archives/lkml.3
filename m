Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755272Ab3I3KMG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Sep 2013 06:12:06 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:43427 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755176Ab3I3KL5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Sep 2013 06:11:57 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Shawn Nematbakhsh <shawnn@chromium.org>,
        Sarah Sharp <sarah.a.sharp@linux.intel.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 021/104] usb: xhci: Disable runtime PM suspend for quirky controllers
Date: Mon, 30 Sep 2013 11:09:58 +0100
Message-Id: <1380535881-9239-22-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1380535881-9239-1-git-send-email-luis.henriques@canonical.com>
References: <1380535881-9239-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.22 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Shawn Nematbakhsh <shawnn@chromium.org>

commit c8476fb855434c733099079063990e5bfa7ecad6 upstream.

If a USB controller with XHCI_RESET_ON_RESUME goes to runtime suspend,
a reset will be performed upon runtime resume. Any previously suspended
devices attached to the controller will be re-enumerated at this time.
This will cause problems, for example, if an open system call on the
device triggered the resume (the open call will fail).

Note that this change is only relevant when persist_enabled is not set
for USB devices.

This patch should be backported to kernels as old as 3.0, that
contain the commit c877b3b2ad5cb9d4fe523c5496185cc328ff3ae9 "xhci: Add
reset on resume quirk for asrock p67 host".

Signed-off-by: Shawn Nematbakhsh <shawnn@chromium.org>
Signed-off-by: Sarah Sharp <sarah.a.sharp@linux.intel.com>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/usb/host/xhci.c | 22 ++++++++++++++++++++++
 1 file changed, 22 insertions(+)

diff --git a/drivers/usb/host/xhci.c b/drivers/usb/host/xhci.c
index 5fcd576..2acae4d 100644
--- a/drivers/usb/host/xhci.c
+++ b/drivers/usb/host/xhci.c
@@ -3501,10 +3501,21 @@ void xhci_free_dev(struct usb_hcd *hcd, struct usb_device *udev)
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
@@ -3576,6 +3587,7 @@ static int xhci_reserve_host_control_ep_resources(struct xhci_hcd *xhci)
 int xhci_alloc_dev(struct usb_hcd *hcd, struct usb_device *udev)
 {
 	struct xhci_hcd *xhci = hcd_to_xhci(hcd);
+	struct device *dev = hcd->self.controller;
 	unsigned long flags;
 	int timeleft;
 	int ret;
@@ -3628,6 +3640,16 @@ int xhci_alloc_dev(struct usb_hcd *hcd, struct usb_device *udev)
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
1.8.3.2

