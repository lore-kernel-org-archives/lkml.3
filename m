Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753303Ab3IRSG4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Sep 2013 14:06:56 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:36940 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751712Ab3IRSGz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Sep 2013 14:06:55 -0400
From: Mark Brown <broonie@kernel.org>
To: Lee Jones <lee.jones@linaro.org>, Samuel Ortiz <sameo@linux.intel.com>,
        Liam Girdwood <lgirdwood@gmail.com>,
        Marc Reilly <marc@cpdesign.com.au>, <u.kleine-koenig@pengutronix.de>
Cc: linux-kernel@vger.kernel.org, alsa-devel@alsa-project.org,
        linaro-kernel@lists.linaro.org, Mark Brown <broonie@linaro.org>
Date: Wed, 18 Sep 2013 19:06:26 +0100
Message-Id: <1379527587-14567-2-git-send-email-broonie@kernel.org>
X-Mailer: git-send-email 1.8.4.rc3
In-Reply-To: <1379527587-14567-1-git-send-email-broonie@kernel.org>
References: <1379527587-14567-1-git-send-email-broonie@kernel.org>
X-SA-Exim-Connect-IP: 86.153.71.95
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: [PATCH 2/3] mfd: mc13xxx: Move SPI erratum workaround into SPI I/O function
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mark Brown <broonie@linaro.org>

Move the workaround for double sending AUDIO_CODEC and AUDIO_DAC writes
into the SPI core, aiding refactoring to eliminate the ASoC custom I/O
functions and avoiding the extra writes for I2C.

Signed-off-by: Mark Brown <broonie@linaro.org>
---
 drivers/mfd/mc13xxx-spi.c   | 5 +++++
 include/linux/mfd/mc13xxx.h | 7 +++++++
 sound/soc/codecs/mc13783.c  | 4 ----
 3 files changed, 12 insertions(+), 4 deletions(-)

diff --git a/drivers/mfd/mc13xxx-spi.c b/drivers/mfd/mc13xxx-spi.c
index 77189da..363c359 100644
--- a/drivers/mfd/mc13xxx-spi.c
+++ b/drivers/mfd/mc13xxx-spi.c
@@ -94,10 +94,15 @@ static int mc13xxx_spi_write(void *context, const void *data, size_t count)
 {
 	struct device *dev = context;
 	struct spi_device *spi = to_spi_device(dev);
+	char *reg = data;
 
 	if (count != 4)
 		return -ENOTSUPP;
 
+	/* include errata fix for spi audio problems */
+	if (*reg == MC13783_AUDIO_CODEC || *reg == MC13783_AUDIO_DAC)
+		spi_write(spi, data, count);
+
 	return spi_write(spi, data, count);
 }
 
diff --git a/include/linux/mfd/mc13xxx.h b/include/linux/mfd/mc13xxx.h
index 41ed592..67c17b5 100644
--- a/include/linux/mfd/mc13xxx.h
+++ b/include/linux/mfd/mc13xxx.h
@@ -41,6 +41,13 @@ int mc13xxx_adc_do_conversion(struct mc13xxx *mc13xxx,
 		unsigned int mode, unsigned int channel,
 		u8 ato, bool atox, unsigned int *sample);
 
+#define MC13783_AUDIO_RX0	36
+#define MC13783_AUDIO_RX1	37
+#define MC13783_AUDIO_TX	38
+#define MC13783_SSI_NETWORK	39
+#define MC13783_AUDIO_CODEC	40
+#define MC13783_AUDIO_DAC	41
+
 #define MC13XXX_IRQ_ADCDONE	0
 #define MC13XXX_IRQ_ADCBISDONE	1
 #define MC13XXX_IRQ_TS		2
diff --git a/sound/soc/codecs/mc13783.c b/sound/soc/codecs/mc13783.c
index ea141e1..4d3c8fd 100644
--- a/sound/soc/codecs/mc13783.c
+++ b/sound/soc/codecs/mc13783.c
@@ -125,10 +125,6 @@ static int mc13783_write(struct snd_soc_codec *codec,
 
 	ret = mc13xxx_reg_write(priv->mc13xxx, reg, value);
 
-	/* include errata fix for spi audio problems */
-	if (reg == MC13783_AUDIO_CODEC || reg == MC13783_AUDIO_DAC)
-		ret = mc13xxx_reg_write(priv->mc13xxx, reg, value);
-
 	mc13xxx_unlock(priv->mc13xxx);
 
 	return ret;
-- 
1.8.4.rc3

