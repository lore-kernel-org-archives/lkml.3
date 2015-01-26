Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755895AbbAZOaM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jan 2015 09:30:12 -0500
Received: from mga02.intel.com ([134.134.136.20]:13264 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755826AbbAZOaG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jan 2015 09:30:06 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.09,469,1418112000"; 
   d="scan'208";a="642663054"
Date: Mon, 26 Jan 2015 23:30:39 +0800
From: Zhuang Jin Can <jin.can.zhuang@intel.com>
To: gregkh@linuxfoundation.org, stern@rowland.harvard.edu,
        dan.j.williams@intel.com, pmladek@suse.cz, peter.chen@freescale.com,
        hdegoede@redhat.com, mathias.nyman@linux.intel.com
Cc: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        jin.can.zhuang@intel.com
Subject: [PATCH] Revert "usb: Reset USB-3 devices on USB-3 link bounce"
Message-ID: <20150126153039.GA18043@intel.com>
Reply-To: jin.can.zhuang@intel.com
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This revert a82b76f7fa6154e8ab2d8071842a3e38b9c0d0ff.

The commit causes an extra reset in remote wakeup as described in:
http://www.spinics.net/lists/linux-usb/msg119080.html

Signed-off-by: Zhuang Jin Can <jin.can.zhuang@intel.com>
---
 drivers/usb/core/hub.c |   34 +++++++++-------------------------
 1 file changed, 9 insertions(+), 25 deletions(-)

diff --git a/drivers/usb/core/hub.c b/drivers/usb/core/hub.c
index aeb50bb..89d009a 100644
--- a/drivers/usb/core/hub.c
+++ b/drivers/usb/core/hub.c
@@ -4882,7 +4882,7 @@ static void hub_port_connect_change(struct usb_hub *hub, int port1,
 static void port_event(struct usb_hub *hub, int port1)
 		__must_hold(&port_dev->status_lock)
 {
-	int connect_change, reset_device = 0;
+	int connect_change;
 	struct usb_port *port_dev = hub->ports[port1 - 1];
 	struct usb_device *udev = port_dev->child;
 	struct usb_device *hdev = hub->hdev;
@@ -4970,30 +4970,14 @@ static void port_event(struct usb_hub *hub, int port1)
 			if (hub_port_reset(hub, port1, NULL,
 					HUB_BH_RESET_TIME, true) < 0)
 				hub_port_disable(hub, port1, 1);
-		} else
-			reset_device = 1;
-	}
-
-	/*
-	 * On disconnect USB3 protocol ports transit from U0 to
-	 * SS.Inactive to Rx.Detect. If this happens a warm-
-	 * reset is not needed, but a (re)connect may happen
-	 * before hub_wq runs and sees the disconnect, and the
-	 * device may be an unknown state.
-	 *
-	 * If the port went through SS.Inactive without hub_wq
-	 * seeing it the C_LINK_STATE change flag will be set,
-	 * and we reset the dev to put it in a known state.
-	 */
-	if (reset_device || (udev && hub_is_superspeed(hub->hdev)
-				&& (portchange & USB_PORT_STAT_C_LINK_STATE)
-				&& (portstatus & USB_PORT_STAT_CONNECTION))) {
-		usb_unlock_port(port_dev);
-		usb_lock_device(udev);
-		usb_reset_device(udev);
-		usb_unlock_device(udev);
-		usb_lock_port(port_dev);
-		connect_change = 0;
+		} else {
+			usb_unlock_port(port_dev);
+			usb_lock_device(udev);
+			usb_reset_device(udev);
+			usb_unlock_device(udev);
+			usb_lock_port(port_dev);
+			connect_change = 0;
+		}
 	}
 
 	if (connect_change)
-- 
1.7.9.5

