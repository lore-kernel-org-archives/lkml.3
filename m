Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753814AbaHNBJc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Aug 2014 21:09:32 -0400
Received: from qmta14.emeryville.ca.mail.comcast.net ([76.96.27.212]:42434
	"EHLO qmta14.emeryville.ca.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752676AbaHNBJ3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Aug 2014 21:09:29 -0400
From: Shuah Khan <shuah.kh@samsung.com>
To: m.chehab@samsung.com, fabf@skynet.be
Cc: Shuah Khan <shuah.kh@samsung.com>, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 1/2] media: tuner xc5000 - release firmwware from xc5000_release()
Date: Wed, 13 Aug 2014 19:09:23 -0600
Message-Id: <ed12c60cb0052853517999841a2c581289c129df.1407977791.git.shuah.kh@samsung.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <cover.1407977791.git.shuah.kh@samsung.com>
References: <cover.1407977791.git.shuah.kh@samsung.com>
In-Reply-To: <cover.1407977791.git.shuah.kh@samsung.com>
References: <cover.1407977791.git.shuah.kh@samsung.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

xc5000 releases firmware right after loading it. Change it to
save the firmware and release it from xc5000_release(). This
helps avoid fecthing firmware when forced firmware load requests
come in to change analog tv frequence and when firmware needs to
be reloaded after suspend and resume.

Signed-off-by: Shuah Khan <shuah.kh@samsung.com>
---
 drivers/media/tuners/xc5000.c |   34 ++++++++++++++++++++--------------
 1 file changed, 20 insertions(+), 14 deletions(-)

diff --git a/drivers/media/tuners/xc5000.c b/drivers/media/tuners/xc5000.c
index 512fe50..31b1dec 100644
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
+			ret = -EINVAL;
+			goto err;
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

