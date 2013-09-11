Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755138Ab3IKPc5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Sep 2013 11:32:57 -0400
Received: from mga03.intel.com ([143.182.124.21]:16876 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755096Ab3IKPcy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Sep 2013 11:32:54 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.90,885,1371106800"; 
   d="scan'208";a="293584922"
From: Mika Westerberg <mika.westerberg@linux.intel.com>
To: linux-i2c@vger.kernel.org
Cc: Wolfram Sang <wsa@the-dreams.de>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org,
        Lv Zheng <lv.zheng@intel.com>, Aaron Lu <aaron.lu@intel.com>,
        linux-arm-kernel@lists.infradead.org, Mark Brown <broonie@kernel.org>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Mauro Carvalho Chehab <m.chehab@samsung.com>,
        Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Liam Girdwood <lgirdwood@gmail.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Mika Westerberg <mika.westerberg@linux.intel.com>
Subject: [PATCH v2 7/9] ASoC: codecs: convert existing I2C client drivers to use I2C core runtime PM
Date: Wed, 11 Sep 2013 18:32:38 +0300
Message-Id: <1378913560-2752-8-git-send-email-mika.westerberg@linux.intel.com>
X-Mailer: git-send-email 1.8.4.rc3
In-Reply-To: <1378913560-2752-1-git-send-email-mika.westerberg@linux.intel.com>
References: <1378913560-2752-1-git-send-email-mika.westerberg@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The I2C core now prepares runtime PM on behalf of the I2C client device, so
only thing the driver needs to do is to call pm_runtime_put() at the end of
its ->probe().

This patch converts ASoC codec drivers to use this model.

Signed-off-by: Mika Westerberg <mika.westerberg@linux.intel.com>
---
 sound/soc/codecs/wm2200.c | 12 +++++-------
 sound/soc/codecs/wm5100.c |  8 ++++----
 sound/soc/codecs/wm8962.c |  5 ++---
 3 files changed, 11 insertions(+), 14 deletions(-)

diff --git a/sound/soc/codecs/wm2200.c b/sound/soc/codecs/wm2200.c
index 57ba315..469b67f 100644
--- a/sound/soc/codecs/wm2200.c
+++ b/sound/soc/codecs/wm2200.c
@@ -2407,21 +2407,17 @@ static int wm2200_i2c_probe(struct i2c_client *i2c,
 				i2c->irq, ret);
 	}
 
-	pm_runtime_set_active(&i2c->dev);
-	pm_runtime_enable(&i2c->dev);
-	pm_request_idle(&i2c->dev);
-
 	ret = snd_soc_register_codec(&i2c->dev, &soc_codec_wm2200,
 				     &wm2200_dai, 1);
 	if (ret != 0) {
 		dev_err(&i2c->dev, "Failed to register CODEC: %d\n", ret);
-		goto err_pm_runtime;
+		goto err_reset;
 	}
 
+	pm_runtime_put(&i2c->dev);
+
 	return 0;
 
-err_pm_runtime:
-	pm_runtime_disable(&i2c->dev);
 err_reset:
 	if (wm2200->pdata.reset)
 		gpio_set_value_cansleep(wm2200->pdata.reset, 0);
@@ -2438,6 +2434,8 @@ static int wm2200_i2c_remove(struct i2c_client *i2c)
 {
 	struct wm2200_priv *wm2200 = i2c_get_clientdata(i2c);
 
+	pm_runtime_get(&i2c->dev);
+
 	snd_soc_unregister_codec(&i2c->dev);
 	if (i2c->irq)
 		free_irq(i2c->irq, wm2200);
diff --git a/sound/soc/codecs/wm5100.c b/sound/soc/codecs/wm5100.c
index ac1745d..5d3b22e 100644
--- a/sound/soc/codecs/wm5100.c
+++ b/sound/soc/codecs/wm5100.c
@@ -2612,10 +2612,6 @@ static int wm5100_i2c_probe(struct i2c_client *i2c,
 		}
 	}
 
-	pm_runtime_set_active(&i2c->dev);
-	pm_runtime_enable(&i2c->dev);
-	pm_request_idle(&i2c->dev);
-
 	ret = snd_soc_register_codec(&i2c->dev,
 				     &soc_codec_dev_wm5100, wm5100_dai,
 				     ARRAY_SIZE(wm5100_dai));
@@ -2624,6 +2620,8 @@ static int wm5100_i2c_probe(struct i2c_client *i2c,
 		goto err_reset;
 	}
 
+	pm_runtime_put(&i2c->dev);
+
 	return ret;
 
 err_reset:
@@ -2650,6 +2648,8 @@ static int wm5100_i2c_remove(struct i2c_client *i2c)
 {
 	struct wm5100_priv *wm5100 = i2c_get_clientdata(i2c);
 
+	pm_runtime_get(&i2c->dev);
+
 	snd_soc_unregister_codec(&i2c->dev);
 	if (i2c->irq)
 		free_irq(i2c->irq, wm5100);
diff --git a/sound/soc/codecs/wm8962.c b/sound/soc/codecs/wm8962.c
index e2de9ec..4fcf7db 100644
--- a/sound/soc/codecs/wm8962.c
+++ b/sound/soc/codecs/wm8962.c
@@ -3715,9 +3715,6 @@ static int wm8962_i2c_probe(struct i2c_client *i2c,
 				ret);
 	}
 
-	pm_runtime_enable(&i2c->dev);
-	pm_request_idle(&i2c->dev);
-
 	ret = snd_soc_register_codec(&i2c->dev,
 				     &soc_codec_dev_wm8962, &wm8962_dai, 1);
 	if (ret < 0)
@@ -3725,6 +3722,7 @@ static int wm8962_i2c_probe(struct i2c_client *i2c,
 
 	/* The drivers should power up as needed */
 	regulator_bulk_disable(ARRAY_SIZE(wm8962->supplies), wm8962->supplies);
+	pm_runtime_put(&i2c->dev);
 
 	return 0;
 
@@ -3736,6 +3734,7 @@ err:
 
 static int wm8962_i2c_remove(struct i2c_client *client)
 {
+	pm_runtime_get(&client->dev);
 	snd_soc_unregister_codec(&client->dev);
 	return 0;
 }
-- 
1.8.4.rc3

