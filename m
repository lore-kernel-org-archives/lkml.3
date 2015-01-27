Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756822AbbA0DhA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jan 2015 22:37:00 -0500
Received: from nasmtp01.atmel.com ([192.199.1.245]:26795 "EHLO
	DVREDG01.corp.atmel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750917AbbA0Dg7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jan 2015 22:36:59 -0500
From: Bo Shen <voice.shen@atmel.com>
To: Mark Brown <broonie@kernel.org>, <nicolas.ferre@atmel.com>
CC: <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        <devicetree@vger.kernel.org>, <alsa-devel@alsa-project.org>,
        <linux-sound@vger.kernel.org>, Alexander Morozov <linux@meltdown.ru>,
        Bo Shen <voice.shen@atmel.com>
Subject: [PATCH v3 1/2] ASoC: codecs: wm8904: add dt ids table
Date: Tue, 27 Jan 2015 11:36:39 +0800
Message-ID: <1422329800-28481-1-git-send-email-voice.shen@atmel.com>
X-Mailer: git-send-email 2.3.0.rc0
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alexander Morozov <linux@meltdown.ru>

The WM8904 and WM8918 has the same data type, while the WM8912
has different data type. So, use the data in dt ids table to
distinguish them.

Signed-off-by: Alexander Morozov <linux@meltdown.ru>
[voice.shen@atmel.com: add code to distinguish device type]
Signed-off-by: Bo Shen <voice.shen@atmel.com>
---
Changes in v3:
  - Get the device type from match data in probe function.
Changes in v2:
  - Add driver data for distinguish the device capability.

 sound/soc/codecs/wm8904.c | 31 ++++++++++++++++++++++++++++++-
 1 file changed, 30 insertions(+), 1 deletion(-)

diff --git a/sound/soc/codecs/wm8904.c b/sound/soc/codecs/wm8904.c
index 4d2d2b1..a80bc52 100644
--- a/sound/soc/codecs/wm8904.c
+++ b/sound/soc/codecs/wm8904.c
@@ -2098,6 +2098,24 @@ static const struct regmap_config wm8904_regmap = {
 	.num_reg_defaults = ARRAY_SIZE(wm8904_reg_defaults),
 };
 
+#ifdef CONFIG_OF
+static enum wm8904_type wm8904_data = WM8904;
+static enum wm8904_type wm8912_data = WM8912;
+
+static const struct of_device_id wm8904_of_match[] = {
+	{
+		.compatible = "wlf,wm8904",
+		.data = &wm8904_data,
+	}, {
+		.compatible = "wlf,wm8912",
+		.data = &wm8912_data,
+	}, {
+		/* sentinel */
+	}
+};
+MODULE_DEVICE_TABLE(of, wm8904_of_match);
+#endif
+
 static int wm8904_i2c_probe(struct i2c_client *i2c,
 			    const struct i2c_device_id *id)
 {
@@ -2125,7 +2143,17 @@ static int wm8904_i2c_probe(struct i2c_client *i2c,
 		return ret;
 	}
 
-	wm8904->devtype = id->driver_data;
+	if (i2c->dev.of_node) {
+		const struct of_device_id *match;
+
+		match = of_match_node(wm8904_of_match, i2c->dev.of_node);
+		if (match == NULL)
+			return -EINVAL;
+		wm8904->devtype = *((enum wm8904_type *)match->data);
+	} else {
+		wm8904->devtype = id->driver_data;
+	}
+
 	i2c_set_clientdata(i2c, wm8904);
 	wm8904->pdata = i2c->dev.platform_data;
 
@@ -2259,6 +2287,7 @@ static struct i2c_driver wm8904_i2c_driver = {
 	.driver = {
 		.name = "wm8904",
 		.owner = THIS_MODULE,
+		.of_match_table = of_match_ptr(wm8904_of_match),
 	},
 	.probe =    wm8904_i2c_probe,
 	.remove =   wm8904_i2c_remove,
-- 
2.3.0.rc0

