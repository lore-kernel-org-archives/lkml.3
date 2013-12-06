Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1162733Ab3LFNfD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Dec 2013 08:35:03 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:44348 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161689Ab3LFNDN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Dec 2013 08:03:13 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 166/272] [media] dw2102: Don't use dynamic static allocation
Date: Fri,  6 Dec 2013 12:57:35 +0000
Message-Id: <1386334761-25517-167-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1386334761-25517-1-git-send-email-luis.henriques@canonical.com>
References: <1386334761-25517-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.1 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mauro Carvalho Chehab <m.chehab@samsung.com>

commit 0065a79a8698a953e4b201c5fce8db8940530578 upstream.

Dynamic static allocation is evil, as Kernel stack is too low, and
compilation complains about it on some archs:
	drivers/media/usb/dvb-usb/dw2102.c:368:1: warning: 'dw2102_earda_i2c_transfer' uses dynamic stack allocation [enabled by default]
	drivers/media/usb/dvb-usb/dw2102.c:449:1: warning: 'dw2104_i2c_transfer' uses dynamic stack allocation [enabled by default]
	drivers/media/usb/dvb-usb/dw2102.c:512:1: warning: 'dw3101_i2c_transfer' uses dynamic stack allocation [enabled by default]
	drivers/media/usb/dvb-usb/dw2102.c:621:1: warning: 's6x0_i2c_transfer' uses dynamic stack allocation [enabled by default]
Instead, let's enforce a limit for the buffer to be the max size of
a control URB payload data (64 bytes).

Signed-off-by: Mauro Carvalho Chehab <m.chehab@samsung.com>
Reviewed-by: Hans Verkuil <hans.verkuil@cisco.com>
Signed-off-by: Mauro Carvalho Chehab <m.chehab@samsung.com>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/media/usb/dvb-usb/dw2102.c | 90 +++++++++++++++++++++++++++++++++-----
 1 file changed, 80 insertions(+), 10 deletions(-)

diff --git a/drivers/media/usb/dvb-usb/dw2102.c b/drivers/media/usb/dvb-usb/dw2102.c
index 6e237b6..71b22f5 100644
--- a/drivers/media/usb/dvb-usb/dw2102.c
+++ b/drivers/media/usb/dvb-usb/dw2102.c
@@ -30,6 +30,9 @@
 #include "stb6100_proc.h"
 #include "m88rs2000.h"
 
+/* Max transfer size done by I2C transfer functions */
+#define MAX_XFER_SIZE  64
+
 #ifndef USB_PID_DW2102
 #define USB_PID_DW2102 0x2102
 #endif
