Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1162489Ab3LFNUM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Dec 2013 08:20:12 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:44596 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161934Ab3LFNE0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Dec 2013 08:04:26 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Mathias Nyman <mathias.nyman@linux.intel.com>,
        Sarah Sharp <sarah.a.sharp@linux.intel.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 219/272] xhci: Enable LPM support only for hardwired or BESL devices
Date: Fri,  6 Dec 2013 12:58:28 +0000
Message-Id: <1386334761-25517-220-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1386334761-25517-1-git-send-email-luis.henriques@canonical.com>
References: <1386334761-25517-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.1 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mathias Nyman <mathias.nyman@linux.intel.com>

commit 890dae88672175f1d39f6105444d9bdc71c89258 upstream.

Some usb3 devices falsely claim they support usb2 hardware Link PM
when connected to a usb2 port. We only trust hardwired devices
or devices with the later BESL LPM support to be LPM enabled as default.

[Note: Sarah re-worked the original patch to move the code into the USB
core, and updated it to check whether the USB device supports BESL,
instead of checking if the xHCI port it's connected to supports BESL
encoding.]

This patch should be backported to kernels as old as 3.11, that
contain the commit a558ccdcc71c7770c5e80c926a31cfe8a3892a09 "usb: xhci:
add USB2 Link power management BESL support".  Without this fix, some
USB 3.0 devices will not enumerate or work properly under USB 2.0 ports
on Haswell-ULT systems.

Signed-off-by: Mathias Nyman <mathias.nyman@linux.intel.com>
Signed-off-by: Sarah Sharp <sarah.a.sharp@linux.intel.com>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/usb/core/hub.c | 27 +++++++++++++++++++++++++++
 1 file changed, 27 insertions(+)

diff --git a/drivers/usb/core/hub.c b/drivers/usb/core/hub.c
index 666dbe3..ef15a22 100644
--- a/drivers/usb/core/hub.c
+++ b/drivers/usb/core/hub.c
@@ -3952,6 +3952,32 @@ static int hub_set_address(struct usb_device *udev, int devnum)
 	return retval;
 }
 
+/*
+ * There are reports of USB 3.0 devices that say they support USB 2.0 Link PM
+ * when they're plugged into a USB 2.0 port, but they don't work when LPM is
+ * enabled.
+ *
+ * Only enable USB 2.0 Link PM if the port is internal (hardwired), or the
+ * device says it supports the new USB 2.0 Link PM errata by setting the BESL
+ * support bit in the BOS descriptor.
+ */
+static void hub_set_initial_usb2_lpm_policy(struct usb_device *udev)
+{
+	int connect_type;
+
+	if (!udev->usb2_hw_lpm_capable)
+		return;
+
+	connect_type = usb_get_hub_port_connect_type(udev->parent,
+			udev->portnum);
+
+	if ((udev->bos->ext_cap->bmAttributes & USB_BESL_SUPPORT) ||
+			connect_type == USB_PORT_CONNECT_TYPE_HARD_WIRED) {
+		udev->usb2_hw_lpm_allowed = 1;
+		usb_set_usb2_hardware_lpm(udev, 1);
+	}
+}
+
 /* Reset device, (re)assign address, get device descriptor.
  * Device connection must be stable, no more debouncing needed.
  * Returns device in USB_STATE_ADDRESS, except on error.
@@ -4245,6 +4271,7 @@ hub_port_init (struct usb_hub *hub, struct usb_device *udev, int port1,
 	/* notify HCD that we have a device connected and addressed */
 	if (hcd->driver->update_device)
 		hcd->driver->update_device(hcd, udev);
+	hub_set_initial_usb2_lpm_policy(udev);
 fail:
 	if (retval) {
 		hub_port_disable(hub, port1, 0);
-- 
1.8.3.2

