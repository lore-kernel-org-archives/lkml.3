Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753860AbbALSGm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2015 13:06:42 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:57733 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753807AbbALSGi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2015 13:06:38 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Stephane Grosjean <s.grosjean@peak-system.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.16.y-ckt 092/216] can: peak_usb: fix memset() usage
Date: Mon, 12 Jan 2015 18:03:29 +0000
Message-Id: <1421085933-32536-93-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 2.1.4
In-Reply-To: <1421085933-32536-1-git-send-email-luis.henriques@canonical.com>
References: <1421085933-32536-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.16
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.16.7-ckt4 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Stephane Grosjean <s.grosjean@peak-system.com>

commit dc50ddcd4c58a5a0226038307d6ef884bec9f8c2 upstream.

This patchs fixes a misplaced call to memset() that fills the request
buffer with 0. The problem was with sending PCAN_USBPRO_REQ_FCT
requests, the content set by the caller was thus lost.

With this patch, the memory area is zeroed only when requesting info
from the device.

Signed-off-by: Stephane Grosjean <s.grosjean@peak-system.com>
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
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
2.1.4

