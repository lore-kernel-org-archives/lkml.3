Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754182AbaKMPFO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Nov 2014 10:05:14 -0500
Received: from mailout1.samsung.com ([203.254.224.24]:50432 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752931AbaKMPFL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Nov 2014 10:05:11 -0500
X-AuditID: cbfee61b-f79d76d0000024d6-cc-5464c8a51ec5
From: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
To: Eduardo Valentin <edubezval@gmail.com>
Cc: Zhang Rui <rui.zhang@intel.com>,
        Amit Daniel Kachhap <amit.daniel@samsung.com>,
        Lukasz Majewski <l.majewski@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        linux-samsung-soc@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, b.zolnierkie@samsung.com
Subject: [PATCH v2 18/33] thermal: exynos: add ->tmu_initialize method
Date: Thu, 13 Nov 2014 16:01:13 +0100
Message-id: <1415890888-8881-19-git-send-email-b.zolnierkie@samsung.com>
X-Mailer: git-send-email 1.7.10.4
In-reply-to: <1415890888-8881-1-git-send-email-b.zolnierkie@samsung.com>
References: <1415890888-8881-1-git-send-email-b.zolnierkie@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprJLMWRmVeSWpSXmKPExsVy+t9jQd2lJ1JCDK6fV7douBpisXHGelaL
	+VeusVqcbXrDbvHm4WZGi8u75rBZfO49wmgx4/w+JosnD/vYHDg9ds66y+6xeM9LJo++LasY
	PT5vkgtgieKySUnNySxLLdK3S+DK+Pj1B1vBwQbGisvrL7E2MK7N7mLk4JAQMJE4dKOqi5ET
	yBSTuHBvPVsXIxeHkMB0Rom9HzaxQjhdTBJ7XrexglSxCVhJTGxfxQhiiwhoSZy4tJ0JpIhZ
	YBmTxKVv85lAEsICbhLHTh5lA7FZBFQlDl1ZxQJi8wp4SLSuXcwEsU5RovvZBLAaTqD4q6l/
	wYYKCbhLXHv0jnkCI+8CRoZVjKKpBckFxUnpuUZ6xYm5xaV56XrJ+bmbGMEB9kx6B+OqBotD
	jAIcjEo8vC9YUkKEWBPLiitzDzFKcDArifB6HwYK8aYkVlalFuXHF5XmpBYfYpTmYFES5z3Y
	ah0oJJCeWJKanZpakFoEk2Xi4JRqYJSaZr/P9lzm16MZ7+Ysc5LflyN4TVDyb5mN/5pb63q7
	Ky5kHdeLuh+v2lsSxMWnbZ3b3deovLdG/f2sN053zz3ar1pRprStXIlB9do3ldUS81pWn//q
	VuP5Xmir68v+qgPG+gbLHjxduefuJT6Xq709poYSgZmPF/6te+Got+++uYKhfYiBkxJLcUai
	oRZzUXEiAD7OcQUsAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add ->tmu_initialize method to struct exynos_tmu_data and
use it in exynos_tmu_initialize().  Then add ->tmu_initialize
implementations for Exynos4210, Exynos4412+ and Exynos5440.
Finally remove no longer needed reg->threshold_th[0,1],
reg->intclr_[fall,rise]_shift and reg->intclr_[rise,fall]_mask
abstractions.

There are more improvements available in the future on top
of this patch like merging HW_TRIP level setting with setting
of other levels for Exynos4412+ or adding separate method
for clearing IRQs using INTCLEAR register (for Exynos5420,
Exynos5260 and Exynos4412+).

There should be no functional changes caused by this patch.

Cc: Amit Daniel Kachhap <amit.daniel@samsung.com>
Cc: Lukasz Majewski <l.majewski@samsung.com>
Cc: Eduardo Valentin <edubezval@gmail.com>
Cc: Zhang Rui <rui.zhang@intel.com>
Signed-off-by: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Acked-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 drivers/thermal/samsung/exynos_tmu.c      | 276 +++++++++++++++++-------------
 drivers/thermal/samsung/exynos_tmu.h      |   5 -
 drivers/thermal/samsung/exynos_tmu_data.c |  11 --
 3 files changed, 159 insertions(+), 133 deletions(-)

diff --git a/drivers/thermal/samsung/exynos_tmu.c b/drivers/thermal/samsung/exynos_tmu.c
index 6e82fdd..736ef78 100644
--- a/drivers/thermal/samsung/exynos_tmu.c
+++ b/drivers/thermal/samsung/exynos_tmu.c
@@ -52,6 +52,7 @@
  * @temp_error2: fused value of the second point trim.
  * @regulator: pointer to the TMU regulator structure.
  * @reg_conf: pointer to structure to register with core thermal.
+ * @tmu_initialize: SoC specific TMU initialization method
  */
 struct exynos_tmu_data {
 	int id;
@@ -66,6 +67,7 @@ struct exynos_tmu_data {
 	u8 temp_error1, temp_error2;
 	struct regulator *regulator;
 	struct thermal_sensor_conf *reg_conf;
+	int (*tmu_initialize)(struct platform_device *pdev);
 };
 
 /*
@@ -180,118 +182,13 @@ static u32 get_th_reg(struct exynos_tmu_data *data, u32 threshold, bool falling)
 static int exynos_tmu_initialize(struct platform_device *pdev)
 {
 	struct exynos_tmu_data *data = platform_get_drvdata(pdev);
-	struct exynos_tmu_platform_data *pdata = data->pdata;
-	const struct exynos_tmu_registers *reg = pdata->registers;
-	unsigned int status, trim_info = 0, con, ctrl;
-	unsigned int rising_threshold = 0, falling_threshold = 0;
-	int ret = 0, threshold_code, i;
+	int ret;
 
 	mutex_lock(&data->lock);
 	clk_enable(data->clk);
 	if (!IS_ERR(data->clk_sec))
 		clk_enable(data->clk_sec);
-
-	if (data->soc != SOC_ARCH_EXYNOS5440) {
-		status = readb(data->base + EXYNOS_TMU_REG_STATUS);
-		if (!status) {
-			ret = -EBUSY;
-			goto out;
-		}
-	}
-
-	if (data->soc == SOC_ARCH_EXYNOS3250 ||
-	    data->soc == SOC_ARCH_EXYNOS4412 ||
-	    data->soc == SOC_ARCH_EXYNOS5250) {
-		if (data->soc == SOC_ARCH_EXYNOS3250) {
-			ctrl = readl(data->base + EXYNOS_TMU_TRIMINFO_CON1);
-			ctrl |= EXYNOS_TRIMINFO_RELOAD_ENABLE;
-			writel(ctrl, data->base + EXYNOS_TMU_TRIMINFO_CON1);
-		}
-		ctrl = readl(data->base + EXYNOS_TMU_TRIMINFO_CON2);
-		ctrl |= EXYNOS_TRIMINFO_RELOAD_ENABLE;
-		writel(ctrl, data->base + EXYNOS_TMU_TRIMINFO_CON2);
-	}
-
-	/* Save trimming info in order to perform calibration */
-	if (data->soc == SOC_ARCH_EXYNOS5440) {
-		/*
-		 * For exynos5440 soc triminfo value is swapped between TMU0 and
-		 * TMU2, so the below logic is needed.
-		 */
-		switch (data->id) {
-		case 0:
-			trim_info = readl(data->base +
-			EXYNOS5440_EFUSE_SWAP_OFFSET + EXYNOS5440_TMU_S0_7_TRIM);
-			break;
-		case 1:
-			trim_info = readl(data->base + EXYNOS5440_TMU_S0_7_TRIM);
-			break;
-		case 2:
-			trim_info = readl(data->base -
-			EXYNOS5440_EFUSE_SWAP_OFFSET + EXYNOS5440_TMU_S0_7_TRIM);
-		}
-	} else {
-		/* On exynos5420 the triminfo register is in the shared space */
-		if (data->soc == SOC_ARCH_EXYNOS5420_TRIMINFO)
-			trim_info = readl(data->base_second +
-						EXYNOS_TMU_REG_TRIMINFO);
-		else
-			trim_info = readl(data->base + EXYNOS_TMU_REG_TRIMINFO);
-	}
-	sanitize_temp_error(data, trim_info);
-
-	if (data->soc == SOC_ARCH_EXYNOS4210) {
-		/* Write temperature code for threshold */
-		threshold_code = temp_to_code(data, pdata->threshold);
-		writeb(threshold_code,
-			data->base + EXYNOS4210_TMU_REG_THRESHOLD_TEMP);
-		for (i = 0; i < pdata->non_hw_trigger_levels; i++)
-			writeb(pdata->trigger_levels[i], data->base +
-			reg->threshold_th0 + i * sizeof(reg->threshold_th0));
-
-		exynos_tmu_clear_irqs(data);
-	} else {
-		/* Write temperature code for rising and falling threshold */
-		rising_threshold = readl(data->base + reg->threshold_th0);
-		rising_threshold = get_th_reg(data, rising_threshold, false);
-		if (data->soc != SOC_ARCH_EXYNOS5440)
-			falling_threshold = get_th_reg(data, 0, true);
-
-		writel(rising_threshold,
-				data->base + reg->threshold_th0);
-		writel(falling_threshold,
-				data->base + reg->threshold_th1);
-
-		exynos_tmu_clear_irqs(data);
-
-		/* if last threshold limit is also present */
-		i = pdata->max_trigger_level - 1;
-		if (pdata->trigger_levels[i] &&
-				(pdata->trigger_type[i] == HW_TRIP)) {
-			threshold_code = temp_to_code(data,
-						pdata->trigger_levels[i]);
-			if (data->soc != SOC_ARCH_EXYNOS5440) {
-				/* 1-4 level to be assigned in th0 reg */
-				rising_threshold &= ~(0xff << 8 * i);
-				rising_threshold |= threshold_code << 8 * i;
-				writel(rising_threshold,
-					data->base + EXYNOS_THD_TEMP_RISE);
-			} else {
-				/* 5th level to be assigned in th2 reg */
-				rising_threshold =
-				threshold_code << EXYNOS5440_TMU_TH_RISE4_SHIFT;
-				writel(rising_threshold,
-					data->base + EXYNOS5440_TMU_S0_7_TH2);
-			}
-			con = readl(data->base + reg->tmu_ctrl);
-			con |= (1 << EXYNOS_TMU_THERM_TRIP_EN_SHIFT);
-			writel(con, data->base + reg->tmu_ctrl);
-		}
-	}
-	/*Clear the PMIN in the common TMU register*/
-	if (data->soc == SOC_ARCH_EXYNOS5440 && !data->id)
-		writel(0, data->base_second + EXYNOS5440_TMU_PMIN);
-out:
+	ret = data->tmu_initialize(pdev);
 	clk_disable(data->clk);
 	mutex_unlock(&data->lock);
 	if (!IS_ERR(data->clk_sec))
@@ -347,6 +244,143 @@ static void exynos_tmu_control(struct platform_device *pdev, bool on)
 	mutex_unlock(&data->lock);
 }
 
+static int exynos4210_tmu_initialize(struct platform_device *pdev)
+{
+	struct exynos_tmu_data *data = platform_get_drvdata(pdev);
+	struct exynos_tmu_platform_data *pdata = data->pdata;
+	unsigned int status;
+	int ret = 0, threshold_code, i;
+
+	status = readb(data->base + EXYNOS_TMU_REG_STATUS);
+	if (!status) {
+		ret = -EBUSY;
+		goto out;
+	}
+
+	sanitize_temp_error(data, readl(data->base + EXYNOS_TMU_REG_TRIMINFO));
+
+	/* Write temperature code for threshold */
+	threshold_code = temp_to_code(data, pdata->threshold);
+	writeb(threshold_code, data->base + EXYNOS4210_TMU_REG_THRESHOLD_TEMP);
+
+	for (i = 0; i < pdata->non_hw_trigger_levels; i++)
+		writeb(pdata->trigger_levels[i], data->base +
+		       EXYNOS4210_TMU_REG_TRIG_LEVEL0 + i * 4);
+
+	exynos_tmu_clear_irqs(data);
+out:
+	return ret;
+}
+
+static int exynos4412_tmu_initialize(struct platform_device *pdev)
+{
+	struct exynos_tmu_data *data = platform_get_drvdata(pdev);
+	struct exynos_tmu_platform_data *pdata = data->pdata;
+	unsigned int status, trim_info, con, ctrl, rising_threshold;
+	int ret = 0, threshold_code, i;
+
+	status = readb(data->base + EXYNOS_TMU_REG_STATUS);
+	if (!status) {
+		ret = -EBUSY;
+		goto out;
+	}
+
+	if (data->soc == SOC_ARCH_EXYNOS3250 ||
+	    data->soc == SOC_ARCH_EXYNOS4412 ||
+	    data->soc == SOC_ARCH_EXYNOS5250) {
+		if (data->soc == SOC_ARCH_EXYNOS3250) {
+			ctrl = readl(data->base + EXYNOS_TMU_TRIMINFO_CON1);
+			ctrl |= EXYNOS_TRIMINFO_RELOAD_ENABLE;
+			writel(ctrl, data->base + EXYNOS_TMU_TRIMINFO_CON1);
+		}
+		ctrl = readl(data->base + EXYNOS_TMU_TRIMINFO_CON2);
+		ctrl |= EXYNOS_TRIMINFO_RELOAD_ENABLE;
+		writel(ctrl, data->base + EXYNOS_TMU_TRIMINFO_CON2);
+	}
+
+	/* On exynos5420 the triminfo register is in the shared space */
+	if (data->soc == SOC_ARCH_EXYNOS5420_TRIMINFO)
+		trim_info = readl(data->base_second + EXYNOS_TMU_REG_TRIMINFO);
+	else
+		trim_info = readl(data->base + EXYNOS_TMU_REG_TRIMINFO);
+
+	sanitize_temp_error(data, trim_info);
+
+	/* Write temperature code for rising and falling threshold */
+	rising_threshold = readl(data->base + EXYNOS_THD_TEMP_RISE);
+	rising_threshold = get_th_reg(data, rising_threshold, false);
+	writel(rising_threshold, data->base + EXYNOS_THD_TEMP_RISE);
+	writel(get_th_reg(data, 0, true), data->base + EXYNOS_THD_TEMP_FALL);
+
+	exynos_tmu_clear_irqs(data);
+
+	/* if last threshold limit is also present */
+	i = pdata->max_trigger_level - 1;
+	if (pdata->trigger_levels[i] && pdata->trigger_type[i] == HW_TRIP) {
+		threshold_code = temp_to_code(data, pdata->trigger_levels[i]);
+		/* 1-4 level to be assigned in th0 reg */
+		rising_threshold &= ~(0xff << 8 * i);
+		rising_threshold |= threshold_code << 8 * i;
+		writel(rising_threshold, data->base + EXYNOS_THD_TEMP_RISE);
+		con = readl(data->base + EXYNOS_TMU_REG_CONTROL);
+		con |= (1 << EXYNOS_TMU_THERM_TRIP_EN_SHIFT);
+		writel(con, data->base + EXYNOS_TMU_REG_CONTROL);
+	}
+out:
+	return ret;
+}
+
+static int exynos5440_tmu_initialize(struct platform_device *pdev)
+{
+	struct exynos_tmu_data *data = platform_get_drvdata(pdev);
+	struct exynos_tmu_platform_data *pdata = data->pdata;
+	unsigned int trim_info = 0, con, rising_threshold;
+	int ret = 0, threshold_code, i;
+
+	/*
+	 * For exynos5440 soc triminfo value is swapped between TMU0 and
+	 * TMU2, so the below logic is needed.
+	 */
+	switch (data->id) {
+	case 0:
+		trim_info = readl(data->base + EXYNOS5440_EFUSE_SWAP_OFFSET +
+				 EXYNOS5440_TMU_S0_7_TRIM);
+		break;
+	case 1:
+		trim_info = readl(data->base + EXYNOS5440_TMU_S0_7_TRIM);
+		break;
+	case 2:
+		trim_info = readl(data->base - EXYNOS5440_EFUSE_SWAP_OFFSET +
+				  EXYNOS5440_TMU_S0_7_TRIM);
+	}
+	sanitize_temp_error(data, trim_info);
+
+	/* Write temperature code for rising and falling threshold */
+	rising_threshold = readl(data->base + EXYNOS5440_TMU_S0_7_TH0);
+	rising_threshold = get_th_reg(data, rising_threshold, false);
+	writel(rising_threshold, data->base + EXYNOS5440_TMU_S0_7_TH0);
+	writel(0, data->base + EXYNOS5440_TMU_S0_7_TH1);
+
+	exynos_tmu_clear_irqs(data);
+
+	/* if last threshold limit is also present */
+	i = pdata->max_trigger_level - 1;
+	if (pdata->trigger_levels[i] && pdata->trigger_type[i] == HW_TRIP) {
+		threshold_code = temp_to_code(data, pdata->trigger_levels[i]);
+		/* 5th level to be assigned in th2 reg */
+		rising_threshold =
+			threshold_code << EXYNOS5440_TMU_TH_RISE4_SHIFT;
+		writel(rising_threshold, data->base + EXYNOS5440_TMU_S0_7_TH2);
+		con = readl(data->base + EXYNOS5440_TMU_S0_7_CTRL);
+		con |= (1 << EXYNOS_TMU_THERM_TRIP_EN_SHIFT);
+		writel(con, data->base + EXYNOS5440_TMU_S0_7_CTRL);
+	}
+	/* Clear the PMIN in the common TMU register */
+	if (!data->id)
+		writel(0, data->base_second + EXYNOS5440_TMU_PMIN);
+	return ret;
+}
+
 static int exynos_tmu_read(struct exynos_tmu_data *data)
 {
 	struct exynos_tmu_platform_data *pdata = data->pdata;
@@ -639,16 +673,24 @@ static int exynos_tmu_probe(struct platform_device *pdev)
 		goto err_clk_sec;
 	}
 
-	if (pdata->type == SOC_ARCH_EXYNOS3250 ||
-	    pdata->type == SOC_ARCH_EXYNOS4210 ||
-	    pdata->type == SOC_ARCH_EXYNOS4412 ||
-	    pdata->type == SOC_ARCH_EXYNOS5250 ||
-	    pdata->type == SOC_ARCH_EXYNOS5260 ||
-	    pdata->type == SOC_ARCH_EXYNOS5420 ||
-	    pdata->type == SOC_ARCH_EXYNOS5420_TRIMINFO ||
-	    pdata->type == SOC_ARCH_EXYNOS5440)
-		data->soc = pdata->type;
-	else {
+	data->soc = pdata->type;
+
+	switch (data->soc) {
+	case SOC_ARCH_EXYNOS4210:
+		data->tmu_initialize = exynos4210_tmu_initialize;
+		break;
+	case SOC_ARCH_EXYNOS3250:
+	case SOC_ARCH_EXYNOS4412:
+	case SOC_ARCH_EXYNOS5250:
+	case SOC_ARCH_EXYNOS5260:
+	case SOC_ARCH_EXYNOS5420:
+	case SOC_ARCH_EXYNOS5420_TRIMINFO:
+		data->tmu_initialize = exynos4412_tmu_initialize;
+		break;
+	case SOC_ARCH_EXYNOS5440:
+		data->tmu_initialize = exynos5440_tmu_initialize;
+		break;
+	default:
 		ret = -EINVAL;
 		dev_err(&pdev->dev, "Platform not supported\n");
 		goto err_clk;
diff --git a/drivers/thermal/samsung/exynos_tmu.h b/drivers/thermal/samsung/exynos_tmu.h
index adecc7f..f186f4f 100644
--- a/drivers/thermal/samsung/exynos_tmu.h
+++ b/drivers/thermal/samsung/exynos_tmu.h
@@ -73,8 +73,6 @@ enum soc_type {
  * slightly across different exynos SOC's.
  * @tmu_ctrl: TMU main controller register.
  * @tmu_cur_temp: register containing the current temperature of the TMU.
- * @threshold_th0: Register containing first set of rising levels.
- * @threshold_th1: Register containing second set of rising levels.
  * @tmu_inten: register containing the different threshold interrupt
 	enable bits.
  * @inten_rise0_shift: shift bits of rising 0 interrupt bits.
@@ -91,9 +89,6 @@ struct exynos_tmu_registers {
 
 	u32	tmu_cur_temp;
 
-	u32	threshold_th0;
-	u32	threshold_th1;
-
 	u32	tmu_inten;
 	u32	inten_rise0_shift;
 	u32	inten_rise1_shift;
diff --git a/drivers/thermal/samsung/exynos_tmu_data.c b/drivers/thermal/samsung/exynos_tmu_data.c
index 1ed8bdc..db3b3bc 100644
--- a/drivers/thermal/samsung/exynos_tmu_data.c
+++ b/drivers/thermal/samsung/exynos_tmu_data.c
@@ -28,7 +28,6 @@
 static const struct exynos_tmu_registers exynos4210_tmu_registers = {
 	.tmu_ctrl = EXYNOS_TMU_REG_CONTROL,
 	.tmu_cur_temp = EXYNOS_TMU_REG_CURRENT_TEMP,
-	.threshold_th0 = EXYNOS4210_TMU_REG_TRIG_LEVEL0,
 	.tmu_inten = EXYNOS_TMU_REG_INTEN,
 	.inten_rise0_shift = EXYNOS_TMU_INTEN_RISE0_SHIFT,
 	.inten_rise1_shift = EXYNOS_TMU_INTEN_RISE1_SHIFT,
@@ -83,8 +82,6 @@ struct exynos_tmu_init_data const exynos4210_default_tmu_data = {
 static const struct exynos_tmu_registers exynos3250_tmu_registers = {
 	.tmu_ctrl = EXYNOS_TMU_REG_CONTROL,
 	.tmu_cur_temp = EXYNOS_TMU_REG_CURRENT_TEMP,
-	.threshold_th0 = EXYNOS_THD_TEMP_RISE,
-	.threshold_th1 = EXYNOS_THD_TEMP_FALL,
 	.tmu_inten = EXYNOS_TMU_REG_INTEN,
 	.inten_rise0_shift = EXYNOS_TMU_INTEN_RISE0_SHIFT,
 	.inten_rise1_shift = EXYNOS_TMU_INTEN_RISE1_SHIFT,
@@ -152,8 +149,6 @@ struct exynos_tmu_init_data const exynos3250_default_tmu_data = {
 static const struct exynos_tmu_registers exynos4412_tmu_registers = {
 	.tmu_ctrl = EXYNOS_TMU_REG_CONTROL,
 	.tmu_cur_temp = EXYNOS_TMU_REG_CURRENT_TEMP,
-	.threshold_th0 = EXYNOS_THD_TEMP_RISE,
-	.threshold_th1 = EXYNOS_THD_TEMP_FALL,
 	.tmu_inten = EXYNOS_TMU_REG_INTEN,
 	.inten_rise0_shift = EXYNOS_TMU_INTEN_RISE0_SHIFT,
 	.inten_rise1_shift = EXYNOS_TMU_INTEN_RISE1_SHIFT,
@@ -234,8 +229,6 @@ struct exynos_tmu_init_data const exynos5250_default_tmu_data = {
 static const struct exynos_tmu_registers exynos5260_tmu_registers = {
 	.tmu_ctrl = EXYNOS_TMU_REG_CONTROL,
 	.tmu_cur_temp = EXYNOS_TMU_REG_CURRENT_TEMP,
-	.threshold_th0 = EXYNOS_THD_TEMP_RISE,
-	.threshold_th1 = EXYNOS_THD_TEMP_FALL,
 	.tmu_inten = EXYNOS5260_TMU_REG_INTEN,
 	.inten_rise0_shift = EXYNOS_TMU_INTEN_RISE0_SHIFT,
 	.inten_rise1_shift = EXYNOS_TMU_INTEN_RISE1_SHIFT,
@@ -306,8 +299,6 @@ struct exynos_tmu_init_data const exynos5260_default_tmu_data = {
 static const struct exynos_tmu_registers exynos5420_tmu_registers = {
 	.tmu_ctrl = EXYNOS_TMU_REG_CONTROL,
 	.tmu_cur_temp = EXYNOS_TMU_REG_CURRENT_TEMP,
-	.threshold_th0 = EXYNOS_THD_TEMP_RISE,
-	.threshold_th1 = EXYNOS_THD_TEMP_FALL,
 	.tmu_inten = EXYNOS_TMU_REG_INTEN,
 	.inten_rise0_shift = EXYNOS_TMU_INTEN_RISE0_SHIFT,
 	.inten_rise1_shift = EXYNOS_TMU_INTEN_RISE1_SHIFT,
@@ -385,8 +376,6 @@ struct exynos_tmu_init_data const exynos5420_default_tmu_data = {
 static const struct exynos_tmu_registers exynos5440_tmu_registers = {
 	.tmu_ctrl = EXYNOS5440_TMU_S0_7_CTRL,
 	.tmu_cur_temp = EXYNOS5440_TMU_S0_7_TEMP,
-	.threshold_th0 = EXYNOS5440_TMU_S0_7_TH0,
-	.threshold_th1 = EXYNOS5440_TMU_S0_7_TH1,
 	.tmu_inten = EXYNOS5440_TMU_S0_7_IRQEN,
 	.inten_rise0_shift = EXYNOS5440_TMU_INTEN_RISE0_SHIFT,
 	.inten_rise1_shift = EXYNOS5440_TMU_INTEN_RISE1_SHIFT,
-- 
1.8.2.3

