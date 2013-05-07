Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932732Ab3EGNDH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 May 2013 09:03:07 -0400
Received: from mail-pd0-f170.google.com ([209.85.192.170]:47469 "EHLO
	mail-pd0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932511Ab3EGNDC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 May 2013 09:03:02 -0400
From: Amit Daniel Kachhap <amit.daniel@samsung.com>
To: linux-pm@vger.kernel.org
Cc: Zhang Rui <rui.zhang@intel.com>, linux-samsung-soc@vger.kernel.org,
        linux-kernel@vger.kernel.org, amit.kachhap@gmail.com,
        Kukjin Kim <kgene.kim@samsung.com>,
        Eduardo Valentin <eduardo.valentin@ti.com>
Subject: [PATCH V3 18/21] thermal: exynos: Add support for exynos5440 TMU sensor.
Date: Tue,  7 May 2013 18:31:08 +0530
Message-Id: <1367931671-3906-19-git-send-email-amit.daniel@samsung.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1367931671-3906-1-git-send-email-amit.daniel@samsung.com>
References: <1367931671-3906-1-git-send-email-amit.daniel@samsung.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch modifies TMU controller to add changes needed to work with
exynos5440 platform. Also register definitions and required configuration data
are added. This sensor registers 3 instance of the tmu controller with the
thermal zone and hence reports 3 temperature output. This controller supports
upto five trip points. For critical threshold the driver uses the core driver
thermal framework for shutdown.

Acked-by: Kukjin Kim <kgene.kim@samsung.com>
Signed-off-by: Amit Daniel Kachhap <amit.daniel@samsung.com>
---
 .../devicetree/bindings/thermal/exynos-thermal.txt |   28 ++++-
 drivers/thermal/samsung/Kconfig                    |    4 +-
 drivers/thermal/samsung/exynos_thermal_common.c    |    2 +-
 drivers/thermal/samsung/exynos_tmu.c               |  139 +++++++++++++++++---
 drivers/thermal/samsung/exynos_tmu.h               |    7 +
 drivers/thermal/samsung/exynos_tmu_data.c          |   66 +++++++++-
 drivers/thermal/samsung/exynos_tmu_data.h          |   40 ++++++
 7 files changed, 261 insertions(+), 25 deletions(-)

diff --git a/Documentation/devicetree/bindings/thermal/exynos-thermal.txt b/Documentation/devicetree/bindings/thermal/exynos-thermal.txt
index 535fd0e..970eeba 100644
--- a/Documentation/devicetree/bindings/thermal/exynos-thermal.txt
+++ b/Documentation/devicetree/bindings/thermal/exynos-thermal.txt
@@ -6,13 +6,16 @@
 	       "samsung,exynos4412-tmu"
 	       "samsung,exynos4210-tmu"
 	       "samsung,exynos5250-tmu"
+	       "samsung,exynos5440-tmu"
 - interrupt-parent : The phandle for the interrupt controller
-- reg : Address range of the thermal registers
+- reg : Address range of the thermal registers. For exynos5440-tmu which has 3
+	instances of TMU, 2 set of register has to supplied. First set belongs
+	to each instance of TMU and second set belongs to common TMU registers.
 - interrupts : Should contain interrupt for thermal system
 - clocks : The main clock for TMU device
 - clock-names : Thermal system clock name
 
-Example:
+Example 1):
 
 	tmu@100C0000 {
 		compatible = "samsung,exynos4412-tmu";
@@ -23,3 +26,24 @@ Example:
 		clock-names = "tmu_apbif";
 		status = "disabled";
 	};
+
+Example 2):
+
+	tmuctrl_0: tmuctrl@160118 {
+		compatible = "samsung,exynos5440-tmu";
+		reg = <0x160118 0x230>, <0x160368 0x10>;
+		interrupts = <0 58 0>;
+		clocks = <&clock 21>;
+		clock-names = "tmu_apbif";
+	};
+
+Note: For multi-instance tmu each instance should have an alias correctly
+numbered in "aliases" node.
+
+Example:
+
+aliases {
+	tmuctrl0 = &tmuctrl_0;
+	tmuctrl1 = &tmuctrl_1;
+	tmuctrl2 = &tmuctrl_2;
+};
diff --git a/drivers/thermal/samsung/Kconfig b/drivers/thermal/samsung/Kconfig
index f23f533..fce04f3 100644
--- a/drivers/thermal/samsung/Kconfig
+++ b/drivers/thermal/samsung/Kconfig
@@ -19,10 +19,10 @@ config EXYNOS_THERMAL_CORE
 
 config EXYNOS_THERMAL_DATA
 	bool "Temperature sensor congiguration data for EXYNOS series SOC"
