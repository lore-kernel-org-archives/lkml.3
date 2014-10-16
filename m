Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753022AbaJPXPv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Oct 2014 19:15:51 -0400
Received: from li271-223.members.linode.com ([178.79.152.223]:35481 "EHLO
	mail.mleia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750765AbaJPXPt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Oct 2014 19:15:49 -0400
Message-ID: <5440519C.5040001@mleia.com>
Date: Fri, 17 Oct 2014 02:15:40 +0300
From: Vladimir Zapolskiy <vz@mleia.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:10.0.12) Gecko/20130116 Icedove/10.0.12
MIME-Version: 1.0
To: Caesar Wang <caesar.wang@rock-chips.com>
CC: heiko@sntech.de, rui.zhang@intel.com, edubezval@gmail.com,
        zyf@rock-chips.com, dianders@chromium.org,
        linux-rockchip@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-pm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        devicetree@vger.kernel.org, linux-doc@vger.kernel.org,
        cf@rock-chips.com, dmitry.torokhov@gmail.com, dbasehore@chromium.org,
        huangtao@rock-chips.com, cjf@rock-chips.com, zhengsq@rock-chips.com,
        vladimir_zapolskiy@mentor.com
Subject: Re: [PATCH v11 1/5] thermal: rockchip: add driver for thermal
References: <1413466301-25952-1-git-send-email-caesar.wang@rock-chips.com> <1413466301-25952-2-git-send-email-caesar.wang@rock-chips.com>
In-Reply-To: <1413466301-25952-2-git-send-email-caesar.wang@rock-chips.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-CRM114-Version: 20100106-BlameMichelson ( TRE 0.8.0 (BSD) ) MR-49551924 
X-CRM114-CacheID: sfid-20141017_001544_570642_7C16985E 
X-CRM114-Status: GOOD (  47.22  )
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Caesar,

