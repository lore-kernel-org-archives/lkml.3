Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752162AbaDALTL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Apr 2014 07:19:11 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:42779 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753025AbaDALTG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Apr 2014 07:19:06 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Dan Carpenter <dan.carpenter@oracle.com>,
        Mauro Carvalho Chehab <m.chehab@samsung.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 136/144] [media] dw2102: some missing unlocks on error
Date: Tue,  1 Apr 2014 12:15:40 +0100
Message-Id: <1396350948-29910-137-git-send-email-luis.henriques@canonical.com>
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

commit 324ed533bf0b23c309b805272c4ffcc5d51493a6 upstream.

We recently introduced some new error paths but the unlocks are missing.
Fixes: 0065a79a8698 ('[media] dw2102: Don't use dynamic static allocation')

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Mauro Carvalho Chehab <m.chehab@samsung.com>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/media/usb/dvb-usb/dw2102.c | 52 ++++++++++++++++++++++++++------------
 1 file changed, 36 insertions(+), 16 deletions(-)

diff --git a/drivers/media/usb/dvb-usb/dw2102.c b/drivers/media/usb/dvb-usb/dw2102.c
index 71b22f5..4170a45 100644
--- a/drivers/media/usb/dvb-usb/dw2102.c
+++ b/drivers/media/usb/dvb-usb/dw2102.c
@@ -301,6 +301,7 @@ static int dw2102_serit_i2c_transfer(struct i2c_adapter *adap,
 static int dw2102_earda_i2c_transfer(struct i2c_adapter *adap, struct i2c_msg msg[], int num)
 {
 	struct dvb_usb_device *d = i2c_get_adapdata(adap);
+	int ret;
 
 	if (!d)
 		return -ENODEV;
@@ -316,7 +317,8 @@ static int dw2102_earda_i2c_transfer(struct i2c_adapter *adap, struct i2c_msg ms
 		if (2 + msg[1].len > sizeof(ibuf)) {
 			warn("i2c rd: len=%d is too big!\n",
 			     msg[1].len);
-			return -EOPNOTSUPP;
+			ret = -EOPNOTSUPP;
+			goto unlock;
 		}
 
 		obuf[0] = msg[0].addr << 1;
@@ -340,7 +342,8 @@ static int dw2102_earda_i2c_transfer(struct i2c_adapter *adap, struct i2c_msg ms
 			if (2 + msg[0].len > sizeof(obuf)) {
 				warn("i2c wr: len=%d is too big!\n",
 				     msg[1].len);
-				return -EOPNOTSUPP;
+				ret = -EOPNOTSUPP;
+				goto unlock;
 			}
 
 			obuf[0] = msg[0].addr << 1;
@@ -357,7 +360,8 @@ static int dw2102_earda_i2c_transfer(struct i2c_adapter *adap, struct i2c_msg ms
 			if (2 + msg[0].len > sizeof(obuf)) {
 				warn("i2c wr: len=%d is too big!\n",
 				     msg[1].len);
-				return -EOPNOTSUPP;
+				ret = -EOPNOTSUPP;
+				goto unlock;
 			}
 
 			obuf[0] = msg[0].addr << 1;
@@ -386,15 +390,17 @@ static int dw2102_earda_i2c_transfer(struct i2c_adapter *adap, struct i2c_msg ms
 
 		break;
 	}
+	ret = num;
 
+unlock:
 	mutex_unlock(&d->i2c_mutex);
-	return num;
+	return ret;
 }
 
 static int dw2104_i2c_transfer(struct i2c_adapter *adap, struct i2c_msg msg[], int num)
 {
 	struct dvb_usb_device *d = i2c_get_adapdata(adap);
-	int len, i, j;
+	int len, i, j, ret;
 
 	if (!d)
 		return -ENODEV;
@@ -430,7 +436,8 @@ static int dw2104_i2c_transfer(struct i2c_adapter *adap, struct i2c_msg msg[], i
 				if (2 + msg[j].len > sizeof(ibuf)) {
 					warn("i2c rd: len=%d is too big!\n",
 					     msg[j].len);
-					return -EOPNOTSUPP;
+					ret = -EOPNOTSUPP;
+					goto unlock;
 				}
 
 				dw210x_op_rw(d->udev, 0xc3,
@@ -466,7 +473,8 @@ static int dw2104_i2c_transfer(struct i2c_adapter *adap, struct i2c_msg msg[], i
 				if (2 + msg[j].len > sizeof(obuf)) {
 					warn("i2c wr: len=%d is too big!\n",
 					     msg[j].len);
-					return -EOPNOTSUPP;
+					ret = -EOPNOTSUPP;
+					goto unlock;
 				}
 
 				obuf[0] = msg[j].addr << 1;
@@ -481,15 +489,18 @@ static int dw2104_i2c_transfer(struct i2c_adapter *adap, struct i2c_msg msg[], i
 		}
 
 	}
+	ret = num;
 
+unlock:
 	mutex_unlock(&d->i2c_mutex);
-	return num;
+	return ret;
 }
 
 static int dw3101_i2c_transfer(struct i2c_adapter *adap, struct i2c_msg msg[],
 								int num)
 {
 	struct dvb_usb_device *d = i2c_get_adapdata(adap);
+	int ret;
 	int i;
 
 	if (!d)
@@ -506,7 +517,8 @@ static int dw3101_i2c_transfer(struct i2c_adapter *adap, struct i2c_msg msg[],
 		if (2 + msg[1].len > sizeof(ibuf)) {
 			warn("i2c rd: len=%d is too big!\n",
 			     msg[1].len);
-			return -EOPNOTSUPP;
+			ret = -EOPNOTSUPP;
+			goto unlock;
 		}
 		obuf[0] = msg[0].addr << 1;
 		obuf[1] = msg[0].len;
@@ -530,7 +542,8 @@ static int dw3101_i2c_transfer(struct i2c_adapter *adap, struct i2c_msg msg[],
 			if (2 + msg[0].len > sizeof(obuf)) {
 				warn("i2c wr: len=%d is too big!\n",
 				     msg[0].len);
-				return -EOPNOTSUPP;
+				ret = -EOPNOTSUPP;
+				goto unlock;
 			}
 			obuf[0] = msg[0].addr << 1;
 			obuf[1] = msg[0].len;
@@ -556,9 +569,11 @@ static int dw3101_i2c_transfer(struct i2c_adapter *adap, struct i2c_msg msg[],
 				msg[i].flags == 0 ? ">>>" : "<<<");
 		debug_dump(msg[i].buf, msg[i].len, deb_xfer);
 	}
+	ret = num;
 
+unlock:
 	mutex_unlock(&d->i2c_mutex);
-	return num;
+	return ret;
 }
 
 static int s6x0_i2c_transfer(struct i2c_adapter *adap, struct i2c_msg msg[],
@@ -566,7 +581,7 @@ static int s6x0_i2c_transfer(struct i2c_adapter *adap, struct i2c_msg msg[],
 {
 	struct dvb_usb_device *d = i2c_get_adapdata(adap);
 	struct usb_device *udev;
-	int len, i, j;
+	int len, i, j, ret;
 
 	if (!d)
 		return -ENODEV;
@@ -618,7 +633,8 @@ static int s6x0_i2c_transfer(struct i2c_adapter *adap, struct i2c_msg msg[],
 				if (msg[j].len > sizeof(ibuf)) {
 					warn("i2c rd: len=%d is too big!\n",
 					     msg[j].len);
-					return -EOPNOTSUPP;
+					ret = -EOPNOTSUPP;
+					goto unlock;
 				}
 
 				dw210x_op_rw(d->udev, 0x91, 0, 0,
@@ -652,7 +668,8 @@ static int s6x0_i2c_transfer(struct i2c_adapter *adap, struct i2c_msg msg[],
 				if (2 + msg[j].len > sizeof(obuf)) {
 					warn("i2c wr: len=%d is too big!\n",
 					     msg[j].len);
-					return -EOPNOTSUPP;
+					ret = -EOPNOTSUPP;
+					goto unlock;
 				}
 
 				obuf[0] = msg[j + 1].len;
@@ -671,7 +688,8 @@ static int s6x0_i2c_transfer(struct i2c_adapter *adap, struct i2c_msg msg[],
 				if (2 + msg[j].len > sizeof(obuf)) {
 					warn("i2c wr: len=%d is too big!\n",
 					     msg[j].len);
-					return -EOPNOTSUPP;
+					ret = -EOPNOTSUPP;
+					goto unlock;
 				}
 				obuf[0] = msg[j].len + 1;
 				obuf[1] = (msg[j].addr << 1);
@@ -685,9 +703,11 @@ static int s6x0_i2c_transfer(struct i2c_adapter *adap, struct i2c_msg msg[],
 		}
 		}
 	}
+	ret = num;
 
+unlock:
 	mutex_unlock(&d->i2c_mutex);
-	return num;
+	return ret;
 }
 
 static int su3000_i2c_transfer(struct i2c_adapter *adap, struct i2c_msg msg[],
-- 
1.9.1

