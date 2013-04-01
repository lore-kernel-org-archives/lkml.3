Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758203Ab3DARbR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Apr 2013 13:31:17 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:47078 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757401Ab3DAR2T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Apr 2013 13:28:19 -0400
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: linux-kernel@vger.kernel.org, patches@opensource.wolfsonmicro.com,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [PATCH 06/15] mfd: arizona: Support configuring MICBIASes into bypass mode
Date: Mon,  1 Apr 2013 18:28:03 +0100
Message-Id: <1364837292-30191-6-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1364837292-30191-1-git-send-email-broonie@opensource.wolfsonmicro.com>
References: <20130401172748.GG18636@opensource.wolfsonmicro.com>
 <1364837292-30191-1-git-send-email-broonie@opensource.wolfsonmicro.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
---
 drivers/mfd/arizona-core.c        |   12 +++++++++++-
 include/linux/mfd/arizona/pdata.h |    1 +
 2 files changed, 12 insertions(+), 1 deletion(-)

diff --git a/drivers/mfd/arizona-core.c b/drivers/mfd/arizona-core.c
index b562c7b..c9df7be 100644
--- a/drivers/mfd/arizona-core.c
+++ b/drivers/mfd/arizona-core.c
@@ -511,10 +511,16 @@ int arizona_dev_init(struct arizona *arizona)
 	}
 
 	for (i = 0; i < ARIZONA_MAX_MICBIAS; i++) {
-		if (!arizona->pdata.micbias[i].mV)
+		if (!arizona->pdata.micbias[i].mV &&
+		    !arizona->pdata.micbias[i].bypass)
 			continue;
 
+		/* Apply default for bypass mode */
+		if (!arizona->pdata.micbias[i].mV)
+			arizona->pdata.micbias[i].mV = 2800;
+
 		val = (arizona->pdata.micbias[i].mV - 1500) / 100;
+
 		val <<= ARIZONA_MICB1_LVL_SHIFT;
 
 		if (arizona->pdata.micbias[i].ext_cap)
@@ -526,10 +532,14 @@ int arizona_dev_init(struct arizona *arizona)
 		if (arizona->pdata.micbias[i].fast_start)
 			val |= ARIZONA_MICB1_RATE;
 
+		if (arizona->pdata.micbias[i].bypass)
+			val |= ARIZONA_MICB1_BYPASS;
+
 		regmap_update_bits(arizona->regmap,
 				   ARIZONA_MIC_BIAS_CTRL_1 + i,
 				   ARIZONA_MICB1_LVL_MASK |
 				   ARIZONA_MICB1_DISCH |
+				   ARIZONA_MICB1_BYPASS |
 				   ARIZONA_MICB1_RATE, val);
 	}
 
diff --git a/include/linux/mfd/arizona/pdata.h b/include/linux/mfd/arizona/pdata.h
index 8755dd0..554d903 100644
--- a/include/linux/mfd/arizona/pdata.h
+++ b/include/linux/mfd/arizona/pdata.h
@@ -78,6 +78,7 @@ struct arizona_micbias {
 	unsigned int ext_cap:1;    /** External capacitor fitted */
 	unsigned int discharge:1;  /** Actively discharge */
 	unsigned int fast_start:1; /** Enable aggressive startup ramp rate */
+	unsigned int bypass:1;     /** Use bypass mode */
 };
 
 struct arizona_micd_config {
-- 
1.7.10.4

