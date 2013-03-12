Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933713Ab3CLWfU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Mar 2013 18:35:20 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:60474 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756163Ab3CLWdn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Mar 2013 18:33:43 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Sarah Sharp <sarah.a.sharp@linux.intel.com>,
        Alan Stern <stern@rowland.harvard.edu>
Subject: [ 098/100] USB: Fix connected device switch to Inactive state.
Date: Tue, 12 Mar 2013 15:32:23 -0700
Message-Id: <20130312223133.388509842@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.rc1.5.g7e0651a
In-Reply-To: <20130312223122.884099393@linuxfoundation.org>
References: <20130312223122.884099393@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sarah Sharp <sarah.a.sharp@linux.intel.com>

[This is upstream commit d3b9d7a9051d7024a93c76a84b2f84b3b66ad6d5.
It needs to be backported to kernels as old as 3.2, because it fixes the
buggy commit 65bdac5effd15d6af619b3b7218627ef4d84ed6a "USB: Handle warm
reset failure on empty port."]

A USB 3.0 device can transition to the Inactive state if a U1 or U2 exit
transition fails.  The current code in hub_events simply issues a warm
reset, but does not call any pre-reset or post-reset driver methods (or
unbind/rebind drivers without them).  Therefore the drivers won't know
their device has just been reset.

hub_events should instead call usb_reset_device.  This means
hub_port_reset now needs to figure out whether it should issue a warm
reset or a hot reset.

Remove the FIXME note about needing disconnect() for a NOTATTACHED
device.  This patch fixes that.

Signed-off-by: Sarah Sharp <sarah.a.sharp@linux.intel.com>
Acked-by: Alan Stern <stern@rowland.harvard.edu>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/usb/core/hub.c |   30 +++++++++++++++++++++++++-----
 1 file changed, 25 insertions(+), 5 deletions(-)

--- a/drivers/usb/core/hub.c
+++ b/drivers/usb/core/hub.c
@@ -2605,7 +2605,6 @@ static void hub_port_finish_reset(struct
 	case -ENODEV:
 		clear_port_feature(hub->hdev,
 				port1, USB_PORT_FEAT_C_RESET);
-		/* FIXME need disconnect() for NOTATTACHED device */
 		if (hub_is_superspeed(hub->hdev)) {
 			clear_port_feature(hub->hdev, port1,
 					USB_PORT_FEAT_C_BH_PORT_RESET);
@@ -2639,6 +2638,18 @@ static int hub_port_reset(struct usb_hub
 		 * Some companion controllers don't like it when they mix.
 		 */
 		down_read(&ehci_cf_port_reset_rwsem);
+	} else if (!warm) {
+		/*
+		 * If the caller hasn't explicitly requested a warm reset,
+		 * double check and see if one is needed.
+		 */
+		status = hub_port_status(hub, port1,
+					&portstatus, &portchange);
+		if (status < 0)
+			goto done;
+
+		if (hub_port_warm_reset_required(hub, portstatus))
+			warm = true;
 	}
 
 	/* Reset the port */
@@ -4730,12 +4741,21 @@ static void hub_events(void)
 			 */
 			if (hub_port_warm_reset_required(hub, portstatus)) {
 				int status;
+				struct usb_device *udev =
+					hub->ports[i - 1]->child;
 
 				dev_dbg(hub_dev, "warm reset port %d\n", i);
-				status = hub_port_reset(hub, i, NULL,
-						HUB_BH_RESET_TIME, true);
-				if (status < 0)
-					hub_port_disable(hub, i, 1);
+				if (!udev) {
+					status = hub_port_reset(hub, i,
+							NULL, HUB_BH_RESET_TIME,
+							true);
+					if (status < 0)
+						hub_port_disable(hub, i, 1);
+				} else {
+					usb_lock_device(udev);
+					status = usb_reset_device(udev);
+					usb_unlock_device(udev);
+				}
 				connect_change = 0;
 			}
 


