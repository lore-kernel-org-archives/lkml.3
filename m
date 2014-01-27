Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754119AbaA0RrK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jan 2014 12:47:10 -0500
Received: from mail-wg0-f52.google.com ([74.125.82.52]:39873 "EHLO
	mail-wg0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754092AbaA0RrG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jan 2014 12:47:06 -0500
From: Luis Ortega <luiorpe1@upv.es>
To: dmitry.torokhov@gmail.com
Cc: heiko@sntech.de, yongjun_wei@trendmicro.com.cn,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        Luis Ortega <luiorpe1@upv.es>
Subject: [PATCH 4/4] Input: zforce - reduce stack memory allocated to frames
Date: Mon, 27 Jan 2014 19:46:13 +0100
Message-Id: <1390848373-7723-5-git-send-email-luiorpe1@upv.es>
X-Mailer: git-send-email 1.8.5.3
In-Reply-To: <1390848373-7723-1-git-send-email-luiorpe1@upv.es>
References: <1390848373-7723-1-git-send-email-luiorpe1@upv.es>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A frame is a u8 array with the following structure:
[PAYLOAD_HEADER, PAYLOAD_LENGTH, ...PAYLOAD_BODY...]

PAYLOAD_BODY can be at most 255 bytes long, as it's size is represented
by PAYLOAD_LENGTH. Therefore we can reduce the stack memory allocated to
payload_buffer[] roughly by half, from 512 to 257 bytes.

Signed-off-by: Luis Ortega <luiorpe1@upv.es>
---
 drivers/input/touchscreen/zforce_ts.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/input/touchscreen/zforce_ts.c b/drivers/input/touchscreen/zforce_ts.c
index e082d5c..afb2492 100644
--- a/drivers/input/touchscreen/zforce_ts.c
+++ b/drivers/input/touchscreen/zforce_ts.c
@@ -33,6 +33,7 @@
 #define WAIT_TIMEOUT		msecs_to_jiffies(1000)
 
 #define FRAME_START		0xee
+#define FRAME_MAXSIZE		257
 
 /* Offsets of the different parts of the payload the controller sends */
 #define PAYLOAD_HEADER		0
@@ -475,7 +476,7 @@ static irqreturn_t zforce_irq_thread(int irq, void *dev_id)
 	struct i2c_client *client = ts->client;
 	const struct zforce_ts_platdata *pdata = dev_get_platdata(&client->dev);
 	int ret;
-	u8 payload_buffer[512];
+	u8 payload_buffer[FRAME_MAXSIZE];
 	u8 *payload;
 
 	/*
-- 
1.8.5.3

