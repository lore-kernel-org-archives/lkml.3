Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754827AbaCYRVD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Mar 2014 13:21:03 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:55776 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753434AbaCYRUz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Mar 2014 13:20:55 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Mark Brown <broonie@linaro.org>, Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.8 66/81] ASoC: da732x: Mark DC offset control registers volatile
Date: Tue, 25 Mar 2014 10:16:19 -0700
Message-Id: <1395767794-5012-67-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1395767794-5012-1-git-send-email-kamal@canonical.com>
References: <1395767794-5012-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.20 -stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
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
1.8.3.2

