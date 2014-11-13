Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933496AbaKMPGW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Nov 2014 10:06:22 -0500
Received: from mailout1.samsung.com ([203.254.224.24]:50486 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933280AbaKMPGR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Nov 2014 10:06:17 -0500
X-AuditID: cbfee61b-f79d76d0000024d6-0f-5464c8e7de42
From: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
To: Eduardo Valentin <edubezval@gmail.com>
Cc: Zhang Rui <rui.zhang@intel.com>,
        Amit Daniel Kachhap <amit.daniel@samsung.com>,
        Lukasz Majewski <l.majewski@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        linux-samsung-soc@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, b.zolnierkie@samsung.com
Subject: [PATCH v2 24/33] thermal: exynos: add ->tmu_clear_irqs method
Date: Thu, 13 Nov 2014 16:01:19 +0100
Message-id: <1415890888-8881-25-git-send-email-b.zolnierkie@samsung.com>
X-Mailer: git-send-email 1.7.10.4
In-reply-to: <1415890888-8881-1-git-send-email-b.zolnierkie@samsung.com>
References: <1415890888-8881-1-git-send-email-b.zolnierkie@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprJLMWRmVeSWpSXmKPExsVy+t9jQd0XJ1JCDFbPZrdouBpisXHGelaL
	+VeusVqcbXrDbvHm4WZGi8u75rBZfO49wmgx4/w+JosnD/vYHDg9ds66y+6xeM9LJo++LasY
	PT5vkgtgieKySUnNySxLLdK3S+DKWL/rPGvBxLiK5o0zmRoYj/l1MXJySAiYSLzc8ocJwhaT
	uHBvPVsXIxeHkMB0RoktG69AOV1MEnv3bWMEqWITsJKY2L4KzBYR0JI4cWk7E0gRs8AyJolL
	3+aDjRIWcJNYe3A6M4jNIqAq8eP/JFYQm1fAQ+Lkj8eMEOsUJbqfTWADsTmB4q+m/gWLCwm4
	S1x79I55AiPvAkaGVYyiqQXJBcVJ6blGesWJucWleel6yfm5mxjBAfZMegfjqgaLQ4wCHIxK
	PLwvWFJChFgTy4orcw8xSnAwK4nweh8GCvGmJFZWpRblxxeV5qQWH2KU5mBREuc92GodKCSQ
	nliSmp2aWpBaBJNl4uCUamBcsav91oou5QS9LPcpi5K/b6r+rhR4tS14B+PHuq50ns2rE83m
	3fRomHq/cenpl05VxxvfBZge9veIWyqwgy/quBW/2s1Xuz0YrHjXzY7LTK1n9OFXFrhfX3jj
	EsP3hN9GqhEC752aWYRKcrZ6SDp+XfwriHtuwKO1WXw16Q2HmsRlJwdUsyixFGckGmoxFxUn
	AgCsnbA9LAIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add ->tmu_clear_irqs method to struct exynos_tmu_data and use
it instead exynos_tmu_clear_irqs().  Then add ->tmu_clear_irqs
implementations for Exynos4210+ and Exynos5440.  Finally
remove no longer needed reg->tmu_int[stat,clear] abstractions
and struct exynos_tmu_registers instances.

There should be no functional changes caused by this patch.

Cc: Amit Daniel Kachhap <amit.daniel@samsung.com>
Cc: Lukasz Majewski <l.majewski@samsung.com>
Cc: Eduardo Valentin <edubezval@gmail.com>
Cc: Zhang Rui <rui.zhang@intel.com>
Signed-off-by: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Acked-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 drivers/thermal/samsung/exynos_tmu.c      | 64 +++++++++++++++++++++----------
 drivers/thermal/samsung/exynos_tmu.h      | 14 -------
 drivers/thermal/samsung/exynos_tmu_data.c | 36 -----------------
 3 files changed, 43 insertions(+), 71 deletions(-)

diff --git a/drivers/thermal/samsung/exynos_tmu.c b/drivers/thermal/samsung/exynos_tmu.c
index 01aa548..1b3c2f4 100644
--- a/drivers/thermal/samsung/exynos_tmu.c
+++ b/drivers/thermal/samsung/exynos_tmu.c
@@ -56,6 +56,7 @@
  * @tmu_control: SoC specific TMU control method
  * @tmu_read: SoC specific TMU temperature read method
  * @tmu_set_emulation: SoC specific TMU emulation setting method
+ * @tmu_clear_irqs: SoC specific TMU interrupts clearing method
  */
 struct exynos_tmu_data {
 	int id;
@@ -75,6 +76,7 @@ struct exynos_tmu_data {
 	int (*tmu_read)(struct exynos_tmu_data *data);
 	void (*tmu_set_emulation)(struct exynos_tmu_data *data,
 				  unsigned long temp);
+	void (*tmu_clear_irqs)(struct exynos_tmu_data *data);
 };
 
 /*
@@ -131,23 +133,6 @@ static int code_to_temp(struct exynos_tmu_data *data, u8 temp_code)
 	return temp;
 }
 
-static void exynos_tmu_clear_irqs(struct exynos_tmu_data *data)
-{
-	const struct exynos_tmu_registers *reg = data->pdata->registers;
-	unsigned int val_irq;
-
-	val_irq = readl(data->base + reg->tmu_intstat);
-	/*
-	 * Clear the interrupts.  Please note that the documentation for
-	 * Exynos3250, Exynos4412, Exynos5250 and Exynos5260 incorrectly
-	 * states that INTCLEAR register has a different placing of bits
-	 * responsible for FALL IRQs than INTSTAT register.  Exynos5420
-	 * and Exynos5440 documentation is correct (Exynos4210 doesn't
-	 * support FALL IRQs at all).
-	 */
-	writel(val_irq, data->base + reg->tmu_intclear);
-}
-
 static void sanitize_temp_error(struct exynos_tmu_data *data, u32 trim_info)
 {
 	struct exynos_tmu_platform_data *pdata = data->pdata;
@@ -259,7 +244,7 @@ static int exynos4210_tmu_initialize(struct platform_device *pdev)
 		writeb(pdata->trigger_levels[i], data->base +
 		       EXYNOS4210_TMU_REG_TRIG_LEVEL0 + i * 4);
 
-	exynos_tmu_clear_irqs(data);
+	data->tmu_clear_irqs(data);
 out:
 	return ret;
 }
@@ -304,7 +289,7 @@ static int exynos4412_tmu_initialize(struct platform_device *pdev)
 	writel(rising_threshold, data->base + EXYNOS_THD_TEMP_RISE);
 	writel(get_th_reg(data, 0, true), data->base + EXYNOS_THD_TEMP_FALL);
 
-	exynos_tmu_clear_irqs(data);
+	data->tmu_clear_irqs(data);
 
 	/* if last threshold limit is also present */
 	i = pdata->max_trigger_level - 1;
@@ -353,7 +338,7 @@ static int exynos5440_tmu_initialize(struct platform_device *pdev)
 	writel(rising_threshold, data->base + EXYNOS5440_TMU_S0_7_TH0);
 	writel(0, data->base + EXYNOS5440_TMU_S0_7_TH1);
 
-	exynos_tmu_clear_irqs(data);
+	data->tmu_clear_irqs(data);
 
 	/* if last threshold limit is also present */
 	i = pdata->max_trigger_level - 1;
@@ -557,7 +542,7 @@ static void exynos_tmu_work(struct work_struct *work)
 	clk_enable(data->clk);
 
 	/* TODO: take action based on particular interrupt */
-	exynos_tmu_clear_irqs(data);
+	data->tmu_clear_irqs(data);
 
 	clk_disable(data->clk);
 	mutex_unlock(&data->lock);
@@ -565,6 +550,40 @@ out:
 	enable_irq(data->irq);
 }
 
