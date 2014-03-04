Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933094AbaCDVKp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2014 16:10:45 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:41113 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756475AbaCDUDq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2014 15:03:46 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Mark Brown <broonie@linaro.org>,
        Adam Thomson <Adam.Thomson.Opensource@diasemi.com>
Subject: [PATCH 3.13 092/172] ASoC: da732x: Mark DC offset control registers volatile
Date: Tue,  4 Mar 2014 12:02:56 -0800
Message-Id: <20140304200302.657916632@linuxfoundation.org>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <20140304200259.626667112@linuxfoundation.org>
References: <20140304200259.626667112@linuxfoundation.org>
User-Agent: quilt/0.61-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 sound/soc/codecs/da732x.c |   12 ++++++++++++
 1 file changed, 12 insertions(+)

--- a/sound/soc/codecs/da732x.c
+++ b/sound/soc/codecs/da732x.c
@@ -1268,11 +1268,23 @@ static struct snd_soc_dai_driver da732x_
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


