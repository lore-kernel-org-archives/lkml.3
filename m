Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752988AbaACNbP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Jan 2014 08:31:15 -0500
Received: from devils.ext.ti.com ([198.47.26.153]:53435 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752015AbaACN2M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Jan 2014 08:28:12 -0500
From: Peter Ujfalusi <peter.ujfalusi@ti.com>
To: Liam Girdwood <lgirdwood@gmail.com>, Mark Brown <broonie@kernel.org>,
        Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>
CC: <alsa-devel@alsa-project.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH 03/11] MFD: twl-core: Enable regcache for audio registers
Date: Fri, 3 Jan 2014 15:27:48 +0200
Message-ID: <1388755676-16036-4-git-send-email-peter.ujfalusi@ti.com>
X-Mailer: git-send-email 1.8.5.2
In-Reply-To: <1388755676-16036-1-git-send-email-peter.ujfalusi@ti.com>
References: <1388755676-16036-1-git-send-email-peter.ujfalusi@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Enable regmap's regcache for the audio registers:
i2c address 0x49, register range 0x01 - 0x49
Mark all other registers as volatile to avoid any side effect for the non
audio functions behind 0x49 i2c address.

Signed-off-by: Peter Ujfalusi <peter.ujfalusi@ti.com>
---
 drivers/mfd/twl-core.c | 111 +++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 111 insertions(+)

diff --git a/drivers/mfd/twl-core.c b/drivers/mfd/twl-core.c
index f0abca79ff34..6ef7685a4cf8 100644
--- a/drivers/mfd/twl-core.c
+++ b/drivers/mfd/twl-core.c
@@ -47,6 +47,9 @@
 #include <linux/i2c.h>
 #include <linux/i2c/twl.h>
 
