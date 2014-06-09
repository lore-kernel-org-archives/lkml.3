Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964791AbaFIPCf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jun 2014 11:02:35 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:54868 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933650AbaFIPCb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jun 2014 11:02:31 -0400
Date: Mon, 9 Jun 2014 16:02:26 +0100
From: Richard Fitzgerald <rf@opensource.wolfsonmicro.com>
To: sameo@linux.intel.com, lee.jones@linaro.org,
        ckeepax@opensource.wolfsonmicro.com, broonie@kernel.org,
        lgirdwood@gmail.com, perex@perex.cz, tiwai@suse.de
Cc: alsa-devel@alsa-project.org, patches@opensource.wolfsonmicro.com,
        linux-kernel@vger.kernel.org
Subject: [PATCH 1/4] mfd: arizona: Export function to control subsystem DVFS
Message-ID: <20140609150226.GB5229@opensource.wolfsonmicro.com>
References: <20140609150013.GA5229@opensource.wolfsonmicro.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140609150013.GA5229@opensource.wolfsonmicro.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Moving this control from being a side-effect of the LDO1
regulator driver to a specific exported function.

Signed-off-by: Richard Fitzgerald <rf@opensource.wolfsonmicro.com>
---
 drivers/mfd/arizona-core.c       |   84 ++++++++++++++++++++++++++++++++++++++
 include/linux/mfd/arizona/core.h |   12 +++++
 2 files changed, 96 insertions(+), 0 deletions(-)

diff --git a/drivers/mfd/arizona-core.c b/drivers/mfd/arizona-core.c
index 58e1fe5..a1b4fe6 100644
--- a/drivers/mfd/arizona-core.c
+++ b/drivers/mfd/arizona-core.c
@@ -94,6 +94,89 @@ int arizona_clk32k_disable(struct arizona *arizona)
 }
 EXPORT_SYMBOL_GPL(arizona_clk32k_disable);
 
+int arizona_dvfs_up(struct arizona *arizona, unsigned int mask)
+{
+	unsigned int new_flags;
+	int ret = 0;
+
+	mutex_lock(&arizona->subsys_max_lock);
+
+	new_flags = arizona->subsys_max_rq | mask;
+
+	if (arizona->subsys_max_rq != new_flags) {
+		switch (arizona->type) {
+		case WM5102:
+		case WM8997:
+			ret = regulator_set_voltage(arizona->dcvdd,
+						    1800000, 1800000);
+			if (ret != 0) {
+				dev_err(arizona->dev,
+					"Failed to raise dcvdd (%u)\n", ret);
+				goto err;
+			}
+
+			ret = regmap_update_bits(arizona->regmap,
+					ARIZONA_DYNAMIC_FREQUENCY_SCALING_1,
+					ARIZONA_SUBSYS_MAX_FREQ, 1);
+			if (ret != 0) {
+				dev_err(arizona->dev,
+					"Failed to enable subsys max (%u)\n",
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
+	arizona->subsys_max_rq = new_flags;
+	}
+err:
+	mutex_unlock(&arizona->subsys_max_lock);
+	return ret;
+}
+EXPORT_SYMBOL_GPL(arizona_dvfs_up);
+
+int arizona_dvfs_down(struct arizona *arizona, unsigned int mask)
+{
+	int ret = 0;
+
+	mutex_lock(&arizona->subsys_max_lock);
+
+	arizona->subsys_max_rq &= ~mask;
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
+					"Failed to disable subsys max (%u)\n",
+					ret);
+
+			ret = regulator_set_voltage(arizona->dcvdd,
+						    1200000, 1800000);
+			if (ret != 0)
+				dev_err(arizona->dev,
+					"Failed to lower dcvdd (%u)\n", ret);
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
@@ -645,6 +728,7 @@ int arizona_dev_init(struct arizona *arizona)
 
 	dev_set_drvdata(arizona->dev, arizona);
 	mutex_init(&arizona->clk_lock);
+	mutex_init(&arizona->subsys_max_lock);
 
 	if (dev_get_platdata(arizona->dev))
 		memcpy(&arizona->pdata, dev_get_platdata(arizona->dev),
diff --git a/include/linux/mfd/arizona/core.h b/include/linux/mfd/arizona/core.h
index 76564af..b4b8a7e 100644
--- a/include/linux/mfd/arizona/core.h
+++ b/include/linux/mfd/arizona/core.h
@@ -132,11 +132,23 @@ struct arizona {
 	struct mutex clk_lock;
 	int clk32k_ref;
 
+	struct mutex subsys_max_lock;
+	unsigned int subsys_max_rq;
+
 	struct snd_soc_dapm_context *dapm;
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