On 16.10.2014 16:31, Caesar Wang wrote:
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
> Signed-off-by: zhaoyifeng<zyf@rock-chips.com>
> Signed-off-by: Caesar Wang<caesar.wang@rock-chips.com>
> ---
>   drivers/thermal/Kconfig            |   9 +
>   drivers/thermal/Makefile           |   1 +
>   drivers/thermal/rockchip_thermal.c | 688 +++++++++++++++++++++++++++++++++++++
>   3 files changed, 698 insertions(+)
>   create mode 100644 drivers/thermal/rockchip_thermal.c
>
> diff --git a/drivers/thermal/Kconfig b/drivers/thermal/Kconfig
> index ef5587f..5efcf73 100644
> --- a/drivers/thermal/Kconfig
> +++ b/drivers/thermal/Kconfig
> @@ -133,6 +133,15 @@ config SPEAR_THERMAL
>   	  Enable this to plug the SPEAr thermal sensor driver into the Linux
>   	  thermal framework.
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
>   config RCAR_THERMAL
>   	tristate "Renesas R-Car thermal driver"
>   	depends on ARCH_SHMOBILE || COMPILE_TEST
> diff --git a/drivers/thermal/Makefile b/drivers/thermal/Makefile
> index 31e232f..21da0a8 100644
> --- a/drivers/thermal/Makefile
> +++ b/drivers/thermal/Makefile
> @@ -19,6 +19,7 @@ thermal_sys-$(CONFIG_CPU_THERMAL)	+= cpu_cooling.o
>
>   # platform thermal drivers
>   obj-$(CONFIG_SPEAR_THERMAL)	+= spear_thermal.o
> +obj-$(CONFIG_ROCKCHIP_THERMAL)	+= rockchip_thermal.o
>   obj-$(CONFIG_RCAR_THERMAL)	+= rcar_thermal.o
>   obj-$(CONFIG_KIRKWOOD_THERMAL)  += kirkwood_thermal.o
>   obj-y				+= samsung/
> diff --git a/drivers/thermal/rockchip_thermal.c b/drivers/thermal/rockchip_thermal.c
> new file mode 100644
> index 0000000..4ecc649
> --- /dev/null
> +++ b/drivers/thermal/rockchip_thermal.c
> @@ -0,0 +1,688 @@
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
> +#include<linux/clk.h>
> +#include<linux/cpu_cooling.h>
> +#include<linux/interrupt.h>
> +#include<linux/io.h>
> +#include<linux/module.h>
> +#include<linux/of.h>
> +#include<linux/of_address.h>
> +#include<linux/of_irq.h>
> +#include<linux/platform_device.h>
> +#include<linux/thermal.h>
> +
> +/**
> + * If the temperature over a period of time High,
> + * the resulting TSHUT gave CRU module,let it reset the entire chip,
> + * or via GPIO give PMIC.
> + */
> +enum reset_mode {
> +	CRU = 0,
> +	GPIO,
> +};
> +
> +/**
> + * The system has three Teperture Sensors.
> + * channel0 is reserve,channel1 is for CPU,and
> + * channel channel 2 is for GPU.
> + */
> +enum sensor_id {
> +	RESERVE = 0,
> +	CPU,
> +	GPU,
> +	SENSOR_ID_END,
> +};
> +
> +struct rockchip_thermal_data {
> +	const struct rockchip_tsadc_platform_data *pdata;
> +	struct thermal_zone_device *tz[SENSOR_ID_END];
> +	struct thermal_cooling_device *cdev;
> +	void __iomem *regs;
> +
> +	unsigned long temp_passive;
> +	unsigned long hw_shut_temp;
> +	unsigned long alarm_temp;
> +	bool irq_enabled;
> +	int irq;
> +	int reset_mode;
> +	int chn;
> +
> +	struct clk *clk;
> +	struct clk *pclk;
> +};
> +
> +struct rockchip_tsadc_platform_data {
> +	unsigned long temp_passive;
> +	unsigned long hw_shut_temp;
> +	int reset_mode;
> +
> +	void (*irq_handle)(void __iomem *reg);
> +	void (*initialize)(int reset_mode, int chn, void __iomem *reg,
> +			   unsigned long hw_shut_temp);
> +	int (*control)(void __iomem *reg, bool on, int chn);
> +	int (*code_to_temp)(u32 code);
> +	u32 (*temp_to_code)(int temp);
> +	void (*set_alarm_temp)(int chn, void __iomem *reg,
> +			       unsigned long alarm_temp);
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
> +#define TSADCV2_AUTO_SRC_EN			(0x3ff<<  4)
> +#define TSADCV2_AUTO_TSHUT_POLARITY_HIGH	BIT(8)
> +#define TSADCV2_AUTO_TSHUT_POLARITY_LOW		~BIT(8)
> +
> +#define TSADCV2_INT_SRC_EN(chn)			BIT(chn)
> +#define TSADCV2_SHUT_2GPIO_SRC_EN(chn)		(0xf<<  (4 + chn))
> +#define TSADCV2_SHUT_2CRU_SRC_EN(chn)		(0xf<<  (8 + chn))
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
> +	int temp;
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
> +static void rk_tsadcv2_irq_handle(void __iomem *regs)
> +{
> +	u32 val;
> +
> +	val = readl_relaxed(regs + TSADCV2_INT_PD);
> +	writel_relaxed(val&  TSADCV2_INT_PD_CLEAR, regs + TSADCV2_INT_PD);
> +}
> +
> +static u32 rk_tsadcv2_temp_to_code(int temp)
> +{
> +	int high, low, mid;
> +
> +	low = 0;
> +	high = ARRAY_SIZE(v2_code_table) - 1;
> +	mid = (high + low) / 2;
> +
> +	if (temp<  v2_code_table[low].temp || temp>  v2_code_table[high].temp)
> +		return 0;
> +
> +	while (low<= high) {
> +		if (temp == v2_code_table[mid].temp)
> +			return v2_code_table[mid].code;
> +		else if (temp<  v2_code_table[mid].temp)
> +			high = mid - 1;
> +		else
> +			low = mid + 1;
> +		mid = (low + high) / 2;
> +	}
> +
> +	return 0;
> +}
> +
> +static int rk_tsadcv2_code_to_temp(u32 code)
> +{
> +	int high, low, mid;
> +
> +	low = 0;
> +	high = ARRAY_SIZE(v2_code_table) - 1;
> +	mid = (high + low) / 2;
> +
> +	if (code>  v2_code_table[low].code || code<  v2_code_table[high].code)
> +		return 125000; /* No code available,return max temperture */
> +
> +	while (low<= high) {
> +		if (code>= v2_code_table[mid].code&&  code<
> +		    v2_code_table[mid - 1].code)
> +			return v2_code_table[mid].temp;
> +		else if (code<  v2_code_table[mid].code)
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
> + * rk_tsadcv2_get_tshut_polarity_high - get the tshut polarity high
> + * the bit 8 is tshut polarity.
> + * 0: low active, 1: high active
> + */
> +static bool rk_tsadcv2_get_tshut_polarity_high(void __iomem *regs)
> +{
> +	u32 val;
> +	bool tshut_polarity;
> +
> +	val = readl_relaxed(regs + TSADCV2_AUTO_CON);
> +	tshut_polarity = (val&  TSADCV2_AUTO_TSHUT_POLARITY_HIGH) ? true :
> +			  false;
> +
> +	return tshut_polarity;
> +}
> +
> +/**
> + * rk_tsadcv2_initialize - init all chn configure for TASDC Controller
> + * (1) Set TSADCV2_COMn_SHUT(chn),configure the super high temperature level,
> + * if tsadc output is smaller than the value, means the temperature is too
> + * high, TSHUT will be asserted.
> + * (2) Set TSADCV2_INT_EN,you can enable the high temperature interrupt for
> + * the channel, and you can set TSHUT output to gpio to reset the whole chip,
> + * and you can set TSHUT output to cru to reset the whole chip.
> + */
> +static void rk_tsadcv2_initialize(int reset_mode, int chn, void __iomem *regs,
> +				  unsigned long hw_shut_temp)
> +{
> +	u32 shutdown_value;
> +
> +	shutdown_value = rk_tsadcv2_temp_to_code(hw_shut_temp);
> +	writel_relaxed(shutdown_value, regs + TSADCV2_COMP_SHUT(chn));
> +
> +	if (reset_mode == GPIO)
> +		writel_relaxed(TSADCV2_SHUT_2GPIO_SRC_EN(chn) |
> +			       TSADCV2_INT_SRC_EN(chn), regs +
> +			       TSADCV2_INT_EN);
> +	else
> +		writel_relaxed(TSADCV2_SHUT_2CRU_SRC_EN(chn) |
> +			       TSADCV2_INT_SRC_EN(chn), regs +
> +			       TSADCV2_INT_EN);
> +}
> +
> +static int rk_tsadcv2_control(void __iomem *regs, bool on, int chn)
> +{
> +	u32 val;
> +
> +	if (on) {
> +		val = readl_relaxed(regs + TSADCV2_AUTO_CON);
> +		writel_relaxed(val | TSADCV2_AUTO_EN, regs + TSADCV2_AUTO_CON);
> +	} else {
> +		val = readl_relaxed(regs + TSADCV2_AUTO_CON);
> +		writel_relaxed(val&  TSADCV2_AUTO_DISABLE,
> +			       regs + TSADCV2_AUTO_CON);
> +	}
> +
> +	return 0;
> +}
> +
> +static void rk_tsadcv2_alarm_temp(int chn, void __iomem *regs,
> +				  unsigned long alarm_temp)
> +{
> +	u32 alarm_value;
> +
> +	alarm_value = rk_tsadcv2_temp_to_code(alarm_temp);
> +
> +	writel_relaxed(alarm_value&  TSADCV2_DATA_MASK, regs +
> +		       TSADCV2_COMP_INT(chn));
> +}
> +
> +static const struct rockchip_tsadc_platform_data rk3288_tsadc_data = {
> +	.reset_mode = GPIO, /* default TSHUT via GPIO give PMIC */
> +	.temp_passive = 80000,
> +	.hw_shut_temp = 120000,
> +	.irq_handle = rk_tsadcv2_irq_handle,
> +	.initialize = rk_tsadcv2_initialize,
> +	.control = rk_tsadcv2_control,
> +	.code_to_temp = rk_tsadcv2_code_to_temp,
> +	.temp_to_code = rk_tsadcv2_temp_to_code,
> +	.set_alarm_temp = rk_tsadcv2_alarm_temp,
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
> +static void rockchip_set_alarm_temp(struct rockchip_thermal_data *data,
> +				    int alarm_temp, int chn)
> +{
> +	const struct rockchip_tsadc_platform_data *tsadc = data->pdata;
> +
> +	data->alarm_temp = alarm_temp;
> +
> +	for (chn = CPU; chn<  SENSOR_ID_END; chn++)
> +		tsadc->set_alarm_temp(chn, data->regs, alarm_temp);

Do you set_alarm_temp() right for all channels? Why do you pass "chn"
argument then?

> +}
> +
> +/**
> + * rockchip_thermal_initialize - init configure for TASDC Controller
> + * (1) Set TSADCV2_AUTO_PERIOD, configure the interleave between
> + * every two accessing of TSADC in normal operation.
> + * (2) Set TSADCV2_AUTO_PERIOD_HT, configure the interleave between
> + * every  two accessing of TSADC after the temperature is higher
> + * than COM_SHUT or COM_INT.
> + * (3) Set TSADCV2_HIGH_INT_DEBOUNCE and TSADC_HIGHT_TSHUT_DEBOUNCE,
> + * if the temperature is higher than COMP_INT or COMP_SHUT for
> + * "debounce" times, TSADC controller will generate interrupt or TSHUT.
> + * (4) Set TSADCV2_AUTO_CON, enable the TSADC controller.
> + */
> +static void rockchip_thermal_initialize(struct rockchip_thermal_data *data)
> +{
> +	bool tshut_polarity;
> +
> +	tshut_polarity = rk_tsadcv2_get_tshut_polarity_high(data->regs);
> +	if (tshut_polarity)
> +		writel_relaxed(0 | (TSADCV2_AUTO_TSHUT_POLARITY_HIGH),
> +			       data->regs + TSADCV2_AUTO_CON);
> +	else
> +		writel_relaxed(0 | (TSADCV2_AUTO_TSHUT_POLARITY_LOW),
> +			       data->regs + TSADCV2_AUTO_CON);
> +
> +	writel_relaxed(TSADCV2_AUTO_PERIOD_TIME, data->regs +
> +		       TSADCV2_AUTO_PERIOD);
> +	writel_relaxed(TSADCV2_AUTO_PERIOD_HT_TIME, data->regs +
> +		       TSADCV2_AUTO_PERIOD_HT);
> +
> +	writel_relaxed(TSADCV2_HIGHT_INT_DEBOUNCE_TIME, data->regs +
> +		       TSADCV2_HIGHT_INT_DEBOUNCE);
> +	writel_relaxed(TSADCV2_HIGHT_TSHUT_DEBOUNCE_TIME, data->regs +
> +		       TSADCV2_HIGHT_TSHUT_DEBOUNCE);
> +
> +	writel_relaxed(TSADCV2_AUTO_SRC_EN | TSADCV2_AUTO_EN, data->regs +
> +		       TSADCV2_AUTO_CON);
> +}
> +
> +static void rockchip_thermal_control(struct rockchip_thermal_data *data,
> +				     bool on, int chn)
> +{
> +	const struct rockchip_tsadc_platform_data *tsadc = data->pdata;
> +
> +	if (tsadc->control)
> +		tsadc->control(data->regs, on, chn);
> +
> +	if (on) {
> +		data->irq_enabled = true;
> +		data->tz[chn]->ops->set_mode(data->tz[chn],
> +		THERMAL_DEVICE_ENABLED);
> +
> +	} else {
> +		data->irq_enabled = false;
> +		data->tz[chn]->ops->set_mode(data->tz[chn],
> +		THERMAL_DEVICE_DISABLED);
> +	}
> +}
> +
> +static irqreturn_t rockchip_thermal_alarm_irq_thread(int irq, void *dev)
> +{
> +	struct rockchip_thermal_data *data = dev;
> +	const struct rockchip_tsadc_platform_data *tsadc = data->pdata;
> +	int chn;
> +
> +	tsadc->irq_handle(data->regs);
> +
> +	for (chn = CPU; chn<  SENSOR_ID_END; chn++)
> +		thermal_zone_device_update(data->tz[chn]);
> +
> +	return IRQ_HANDLED;
> +}
> +
> +static int rockchip_thermal_set_trips(void *zone, long low, long high)
> +{
> +	struct rockchip_thermal_data *data = zone;
> +	const struct rockchip_tsadc_platform_data *tsadc = data->pdata;
> +
> +	low = clamp_val(low, LONG_MIN, LONG_MAX);
> +	high = clamp_val(high, LONG_MIN, LONG_MAX);
> +
> +	/* Update alarm value to next higher trip point */
> +	if (data->alarm_temp == data->temp_passive&&  high<=
> +		tsadc->temp_to_code(data->temp_passive))
> +		high = data->hw_shut_temp;
> +
> +	if (data->alarm_temp>= data->temp_passive&&  high>
> +		tsadc->temp_to_code(data->temp_passive)) {
> +		high = data->temp_passive;
> +	}
> +
> +	return 0;
> +}
> +
> +static int rockchip_thermal_get_cpu_temp(void *zone, long *out_temp)
> +{
> +	struct rockchip_thermal_data *data = zone;
> +	const struct rockchip_tsadc_platform_data *tsadc = data->pdata;
> +	u32 val;
> +
> +	/* the A/D value of the channel last conversion need some time */
> +	val = readl_relaxed(data->regs + TSADCV2_DATA(CPU));
> +	if (val == 0)
> +		return -EPROBE_DEFER;
> +
> +	*out_temp = tsadc->code_to_temp(val);
> +
> +	return 0;
> +}
> +
> +static int rockchip_thermal_get_gpu_temp(void *zone, long *out_temp)
> +{
> +	struct rockchip_thermal_data *data = zone;
> +	const struct rockchip_tsadc_platform_data *tsadc = data->pdata;
> +	u32 val;
> +
> +	/* the A/D value of the channel last conversion need some time */
> +	val = readl_relaxed(data->regs + TSADCV2_DATA(GPU));
> +	if (val == 0)
> +		return -EPROBE_DEFER;
> +
> +	*out_temp = tsadc->code_to_temp(val);
> +
> +	return 0;
> +}
> +
> +static int rockchip_configure_from_dt(struct device *dev,
> +				      struct device_node *np,
> +				      struct rockchip_thermal_data *data)
> +{
> +	int shut_temp, reset_mode;
> +
> +	if (of_property_read_u32(np, "hw-shut-temp",&shut_temp)) {
> +		dev_warn(dev, "Missing default shutdown temp property\n");
> +		data->hw_shut_temp = data->pdata->hw_shut_temp;
> +	} else {
> +		data->hw_shut_temp = shut_temp;
> +	}
> +
> +	if (of_property_read_u32(np, "tsadc-ht-reset-mode",&reset_mode)) {
> +		dev_warn(dev, "Missing default reset mode property\n");
> +		data->reset_mode = data->pdata->reset_mode;
> +	} else {
> +		data->reset_mode = reset_mode;
> +	}
> +
> +	data->temp_passive = data->pdata->temp_passive;
> +
> +	return 0;
> +}
> +
> +static int rockchip_thermal_probe(struct platform_device *pdev)
> +{
> +	struct rockchip_thermal_data *data;
> +	const struct rockchip_tsadc_platform_data *tsadc;
> +	const struct of_device_id *match;
> +
> +	struct cpumask clip_cpus;
> +	struct resource *res;
> +	struct device_node *np = pdev->dev.of_node;
> +
> +	int ret, chn;
> +
> +	data = devm_kzalloc(&pdev->dev, sizeof(struct rockchip_thermal_data),
> +			    GFP_KERNEL);
> +	if (!data)
> +		return -ENOMEM;
> +
> +	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
> +	data->regs = devm_ioremap_resource(&pdev->dev, res);
> +	if (IS_ERR(data->regs)) {
> +		dev_err(&pdev->dev, "Could not get tsadc source, %p\n",
> +			data->regs);
> +		return PTR_ERR(data->regs);
> +	}
> +
> +	match = of_match_node(of_rockchip_thermal_match, np);
> +	if (!match)
> +		return -ENXIO;
> +	data->pdata = (const struct rockchip_tsadc_platform_data *)match->data;
> +	if (!data->pdata)
> +		return -EINVAL;
> +	tsadc = data->pdata;
> +
> +	data->clk = devm_clk_get(&pdev->dev, "tsadc");
> +	if (IS_ERR(data->clk)) {
> +		dev_err(&pdev->dev, "failed to get tsadc clock\n");
> +		return PTR_ERR(data->clk);
> +	}
> +
> +	data->pclk = devm_clk_get(&pdev->dev, "apb_pclk");
> +	if (IS_ERR(data->pclk)) {
> +		dev_err(&pdev->dev, "failed to get tsadc pclk\n");
> +		return PTR_ERR(data->pclk);
> +	}
> +
> +	/**
> +	 * Use a default of 10KHz for the converter clock.
> +	 * This may become user-configurable in the future.
> +	 * Need to judge the data->clk is Divided by xin32k.
> +	 * Need to retry it if the pmic hasn't output the xin32k.
> +	 */
> +	if (clk_get_rate(data->clk) == 0)
> +		return -EPROBE_DEFER;
> +	ret = clk_set_rate(data->clk, 10000);
> +	if (ret<  0) {
> +		dev_err(&pdev->dev, "failed to set tsadc clk rate, %d\n", ret);
> +		return ret;
> +	}
> +
> +	ret = clk_prepare_enable(data->clk);
> +	if (ret<  0) {
> +		dev_err(&pdev->dev, "failed to enable converter clock\n");
> +		goto err_clk;
> +	}
> +
> +	ret = clk_prepare_enable(data->pclk);
> +	if (ret<  0) {
> +		dev_err(&pdev->dev, "failed to enable pclk\n");
> +		goto err_pclk;
> +	}
> +
> +	cpumask_set_cpu(0,&clip_cpus);
> +	data->cdev = of_cpufreq_cooling_register(np,&clip_cpus);
> +	if (IS_ERR(data->cdev)) {
> +		dev_err(&pdev->dev, "failed to register cpufreq cooling device\n");
> +		goto fail_cpufreq_register;
> +	}
> +
> +	data->irq = platform_get_irq(pdev, 0);
> +	if (data->irq<  0) {
> +		dev_err(&pdev->dev, "no irq resource?\n");
> +		goto fail_irq;
> +	}
> +
> +	ret = devm_request_threaded_irq(&pdev->dev, data->irq, NULL,
> +					&rockchip_thermal_alarm_irq_thread,
> +					IRQF_ONESHOT, "rockchip_thermal",
> +					data);
> +	if (ret<  0) {
> +		dev_err(&pdev->dev,
> +			"failed to request tsadc irq: %d\n", ret);
> +		goto fail_irq;
> +	}
> +
> +	ret = rockchip_configure_from_dt(&pdev->dev, np, data);
> +	if (ret)
> +		dev_err(&pdev->dev, "Parsing device tree data error.\n");
> +
> +	rockchip_thermal_initialize(data);
> +
> +	/* The system have two valid Teperture Sensors be registered */
> +	for (chn = CPU; chn<  SENSOR_ID_END; chn++) {
> +		data->chn = chn;

Redundant assignment.

> +		if (chn == CPU)
> +			data->tz[chn] = thermal_zone_of_sensor_register(
> +					&pdev->dev, chn,
> +					data, rockchip_thermal_get_cpu_temp,
> +					NULL,
> +					rockchip_thermal_set_trips);
> +		else
> +			data->tz[chn] = thermal_zone_of_sensor_register(
> +					&pdev->dev, chn,
> +					data, rockchip_thermal_get_gpu_temp,
> +					NULL,
> +					rockchip_thermal_set_trips);
> +		if (IS_ERR(data->tz[chn])) {
> +			ret = PTR_ERR(data->tz[chn]);
> +			dev_err(&pdev->dev, "failed to register sensor: %d\n",
> +				ret);
> +			chn--;

See a comment below about chn.

> +			goto unregister_tzs;
> +		}
> +
> +		rockchip_set_alarm_temp(data, data->temp_passive, chn);
> +		tsadc->initialize(tsadc->reset_mode, chn, data->regs,
> +				  data->hw_shut_temp);
> +		rockchip_thermal_control(data, true, chn);
> +	}
> +
> +	platform_set_drvdata(pdev, data);
> +
> +	return 0;
> +
> +unregister_tzs:
> +	for (; data->chn>= CPU; data->chn--)

Should be chn instead of data->chn.

> +		thermal_zone_of_sensor_unregister(&pdev->dev, data->tz[chn]);
> +
> +fail_irq:
> +	cpufreq_cooling_unregister(data->cdev);
> +fail_cpufreq_register:
> +err_pclk:
> +	clk_disable_unprepare(data->pclk);
> +err_clk:
> +	clk_disable_unprepare(data->clk);
> +
> +	return ret;
> +}
> +
> +static int rockchip_thermal_remove(struct platform_device *pdev)
> +{
> +	struct rockchip_thermal_data *data = platform_get_drvdata(pdev);
> +
> +	for (; data->chn>= CPU; data->chn--) {

Try to get rid of data->chn completely, use local variables for iterating.

You introduce only two sensors (CPU and GPU), and probe() is passed
only if both sensors are configured, so here and below you know how
many sensors are registered -- exactly 2.

> +		rockchip_thermal_control(data, false, data->chn);
> +		thermal_zone_of_sensor_unregister(&pdev->dev,
> +						  data->tz[data->chn]);
> +	}
> +	cpufreq_cooling_unregister(data->cdev);
> +
> +	clk_disable_unprepare(data->clk);
> +	clk_disable_unprepare(data->pclk);
> +
> +	return 0;
> +}
> +
> +#ifdef CONFIG_PM_SLEEP
> +static int rockchip_thermal_suspend(struct device *dev)
> +{
> +	struct platform_device *pdev = to_platform_device(dev);
> +	struct rockchip_thermal_data *data = platform_get_drvdata(pdev);
> +
> +	for (; data->chn>= CPU; data->chn--)
> +		rockchip_thermal_control(data, false, data->chn);
> +
> +	clk_disable(data->clk);
> +	clk_disable(data->pclk);
> +
> +	return 0;
> +}
> +
> +static int rockchip_thermal_resume(struct device *dev)
> +{
> +	struct platform_device *pdev = to_platform_device(dev);
> +	struct rockchip_thermal_data *data = platform_get_drvdata(pdev);
> +	int ret;
> +
> +	ret = clk_enable(data->pclk);
> +	if (ret)
> +		return ret;
> +
> +	ret = clk_enable(data->clk);
> +	if (ret)
> +		return ret;
> +
> +	rockchip_thermal_initialize(data);
> +
> +	for (data->chn = CPU; data->chn<  SENSOR_ID_END; data->chn++)
> +		rockchip_thermal_control(data, true, data->chn);
> +
> +	return 0;
> +}
> +#endif
> +
> +static SIMPLE_DEV_PM_OPS(rockchip_thermal_pm_ops,
> +			 rockchip_thermal_suspend, rockchip_thermal_resume);
> +
> +static struct platform_driver rockchip_thermal_driver = {
> +	.driver = {
> +		   .name = "rockchip-thermal",
> +		   .owner = THIS_MODULE,
> +		   .pm =&rockchip_thermal_pm_ops,
> +		   .of_match_table = of_rockchip_thermal_match,
> +		   },
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
