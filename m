Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755389Ab3LRWIy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Dec 2013 17:08:54 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:35971 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753022Ab3LRVMI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Dec 2013 16:12:08 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Antti Palosaari <crope@iki.fi>,
        Mauro Carvalho Chehab <mchehab@redhat.com>
Subject: [PATCH 3.10 32/78] media: af9035: fix broken I2C and USB I/O
Date: Wed, 18 Dec 2013 13:11:00 -0800
Message-Id: <20131218211112.815397660@linuxfoundation.org>
X-Mailer: git-send-email 1.8.5.1.163.gd7aced9
In-Reply-To: <20131218211111.903835960@linuxfoundation.org>
References: <20131218211111.903835960@linuxfoundation.org>
User-Agent: quilt/0.61-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Antti Palosaari <crope@iki.fi>

commit 9323297dc0ea9141f8099e474657391bb3ad98f8 upstream.

There was three small buffer len calculation bugs which caused
driver non-working. These are coming from recent commit:
commit 7760e148350bf6df95662bc0db3734e9d991cb03
[media] af9035: Don't use dynamic static allocation

Signed-off-by: Antti Palosaari <crope@iki.fi>
Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/media/usb/dvb-usb-v2/af9035.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/drivers/media/usb/dvb-usb-v2/af9035.c
+++ b/drivers/media/usb/dvb-usb-v2/af9035.c
@@ -130,7 +130,7 @@ static int af9035_wr_regs(struct dvb_usb
 {
 	u8 wbuf[MAX_XFER_SIZE];
 	u8 mbox = (reg >> 16) & 0xff;
-	struct usb_req req = { CMD_MEM_WR, mbox, sizeof(wbuf), wbuf, 0, NULL };
+	struct usb_req req = { CMD_MEM_WR, mbox, 6 + len, wbuf, 0, NULL };
 
 	if (6 + len > sizeof(wbuf)) {
 		dev_warn(&d->udev->dev, "%s: i2c wr: len=%d is too big!\n",
@@ -237,7 +237,7 @@ static int af9035_i2c_master_xfer(struct
 		} else {
 			/* I2C */
 			u8 buf[MAX_XFER_SIZE];
-			struct usb_req req = { CMD_I2C_RD, 0, sizeof(buf),
+			struct usb_req req = { CMD_I2C_RD, 0, 5 + msg[0].len,
 					buf, msg[1].len, msg[1].buf };
 
 			if (5 + msg[0].len > sizeof(buf)) {
@@ -273,8 +273,8 @@ static int af9035_i2c_master_xfer(struct
 		} else {
 			/* I2C */
 			u8 buf[MAX_XFER_SIZE];
-			struct usb_req req = { CMD_I2C_WR, 0, sizeof(buf), buf,
-					0, NULL };
+			struct usb_req req = { CMD_I2C_WR, 0, 5 + msg[0].len,
+					buf, 0, NULL };
 
 			if (5 + msg[0].len > sizeof(buf)) {
 				dev_warn(&d->udev->dev,


