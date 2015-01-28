Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762200AbbA2KvJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jan 2015 05:51:09 -0500
Received: from ip4-83-240-67-251.cust.nbox.cz ([83.240.67.251]:44737 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753275AbbA2I7X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jan 2015 03:59:23 -0500
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
        Stephane Grosjean <s.grosjean@peak-system.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>, Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 007/176] can: peak_usb: fix memset() usage
Date: Wed, 28 Jan 2015 15:27:17 +0100
Message-Id: <6b4be54359e16d4b4f2dfa8d00ddce49e0e2d93b.1422455352.git.jslaby@suse.cz>
X-Mailer: git-send-email 2.2.2
In-Reply-To: <ce4a451f616a1e7ab58cfeceea5e49c8b1c68c81.1422455352.git.jslaby@suse.cz>
References: <ce4a451f616a1e7ab58cfeceea5e49c8b1c68c81.1422455352.git.jslaby@suse.cz>
In-Reply-To: <cover.1422455352.git.jslaby@suse.cz>
References: <cover.1422455352.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stephane Grosjean <s.grosjean@peak-system.com>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

commit dc50ddcd4c58a5a0226038307d6ef884bec9f8c2 upstream.

This patchs fixes a misplaced call to memset() that fills the request
buffer with 0. The problem was with sending PCAN_USBPRO_REQ_FCT
requests, the content set by the caller was thus lost.

With this patch, the memory area is zeroed only when requesting info
from the device.

Signed-off-by: Stephane Grosjean <s.grosjean@peak-system.com>
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 drivers/net/can/usb/peak_usb/pcan_usb_pro.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/net/can/usb/peak_usb/pcan_usb_pro.c b/drivers/net/can/usb/peak_usb/pcan_usb_pro.c
index 263dd921edc4..f7f796a2c50b 100644
--- a/drivers/net/can/usb/peak_usb/pcan_usb_pro.c
+++ b/drivers/net/can/usb/peak_usb/pcan_usb_pro.c
@@ -333,8 +333,6 @@ static int pcan_usb_pro_send_req(struct peak_usb_device *dev, int req_id,
 	if (!(dev->state & PCAN_USB_STATE_CONNECTED))
 		return 0;
 
-	memset(req_addr, '\0', req_size);
-
 	req_type = USB_TYPE_VENDOR | USB_RECIP_OTHER;
 
 	switch (req_id) {
@@ -345,6 +343,7 @@ static int pcan_usb_pro_send_req(struct peak_usb_device *dev, int req_id,
 	default:
 		p = usb_rcvctrlpipe(dev->udev, 0);
 		req_type |= USB_DIR_IN;
+		memset(req_addr, '\0', req_size);
 		break;
 	}
 
-- 
2.2.2

