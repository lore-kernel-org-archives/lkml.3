Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753819AbaKHNkn (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Nov 2014 08:40:43 -0500
Received: from mail.lysator.liu.se ([130.236.254.3]:40483 "EHLO
	mail.lysator.liu.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753783AbaKHNkm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Nov 2014 08:40:42 -0500
From: Peter Rosin <peda@lysator.liu.se>
To: alsa-devel@alsa-project.org
Cc: Liam Girdwood <lgirdwood@gmail.com>, Mark Brown <broonie@kernel.org>,
        linux-kernel@vger.kernel.org, Peter Rosin <peda@axentia.se>
Subject: NXP Semiconductors TFA9879 Amplifier Driver
Date: Sat,  8 Nov 2014 14:40:16 +0100
Message-Id: <1415454017-4146-1-git-send-email-peda@lysator.liu.se>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <20141107111737.GJ8509@sirena.org.uk>
References: <20141107111737.GJ8509@sirena.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mark Brown wrote:
> On Thu, Nov 06, 2014 at 05:39:45PM +0100, Peter Rosin wrote:
> 
> > +	{ TFA9879_MISC_STATUS,		0x0000 }, /* 0x15, read-only
> */
> 
> The fix here is the wrong way round - if the device is reporting status
> here there should be no default and there should be a volatile operation
> (though it's not the end of the world to omit that if it's not used).
> 
> Otherwise this looks good.

Ok, I think I finally see what you mean...

Diff since v2 below.

Cheers,
Peter

diff --git a/sound/soc/codecs/tfa9879.c b/sound/soc/codecs/tfa9879.c
index c48022639a29..16f1b71edb55 100644
--- a/sound/soc/codecs/tfa9879.c
+++ b/sound/soc/codecs/tfa9879.c
@@ -182,9 +182,13 @@ static struct reg_default tfa9879_regs[] = {
 	{ TFA9879_HIGH_PASS_FILTER,	0x0004 }, /* 0x12 */
 	{ TFA9879_VOLUME_CONTROL,	0x10bd }, /* 0x13 */
 	{ TFA9879_MISC_CONTROL,		0x0000 }, /* 0x14 */
-	{ TFA9879_MISC_STATUS,		0x0000 }, /* 0x15, read-only */
 };
 
+static bool tfa9879_volatile_reg(struct device *dev, unsigned int reg)
+{
+	return reg == TFA9879_MISC_STATUS;
+}
+
 static const DECLARE_TLV_DB_SCALE(volume_tlv, -7050, 50, 1);
 static const DECLARE_TLV_DB_SCALE(tb_gain_tlv, -1800, 200, 0);
 static const char * const tb_freq_text[] = {
@@ -240,6 +244,7 @@ static const struct regmap_config tfa9879_regmap = {
 	.reg_bits = 8,
 	.val_bits = 16,
 
+	.volatile_reg = tfa9879_volatile_reg,
 	.max_register = TFA9879_MISC_STATUS,
 	.reg_defaults = tfa9879_regs,
 	.num_reg_defaults = ARRAY_SIZE(tfa9879_regs),
@@ -285,7 +290,7 @@ static int tfa9879_i2c_probe(struct i2c_client *i2c,
 		return PTR_ERR(tfa9879->regmap);
 
 	/* Ensure the device is in reset state */
-	for (i = 0; i < ARRAY_SIZE(tfa9879_regs) - 1; i++)
+	for (i = 0; i < ARRAY_SIZE(tfa9879_regs); i++)
 		regmap_write(tfa9879->regmap,
 			     tfa9879_regs[i].reg, tfa9879_regs[i].def);
 

