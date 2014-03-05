Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756313AbaCEOYj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Mar 2014 09:24:39 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:40730 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756197AbaCEOYe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Mar 2014 09:24:34 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Adam Thomson <Adam.Thomson.Opensource@diasemi.com>,
        Mark Brown <broonie@linaro.org>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 009/131] ASoC: da9055: Fix device registration of PMIC and CODEC devices
Date: Wed,  5 Mar 2014 14:22:13 +0000
Message-Id: <1394029455-23128-10-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <1394029455-23128-1-git-send-email-luis.henriques@canonical.com>
References: <1394029455-23128-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.6 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Adam Thomson <Adam.Thomson.Opensource@diasemi.com>

commit 07b0e5b10258b48e5edfb6c8ac156f05510eb775 upstream.

Currently the I2C device Ids conflict for the MFD and CODEC so
cannot be both instantiated on one platform. This patch updates
the Ids and names to make them unique from each other.

It should be noted that the I2C addresses for both PMIC and CODEC
are modifiable so instantiation of the two are kept as separate
devices, rather than instantiating the CODEC from the MFD code.

Signed-off-by: Adam Thomson <Adam.Thomson.Opensource@diasemi.com>
Acked-by: Mark Brown <broonie@linaro.org>
Signed-off-by: Mark Brown <broonie@linaro.org>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/mfd/da9055-i2c.c  | 12 ++++++++++--
 sound/soc/codecs/da9055.c | 11 +++++++++--
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
index fc9802d..620f804 100644
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
1.9.0