-	depends on (CPU_EXYNOS4210 || SOC_EXYNOS4212 || SOC_EXYNOS4412 || SOC_EXYNOS5250)
+	depends on (CPU_EXYNOS4210 || SOC_EXYNOS4212 || SOC_EXYNOS4412 || SOC_EXYNOS5250 || SOC_EXYNOS5440)
 	depends on EXYNOS_THERMAL
 	help
 	  If you say yes here you can enable TMU (Thermal Management Unit) on
-	  SAMSUNG EXYNOS 4210, 4412, 4414 and 5250 series of SoC. This option
+	  SAMSUNG EXYNOS 4210, 4412, 4414, 5250 and 5440 series of SoC. This option
 	  enables/prepares the configuration, trip and cooling data for the TMU
 	  driver.
diff --git a/drivers/thermal/samsung/exynos_thermal_common.c b/drivers/thermal/samsung/exynos_thermal_common.c
index b0dc63e..de43e18 100644
--- a/drivers/thermal/samsung/exynos_thermal_common.c
+++ b/drivers/thermal/samsung/exynos_thermal_common.c
@@ -370,7 +370,7 @@ int exynos_register_thermal(struct thermal_sensor_conf *sensor_conf)
 	th_zone->mode = THERMAL_DEVICE_ENABLED;
 	sensor_conf->pzone_data = th_zone;
 
-	pr_info("Exynos: Kernel Thermal management registered\n");
+	pr_info("Exynos: Thermal zone(%s) registered\n", sensor_conf->name);
 
 	return 0;
 
diff --git a/drivers/thermal/samsung/exynos_tmu.c b/drivers/thermal/samsung/exynos_tmu.c
index c1a8c5f..72446c9 100644
--- a/drivers/thermal/samsung/exynos_tmu.c
+++ b/drivers/thermal/samsung/exynos_tmu.c
@@ -44,6 +44,7 @@
  * @id: identifier of the one instance of the TMU controller.
  * @pdata: pointer to the tmu platform/configuration data
  * @base: base address of the single instance of the TMU controller.
+ * @base_common: base address of the common registers of the TMU controller.
  * @irq: irq number of the TMU controller.
  * @soc: id of the SOC type.
  * @irq_work: pointer to the irq work structure.
