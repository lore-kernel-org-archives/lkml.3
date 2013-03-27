Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756922Ab3C0IS3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Mar 2013 04:18:29 -0400
Received: from mail-wi0-f175.google.com ([209.85.212.175]:48287 "EHLO
	mail-wi0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756898Ab3C0IS0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Mar 2013 04:18:26 -0400
From: seb <sebastien.royen@gmail.com>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Bill Pemberton <wfp5p@virginia.edu>
Cc: linux-kernel@vger.kernel.org, seb <sebastien.royen@armadeus.com>
Subject: [PATCH 1/1] Input: mma8450 - fix signed 12bits to 32bits conversion
Date: Wed, 27 Mar 2013 09:17:43 +0100
Message-Id: <1364372263-16848-1-git-send-email-sebastien.royen@armadeus.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Event value is wrong. Should be in range -2048 to 2047, but is in range 0 to 4095.
Use int8_t to int conversion and remove 0xfff mask.

Signed-off-by: seb <sebastien.royen@armadeus.com>
---
 drivers/input/misc/mma8450.c |   15 ++++++++++-----
 1 file changed, 10 insertions(+), 5 deletions(-)

diff --git a/drivers/input/misc/mma8450.c b/drivers/input/misc/mma8450.c
index 480557f..c3781a1 100644
--- a/drivers/input/misc/mma8450.c
+++ b/drivers/input/misc/mma8450.c
@@ -110,7 +110,7 @@ static void mma8450_poll(struct input_polled_dev *dev)
 	struct mma8450 *m = dev->private;
 	int x, y, z;
 	int ret;
-	u8 buf[6];
+	int8_t buf[6];
 
 	ret = mma8450_read(m, MMA8450_STATUS);
 	if (ret < 0)
@@ -119,13 +119,18 @@ static void mma8450_poll(struct input_polled_dev *dev)
 	if (!(ret & MMA8450_STATUS_ZXYDR))
 		return;
 
-	ret = mma8450_read_block(m, MMA8450_OUT_X_LSB, buf, sizeof(buf));
+	ret = mma8450_read_block(m, MMA8450_OUT_X_LSB, (u8*)buf, sizeof(buf));
 	if (ret < 0)
 		return;
 
-	x = ((buf[1] << 4) & 0xff0) | (buf[0] & 0xf);
-	y = ((buf[3] << 4) & 0xff0) | (buf[2] & 0xf);
-	z = ((buf[5] << 4) & 0xff0) | (buf[4] & 0xf);
+	/* convert 8 MSB from int8_t to int */
+	x = buf[1];
+	y = buf[3];
+	z = buf[5];
+	/* add 4 LSB */
+	x = (x << 4) | (buf[0] & 0xf);
+	y = (y << 4) | (buf[2] & 0xf);
+	z = (z << 4) | (buf[4] & 0xf);
 
 	input_report_abs(dev->input, ABS_X, x);
 	input_report_abs(dev->input, ABS_Y, y);
-- 
1.7.9.5

