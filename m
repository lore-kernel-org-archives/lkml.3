Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757761AbaCEO1U (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Mar 2014 09:27:20 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:41289 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757732AbaCEO1N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Mar 2014 09:27:13 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Mark Brown <broonie@linaro.org>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 117/131] ASoC: da732x: Mark DC offset control registers volatile
Date: Wed,  5 Mar 2014 14:24:01 +0000
Message-Id: <1394029455-23128-118-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <1394029455-23128-1-git-send-email-luis.henriques@canonical.com>
References: <1394029455-23128-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.6 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mark Brown <broonie@linaro.org>

commit 75306820248e26d15d84acf4e297b9fb27dd3bb2 upstream.

The driver reads from the DC offset control registers during callibration
but since the registers are marked as volatile and there is a register
cache the values will not be read from the hardware after the first reading
rendering the callibration ineffective.

It appears that the driver was originally written for the ASoC level
register I/O code but converted to regmap prior to merge and this issue
was missed during the conversion as the framework level volatile register
functionality was not being used.

Signed-off-by: Mark Brown <broonie@linaro.org>
Acked-by: Adam Thomson <Adam.Thomson.Opensource@diasemi.com>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 sound/soc/codecs/da732x.c | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/sound/soc/codecs/da732x.c b/sound/soc/codecs/da732x.c
index dc0284d..76fdf0a 100644
--- a/sound/soc/codecs/da732x.c
+++ b/sound/soc/codecs/da732x.c
@@ -1268,11 +1268,23 @@ static struct snd_soc_dai_driver da732x_dai[] = {
 	},
 };
 
+static bool da732x_volatile(struct device *dev, unsigned int reg)
+{
+	switch (reg) {
+	case DA732X_REG_HPL_DAC_OFF_CNTL:
+	case DA732X_REG_HPR_DAC_OFF_CNTL:
+		return true;
+	default:
+		return false;
+	}
+}
+
 static const struct regmap_config da732x_regmap = {
 	.reg_bits		= 8,
 	.val_bits		= 8,
 
 	.max_register		= DA732X_MAX_REG,
+	.volatile_reg		= da732x_volatile,
 	.reg_defaults		= da732x_reg_cache,
 	.num_reg_defaults	= ARRAY_SIZE(da732x_reg_cache),
 	.cache_type		= REGCACHE_RBTREE,
-- 
1.9.0

