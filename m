Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756518AbaHHNcl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Aug 2014 09:32:41 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:42533 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752126AbaHHNck (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Aug 2014 09:32:40 -0400
Date: Fri, 8 Aug 2014 14:32:34 +0100
From: Richard Fitzgerald <rf@opensource.wolfsonmicro.com>
To: broonie@linaro.org, lee.jones@linaro.org, sameo@linux.intel.com,
        lgirdwood@gmail.com, perex@perex.cz, tiwai@suse.de
Cc: linux-kernel@vger.kernel.org, alsa-devel@alsa-project.org,
        patches@opensource.wolfsonmicro.com
Subject: [PATCH 1/3 v4 RESEND] mfd: arizona: Export function to control
	subsystem DVFS
Message-ID: <20140808133233.GA2665@opensource.wolfsonmicro.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Richard Fitzgerald <rf@opensource.wolfsonmicro.com>

Moving this control from being a side-effect of the LDO1
regulator driver to a specific exported function.

Signed-off-by: Richard Fitzgerald <rf@opensource.wolfsonmicro.com>
Signed-off-by: Charles Keepax <ckeepax@opensource.wolfsonmicro.com>
---
 drivers/mfd/arizona-core.c       |   89 ++++++++++++++++++++++++++++++++++++++
 include/linux/mfd/arizona/core.h |   12 +++++
 2 files changed, 101 insertions(+), 0 deletions(-)

diff --git a/drivers/mfd/arizona-core.c b/drivers/mfd/arizona-core.c
index cfc191a..04cde4b 100644
--- a/drivers/mfd/arizona-core.c
+++ b/drivers/mfd/arizona-core.c
@@ -94,6 +94,94 @@ int arizona_clk32k_disable(struct arizona *arizona)
 }
 EXPORT_SYMBOL_GPL(arizona_clk32k_disable);
 
+int arizona_dvfs_up(struct arizona *arizona, unsigned int flags)
+{
+	unsigned int new_flags;
+	int ret = 0;
+
+	mutex_lock(&arizona->subsys_max_lock);
+
+	new_flags = arizona->subsys_max_rq | flags;
+
+	if (arizona->subsys_max_rq != new_flags) {
+		switch (arizona->type) {
+		case WM5102:
+		case WM8997:
+			ret = regulator_set_voltage(arizona->dcvdd,
+						    1800000, 1800000);
+			if (ret != 0) {
+				dev_err(arizona->dev,
+					"Failed to set DCVDD (DVFS up): %d\n",
+					ret);
+				goto err;
+			}
+
+			ret = regmap_update_bits(arizona->regmap,
+					ARIZONA_DYNAMIC_FREQUENCY_SCALING_1,
+					ARIZONA_SUBSYS_MAX_FREQ, 1);
+			if (ret != 0) {
+				dev_err(arizona->dev,
+					"Failed to enable subsys max: %d\n",
+					ret);
+				regulator_set_voltage(arizona->dcvdd,
+						      1200000, 1800000);
+				goto err;
+			}
+			break;
+
+		default:
+			break;
+		}
+
+		arizona->subsys_max_rq = new_flags;
+	}
+err:
+	mutex_unlock(&arizona->subsys_max_lock);
+	return ret;
+}
+EXPORT_SYMBOL_GPL(arizona_dvfs_up);
+
+int arizona_dvfs_down(struct arizona *arizona, unsigned int flags)
+{
+	int ret = 0;
+
+	mutex_lock(&arizona->subsys_max_lock);
+
+	if ((arizona->subsys_max_rq & flags) != flags)
+		dev_warn(arizona->dev, "Unbalanced DVFS down: %x\n", flags);
+
+	arizona->subsys_max_rq &= ~flags;
+
+	if (arizona->subsys_max_rq == 0) {
+		switch (arizona->type) {
+		case WM5102:
+		case WM8997:
+			ret = regmap_update_bits(arizona->regmap,
+					ARIZONA_DYNAMIC_FREQUENCY_SCALING_1,
+					ARIZONA_SUBSYS_MAX_FREQ, 0);
+			if (ret != 0)
+				dev_err(arizona->dev,
+					"Failed to disable subsys max: %d\n",
+					ret);
+
+			ret = regulator_set_voltage(arizona->dcvdd,
+						    1200000, 1800000);
+			if (ret != 0)
+				dev_err(arizona->dev,
+					"Failed to set DCVDD (DVFS down): %d\n",
+					ret);
+			break;
+
+		default:
+			break;
+		}
+	}
+
+	mutex_unlock(&arizona->subsys_max_lock);
+	return ret;
+}
+EXPORT_SYMBOL_GPL(arizona_dvfs_down);
+
 static irqreturn_t arizona_clkgen_err(int irq, void *data)
 {
 	struct arizona *arizona = data;
@@ -641,6 +729,7 @@ int arizona_dev_init(struct arizona *arizona)
 
 	dev_set_drvdata(arizona->dev, arizona);
 	mutex_init(&arizona->clk_lock);
+	mutex_init(&arizona->subsys_max_lock);
 
 	if (dev_get_platdata(arizona->dev))
 		memcpy(&arizona->pdata, dev_get_platdata(arizona->dev),
diff --git a/include/linux/mfd/arizona/core.h b/include/linux/mfd/arizona/core.h
index a614b33..4aec6a3 100644
--- a/include/linux/mfd/arizona/core.h
+++ b/include/linux/mfd/arizona/core.h
@@ -109,6 +109,9 @@ struct arizona {
 	struct mutex clk_lock;
 	int clk32k_ref;
 
+	struct mutex subsys_max_lock;
+	unsigned int subsys_max_rq;
+
 	struct snd_soc_dapm_context *dapm;
 
 	int tdm_width[ARIZONA_MAX_AIF];
@@ -118,8 +121,17 @@ struct arizona {
 	uint8_t dac_comp_enabled;
 };
 
+#define ARIZONA_DVFS_SR1_RQ          0x00000001
+#define ARIZONA_DVFS_SR2_RQ          0x00000002
+#define ARIZONA_DVFS_SR3_RQ          0x00000004
+#define ARIZONA_DVFS_ASR1_RQ         0x00000010
+#define ARIZONA_DVFS_ASR2_RQ         0x00000020
+#define ARIZONA_DVFS_ADSP1_RQ        0x00010000
+
 int arizona_clk32k_enable(struct arizona *arizona);
 int arizona_clk32k_disable(struct arizona *arizona);
+int arizona_dvfs_up(struct arizona *arizona, unsigned int mask);
+int arizona_dvfs_down(struct arizona *arizona, unsigned int mask);
 
 int arizona_request_irq(struct arizona *arizona, int irq, char *name,
 			irq_handler_t handler, void *data);
-- 
1.7.2.5

