Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755665Ab3LSL6y (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Dec 2013 06:58:54 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:45141 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755624Ab3LSL6w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Dec 2013 06:58:52 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Antti Palosaari <crope@iki.fi>, Mauro Carvalho Chehab <mchehab@redhat.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 148/208] [media] af9035: fix broken I2C and USB I/O
Date: Thu, 19 Dec 2013 11:54:06 +0000
Message-Id: <1387454106-19326-149-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1387454106-19326-1-git-send-email-luis.henriques@canonical.com>
References: <1387454106-19326-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.2 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Antti Palosaari <crope@iki.fi>

commit 9323297dc0ea9141f8099e474657391bb3ad98f8 upstream.

There was three small buffer len calculation bugs which caused
driver non-working. These are coming from recent commit:
commit 7760e148350bf6df95662bc0db3734e9d991cb03
[media] af9035: Don't use dynamic static allocation

Signed-off-by: Antti Palosaari <crope@iki.fi>
Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/media/usb/dvb-usb-v2/af9035.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/media/usb/dvb-usb-v2/af9035.c b/drivers/media/usb/dvb-usb-v2/af9035.c
index 798565c..4453b0b 100644
--- a/drivers/media/usb/dvb-usb-v2/af9035.c
+++ b/drivers/media/usb/dvb-usb-v2/af9035.c
@@ -131,7 +131,7 @@ static int af9035_wr_regs(struct dvb_usb_device *d, u32 reg, u8 *val, int len)
 {
 	u8 wbuf[MAX_XFER_SIZE];
 	u8 mbox = (reg >> 16) & 0xff;
-	struct usb_req req = { CMD_MEM_WR, mbox, sizeof(wbuf), wbuf, 0, NULL };
+	struct usb_req req = { CMD_MEM_WR, mbox, 6 + len, wbuf, 0, NULL };
 
 	if (6 + len > sizeof(wbuf)) {
 		dev_warn(&d->udev->dev, "%s: i2c wr: len=%d is too big!\n",
@@ -238,7 +238,7 @@ static int af9035_i2c_master_xfer(struct i2c_adapter *adap,
 		} else {
 			/* I2C */
 			u8 buf[MAX_XFER_SIZE];
-			struct usb_req req = { CMD_I2C_RD, 0, sizeof(buf),
+			struct usb_req req = { CMD_I2C_RD, 0, 5 + msg[0].len,
 					buf, msg[1].len, msg[1].buf };
 
 			if (5 + msg[0].len > sizeof(buf)) {
@@ -274,8 +274,8 @@ static int af9035_i2c_master_xfer(struct i2c_adapter *adap,
 		} else {
 			/* I2C */
 			u8 buf[MAX_XFER_SIZE];
-			struct usb_req req = { CMD_I2C_WR, 0, sizeof(buf), buf,
-					0, NULL };
+			struct usb_req req = { CMD_I2C_WR, 0, 5 + msg[0].len,
+					buf, 0, NULL };
 
 			if (5 + msg[0].len > sizeof(buf)) {
 				dev_warn(&d->udev->dev,
-- 
1.8.3.2

