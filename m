Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755568AbaG3B7h (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jul 2014 21:59:37 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:60647 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755136AbaG3BuD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jul 2014 21:50:03 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Antti Palosaari <crope@iki.fi>,
        Mauro Carvalho Chehab <m.chehab@samsung.com>
Subject: [PATCH 3.15 03/37] media: af9035: override tuner id when bad value set into eeprom
Date: Tue, 29 Jul 2014 18:48:39 -0700
Message-Id: <20140730014827.760224199@linuxfoundation.org>
X-Mailer: git-send-email 2.0.3
In-Reply-To: <20140730014827.565626091@linuxfoundation.org>
References: <20140730014827.565626091@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Antti Palosaari <crope@iki.fi>

commit 1cbbf90d0406913ad4b44194b07f4f41bde84e54 upstream.

Tuner ID set into EEPROM is wrong in some cases, which causes driver
to select wrong tuner profile. That leads device non-working. Fix
issue by overriding known bad tuner IDs with suitable default value.

Thanks to MX-NET Telekomunikace s.r.o. for providing non-working
DTV stick, that I could fix the bug!

Signed-off-by: Antti Palosaari <crope@iki.fi>
Signed-off-by: Mauro Carvalho Chehab <m.chehab@samsung.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/media/usb/dvb-usb-v2/af9035.c |   40 ++++++++++++++++++++++++++++------
 1 file changed, 33 insertions(+), 7 deletions(-)

--- a/drivers/media/usb/dvb-usb-v2/af9035.c
+++ b/drivers/media/usb/dvb-usb-v2/af9035.c
@@ -704,15 +704,41 @@ static int af9035_read_config(struct dvb
 		if (ret < 0)
 			goto err;
 
-		if (tmp == 0x00)
-			dev_dbg(&d->udev->dev,
-					"%s: [%d]tuner not set, using default\n",
-					__func__, i);
-		else
+		dev_dbg(&d->udev->dev, "%s: [%d]tuner=%02x\n",
+				__func__, i, tmp);
+
+		/* tuner sanity check */
+		if (state->chip_type == 0x9135) {
+			if (state->chip_version == 0x02) {
+				/* IT9135 BX (v2) */
+				switch (tmp) {
+				case AF9033_TUNER_IT9135_60:
+				case AF9033_TUNER_IT9135_61:
+				case AF9033_TUNER_IT9135_62:
+					state->af9033_config[i].tuner = tmp;
+					break;
+				}
+			} else {
+				/* IT9135 AX (v1) */
+				switch (tmp) {
+				case AF9033_TUNER_IT9135_38:
+				case AF9033_TUNER_IT9135_51:
+				case AF9033_TUNER_IT9135_52:
+					state->af9033_config[i].tuner = tmp;
+					break;
+				}
+			}
+		} else {
+			/* AF9035 */
 			state->af9033_config[i].tuner = tmp;
+		}
 
-		dev_dbg(&d->udev->dev, "%s: [%d]tuner=%02x\n",
-				__func__, i, state->af9033_config[i].tuner);
+		if (state->af9033_config[i].tuner != tmp) {
+			dev_info(&d->udev->dev,
+					"%s: [%d] overriding tuner from %02x to %02x\n",
+					KBUILD_MODNAME, i, tmp,
+					state->af9033_config[i].tuner);
+		}
 
 		switch (state->af9033_config[i].tuner) {
 		case AF9033_TUNER_TUA9001:


