Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755461AbaIWAbJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Sep 2014 20:31:09 -0400
Received: from resqmta-po-07v.sys.comcast.net ([96.114.154.166]:50436 "EHLO
	resqmta-po-07v.sys.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753507AbaIWAbH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Sep 2014 20:31:07 -0400
From: Shuah Khan <shuahkh@osg.samsung.com>
To: m.chehab@samsung.com, fabf@skynet.be
Cc: Shuah Khan <shuahkh@osg.samsung.com>, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2] media: tuner xc5000 - release firmwware from xc5000_release()
Date: Mon, 22 Sep 2014 18:30:46 -0600
Message-Id: <1411432246-9085-1-git-send-email-shuahkh@osg.samsung.com>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

xc5000 releases firmware right after loading it. Change it to
save the firmware and release it from xc5000_release(). This
helps avoid fecthing firmware when forced firmware load requests
come in to change analog tv frequence and when firmware needs to
be reloaded after suspend and resume.

Signed-off-by: Shuah Khan <shuahkh@osg.samsung.com>
---

patch v2: fixes issues found in patch v1 review

 drivers/media/tuners/xc5000.c |   34 ++++++++++++++++++++--------------
 1 file changed, 20 insertions(+), 14 deletions(-)

diff --git a/drivers/media/tuners/xc5000.c b/drivers/media/tuners/xc5000.c
index 512fe50..b72ec64 100644
--- a/drivers/media/tuners/xc5000.c
+++ b/drivers/media/tuners/xc5000.c
@@ -70,6 +70,8 @@ struct xc5000_priv {
 
 	struct dvb_frontend *fe;
 	struct delayed_work timer_sleep;
+
+	const struct firmware   *firmware;
 };
 
 /* Misc Defines */
@@ -1136,20 +1138,23 @@ static int xc_load_fw_and_init_tuner(struct dvb_frontend *fe, int force)
 	if (!force && xc5000_is_firmware_loaded(fe) == 0)
 		return 0;
 
-	ret = request_firmware(&fw, desired_fw->name,
-			       priv->i2c_props.adap->dev.parent);
-	if (ret) {
-		printk(KERN_ERR "xc5000: Upload failed. (file not found?)\n");
-		return ret;
-	}
-
-	dprintk(1, "firmware read %Zu bytes.\n", fw->size);
+	if (!priv->firmware) {
+		ret = request_firmware(&fw, desired_fw->name,
+					priv->i2c_props.adap->dev.parent);
+		if (ret) {
+			pr_err("xc5000: Upload failed. rc %d\n", ret);
+			return ret;
+		}
+		dprintk(1, "firmware read %Zu bytes.\n", fw->size);
 
-	if (fw->size != desired_fw->size) {
-		printk(KERN_ERR "xc5000: Firmware file with incorrect size\n");
-		ret = -EINVAL;
-		goto err;
-	}
+		if (fw->size != desired_fw->size) {
+			pr_err("xc5000: Firmware file with incorrect size\n");
+			release_firmware(fw);
+			return -EINVAL;
+		}
+		priv->firmware = fw;
+	} else
+		fw = priv->firmware;
 
 	/* Try up to 5 times to load firmware */
 	for (i = 0; i < 5; i++) {
@@ -1232,7 +1237,6 @@ err:
 	else
 		printk(KERN_CONT " - too many retries. Giving up\n");
 
-	release_firmware(fw);
 	return ret;
 }
 
@@ -1316,6 +1320,8 @@ static int xc5000_release(struct dvb_frontend *fe)
 	if (priv) {
 		cancel_delayed_work(&priv->timer_sleep);
 		hybrid_tuner_release_state(priv);
+		if (priv->firmware)
+			release_firmware(priv->firmware);
 	}
 
 	mutex_unlock(&xc5000_list_mutex);
-- 
1.7.10.4

