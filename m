Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752580AbaDCOtU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Apr 2014 10:49:20 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:47910 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752350AbaDCOtK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Apr 2014 10:49:10 -0400
From: Richard Genoud <richard.genoud@gmail.com>
To: Ivo van Doorn <IvDoorn@gmail.com>
Cc: Gertjan van Wingerde <gwingerde@gmail.com>,
        Helmut Schaa <helmut.schaa@googlemail.com>,
        "John W. Linville" <linville@tuxdriver.com>,
        linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
        Richard Genoud <richard.genoud@gmail.com>
Subject: [PATCH] rt2x00: Endless loop on hub port power down
Date: Thu,  3 Apr 2014 16:48:56 +0200
Message-Id: <1396536536-26423-1-git-send-email-richard.genoud@gmail.com>
X-Mailer: git-send-email 1.8.5.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I've met an endless (or at least very long) loop if I power down the usb
port on witch a usb wifi key is plugged.
(Ok, it's not very smart to power down a usb port when a usb key is in
used... but still, I think that should not lead to an endless loop).

I have a lot of:
ieee80211 phy1: rt2x00usb_vendor_request: Error - Vendor Request 0x07 failed for offset 0x0438 with error -71

(-71==-EPROTO)

How to reproduce:
- plug an usb wifi key
- ip link set wlan0 up
- hub-ctrl -b usb_bus -d usb_device -P usb_port -p 0

hub-ctrl source: https://github.com/codazoda/hub-ctrl.c/blob/master/hub-ctrl.c

The following patch prevents the endless loop, but I'm really not sure
that The Right Way To Do It (R)

Signed-off-by: Richard Genoud <richard.genoud@gmail.com>
---
 drivers/net/wireless/rt2x00/rt2x00usb.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/net/wireless/rt2x00/rt2x00usb.c b/drivers/net/wireless/rt2x00/rt2x00usb.c
index 14142b099019..6bf4067ebf63 100644
--- a/drivers/net/wireless/rt2x00/rt2x00usb.c
+++ b/drivers/net/wireless/rt2x00/rt2x00usb.c
@@ -68,6 +68,12 @@ int rt2x00usb_vendor_request(struct rt2x00_dev *rt2x00dev,
 		}
 	}
 
+	/* If the port is powered down, we get a -EPROTO error, and this
+	 * leads to a endless loop. So just say that the device is gone.
+	 */
+	if (status == -EPROTO)
+		clear_bit(DEVICE_STATE_PRESENT, &rt2x00dev->flags);
+
 	rt2x00_err(rt2x00dev,
 		   "Vendor Request 0x%02x failed for offset 0x%04x with error %d\n",
 		   request, offset, status);
-- 
1.8.5.5

