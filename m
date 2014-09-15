Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758721AbaIOU5Y (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Sep 2014 16:57:24 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:54594 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755030AbaIOT1H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Sep 2014 15:27:07 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Peter Ujfalusi <peter.ujfalusi@ti.com>,
        Mark Brown <broonie@linaro.org>
Subject: [PATCH 3.16 084/158] ASoC: tlv320aic31xx: Do not ignore errors in aic31xx_device_init()
Date: Mon, 15 Sep 2014 12:25:23 -0700
Message-Id: <20140915192545.409641989@linuxfoundation.org>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <20140915192542.872134685@linuxfoundation.org>
References: <20140915192542.872134685@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Peter Ujfalusi <peter.ujfalusi@ti.com>

commit a72d2abbe5752f3a773c4d8b7b41ae41f617f772 upstream.

We need to return the error codes from aic31xx_device_init() and return
from the i2c_probe with the error code.
We will have kernel panic (NULL pointer dereference) in
regulator_register_notifier() in case the devm_regulator_bulk_get() fails
(with -EPROBE_DEFER for example).

Signed-off-by: Peter Ujfalusi <peter.ujfalusi@ti.com>
Signed-off-by: Mark Brown <broonie@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 sound/soc/codecs/tlv320aic31xx.c |    9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

--- a/sound/soc/codecs/tlv320aic31xx.c
+++ b/sound/soc/codecs/tlv320aic31xx.c
@@ -1178,7 +1178,7 @@ static void aic31xx_pdata_from_of(struct
 }
 #endif /* CONFIG_OF */
 
-static void aic31xx_device_init(struct aic31xx_priv *aic31xx)
+static int aic31xx_device_init(struct aic31xx_priv *aic31xx)
 {
 	int ret, i;
 
@@ -1197,7 +1197,7 @@ static void aic31xx_device_init(struct a
 					    "aic31xx-reset-pin");
 		if (ret < 0) {
 			dev_err(aic31xx->dev, "not able to acquire gpio\n");
-			return;
+			return ret;
 		}
 	}
 
@@ -1210,6 +1210,7 @@ static void aic31xx_device_init(struct a
 	if (ret != 0)
 		dev_err(aic31xx->dev, "Failed to request supplies: %d\n", ret);
 
+	return ret;
 }
 
 static int aic31xx_i2c_probe(struct i2c_client *i2c,
@@ -1239,7 +1240,9 @@ static int aic31xx_i2c_probe(struct i2c_
 
 	aic31xx->pdata.codec_type = id->driver_data;
 
-	aic31xx_device_init(aic31xx);
+	ret = aic31xx_device_init(aic31xx);
+	if (ret)
+		return ret;
 
 	return snd_soc_register_codec(&i2c->dev, &soc_codec_driver_aic31xx,
 				     aic31xx_dai_driver,


