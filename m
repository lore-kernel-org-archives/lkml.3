Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753982Ab3AXD2k (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jan 2013 22:28:40 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:44166 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753865Ab3AXD21 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jan 2013 22:28:27 -0500
From: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Sarah Sharp <sarah.a.sharp@linux.intel.com>,
        Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
Subject: [PATCH 13/74] USB: Ignore port state until reset completes.
Date: Thu, 24 Jan 2013 01:26:25 -0200
Message-Id: <1358998046-613-14-git-send-email-herton.krzesinski@canonical.com>
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

commit 4f43447e62b37ee19c82a13f72f35b1ca60a74d3 upstream.

The port reset code bails out early if the current connect status is
cleared (device disconnected).  If we're issuing a hot reset, it may
also look at the link state before the reset is finished.

Section 10.14.2.6 of the USB 3.0 spec says that when a port enters the
Error state or Resetting state, the port connection bit retains the
value from the previous state.  Therefore we can't trust it until the
reset finishes.  Also, the xHCI spec section 4.19.1.2.5 says software
shall ignore the link state while the port is resetting, as it can be in
an unknown state.

The port state during reset is also unknown for USB 2.0 hubs.  The hub
sends a reset signal by driving the bus into an SE0 state.  This
overwhelms the "connect" signal from the device, so the port can't tell
whether anything is connected or not.

Fix the port reset code to ignore the port link state and current
connect bit until the reset finishes, and USB_PORT_STAT_RESET is
cleared.

Remove the check for USB_PORT_STAT_C_BH_RESET in the warm reset case,
because it's redundant.  When the warm reset finishes, the port reset
bit will be cleared at the same time USB_PORT_STAT_C_BH_RESET is set.
Remove the now-redundant check for a cleared USB_PORT_STAT_RESET bit
in the code to deal with the finished reset.

This patch should be backported to all stable kernels.

Signed-off-by: Sarah Sharp <sarah.a.sharp@linux.intel.com>
Acked-by: Alan Stern <stern@rowland.harvard.edu>
Signed-off-by: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
---
 drivers/usb/core/hub.c |   14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/drivers/usb/core/hub.c b/drivers/usb/core/hub.c
index 0b408c6..89fc61b 100644
--- a/drivers/usb/core/hub.c
+++ b/drivers/usb/core/hub.c
@@ -2425,6 +2425,10 @@ static int hub_port_wait_reset(struct usb_hub *hub, int port1,
 		if (ret < 0)
 			return ret;
 
+		/* The port state is unknown until the reset completes. */
+		if ((portstatus & USB_PORT_STAT_RESET))
+			goto delay;
+
 		/*
 		 * Some buggy devices require a warm reset to be issued even
 		 * when the port appears not to be connected.
@@ -2470,11 +2474,7 @@ static int hub_port_wait_reset(struct usb_hub *hub, int port1,
 			if ((portchange & USB_PORT_STAT_C_CONNECTION))
 				return -ENOTCONN;
 
-			/* if we`ve finished resetting, then break out of
-			 * the loop
-			 */
-			if (!(portstatus & USB_PORT_STAT_RESET) &&
-			    (portstatus & USB_PORT_STAT_ENABLE)) {
+			if ((portstatus & USB_PORT_STAT_ENABLE)) {
 				if (hub_is_wusb(hub))
 					udev->speed = USB_SPEED_WIRELESS;
 				else if (hub_is_superspeed(hub->hdev))
@@ -2488,10 +2488,10 @@ static int hub_port_wait_reset(struct usb_hub *hub, int port1,
 				return 0;
 			}
 		} else {
-			if (portchange & USB_PORT_STAT_C_BH_RESET)
-				return 0;
+			return 0;
 		}
 
+delay:
 		/* switch to the long delay after two short delay failures */
 		if (delay_time >= 2 * HUB_SHORT_RESET_TIME)
 			delay = HUB_LONG_RESET_TIME;
-- 
1.7.9.5

