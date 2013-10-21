Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756003Ab3JUJ2y (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Oct 2013 05:28:54 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:39384 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753449Ab3JUIux (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Oct 2013 04:50:53 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "Shawn Nematbakhsh" <shawnn@chromium.org>,
        "Sarah Sharp" <sarah.a.sharp@linux.intel.com>
Date: Mon, 21 Oct 2013 09:46:28 +0100
Message-ID: <lsq.1382345188.567589930@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [PATCH 3.2 036/149] usb: xhci: Disable runtime PM suspend for
 quirky controllers
In-Reply-To: <lsq.1382345187.199780875@decadent.org.uk>
X-SA-Exim-Connect-IP: 212.20.242.100
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.52-rc1 review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/usb/host/xhci.c | 22 ++++++++++++++++++++++
 1 file changed, 22 insertions(+)

--- a/drivers/usb/host/xhci.c
+++ b/drivers/usb/host/xhci.c
@@ -3484,10 +3484,21 @@ void xhci_free_dev(struct usb_hcd *hcd,
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
@@ -3559,6 +3570,7 @@ static int xhci_reserve_host_control_ep_
 int xhci_alloc_dev(struct usb_hcd *hcd, struct usb_device *udev)
 {
 	struct xhci_hcd *xhci = hcd_to_xhci(hcd);
+	struct device *dev = hcd->self.controller;
 	unsigned long flags;
 	int timeleft;
 	int ret;
@@ -3611,6 +3623,16 @@ int xhci_alloc_dev(struct usb_hcd *hcd,
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

