Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754557AbaJXAzz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Oct 2014 20:55:55 -0400
Received: from mail-pa0-f50.google.com ([209.85.220.50]:58258 "EHLO
	mail-pa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753372AbaJXAzv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Oct 2014 20:55:51 -0400
Date: Thu, 23 Oct 2014 17:55:46 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Caesar Wang <caesar.wang@rock-chips.com>
Cc: heiko@sntech.de, rui.zhang@intel.com, edubezval@gmail.com,
        zyf@rock-chips.com, dianders@chromium.org,
        linux-rockchip@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-pm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        devicetree@vger.kernel.org, linux-doc@vger.kernel.org,
        cf@rock-chips.com, dbasehore@chromium.org, huangtao@rock-chips.com,
        cjf@rock-chips.com, zhengsq@rock-chips.com
Subject: Re: [PATCH v13 1/5] thermal: rockchip: add driver for thermal
Message-ID: <20141024005546.GF9463@dtor-ws>
References: <1414057207-1576-1-git-send-email-caesar.wang@rock-chips.com>
 <1414057207-1576-2-git-send-email-caesar.wang@rock-chips.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1414057207-1576-2-git-send-email-caesar.wang@rock-chips.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Caesar,

On Thu, Oct 23, 2014 at 05:40:03PM +0800, Caesar Wang wrote:
> Thermal is TS-ADC Controller module supports
> user-defined mode and automatic mode.
> 
> User-defined mode refers,TSADC all the control signals entirely by
> software writing to register for direct control.
> 
> Automaic mode refers to the module automatically poll TSADC output,
> and the results were checked.If you find that the temperature High
> in a period of time,an interrupt is generated to the processor
> down-measures taken;If the temperature over a period of time High,
> the resulting TSHUT gave CRU module,let it reset the entire chip,
> or via GPIO give PMIC.
> 
> Signed-off-by: zhaoyifeng <zyf@rock-chips.com>
> Signed-off-by: Caesar Wang <caesar.wang@rock-chips.com>
> ---
>  drivers/thermal/Kconfig            |   9 +
>  drivers/thermal/Makefile           |   1 +
>  drivers/thermal/rockchip_thermal.c | 693 +++++++++++++++++++++++++++++++++++++
>  3 files changed, 703 insertions(+)
>  create mode 100644 drivers/thermal/rockchip_thermal.c
> 
> diff --git a/drivers/thermal/Kconfig b/drivers/thermal/Kconfig
> index ef5587f..5efcf73 100644
> --- a/drivers/thermal/Kconfig
> +++ b/drivers/thermal/Kconfig
> @@ -133,6 +133,15 @@ config SPEAR_THERMAL
>  	  Enable this to plug the SPEAr thermal sensor driver into the Linux
>  	  thermal framework.
>  
> +config ROCKCHIP_THERMAL
> +	tristate "Rockchip thermal driver"
> +	depends on ARCH_ROCKCHIP
> +	help
> +	  Rockchip thermal driver provides support for Temperature sensor
> +	  ADC (TS-ADC) found on Rockchip SoCs. It supports one critical
> +	  trip point. Cpufreq is used as the cooling device and will throttle
> +	  CPUs when the Temperature crosses the passive trip point.
> +
>  config RCAR_THERMAL
>  	tristate "Renesas R-Car thermal driver"
>  	depends on ARCH_SHMOBILE || COMPILE_TEST
> diff --git a/drivers/thermal/Makefile b/drivers/thermal/Makefile
> index 31e232f..21da0a8 100644
> --- a/drivers/thermal/Makefile
> +++ b/drivers/thermal/Makefile
> @@ -19,6 +19,7 @@ thermal_sys-$(CONFIG_CPU_THERMAL)	+= cpu_cooling.o
>  
>  # platform thermal drivers
>  obj-$(CONFIG_SPEAR_THERMAL)	+= spear_thermal.o
> +obj-$(CONFIG_ROCKCHIP_THERMAL)	+= rockchip_thermal.o
>  obj-$(CONFIG_RCAR_THERMAL)	+= rcar_thermal.o
>  obj-$(CONFIG_KIRKWOOD_THERMAL)  += kirkwood_thermal.o
>  obj-y				+= samsung/
> diff --git a/drivers/thermal/rockchip_thermal.c b/drivers/thermal/rockchip_thermal.c
> new file mode 100644
> index 0000000..6705981
> --- /dev/null
> +++ b/drivers/thermal/rockchip_thermal.c
> @@ -0,0 +1,693 @@
> +/*
> + * Copyright (c) 2014, Fuzhou Rockchip Electronics Co., Ltd
> + *
> + * This program is free software; you can redistribute it and/or modify it
> + * under the terms and conditions of the GNU General Public License,
> + * version 2, as published by the Free Software Foundation.
> + *
> + * This program is distributed in the hope it will be useful, but WITHOUT
> + * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
> + * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
> + * more details.
> + */
> +
> +#include <linux/clk.h>
> +#include <linux/cpu_cooling.h>
> +#include <linux/interrupt.h>
> +#include <linux/io.h>
> +#include <linux/module.h>
> +#include <linux/of.h>
> +#include <linux/of_address.h>
> +#include <linux/of_irq.h>
> +#include <linux/platform_device.h>
> +#include <linux/thermal.h>
> +
> +/**
> + * If the temperature over a period of time High,
> + * the resulting TSHUT gave CRU module,let it reset the entire chip,
> + * or via GPIO give PMIC.
> + */
> +enum tshut_mode {
> +	TSHUT_MODE_CRU = 0,
> +	TSHUT_MODE_GPIO,
> +};
> +
> +/**
> + * the system Temperature Sensors tshut(tshut) polarity
> + * the bit 8 is tshut polarity.
> + * 0: low active, 1: high active
> + */
> +enum tshut_polarity {
> +	TSHUT_LOW_ACTIVE = 0,
> +	TSHUT_HIGH_ACTIVE,
> +};
> +
> +/**
> + * The system has three Temperature Sensors.  channel 0 is reserved,
> + * channel 1 is for CPU, and channel 2 is for GPU.
> + */
> +enum sensor_id {
> +	SENSOR_CPU = 1,
> +	SENSOR_GPU,
> +};
> +
> +
> +struct rockchip_tsadc_chip {
> +	long hw_shut_temp;
> +	enum tshut_mode tshut_mode;
> +	enum tshut_polarity tshut_polarity;
> +
> +	/* Chip-wide methods */
> +	void (*initialize)(void __iomem *reg, enum tshut_polarity p);
> +	void (*irq_ack)(void __iomem *reg);
> +
> +	/* Per-sensor methods */
> +	int (*get_temp)(int chn, void __iomem *reg, long *temp);
> +	void (*set_alarm_temp)(int chn, void __iomem *reg, long temp);
> +	void (*set_tshut_temp)(int chn, void __iomem *reg, long temp);
> +	void (*set_tshut_mode)(int chn, void __iomem *reg, enum tshut_mode m);
> +	void (*control)(int chn, void __iomem *reg, bool on);
> +};
> +
> +struct rockchip_thermal_sensor {
> +	struct rockchip_thermal_data *thermal;
> +	struct thermal_zone_device *tzd;
> +	enum sensor_id id;
> +};
> +
> +#define NUM_SENSORS	2 /* Ignore unused sensor 0 */
> +
> +struct rockchip_thermal_data {
> +	const struct rockchip_tsadc_chip *chip;
> +	struct platform_device *pdev;
> +
> +	struct rockchip_thermal_sensor sensors[NUM_SENSORS];
> +
> +	struct thermal_cooling_device *cdev;
> +
> +	struct clk *clk;
> +	struct clk *pclk;
> +
> +	void __iomem *regs;
> +
> +	long hw_shut_temp;
> +	enum tshut_mode tshut_mode;
> +	enum tshut_polarity tshut_polarity;
> +};
> +
> +/* TSADC V2 Sensor info define: */
> +#define TSADCV2_AUTO_CON			0x04
> +#define TSADCV2_INT_EN				0x08
> +#define TSADCV2_INT_PD				0x0c
> +#define TSADCV2_DATA(chn)			(0x20 + (chn) * 0x04)
> +#define TSADCV2_COMP_INT(chn)		        (0x30 + (chn) * 0x04)
> +#define TSADCV2_COMP_SHUT(chn)		        (0x40 + (chn) * 0x04)
> +#define TSADCV2_HIGHT_INT_DEBOUNCE		0x60
> +#define TSADCV2_HIGHT_TSHUT_DEBOUNCE		0x64
> +#define TSADCV2_AUTO_PERIOD			0x68
> +#define TSADCV2_AUTO_PERIOD_HT			0x6c
> +
> +#define TSADCV2_AUTO_EN				BIT(0)
> +#define TSADCV2_AUTO_DISABLE			~BIT(0)
> +#define TSADCV2_AUTO_SRC_EN(chn)		BIT(4 + (chn))
> +#define TSADCV2_AUTO_TSHUT_POLARITY_HIGH	BIT(8)
> +#define TSADCV2_AUTO_TSHUT_POLARITY_LOW		~BIT(8)
> +
> +#define TSADCV2_INT_SRC_EN(chn)			BIT(chn)
> +#define TSADCV2_SHUT_2GPIO_SRC_EN(chn)		BIT(4 + (chn))
> +#define TSADCV2_SHUT_2CRU_SRC_EN(chn)		BIT(8 + (chn))
> +
> +#define TSADCV2_INT_PD_CLEAR			~BIT(8)
> +
> +#define TSADCV2_DATA_MASK			0xfff
> +#define TSADCV2_HIGHT_INT_DEBOUNCE_TIME		0x0a
> +#define TSADCV2_HIGHT_TSHUT_DEBOUNCE_TIME	0x0a
> +#define TSADCV2_AUTO_PERIOD_TIME		0x03e8
> +#define TSADCV2_AUTO_PERIOD_HT_TIME		0x64
> +
> +struct tsadc_table {
> +	unsigned long code;
> +	long temp;
> +};
> +
> +static const struct tsadc_table v2_code_table[] = {
> +	{TSADCV2_DATA_MASK, -40000},
> +	{3800, -40000},
> +	{3792, -35000},
> +	{3783, -30000},
> +	{3774, -25000},
> +	{3765, -20000},
> +	{3756, -15000},
> +	{3747, -10000},
> +	{3737, -5000},
> +	{3728, 0},
> +	{3718, 5000},
> +	{3708, 10000},
> +	{3698, 15000},
> +	{3688, 20000},
> +	{3678, 25000},
> +	{3667, 30000},
> +	{3656, 35000},
> +	{3645, 40000},
> +	{3634, 45000},
> +	{3623, 50000},
> +	{3611, 55000},
> +	{3600, 60000},
> +	{3588, 65000},
> +	{3575, 70000},
> +	{3563, 75000},
> +	{3550, 80000},
> +	{3537, 85000},
> +	{3524, 90000},
> +	{3510, 95000},
> +	{3496, 100000},
> +	{3482, 105000},
> +	{3467, 110000},
> +	{3452, 115000},
> +	{3437, 120000},
> +	{3421, 125000},
> +	{0, 125000},
> +};
> +
> +static u32 rk_tsadcv2_temp_to_code(long temp)
> +{
> +	int high, low, mid;
> +
> +	low = 0;
> +	high = ARRAY_SIZE(v2_code_table) - 1;
> +	mid = (high + low) / 2;
> +
> +	if (temp < v2_code_table[low].temp || temp > v2_code_table[high].temp)
> +		return 0;
> +
> +	while (low <= high) {
> +		if (temp == v2_code_table[mid].temp)
> +			return v2_code_table[mid].code;
> +		else if (temp < v2_code_table[mid].temp)
> +			high = mid - 1;
> +		else
> +			low = mid + 1;
> +		mid = (low + high) / 2;
> +	}
> +
> +	return 0;
> +}
> +
> +static long rk_tsadcv2_code_to_temp(u32 code)
> +{
> +	int high, low, mid;
> +
> +	low = 0;
> +	high = ARRAY_SIZE(v2_code_table) - 1;
> +	mid = (high + low) / 2;
> +
> +	if (code > v2_code_table[low].code || code < v2_code_table[high].code)
> +		return 125000; /* No code available, return max temperature */
> +
> +	while (low <= high) {
> +		if (code >= v2_code_table[mid].code && code <
> +		    v2_code_table[mid - 1].code)
> +			return v2_code_table[mid].temp;
> +		else if (code < v2_code_table[mid].code)
> +			low = mid + 1;
> +		else
> +			high = mid - 1;
> +		mid = (low + high) / 2;
> +	}
> +
> +	return 125000;
> +}
> +
> +/**
> + * rk_tsadcv2_initialize - initialize TASDC Controller
> + * (1) Set TSADCV2_AUTO_PERIOD, configure the interleave between
> + * every two accessing of TSADC in normal operation.
> + * (2) Set TSADCV2_AUTO_PERIOD_HT, configure the interleave between
> + * every two accessing of TSADC after the temperature is higher
> + * than COM_SHUT or COM_INT.
> + * (3) Set TSADCV2_HIGH_INT_DEBOUNCE and TSADC_HIGHT_TSHUT_DEBOUNCE,
> + * if the temperature is higher than COMP_INT or COMP_SHUT for
> + * "debounce" times, TSADC controller will generate interrupt or TSHUT.
> + */
> +static void rk_tsadcv2_initialize(void __iomem *regs,
> +				  enum tshut_polarity tshut_polarity)
> +{
> +	if (tshut_polarity == TSHUT_HIGH_ACTIVE)
> +		writel_relaxed(0 | (TSADCV2_AUTO_TSHUT_POLARITY_HIGH),
> +			       regs + TSADCV2_AUTO_CON);
> +	else
> +		writel_relaxed(0 | (TSADCV2_AUTO_TSHUT_POLARITY_LOW),
> +			       regs + TSADCV2_AUTO_CON);
> +
> +	writel_relaxed(TSADCV2_AUTO_PERIOD_TIME,
> +		       regs + TSADCV2_AUTO_PERIOD);
> +	writel_relaxed(TSADCV2_AUTO_PERIOD_HT_TIME,
> +		       regs + TSADCV2_AUTO_PERIOD_HT);
> +
> +	writel_relaxed(TSADCV2_HIGHT_INT_DEBOUNCE_TIME,
> +		       regs + TSADCV2_HIGHT_INT_DEBOUNCE);
> +	writel_relaxed(TSADCV2_HIGHT_TSHUT_DEBOUNCE_TIME,
> +		       regs + TSADCV2_HIGHT_TSHUT_DEBOUNCE);

SO I do not think we can keep these static, since polling frequency
depends on base clock. On my system given values result in thermal alarm
triggering after as long as 10 seconds after temperature crosses the
alarm setting. We need to adjust values like:


#define TSADCV2_AUTO_PERIOD_TIME 250  /* msec */
#define TSADCV2_AUTO_PERIOD_HT_TIME 50  /* msec */
#define TSADCV2_HIGHT_INT_DEBOUNCE_COUNT 4
#define TSADCV2_HIGHT_TSHUT_DEBOUNCE_COUNT 4

whih will give us 1 sec and 200 msec reaction times and we shoudl set
them as this:

	val = TSADCV2_AUTO_PERIOD_TIME * clk_rate / 1000;
	writel_relaxed(val, regs + TSADCV2_AUTO_PERIOD);

etc.

> +}
> +
> +static void rk_tsadcv2_irq_ack(void __iomem *regs)
> +{
> +	u32 val;
> +
> +	val = readl_relaxed(regs + TSADCV2_INT_PD);
> +	writel_relaxed(val & TSADCV2_INT_PD_CLEAR, regs + TSADCV2_INT_PD);
> +}
> +
> +static int rk_tsadcv2_get_temp(int chn, void __iomem *regs, long *temp)
> +{
> +	u32 val;
> +
> +	/* the A/D value of the channel last conversion need some time */
> +	val = readl_relaxed(regs + TSADCV2_DATA(chn));
> +	if (val == 0)
> +		return -EAGAIN;
> +
> +	*temp = rk_tsadcv2_code_to_temp(val);
> +
> +	return 0;
> +}
> +
> +static void rk_tsadcv2_alarm_temp(int chn, void __iomem *regs, long temp)
> +{
> +	u32 alarm_value, int_en;
> +
> +	alarm_value = rk_tsadcv2_temp_to_code(temp);
> +	writel_relaxed(alarm_value & TSADCV2_DATA_MASK,
> +		       regs + TSADCV2_COMP_INT(chn));
> +
> +	int_en = readl_relaxed(regs + TSADCV2_INT_EN);
> +	int_en |= TSADCV2_INT_SRC_EN(chn);
> +	writel_relaxed(int_en, regs + TSADCV2_INT_EN);
> +}
> +
> +static void rk_tsadcv2_tshut_temp(int chn, void __iomem *regs, long temp)
> +{
> +	u32 tshut_value;
> +
> +	tshut_value = rk_tsadcv2_temp_to_code(temp);
> +	writel_relaxed(tshut_value, regs + TSADCV2_COMP_SHUT(chn));
> +}
> +
> +static void rk_tsadcv2_tshut_mode(int chn, void __iomem *regs,
> +				  enum tshut_mode mode)
> +{
> +	u32 val;
> +
> +	val = readl_relaxed(regs + TSADCV2_INT_EN);
> +	if (mode == TSHUT_MODE_GPIO) {
> +		val &= ~TSADCV2_SHUT_2CRU_SRC_EN(chn);
> +		val |= TSADCV2_SHUT_2GPIO_SRC_EN(chn);
> +	} else {
> +		val &= ~TSADCV2_SHUT_2GPIO_SRC_EN(chn);
> +		val |= TSADCV2_SHUT_2CRU_SRC_EN(chn);
> +	}
> +
> +	writel_relaxed(val, regs + TSADCV2_INT_EN);
> +}
> +
> +static void rk_tsadcv2_control(int chn, void __iomem *regs, bool enable)
> +{
> +	u32 val;
> +
> +	val = readl_relaxed(regs + TSADCV2_AUTO_CON);
> +	if (enable)
> +		val |= TSADCV2_AUTO_EN | TSADCV2_AUTO_SRC_EN(chn);

If I read the spec correctly this TSADCV2_AUTO_SRC_EN controls TSHUT
functionality, not measurements, right? If so you need to toggle these
bits in rk_tsadcv2_tshut_temp, and set TSADCV2_AUTO_EN separately.

> +	else
> +		val &= ~TSADCV2_AUTO_EN;
> +
> +	writel_relaxed(val, regs + TSADCV2_AUTO_CON);
> +}
> +
> +static const struct rockchip_tsadc_chip rk3288_tsadc_data = {
> +	.tshut_mode = TSHUT_MODE_GPIO, /* default TSHUT via GPIO give PMIC */
> +	.tshut_polarity = TSHUT_LOW_ACTIVE, /* default TSHUT LOW ACTIVE */
> +	.hw_shut_temp = 120000,
> +
> +	.initialize = rk_tsadcv2_initialize,
> +	.irq_ack = rk_tsadcv2_irq_ack,
> +	.get_temp = rk_tsadcv2_get_temp,
> +	.set_alarm_temp = rk_tsadcv2_alarm_temp,
> +	.set_tshut_temp = rk_tsadcv2_tshut_temp,
> +	.set_tshut_mode = rk_tsadcv2_tshut_mode,
> +	.control = rk_tsadcv2_control,
> +};
> +
> +static const struct of_device_id of_rockchip_thermal_match[] = {
> +	{
> +		.compatible = "rockchip,rk3288-tsadc",
> +		.data = (void *)&rk3288_tsadc_data,
> +	},
> +	{ /* end */ },
> +};
> +MODULE_DEVICE_TABLE(of, of_rockchip_thermal_match);
> +
> +static void
> +rockchip_thermal_toggle_sensor(struct rockchip_thermal_sensor *sensor, bool on)
> +{
> +	struct thermal_zone_device *tzd = sensor->tzd;
> +
> +	tzd->ops->set_mode(tzd,
> +		on ? THERMAL_DEVICE_ENABLED : THERMAL_DEVICE_DISABLED);
> +}
> +
> +static irqreturn_t rockchip_thermal_alarm_irq_thread(int irq, void *dev)
> +{
> +	struct rockchip_thermal_data *thermal = dev;
> +	int i;
> +
> +	dev_dbg(&thermal->pdev->dev, "thermal alarm\n");
> +
> +	thermal->chip->irq_ack(thermal->regs);
> +
> +	for (i = 0; i < ARRAY_SIZE(thermal->sensors); i++)
> +		thermal_zone_device_update(thermal->sensors[i].tzd);
> +
> +	return IRQ_HANDLED;
> +}
> +
> +static int rockchip_thermal_set_trips(void *_sensor, long low, long high)
> +{
> +	struct rockchip_thermal_sensor *sensor = _sensor;
> +	struct rockchip_thermal_data *thermal = sensor->thermal;
> +	const struct rockchip_tsadc_chip *tsadc = thermal->chip;
> +
> +	dev_dbg(&thermal->pdev->dev, "%s: sensor %d: low: %ld, high %ld\n",
> +		__func__, sensor->id, low, high);
> +
> +	tsadc->set_alarm_temp(sensor->id, thermal->regs, high-5000);
> +
> +	return 0;
> +}
> +
> +static int rockchip_thermal_get_temp(void *_sensor, long *out_temp)
> +{
> +	struct rockchip_thermal_sensor *sensor = _sensor;
> +	struct rockchip_thermal_data *thermal = sensor->thermal;
> +	const struct rockchip_tsadc_chip *tsadc = sensor->thermal->chip;
> +	int retval;
> +
> +	retval = tsadc->get_temp(sensor->id, thermal->regs, out_temp);
> +	dev_dbg(&thermal->pdev->dev, "sensor %d - temp: %ld, retval: %d\n",
> +		sensor->id, *out_temp, retval);
> +
> +	return retval;
> +}
> +
> +static int rockchip_configure_from_dt(struct device *dev,
> +				      struct device_node *np,
> +				      struct rockchip_thermal_data *thermal)
> +{
> +	u32 shut_temp, tshut_mode, tshut_polarity;
> +
> +	if (of_property_read_u32(np, "hw-shut-temp", &shut_temp)) {
> +		dev_warn(dev,
> +			 "Missing tshut temp property, using default %ld\n",
> +			 thermal->chip->hw_shut_temp);
> +		thermal->hw_shut_temp = thermal->chip->hw_shut_temp;
> +	} else if (shut_temp > INT_MAX) {
> +		dev_err(dev, "Invalid tshut temperature specified: %u\n",
> +			shut_temp);
> +		return -ERANGE;
> +	} else {
> +		thermal->hw_shut_temp = shut_temp;
> +	}
> +
> +	if (of_property_read_u32(np, "tsadc-tshut-mode", &tshut_mode)) {
> +		dev_warn(dev,
> +			 "Missing tshut mode property, using default (%s)\n",
> +			 thermal->chip->tshut_mode == TSHUT_MODE_GPIO ?
> +				"gpio" : "cru");
> +		thermal->tshut_mode = thermal->chip->tshut_mode;
> +	} else if (tshut_mode > 1) {
> +		dev_err(dev, "Invalid tshut mode specified: %d\n", tshut_mode);
> +		return -EINVAL;
> +	} else {
> +		thermal->tshut_mode = tshut_mode;
> +	}
> +
> +	if (of_property_read_u32(np, "tsadc-tshut-polarity", &tshut_polarity)) {
> +		dev_warn(dev,
> +			 "Missing tshut-polarity property, using default (%s)\n",
> +			 thermal->chip->tshut_polarity == TSHUT_LOW_ACTIVE ?
> +				"low" : "high");
> +		thermal->tshut_polarity = thermal->chip->tshut_polarity;
> +	} else if (tshut_polarity > 1) {
> +		dev_err(dev, "Invalid tshut-polarity specified: %d\n",
> +			tshut_polarity);
> +		return -EINVAL;
> +	} else {
> +		thermal->tshut_polarity = tshut_polarity;
> +	}
> +
> +	return 0;
> +}
> +
> +static int
> +rockchip_thermal_register_sensor(struct platform_device *pdev,
> +				 struct rockchip_thermal_data *thermal,
> +				 struct rockchip_thermal_sensor *sensor,
> +				 enum sensor_id id)
> +{
> +	const struct rockchip_tsadc_chip *tsadc = thermal->chip;
> +	int error;
> +
> +	tsadc->set_tshut_mode(id, thermal->regs, thermal->chip->tshut_mode);
> +	tsadc->set_tshut_temp(id, thermal->regs, thermal->hw_shut_temp);
> +	thermal->chip->control(id, thermal->regs, true);
> +
> +	sensor->thermal = thermal;
> +	sensor->id = id;
> +	sensor->tzd = thermal_zone_of_sensor_register(&pdev->dev, id, sensor,
> +						rockchip_thermal_get_temp,
> +						NULL,
> +						rockchip_thermal_set_trips);
> +	if (IS_ERR(sensor->tzd)) {
> +		error = PTR_ERR(sensor->tzd);
> +		dev_err(&pdev->dev, "failed to register sensor %d: %d\n",
> +			id, error);
> +		return error;
> +	}
> +
> +	return 0;
> +}
> +
> +static int rockchip_thermal_probe(struct platform_device *pdev)
> +{
> +	struct device_node *np = pdev->dev.of_node;
> +	struct rockchip_thermal_data *thermal;
> +	const struct of_device_id *match;
> +	struct cpumask clip_cpus;
> +	struct resource *res;
> +	int irq;
> +	int i;
> +	int error;
> +
> +	match = of_match_node(of_rockchip_thermal_match, np);
> +	if (!match)
> +		return -ENXIO;
> +
> +	irq = platform_get_irq(pdev, 0);
> +	if (irq < 0) {
> +		dev_err(&pdev->dev, "no irq resource?\n");
> +		return -EINVAL;
> +	}
> +
> +	thermal = devm_kzalloc(&pdev->dev, sizeof(struct rockchip_thermal_data),
> +			       GFP_KERNEL);
> +	if (!thermal)
> +		return -ENOMEM;
> +
> +	thermal->pdev = pdev;
> +
> +	thermal->chip = (const struct rockchip_tsadc_chip *)match->data;
> +	if (!thermal->chip)
> +		return -EINVAL;
> +
> +	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
> +	thermal->regs = devm_ioremap_resource(&pdev->dev, res);
> +	if (IS_ERR(thermal->regs))
> +		return PTR_ERR(thermal->regs);
> +
> +	thermal->clk = devm_clk_get(&pdev->dev, "tsadc");
> +	if (IS_ERR(thermal->clk)) {
> +		error = PTR_ERR(thermal->clk);
> +		dev_err(&pdev->dev, "failed to get tsadc clock: %d\n", error);
> +		return error;
> +	}
> +
> +	thermal->pclk = devm_clk_get(&pdev->dev, "apb_pclk");
> +	if (IS_ERR(thermal->pclk)) {
> +		error = PTR_ERR(thermal->clk);
> +		dev_err(&pdev->dev, "failed to get apb_pclk clock: %d\n",
> +			error);
> +		return error;
> +	}
> +
> +	error = clk_prepare_enable(thermal->clk);
> +	if (error) {
> +		dev_err(&pdev->dev, "failed to enable converter clock: %d\n",
> +			error);
> +		return error;
> +	}
> +
> +	error = clk_prepare_enable(thermal->pclk);
> +	if (error) {
> +		dev_err(&pdev->dev, "failed to enable pclk: %d\n", error);
> +		goto err_disable_clk;
> +	}
> +
> +	cpumask_set_cpu(0, &clip_cpus);
> +	thermal->cdev = of_cpufreq_cooling_register(np, &clip_cpus);

Thinking more about this this chip is not a cooling device, it does not
know how to cool the box, CPU does. So we shoudl not be registering
cooling device here at all.

> +	if (IS_ERR(thermal->cdev)) {
> +		error = PTR_ERR(thermal->cdev);
> +		dev_err(&pdev->dev,
> +			"failed to register cpufreq cooling device: %d\n",
> +			error);
> +		goto err_disable_pclk;
> +	}
> +
> +	error = rockchip_configure_from_dt(&pdev->dev, np, thermal);
> +	if (error) {
> +		dev_err(&pdev->dev, "failed to parse device tree data: %d\n",
> +			error);
> +		goto err_unregister_cooling_device;
> +	}
> +
> +	thermal->chip->initialize(thermal->regs, thermal->tshut_polarity);
> +
> +	error = rockchip_thermal_register_sensor(pdev, thermal,
> +						 &thermal->sensors[0],
> +						 SENSOR_CPU);
> +	if (error) {
> +		dev_err(&pdev->dev,
> +			"failed to register CPU thermal sensor: %d\n", error);
> +		goto err_unregister_cooling_device;
> +	}
> +
> +	error = rockchip_thermal_register_sensor(pdev, thermal,
> +						 &thermal->sensors[1],
> +						 SENSOR_GPU);
> +	if (error) {
> +		dev_err(&pdev->dev,
> +			"failed to register GPU thermal sensor: %d\n", error);
> +		goto err_unregister_cpu_sensor;
> +	}
> +
> +	error = devm_request_threaded_irq(&pdev->dev, irq, NULL,
> +					  &rockchip_thermal_alarm_irq_thread,
> +					  IRQF_ONESHOT,
> +					  "rockchip_thermal", thermal);
> +	if (error) {
> +		dev_err(&pdev->dev,
> +			"failed to request tsadc irq: %d\n", error);
> +		goto err_unregister_gpu_sensor;
> +	}
> +
> +	for (i = 0; i < ARRAY_SIZE(thermal->sensors); i++)
> +		rockchip_thermal_toggle_sensor(&thermal->sensors[i], true);
> +
> +	platform_set_drvdata(pdev, thermal);
> +
> +	return 0;
> +
> +err_unregister_gpu_sensor:
> +	thermal_zone_of_sensor_unregister(&pdev->dev, thermal->sensors[1].tzd);
> +err_unregister_cpu_sensor:
> +	thermal_zone_of_sensor_unregister(&pdev->dev, thermal->sensors[0].tzd);
> +err_unregister_cooling_device:
> +	cpufreq_cooling_unregister(thermal->cdev);
> +err_disable_pclk:
> +	clk_disable_unprepare(thermal->pclk);
> +err_disable_clk:
> +	clk_disable_unprepare(thermal->clk);
> +
> +	return error;
> +}
> +
> +static int rockchip_thermal_remove(struct platform_device *pdev)
> +{
> +	struct rockchip_thermal_data *thermal = platform_get_drvdata(pdev);
> +	int i;
> +
> +	for (i = 0; i < ARRAY_SIZE(thermal->sensors); i++) {
> +		struct rockchip_thermal_sensor *sensor = &thermal->sensors[i];
> +
> +		rockchip_thermal_toggle_sensor(sensor, false);
> +		thermal_zone_of_sensor_unregister(&pdev->dev, sensor->tzd);
> +	}
> +
> +	cpufreq_cooling_unregister(thermal->cdev);
> +
> +	clk_disable_unprepare(thermal->clk);
> +	clk_disable_unprepare(thermal->pclk);
> +
> +	return 0;
> +}
> +
> +static int __maybe_unused rockchip_thermal_suspend(struct device *dev)
> +{
> +	struct platform_device *pdev = to_platform_device(dev);
> +	struct rockchip_thermal_data *thermal = platform_get_drvdata(pdev);
> +	int i;
> +
> +	for (i = 0; i < ARRAY_SIZE(thermal->sensors); i++) {
> +		rockchip_thermal_toggle_sensor(&thermal->sensors[i], false);
> +		thermal->chip->control(i, thermal->regs, false);
> +	}
> +
> +	clk_disable(thermal->clk);
> +	clk_disable(thermal->pclk);
> +
> +	return 0;
> +}
> +
> +static int __maybe_unused rockchip_thermal_resume(struct device *dev)
> +{
> +	struct platform_device *pdev = to_platform_device(dev);
> +	struct rockchip_thermal_data *thermal = platform_get_drvdata(pdev);
> +	int i;
> +	int error;
> +
> +	error = clk_enable(thermal->pclk);
> +	if (error)
> +		return error;
> +
> +	error = clk_enable(thermal->clk);
> +	if (error)
> +		return error;
> +
> +	thermal->chip->initialize(thermal->regs, thermal->tshut_polarity);
> +
> +	for (i = 0; i < ARRAY_SIZE(thermal->sensors); i++) {
> +		thermal->chip->control(i, thermal->regs, true);
> +		rockchip_thermal_toggle_sensor(&thermal->sensors[i], true);
> +	}
> +
> +	return 0;
> +}
> +
> +static SIMPLE_DEV_PM_OPS(rockchip_thermal_pm_ops,
> +			 rockchip_thermal_suspend, rockchip_thermal_resume);
> +
> +static struct platform_driver rockchip_thermal_driver = {
> +	.driver = {
> +		.name = "rockchip-thermal",
> +		.owner = THIS_MODULE,
> +		.pm = &rockchip_thermal_pm_ops,
> +		.of_match_table = of_rockchip_thermal_match,
> +	},
> +	.probe = rockchip_thermal_probe,
> +	.remove = rockchip_thermal_remove,
> +};
> +
> +module_platform_driver(rockchip_thermal_driver);
> +
> +MODULE_DESCRIPTION("ROCKCHIP THERMAL Driver");
> +MODULE_AUTHOR("Rockchip, Inc.");
> +MODULE_LICENSE("GPL v2");
> +MODULE_ALIAS("platform:rockchip-thermal");
> -- 
> 1.9.1
> 
> 

Thanks.

-- 
Dmitry
