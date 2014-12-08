Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754978AbaLHPd3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Dec 2014 10:33:29 -0500
Received: from mail.lysator.liu.se ([130.236.254.3]:41673 "EHLO
	mail.lysator.liu.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751216AbaLHPd2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Dec 2014 10:33:28 -0500
From: Peter Rosin <peda@lysator.liu.se>
To: alsa-devel@alsa-project.org
Cc: Liam Girdwood <lgirdwood@gmail.com>, Mark Brown <broonie@kernel.org>,
        linux-kernel@vger.kernel.org, Peter Rosin <peda@axentia.se>
Subject: [PATCH] ASoC: pcm512x: Trigger auto-increment of register addresses on i2c
Date: Mon,  8 Dec 2014 16:33:11 +0100
Message-Id: <1418052791-4257-1-git-send-email-peda@lysator.liu.se>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Peter Rosin <peda@axentia.se>

When the codec is connected using i2c, it will only auto-increment
register addresses if msb (0x80) of the register address byte is set.

Signed-off-by: Peter Rosin <peda@axentia.se>
---
 sound/soc/codecs/pcm512x-i2c.c |    7 ++++++-
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
1.7.10.4

