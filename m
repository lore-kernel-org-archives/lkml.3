Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932101Ab3A1Qrs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jan 2013 11:47:48 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:54857 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756981Ab3A1Qrq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jan 2013 11:47:46 -0500
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: linux-kernel@vger.kernel.org, patches@opensource.wolfsonmicro.com,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [PATCH] mfd: arizona: Provide platform data for MICBIAS configuration
Date: Tue, 29 Jan 2013 00:47:37 +0800
Message-Id: <1359391658-13479-1-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Allow the MICBIAS voltages and other attributes to be configured by the
platform.

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
---
 drivers/mfd/arizona-core.c        |   23 +++++++++++++++++++++++
 include/linux/mfd/arizona/pdata.h |   12 ++++++++++++
 2 files changed, 35 insertions(+)

diff --git a/drivers/mfd/arizona-core.c b/drivers/mfd/arizona-core.c
index 0bb79c8..06d245a 100644
--- a/drivers/mfd/arizona-core.c
+++ b/drivers/mfd/arizona-core.c
@@ -518,6 +518,29 @@ int arizona_dev_init(struct arizona *arizona)
 		goto err_reset;
 	}
 
+	for (i = 0; i < ARIZONA_MAX_MICBIAS; i++) {
+		if (!arizona->pdata.micbias[i].mV)
+			continue;
+
+		val = (arizona->pdata.micbias[i].mV - 1500) / 100;
+		val <<= ARIZONA_MICB1_LVL_SHIFT;
+
+		if (arizona->pdata.micbias[i].ext_cap)
+			val |= ARIZONA_MICB1_EXT_CAP;
+
+		if (arizona->pdata.micbias[i].discharge)
+			val |= ARIZONA_MICB1_DISCH;
+
+		if (arizona->pdata.micbias[i].fast_start)
+			val |= ARIZONA_MICB1_RATE;
+
+		regmap_update_bits(arizona->regmap,
+				   ARIZONA_MIC_BIAS_CTRL_1 + i,
+				   ARIZONA_MICB1_LVL_MASK |
+				   ARIZONA_MICB1_DISCH |
+				   ARIZONA_MICB1_RATE, val);
+	}
+
 	for (i = 0; i < ARIZONA_MAX_INPUT; i++) {
 		/* Default for both is 0 so noop with defaults */
 		val = arizona->pdata.dmic_ref[i]
diff --git a/include/linux/mfd/arizona/pdata.h b/include/linux/mfd/arizona/pdata.h
index 73822bd..32992a6 100644
--- a/include/linux/mfd/arizona/pdata.h
+++ b/include/linux/mfd/arizona/pdata.h
@@ -56,6 +56,8 @@
 #define ARIZONA_DMIC_MICBIAS2 2
 #define ARIZONA_DMIC_MICBIAS3 3
 
+#define ARIZONA_MAX_MICBIAS 3
+
 #define ARIZONA_INMODE_DIFF 0
 #define ARIZONA_INMODE_SE   1
 #define ARIZONA_INMODE_DMIC 2
@@ -71,6 +73,13 @@
 
 struct regulator_init_data;
 
+struct arizona_micbias {
+	int mV;                    /** Regulated voltage */
+	unsigned int ext_cap:1;    /** External capacitor fitted */
+	unsigned int discharge:1;  /** Actively discharge */
+	unsigned int fast_start:1; /** Enable aggressive startup ramp rate */
+};
+
 struct arizona_micd_config {
 	unsigned int src;
 	unsigned int bias;
@@ -111,6 +120,9 @@ struct arizona_pdata {
 	/** Reference voltage for DMIC inputs */
 	int dmic_ref[ARIZONA_MAX_INPUT];
 
+	/** MICBIAS configurations */
+	struct arizona_micbias micbias[ARIZONA_MAX_MICBIAS];
+
 	/** Mode of input structures */
 	int inmode[ARIZONA_MAX_INPUT];
 
-- 
1.7.10.4

