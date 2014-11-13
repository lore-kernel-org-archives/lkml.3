Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933441AbaKMPFl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Nov 2014 10:05:41 -0500
Received: from mailout3.samsung.com ([203.254.224.33]:42973 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932269AbaKMPFi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Nov 2014 10:05:38 -0500
X-AuditID: cbfee61a-f79c06d000004e71-bb-5464c8c09c73
From: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
To: Eduardo Valentin <edubezval@gmail.com>
Cc: Zhang Rui <rui.zhang@intel.com>,
        Amit Daniel Kachhap <amit.daniel@samsung.com>,
        Lukasz Majewski <l.majewski@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        linux-samsung-soc@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, b.zolnierkie@samsung.com
Subject: [PATCH v2 20/33] thermal: exynos: add ->tmu_control method
Date: Thu, 13 Nov 2014 16:01:15 +0100
Message-id: <1415890888-8881-21-git-send-email-b.zolnierkie@samsung.com>
X-Mailer: git-send-email 1.7.10.4
In-reply-to: <1415890888-8881-1-git-send-email-b.zolnierkie@samsung.com>
References: <1415890888-8881-1-git-send-email-b.zolnierkie@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprGLMWRmVeSWpSXmKPExsVy+t9jQd0DJ1JCDHYfkrdouBpisXHGelaL
	+VeusVqcbXrDbvHm4WZGi8u75rBZfO49wmgx4/w+JosnD/vYHDg9ds66y+6xeM9LJo++LasY
	PT5vkgtgieKySUnNySxLLdK3S+DKWPC8vKAlrqJp6iKWBsZ9AV2MnBwSAiYSXYc2MUHYYhIX
	7q1n62Lk4hASmM4ose3QUzaQhJBAF5PEpdssIDabgJXExPZVjCC2iICWxIlL25lAGpgFlgHV
	fJsP5HBwCAs4S+x9FwtSwyKgKnHk63ywBbwCHhIHJ65jhlimKNH9bALYfE6g+KupfxkhdrlL
	XHv0jnkCI+8CRoZVjKKpBckFxUnpuYZ6xYm5xaV56XrJ+bmbGMGh9UxqB+PKBotDjAIcjEo8
	vC9YUkKEWBPLiitzDzFKcDArifB6HwYK8aYkVlalFuXHF5XmpBYfYpTmYFES5z3Qah0oJJCe
	WJKanZpakFoEk2Xi4JRqYOT8/GK1VgvbIauTyw+qCWdPEoz7HH7hX+89ln+PxFsufHrnt3aP
	ieJjd3MrxT/yvPHO5mEX9iwKkbrfwBC0cMHdhanHX8zcsdWgee++JbcT0k6zG+qV+hc9XL1i
	3vdiE//iPb/u3QhKC0vmnmFt28QncvptQ7NDB/NsJ7M10+RzDvy6kP8nq1iJpTgj0VCLuag4
	EQBNZ51rKQIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add ->tmu_control method to struct exynos_tmu_data and use it
in exynos_tmu_control().  Then add ->tmu_control implementations
for Exynos4210+ and Exynos5440.  Finally remove no longer needed
reg->tmu_[ctrl,inten], reg->inten_rise[0,1,2,3]_shift and
reg->inten_fall0_shift abstractions.

There should be no functional changes caused by this patch.

Cc: Amit Daniel Kachhap <amit.daniel@samsung.com>
Cc: Lukasz Majewski <l.majewski@samsung.com>
Cc: Eduardo Valentin <edubezval@gmail.com>
Cc: Zhang Rui <rui.zhang@intel.com>
Signed-off-by: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Acked-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 drivers/thermal/samsung/exynos_tmu.c      | 81 ++++++++++++++++++++++---------
 drivers/thermal/samsung/exynos_tmu.h      | 25 +---------
 drivers/thermal/samsung/exynos_tmu_data.c | 41 ----------------
 3 files changed, 60 insertions(+), 87 deletions(-)

diff --git a/drivers/thermal/samsung/exynos_tmu.c b/drivers/thermal/samsung/exynos_tmu.c
index f65e6d8..938e8e63 100644
--- a/drivers/thermal/samsung/exynos_tmu.c
+++ b/drivers/thermal/samsung/exynos_tmu.c
@@ -53,6 +53,7 @@
  * @regulator: pointer to the TMU regulator structure.
  * @reg_conf: pointer to structure to register with core thermal.
  * @tmu_initialize: SoC specific TMU initialization method
+ * @tmu_control: SoC specific TMU control method
  */
 struct exynos_tmu_data {
 	int id;
@@ -68,6 +69,7 @@ struct exynos_tmu_data {
 	struct regulator *regulator;
 	struct thermal_sensor_conf *reg_conf;
 	int (*tmu_initialize)(struct platform_device *pdev);
+	void (*tmu_control)(struct platform_device *pdev, bool on);
 };
 
 /*
@@ -221,32 +223,10 @@ static u32 get_con_reg(struct exynos_tmu_data *data, u32 con)
 static void exynos_tmu_control(struct platform_device *pdev, bool on)
 {
 	struct exynos_tmu_data *data = platform_get_drvdata(pdev);
-	struct exynos_tmu_platform_data *pdata = data->pdata;
-	const struct exynos_tmu_registers *reg = pdata->registers;
-	unsigned int con, interrupt_en;
 
 	mutex_lock(&data->lock);
 	clk_enable(data->clk);
-
-	con = get_con_reg(data, readl(data->base + reg->tmu_ctrl));
-
-	if (on) {
-		con |= (1 << EXYNOS_TMU_CORE_EN_SHIFT);
-		interrupt_en =
-			pdata->trigger_enable[3] << reg->inten_rise3_shift |
-			pdata->trigger_enable[2] << reg->inten_rise2_shift |
-			pdata->trigger_enable[1] << reg->inten_rise1_shift |
-			pdata->trigger_enable[0] << reg->inten_rise0_shift;
-		if (TMU_SUPPORTS(pdata, FALLING_TRIP))
-			interrupt_en |=
-				interrupt_en << reg->inten_fall0_shift;
-	} else {
-		con &= ~(1 << EXYNOS_TMU_CORE_EN_SHIFT);
-		interrupt_en = 0; /* Disable all interrupts */
-	}
-	writel(interrupt_en, data->base + reg->tmu_inten);
-	writel(con, data->base + reg->tmu_ctrl);
-
+	data->tmu_control(pdev, on);
 	clk_disable(data->clk);
 	mutex_unlock(&data->lock);
 }
