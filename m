Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752847Ab3CREsU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Mar 2013 00:48:20 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:33443 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751608Ab3CREaS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Mar 2013 00:30:18 -0400
Message-Id: <20130318042151.129480243@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Mon, 18 Mar 2013 04:22:55 +0000
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: akpm@linux-foundation.org, Sarah Sharp <sarah.a.sharp@linux.intel.com>,
        Alan Stern <stern@rowland.harvard.edu>
Subject: [ 71/82] USB: Prepare for refactoring by adding extra udev  checks.
In-Reply-To: <20130318042144.234468645@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:d98f:da4e:f620:7bea
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sarah Sharp <sarah.a.sharp@linux.intel.com>

commit 2d4fa940f99663c82ba55b2244638833b388e4e2 upstream.

The next patch will refactor the hub port code to rip out the recursive
call to hub_port_reset on a failed hot reset.  In preparation for that,
make sure all code paths can deal with being called with a NULL udev.
The usb_device will not be valid if warm reset was issued because a port
transitioned to the Inactive or Compliance Mode on a device connect.

This patch should have no effect on current behavior.

Signed-off-by: Sarah Sharp <sarah.a.sharp@linux.intel.com>
Acked-by: Alan Stern <stern@rowland.harvard.edu>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/usb/core/hub.c |   21 +++++++++++++--------
 1 files changed, 13 insertions(+), 8 deletions(-)

--- a/drivers/usb/core/hub.c
+++ b/drivers/usb/core/hub.c
@@ -2194,6 +2194,9 @@ static int hub_port_wait_reset(struct us
 				return -ENOTCONN;
 
 			if ((portstatus & USB_PORT_STAT_ENABLE)) {
+				if (!udev)
+					return 0;
+
 				if (hub_is_wusb(hub))
 					udev->speed = USB_SPEED_WIRELESS;
 				else if (hub_is_superspeed(hub->hdev))
@@ -2237,13 +2240,15 @@ static void hub_port_finish_reset(struct
 			struct usb_hcd *hcd;
 			/* TRSTRCY = 10 ms; plus some extra */
 			msleep(10 + 40);
-			update_devnum(udev, 0);
-			hcd = bus_to_hcd(udev->bus);
-			/* The xHC may think the device is already reset,
-			 * so ignore the status.
-			 */
-			if (hcd->driver->reset_device)
-				hcd->driver->reset_device(hcd, udev);
+			if (udev) {
+				update_devnum(udev, 0);
+				hcd = bus_to_hcd(udev->bus);
+				/* The xHC may think the device is already
+				 * reset, so ignore the status.
+				 */
+				if (hcd->driver->reset_device)
+					hcd->driver->reset_device(hcd, udev);
+			}
 		}
 		/* FALL THROUGH */
 	case -ENOTCONN:
@@ -2257,7 +2262,7 @@ static void hub_port_finish_reset(struct
 			clear_port_feature(hub->hdev, port1,
 					USB_PORT_FEAT_C_PORT_LINK_STATE);
 		}
-		if (!warm)
+		if (!warm && udev)
 			usb_set_device_state(udev, *status
 					? USB_STATE_NOTATTACHED
 					: USB_STATE_DEFAULT);


