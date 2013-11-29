Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755283Ab3K2Vug (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Nov 2013 16:50:36 -0500
Received: from mail.ispras.ru ([83.149.199.45]:40034 "EHLO mail.ispras.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754452Ab3K2Vuf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Nov 2013 16:50:35 -0500
From: Alexey Khoroshilov <khoroshilov@ispras.ru>
To: Michael Krufky <mkrufky@linuxtv.org>
Cc: Alexey Khoroshilov <khoroshilov@ispras.ru>,
        Mauro Carvalho Chehab <m.chehab@samsung.com>,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        ldv-project@linuxtesting.org
Subject: [PATCH] cxusb: fix mismatch in mutex lock-unlock in cxusb_i2c_xfer()
Date: Sat, 30 Nov 2013 01:50:19 +0400
Message-Id: <1385761819-32409-1-git-send-email-khoroshilov@ispras.ru>
X-Mailer: git-send-email 1.8.3.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There are several failure paths in cxusb_i2c_xfer(), where
d->i2c_mutex is left held. The patch fixes them.

Found by Linux Driver Verification project (linuxtesting.org).

Signed-off-by: Alexey Khoroshilov <khoroshilov@ispras.ru>
---
 drivers/media/usb/dvb-usb/cxusb.c | 19 ++++++++++++-------
 1 file changed, 12 insertions(+), 7 deletions(-)

diff --git a/drivers/media/usb/dvb-usb/cxusb.c b/drivers/media/usb/dvb-usb/cxusb.c
index 20e345d9fe8f..00b42984f1dd 100644
--- a/drivers/media/usb/dvb-usb/cxusb.c
+++ b/drivers/media/usb/dvb-usb/cxusb.c
@@ -149,7 +149,7 @@ static int cxusb_i2c_xfer(struct i2c_adapter *adap, struct i2c_msg msg[],
 			  int num)
 {
 	struct dvb_usb_device *d = i2c_get_adapdata(adap);
-	int i;
+	int i, ret;
 
 	if (mutex_lock_interruptible(&d->i2c_mutex) < 0)
 		return -EAGAIN;
@@ -173,7 +173,8 @@ static int cxusb_i2c_xfer(struct i2c_adapter *adap, struct i2c_msg msg[],
 			if (1 + msg[i].len > sizeof(ibuf)) {
 				warn("i2c rd: len=%d is too big!\n",
 				     msg[i].len);
-				return -EOPNOTSUPP;
+				ret = -EOPNOTSUPP;
+				goto unlock;
 			}
 			obuf[0] = 0;
 			obuf[1] = msg[i].len;
@@ -193,12 +194,14 @@ static int cxusb_i2c_xfer(struct i2c_adapter *adap, struct i2c_msg msg[],
 			if (3 + msg[i].len > sizeof(obuf)) {
 				warn("i2c wr: len=%d is too big!\n",
 				     msg[i].len);
-				return -EOPNOTSUPP;
+				ret = -EOPNOTSUPP;
+				goto unlock;
 			}
 			if (1 + msg[i + 1].len > sizeof(ibuf)) {
 				warn("i2c rd: len=%d is too big!\n",
 				     msg[i + 1].len);
-				return -EOPNOTSUPP;
+				ret = -EOPNOTSUPP;
+				goto unlock;
 			}
 			obuf[0] = msg[i].len;
 			obuf[1] = msg[i+1].len;
@@ -223,7 +226,8 @@ static int cxusb_i2c_xfer(struct i2c_adapter *adap, struct i2c_msg msg[],
 			if (2 + msg[i].len > sizeof(obuf)) {
 				warn("i2c wr: len=%d is too big!\n",
 				     msg[i].len);
-				return -EOPNOTSUPP;
+				ret = -EOPNOTSUPP;
+				goto unlock;
 			}
 			obuf[0] = msg[i].addr;
 			obuf[1] = msg[i].len;
@@ -236,9 +240,10 @@ static int cxusb_i2c_xfer(struct i2c_adapter *adap, struct i2c_msg msg[],
 				deb_i2c("i2c write may have failed\n");
 		}
 	}
-
+	ret = (i == num) ? num : -EREMOTEIO;
+unlock:
 	mutex_unlock(&d->i2c_mutex);
-	return i == num ? num : -EREMOTEIO;
+	return ret;
 }
 
 static u32 cxusb_i2c_func(struct i2c_adapter *adapter)
-- 
1.8.3.2

