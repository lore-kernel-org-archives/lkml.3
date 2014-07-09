Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932220AbaGINVd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2014 09:21:33 -0400
Received: from qmta07.emeryville.ca.mail.comcast.net ([76.96.30.64]:51741 "EHLO
	qmta07.emeryville.ca.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932165AbaGINVb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2014 09:21:31 -0400
From: Shuah Khan <shuah.kh@samsung.com>
To: m.chehab@samsung.com, crope@iki.fi
Cc: Shuah Khan <shuah.kh@samsung.com>, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] media: em28xx-dvb - fix em28xx_dvb_resume() to not unregister i2c and dvb
Date: Wed,  9 Jul 2014 07:21:27 -0600
Message-Id: <1404912087-22028-1-git-send-email-shuah.kh@samsung.com>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

em28xx_dvb_resume() unregisters i2c tuner, i2c demod, and dvb.
This erroneous cleanup results in i2c tuner, i2c demod, and dvb
devices unregistered and removed during resume. This error is a
result of merge conflict between two patches that went into 3.15.

Signed-off-by: Shuah Khan <shuah.kh@samsung.com>
---
 drivers/media/usb/em28xx/em28xx-dvb.c |   17 -----------------
 1 file changed, 17 deletions(-)

diff --git a/drivers/media/usb/em28xx/em28xx-dvb.c b/drivers/media/usb/em28xx/em28xx-dvb.c
index a121ed9..d381861 100644
--- a/drivers/media/usb/em28xx/em28xx-dvb.c
+++ b/drivers/media/usb/em28xx/em28xx-dvb.c
@@ -1712,7 +1712,6 @@ static int em28xx_dvb_resume(struct em28xx *dev)
 	em28xx_info("Resuming DVB extension");
 	if (dev->dvb) {
 		struct em28xx_dvb *dvb = dev->dvb;
-		struct i2c_client *client = dvb->i2c_client_tuner;
 
 		if (dvb->fe[0]) {
 			ret = dvb_frontend_resume(dvb->fe[0]);
@@ -1723,22 +1722,6 @@ static int em28xx_dvb_resume(struct em28xx *dev)
 			ret = dvb_frontend_resume(dvb->fe[1]);
 			em28xx_info("fe1 resume %d", ret);
 		}
-		/* remove I2C tuner */
-		if (client) {
-			module_put(client->dev.driver->owner);
-			i2c_unregister_device(client);
-		}
-
-		/* remove I2C demod */
-		client = dvb->i2c_client_demod;
-		if (client) {
-			module_put(client->dev.driver->owner);
-			i2c_unregister_device(client);
-		}
-
-		em28xx_unregister_dvb(dvb);
-		kfree(dvb);
-		dev->dvb = NULL;
 	}
 
 	return 0;
-- 
1.7.10.4

