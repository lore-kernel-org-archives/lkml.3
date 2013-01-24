Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753855Ab3AXD20 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jan 2013 22:28:26 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:44150 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753134Ab3AXD2M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jan 2013 22:28:12 -0500
From: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Sarah Sharp <sarah.a.sharp@linux.intel.com>,
        Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
Subject: [PATCH 09/74] USB: Handle auto-transition from hot to warm reset.
Date: Thu, 24 Jan 2013 01:26:21 -0200
Message-Id: <1358998046-613-10-git-send-email-herton.krzesinski@canonical.com>
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
Signed-off-by: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
---
 drivers/usb/core/hub.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/usb/core/hub.c b/drivers/usb/core/hub.c
index f04ca3c..931eea2 100644
--- a/drivers/usb/core/hub.c
+++ b/drivers/usb/core/hub.c
@@ -2471,16 +2471,16 @@ static void hub_port_finish_reset(struct usb_hub *hub, int port1,
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
-- 
1.7.9.5