+static void exynos4210_tmu_clear_irqs(struct exynos_tmu_data *data)
+{
+	unsigned int val_irq;
+	u32 tmu_intstat, tmu_intclear;
+
+	if (data->soc == SOC_ARCH_EXYNOS5260) {
+		tmu_intstat = EXYNOS5260_TMU_REG_INTSTAT;
+		tmu_intclear = EXYNOS5260_TMU_REG_INTCLEAR;
+	} else {
+		tmu_intstat = EXYNOS_TMU_REG_INTSTAT;
+		tmu_intclear = EXYNOS_TMU_REG_INTCLEAR;
+	}
+
+	val_irq = readl(data->base + tmu_intstat);
+	/*
+	 * Clear the interrupts.  Please note that the documentation for
+	 * Exynos3250, Exynos4412, Exynos5250 and Exynos5260 incorrectly
+	 * states that INTCLEAR register has a different placing of bits
+	 * responsible for FALL IRQs than INTSTAT register.  Exynos5420
+	 * and Exynos5440 documentation is correct (Exynos4210 doesn't
+	 * support FALL IRQs at all).
+	 */
+	writel(val_irq, data->base + tmu_intclear);
+}
+
+static void exynos5440_tmu_clear_irqs(struct exynos_tmu_data *data)
+{
+	unsigned int val_irq;
+
+	val_irq = readl(data->base + EXYNOS5440_TMU_S0_7_IRQ);
+	/* clear the interrupts */
+	writel(val_irq, data->base + EXYNOS5440_TMU_S0_7_IRQ);
+}
+
 static irqreturn_t exynos_tmu_irq(int irq, void *id)
 {
 	struct exynos_tmu_data *data = id;
@@ -760,6 +779,7 @@ static int exynos_tmu_probe(struct platform_device *pdev)
 		data->tmu_initialize = exynos4210_tmu_initialize;
 		data->tmu_control = exynos4210_tmu_control;
 		data->tmu_read = exynos4210_tmu_read;
+		data->tmu_clear_irqs = exynos4210_tmu_clear_irqs;
 		break;
 	case SOC_ARCH_EXYNOS3250:
 	case SOC_ARCH_EXYNOS4412:
@@ -771,12 +791,14 @@ static int exynos_tmu_probe(struct platform_device *pdev)
 		data->tmu_control = exynos4210_tmu_control;
 		data->tmu_read = exynos4412_tmu_read;
 		data->tmu_set_emulation = exynos4412_tmu_set_emulation;
+		data->tmu_clear_irqs = exynos4210_tmu_clear_irqs;
 		break;
 	case SOC_ARCH_EXYNOS5440:
 		data->tmu_initialize = exynos5440_tmu_initialize;
 		data->tmu_control = exynos5440_tmu_control;
 		data->tmu_read = exynos5440_tmu_read;
 		data->tmu_set_emulation = exynos5440_tmu_set_emulation;
+		data->tmu_clear_irqs = exynos5440_tmu_clear_irqs;
 		break;
 	default:
 		ret = -EINVAL;
diff --git a/drivers/thermal/samsung/exynos_tmu.h b/drivers/thermal/samsung/exynos_tmu.h
index 785eccf..c4c0aa5 100644
--- a/drivers/thermal/samsung/exynos_tmu.h
+++ b/drivers/thermal/samsung/exynos_tmu.h
@@ -68,17 +68,6 @@ enum soc_type {
 #define TMU_SUPPORTS(a, b)	(a->features & TMU_SUPPORT_ ## b)
 
 /**
- * struct exynos_tmu_register - register descriptors to access registers.
- * The register validity may vary slightly across different exynos SOC's.
- * @tmu_intstat: Register containing the interrupt status values.
- * @tmu_intclear: Register for clearing the raised interrupt status.
- */
-struct exynos_tmu_registers {
-	u32	tmu_intstat;
-	u32	tmu_intclear;
-};
-
-/**
  * struct exynos_tmu_platform_data
  * @threshold: basic temperature for generating interrupt
  *	       25 <= threshold <= 125 [unit: degree Celsius]
@@ -127,8 +116,6 @@ struct exynos_tmu_registers {
  * @freq_clip_table: Table representing frequency reduction percentage.
  * @freq_tab_count: Count of the above table as frequency reduction may
  *	applicable to only some of the trigger levels.
- * @registers: Pointer to structure containing all the TMU controller registers
- *	and bitfields shifts and masks.
  * @features: a bitfield value indicating the features supported in SOC like
  *	emulation, multi instance etc
  *
@@ -158,7 +145,6 @@ struct exynos_tmu_platform_data {
 	enum soc_type type;
 	struct freq_clip_table freq_tab[4];
 	unsigned int freq_tab_count;
-	const struct exynos_tmu_registers *registers;
 	unsigned int features;
 };
 
diff --git a/drivers/thermal/samsung/exynos_tmu_data.c b/drivers/thermal/samsung/exynos_tmu_data.c
index d0bb4b3..d35ec15 100644
--- a/drivers/thermal/samsung/exynos_tmu_data.c
+++ b/drivers/thermal/samsung/exynos_tmu_data.c
@@ -25,11 +25,6 @@
 #include "exynos_tmu_data.h"
 
 #if defined(CONFIG_CPU_EXYNOS4210)
-static const struct exynos_tmu_registers exynos4210_tmu_registers = {
-	.tmu_intstat = EXYNOS_TMU_REG_INTSTAT,
-	.tmu_intclear = EXYNOS_TMU_REG_INTCLEAR,
-};
-
 struct exynos_tmu_init_data const exynos4210_default_tmu_data = {
 	.tmu_data = {
 		{
@@ -64,7 +59,6 @@ struct exynos_tmu_init_data const exynos4210_default_tmu_data = {
 		},
 		.freq_tab_count = 2,
 		.type = SOC_ARCH_EXYNOS4210,
-		.registers = &exynos4210_tmu_registers,
 		},
 	},
 	.tmu_count = 1,
@@ -72,11 +66,6 @@ struct exynos_tmu_init_data const exynos4210_default_tmu_data = {
 #endif
 
 #if defined(CONFIG_SOC_EXYNOS3250)
-static const struct exynos_tmu_registers exynos3250_tmu_registers = {
-	.tmu_intstat = EXYNOS_TMU_REG_INTSTAT,
-	.tmu_intclear = EXYNOS_TMU_REG_INTCLEAR,
-};
-
 #define EXYNOS3250_TMU_DATA \
 	.threshold_falling = 10, \
 	.trigger_levels[0] = 70, \
@@ -112,7 +101,6 @@ static const struct exynos_tmu_registers exynos3250_tmu_registers = {
 		.temp_level = 95, \
 	}, \
 	.freq_tab_count = 2, \
-	.registers = &exynos3250_tmu_registers, \
 	.features = (TMU_SUPPORT_EMULATION | TMU_SUPPORT_FALLING_TRIP | \
 			TMU_SUPPORT_EMUL_TIME)
 #endif
@@ -131,11 +119,6 @@ struct exynos_tmu_init_data const exynos3250_default_tmu_data = {
 #endif
 
 #if defined(CONFIG_SOC_EXYNOS4412) || defined(CONFIG_SOC_EXYNOS5250)
-static const struct exynos_tmu_registers exynos4412_tmu_registers = {
-	.tmu_intstat = EXYNOS_TMU_REG_INTSTAT,
-	.tmu_intclear = EXYNOS_TMU_REG_INTCLEAR,
-};
-
 #define EXYNOS4412_TMU_DATA \
 	.threshold_falling = 10, \
 	.trigger_levels[0] = 70, \
@@ -171,7 +154,6 @@ static const struct exynos_tmu_registers exynos4412_tmu_registers = {
 		.temp_level = 95, \
 	}, \
 	.freq_tab_count = 2, \
-	.registers = &exynos4412_tmu_registers, \
 	.features = (TMU_SUPPORT_EMULATION | TMU_SUPPORT_FALLING_TRIP | \
 			TMU_SUPPORT_EMUL_TIME)
 #endif
@@ -202,11 +184,6 @@ struct exynos_tmu_init_data const exynos5250_default_tmu_data = {
 #endif
 
 #if defined(CONFIG_SOC_EXYNOS5260)
-static const struct exynos_tmu_registers exynos5260_tmu_registers = {
-	.tmu_intstat = EXYNOS5260_TMU_REG_INTSTAT,
-	.tmu_intclear = EXYNOS5260_TMU_REG_INTCLEAR,
-};
-
 #define __EXYNOS5260_TMU_DATA	\
 	.threshold_falling = 10, \
 	.trigger_levels[0] = 85, \
@@ -242,7 +219,6 @@ static const struct exynos_tmu_registers exynos5260_tmu_registers = {
 		.temp_level = 103, \
 	}, \
 	.freq_tab_count = 2, \
-	.registers = &exynos5260_tmu_registers, \
 
 #define EXYNOS5260_TMU_DATA \
 	__EXYNOS5260_TMU_DATA \
@@ -263,11 +239,6 @@ struct exynos_tmu_init_data const exynos5260_default_tmu_data = {
 #endif
 
 #if defined(CONFIG_SOC_EXYNOS5420)
-static const struct exynos_tmu_registers exynos5420_tmu_registers = {
-	.tmu_intstat = EXYNOS_TMU_REG_INTSTAT,
-	.tmu_intclear = EXYNOS_TMU_REG_INTCLEAR,
-};
-
 #define __EXYNOS5420_TMU_DATA	\
 	.threshold_falling = 10, \
 	.trigger_levels[0] = 85, \
@@ -303,7 +274,6 @@ static const struct exynos_tmu_registers exynos5420_tmu_registers = {
 		.temp_level = 103, \
 	}, \
 	.freq_tab_count = 2, \
-	.registers = &exynos5420_tmu_registers, \
 
 #define EXYNOS5420_TMU_DATA \
 	__EXYNOS5420_TMU_DATA \
@@ -330,11 +300,6 @@ struct exynos_tmu_init_data const exynos5420_default_tmu_data = {
 #endif
 
 #if defined(CONFIG_SOC_EXYNOS5440)
-static const struct exynos_tmu_registers exynos5440_tmu_registers = {
-	.tmu_intstat = EXYNOS5440_TMU_S0_7_IRQ,
-	.tmu_intclear = EXYNOS5440_TMU_S0_7_IRQ,
-};
-
 #define EXYNOS5440_TMU_DATA \
 	.trigger_levels[0] = 100, \
 	.trigger_levels[4] = 105, \
@@ -354,7 +319,6 @@ static const struct exynos_tmu_registers exynos5440_tmu_registers = {
 	.second_point_trim = 70, \
 	.default_temp_offset = 25, \
 	.type = SOC_ARCH_EXYNOS5440, \
-	.registers = &exynos5440_tmu_registers, \
 	.features = (TMU_SUPPORT_EMULATION | TMU_SUPPORT_FALLING_TRIP | \
 			TMU_SUPPORT_MULTI_INST | TMU_SUPPORT_ADDRESS_MULTIPLE),
 
-- 
1.8.2.3

