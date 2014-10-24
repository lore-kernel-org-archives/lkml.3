Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756133AbaJXIfN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Oct 2014 04:35:13 -0400
Received: from regular1.263xmail.com ([211.150.99.133]:53106 "EHLO
	regular1.263xmail.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755934AbaJXIfD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Oct 2014 04:35:03 -0400
X-263anti-spam: KSV:0;
X-MAIL-GRAY: 0
X-MAIL-DELIVERY: 1
X-KSVirus-check: 0
X-ABS-CHECKED: 4
X-RL-SENDER: caesar.wang@rock-chips.com
X-FST-TO: zhengsq@rock-chips.com
X-SENDER-IP: 58.22.7.114
X-LOGIN-NAME: caesar.wang@rock-chips.com
X-UNIQUE-TAG: <33a9d634e045d8a7081354c43c4d6de4>
X-ATTACHMENT-NUM: 0
X-DNS-TYPE: 0
Message-ID: <544A0F3C.8020609@rock-chips.com>
Date: Fri, 24 Oct 2014 16:35:08 +0800
From: Caesar Wang <caesar.wang@rock-chips.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
CC: heiko@sntech.de, rui.zhang@intel.com, edubezval@gmail.com,
        zyf@rock-chips.com, dianders@chromium.org,
        linux-rockchip@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-pm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        devicetree@vger.kernel.org, linux-doc@vger.kernel.org,
        cf@rock-chips.com, dbasehore@chromium.org, huangtao@rock-chips.com,
        cjf@rock-chips.com, zhengsq@rock-chips.com
Subject: Re: [PATCH v13 1/5] thermal: rockchip: add driver for thermal
References: <1414057207-1576-1-git-send-email-caesar.wang@rock-chips.com> <1414057207-1576-2-git-send-email-caesar.wang@rock-chips.com> <20141024005546.GF9463@dtor-ws> <20141024082108.GB39338@dtor-ws>
In-Reply-To: <20141024082108.GB39338@dtor-ws>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


在 2014/10/24 16:21, Dmitry Torokhov 写道:
> On Thu, Oct 23, 2014 at 05:55:46PM -0700, Dmitry Torokhov wrote:
>> Hi Caesar,
>>
>> On Thu, Oct 23, 2014 at 05:40:03PM +0800, Caesar Wang wrote:
>>> Thermal is TS-ADC Controller module supports
>>> user-defined mode and automatic mode.
>>>
>>> User-defined mode refers,TSADC all the control signals entirely by
>>> software writing to register for direct control.
>>>
>>> Automaic mode refers to the module automatically poll TSADC output,
>>> and the results were checked.If you find that the temperature High
>>> in a period of time,an interrupt is generated to the processor
>>> down-measures taken;If the temperature over a period of time High,
>>> the resulting TSHUT gave CRU module,let it reset the entire chip,
>>> or via GPIO give PMIC.
>>>
>>> Signed-off-by: zhaoyifeng <zyf@rock-chips.com>
>>> Signed-off-by: Caesar Wang <caesar.wang@rock-chips.com>
>>> ---
>>>   drivers/thermal/Kconfig            |   9 +
>>>   drivers/thermal/Makefile           |   1 +
>>>   drivers/thermal/rockchip_thermal.c | 693 +++++++++++++++++++++++++++++++++++++
>>>   3 files changed, 703 insertions(+)
>>>   create mode 100644 drivers/thermal/rockchip_thermal.c
>>>
>>> diff --git a/drivers/thermal/Kconfig b/drivers/thermal/Kconfig
>>> index ef5587f..5efcf73 100644
>>> --- a/drivers/thermal/Kconfig
>>> +++ b/drivers/thermal/Kconfig
>>> @@ -133,6 +133,15 @@ config SPEAR_THERMAL
>>>   	  Enable this to plug the SPEAr thermal sensor driver into the Linux
>>>   	  thermal framework.
>>>   
>>> +config ROCKCHIP_THERMAL
>>> +	tristate "Rockchip thermal driver"
>>> +	depends on ARCH_ROCKCHIP
>>> +	help
>>> +	  Rockchip thermal driver provides support for Temperature sensor
>>> +	  ADC (TS-ADC) found on Rockchip SoCs. It supports one critical
>>> +	  trip point. Cpufreq is used as the cooling device and will throttle
>>> +	  CPUs when the Temperature crosses the passive trip point.
>>> +
>>>   config RCAR_THERMAL
>>>   	tristate "Renesas R-Car thermal driver"
>>>   	depends on ARCH_SHMOBILE || COMPILE_TEST
>>> diff --git a/drivers/thermal/Makefile b/drivers/thermal/Makefile
>>> index 31e232f..21da0a8 100644
>>> --- a/drivers/thermal/Makefile
>>> +++ b/drivers/thermal/Makefile
>>> @@ -19,6 +19,7 @@ thermal_sys-$(CONFIG_CPU_THERMAL)	+= cpu_cooling.o
>>>   
>>>   # platform thermal drivers
>>>   obj-$(CONFIG_SPEAR_THERMAL)	+= spear_thermal.o
>>> +obj-$(CONFIG_ROCKCHIP_THERMAL)	+= rockchip_thermal.o
>>>   obj-$(CONFIG_RCAR_THERMAL)	+= rcar_thermal.o
>>>   obj-$(CONFIG_KIRKWOOD_THERMAL)  += kirkwood_thermal.o
>>>   obj-y				+= samsung/
>>> diff --git a/drivers/thermal/rockchip_thermal.c b/drivers/thermal/rockchip_thermal.c
>>> new file mode 100644
>>> index 0000000..6705981
>>> --- /dev/null
>>> +++ b/drivers/thermal/rockchip_thermal.c
>>> @@ -0,0 +1,693 @@
>>> +/*
>>> + * Copyright (c) 2014, Fuzhou Rockchip Electronics Co., Ltd
>>> + *
>>> + * This program is free software; you can redistribute it and/or modify it
>>> + * under the terms and conditions of the GNU General Public License,
>>> + * version 2, as published by the Free Software Foundation.
>>> + *
>>> + * This program is distributed in the hope it will be useful, but WITHOUT
>>> + * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
>>> + * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
>>> + * more details.
>>> + */
>>> +
>>> +#include <linux/clk.h>
>>> +#include <linux/cpu_cooling.h>
>>> +#include <linux/interrupt.h>
>>> +#include <linux/io.h>
>>> +#include <linux/module.h>
>>> +#include <linux/of.h>
>>> +#include <linux/of_address.h>
>>> +#include <linux/of_irq.h>
>>> +#include <linux/platform_device.h>
>>> +#include <linux/thermal.h>
>>> +
>>> +/**
>>> + * If the temperature over a period of time High,
>>> + * the resulting TSHUT gave CRU module,let it reset the entire chip,
>>> + * or via GPIO give PMIC.
>>> + */
>>> +enum tshut_mode {
>>> +	TSHUT_MODE_CRU = 0,
>>> +	TSHUT_MODE_GPIO,
>>> +};
>>> +
>>> +/**
>>> + * the system Temperature Sensors tshut(tshut) polarity
>>> + * the bit 8 is tshut polarity.
>>> + * 0: low active, 1: high active
>>> + */
>>> +enum tshut_polarity {
>>> +	TSHUT_LOW_ACTIVE = 0,
>>> +	TSHUT_HIGH_ACTIVE,
>>> +};
>>> +
>>> +/**
>>> + * The system has three Temperature Sensors.  channel 0 is reserved,
>>> + * channel 1 is for CPU, and channel 2 is for GPU.
>>> + */
>>> +enum sensor_id {
>>> +	SENSOR_CPU = 1,
>>> +	SENSOR_GPU,
>>> +};
>>> +
>>> +
>>> +struct rockchip_tsadc_chip {
>>> +	long hw_shut_temp;
>>> +	enum tshut_mode tshut_mode;
>>> +	enum tshut_polarity tshut_polarity;
>>> +
>>> +	/* Chip-wide methods */
>>> +	void (*initialize)(void __iomem *reg, enum tshut_polarity p);
>>> +	void (*irq_ack)(void __iomem *reg);
>>> +
>>> +	/* Per-sensor methods */
>>> +	int (*get_temp)(int chn, void __iomem *reg, long *temp);
>>> +	void (*set_alarm_temp)(int chn, void __iomem *reg, long temp);
>>> +	void (*set_tshut_temp)(int chn, void __iomem *reg, long temp);
>>> +	void (*set_tshut_mode)(int chn, void __iomem *reg, enum tshut_mode m);
>>> +	void (*control)(int chn, void __iomem *reg, bool on);
>>> +};
>>> +
>>> +struct rockchip_thermal_sensor {
>>> +	struct rockchip_thermal_data *thermal;
>>> +	struct thermal_zone_device *tzd;
>>> +	enum sensor_id id;
>>> +};
>>> +
>>> +#define NUM_SENSORS	2 /* Ignore unused sensor 0 */
>>> +
>>> +struct rockchip_thermal_data {
>>> +	const struct rockchip_tsadc_chip *chip;
>>> +	struct platform_device *pdev;
>>> +
>>> +	struct rockchip_thermal_sensor sensors[NUM_SENSORS];
>>> +
>>> +	struct thermal_cooling_device *cdev;
>>> +
>>> +	struct clk *clk;
>>> +	struct clk *pclk;
>>> +
>>> +	void __iomem *regs;
>>> +
>>> +	long hw_shut_temp;
>>> +	enum tshut_mode tshut_mode;
>>> +	enum tshut_polarity tshut_polarity;
>>> +};
>>> +
>>> +/* TSADC V2 Sensor info define: */
>>> +#define TSADCV2_AUTO_CON			0x04
>>> +#define TSADCV2_INT_EN				0x08
>>> +#define TSADCV2_INT_PD				0x0c
>>> +#define TSADCV2_DATA(chn)			(0x20 + (chn) * 0x04)
>>> +#define TSADCV2_COMP_INT(chn)		        (0x30 + (chn) * 0x04)
>>> +#define TSADCV2_COMP_SHUT(chn)		        (0x40 + (chn) * 0x04)
>>> +#define TSADCV2_HIGHT_INT_DEBOUNCE		0x60
>>> +#define TSADCV2_HIGHT_TSHUT_DEBOUNCE		0x64
>>> +#define TSADCV2_AUTO_PERIOD			0x68
>>> +#define TSADCV2_AUTO_PERIOD_HT			0x6c
>>> +
>>> +#define TSADCV2_AUTO_EN				BIT(0)
>>> +#define TSADCV2_AUTO_DISABLE			~BIT(0)
>>> +#define TSADCV2_AUTO_SRC_EN(chn)		BIT(4 + (chn))
>>> +#define TSADCV2_AUTO_TSHUT_POLARITY_HIGH	BIT(8)
>>> +#define TSADCV2_AUTO_TSHUT_POLARITY_LOW		~BIT(8)
>>> +
>>> +#define TSADCV2_INT_SRC_EN(chn)			BIT(chn)
>>> +#define TSADCV2_SHUT_2GPIO_SRC_EN(chn)		BIT(4 + (chn))
>>> +#define TSADCV2_SHUT_2CRU_SRC_EN(chn)		BIT(8 + (chn))
>>> +
>>> +#define TSADCV2_INT_PD_CLEAR			~BIT(8)
>>> +
>>> +#define TSADCV2_DATA_MASK			0xfff
>>> +#define TSADCV2_HIGHT_INT_DEBOUNCE_TIME		0x0a
>>> +#define TSADCV2_HIGHT_TSHUT_DEBOUNCE_TIME	0x0a
>>> +#define TSADCV2_AUTO_PERIOD_TIME		0x03e8
>>> +#define TSADCV2_AUTO_PERIOD_HT_TIME		0x64
>>> +
>>> +struct tsadc_table {
>>> +	unsigned long code;
>>> +	long temp;
>>> +};
>>> +
>>> +static const struct tsadc_table v2_code_table[] = {
>>> +	{TSADCV2_DATA_MASK, -40000},
>>> +	{3800, -40000},
>>> +	{3792, -35000},
>>> +	{3783, -30000},
>>> +	{3774, -25000},
>>> +	{3765, -20000},
>>> +	{3756, -15000},
>>> +	{3747, -10000},
>>> +	{3737, -5000},
>>> +	{3728, 0},
>>> +	{3718, 5000},
>>> +	{3708, 10000},
>>> +	{3698, 15000},
>>> +	{3688, 20000},
>>> +	{3678, 25000},
>>> +	{3667, 30000},
>>> +	{3656, 35000},
>>> +	{3645, 40000},
>>> +	{3634, 45000},
>>> +	{3623, 50000},
>>> +	{3611, 55000},
>>> +	{3600, 60000},
>>> +	{3588, 65000},
>>> +	{3575, 70000},
>>> +	{3563, 75000},
>>> +	{3550, 80000},
>>> +	{3537, 85000},
>>> +	{3524, 90000},
>>> +	{3510, 95000},
>>> +	{3496, 100000},
>>> +	{3482, 105000},
>>> +	{3467, 110000},
>>> +	{3452, 115000},
>>> +	{3437, 120000},
>>> +	{3421, 125000},
>>> +	{0, 125000},
>>> +};
>>> +
>>> +static u32 rk_tsadcv2_temp_to_code(long temp)
>>> +{
>>> +	int high, low, mid;
>>> +
>>> +	low = 0;
>>> +	high = ARRAY_SIZE(v2_code_table) - 1;
>>> +	mid = (high + low) / 2;
>>> +
>>> +	if (temp < v2_code_table[low].temp || temp > v2_code_table[high].temp)
>>> +		return 0;
>>> +
>>> +	while (low <= high) {
>>> +		if (temp == v2_code_table[mid].temp)
>>> +			return v2_code_table[mid].code;
>>> +		else if (temp < v2_code_table[mid].temp)
>>> +			high = mid - 1;
>>> +		else
>>> +			low = mid + 1;
>>> +		mid = (low + high) / 2;
>>> +	}
>>> +
>>> +	return 0;
>>> +}
>>> +
>>> +static long rk_tsadcv2_code_to_temp(u32 code)
>>> +{
>>> +	int high, low, mid;
>>> +
>>> +	low = 0;
>>> +	high = ARRAY_SIZE(v2_code_table) - 1;
>>> +	mid = (high + low) / 2;
>>> +
>>> +	if (code > v2_code_table[low].code || code < v2_code_table[high].code)
>>> +		return 125000; /* No code available, return max temperature */
>>> +
>>> +	while (low <= high) {
>>> +		if (code >= v2_code_table[mid].code && code <
>>> +		    v2_code_table[mid - 1].code)
>>> +			return v2_code_table[mid].temp;
>>> +		else if (code < v2_code_table[mid].code)
>>> +			low = mid + 1;
>>> +		else
>>> +			high = mid - 1;
>>> +		mid = (low + high) / 2;
>>> +	}
>>> +
>>> +	return 125000;
>>> +}
>>> +
>>> +/**
>>> + * rk_tsadcv2_initialize - initialize TASDC Controller
>>> + * (1) Set TSADCV2_AUTO_PERIOD, configure the interleave between
>>> + * every two accessing of TSADC in normal operation.
>>> + * (2) Set TSADCV2_AUTO_PERIOD_HT, configure the interleave between
>>> + * every two accessing of TSADC after the temperature is higher
>>> + * than COM_SHUT or COM_INT.
>>> + * (3) Set TSADCV2_HIGH_INT_DEBOUNCE and TSADC_HIGHT_TSHUT_DEBOUNCE,
>>> + * if the temperature is higher than COMP_INT or COMP_SHUT for
>>> + * "debounce" times, TSADC controller will generate interrupt or TSHUT.
>>> + */
>>> +static void rk_tsadcv2_initialize(void __iomem *regs,
>>> +				  enum tshut_polarity tshut_polarity)
>>> +{
>>> +	if (tshut_polarity == TSHUT_HIGH_ACTIVE)
>>> +		writel_relaxed(0 | (TSADCV2_AUTO_TSHUT_POLARITY_HIGH),
>>> +			       regs + TSADCV2_AUTO_CON);
>>> +	else
>>> +		writel_relaxed(0 | (TSADCV2_AUTO_TSHUT_POLARITY_LOW),
>>> +			       regs + TSADCV2_AUTO_CON);
>>> +
>>> +	writel_relaxed(TSADCV2_AUTO_PERIOD_TIME,
>>> +		       regs + TSADCV2_AUTO_PERIOD);
>>> +	writel_relaxed(TSADCV2_AUTO_PERIOD_HT_TIME,
>>> +		       regs + TSADCV2_AUTO_PERIOD_HT);
>>> +
>>> +	writel_relaxed(TSADCV2_HIGHT_INT_DEBOUNCE_TIME,
>>> +		       regs + TSADCV2_HIGHT_INT_DEBOUNCE);
>>> +	writel_relaxed(TSADCV2_HIGHT_TSHUT_DEBOUNCE_TIME,
>>> +		       regs + TSADCV2_HIGHT_TSHUT_DEBOUNCE);
>> SO I do not think we can keep these static, since polling frequency
>> depends on base clock. On my system given values result in thermal alarm
>> triggering after as long as 10 seconds after temperature crosses the
>> alarm setting. We need to adjust values like:
>>
>>
>> #define TSADCV2_AUTO_PERIOD_TIME 250  /* msec */
>> #define TSADCV2_AUTO_PERIOD_HT_TIME 50  /* msec */
>> #define TSADCV2_HIGHT_INT_DEBOUNCE_COUNT 4
>> #define TSADCV2_HIGHT_TSHUT_DEBOUNCE_COUNT 4
>>
>> whih will give us 1 sec and 200 msec reaction times and we shoudl set
>> them as this:
>>
>> 	val = TSADCV2_AUTO_PERIOD_TIME * clk_rate / 1000;
>> 	writel_relaxed(val, regs + TSADCV2_AUTO_PERIOD);
>>
>> etc.
>>
>>> +}
>>> +
>>> +static void rk_tsadcv2_irq_ack(void __iomem *regs)
>>> +{
>>> +	u32 val;
>>> +
>>> +	val = readl_relaxed(regs + TSADCV2_INT_PD);
>>> +	writel_relaxed(val & TSADCV2_INT_PD_CLEAR, regs + TSADCV2_INT_PD);
>>> +}
>>> +
>>> +static int rk_tsadcv2_get_temp(int chn, void __iomem *regs, long *temp)
>>> +{
>>> +	u32 val;
>>> +
>>> +	/* the A/D value of the channel last conversion need some time */
>>> +	val = readl_relaxed(regs + TSADCV2_DATA(chn));
>>> +	if (val == 0)
>>> +		return -EAGAIN;
>>> +
>>> +	*temp = rk_tsadcv2_code_to_temp(val);
>>> +
>>> +	return 0;
>>> +}
>>> +
>>> +static void rk_tsadcv2_alarm_temp(int chn, void __iomem *regs, long temp)
>>> +{
>>> +	u32 alarm_value, int_en;
>>> +
>>> +	alarm_value = rk_tsadcv2_temp_to_code(temp);
>>> +	writel_relaxed(alarm_value & TSADCV2_DATA_MASK,
>>> +		       regs + TSADCV2_COMP_INT(chn));
>>> +
>>> +	int_en = readl_relaxed(regs + TSADCV2_INT_EN);
>>> +	int_en |= TSADCV2_INT_SRC_EN(chn);
>>> +	writel_relaxed(int_en, regs + TSADCV2_INT_EN);
>>> +}
>>> +
>>> +static void rk_tsadcv2_tshut_temp(int chn, void __iomem *regs, long temp)
>>> +{
>>> +	u32 tshut_value;
>>> +
>>> +	tshut_value = rk_tsadcv2_temp_to_code(temp);
>>> +	writel_relaxed(tshut_value, regs + TSADCV2_COMP_SHUT(chn));
>>> +}
>>> +
>>> +static void rk_tsadcv2_tshut_mode(int chn, void __iomem *regs,
>>> +				  enum tshut_mode mode)
>>> +{
>>> +	u32 val;
>>> +
>>> +	val = readl_relaxed(regs + TSADCV2_INT_EN);
>>> +	if (mode == TSHUT_MODE_GPIO) {
>>> +		val &= ~TSADCV2_SHUT_2CRU_SRC_EN(chn);
>>> +		val |= TSADCV2_SHUT_2GPIO_SRC_EN(chn);
>>> +	} else {
>>> +		val &= ~TSADCV2_SHUT_2GPIO_SRC_EN(chn);
>>> +		val |= TSADCV2_SHUT_2CRU_SRC_EN(chn);
>>> +	}
>>> +
>>> +	writel_relaxed(val, regs + TSADCV2_INT_EN);
>>> +}
>>> +
>>> +static void rk_tsadcv2_control(int chn, void __iomem *regs, bool enable)
>>> +{
>>> +	u32 val;
>>> +
>>> +	val = readl_relaxed(regs + TSADCV2_AUTO_CON);
>>> +	if (enable)
>>> +		val |= TSADCV2_AUTO_EN | TSADCV2_AUTO_SRC_EN(chn);
>> If I read the spec correctly this TSADCV2_AUTO_SRC_EN controls TSHUT
>> functionality, not measurements, right? If so you need to toggle these
>> bits in rk_tsadcv2_tshut_temp, and set TSADCV2_AUTO_EN separately.
>>
>>> +	else
>>> +		val &= ~TSADCV2_AUTO_EN;
>>> +
>>> +	writel_relaxed(val, regs + TSADCV2_AUTO_CON);
>>> +}
>>> +
>>> +static const struct rockchip_tsadc_chip rk3288_tsadc_data = {
>>> +	.tshut_mode = TSHUT_MODE_GPIO, /* default TSHUT via GPIO give PMIC */
>>> +	.tshut_polarity = TSHUT_LOW_ACTIVE, /* default TSHUT LOW ACTIVE */
>>> +	.hw_shut_temp = 120000,
>>> +
>>> +	.initialize = rk_tsadcv2_initialize,
>>> +	.irq_ack = rk_tsadcv2_irq_ack,
>>> +	.get_temp = rk_tsadcv2_get_temp,
>>> +	.set_alarm_temp = rk_tsadcv2_alarm_temp,
>>> +	.set_tshut_temp = rk_tsadcv2_tshut_temp,
>>> +	.set_tshut_mode = rk_tsadcv2_tshut_mode,
>>> +	.control = rk_tsadcv2_control,
>>> +};
>>> +
>>> +static const struct of_device_id of_rockchip_thermal_match[] = {
>>> +	{
>>> +		.compatible = "rockchip,rk3288-tsadc",
>>> +		.data = (void *)&rk3288_tsadc_data,
>>> +	},
>>> +	{ /* end */ },
>>> +};
>>> +MODULE_DEVICE_TABLE(of, of_rockchip_thermal_match);
>>> +
>>> +static void
>>> +rockchip_thermal_toggle_sensor(struct rockchip_thermal_sensor *sensor, bool on)
>>> +{
>>> +	struct thermal_zone_device *tzd = sensor->tzd;
>>> +
>>> +	tzd->ops->set_mode(tzd,
>>> +		on ? THERMAL_DEVICE_ENABLED : THERMAL_DEVICE_DISABLED);
>>> +}
>>> +
>>> +static irqreturn_t rockchip_thermal_alarm_irq_thread(int irq, void *dev)
>>> +{
>>> +	struct rockchip_thermal_data *thermal = dev;
>>> +	int i;
>>> +
>>> +	dev_dbg(&thermal->pdev->dev, "thermal alarm\n");
>>> +
>>> +	thermal->chip->irq_ack(thermal->regs);
>>> +
>>> +	for (i = 0; i < ARRAY_SIZE(thermal->sensors); i++)
>>> +		thermal_zone_device_update(thermal->sensors[i].tzd);
>>> +
>>> +	return IRQ_HANDLED;
>>> +}
>>> +
>>> +static int rockchip_thermal_set_trips(void *_sensor, long low, long high)
>>> +{
>>> +	struct rockchip_thermal_sensor *sensor = _sensor;
>>> +	struct rockchip_thermal_data *thermal = sensor->thermal;
>>> +	const struct rockchip_tsadc_chip *tsadc = thermal->chip;
>>> +
>>> +	dev_dbg(&thermal->pdev->dev, "%s: sensor %d: low: %ld, high %ld\n",
>>> +		__func__, sensor->id, low, high);
>>> +
>>> +	tsadc->set_alarm_temp(sensor->id, thermal->regs, high-5000);
> Forgot to mention - why do we reduce alarm temperature down 5 C from the
> trip point? I think we sample often enough to set the trigger exactly at
> trip point.

Fixed.

> Thanks.
>

-- 
Best regards,
Caesar


