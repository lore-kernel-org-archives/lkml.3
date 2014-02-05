Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753352AbaBERyz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Feb 2014 12:54:55 -0500
Received: from mail1.bemta5.messagelabs.com ([195.245.231.148]:31111 "EHLO
	mail1.bemta5.messagelabs.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753163AbaBERyx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Feb 2014 12:54:53 -0500
X-Greylist: delayed 374 seconds by postgrey-1.27 at vger.kernel.org; Wed, 05 Feb 2014 12:54:52 EST
X-Env-Sender: Adam.Thomson.Opensource@diasemi.com
X-Msg-Ref: server-14.tower-178.messagelabs.com!1391622513!25786800!1
X-Originating-IP: [82.210.246.133]
X-StarScan-Received: 
X-StarScan-Version: 6.9.16; banners=-,-,-
X-VirusChecked: Checked
Message-ID: <6a398d176b0b2bf8792d27bd5e2995fd96afb32d.1391614923.git.Adam.Thomson.Opensource@diasemi.com>
In-Reply-To: <cover.1391614923.git.Adam.Thomson.Opensource@diasemi.com>
References: <cover.1391614923.git.Adam.Thomson.Opensource@diasemi.com>
From: Adam Thomson <Adam.Thomson.Opensource@diasemi.com>
Date: Wed, 5 Feb 2014 17:48:32 +0000
Subject: [PATCH 1/8] ASoC: da9055: Fix device registration of PMIC and CODEC devices
To: Mark Brown <broonie@kernel.org>, Lee Jones <lee.jones@linaro.org>
CC: <alsa-devel@alsa-project.org>, <linux-kernel@vger.kernel.org>,
        <devicetree@vger.kernel.org>, Rob Herring <robh+dt@kernel.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Alessandro Zummo <a.zummo@towertech.it>,
        Guenter Roeck <linux@roeck-us.net>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently the I2C device Ids conflict for the MFD and CODEC so
cannot be both instantiated on one platform. This patch updates
the Ids and names to make them unique from each other.

It should be noted that the I2C addresses for both PMIC and CODEC
are modifiable so instantiation of the two are kept as separate
devices, rather than instantiating the CODEC from the MFD code.

Signed-off-by: Adam Thomson <Adam.Thomson.Opensource@diasemi.com>
---
 drivers/mfd/da9055-i2c.c  |   12 ++++++++++--
 sound/soc/codecs/da9055.c |   11 +++++++++--
 2 files changed, 19 insertions(+), 4 deletions(-)

diff --git a/drivers/mfd/da9055-i2c.c b/drivers/mfd/da9055-i2c.c
index 13af7e5..8103e43 100644
--- a/drivers/mfd/da9055-i2c.c
+++ b/drivers/mfd/da9055-i2c.c
@@ -53,17 +53,25 @@ static int da9055_i2c_remove(struct i2c_client *i2c)
 	return 0;
 }

+/*
+ * DO NOT change the device Ids. The naming is intentionally specific as both
+ * the PMIC and CODEC parts of this chip are instantiated separately as I2C
+ * devices (both have configurable I2C addresses, and are to all intents and
+ * purposes separate). As a result there are specific DA9055 ids for PMIC
+ * and CODEC, which must be different to operate together.
+ */
 static struct i2c_device_id da9055_i2c_id[] = {
-	{"da9055", 0},
+	{"da9055-pmic", 0},
 	{ }
 };
+MODULE_DEVICE_TABLE(i2c, da9055_i2c_id);

 static struct i2c_driver da9055_i2c_driver = {
 	.probe = da9055_i2c_probe,
 	.remove = da9055_i2c_remove,
 	.id_table = da9055_i2c_id,
 	.driver = {
-		.name = "da9055",
+		.name = "da9055-pmic",
 		.owner = THIS_MODULE,
 	},
 };
diff --git a/sound/soc/codecs/da9055.c b/sound/soc/codecs/da9055.c
index 52b79a4..4228126 100644
--- a/sound/soc/codecs/da9055.c
+++ b/sound/soc/codecs/da9055.c
@@ -1523,8 +1523,15 @@ static int da9055_remove(struct i2c_client *client)
 	return 0;
 }

+/*
+ * DO NOT change the device Ids. The naming is intentionally specific as both
+ * the CODEC and PMIC parts of this chip are instantiated separately as I2C
+ * devices (both have configurable I2C addresses, and are to all intents and
+ * purposes separate). As a result there are specific DA9055 Ids for CODEC
+ * and PMIC, which must be different to operate together.
+ */
 static const struct i2c_device_id da9055_i2c_id[] = {
-	{ "da9055", 0 },
+	{ "da9055-codec", 0 },
 	{ }
 };
 MODULE_DEVICE_TABLE(i2c, da9055_i2c_id);
@@ -1532,7 +1539,7 @@ MODULE_DEVICE_TABLE(i2c, da9055_i2c_id);
 /* I2C codec control layer */
 static struct i2c_driver da9055_i2c_driver = {
 	.driver = {
-		.name = "da9055",
+		.name = "da9055-codec",
 		.owner = THIS_MODULE,
 	},
 	.probe		= da9055_i2c_probe,
--
1.7.0.4