@@ -388,6 +368,58 @@ static int exynos5440_tmu_initialize(struct platform_device *pdev)
 	return ret;
 }
 
+static void exynos4210_tmu_control(struct platform_device *pdev, bool on)
+{
+	struct exynos_tmu_data *data = platform_get_drvdata(pdev);
+	struct exynos_tmu_platform_data *pdata = data->pdata;
+	unsigned int con, interrupt_en;
+
+	con = get_con_reg(data, readl(data->base + EXYNOS_TMU_REG_CONTROL));
+
+	if (on) {
+		con |= (1 << EXYNOS_TMU_CORE_EN_SHIFT);
+		interrupt_en =
+			pdata->trigger_enable[3] << EXYNOS_TMU_INTEN_RISE3_SHIFT |
+			pdata->trigger_enable[2] << EXYNOS_TMU_INTEN_RISE2_SHIFT |
+			pdata->trigger_enable[1] << EXYNOS_TMU_INTEN_RISE1_SHIFT |
+			pdata->trigger_enable[0] << EXYNOS_TMU_INTEN_RISE0_SHIFT;
+		if (TMU_SUPPORTS(pdata, FALLING_TRIP))
+			interrupt_en |=
+				interrupt_en << EXYNOS_TMU_INTEN_FALL0_SHIFT;
+	} else {
+		con &= ~(1 << EXYNOS_TMU_CORE_EN_SHIFT);
+		interrupt_en = 0; /* Disable all interrupts */
+	}
+	writel(interrupt_en, data->base + EXYNOS_TMU_REG_INTEN);
+	writel(con, data->base + EXYNOS_TMU_REG_CONTROL);
+}
+
+static void exynos5440_tmu_control(struct platform_device *pdev, bool on)
+{
+	struct exynos_tmu_data *data = platform_get_drvdata(pdev);
+	struct exynos_tmu_platform_data *pdata = data->pdata;
+	unsigned int con, interrupt_en;
+
+	con = get_con_reg(data, readl(data->base + EXYNOS5440_TMU_S0_7_CTRL));
+
+	if (on) {
+		con |= (1 << EXYNOS_TMU_CORE_EN_SHIFT);
+		interrupt_en =
+			pdata->trigger_enable[3] << EXYNOS5440_TMU_INTEN_RISE3_SHIFT |
+			pdata->trigger_enable[2] << EXYNOS5440_TMU_INTEN_RISE2_SHIFT |
+			pdata->trigger_enable[1] << EXYNOS5440_TMU_INTEN_RISE1_SHIFT |
+			pdata->trigger_enable[0] << EXYNOS5440_TMU_INTEN_RISE0_SHIFT;
+		if (TMU_SUPPORTS(pdata, FALLING_TRIP))
+			interrupt_en |=
+				interrupt_en << EXYNOS5440_TMU_INTEN_FALL0_SHIFT;
+	} else {
+		con &= ~(1 << EXYNOS_TMU_CORE_EN_SHIFT);
+		interrupt_en = 0; /* Disable all interrupts */
+	}
+	writel(interrupt_en, data->base + EXYNOS5440_TMU_S0_7_IRQEN);
+	writel(con, data->base + EXYNOS5440_TMU_S0_7_CTRL);
+}
+
 static int exynos_tmu_read(struct exynos_tmu_data *data)
 {
 	struct exynos_tmu_platform_data *pdata = data->pdata;
@@ -685,6 +717,7 @@ static int exynos_tmu_probe(struct platform_device *pdev)
 	switch (data->soc) {
 	case SOC_ARCH_EXYNOS4210:
 		data->tmu_initialize = exynos4210_tmu_initialize;
+		data->tmu_control = exynos4210_tmu_control;
 		break;
 	case SOC_ARCH_EXYNOS3250:
 	case SOC_ARCH_EXYNOS4412:
@@ -693,9 +726,11 @@ static int exynos_tmu_probe(struct platform_device *pdev)
 	case SOC_ARCH_EXYNOS5420:
 	case SOC_ARCH_EXYNOS5420_TRIMINFO:
 		data->tmu_initialize = exynos4412_tmu_initialize;
+		data->tmu_control = exynos4210_tmu_control;
 		break;
 	case SOC_ARCH_EXYNOS5440:
 		data->tmu_initialize = exynos5440_tmu_initialize;
+		data->tmu_control = exynos5440_tmu_control;
 		break;
 	default:
 		ret = -EINVAL;
diff --git a/drivers/thermal/samsung/exynos_tmu.h b/drivers/thermal/samsung/exynos_tmu.h
index f186f4f..7496b54 100644
--- a/drivers/thermal/samsung/exynos_tmu.h
+++ b/drivers/thermal/samsung/exynos_tmu.h
@@ -68,38 +68,17 @@ enum soc_type {
 #define TMU_SUPPORTS(a, b)	(a->features & TMU_SUPPORT_ ## b)
 
 /**
- * struct exynos_tmu_register - register descriptors to access registers and
- * bitfields. The register validity, offsets and bitfield values may vary
- * slightly across different exynos SOC's.
- * @tmu_ctrl: TMU main controller register.
+ * struct exynos_tmu_register - register descriptors to access registers.
+ * The register validity may vary slightly across different exynos SOC's.
  * @tmu_cur_temp: register containing the current temperature of the TMU.
- * @tmu_inten: register containing the different threshold interrupt
-	enable bits.
- * @inten_rise0_shift: shift bits of rising 0 interrupt bits.
- * @inten_rise1_shift: shift bits of rising 1 interrupt bits.
- * @inten_rise2_shift: shift bits of rising 2 interrupt bits.
- * @inten_rise3_shift: shift bits of rising 3 interrupt bits.
- * @inten_fall0_shift: shift bits of falling 0 interrupt bits.
  * @tmu_intstat: Register containing the interrupt status values.
  * @tmu_intclear: Register for clearing the raised interrupt status.
  * @emul_con: TMU emulation controller register.
  */
 struct exynos_tmu_registers {
-	u32	tmu_ctrl;
-
 	u32	tmu_cur_temp;
-
-	u32	tmu_inten;
-	u32	inten_rise0_shift;
-	u32	inten_rise1_shift;
-	u32	inten_rise2_shift;
-	u32	inten_rise3_shift;
-	u32	inten_fall0_shift;
-
 	u32	tmu_intstat;
-
 	u32	tmu_intclear;
-
 	u32	emul_con;
 };
 
diff --git a/drivers/thermal/samsung/exynos_tmu_data.c b/drivers/thermal/samsung/exynos_tmu_data.c
index db3b3bc..2bfd469 100644
--- a/drivers/thermal/samsung/exynos_tmu_data.c
+++ b/drivers/thermal/samsung/exynos_tmu_data.c
@@ -26,13 +26,7 @@
 
 #if defined(CONFIG_CPU_EXYNOS4210)
 static const struct exynos_tmu_registers exynos4210_tmu_registers = {
-	.tmu_ctrl = EXYNOS_TMU_REG_CONTROL,
 	.tmu_cur_temp = EXYNOS_TMU_REG_CURRENT_TEMP,
-	.tmu_inten = EXYNOS_TMU_REG_INTEN,
-	.inten_rise0_shift = EXYNOS_TMU_INTEN_RISE0_SHIFT,
-	.inten_rise1_shift = EXYNOS_TMU_INTEN_RISE1_SHIFT,
-	.inten_rise2_shift = EXYNOS_TMU_INTEN_RISE2_SHIFT,
-	.inten_rise3_shift = EXYNOS_TMU_INTEN_RISE3_SHIFT,
 	.tmu_intstat = EXYNOS_TMU_REG_INTSTAT,
 	.tmu_intclear = EXYNOS_TMU_REG_INTCLEAR,
 };
@@ -80,13 +74,7 @@ struct exynos_tmu_init_data const exynos4210_default_tmu_data = {
 
 #if defined(CONFIG_SOC_EXYNOS3250)
 static const struct exynos_tmu_registers exynos3250_tmu_registers = {
-	.tmu_ctrl = EXYNOS_TMU_REG_CONTROL,
 	.tmu_cur_temp = EXYNOS_TMU_REG_CURRENT_TEMP,
-	.tmu_inten = EXYNOS_TMU_REG_INTEN,
-	.inten_rise0_shift = EXYNOS_TMU_INTEN_RISE0_SHIFT,
-	.inten_rise1_shift = EXYNOS_TMU_INTEN_RISE1_SHIFT,
-	.inten_rise2_shift = EXYNOS_TMU_INTEN_RISE2_SHIFT,
-	.inten_fall0_shift = EXYNOS_TMU_INTEN_FALL0_SHIFT,
 	.tmu_intstat = EXYNOS_TMU_REG_INTSTAT,
 	.tmu_intclear = EXYNOS_TMU_REG_INTCLEAR,
 	.emul_con = EXYNOS_EMUL_CON,
@@ -147,14 +135,7 @@ struct exynos_tmu_init_data const exynos3250_default_tmu_data = {
 
 #if defined(CONFIG_SOC_EXYNOS4412) || defined(CONFIG_SOC_EXYNOS5250)
 static const struct exynos_tmu_registers exynos4412_tmu_registers = {
-	.tmu_ctrl = EXYNOS_TMU_REG_CONTROL,
 	.tmu_cur_temp = EXYNOS_TMU_REG_CURRENT_TEMP,
-	.tmu_inten = EXYNOS_TMU_REG_INTEN,
-	.inten_rise0_shift = EXYNOS_TMU_INTEN_RISE0_SHIFT,
-	.inten_rise1_shift = EXYNOS_TMU_INTEN_RISE1_SHIFT,
-	.inten_rise2_shift = EXYNOS_TMU_INTEN_RISE2_SHIFT,
-	.inten_rise3_shift = EXYNOS_TMU_INTEN_RISE3_SHIFT,
-	.inten_fall0_shift = EXYNOS_TMU_INTEN_FALL0_SHIFT,
 	.tmu_intstat = EXYNOS_TMU_REG_INTSTAT,
 	.tmu_intclear = EXYNOS_TMU_REG_INTCLEAR,
 	.emul_con = EXYNOS_EMUL_CON,
@@ -227,14 +208,7 @@ struct exynos_tmu_init_data const exynos5250_default_tmu_data = {
 
 #if defined(CONFIG_SOC_EXYNOS5260)
 static const struct exynos_tmu_registers exynos5260_tmu_registers = {
-	.tmu_ctrl = EXYNOS_TMU_REG_CONTROL,
 	.tmu_cur_temp = EXYNOS_TMU_REG_CURRENT_TEMP,
-	.tmu_inten = EXYNOS5260_TMU_REG_INTEN,
-	.inten_rise0_shift = EXYNOS_TMU_INTEN_RISE0_SHIFT,
-	.inten_rise1_shift = EXYNOS_TMU_INTEN_RISE1_SHIFT,
-	.inten_rise2_shift = EXYNOS_TMU_INTEN_RISE2_SHIFT,
-	.inten_rise3_shift = EXYNOS_TMU_INTEN_RISE3_SHIFT,
-	.inten_fall0_shift = EXYNOS_TMU_INTEN_FALL0_SHIFT,
 	.tmu_intstat = EXYNOS5260_TMU_REG_INTSTAT,
 	.tmu_intclear = EXYNOS5260_TMU_REG_INTCLEAR,
 	.emul_con = EXYNOS5260_EMUL_CON,
@@ -297,15 +271,7 @@ struct exynos_tmu_init_data const exynos5260_default_tmu_data = {
 
 #if defined(CONFIG_SOC_EXYNOS5420)
 static const struct exynos_tmu_registers exynos5420_tmu_registers = {
-	.tmu_ctrl = EXYNOS_TMU_REG_CONTROL,
 	.tmu_cur_temp = EXYNOS_TMU_REG_CURRENT_TEMP,
-	.tmu_inten = EXYNOS_TMU_REG_INTEN,
-	.inten_rise0_shift = EXYNOS_TMU_INTEN_RISE0_SHIFT,
-	.inten_rise1_shift = EXYNOS_TMU_INTEN_RISE1_SHIFT,
-	.inten_rise2_shift = EXYNOS_TMU_INTEN_RISE2_SHIFT,
-	/* INTEN_RISE3 Not availble in exynos5420 */
-	.inten_rise3_shift = EXYNOS_TMU_INTEN_RISE3_SHIFT,
-	.inten_fall0_shift = EXYNOS_TMU_INTEN_FALL0_SHIFT,
 	.tmu_intstat = EXYNOS_TMU_REG_INTSTAT,
 	.tmu_intclear = EXYNOS_TMU_REG_INTCLEAR,
 	.emul_con = EXYNOS_EMUL_CON,
@@ -374,14 +340,7 @@ struct exynos_tmu_init_data const exynos5420_default_tmu_data = {
 
 #if defined(CONFIG_SOC_EXYNOS5440)
 static const struct exynos_tmu_registers exynos5440_tmu_registers = {
-	.tmu_ctrl = EXYNOS5440_TMU_S0_7_CTRL,
 	.tmu_cur_temp = EXYNOS5440_TMU_S0_7_TEMP,
-	.tmu_inten = EXYNOS5440_TMU_S0_7_IRQEN,
-	.inten_rise0_shift = EXYNOS5440_TMU_INTEN_RISE0_SHIFT,
-	.inten_rise1_shift = EXYNOS5440_TMU_INTEN_RISE1_SHIFT,
-	.inten_rise2_shift = EXYNOS5440_TMU_INTEN_RISE2_SHIFT,
-	.inten_rise3_shift = EXYNOS5440_TMU_INTEN_RISE3_SHIFT,
-	.inten_fall0_shift = EXYNOS5440_TMU_INTEN_FALL0_SHIFT,
 	.tmu_intstat = EXYNOS5440_TMU_S0_7_IRQ,
 	.tmu_intclear = EXYNOS5440_TMU_S0_7_IRQ,
 	.emul_con = EXYNOS5440_TMU_S0_7_DEBUG,
-- 
1.8.2.3

