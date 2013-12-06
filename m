Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758389Ab3LFNgN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Dec 2013 08:36:13 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:44340 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161680Ab3LFNDK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Dec 2013 08:03:10 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 164/272] [media] af9035: Don't use dynamic static allocation
Date: Fri,  6 Dec 2013 12:57:33 +0000
Message-Id: <1386334761-25517-165-git-send-email-luis.henriques@canonical.com>
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
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/media/usb/dvb-usb-v2/af9035.c | 29 ++++++++++++++++++++++++++---
 1 file changed, 26 insertions(+), 3 deletions(-)

diff --git a/drivers/media/usb/dvb-usb-v2/af9035.c b/drivers/media/usb/dvb-usb-v2/af9035.c
index 1ea17dc..c8fcd78 100644
--- a/drivers/media/usb/dvb-usb-v2/af9035.c
+++ b/drivers/media/usb/dvb-usb-v2/af9035.c
@@ -21,6 +21,9 @@
 
 #include "af9035.h"
 
+/* Max transfer size done by I2C transfer functions */
+#define MAX_XFER_SIZE  64
+
 DVB_DEFINE_MOD_OPT_ADAPTER_NR(adapter_nr);
 
 static u16 af9035_checksum(const u8 *buf, size_t len)
@@ -126,10 +129,16 @@ exit:
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
@@ -228,9 +237,16 @@ static int af9035_i2c_master_xfer(struct i2c_adapter *adap,
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
@@ -257,9 +273,16 @@ static int af9035_i2c_master_xfer(struct i2c_adapter *adap,
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
-- 
1.8.3.2

