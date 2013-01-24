Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754378Ab3AXDoz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jan 2013 22:44:55 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:44154 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753811Ab3AXD2P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jan 2013 22:28:15 -0500
From: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Sarah Sharp <sarah.a.sharp@linux.intel.com>,
        Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
Subject: [PATCH 10/74] USB: Ignore xHCI Reset Device status.
Date: Thu, 24 Jan 2013 01:26:22 -0200
Message-Id: <1358998046-613-11-git-send-email-herton.krzesinski@canonical.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1358998046-613-1-git-send-email-herton.krzesinski@canonical.com>
References: <1358998046-613-1-git-send-email-herton.krzesinski@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.4 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sarah Sharp <sarah.a.sharp@linux.intel.com>

commit 8b8132bc3d1cc3d4c0687e4d638a482fa920d98a upstream.

When the USB core finishes reseting a USB device, the xHCI driver sends
a Reset Device command to the host.  The xHC then updates its internal
representation of the USB device to the 'Default' device state.  If the
device was already in the Default state, the xHC will complete the
command with an error status.

If a device needs to be reset several times during enumeration, the
second reset will always fail because of the xHCI Reset Device command.
This can cause issues during enumeration.

For example, usb_reset_and_verify_device calls into hub_port_init in a
loop.  Say that on the first call into hub_port_init, the device is
successfully reset, but doesn't respond to several set address control
transfers.  Then the port will be disabled, but the udev will remain in
tact.  usb_reset_and_verify_device will call into hub_port_init again.

On the second call into hub_port_init, the device will be reset, and the
xHCI driver will issue a Reset Device command.  This command will fail
(because the device is already in the Default state), and
usb_reset_and_verify_device will fail.  The port will be disabled, and
the device won't be able to enumerate.

Fix this by ignoring the return value of the HCD reset_device callback.

This commit should be backported to kernels as old as 3.2, that contain
the commit 75d7cf72ab9fa01dc70877aa5c68e8ef477229dc "usbcore: refine
warm reset logic".

Signed-off-by: Sarah Sharp <sarah.a.sharp@linux.intel.com>
Acked-by: Alan Stern <stern@rowland.harvard.edu>
Signed-off-by: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
---
 drivers/usb/core/hub.c |   13 +++++--------
 1 file changed, 5 insertions(+), 8 deletions(-)

diff --git a/drivers/usb/core/hub.c b/drivers/usb/core/hub.c
index 931eea2..03af701 100644
--- a/drivers/usb/core/hub.c
+++ b/drivers/usb/core/hub.c
@@ -2456,14 +2456,11 @@ static void hub_port_finish_reset(struct usb_hub *hub, int port1,
 			msleep(10 + 40);
 			update_devnum(udev, 0);
 			hcd = bus_to_hcd(udev->bus);
-			if (hcd->driver->reset_device) {
-				*status = hcd->driver->reset_device(hcd, udev);
-				if (*status < 0) {
-					dev_err(&udev->dev, "Cannot reset "
-							"HCD device state\n");
-					break;
-				}
-			}
+			/* The xHC may think the device is already reset,
+			 * so ignore the status.
+			 */
+			if (hcd->driver->reset_device)
+				hcd->driver->reset_device(hcd, udev);
 		}
 		/* FALL THROUGH */
 	case -ENOTCONN:
-- 
1.7.9.5

