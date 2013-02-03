Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753651Ab3BCOyz (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Feb 2013 09:54:55 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:34086 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752541Ab3BCOyw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Feb 2013 09:54:52 -0500
Message-Id: <20130203144644.567062850@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Sun, 03 Feb 2013 15:46:50 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: akpm@linux-foundation.org, Sarah Sharp <sarah.a.sharp@linux.intel.com>,
        Alan Stern <stern@rowland.harvard.edu>
Subject: [ 006/128] USB: Handle auto-transition from hot to warm reset.
In-Reply-To: <20130203144644.035172954@decadent.org.uk>
X-SA-Exim-Connect-IP: 151.216.67.5
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sarah Sharp <sarah.a.sharp@linux.intel.com>

commit 1c7439c61fa6516419c32a9824976334ea969d47 upstream.

USB 3.0 hubs and roothubs will automatically transition a failed hot
reset to a warm (BH) reset.  In that case, the warm reset change bit
will be set, and the link state change bit may also be set.  Change
hub_port_finish_reset to unconditionally clear those change bits for USB
3.0 hubs.  If these bits are not cleared, we may lose port change events
from the roothub.

This commit should be backported to kernels as old as 3.2, that contain
the commit 75d7cf72ab9fa01dc70877aa5c68e8ef477229dc "usbcore: refine
warm reset logic".

Signed-off-by: Sarah Sharp <sarah.a.sharp@linux.intel.com>
Acked-by: Alan Stern <stern@rowland.harvard.edu>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/usb/core/hub.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/usb/core/hub.c b/drivers/usb/core/hub.c
index a815fd2..7f8f10e 100644
--- a/drivers/usb/core/hub.c
+++ b/drivers/usb/core/hub.c
@@ -2580,16 +2580,16 @@ static void hub_port_finish_reset(struct usb_hub *hub, int port1,
 		clear_port_feature(hub->hdev,
 				port1, USB_PORT_FEAT_C_RESET);
 		/* FIXME need disconnect() for NOTATTACHED device */
-		if (warm) {
+		if (hub_is_superspeed(hub->hdev)) {
 			clear_port_feature(hub->hdev, port1,
 					USB_PORT_FEAT_C_BH_PORT_RESET);
 			clear_port_feature(hub->hdev, port1,
 					USB_PORT_FEAT_C_PORT_LINK_STATE);
-		} else {
+		}
+		if (!warm)
 			usb_set_device_state(udev, *status
 					? USB_STATE_NOTATTACHED
 					: USB_STATE_DEFAULT);
-		}
 		break;
 	}
 }


