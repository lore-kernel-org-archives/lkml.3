Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761039Ab3DBLgN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Apr 2013 07:36:13 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:46550 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759941Ab3DBLdA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Apr 2013 07:33:00 -0400
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        MyungJoo Ham <myungjoo.ham@samsung.com>,
        Chanwoo Choi <cw00.choi@samsung.com>
Cc: linux-kernel@vger.kernel.org, patches@opensource.wolfsonmicro.com,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [PATCH 03/16] extcon: arizona: Allow configuration of button detection
Date: Tue,  2 Apr 2013 12:32:35 +0100
Message-Id: <1364902368-1123-3-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1364902368-1123-1-git-send-email-broonie@opensource.wolfsonmicro.com>
References: <20130402113157.GJ23065@opensource.wolfsonmicro.com>
 <1364902368-1123-1-git-send-email-broonie@opensource.wolfsonmicro.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The Arizona button detection circuit is configurable, allowing the system
integrator to program a range of thresholds for the buttons supported on
the accessory but currently the driver uses the default button ranges and
does not provide any flexibility in how this is exposed to the application
layer.

Provide platform data allowing the user to control this and to map
the buttons to keys in the input subsystem.

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
---
 drivers/extcon/extcon-arizona.c   |  164 ++++++++++++++++++++++++++++---------
 include/linux/mfd/arizona/pdata.h |    9 ++
 2 files changed, 134 insertions(+), 39 deletions(-)

diff --git a/drivers/extcon/extcon-arizona.c b/drivers/extcon/extcon-arizona.c
index 4bb0e9a..e233962 100644
--- a/drivers/extcon/extcon-arizona.c
+++ b/drivers/extcon/extcon-arizona.c
@@ -33,7 +33,7 @@
 #include <linux/mfd/arizona/pdata.h>
 #include <linux/mfd/arizona/registers.h>
 
-#define ARIZONA_NUM_BUTTONS 6
+#define ARIZONA_MAX_MICD_RANGE 8
 
 #define ARIZONA_ACCDET_MODE_MIC 0
 #define ARIZONA_ACCDET_MODE_HPL 1
@@ -50,6 +50,9 @@ struct arizona_extcon_info {
 	const struct arizona_micd_config *micd_modes;
 	int micd_num_modes;
 
+	const struct arizona_micd_range *micd_ranges;
+	int num_micd_ranges;
+
 	bool micd_reva;
 	bool micd_clamp;
 
@@ -71,20 +74,25 @@ struct arizona_extcon_info {
 };
 
 static const struct arizona_micd_config micd_default_modes[] = {
-	{ 0,                  2 << ARIZONA_MICD_BIAS_SRC_SHIFT, 1 },
 	{ ARIZONA_ACCDET_SRC, 1 << ARIZONA_MICD_BIAS_SRC_SHIFT, 0 },
+	{ 0,                  2 << ARIZONA_MICD_BIAS_SRC_SHIFT, 1 },
 };
 
-static struct {
-	u16 status;
-	int report;
-} arizona_lvl_to_key[ARIZONA_NUM_BUTTONS] = {
-	{  0x1, BTN_0 },
-	{  0x2, BTN_1 },
-	{  0x4, BTN_2 },
-	{  0x8, BTN_3 },
-	{ 0x10, BTN_4 },
-	{ 0x20, BTN_5 },
+static const struct arizona_micd_range micd_default_ranges[] = {
+	{ .max =  11, .key = BTN_0 },
+	{ .max =  28, .key = BTN_1 },
+	{ .max =  54, .key = BTN_2 },
+	{ .max = 100, .key = BTN_3 },
+	{ .max = 186, .key = BTN_4 },
+	{ .max = 430, .key = BTN_5 },
+};
+
+static const int arizona_micd_levels[] = {
+	3, 6, 8, 11, 13, 16, 18, 21, 23, 26, 28, 31, 34, 36, 39, 41, 44, 46,
+	49, 52, 54, 57, 60, 62, 65, 67, 70, 73, 75, 78, 81, 83, 89, 94, 100,
+	105, 111, 116, 122, 127, 139, 150, 161, 173, 186, 196, 209, 220, 245,
+	270, 295, 321, 348, 375, 402, 430, 489, 550, 614, 681, 752, 903, 1071,
+	1257,
 };
 
 #define ARIZONA_CABLE_MECHANICAL 0
@@ -153,7 +161,7 @@ static void arizona_extcon_set_mode(struct arizona_extcon_info *info, int mode)
 {
 	struct arizona *arizona = info->arizona;
 
-	mode %= info->num_micd_modes;
+	mode %= info->micd_num_modes;
 
 	if (arizona->pdata.micd_pol_gpio > 0)
 		gpio_set_value_cansleep(arizona->pdata.micd_pol_gpio,
@@ -728,7 +736,7 @@ static irqreturn_t arizona_micdet(int irq, void *data)
 	struct arizona_extcon_info *info = data;
 	struct arizona *arizona = info->arizona;
 	unsigned int val, lvl;
-	int ret, i;
+	int ret, i, key;
 
 	mutex_lock(&info->lock);
 
@@ -815,12 +823,13 @@ static irqreturn_t arizona_micdet(int irq, void *data)
 			lvl = val & ARIZONA_MICD_LVL_MASK;
 			lvl >>= ARIZONA_MICD_LVL_SHIFT;
 
-			for (i = 0; i < ARIZONA_NUM_BUTTONS; i++)
-				if (lvl & arizona_lvl_to_key[i].status)
-					input_report_key(info->input,
-							 arizona_lvl_to_key[i].report,
-							 1);
-			input_sync(info->input);
+			WARN_ON(!lvl);
+			WARN_ON(ffs(lvl) - 1 >= info->num_micd_ranges);
+			if (lvl && ffs(lvl) - 1 < info->num_micd_ranges) {
+				key = info->micd_ranges[ffs(lvl) - 1].key;
+				input_report_key(info->input, key, 1);
+				input_sync(info->input);
+			}
 
 		} else if (info->detecting) {
 			dev_dbg(arizona->dev, "Headphone detected\n");
@@ -834,9 +843,9 @@ static irqreturn_t arizona_micdet(int irq, void *data)
 		}
 	} else {
 		dev_dbg(arizona->dev, "Mic button released\n");
-		for (i = 0; i < ARIZONA_NUM_BUTTONS; i++)
+		for (i = 0; i < info->num_micd_ranges; i++)
 			input_report_key(info->input,
-					 arizona_lvl_to_key[i].report, 0);
+					 info->micd_ranges[i].key, 0);
 		input_sync(info->input);
 		arizona_extcon_pulse_micbias(info);
 	}
@@ -923,9 +932,9 @@ static irqreturn_t arizona_jackdet(int irq, void *data)
 		info->mic = false;
 		info->hpdet_done = false;
 
-		for (i = 0; i < ARIZONA_NUM_BUTTONS; i++)
+		for (i = 0; i < info->num_micd_ranges; i++)
 			input_report_key(info->input,
-					 arizona_lvl_to_key[i].report, 0);
+					 info->micd_ranges[i].key, 0);
 		input_sync(info->input);
 
 		ret = extcon_update_state(&info->edev, 0xffffffff, 0);
