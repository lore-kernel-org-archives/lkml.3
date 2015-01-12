Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932136AbbALSuF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2015 13:50:05 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:58207 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753757AbbALSaX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2015 13:30:23 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Peter Rosin <peda@axentia.se>, Mark Brown <broonie@kernel.org>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.16.y-ckt 160/216] ASoC: pcm512x: Trigger auto-increment of register addresses on i2c
Date: Mon, 12 Jan 2015 18:28:58 +0000
Message-Id: <1421087394-2712-48-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 2.1.4
In-Reply-To: <1421085933-32536-1-git-send-email-luis.henriques@canonical.com>
References: <1421085933-32536-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.16
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.16.7-ckt4 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Peter Rosin <peda@axentia.se>

commit 681a19560378213a193c424881b2180a783b81ae upstream.

When the codec is connected using i2c, it will only auto-increment
register addresses if msb (0x80) of the register address byte is set.

[Fixes cache sync if multiple adjacent registers are updated -- broonie]

Signed-off-by: Peter Rosin <peda@axentia.se>
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 sound/soc/codecs/pcm512x-i2c.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/sound/soc/codecs/pcm512x-i2c.c b/sound/soc/codecs/pcm512x-i2c.c
index 4d62230bd378..d0547fa275fc 100644
--- a/sound/soc/codecs/pcm512x-i2c.c
+++ b/sound/soc/codecs/pcm512x-i2c.c
@@ -24,8 +24,13 @@ static int pcm512x_i2c_probe(struct i2c_client *i2c,
 			     const struct i2c_device_id *id)
 {
 	struct regmap *regmap;
+	struct regmap_config config = pcm512x_regmap;
 
-	regmap = devm_regmap_init_i2c(i2c, &pcm512x_regmap);
+	/* msb needs to be set to enable auto-increment of addresses */
+	config.read_flag_mask = 0x80;
+	config.write_flag_mask = 0x80;
+
+	regmap = devm_regmap_init_i2c(i2c, &config);
 	if (IS_ERR(regmap))
 		return PTR_ERR(regmap);
 
-- 
2.1.4

