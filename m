Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756659AbaHHNeR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Aug 2014 09:34:17 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:42554 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752115AbaHHNeP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Aug 2014 09:34:15 -0400
Date: Fri, 8 Aug 2014 14:34:10 +0100
From: Richard Fitzgerald <rf@opensource.wolfsonmicro.com>
To: broonie@linaro.org, lee.jones@linaro.org, sameo@linux.intel.com,
        lgirdwood@gmail.com, perex@perex.cz, tiwai@suse.de
Cc: alsa-devel@alsa-project.org, patches@opensource.wolfsonmicro.com,
        linux-kernel@vger.kernel.org
Subject: [PATCH 2/3 v4 RESEND] ASoC: wm_adsp: Move DVFS control into codec
	driver
Message-ID: <20140808133410.GB2665@opensource.wolfsonmicro.com>
References: <20140808133233.GA2665@opensource.wolfsonmicro.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140808133233.GA2665@opensource.wolfsonmicro.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Richard Fitzgerald <rf@opensource.wolfsonmicro.com>

In theory the ADSP driver should not need to know
anything about the codec it is part of. But some codecs
need DVFS control based on ADSP clocking speed. This was
being handled by bundling part of the knowledge of this
into the ADSP driver.

This change removes this handling out of the ADSP driver.
A new macro WM_ADSP2_E() takes a callback function to be
called by the preloader widget in place of the default
handler, and this can be used to do codec-specific power
control.

The WM5102 driver has been updated to implement the DVFS.

Signed-off-by: Richard Fitzgerald <rf@opensource.wolfsonmicro.com>
Signed-off-by: Charles Keepax <ckeepax@opensource.wolfsonmicro.com>
---
 drivers/regulator/arizona-ldo1.c |    5 ---
 sound/soc/codecs/wm5102.c        |   47 +++++++++++++++++++++++-
 sound/soc/codecs/wm5110.c        |    2 +-
 sound/soc/codecs/wm_adsp.c       |   73 +-------------------------------------
 sound/soc/codecs/wm_adsp.h       |   13 ++++---
 5 files changed, 54 insertions(+), 86 deletions(-)

