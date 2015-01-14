Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756168AbbANIuI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2015 03:50:08 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:57655 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752401AbbANHZT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2015 02:25:19 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Peter Rosin <peda@axentia.se>, Mark Brown <broonie@kernel.org>
Subject: [PATCH 3.18 023/150] ASoC: pcm512x: Trigger auto-increment of register addresses on i2c
Date: Tue, 13 Jan 2015 23:21:34 -0800
Message-Id: <20150114072056.918341238@linuxfoundation.org>
X-Mailer: git-send-email 2.2.2
In-Reply-To: <20150114072055.842408181@linuxfoundation.org>
References: <20150114072055.842408181@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Peter Rosin <peda@axentia.se>

commit 681a19560378213a193c424881b2180a783b81ae upstream.

When the codec is connected using i2c, it will only auto-increment
register addresses if msb (0x80) of the register address byte is set.

[Fixes cache sync if multiple adjacent registers are updated -- broonie]

Signed-off-by: Peter Rosin <peda@axentia.se>
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 sound/soc/codecs/pcm512x-i2c.c |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

--- a/sound/soc/codecs/pcm512x-i2c.c
+++ b/sound/soc/codecs/pcm512x-i2c.c
@@ -24,8 +24,13 @@ static int pcm512x_i2c_probe(struct i2c_
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
 


