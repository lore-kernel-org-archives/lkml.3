Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757076Ab3CNKjK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Mar 2013 06:39:10 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:52132 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757415Ab3CNKi2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Mar 2013 06:38:28 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Sarah Sharp <sarah.a.sharp@linux.intel.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 88/88] USB: Fix connected device switch to Inactive state.
Date: Thu, 14 Mar 2013 10:36:21 +0000
Message-Id: <1363257381-15900-89-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1363257381-15900-1-git-send-email-luis.henriques@canonical.com>
References: <1363257381-15900-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.8 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sarah Sharp <sarah.a.sharp@linux.intel.com>

commit d3b9d7a9051d7024a93c76a84b2f84b3b66ad6d5 upstream.

[This is upstream commit d3b9d7a9051d7024a93c76a84b2f84b3b66ad6d5.
It needs to be backported to kernels as old as 3.2, because it fixes the
buggy commit 9dbcaec830cd97f44a0b91b315844e0d7144746b "USB: Handle warm
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
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/usb/core/hub.c | 30 +++++++++++++++++++++++++-----
 1 file changed, 25 insertions(+), 5 deletions(-)

diff --git a/drivers/usb/core/hub.c b/drivers/usb/core/hub.c
index fc9788f..9d70788 100644
--- a/drivers/usb/core/hub.c
+++ b/drivers/usb/core/hub.c
@@ -2496,7 +2496,6 @@ static void hub_port_finish_reset(struct usb_hub *hub, int port1,
 	case -ENODEV:
 		clear_port_feature(hub->hdev,
 				port1, USB_PORT_FEAT_C_RESET);
-		/* FIXME need disconnect() for NOTATTACHED device */
 		if (hub_is_superspeed(hub->hdev)) {
 			clear_port_feature(hub->hdev, port1,
 					USB_PORT_FEAT_C_BH_PORT_RESET);
@@ -2530,6 +2529,18 @@ static int hub_port_reset(struct usb_hub *hub, int port1,
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
@@ -4528,12 +4539,21 @@ static void hub_events(void)
 			 */
 			if (hub_port_warm_reset_required(hub, portstatus)) {
 				int status;
+				struct usb_device *udev =
+					hub->hdev->children[i - 1];
 
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
 
-- 
1.8.1.2