@@ -954,13 +963,33 @@ static irqreturn_t arizona_jackdet(int irq, void *data)
 	return IRQ_HANDLED;
 }
 
+/* Map a level onto a slot in the register bank */
+static void arizona_micd_set_level(struct arizona *arizona, int index,
+				   unsigned int level)
+{
+	int reg;
+	unsigned int mask;
+
+	reg = ARIZONA_MIC_DETECT_LEVEL_4 - (index / 2);
+
+	if (!(index % 2)) {
+		mask = 0x3f00;
+		level <<= 8;
+	} else {
+		mask = 0x3f;
+	}
+
+	/* Program the level itself */
+	regmap_update_bits(arizona->regmap, reg, mask, level);
+}
+
 static int arizona_extcon_probe(struct platform_device *pdev)
 {
 	struct arizona *arizona = dev_get_drvdata(pdev->dev.parent);
 	struct arizona_pdata *pdata;
 	struct arizona_extcon_info *info;
 	int jack_irq_fall, jack_irq_rise;
-	int ret, mode, i;
+	int ret, mode, i, j;
 
 	if (!arizona->dapm || !arizona->dapm->card)
 		return -EPROBE_DEFER;
@@ -1013,6 +1042,17 @@ static int arizona_extcon_probe(struct platform_device *pdev)
 		goto err;
 	}
 
+	info->input = devm_input_allocate_device(&pdev->dev);
+	if (!info->input) {
+		dev_err(arizona->dev, "Can't allocate input dev\n");
+		ret = -ENOMEM;
+		goto err_register;
+	}
+
+	info->input->name = "Headset";
+	info->input->phys = "arizona/extcon";
+	info->input->dev.parent = &pdev->dev;
+
 	if (pdata->num_micd_configs) {
 		info->micd_modes = pdata->micd_configs;
 		info->micd_num_modes = pdata->num_micd_configs;
@@ -1068,6 +1108,66 @@ static int arizona_extcon_probe(struct platform_device *pdev)
 				   arizona->pdata.micd_dbtime
 				   << ARIZONA_MICD_DBTIME_SHIFT);
 
