Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755691Ab3LBTcq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Dec 2013 14:32:46 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:39701 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755019Ab3LBTTF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Dec 2013 14:19:05 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Mauro Carvalho Chehab <m.chehab@samsung.com>,
        Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCH 3.12 192/212] media: cxusb: Dont use dynamic static allocation
Date: Mon,  2 Dec 2013 11:16:23 -0800
Message-Id: <20131202191310.332706624@linuxfoundation.org>
X-Mailer: git-send-email 1.8.4.3.gca3854a
In-Reply-To: <20131202191248.517975703@linuxfoundation.org>
References: <20131202191248.517975703@linuxfoundation.org>
User-Agent: quilt/0.60-8.1.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mauro Carvalho Chehab <m.chehab@samsung.com>

commit 64f7ef8afbf89f3c72c4d2472e4914ca198c0668 upstream.

Dynamic static allocation is evil, as Kernel stack is too low, and
compilation complains about it on some archs:
	drivers/media/usb/dvb-usb/cxusb.c:209:1: warning: 'cxusb_i2c_xfer' uses dynamic stack allocation [enabled by default]
	drivers/media/usb/dvb-usb/cxusb.c:69:1: warning: 'cxusb_ctrl_msg' uses dynamic stack allocation [enabled by default]
Instead, let's enforce a limit for the buffer to be the max size of
a control URB payload data (64 bytes).

Signed-off-by: Mauro Carvalho Chehab <m.chehab@samsung.com>
Reviewed-by: Hans Verkuil <hans.verkuil@cisco.com>
Signed-off-by: Mauro Carvalho Chehab <m.chehab@samsung.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/media/usb/dvb-usb/cxusb.c |   41 ++++++++++++++++++++++++++++++++++----
 1 file changed, 37 insertions(+), 4 deletions(-)

--- a/drivers/media/usb/dvb-usb/cxusb.c
+++ b/drivers/media/usb/dvb-usb/cxusb.c
@@ -43,6 +43,9 @@
 #include "lgs8gxx.h"
 #include "atbm8830.h"
 
+/* Max transfer size done by I2C transfer functions */
+#define MAX_XFER_SIZE  64
+
 /* debug */
 static int dvb_usb_cxusb_debug;
 module_param_named(debug, dvb_usb_cxusb_debug, int, 0644);
@@ -57,7 +60,14 @@ static int cxusb_ctrl_msg(struct dvb_usb
 			  u8 cmd, u8 *wbuf, int wlen, u8 *rbuf, int rlen)
 {
 	int wo = (rbuf == NULL || rlen == 0); /* write-only */
-	u8 sndbuf[1+wlen];
+	u8 sndbuf[MAX_XFER_SIZE];
+
+	if (1 + wlen > sizeof(sndbuf)) {
+		warn("i2c wr: len=%d is too big!\n",
+		     wlen);
+		return -EOPNOTSUPP;
+	}
+
 	memset(sndbuf, 0, 1+wlen);
 
 	sndbuf[0] = cmd;
@@ -158,7 +168,13 @@ static int cxusb_i2c_xfer(struct i2c_ada
 
 		if (msg[i].flags & I2C_M_RD) {
 			/* read only */
-			u8 obuf[3], ibuf[1+msg[i].len];
+			u8 obuf[3], ibuf[MAX_XFER_SIZE];
+
+			if (1 + msg[i].len > sizeof(ibuf)) {
+				warn("i2c rd: len=%d is too big!\n",
+				     msg[i].len);
+				return -EOPNOTSUPP;
+			}
 			obuf[0] = 0;
 			obuf[1] = msg[i].len;
 			obuf[2] = msg[i].addr;
@@ -172,7 +188,18 @@ static int cxusb_i2c_xfer(struct i2c_ada
 		} else if (i+1 < num && (msg[i+1].flags & I2C_M_RD) &&
 			   msg[i].addr == msg[i+1].addr) {
 			/* write to then read from same address */
-			u8 obuf[3+msg[i].len], ibuf[1+msg[i+1].len];
+			u8 obuf[MAX_XFER_SIZE], ibuf[MAX_XFER_SIZE];
+
+			if (3 + msg[i].len > sizeof(obuf)) {
+				warn("i2c wr: len=%d is too big!\n",
+				     msg[i].len);
+				return -EOPNOTSUPP;
+			}
+			if (1 + msg[i + 1].len > sizeof(ibuf)) {
+				warn("i2c rd: len=%d is too big!\n",
+				     msg[i + 1].len);
+				return -EOPNOTSUPP;
+			}
 			obuf[0] = msg[i].len;
 			obuf[1] = msg[i+1].len;
 			obuf[2] = msg[i].addr;
@@ -191,7 +218,13 @@ static int cxusb_i2c_xfer(struct i2c_ada
 			i++;
 		} else {
 			/* write only */
-			u8 obuf[2+msg[i].len], ibuf;
+			u8 obuf[MAX_XFER_SIZE], ibuf;
+
+			if (2 + msg[i].len > sizeof(obuf)) {
+				warn("i2c wr: len=%d is too big!\n",
+				     msg[i].len);
+				return -EOPNOTSUPP;
+			}
 			obuf[0] = msg[i].addr;
 			obuf[1] = msg[i].len;
 			memcpy(&obuf[2], msg[i].buf, msg[i].len);