@@ -308,7 +311,14 @@ static int dw2102_earda_i2c_transfer(struct i2c_adapter *adap, struct i2c_msg ms
 	case 2: {
 		/* read */
 		/* first write first register number */
-		u8 ibuf[msg[1].len + 2], obuf[3];
+		u8 ibuf[MAX_XFER_SIZE], obuf[3];
+
+		if (2 + msg[1].len > sizeof(ibuf)) {
+			warn("i2c rd: len=%d is too big!\n",
+			     msg[1].len);
+			return -EOPNOTSUPP;
+		}
+
 		obuf[0] = msg[0].addr << 1;
 		obuf[1] = msg[0].len;
 		obuf[2] = msg[0].buf[0];
@@ -325,7 +335,14 @@ static int dw2102_earda_i2c_transfer(struct i2c_adapter *adap, struct i2c_msg ms
 		switch (msg[0].addr) {
 		case 0x68: {
 			/* write to register */
-			u8 obuf[msg[0].len + 2];
+			u8 obuf[MAX_XFER_SIZE];
+
+			if (2 + msg[0].len > sizeof(obuf)) {
+				warn("i2c wr: len=%d is too big!\n",
+				     msg[1].len);
+				return -EOPNOTSUPP;
+			}
+
 			obuf[0] = msg[0].addr << 1;
 			obuf[1] = msg[0].len;
 			memcpy(obuf + 2, msg[0].buf, msg[0].len);
@@ -335,7 +352,14 @@ static int dw2102_earda_i2c_transfer(struct i2c_adapter *adap, struct i2c_msg ms
 		}
 		case 0x61: {
 			/* write to tuner */
-			u8 obuf[msg[0].len + 2];
+			u8 obuf[MAX_XFER_SIZE];
+
+			if (2 + msg[0].len > sizeof(obuf)) {
+				warn("i2c wr: len=%d is too big!\n",
+				     msg[1].len);
+				return -EOPNOTSUPP;
+			}
+
 			obuf[0] = msg[0].addr << 1;
 			obuf[1] = msg[0].len;
 			memcpy(obuf + 2, msg[0].buf, msg[0].len);
@@ -401,7 +425,14 @@ static int dw2104_i2c_transfer(struct i2c_adapter *adap, struct i2c_msg msg[], i
 		default: {
 			if (msg[j].flags == I2C_M_RD) {
 				/* read registers */
-				u8  ibuf[msg[j].len + 2];
+				u8  ibuf[MAX_XFER_SIZE];
+
+				if (2 + msg[j].len > sizeof(ibuf)) {
+					warn("i2c rd: len=%d is too big!\n",
+					     msg[j].len);
+					return -EOPNOTSUPP;
+				}
+
 				dw210x_op_rw(d->udev, 0xc3,
 						(msg[j].addr << 1) + 1, 0,
 						ibuf, msg[j].len + 2,
@@ -430,7 +461,14 @@ static int dw2104_i2c_transfer(struct i2c_adapter *adap, struct i2c_msg msg[], i
 				} while (len > 0);
 			} else {
 				/* write registers */
-				u8 obuf[msg[j].len + 2];
+				u8 obuf[MAX_XFER_SIZE];
+
+				if (2 + msg[j].len > sizeof(obuf)) {
+					warn("i2c wr: len=%d is too big!\n",
+					     msg[j].len);
+					return -EOPNOTSUPP;
+				}
+
 				obuf[0] = msg[j].addr << 1;
 				obuf[1] = msg[j].len;
 				memcpy(obuf + 2, msg[j].buf, msg[j].len);
@@ -463,7 +501,13 @@ static int dw3101_i2c_transfer(struct i2c_adapter *adap, struct i2c_msg msg[],
 	case 2: {
 		/* read */
 		/* first write first register number */
-		u8 ibuf[msg[1].len + 2], obuf[3];
+		u8 ibuf[MAX_XFER_SIZE], obuf[3];
+
+		if (2 + msg[1].len > sizeof(ibuf)) {
+			warn("i2c rd: len=%d is too big!\n",
+			     msg[1].len);
+			return -EOPNOTSUPP;
+		}
 		obuf[0] = msg[0].addr << 1;
 		obuf[1] = msg[0].len;
 		obuf[2] = msg[0].buf[0];
@@ -481,7 +525,13 @@ static int dw3101_i2c_transfer(struct i2c_adapter *adap, struct i2c_msg msg[],
 		case 0x60:
 		case 0x0c: {
 			/* write to register */
-			u8 obuf[msg[0].len + 2];
+			u8 obuf[MAX_XFER_SIZE];
+
+			if (2 + msg[0].len > sizeof(obuf)) {
+				warn("i2c wr: len=%d is too big!\n",
+				     msg[0].len);
+				return -EOPNOTSUPP;
+			}
 			obuf[0] = msg[0].addr << 1;
 			obuf[1] = msg[0].len;
 			memcpy(obuf + 2, msg[0].buf, msg[0].len);
@@ -563,7 +613,14 @@ static int s6x0_i2c_transfer(struct i2c_adapter *adap, struct i2c_msg msg[],
 		default: {
 			if (msg[j].flags == I2C_M_RD) {
 				/* read registers */
-				u8 ibuf[msg[j].len];
+				u8 ibuf[MAX_XFER_SIZE];
+
+				if (msg[j].len > sizeof(ibuf)) {
+					warn("i2c rd: len=%d is too big!\n",
+					     msg[j].len);
+					return -EOPNOTSUPP;
+				}
+
 				dw210x_op_rw(d->udev, 0x91, 0, 0,
 						ibuf, msg[j].len,
 						DW210X_READ_MSG);
@@ -590,7 +647,14 @@ static int s6x0_i2c_transfer(struct i2c_adapter *adap, struct i2c_msg msg[],
 				} while (len > 0);
 			} else if (j < (num - 1)) {
 				/* write register addr before read */
-				u8 obuf[msg[j].len + 2];
+				u8 obuf[MAX_XFER_SIZE];
+
+				if (2 + msg[j].len > sizeof(obuf)) {
+					warn("i2c wr: len=%d is too big!\n",
+					     msg[j].len);
+					return -EOPNOTSUPP;
+				}
+
 				obuf[0] = msg[j + 1].len;
 				obuf[1] = (msg[j].addr << 1);
 				memcpy(obuf + 2, msg[j].buf, msg[j].len);
@@ -602,7 +666,13 @@ static int s6x0_i2c_transfer(struct i2c_adapter *adap, struct i2c_msg msg[],
 				break;
 			} else {
 				/* write registers */
-				u8 obuf[msg[j].len + 2];
+				u8 obuf[MAX_XFER_SIZE];
+
+				if (2 + msg[j].len > sizeof(obuf)) {
+					warn("i2c wr: len=%d is too big!\n",
+					     msg[j].len);
+					return -EOPNOTSUPP;
+				}
 				obuf[0] = msg[j].len + 1;
 				obuf[1] = (msg[j].addr << 1);
 				memcpy(obuf + 2, msg[j].buf, msg[j].len);
-- 
1.8.3.2

