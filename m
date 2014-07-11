Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754591AbaGKPpc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jul 2014 11:45:32 -0400
Received: from qmta05.emeryville.ca.mail.comcast.net ([76.96.30.48]:49428 "EHLO
	qmta05.emeryville.ca.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753503AbaGKPp3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jul 2014 11:45:29 -0400
From: Shuah Khan <shuah.kh@samsung.com>
To: m.chehab@samsung.com, crope@iki.fi
Cc: Shuah Khan <shuah.kh@samsung.com>, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] media: em28xx-dvb unregister i2c tuner and demod after fe detach
Date: Fri, 11 Jul 2014 09:45:25 -0600
Message-Id: <1405093525-8745-1-git-send-email-shuah.kh@samsung.com>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

i2c tuner and demod are unregisetred in .fini before fe detach.
dvb_unregister_frontend() and dvb_frontend_detach() invoke tuner
sleep() and release() interfaces. Change to unregister i2c tuner
and demod from em28xx_unregister_dvb() after unregistering dvb
and detaching fe.

Signed-off-by: Shuah Khan <shuah.kh@samsung.com>
---
 drivers/media/usb/em28xx/em28xx-dvb.c |   32 +++++++++++++++++---------------
 1 file changed, 17 insertions(+), 15 deletions(-)

diff --git a/drivers/media/usb/em28xx/em28xx-dvb.c b/drivers/media/usb/em28xx/em28xx-dvb.c
index 8314f51..8d5cb62 100644
--- a/drivers/media/usb/em28xx/em28xx-dvb.c
+++ b/drivers/media/usb/em28xx/em28xx-dvb.c
@@ -1030,6 +1030,8 @@ fail_adapter:
 
 static void em28xx_unregister_dvb(struct em28xx_dvb *dvb)
 {
+	struct i2c_client *client;
+
 	dvb_net_release(&dvb->net);
 	dvb->demux.dmx.remove_frontend(&dvb->demux.dmx, &dvb->fe_mem);
 	dvb->demux.dmx.remove_frontend(&dvb->demux.dmx, &dvb->fe_hw);
@@ -1041,6 +1043,21 @@ static void em28xx_unregister_dvb(struct em28xx_dvb *dvb)
 	if (dvb->fe[1] && !dvb->dont_attach_fe1)
 		dvb_frontend_detach(dvb->fe[1]);
 	dvb_frontend_detach(dvb->fe[0]);
+
+	/* remove I2C tuner */
+	client = dvb->i2c_client_tuner;
+	if (client) {
+		module_put(client->dev.driver->owner);
+		i2c_unregister_device(client);
+	}
+
+	/* remove I2C demod */
+	client = dvb->i2c_client_demod;
+	if (client) {
+		module_put(client->dev.driver->owner);
+		i2c_unregister_device(client);
+	}
+
 	dvb_unregister_adapter(&dvb->adapter);
 }
 
@@ -1628,7 +1645,6 @@ static inline void prevent_sleep(struct dvb_frontend_ops *ops)
 static int em28xx_dvb_fini(struct em28xx *dev)
 {
 	struct em28xx_dvb *dvb;
-	struct i2c_client *client;
 
 	if (dev->is_audio_only) {
 		/* Shouldn't initialize IR for this interface */
@@ -1646,7 +1662,6 @@ static int em28xx_dvb_fini(struct em28xx *dev)
 	em28xx_info("Closing DVB extension");
 
 	dvb = dev->dvb;
-	client = dvb->i2c_client_tuner;
 
 	em28xx_uninit_usb_xfer(dev, EM28XX_DIGITAL_MODE);
 
@@ -1659,19 +1674,6 @@ static int em28xx_dvb_fini(struct em28xx *dev)
 			prevent_sleep(&dvb->fe[1]->ops);
 	}
 
-	/* remove I2C tuner */
-	if (client) {
-		module_put(client->dev.driver->owner);
-		i2c_unregister_device(client);
-	}
-
-	/* remove I2C demod */
-	client = dvb->i2c_client_demod;
-	if (client) {
-		module_put(client->dev.driver->owner);
-		i2c_unregister_device(client);
-	}
-
 	em28xx_unregister_dvb(dvb);
 	kfree(dvb);
 	dev->dvb = NULL;
-- 
1.7.10.4