diff --git a/drivers/regulator/arizona-ldo1.c b/drivers/regulator/arizona-ldo1.c
index 04f262a..47b48c8 100644
--- a/drivers/regulator/arizona-ldo1.c
+++ b/drivers/regulator/arizona-ldo1.c
@@ -78,11 +78,6 @@ static int arizona_ldo1_hc_set_voltage_sel(struct regulator_dev *rdev,
 	if (ret != 0)
 		return ret;
 
-	ret = regmap_update_bits(regmap, ARIZONA_DYNAMIC_FREQUENCY_SCALING_1,
-				 ARIZONA_SUBSYS_MAX_FREQ, val);
-	if (ret != 0)
-		return ret;
-
 	if (val)
 		return 0;
 
diff --git a/sound/soc/codecs/wm5102.c b/sound/soc/codecs/wm5102.c
index fa24d55..0ecc89b 100644
--- a/sound/soc/codecs/wm5102.c
+++ b/sound/soc/codecs/wm5102.c
@@ -612,6 +612,49 @@ static int wm5102_sysclk_ev(struct snd_soc_dapm_widget *w,
 	return 0;
 }
 
+static int wm5102_adsp_power_ev(struct snd_soc_dapm_widget *w,
+		   struct snd_kcontrol *kcontrol, int event)
+{
+	struct snd_soc_codec *codec = w->codec;
+	struct arizona *arizona = dev_get_drvdata(codec->dev->parent);
+	unsigned int v;
+	int ret;
+
+	switch (event) {
+	case SND_SOC_DAPM_PRE_PMU:
+		ret = regmap_read(arizona->regmap, ARIZONA_SYSTEM_CLOCK_1, &v);
+		if (ret != 0) {
+			dev_err(codec->dev,
+				"Failed to read SYSCLK state: %d\n", ret);
+			return -EIO;
+		}
+
+		v = (v & ARIZONA_SYSCLK_FREQ_MASK) >> ARIZONA_SYSCLK_FREQ_SHIFT;
+
+		if (v >= 3) {
+			ret = arizona_dvfs_up(arizona, ARIZONA_DVFS_ADSP1_RQ);
+			if (ret != 0) {
+				dev_err(codec->dev,
+					"Failed to raise DVFS: %d\n", ret);
+				return ret;
+			}
+		}
+		break;
+
+	case SND_SOC_DAPM_POST_PMD:
+		ret = arizona_dvfs_down(arizona, ARIZONA_DVFS_ADSP1_RQ);
+		if (ret != 0)
+			dev_warn(codec->dev,
+				 "Failed to lower DVFS: %d\n", ret);
+		break;
+
+	default:
+		break;
+	}
+
+	return wm_adsp2_early_event(w, kcontrol, event);
+}
+
 static int wm5102_out_comp_coeff_get(struct snd_kcontrol *kcontrol,
 				     struct snd_ctl_elem_value *ucontrol)
 {
@@ -1362,7 +1405,7 @@ ARIZONA_MUX_WIDGETS(ISRC2DEC2, "ISRC2DEC2"),
 ARIZONA_MUX_WIDGETS(ISRC2INT1, "ISRC2INT1"),
 ARIZONA_MUX_WIDGETS(ISRC2INT2, "ISRC2INT2"),
 
-WM_ADSP2("DSP1", 0),
+WM_ADSP2_E("DSP1", 0, wm5102_adsp_power_ev),
 
 SND_SOC_DAPM_OUTPUT("HPOUT1L"),
 SND_SOC_DAPM_OUTPUT("HPOUT1R"),
@@ -1909,7 +1952,7 @@ static int wm5102_probe(struct platform_device *pdev)
 	wm5102->core.adsp[0].mem = wm5102_dsp1_regions;
 	wm5102->core.adsp[0].num_mems = ARRAY_SIZE(wm5102_dsp1_regions);
 
-	ret = wm_adsp2_init(&wm5102->core.adsp[0], true);
+	ret = wm_adsp2_init(&wm5102->core.adsp[0]);
 	if (ret != 0)
 		return ret;
 
diff --git a/sound/soc/codecs/wm5110.c b/sound/soc/codecs/wm5110.c
index 62ef544..a2a3951 100644
--- a/sound/soc/codecs/wm5110.c
+++ b/sound/soc/codecs/wm5110.c
@@ -1688,7 +1688,7 @@ static int wm5110_probe(struct platform_device *pdev)
 		wm5110->core.adsp[i].num_mems
 			= ARRAY_SIZE(wm5110_dsp1_regions);
 
-		ret = wm_adsp2_init(&wm5110->core.adsp[i], false);
+		ret = wm_adsp2_init(&wm5110->core.adsp[i]);
 		if (ret != 0)
 			return ret;
 	}
diff --git a/sound/soc/codecs/wm_adsp.c b/sound/soc/codecs/wm_adsp.c
index 0600271..cdf98bf 100644
--- a/sound/soc/codecs/wm_adsp.c
+++ b/sound/soc/codecs/wm_adsp.c
@@ -1539,35 +1539,6 @@ static void wm_adsp2_boot_work(struct work_struct *work)
 		return;
 	}
 
-	if (dsp->dvfs) {
-		ret = regmap_read(dsp->regmap,
-				  dsp->base + ADSP2_CLOCKING, &val);
-		if (ret != 0) {
-			adsp_err(dsp, "Failed to read clocking: %d\n", ret);
-			return;
-		}
-
-		if ((val & ADSP2_CLK_SEL_MASK) >= 3) {
-			ret = regulator_enable(dsp->dvfs);
-			if (ret != 0) {
-				adsp_err(dsp,
-					 "Failed to enable supply: %d\n",
-					 ret);
-				return;
-			}
-
-			ret = regulator_set_voltage(dsp->dvfs,
-						    1800000,
-						    1800000);
-			if (ret != 0) {
-				adsp_err(dsp,
-					 "Failed to raise supply: %d\n",
-					 ret);
-				return;
-			}
-		}
-	}
-
 	ret = wm_adsp2_ena(dsp);
 	if (ret != 0)
 		return;
@@ -1668,21 +1639,6 @@ int wm_adsp2_event(struct snd_soc_dapm_widget *w,
 		regmap_write(dsp->regmap, dsp->base + ADSP2_WDMA_CONFIG_2, 0);
 		regmap_write(dsp->regmap, dsp->base + ADSP2_RDMA_CONFIG_1, 0);
 
-		if (dsp->dvfs) {
-			ret = regulator_set_voltage(dsp->dvfs, 1200000,
-						    1800000);
-			if (ret != 0)
-				adsp_warn(dsp,
-					  "Failed to lower supply: %d\n",
-					  ret);
-
-			ret = regulator_disable(dsp->dvfs);
-			if (ret != 0)
-				adsp_err(dsp,
-					 "Failed to enable supply: %d\n",
-					 ret);
-		}
-
 		list_for_each_entry(ctl, &dsp->ctl_list, list)
 			ctl->enabled = 0;
 
@@ -1709,7 +1665,7 @@ err:
 }
 EXPORT_SYMBOL_GPL(wm_adsp2_event);
 
