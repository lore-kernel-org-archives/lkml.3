Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933553Ab3AOWwA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2013 17:52:00 -0500
Received: from mail.kernel.org ([198.145.19.201]:46600 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933121Ab3AOWv6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2013 17:51:58 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Sarah Sharp <sarah.a.sharp@linux.intel.com>,
        Alan Stern <stern@rowland.harvard.edu>
Subject: [ 100/171] USB: Handle auto-transition from hot to warm reset.
Date: Tue, 15 Jan 2013 14:44:25 -0800
Message-Id: <20130115224320.582239200@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.336.g94702dd
In-Reply-To: <20130115224313.394976595@linuxfoundation.org>
References: <20130115224313.394976595@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/usb/core/hub.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/drivers/usb/core/hub.c
+++ b/drivers/usb/core/hub.c
@@ -2249,16 +2249,16 @@ static void hub_port_finish_reset(struct
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


