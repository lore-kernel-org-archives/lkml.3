Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758034Ab3DAR3c (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Apr 2013 13:29:32 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:47078 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757560Ab3DAR2V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Apr 2013 13:28:21 -0400
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: linux-kernel@vger.kernel.org, patches@opensource.wolfsonmicro.com,
        Charles Keepax <ckeepax@opensource.wolfsonmicro.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [PATCH 13/15] mfd: arizona: Add a hardware patch mechanism
Date: Mon,  1 Apr 2013 18:28:10 +0100
Message-Id: <1364837292-30191-13-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1364837292-30191-1-git-send-email-broonie@opensource.wolfsonmicro.com>
References: <20130401172748.GG18636@opensource.wolfsonmicro.com>
 <1364837292-30191-1-git-send-email-broonie@opensource.wolfsonmicro.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Charles Keepax <ckeepax@opensource.wolfsonmicro.com>

This patch adds facilities for apply a register patch contained within
the chip using the write sequencer.

Signed-off-by: Charles Keepax <ckeepax@opensource.wolfsonmicro.com>
Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
---
 drivers/mfd/arizona-core.c |  103 ++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 103 insertions(+)

diff --git a/drivers/mfd/arizona-core.c b/drivers/mfd/arizona-core.c
index 559129e..6ca5cfb 100644
--- a/drivers/mfd/arizona-core.c
+++ b/drivers/mfd/arizona-core.c
@@ -242,6 +242,84 @@ static int arizona_wait_for_boot(struct arizona *arizona)
 	return ret;
 }
 
+static int arizona_apply_hardware_patch(struct arizona* arizona)
+{
+	unsigned int fll, sysclk;
+	int ret;
+
+	regcache_cache_bypass(arizona->regmap, true);
+
+	/* Cache existing FLL and SYSCLK settings */
+	ret = regmap_read(arizona->regmap, ARIZONA_FLL1_CONTROL_1, &fll);
+	if (ret < 0) {
+		dev_err(arizona->dev, "Failed to cache FLL settings: %d\n",
+			ret);
+		return ret;
+	}
+	ret = regmap_read(arizona->regmap, ARIZONA_SYSTEM_CLOCK_1, &sysclk);
+	if (ret < 0) {
+		dev_err(arizona->dev, "Failed to cache SYSCLK settings: %d\n",
+			ret);
+		return ret;
+	}
+
+	/* Start up SYSCLK using the FLL in free running mode */
+	ret = regmap_write(arizona->regmap, ARIZONA_FLL1_CONTROL_1,
+			ARIZONA_FLL1_ENA | ARIZONA_FLL1_FREERUN);
+	if (ret < 0) {
+		dev_err(arizona->dev,
+			"Failed to start FLL in freerunning mode: %d\n",
+			ret);
+		return ret;
+	}
+	ret = arizona_poll_reg(arizona, 25, ARIZONA_INTERRUPT_RAW_STATUS_5,
+			       ARIZONA_FLL1_CLOCK_OK_STS,
+			       ARIZONA_FLL1_CLOCK_OK_STS);
+	if (ret < 0) {
+		ret = -ETIMEDOUT;
+		goto err_fll;
+	}
+
+	ret = regmap_write(arizona->regmap, ARIZONA_SYSTEM_CLOCK_1, 0x0144);
+	if (ret < 0) {
+		dev_err(arizona->dev, "Failed to start SYSCLK: %d\n", ret);
+		goto err_fll;
+	}
+
+	/* Start the write sequencer and wait for it to finish */
+	ret = regmap_write(arizona->regmap, ARIZONA_WRITE_SEQUENCER_CTRL_0,
+			ARIZONA_WSEQ_ENA | ARIZONA_WSEQ_START | 160);
+	if (ret < 0) {
+		dev_err(arizona->dev, "Failed to start write sequencer: %d\n",
+			ret);
+		goto err_sysclk;
+	}
+	ret = arizona_poll_reg(arizona, 5, ARIZONA_WRITE_SEQUENCER_CTRL_1,
+			       ARIZONA_WSEQ_BUSY, 0);
+	if (ret < 0) {
+		regmap_write(arizona->regmap, ARIZONA_WRITE_SEQUENCER_CTRL_0,
+				ARIZONA_WSEQ_ABORT);
+		ret = -ETIMEDOUT;
+	}
+
+err_sysclk:
+	ret = regmap_write(arizona->regmap, ARIZONA_SYSTEM_CLOCK_1, sysclk);
+	if (ret < 0)
+		dev_err(arizona->dev,
+			"Failed to re-apply old SYSCLK settings: %d\n",
+			ret);
+
+err_fll:
+	ret = regmap_write(arizona->regmap, ARIZONA_FLL1_CONTROL_1, fll);
+	if (ret < 0)
+		dev_err(arizona->dev,
+			"Failed to re-apply old FLL settings: %d\n",
+			ret);
+
+	regcache_cache_bypass(arizona->regmap, false);
+	return ret;
+}
+
 #ifdef CONFIG_PM_RUNTIME
 static int arizona_runtime_resume(struct device *dev)
 {
@@ -272,6 +350,17 @@ static int arizona_runtime_resume(struct device *dev)
 				ret);
 			goto err;
 		}
+
+		ret = arizona_apply_hardware_patch(arizona);
+		if (ret != 0) {
+			dev_err(arizona->dev,
+				"Failed to apply hardware patch: %d\n",
+				ret);
+			goto err;
+		}
+		break;
+	default:
+		break;
 	}
 
 	ret = regcache_sync(arizona->regmap);
@@ -510,6 +599,20 @@ int arizona_dev_init(struct arizona *arizona)
 				ret);
 			goto err_reset;
 		}
+
+		switch (arizona->type) {
+		case WM5102:
+			ret = arizona_apply_hardware_patch(arizona);
+			if (ret != 0) {
+				dev_err(arizona->dev,
+					"Failed to apply hardware patch: %d\n",
+					ret);
+				goto err_reset;
+			}
+			break;
+		default:
+			break;
+		}
 	}
 
 	for (i = 0; i < ARRAY_SIZE(arizona->pdata.gpio_defaults); i++) {
-- 
1.7.10.4

