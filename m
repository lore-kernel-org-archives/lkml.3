Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753641Ab3LBTOe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Dec 2013 14:14:34 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:38798 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754327Ab3LBTOT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Dec 2013 14:14:19 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Mauro Carvalho Chehab <m.chehab@samsung.com>,
        Hans Verkuil <hans.verkuil@cisco.com>, Antti Palosaari <crope@iki.fi>
Subject: [PATCH 3.10 141/173] media: af9035: Dont use dynamic static allocation
Date: Mon,  2 Dec 2013 11:12:04 -0800
Message-Id: <20131202191159.581312456@linuxfoundation.org>
X-Mailer: git-send-email 1.8.4.3.gca3854a
In-Reply-To: <20131202191142.873808297@linuxfoundation.org>
References: <20131202191142.873808297@linuxfoundation.org>
User-Agent: quilt/0.60-8.1.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mauro Carvalho Chehab <m.chehab@samsung.com>

commit 7760e148350bf6df95662bc0db3734e9d991cb03 upstream.

Dynamic static allocation is evil, as Kernel stack is too low, and
compilation complains about it on some archs:
	drivers/media/usb/dvb-usb-v2/af9035.c:142:1: warning: 'af9035_wr_regs' uses dynamic stack allocation [enabled by default]
	drivers/media/usb/dvb-usb-v2/af9035.c:305:1: warning: 'af9035_i2c_master_xfer' uses dynamic stack allocation [enabled by default]
Instead, let's enforce a limit for the buffer to be the max size of
a control URB payload data (64 bytes).

Signed-off-by: Mauro Carvalho Chehab <m.chehab@samsung.com>
Reviewed-by: Hans Verkuil <hans.verkuil@cisco.com>
Reviewed-by: Antti Palosaari <crope@iki.fi>
Signed-off-by: Mauro Carvalho Chehab <m.chehab@samsung.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/media/usb/dvb-usb-v2/af9035.c |   29 ++++++++++++++++++++++++++---
 1 file changed, 26 insertions(+), 3 deletions(-)

--- a/drivers/media/usb/dvb-usb-v2/af9035.c
+++ b/drivers/media/usb/dvb-usb-v2/af9035.c
@@ -21,6 +21,9 @@
 
 #include "af9035.h"
 
+/* Max transfer size done by I2C transfer functions */
+#define MAX_XFER_SIZE  64
+
 DVB_DEFINE_MOD_OPT_ADAPTER_NR(adapter_nr);
 
 static u16 af9035_checksum(const u8 *buf, size_t len)
@@ -125,10 +128,16 @@ exit:
 /* write multiple registers */
 static int af9035_wr_regs(struct dvb_usb_device *d, u32 reg, u8 *val, int len)
 {
-	u8 wbuf[6 + len];
+	u8 wbuf[MAX_XFER_SIZE];
 	u8 mbox = (reg >> 16) & 0xff;
 	struct usb_req req = { CMD_MEM_WR, mbox, sizeof(wbuf), wbuf, 0, NULL };
 
+	if (6 + len > sizeof(wbuf)) {
+		dev_warn(&d->udev->dev, "%s: i2c wr: len=%d is too big!\n",
+			 KBUILD_MODNAME, len);
+		return -EOPNOTSUPP;
+	}
+
 	wbuf[0] = len;
 	wbuf[1] = 2;
 	wbuf[2] = 0;
@@ -227,9 +236,16 @@ static int af9035_i2c_master_xfer(struct
 					msg[1].len);
 		} else {
 			/* I2C */
-			u8 buf[5 + msg[0].len];
+			u8 buf[MAX_XFER_SIZE];
 			struct usb_req req = { CMD_I2C_RD, 0, sizeof(buf),
 					buf, msg[1].len, msg[1].buf };
+
+			if (5 + msg[0].len > sizeof(buf)) {
+				dev_warn(&d->udev->dev,
+					 "%s: i2c xfer: len=%d is too big!\n",
+					 KBUILD_MODNAME, msg[0].len);
+				return -EOPNOTSUPP;
+			}
 			req.mbox |= ((msg[0].addr & 0x80)  >>  3);
 			buf[0] = msg[1].len;
 			buf[1] = msg[0].addr << 1;
@@ -256,9 +272,16 @@ static int af9035_i2c_master_xfer(struct
 					msg[0].len - 3);
 		} else {
 			/* I2C */
-			u8 buf[5 + msg[0].len];
+			u8 buf[MAX_XFER_SIZE];
 			struct usb_req req = { CMD_I2C_WR, 0, sizeof(buf), buf,
 					0, NULL };
+
+			if (5 + msg[0].len > sizeof(buf)) {
+				dev_warn(&d->udev->dev,
+					 "%s: i2c xfer: len=%d is too big!\n",
+					 KBUILD_MODNAME, msg[0].len);
+				return -EOPNOTSUPP;
+			}
 			req.mbox |= ((msg[0].addr & 0x80)  >>  3);
 			buf[0] = msg[0].len;
 			buf[1] = msg[0].addr << 1;