@@ -57,6 +58,7 @@ struct exynos_tmu_data {
 	int id;
 	struct exynos_tmu_platform_data *pdata;
 	void __iomem *base;
+	void __iomem *base_common;
 	int irq;
 	enum soc_type soc;
 	struct work_struct irq_work;
@@ -75,6 +77,9 @@ static int temp_to_code(struct exynos_tmu_data *data, u8 temp)
 	struct exynos_tmu_platform_data *pdata = data->pdata;
 	int temp_code;
 
+	if (pdata->cal_mode == HW_MODE)
+		return temp;
+
 	if (data->soc == SOC_ARCH_EXYNOS4210)
 		/* temp should range between 25 and 125 */
 		if (temp < 25 || temp > 125) {
@@ -109,6 +114,9 @@ static int code_to_temp(struct exynos_tmu_data *data, u8 temp_code)
 	struct exynos_tmu_platform_data *pdata = data->pdata;
 	int temp;
 
+	if (pdata->cal_mode == HW_MODE)
+		return temp_code;
+
 	if (data->soc == SOC_ARCH_EXYNOS4210)
 		/* temp_code should range between 75 and 175 */
 		if (temp_code < 75 || temp_code > 175) {
@@ -139,33 +147,63 @@ static int exynos_tmu_initialize(struct platform_device *pdev)
 	struct exynos_tmu_data *data = platform_get_drvdata(pdev);
 	struct exynos_tmu_platform_data *pdata = data->pdata;
 	struct exynos_tmu_registers *reg = pdata->registers;
-	unsigned int status, trim_info, con;
+	unsigned int status, trim_info = 0, con;
 	unsigned int rising_threshold = 0, falling_threshold = 0;
 	int ret = 0, threshold_code, i, trigger_levs = 0;
 
 	mutex_lock(&data->lock);
 	clk_enable(data->clk);
 
-	status = readb(data->base + reg->tmu_status);
-	if (!status) {
-		ret = -EBUSY;
-		goto out;
+	if (TMU_SUPPORTS(pdata, READY_STATUS)) {
+		status = readb(data->base + reg->tmu_status);
+		if (!status) {
+			ret = -EBUSY;
+			goto out;
+		}
 	}
 
 	if (TMU_SUPPORTS(pdata, TRIM_RELOAD))
 		__raw_writel(1, data->base + reg->triminfo_ctrl);
 
+	if (pdata->cal_mode == HW_MODE)
+		goto skip_calib_data;
+
 	/* Save trimming info in order to perform calibration */
-	trim_info = readl(data->base + reg->triminfo_data);
+	if (data->soc == SOC_ARCH_EXYNOS5440) {
+		/*
+		 * For exynos5440 soc triminfo value is swapped between TMU0 and
+		 * TMU2, so the below logic is needed.
+		 */
+		switch (data->id) {
+		case 0:
+			trim_info = readl(data->base +
+			EXYNOS5440_EFUSE_SWAP_OFFSET + reg->triminfo_data);
+			break;
+		case 1:
+			trim_info = readl(data->base + reg->triminfo_data);
+			break;
+		case 2:
+			trim_info = readl(data->base -
+			EXYNOS5440_EFUSE_SWAP_OFFSET + reg->triminfo_data);
+		}
+	} else {
+		trim_info = readl(data->base + reg->triminfo_data);
+	}
 	data->temp_error1 = trim_info & EXYNOS_TMU_TEMP_MASK;
 	data->temp_error2 = ((trim_info >> reg->triminfo_85_shift) &
 				EXYNOS_TMU_TEMP_MASK);
 
-	if ((pdata->min_efuse_value > data->temp_error1) ||
-			(data->temp_error1 > pdata->max_efuse_value) ||
-			(data->temp_error2 != 0))
-		data->temp_error1 = pdata->efuse_value;
+	if (!data->temp_error1 ||
+		(pdata->min_efuse_value > data->temp_error1) ||
+		(data->temp_error1 > pdata->max_efuse_value))
+		data->temp_error1 = pdata->efuse_value & EXYNOS_TMU_TEMP_MASK;
+
+	if (!data->temp_error2)
+		data->temp_error2 =
+			(pdata->efuse_value >> reg->triminfo_85_shift) &
+			EXYNOS_TMU_TEMP_MASK;
 
+skip_calib_data:
 	/* Count trigger levels to be enabled */
 	for (i = 0; i < MAX_THRESHOLD_LEVS; i++)
 		if (pdata->trigger_levels[i])
@@ -185,9 +223,10 @@ static int exynos_tmu_initialize(struct platform_device *pdev)
 			data->base + reg->threshold_th0 + i * 4);
 
 		writel(reg->inten_rise_mask, data->base + reg->tmu_intclear);
-	} else if (data->soc == SOC_ARCH_EXYNOS) {
+	} else if (data->soc == SOC_ARCH_EXYNOS ||
+			data->soc == SOC_ARCH_EXYNOS5440) {
 		/* Write temperature code for rising and falling threshold */
-		for (i = 0; i < trigger_levs; i++) {
+		for (i = 0; i < trigger_levs && i < 4 ; i++) {
 			threshold_code = temp_to_code(data,
 						pdata->trigger_levels[i]);
 			if (threshold_code < 0) {
@@ -218,7 +257,29 @@ static int exynos_tmu_initialize(struct platform_device *pdev)
 		writel((reg->inten_rise_mask << reg->inten_rise_shift) |
 			(reg->inten_fall_mask << reg->inten_fall_shift),
 				data->base + reg->tmu_intclear);
+
+		/* if 5th threshold limit is also present, use TH2 register */
+		i = 4;
+		if (pdata->trigger_levels[i]) {
+			threshold_code = temp_to_code(data,
+						pdata->trigger_levels[i]);
+			if (threshold_code < 0) {
+				ret = threshold_code;
+				goto out;
+			}
+			rising_threshold = threshold_code << 24;
+			writel(rising_threshold,
+				data->base + reg->threshold_th2);
+			if (pdata->trigger_type[i] == HW_TRIP) {
+				con = readl(data->base + reg->tmu_ctrl);
+				con |= (1 << reg->therm_trip_en_shift);
+				writel(con, data->base + reg->tmu_ctrl);
+			}
+		}
 	}
+	/*Clear the PMIN in the common TMU register*/
+	if (reg->tmu_pmin && !data->id)
+		writel(0, data->base_common + reg->tmu_pmin);
 out:
 	clk_disable(data->clk);
 	mutex_unlock(&data->lock);
@@ -254,6 +315,11 @@ static void exynos_tmu_control(struct platform_device *pdev, bool on)
 		con |= (pdata->noise_cancel_mode << reg->therm_trip_mode_shift);
 	}
 
+	if (pdata->cal_mode == HW_MODE) {
+		con &= ~(reg->calib_mode_mask << reg->calib_mode_shift);
+		con |= pdata->cal_type << reg->calib_mode_shift;
+	}
+
 	if (on) {
 		con |= (1 << reg->core_en_shift);
 		interrupt_en =
@@ -317,9 +383,11 @@ static int exynos_tmu_set_emulation(void *drv_data, unsigned long temp)
 	if (temp) {
 		temp /= MCELSIUS;
 
-		val = (EXYNOS_EMUL_TIME << reg->emul_time_shift) |
-			(temp_to_code(data, temp)
-			 << reg->emul_temp_shift) | EXYNOS_EMUL_ENABLE;
+		if (data->soc == SOC_ARCH_EXYNOS && reg->emul_time_shift)
+			val |= (EXYNOS_EMUL_TIME << reg->emul_time_shift);
+
+		val |= (temp_to_code(data, temp) << reg->emul_temp_shift) |
+			EXYNOS_EMUL_ENABLE;
 	} else {
 		val &= ~EXYNOS_EMUL_ENABLE;
 	}
@@ -343,7 +411,14 @@ static void exynos_tmu_work(struct work_struct *work)
 			struct exynos_tmu_data, irq_work);
 	struct exynos_tmu_platform_data *pdata = data->pdata;
 	struct exynos_tmu_registers *reg = pdata->registers;
-	unsigned int val_irq;
+	unsigned int val_irq, val_type;
+
+	/* Find which sensor generated this interrupt */
+	if (reg->tmu_irqstatus) {
+		val_type = readl(data->base_common + reg->tmu_irqstatus);
+		if (!((val_type >> data->id) & 0x1))
+			goto out;
+	}
 
 	exynos_report_trigger(data->reg_conf);
 	mutex_lock(&data->lock);
@@ -355,7 +430,7 @@ static void exynos_tmu_work(struct work_struct *work)
 
 	clk_disable(data->clk);
 	mutex_unlock(&data->lock);
-
+out:
 	enable_irq(data->irq);
 }
 
@@ -383,6 +458,10 @@ static const struct of_device_id exynos_tmu_match[] = {
 		.compatible = "samsung,exynos5250-tmu",
 		.data = (void *)EXYNOS5250_TMU_DRV_DATA,
 	},
+	{
+		.compatible = "samsung,exynos5440-tmu",
+		.data = (void *)EXYNOS5440_TMU_DRV_DATA,
+	},
 	{},
 };
 MODULE_DEVICE_TABLE(of, exynos_tmu_match);
@@ -420,6 +499,7 @@ static inline struct  exynos_tmu_platform_data *exynos_get_driver_data(
 static int exynos_map_dt_data(struct platform_device *pdev)
 {
 	struct exynos_tmu_data *data = platform_get_drvdata(pdev);
+	struct exynos_tmu_platform_data *pdata = data->pdata;
 	struct resource res;
 
 	if (!data)
@@ -436,7 +516,7 @@ static int exynos_map_dt_data(struct platform_device *pdev)
 	}
 
 	if (of_address_to_resource(pdev->dev.of_node, 0, &res)) {
-		dev_err(&pdev->dev, "failed to get Resource\n");
+		dev_err(&pdev->dev, "failed to get Resource 0\n");
 		return -ENODEV;
 	}
 
@@ -445,6 +525,26 @@ static int exynos_map_dt_data(struct platform_device *pdev)
 		dev_err(&pdev->dev, "Failed to ioremap memory\n");
 		return -ENOMEM;
 	}
+
+	/*
+	 * Check if the TMU is multi instance type and then try to map the
+	 * memory of common registers.
+	 */
+	if (!TMU_SUPPORTS(pdata, MULTI_INST))
+		return 0;
+
+	if (of_address_to_resource(pdev->dev.of_node, 1, &res)) {
+		dev_err(&pdev->dev, "failed to get Resource 1\n");
+		return -ENODEV;
+	}
+
+	data->base_common = devm_ioremap(&pdev->dev, res.start,
+					resource_size(&res));
+	if (!data->base) {
+		dev_err(&pdev->dev, "Failed to ioremap memory\n");
+		return -ENOMEM;
+	}
+
 	return 0;
 }
 
@@ -496,7 +596,8 @@ static int exynos_tmu_probe(struct platform_device *pdev)
 		return ret;
 
 	if (pdata->type == SOC_ARCH_EXYNOS ||
-				pdata->type == SOC_ARCH_EXYNOS4210)
+		pdata->type == SOC_ARCH_EXYNOS4210 ||
+		pdata->type == SOC_ARCH_EXYNOS5440)
 		data->soc = pdata->type;
 	else {
 		ret = -EINVAL;
diff --git a/drivers/thermal/samsung/exynos_tmu.h b/drivers/thermal/samsung/exynos_tmu.h
index de1c342..cc6b10e 100644
--- a/drivers/thermal/samsung/exynos_tmu.h
+++ b/drivers/thermal/samsung/exynos_tmu.h
@@ -43,6 +43,7 @@ enum trigger_type {
 enum soc_type {
 	SOC_ARCH_EXYNOS4210 = 1,
 	SOC_ARCH_EXYNOS,
+	SOC_ARCH_EXYNOS5440,
 };
 
 /**
@@ -61,6 +62,7 @@ enum soc_type {
 #define TMU_SUPPORT_MULTI_INST			BIT(1)
 #define TMU_SUPPORT_TRIM_RELOAD			BIT(2)
 #define TMU_SUPPORT_FALLING_TRIP		BIT(3)
+#define TMU_SUPPORT_READY_STATUS		BIT(4)
 
 #define TMU_SUPPORTS(a, b)	(a->features & TMU_SUPPORT_ ## b)
 
@@ -85,6 +87,8 @@ struct exynos_tmu_registers {
 	u32	therm_trip_en_shift;
 	u32	buf_slope_sel_shift;
 	u32	buf_slope_sel_mask;
+	u32	calib_mode_shift;
+	u32	calib_mode_mask;
 	u32	therm_trip_tq_en_shift;
 	u32	core_en_shift;
 
@@ -137,6 +141,9 @@ struct exynos_tmu_registers {
 	u32	emul_temp_shift;
 	u32	emul_time_shift;
 	u32	emul_time_mask;
+
+	u32	tmu_irqstatus;
+	u32	tmu_pmin;
 };
 
 /**
diff --git a/drivers/thermal/samsung/exynos_tmu_data.c b/drivers/thermal/samsung/exynos_tmu_data.c
index 8a587d4..25629e6 100644
--- a/drivers/thermal/samsung/exynos_tmu_data.c
+++ b/drivers/thermal/samsung/exynos_tmu_data.c
@@ -79,6 +79,7 @@ struct exynos_tmu_platform_data const exynos4210_default_tmu_data = {
 	.freq_tab_count = 2,
 	.type = SOC_ARCH_EXYNOS4210,
 	.registers = &exynos4210_tmu_registers,
+	.features = (TMU_SUPPORT_READY_STATUS),
 };
 #endif
 
@@ -155,6 +156,69 @@ struct exynos_tmu_platform_data const exynos5250_default_tmu_data = {
 	.type = SOC_ARCH_EXYNOS,
 	.registers = &exynos5250_tmu_registers,
 	.features = (TMU_SUPPORT_EMULATION | TMU_SUPPORT_TRIM_RELOAD |
-			TMU_SUPPORT_FALLING_TRIP),
+			TMU_SUPPORT_FALLING_TRIP | TMU_SUPPORT_READY_STATUS),
+};
+#endif
+
+#if defined(CONFIG_SOC_EXYNOS5440)
+static struct exynos_tmu_registers exynos5440_tmu_registers = {
+	.triminfo_data = EXYNOS5440_TMU_S0_7_TRIM,
+	.triminfo_25_shift = EXYNOS_TRIMINFO_25_SHIFT,
+	.triminfo_85_shift = EXYNOS_TRIMINFO_85_SHIFT,
+	.tmu_ctrl = EXYNOS5440_TMU_S0_7_CTRL,
+	.buf_vref_sel_shift = EXYNOS_TMU_REF_VOLTAGE_SHIFT,
+	.buf_vref_sel_mask = EXYNOS_TMU_REF_VOLTAGE_MASK,
+	.therm_trip_mode_shift = EXYNOS_TMU_TRIP_MODE_SHIFT,
+	.therm_trip_mode_mask = EXYNOS_TMU_TRIP_MODE_MASK,
+	.therm_trip_en_shift = EXYNOS_TMU_THERM_TRIP_EN_SHIFT,
+	.buf_slope_sel_shift = EXYNOS_TMU_BUF_SLOPE_SEL_SHIFT,
+	.buf_slope_sel_mask = EXYNOS_TMU_BUF_SLOPE_SEL_MASK,
+	.calib_mode_shift = EXYNOS_TMU_CALIB_MODE_SHIFT,
+	.calib_mode_mask = EXYNOS_TMU_CALIB_MODE_MASK,
+	.core_en_shift = EXYNOS_TMU_CORE_EN_SHIFT,
+	.tmu_status = EXYNOS5440_TMU_S0_7_STATUS,
+	.tmu_cur_temp = EXYNOS5440_TMU_S0_7_TEMP,
+	.threshold_th0 = EXYNOS5440_TMU_S0_7_TH0,
+	.threshold_th1 = EXYNOS5440_TMU_S0_7_TH1,
+	.threshold_th2 = EXYNOS5440_TMU_S0_7_TH2,
+	.tmu_inten = EXYNOS5440_TMU_S0_7_IRQEN,
+	.inten_rise_mask = EXYNOS5440_TMU_RISE_INT_MASK,
+	.inten_rise_shift = EXYNOS5440_TMU_RISE_INT_SHIFT,
+	.inten_fall_mask = EXYNOS5440_TMU_FALL_INT_MASK,
+	.inten_fall_shift = EXYNOS5440_TMU_FALL_INT_SHIFT,
+	.inten_rise0_shift = EXYNOS5440_TMU_INTEN_RISE0_SHIFT,
+	.inten_rise1_shift = EXYNOS5440_TMU_INTEN_RISE1_SHIFT,
+	.inten_rise2_shift = EXYNOS5440_TMU_INTEN_RISE2_SHIFT,
+	.inten_rise3_shift = EXYNOS5440_TMU_INTEN_RISE3_SHIFT,
+	.inten_fall0_shift = EXYNOS5440_TMU_INTEN_FALL0_SHIFT,
+	.tmu_evten = EXYNOS5440_TMU_S0_7_EVTEN,
+	.tmu_intstat = EXYNOS5440_TMU_S0_7_IRQ,
+	.tmu_intclear = EXYNOS5440_TMU_S0_7_IRQ,
+	.tmu_irqstatus = EXYNOS5440_TMU_IRQ_STATUS,
+	.emul_con = EXYNOS5440_TMU_S0_7_DEBUG,
+	.emul_temp_shift = EXYNOS_EMUL_DATA_SHIFT,
+	.tmu_pmin = EXYNOS5440_TMU_PMIN,
+};
+struct exynos_tmu_platform_data const exynos5440_default_tmu_data = {
+	.trigger_levels[0] = 100,
+	.trigger_levels[4] = 105,
+	.trigger_enable[0] = 1,
+	.trigger_type[0] = 1,
+	.trigger_type[4] = 2,
+	.gain = 5,
+	.reference_voltage = 16,
+	.noise_cancel_mode = 4,
+	.cal_type = TYPE_TWO_POINT_TRIMMING,
+	.cal_mode = 0,
+	.efuse_value = 0x5b2d,
+	.min_efuse_value = 16,
+	.max_efuse_value = 76,
+	.first_point_trim = 25,
+	.second_point_trim = 70,
+	.default_temp_offset = 25,
+	.type = SOC_ARCH_EXYNOS5440,
+	.registers = &exynos5440_tmu_registers,
+	.features = (TMU_SUPPORT_EMULATION | TMU_SUPPORT_FALLING_TRIP |
+			TMU_SUPPORT_MULTI_INST),
 };
 #endif
diff --git a/drivers/thermal/samsung/exynos_tmu_data.h b/drivers/thermal/samsung/exynos_tmu_data.h
index 0560413..c409f3a 100644
--- a/drivers/thermal/samsung/exynos_tmu_data.h
+++ b/drivers/thermal/samsung/exynos_tmu_data.h
@@ -75,6 +75,8 @@
 #define EXYNOS_TMU_TRIP_MODE_SHIFT	13
 #define EXYNOS_TMU_TRIP_MODE_MASK	0x7
 #define EXYNOS_TMU_THERM_TRIP_EN_SHIFT	12
+#define EXYNOS_TMU_CALIB_MODE_SHIFT	4
+#define EXYNOS_TMU_CALIB_MODE_MASK	0x3
 
 #define EXYNOS_TMU_INTEN_RISE0_SHIFT	0
 #define EXYNOS_TMU_INTEN_RISE1_SHIFT	4
@@ -91,6 +93,37 @@
 #define EXYNOS_EMUL_DATA_MASK	0xFF
 #define EXYNOS_EMUL_ENABLE	0x1
 
+/*exynos5440 specific registers*/
+#define EXYNOS5440_TMU_S0_7_TRIM		0x000
+#define EXYNOS5440_TMU_S0_7_CTRL		0x020
+#define EXYNOS5440_TMU_S0_7_DEBUG		0x040
+#define EXYNOS5440_TMU_S0_7_STATUS		0x060
+#define EXYNOS5440_TMU_S0_7_TEMP		0x0f0
+#define EXYNOS5440_TMU_S0_7_TH0			0x110
+#define EXYNOS5440_TMU_S0_7_TH1			0x130
+#define EXYNOS5440_TMU_S0_7_TH2			0x150
+#define EXYNOS5440_TMU_S0_7_EVTEN		0x1F0
+#define EXYNOS5440_TMU_S0_7_IRQEN		0x210
+#define EXYNOS5440_TMU_S0_7_IRQ			0x230
+/* exynos5440 common registers */
+#define EXYNOS5440_TMU_IRQ_STATUS		0x000
+#define EXYNOS5440_TMU_PMIN			0x004
+#define EXYNOS5440_TMU_TEMP			0x008
+
+#define EXYNOS5440_EFUSE_SWAP_OFFSET		8
+#define EXYNOS5440_TMU_RISE_INT_MASK		0xf
+#define EXYNOS5440_TMU_RISE_INT_SHIFT		0
+#define EXYNOS5440_TMU_FALL_INT_MASK		0xf
+#define EXYNOS5440_TMU_FALL_INT_SHIFT		4
+#define EXYNOS5440_TMU_INTEN_RISE0_SHIFT	0
+#define EXYNOS5440_TMU_INTEN_RISE1_SHIFT	1
+#define EXYNOS5440_TMU_INTEN_RISE2_SHIFT	2
+#define EXYNOS5440_TMU_INTEN_RISE3_SHIFT	3
+#define EXYNOS5440_TMU_INTEN_FALL0_SHIFT	4
+#define EXYNOS5440_TMU_INTEN_FALL1_SHIFT	5
+#define EXYNOS5440_TMU_INTEN_FALL2_SHIFT	6
+#define EXYNOS5440_TMU_INTEN_FALL3_SHIFT	7
+
 #if defined(CONFIG_CPU_EXYNOS4210) && defined(CONFIG_EXYNOS_THERMAL_DATA)
 extern struct exynos_tmu_platform_data const exynos4210_default_tmu_data;
 #define EXYNOS4210_TMU_DRV_DATA (&exynos4210_default_tmu_data)
@@ -106,4 +139,11 @@ extern struct exynos_tmu_platform_data const exynos5250_default_tmu_data;
 #define EXYNOS5250_TMU_DRV_DATA (NULL)
 #endif
 
+#if defined(CONFIG_SOC_EXYNOS5440) && defined(CONFIG_EXYNOS_THERMAL_DATA)
+extern struct exynos_tmu_platform_data const exynos5440_default_tmu_data;
+#define EXYNOS5440_TMU_DRV_DATA (&exynos5440_default_tmu_data)
+#else
+#define EXYNOS5440_TMU_DRV_DATA (NULL)
+#endif
+
 #endif /*_LINUX_EXYNOS_TMU_DATA_H*/
-- 
1.7.1

