Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752823Ab3KNDoV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Nov 2013 22:44:21 -0500
Received: from mail-pa0-f49.google.com ([209.85.220.49]:63146 "EHLO
	mail-pa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751394Ab3KNDoN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Nov 2013 22:44:13 -0500
From: Daniel Jeong <gshark.jeong@gmail.com>
To: Mauro Carvalho Chehab <m.chehab@samsung.com>
Cc: Hans Verkuil <hans.verkuil@cisco.com>,
        Daniel Jeong <gshark.jeong@gmail.com>, <linux-kernel@vger.kernel.org>,
        Sakari Ailus <sakari.ailus@iki.fi>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        <linux-media@vger.kernel.org>,
        Dan Carpenter <dan.carpenter@oracle.com>
Subject: [PATCH -next] [media] media: i2c: lm3560: fix missing unlock error in lm3560_get_ctrl().
Date: Thu, 14 Nov 2013 12:43:27 +0900
Message-Id: <1384400607-18504-1-git-send-email-gshark.jeong@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add the missing unlock before return from function lm3560_get_ctrl()
to avoid deadlock. Thanks to Dan Carpenter.

Signed-off-by: Daniel Jeong <gshark.jeong@gmail.com>
---
 drivers/media/i2c/lm3560.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/media/i2c/lm3560.c b/drivers/media/i2c/lm3560.c
index 3317a9a..5d6eef0 100644
--- a/drivers/media/i2c/lm3560.c
+++ b/drivers/media/i2c/lm3560.c
@@ -172,16 +172,16 @@ static int lm3560_flash_brt_ctrl(struct lm3560_flash *flash,
 static int lm3560_get_ctrl(struct v4l2_ctrl *ctrl, enum lm3560_led_id led_no)
 {
 	struct lm3560_flash *flash = to_lm3560_flash(ctrl, led_no);
+	int rval = -EINVAL;
 
 	mutex_lock(&flash->lock);
 
 	if (ctrl->id == V4L2_CID_FLASH_FAULT) {
-		int rval;
 		s32 fault = 0;
 		unsigned int reg_val;
 		rval = regmap_read(flash->regmap, REG_FLAG, &reg_val);
 		if (rval < 0)
-			return rval;
+			goto out;
 		if (rval & FAULT_SHORT_CIRCUIT)
 			fault |= V4L2_FLASH_FAULT_SHORT_CIRCUIT;
 		if (rval & FAULT_OVERTEMP)
@@ -189,11 +189,11 @@ static int lm3560_get_ctrl(struct v4l2_ctrl *ctrl, enum lm3560_led_id led_no)
 		if (rval & FAULT_TIMEOUT)
 			fault |= V4L2_FLASH_FAULT_TIMEOUT;
 		ctrl->cur.val = fault;
-		return 0;
 	}
 
+out:
 	mutex_unlock(&flash->lock);
-	return -EINVAL;
+	return rval;
 }
 
 static int lm3560_set_ctrl(struct v4l2_ctrl *ctrl, enum lm3560_led_id led_no)
-- 
1.7.9.5

