Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756018AbaJGXjW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Oct 2014 19:39:22 -0400
Received: from mail-pd0-f169.google.com ([209.85.192.169]:63486 "EHLO
	mail-pd0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755637AbaJGXjR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Oct 2014 19:39:17 -0400
Date: Tue, 7 Oct 2014 16:39:12 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Caesar Wang <caesar.wang@rock-chips.com>
Cc: heiko@sntech.de, rui.zhang@intel.com, edubezval@gmail.com, arnd@arndb.de,
        zyf@rock-chips.com, dianders@chromium.org,
        linux-rockchip@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-pm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        devicetree@vger.kernel.org, linux-doc@vger.kernel.org,
        cf@rock-chips.com, dbasehore@chromium.org, huangtao@rock-chips.com
Subject: Re: [PATCH v7 1/5] thermal: rockchip: add driver for thermal
Message-ID: <20141007233912.GK16469@dtor-ws>
References: <1411900693-30484-1-git-send-email-caesar.wang@rock-chips.com>
 <1411900693-30484-2-git-send-email-caesar.wang@rock-chips.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1411900693-30484-2-git-send-email-caesar.wang@rock-chips.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Caesar,

On Sun, Sep 28, 2014 at 06:38:09PM +0800, Caesar Wang wrote:
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
>  drivers/thermal/Kconfig            |  10 +
>  drivers/thermal/Makefile           |   1 +
>  drivers/thermal/rockchip_thermal.c | 608 +++++++++++++++++++++++++++++++++++++
>  3 files changed, 619 insertions(+)
>  create mode 100644 drivers/thermal/rockchip_thermal.c
> 
> diff --git a/drivers/thermal/Kconfig b/drivers/thermal/Kconfig
> index f9a1386..84f3fc0 100644
> --- a/drivers/thermal/Kconfig
> +++ b/drivers/thermal/Kconfig
> @@ -133,6 +133,16 @@ config SPEAR_THERMAL
>  	  Enable this to plug the SPEAr thermal sensor driver into the Linux
>  	  thermal framework.
>  
> +config ROCKCHIP_THERMAL
> +	tristate "Rockchip thermal driver"
> +	depends on ARCH_ROCKCHIP
> +	help
> +	  Rockchip thermal driver provides support for Temperature sensor
> +	  ADC (TS-ADC) found on Rockchip SoCs. It supports one critical
> +	  trip point and one passive trip point. Cpufreq is used as the
> +	  cooling device and will throttle CPUs when the Temperature
> +	  crosses the passive trip point.
> +
>  config RCAR_THERMAL
>  	tristate "Renesas R-Car thermal driver"
>  	depends on ARCH_SHMOBILE || COMPILE_TEST
> diff --git a/drivers/thermal/Makefile b/drivers/thermal/Makefile
> index de0636a..930554f 100644
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
> index 0000000..9e3e8e8
> --- /dev/null
> +++ b/drivers/thermal/rockchip_thermal.c
> @@ -0,0 +1,608 @@
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
> +#include <linux/gpio/consumer.h>
> +#include <linux/io.h>
> +#include <linux/interrupt.h>
> +#include <linux/module.h>
> +#include <linux/of.h>
> +#include <linux/of_address.h>
> +#include <linux/of_irq.h>
> +#include <linux/platform_device.h>
> +#include <linux/regulator/consumer.h>
> +#include <linux/cpu_cooling.h>
> +#include <linux/thermal.h>
> +
> +struct rockchip_thermal_data {
> +	const struct rockchip_tsadc_platform_data *pdata;
> +	struct thermal_zone_device *tz;
> +	struct thermal_cooling_device *cdev;
> +	void __iomem *regs;
> +
> +	unsigned long temp_passive;
> +	unsigned long temp_critical;
> +	unsigned long hw_shut_temp;
> +	unsigned long alarm_temp;
> +	unsigned long last_temp;
> +	bool irq_enabled;
> +	int irq;
> +
> +	struct clk *clk;
> +	struct clk *pclk;
> +	struct gpio_desc *reset_gpio;
> +};
> +
> +struct rockchip_tsadc_platform_data {
> +	u8 irq_en;
> +	unsigned long hw_shut_temp;
> +
> +	int (*irq_handle)(void __iomem *reg);
> +	int (*initialize)(void __iomem *reg, unsigned long hw_shut_temp);
> +	int (*control)(void __iomem *reg, bool on);
> +	int (*code_to_temp)(u32 code);
> +	u32 (*temp_to_code)(int temp);
> +	void (*set_alarm_temp)(void __iomem *regs, unsigned long alarm_temp);
> +};
> +
> +/* TSADC V2 Sensor info define: */
> +#define TSADCV2_AUTO_CON			0x04
> +#define TSADCV2_INT_EN				0x08
> +#define TSADCV2_INT_PD				0x0c
> +#define TSADCV2_DATA1				0x24
> +#define TSADCV2_COMP1_INT			0x34
> +#define TSADCV2_COMP1_SHUT			0x44
> +#define TSADCV2_AUTO_PERIOD			0x68
> +#define TSADCV2_AUTO_PERIOD_HT			0x6c
> +
> +#define TSADCV2_AUTO_SRC1_EN			BIT(5)
> +#define TSADCV2_AUTO_EN				BIT(0)
> +#define TSADCV2_AUTO_DISABLE			~BIT(0)
> +#define TSADCV2_AUTO_STAS_BUSY			BIT(16)
> +#define TSADCV2_AUTO_STAS_BUSY_MASK		BIT(16)
> +#define TSADCV2_SHUT_2GPIO_SRC1_EN		BIT(5)
> +#define TSADCV2_INT_SRC1_EN			BIT(1)
> +#define TSADCV2_SHUT_SRC1_STATUS		BIT(5)
> +#define TSADCV2_INT_SRC1_STATUS			BIT(1)
> +#define TSADCV2_INT_PD_CLEAR			~BIT(8)
> +
> +#define TSADCV2_DATA_MASK			0xfff
> +#define TSADCV2_HIGHT_INT_DEBOUNCE		0x60
> +#define TSADCV2_HIGHT_TSHUT_DEBOUNCE		0x64
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
> +static int rk_tsadcv2_irq_handle(void __iomem *regs)
> +{
> +	u32 val;
> +
> +	val = readl_relaxed(regs + TSADCV2_INT_PD);
> +	writel_relaxed(val & TSADCV2_INT_PD_CLEAR, regs + TSADCV2_INT_PD);
> +
> +	return 0;
> +}
> +
> +static u32 rk_tsadcv2_temp_to_code(int temp)
> +{
> +	int high, low, mid, ret = 0;
> +
> +	low = 0;
> +	high = ARRAY_SIZE(v2_code_table) - 1;
> +	mid = (high + low) / 2;
> +
> +	if (temp < v2_code_table[low].temp || temp > v2_code_table[high].temp) {
> +		ret = -ERANGE;
> +		goto exit;
> +	}
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
> +
> +exit:
> +	return ret;
> +}
> +
> +static int rk_tsadcv2_code_to_temp(u32 code)
> +{
> +	int i;
> +
> +	for (i = 0; i < ARRAY_SIZE(v2_code_table) - 1; i++) {
> +		if (code >= v2_code_table[i].code)
> +			return v2_code_table[i].temp;
> +	}
> +
> +	/* No code available,return max temperture */
> +	return 125000;
> +}
> +
> +static int rk_tsadcv2_initialize(void __iomem *regs,
> +				 unsigned long hw_shut_temp)
> +{
> +	u32 shutdown_value;
> +
> +	shutdown_value = rk_tsadcv2_temp_to_code(hw_shut_temp);
> +
> +	/* Enable measurements at ~ 10 Hz */
> +	writel_relaxed(0, regs + TSADCV2_AUTO_CON);
> +	writel_relaxed(TSADCV2_AUTO_PERIOD_TIME, regs + TSADCV2_AUTO_PERIOD);
> +	writel_relaxed(TSADCV2_AUTO_PERIOD_HT_TIME, regs +
> +		       TSADCV2_AUTO_PERIOD_HT);
> +	writel_relaxed(shutdown_value, regs + TSADCV2_COMP1_SHUT);
> +	writel_relaxed(TSADCV2_HIGHT_INT_DEBOUNCE_TIME, regs +
> +		       TSADCV2_HIGHT_INT_DEBOUNCE);
> +	writel_relaxed(TSADCV2_HIGHT_TSHUT_DEBOUNCE_TIME, regs +
> +		       TSADCV2_HIGHT_TSHUT_DEBOUNCE);
> +	writel_relaxed(TSADCV2_SHUT_2GPIO_SRC1_EN | TSADCV2_INT_SRC1_EN, regs +
> +		       TSADCV2_INT_EN);
> +	writel_relaxed(TSADCV2_AUTO_SRC1_EN | TSADCV2_AUTO_EN, regs +
> +		       TSADCV2_AUTO_CON);
> +
> +	return 0;
> +}
> +
> +static int rk_tsadcv2_control(void __iomem *regs, bool on)
> +{
> +	u32 val;
> +
> +	if (on) {
> +		val = readl_relaxed(regs + TSADCV2_AUTO_CON);
> +		writel_relaxed(val | TSADCV2_AUTO_EN, regs + TSADCV2_AUTO_CON);
> +	} else {
> +		val = readl_relaxed(regs + TSADCV2_AUTO_CON);
> +		writel_relaxed(val & TSADCV2_AUTO_DISABLE,
> +			       regs + TSADCV2_AUTO_CON);
> +	}
> +
> +	return 0;
> +}
> +
> +static void rk_tsadcv2_alarm_temp(void __iomem *regs, unsigned long alarm_temp)
> +{
> +	u32 alarm_value;
> +
> +	alarm_value = rk_tsadcv2_temp_to_code(alarm_temp);
> +
> +	writel_relaxed(alarm_value, regs + TSADCV2_COMP1_INT);
> +}
> +
> +static const struct rockchip_tsadc_platform_data rk3288_tsadc_data = {
> +	.irq_en = 1,
> +	.hw_shut_temp = 115000,
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
> +				    int alarm_temp)
> +{
> +	const struct rockchip_tsadc_platform_data *p_tsadc_data = data->pdata;
> +
> +	data->alarm_temp = alarm_temp;
> +	if (p_tsadc_data->set_alarm_temp)
> +		p_tsadc_data->set_alarm_temp(data->regs, alarm_temp);
> +}
> +
> +static int rockchip_thermal_initialize(struct rockchip_thermal_data *data)
> +{
> +	const struct rockchip_tsadc_platform_data *p_tsadc_data = data->pdata;
> +
> +	if (p_tsadc_data->initialize)
> +		p_tsadc_data->initialize(data->regs, data->hw_shut_temp);
> +	rockchip_set_alarm_temp(data, data->temp_passive);
> +
> +	return 0;
> +}
> +
> +static void rockchip_thermal_control(struct rockchip_thermal_data *data,
> +				     bool on)
> +{
> +	const struct rockchip_tsadc_platform_data *p_tsadc_data = data->pdata;
> +
> +	if (p_tsadc_data->control)
> +		p_tsadc_data->control(data->regs, on);
> +
> +	if (on) {
> +		data->irq_enabled = true;
> +		data->tz->ops->set_mode(data->tz, THERMAL_DEVICE_ENABLED);
> +	} else {
> +		data->irq_enabled = false;
> +		data->tz->ops->set_mode(data->tz, THERMAL_DEVICE_DISABLED);
> +	}
> +}
> +
> +static irqreturn_t rockchip_thermal_alarm_irq_thread(int irq, void *dev)
> +{
> +	struct rockchip_thermal_data *data = dev;
> +	const struct rockchip_tsadc_platform_data *p_tsadc_data = data->pdata;
> +
> +	unsigned long current_temp;
> +	int err;
> +
> +	dev_dbg(&data->tz->device, "THERMAL ALARM: T > %lu\n",
> +		data->alarm_temp / 1000);
> +
> +	if (p_tsadc_data->irq_en && p_tsadc_data->irq_handle)
> +		p_tsadc_data->irq_handle(data->regs);
> +
> +	thermal_zone_device_update(data->tz);
> +
> +	/* Ensure to over shutdown temp after irq be generated */
> +	err = data->tz->ops->get_temp(data->tz, &current_temp);
> +	if (err)
> +		return err;
> +
> +	if (current_temp > data->hw_shut_temp) {
> +		dev_info(&data->tz->device, "over temp restarting...\n");
> +		gpiod_direction_output(data->reset_gpio, 1);
> +	}

I am a bit confused with the purpose of data->hw_shut_temp. We first
write it as a shutdown value during initialization (which I assume will
cause hardware to shut off immediately). We also set an alarm with it
and toggle reset ping if defined. On top of that, if I read this
correctly) we have generic thermal code issuing shutdown when critical
trip point is reached. This seems like 2 ways too many of handling the
shut off.

Also it seems that we fetch data->temp_critical from DT but never use
it.

Can we say that we define safeguard value (hardcoded, not a DT properly)
that causes immediate thermal shutdown via hardware, and let generic
framework continue orderly shutting down if we trip over critical point?

This way rockchip_thermal_alarm_irq_thread() will only need to ack the
interrupt and call thermal_zone_device_update(data->tz); 
 
> +
> +	return IRQ_HANDLED;
> +}
> +
> +static int rockchip_thermal_get_temp(void *zone, long *out_temp)
> +{
> +	struct rockchip_thermal_data *data = zone;
> +	const struct rockchip_tsadc_platform_data *p_tsadc_data = data->pdata;
> +	u32 val;
> +
> +	val = readl_relaxed(data->regs + TSADCV2_DATA1);
> +	if (val == 0)
> +		return -EPROBE_DEFER;
> +
> +	*out_temp = p_tsadc_data->code_to_temp(val);
> +
> +	/* Update alarm value to next higher trip point */
> +	if (data->alarm_temp == data->temp_passive && *out_temp >=
> +		data->temp_passive)
> +		rockchip_set_alarm_temp(data, data->hw_shut_temp);
> +
> +	if (data->alarm_temp == data->temp_passive && *out_temp <
> +		data->temp_passive) {
> +		rockchip_set_alarm_temp(data, data->temp_passive);
> +		dev_dbg(&data->tz->device, "thermal alarm off: T < %lu\n",
> +			data->alarm_temp / 1000);
> +	}
> +
> +	if (*out_temp != data->last_temp) {
> +		dev_dbg(&data->tz->device, "millicelsius: %ld\n", *out_temp);
> +		data->last_temp = *out_temp;
> +	}
> +
> +	/* Reenable alarm IRQ if temperature below alarm temperature */
> +	if (!data->irq_enabled && *out_temp < data->alarm_temp) {
> +		data->irq_enabled = true;
> +		enable_irq(data->irq);
> +	}

I think instead of changing alarm settings here we should be doing it in
the set_trips() callback. Also, it seems that we are resetting the alarm
once temperature subsides, but should not we advance alarm to the next
trip point as temperature is rising (in case it raises too fast compared
to our polling frequency)?

Thanks.

-- 
Dmitry