-int wm_adsp2_init(struct wm_adsp *adsp, bool dvfs)
+int wm_adsp2_init(struct wm_adsp *adsp)
 {
 	int ret;
 
@@ -1728,33 +1684,6 @@ int wm_adsp2_init(struct wm_adsp *adsp, bool dvfs)
 	INIT_LIST_HEAD(&adsp->ctl_list);
 	INIT_WORK(&adsp->boot_work, wm_adsp2_boot_work);
 
-	if (dvfs) {
-		adsp->dvfs = devm_regulator_get(adsp->dev, "DCVDD");
-		if (IS_ERR(adsp->dvfs)) {
-			ret = PTR_ERR(adsp->dvfs);
-			adsp_err(adsp, "Failed to get DCVDD: %d\n", ret);
-			return ret;
-		}
-
-		ret = regulator_enable(adsp->dvfs);
-		if (ret != 0) {
-			adsp_err(adsp, "Failed to enable DCVDD: %d\n", ret);
-			return ret;
-		}
-
-		ret = regulator_set_voltage(adsp->dvfs, 1200000, 1800000);
-		if (ret != 0) {
-			adsp_err(adsp, "Failed to initialise DVFS: %d\n", ret);
-			return ret;
-		}
-
-		ret = regulator_disable(adsp->dvfs);
-		if (ret != 0) {
-			adsp_err(adsp, "Failed to disable DCVDD: %d\n", ret);
-			return ret;
-		}
-	}
-
 	return 0;
 }
 EXPORT_SYMBOL_GPL(wm_adsp2_init);
diff --git a/sound/soc/codecs/wm_adsp.h b/sound/soc/codecs/wm_adsp.h
index a4f6b64..a86e531 100644
--- a/sound/soc/codecs/wm_adsp.h
+++ b/sound/soc/codecs/wm_adsp.h
@@ -56,8 +56,6 @@ struct wm_adsp {
 	int fw;
 	bool running;
 
-	struct regulator *dvfs;
-
 	struct list_head ctl_list;
 
 	struct work_struct boot_work;
@@ -67,19 +65,22 @@ struct wm_adsp {
 	SND_SOC_DAPM_PGA_E(wname, SND_SOC_NOPM, num, 0, NULL, 0, \
 		wm_adsp1_event, SND_SOC_DAPM_POST_PMU | SND_SOC_DAPM_PRE_PMD)
 
-#define WM_ADSP2(wname, num) \
+#define WM_ADSP2_E(wname, num, event_fn) \
 {	.id = snd_soc_dapm_dai_link, .name = wname " Preloader", \
-	.reg = SND_SOC_NOPM, .shift = num, .event = wm_adsp2_early_event, \
-	.event_flags = SND_SOC_DAPM_PRE_PMU }, \
+	.reg = SND_SOC_NOPM, .shift = num, .event = event_fn, \
+	.event_flags = SND_SOC_DAPM_PRE_PMU | SND_SOC_DAPM_POST_PMD }, \
 {	.id = snd_soc_dapm_out_drv, .name = wname, \
 	.reg = SND_SOC_NOPM, .shift = num, .event = wm_adsp2_event, \
 	.event_flags = SND_SOC_DAPM_POST_PMU | SND_SOC_DAPM_PRE_PMD }
 
+#define WM_ADSP2(wname, num) \
+	WM_ADSP2_E(wname, num, wm_adsp2_early_event)
+
 extern const struct snd_kcontrol_new wm_adsp1_fw_controls[];
 extern const struct snd_kcontrol_new wm_adsp2_fw_controls[];
 
 int wm_adsp1_init(struct wm_adsp *adsp);
-int wm_adsp2_init(struct wm_adsp *adsp, bool dvfs);
+int wm_adsp2_init(struct wm_adsp *adsp);
 int wm_adsp1_event(struct snd_soc_dapm_widget *w,
 		   struct snd_kcontrol *kcontrol, int event);
 int wm_adsp2_early_event(struct snd_soc_dapm_widget *w,
-- 
1.7.2.5

