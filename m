Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752314AbaDCOMc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Apr 2014 10:12:32 -0400
Received: from mail-we0-f169.google.com ([74.125.82.169]:52587 "EHLO
	mail-we0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752154AbaDCOMb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Apr 2014 10:12:31 -0400
From: Richard Genoud <richard.genoud@gmail.com>
To: Ivo van Doorn <IvDoorn@gmail.com>
Cc: Gertjan van Wingerde <gwingerde@gmail.com>,
        Helmut Schaa <helmut.schaa@googlemail.com>,
        "John W. Linville" <linville@tuxdriver.com>,
        linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
        Richard Genoud <richard.genoud@gmail.com>
Subject: [PATCH] rt2x00: BUG: remove double loop on REGISTER_BUSY_COUNT
Date: Thu,  3 Apr 2014 16:12:07 +0200
Message-Id: <1396534327-12971-1-git-send-email-richard.genoud@gmail.com>
X-Mailer: git-send-email 1.8.5.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

rt2x00usb_register_read_lock() calls rt2x00usb_vendor_req_buff_lock()
that calls rt2x00usb_vendor_request() which is already looping up to
REGISTER_BUSY_COUNT times.

So this loop is not needed.

Signed-off-by: Richard Genoud <richard.genoud@gmail.com>
---
 drivers/net/wireless/rt2x00/rt2x00usb.c | 9 +++------
 1 file changed, 3 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2x00usb.c b/drivers/net/wireless/rt2x00/rt2x00usb.c
index 10572452cc21..14142b099019 100644
--- a/drivers/net/wireless/rt2x00/rt2x00usb.c
+++ b/drivers/net/wireless/rt2x00/rt2x00usb.c
@@ -148,12 +148,9 @@ int rt2x00usb_regbusy_read(struct rt2x00_dev *rt2x00dev,
 	if (!test_bit(DEVICE_STATE_PRESENT, &rt2x00dev->flags))
 		return -ENODEV;
 
-	for (i = 0; i < REGISTER_BUSY_COUNT; i++) {
-		rt2x00usb_register_read_lock(rt2x00dev, offset, reg);
-		if (!rt2x00_get_field32(*reg, field))
-			return 1;
-		udelay(REGISTER_BUSY_DELAY);
-	}
+	rt2x00usb_register_read_lock(rt2x00dev, offset, reg);
+	if (!rt2x00_get_field32(*reg, field))
+		return 1;
 
 	rt2x00_err(rt2x00dev, "Indirect register access failed: offset=0x%.08x, value=0x%.08x\n",
 		   offset, *reg);
-- 
1.8.5.5