+/* Register descriptions for audio */
+#include <linux/mfd/twl4030-audio.h>
+
 #include "twl-core.h"
 
 /*
@@ -200,6 +203,105 @@ static struct twl_mapping twl4030_map[] = {
 	{ 2, TWL5031_BASEADD_INTERRUPTS },
 };
 
+static struct reg_default twl4030_49_defaults[] = {
+	/* Audio Registers */
+	{ 0x01, 0x00}, /* CODEC_MODE	*/
+	{ 0x02, 0x00}, /* OPTION	*/
+	/* 0x03  Unused	*/
+	{ 0x04, 0x00}, /* MICBIAS_CTL	*/
+	{ 0x05, 0x00}, /* ANAMICL	*/
+	{ 0x06, 0x00}, /* ANAMICR	*/
+	{ 0x07, 0x00}, /* AVADC_CTL	*/
+	{ 0x08, 0x00}, /* ADCMICSEL	*/
+	{ 0x09, 0x00}, /* DIGMIXING	*/
+	{ 0x0a, 0x0f}, /* ATXL1PGA	*/
+	{ 0x0b, 0x0f}, /* ATXR1PGA	*/
+	{ 0x0c, 0x0f}, /* AVTXL2PGA	*/
+	{ 0x0d, 0x0f}, /* AVTXR2PGA	*/
+	{ 0x0e, 0x00}, /* AUDIO_IF	*/
+	{ 0x0f, 0x00}, /* VOICE_IF	*/
+	{ 0x10, 0x3f}, /* ARXR1PGA	*/
+	{ 0x11, 0x3f}, /* ARXL1PGA	*/
+	{ 0x12, 0x3f}, /* ARXR2PGA	*/
+	{ 0x13, 0x3f}, /* ARXL2PGA	*/
+	{ 0x14, 0x25}, /* VRXPGA	*/
+	{ 0x15, 0x00}, /* VSTPGA	*/
+	{ 0x16, 0x00}, /* VRX2ARXPGA	*/
+	{ 0x17, 0x00}, /* AVDAC_CTL	*/
+	{ 0x18, 0x00}, /* ARX2VTXPGA	*/
+	{ 0x19, 0x32}, /* ARXL1_APGA_CTL*/
+	{ 0x1a, 0x32}, /* ARXR1_APGA_CTL*/
+	{ 0x1b, 0x32}, /* ARXL2_APGA_CTL*/
+	{ 0x1c, 0x32}, /* ARXR2_APGA_CTL*/
+	{ 0x1d, 0x00}, /* ATX2ARXPGA	*/
+	{ 0x1e, 0x00}, /* BT_IF		*/
+	{ 0x1f, 0x55}, /* BTPGA		*/
+	{ 0x20, 0x00}, /* BTSTPGA	*/
+	{ 0x21, 0x00}, /* EAR_CTL	*/
+	{ 0x22, 0x00}, /* HS_SEL	*/
+	{ 0x23, 0x00}, /* HS_GAIN_SET	*/
+	{ 0x24, 0x00}, /* HS_POPN_SET	*/
+	{ 0x25, 0x00}, /* PREDL_CTL	*/
+	{ 0x26, 0x00}, /* PREDR_CTL	*/
+	{ 0x27, 0x00}, /* PRECKL_CTL	*/
+	{ 0x28, 0x00}, /* PRECKR_CTL	*/
+	{ 0x29, 0x00}, /* HFL_CTL	*/
+	{ 0x2a, 0x00}, /* HFR_CTL	*/
+	{ 0x2b, 0x05}, /* ALC_CTL	*/
+	{ 0x2c, 0x00}, /* ALC_SET1	*/
+	{ 0x2d, 0x00}, /* ALC_SET2	*/
+	{ 0x2e, 0x00}, /* BOOST_CTL	*/
+	{ 0x2f, 0x00}, /* SOFTVOL_CTL	*/
+	{ 0x30, 0x13}, /* DTMF_FREQSEL	*/
+	{ 0x31, 0x00}, /* DTMF_TONEXT1H	*/
+	{ 0x32, 0x00}, /* DTMF_TONEXT1L	*/
+	{ 0x33, 0x00}, /* DTMF_TONEXT2H	*/
+	{ 0x34, 0x00}, /* DTMF_TONEXT2L	*/
+	{ 0x35, 0x79}, /* DTMF_TONOFF	*/
+	{ 0x36, 0x11}, /* DTMF_WANONOFF	*/
+	{ 0x37, 0x00}, /* I2S_RX_SCRAMBLE_H */
+	{ 0x38, 0x00}, /* I2S_RX_SCRAMBLE_M */
+	{ 0x39, 0x00}, /* I2S_RX_SCRAMBLE_L */
+	{ 0x3a, 0x06}, /* APLL_CTL */
+	{ 0x3b, 0x00}, /* DTMF_CTL */
+	{ 0x3c, 0x44}, /* DTMF_PGA_CTL2	(0x3C) */
+	{ 0x3d, 0x69}, /* DTMF_PGA_CTL1	(0x3D) */
+	{ 0x3e, 0x00}, /* MISC_SET_1 */
+	{ 0x3f, 0x00}, /* PCMBTMUX */
+	/* 0x40 - 0x42  Unused */
+	{ 0x43, 0x00}, /* RX_PATH_SEL */
+	{ 0x44, 0x32}, /* VDL_APGA_CTL */
+	{ 0x45, 0x00}, /* VIBRA_CTL */
+	{ 0x46, 0x00}, /* VIBRA_SET */
+	{ 0x47, 0x00}, /* VIBRA_PWM_SET	*/
+	{ 0x48, 0x00}, /* ANAMIC_GAIN	*/
+	{ 0x49, 0x00}, /* MISC_SET_2	*/
+	/* End of Audio Registers */
+};
+
+static bool twl4030_49_nop_reg(struct device *dev, unsigned int reg)
+{
+	switch (reg) {
+	case 0:
+	case 3:
+	case 40:
+	case 41:
+	case 42:
+		return false;
+	default:
+		return true;
+	}
+}
+
+static const struct regmap_range twl4030_49_volatile_ranges[] = {
+	regmap_reg_range(TWL4030_BASEADD_TEST, 0xff),
+};
+
+static const struct regmap_access_table twl4030_49_volatile_table = {
+	.yes_ranges = twl4030_49_volatile_ranges,
+	.n_yes_ranges = ARRAY_SIZE(twl4030_49_volatile_ranges),
+};
+
 static struct regmap_config twl4030_regmap_config[4] = {
 	{
 		/* Address 0x48 */
@@ -212,6 +314,15 @@ static struct regmap_config twl4030_regmap_config[4] = {
 		.reg_bits = 8,
 		.val_bits = 8,
 		.max_register = 0xff,
+
+		.readable_reg = twl4030_49_nop_reg,
+		.writeable_reg = twl4030_49_nop_reg,
+
+		.volatile_table = &twl4030_49_volatile_table,
+
+		.reg_defaults = twl4030_49_defaults,
+		.num_reg_defaults = ARRAY_SIZE(twl4030_49_defaults),
+		.cache_type = REGCACHE_RBTREE,
 	},
 	{
 		/* Address 0x4a */
-- 
1.8.5.2