+	BUILD_BUG_ON(ARRAY_SIZE(arizona_micd_levels) != 0x40);
+
+	if (arizona->pdata.num_micd_ranges) {
+		info->micd_ranges = pdata->micd_ranges;
+		info->num_micd_ranges = pdata->num_micd_ranges;
+	} else {
+		info->micd_ranges = micd_default_ranges;
+		info->num_micd_ranges = ARRAY_SIZE(micd_default_ranges);
+	}
+
+	if (arizona->pdata.num_micd_ranges > ARIZONA_MAX_MICD_RANGE) {
+		dev_err(arizona->dev, "Too many MICD ranges: %d\n",
+			arizona->pdata.num_micd_ranges);
+	}
+
+	if (info->num_micd_ranges > 1) {
+		for (i = 1; i < info->num_micd_ranges; i++) {
+			if (info->micd_ranges[i - 1].max >
+			    info->micd_ranges[i].max) {
+				dev_err(arizona->dev,
+					"MICD ranges must be sorted\n");
+				ret = -EINVAL;
+				goto err_input;
+			}
+		}
+	}
+
+	/* Disable all buttons by default */
+	regmap_update_bits(arizona->regmap, ARIZONA_MIC_DETECT_2,
+			   ARIZONA_MICD_LVL_SEL_MASK, 0x81);
+
+	/* Set up all the buttons the user specified */
+	for (i = 0; i < info->num_micd_ranges; i++) {
+		for (j = 0; j < ARRAY_SIZE(arizona_micd_levels); j++)
+			if (arizona_micd_levels[j] >= info->micd_ranges[i].max)
+				break;
+
+		if (j == ARRAY_SIZE(arizona_micd_levels)) {
+			dev_err(arizona->dev, "Unsupported MICD level %d\n",
+				info->micd_ranges[i].max);
+			ret = -EINVAL;
+			goto err_input;
+		}
+
+		dev_dbg(arizona->dev, "%d ohms for MICD threshold %d\n",
+			arizona_micd_levels[j], i);
+
+		arizona_micd_set_level(arizona, i, j);
+		input_set_capability(info->input, EV_KEY,
+				     info->micd_ranges[i].key);
+
+		/* Enable reporting of that range */
+		regmap_update_bits(arizona->regmap, ARIZONA_MIC_DETECT_2,
+				   1 << i, 1 << i);
+	}
+
+	/* Set all the remaining keys to a maximum */
+	for (; i < ARIZONA_MAX_MICD_RANGE; i++)
+		arizona_micd_set_level(arizona, i, 0x3f);
+
 	/*
 	 * If we have a clamp use it, activating in conjunction with
 	 * GPIO5 if that is connected for jack detect operation.
@@ -1095,20 +1195,6 @@ static int arizona_extcon_probe(struct platform_device *pdev)
 
 	arizona_extcon_set_mode(info, 0);
 
-	info->input = devm_input_allocate_device(&pdev->dev);
-	if (!info->input) {
-		dev_err(arizona->dev, "Can't allocate input dev\n");
-		ret = -ENOMEM;
-		goto err_register;
-	}
-
-	for (i = 0; i < ARIZONA_NUM_BUTTONS; i++)
-		input_set_capability(info->input, EV_KEY,
-				     arizona_lvl_to_key[i].report);
-	info->input->name = "Headset";
-	info->input->phys = "arizona/extcon";
-	info->input->dev.parent = &pdev->dev;
-
 	pm_runtime_enable(&pdev->dev);
 	pm_runtime_idle(&pdev->dev);
 	pm_runtime_get_sync(&pdev->dev);
diff --git a/include/linux/mfd/arizona/pdata.h b/include/linux/mfd/arizona/pdata.h
index 455c51d..eb11a8a 100644
--- a/include/linux/mfd/arizona/pdata.h
+++ b/include/linux/mfd/arizona/pdata.h
@@ -86,6 +86,11 @@ struct arizona_micd_config {
 	bool gpio;
 };
 
+struct arizona_micd_range {
+	int max;  /** Ohms */
+	int key;  /** Key to report to input layer */
+};
+
 struct arizona_pdata {
 	int reset;      /** GPIO controlling /RESET, if any */
 	int ldoena;     /** GPIO controlling LODENA, if any */
@@ -138,6 +143,10 @@ struct arizona_pdata {
 	/** Force MICBIAS on for mic detect */
 	bool micd_force_micbias;
 
+	/** Mic detect level parameters */
+	const struct arizona_micd_range *micd_ranges;
+	int num_micd_ranges;
+
 	/** Headset polarity configurations */
 	struct arizona_micd_config *micd_configs;
 	int num_micd_configs;
-- 
1.7.10.4

