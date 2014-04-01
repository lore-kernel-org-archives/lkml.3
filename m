Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753292AbaDALYt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Apr 2014 07:24:49 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:42771 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751903AbaDALTE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Apr 2014 07:19:04 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Dan Carpenter <dan.carpenter@oracle.com>,
        Mauro Carvalho Chehab <m.chehab@samsung.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 134/144] [media] cxusb: unlock on error in cxusb_i2c_xfer()
Date: Tue,  1 Apr 2014 12:15:38 +0100
Message-Id: <1396350948-29910-135-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1396350948-29910-1-git-send-email-luis.henriques@canonical.com>
References: <1396350948-29910-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.7 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dan Carpenter <dan.carpenter@oracle.com>

commit 1cdbcc5db4e6d51ce9bb1313195167cada9aa6e9 upstream.

We recently introduced some new error paths which are missing their
unlocks.
Fixes: 64f7ef8afbf8 ('[media] cxusb: Don't use dynamic static allocation')

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Mauro Carvalho Chehab <m.chehab@samsung.com>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/media/usb/dvb-usb/cxusb.c | 21 ++++++++++++++++-----
 1 file changed, 16 insertions(+), 5 deletions(-)

diff --git a/drivers/media/usb/dvb-usb/cxusb.c b/drivers/media/usb/dvb-usb/cxusb.c
index 20e345d..a1c641e 100644
--- a/drivers/media/usb/dvb-usb/cxusb.c
+++ b/drivers/media/usb/dvb-usb/cxusb.c
@@ -149,6 +149,7 @@ static int cxusb_i2c_xfer(struct i2c_adapter *adap, struct i2c_msg msg[],
 			  int num)
 {
 	struct dvb_usb_device *d = i2c_get_adapdata(adap);
+	int ret;
 	int i;
 
 	if (mutex_lock_interruptible(&d->i2c_mutex) < 0)
@@ -173,7 +174,8 @@ static int cxusb_i2c_xfer(struct i2c_adapter *adap, struct i2c_msg msg[],
 			if (1 + msg[i].len > sizeof(ibuf)) {
 				warn("i2c rd: len=%d is too big!\n",
 				     msg[i].len);
-				return -EOPNOTSUPP;
+				ret = -EOPNOTSUPP;
+				goto unlock;
 			}
 			obuf[0] = 0;
 			obuf[1] = msg[i].len;
@@ -193,12 +195,14 @@ static int cxusb_i2c_xfer(struct i2c_adapter *adap, struct i2c_msg msg[],
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
@@ -223,7 +227,8 @@ static int cxusb_i2c_xfer(struct i2c_adapter *adap, struct i2c_msg msg[],
 			if (2 + msg[i].len > sizeof(obuf)) {
 				warn("i2c wr: len=%d is too big!\n",
 				     msg[i].len);
-				return -EOPNOTSUPP;
+				ret = -EOPNOTSUPP;
+				goto unlock;
 			}
 			obuf[0] = msg[i].addr;
 			obuf[1] = msg[i].len;
@@ -237,8 +242,14 @@ static int cxusb_i2c_xfer(struct i2c_adapter *adap, struct i2c_msg msg[],
 		}
 	}
 
+	if (i == num)
+		ret = num;
+	else
+		ret = -EREMOTEIO;
+
+unlock:
 	mutex_unlock(&d->i2c_mutex);
-	return i == num ? num : -EREMOTEIO;
+	return ret;
 }
 
 static u32 cxusb_i2c_func(struct i2c_adapter *adapter)
-- 
1.9.1

