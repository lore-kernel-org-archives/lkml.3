Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758520AbaGDMxE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jul 2014 08:53:04 -0400
Received: from bhuna.collabora.co.uk ([93.93.135.160]:38341 "EHLO
	bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758135AbaGDMxA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jul 2014 08:53:00 -0400
Message-ID: <53B6A3A3.9090300@collabora.co.uk>
Date: Fri, 04 Jul 2014 14:52:51 +0200
From: Javier Martinez Canillas <javier.martinez@collabora.co.uk>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Icedove/24.5.0
MIME-Version: 1.0
To: Krzysztof Kozlowski <k.kozlowski@samsung.com>
CC: Lee Jones <lee.jones@linaro.org>, Mark Brown <broonie@kernel.org>,
        Mike Turquette <mturquette@linaro.org>,
        Liam Girdwood <lgirdwood@gmail.com>,
        Alessandro Zummo <a.zummo@towertech.it>,
        Kukjin Kim <kgene.kim@samsung.com>,
        Doug Anderson <dianders@chromium.org>, Olof Johansson <olof@lixom.net>,
        Tomeu Vizoso <tomeu.vizoso@collabora.com>,
        Yadwinder Singh Brar <yadi.brar01@gmail.com>,
        Tushar Behera <trblinux@gmail.com>, Andreas Farber <afaerber@suse.de>,
        linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org,
        linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v6 22/23] rtc: Add driver for Maxim 77802 PMIC Real-Time-Clock
References: <1404467722-26687-1-git-send-email-javier.martinez@collabora.co.uk> <1404467722-26687-23-git-send-email-javier.martinez@collabora.co.uk> <1404474972.14069.20.camel@AMDC1943>
In-Reply-To: <1404474972.14069.20.camel@AMDC1943>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Krzysztof,

Thanks a lot for your feedback.

On 07/04/2014 01:56 PM, Krzysztof Kozlowski wrote:
> On pią, 2014-07-04 at 11:55 +0200, Javier Martinez Canillas wrote:
>> The MAX7802 PMIC has a Real-Time-Clock (RTC) with two alarms.
>> This patch adds support for the RTC and is based on a driver
>> added by Simon Glass to the Chrome OS kernel 3.8 tree.
>> 
>> Signed-off-by: Javier Martinez Canillas <javier.martinez@collabora.co.uk>
>> ---
>> 
>> Changes since v5: None
>> 
>> Changes since v4: None
>> 
>> Changes since v3: None
>> ---
>>  drivers/rtc/Kconfig        |  10 +
>>  drivers/rtc/Makefile       |   1 +
>>  drivers/rtc/rtc-max77802.c | 637 +++++++++++++++++++++++++++++++++++++++++++++
>>  3 files changed, 648 insertions(+)
>>  create mode 100644 drivers/rtc/rtc-max77802.c
>> 
>> diff --git a/drivers/rtc/Kconfig b/drivers/rtc/Kconfig
>> index a672dd1..243ac72 100644
>> --- a/drivers/rtc/Kconfig
>> +++ b/drivers/rtc/Kconfig
>> @@ -288,6 +288,16 @@ config RTC_DRV_MAX77686
>>  	  This driver can also be built as a module. If so, the module
>>  	  will be called rtc-max77686.
>>  
>> +config RTC_DRV_MAX77802
>> +	tristate "Maxim 77802 RTC"
>> +	depends on MFD_MAX77686
>> +	help
>> +	  If you say yes here you will get support for the
>> +	  RTC of Maxim MAX77802 PMIC.
>> +
>> +	  This driver can also be built as a module. If so, the module
>> +	  will be called rtc-max77802.
>> +
>>  config RTC_DRV_RS5C372
>>  	tristate "Ricoh R2025S/D, RS5C372A/B, RV5C386, RV5C387A"
>>  	help
>> diff --git a/drivers/rtc/Makefile b/drivers/rtc/Makefile
>> index 70347d0..247de78 100644
>> --- a/drivers/rtc/Makefile
>> +++ b/drivers/rtc/Makefile
>> @@ -81,6 +81,7 @@ obj-$(CONFIG_RTC_DRV_MAX8998)	+= rtc-max8998.o
>>  obj-$(CONFIG_RTC_DRV_MAX8997)	+= rtc-max8997.o
>>  obj-$(CONFIG_RTC_DRV_MAX6902)	+= rtc-max6902.o
>>  obj-$(CONFIG_RTC_DRV_MAX77686)	+= rtc-max77686.o
>> +obj-$(CONFIG_RTC_DRV_MAX77802)  += rtc-max77802.o
>>  obj-$(CONFIG_RTC_DRV_MC13XXX)	+= rtc-mc13xxx.o
>>  obj-$(CONFIG_RTC_DRV_MCP795)	+= rtc-mcp795.o
>>  obj-$(CONFIG_RTC_DRV_MSM6242)	+= rtc-msm6242.o
>> diff --git a/drivers/rtc/rtc-max77802.c b/drivers/rtc/rtc-max77802.c
>> new file mode 100644
>> index 0000000..2f4fc2e
>> --- /dev/null
>> +++ b/drivers/rtc/rtc-max77802.c
>> @@ -0,0 +1,637 @@
>> +/*
>> + * RTC driver for Maxim MAX77802
>> + *
>> + * Copyright (C) 2013 Google, Inc
>> + *
>> + * Copyright (C) 2012 Samsung Electronics Co.Ltd
>> + *
>> + *  based on rtc-max8997.c
>> + *
>> + *  This program is free software; you can redistribute  it and/or modify it
>> + *  under  the terms of  the GNU General  Public License as published by the
>> + *  Free Software Foundation;  either version 2 of the  License, or (at your
>> + *  option) any later version.
>> + *
>> + */
>> +
>> +#include <linux/slab.h>
>> +#include <linux/rtc.h>
>> +#include <linux/delay.h>
>> +#include <linux/mutex.h>
>> +#include <linux/module.h>
>> +#include <linux/platform_device.h>
>> +#include <linux/mfd/max77686-private.h>
>> +#include <linux/irqdomain.h>
>> +#include <linux/regmap.h>
>> +
>> +/* RTC Control Register */
>> +#define BCD_EN_SHIFT			0
>> +#define BCD_EN_MASK			(1 << BCD_EN_SHIFT)
>> +#define MODEL24_SHIFT			1
>> +#define MODEL24_MASK			(1 << MODEL24_SHIFT)
>> +/* RTC Update Register1 */
>> +#define RTC_UDR_SHIFT			0
>> +#define RTC_UDR_MASK			(1 << RTC_UDR_SHIFT)
>> +#define RTC_RBUDR_SHIFT			4
>> +#define RTC_RBUDR_MASK			(1 << RTC_RBUDR_SHIFT)
>> +/* WTSR and SMPL Register */
>> +#define WTSRT_SHIFT			0
>> +#define SMPLT_SHIFT			2
>> +#define WTSR_EN_SHIFT			6
>> +#define SMPL_EN_SHIFT			7
>> +#define WTSRT_MASK			(3 << WTSRT_SHIFT)
>> +#define SMPLT_MASK			(3 << SMPLT_SHIFT)
>> +#define WTSR_EN_MASK			(1 << WTSR_EN_SHIFT)
>> +#define SMPL_EN_MASK			(1 << SMPL_EN_SHIFT)
>> +/* RTC Hour register */
>> +#define HOUR_PM_SHIFT			6
>> +#define HOUR_PM_MASK			(1 << HOUR_PM_SHIFT)
>> +/* RTC Alarm Enable */
>> +#define ALARM_ENABLE_SHIFT		7
>> +#define ALARM_ENABLE_MASK		(1 << ALARM_ENABLE_SHIFT)
>> +
>> +/* For the RTCAE1 register, we write this value to enable the alarm */
>> +#define ALARM_ENABLE_VALUE		0x77
>> +
>> +#define MAX77802_RTC_UPDATE_DELAY_US	200
>> +#undef MAX77802_RTC_WTSR_SMPL
> 
> Hmmm... I am not sure what is the purpose of this undef. It disables
> some functions below. I saw same code in 77686 RTC driver but this does
> not help me :).
> 
> If this is on purpose can you add a comment explaining the
> purpose/cause?
> 

This is a left over from when a combined 77686/802 driver was attempted since as
you said the 77686 RTC driver does the same.

I just checked MAX77802 data sheet and the MAX77802_RTC_WTSR_SMPL register is to
control the SMPL (Sudden Momentary Power Loss) and WTSR (Watchdog Timeout and
Software Resets) features.

Now, I wanted to figure out why the 77686 driver unset that register and have
those conditionals but git blame shows me that this was already in the original
commit that added the driver: fca1dd03 ("rtc: max77686: add Maxim 77686 driver").

Also, I see that the MAX8997 driver (drivers/rtc/rtc-max8997.c) also has a
similar register but actually uses it and doesn't have the conditionals if is
disabled. But this driver has two module parameters to control if these features
are enabled or not (wtsr_en and smpl_en).

If these two features have been disabled since the max77686 driver was merged
then I guess that the dead code should be removed from that driver as well? Or
do you have more hints about why it has been disabled?

>> +
>> +enum {
>> +	RTC_SEC = 0,
>> +	RTC_MIN,
>> +	RTC_HOUR,
>> +	RTC_WEEKDAY,
>> +	RTC_MONTH,
>> +	RTC_YEAR,
>> +	RTC_DATE,
>> +	RTC_NR_TIME
>> +};
>> +
>> +struct max77802_rtc_info {
>> +	struct device		*dev;
>> +	struct max77686_dev	*max77802;
>> +	struct i2c_client	*rtc;
>> +	struct rtc_device	*rtc_dev;
>> +	struct mutex		lock;
>> +
>> +	struct regmap		*regmap;
>> +
>> +	int virq;
>> +	int rtc_24hr_mode;
>> +};
>> +
>> +enum MAX77802_RTC_OP {
>> +	MAX77802_RTC_WRITE,
>> +	MAX77802_RTC_READ,
>> +};
>> +
>> +static inline int max77802_rtc_calculate_wday(u8 shifted)
>> +{
>> +	int counter = -1;
>> +
>> +	while (shifted) {
>> +		shifted >>= 1;
>> +		counter++;
>> +	}
>> +
>> +	return counter;
>> +}
>> +
>> +static void max77802_rtc_data_to_tm(u8 *data, struct rtc_time *tm,
>> +				   int rtc_24hr_mode)
>> +{
>> +	tm->tm_sec = data[RTC_SEC] & 0xff;
>> +	tm->tm_min = data[RTC_MIN] & 0xff;
>> +	if (rtc_24hr_mode)
>> +		tm->tm_hour = data[RTC_HOUR] & 0x1f;
>> +	else {
>> +		tm->tm_hour = data[RTC_HOUR] & 0x0f;
>> +		if (data[RTC_HOUR] & HOUR_PM_MASK)
>> +			tm->tm_hour += 12;
>> +	}
>> +
>> +	tm->tm_wday = max77802_rtc_calculate_wday(data[RTC_WEEKDAY] & 0xff);
>> +	tm->tm_mday = data[RTC_DATE] & 0x1f;
>> +	tm->tm_mon = (data[RTC_MONTH] & 0x0f) - 1;
>> +
>> +	tm->tm_year = data[RTC_YEAR] & 0xff;
>> +	tm->tm_yday = 0;
>> +	tm->tm_isdst = 0;
>> +}
>> +
>> +static int max77802_rtc_tm_to_data(struct rtc_time *tm, u8 *data)
>> +{
>> +	data[RTC_SEC] = tm->tm_sec;
>> +	data[RTC_MIN] = tm->tm_min;
>> +	data[RTC_HOUR] = tm->tm_hour;
>> +	data[RTC_WEEKDAY] = 1 << tm->tm_wday;
>> +	data[RTC_DATE] = tm->tm_mday;
>> +	data[RTC_MONTH] = tm->tm_mon + 1;
>> +	data[RTC_YEAR] = tm->tm_year;
>> +
>> +	return 0;
>> +}
>> +
>> +static int max77802_rtc_update(struct max77802_rtc_info *info,
>> +	enum MAX77802_RTC_OP op)
>> +{
>> +	int ret;
>> +	unsigned int data;
>> +
>> +	if (op == MAX77802_RTC_WRITE)
>> +		data = 1 << RTC_UDR_SHIFT;
>> +	else
>> +		data = 1 << RTC_RBUDR_SHIFT;
>> +
>> +	ret = regmap_update_bits(info->max77802->regmap,
>> +				 MAX77802_RTC_UPDATE0, data, data);
>> +	if (ret < 0)
>> +		dev_err(info->dev, "%s: fail to write update reg(ret=%d, data=0x%x)\n",
>> +				__func__, ret, data);
>> +	else {
>> +		/* Minimum delay required before RTC update. */
>> +		usleep_range(MAX77802_RTC_UPDATE_DELAY_US,
>> +			     MAX77802_RTC_UPDATE_DELAY_US * 2);
>> +	}
>> +
>> +	return ret;
>> +}
>> +
>> +static int max77802_rtc_read_time(struct device *dev, struct rtc_time *tm)
>> +{
>> +	struct max77802_rtc_info *info = dev_get_drvdata(dev);
>> +	u8 data[RTC_NR_TIME];
>> +	int ret;
>> +
>> +	mutex_lock(&info->lock);
>> +
>> +	ret = max77802_rtc_update(info, MAX77802_RTC_READ);
>> +	if (ret < 0)
>> +		goto out;
>> +
>> +	ret = regmap_bulk_read(info->max77802->regmap,
>> +				MAX77802_RTC_SEC, data, RTC_NR_TIME);
>> +	if (ret < 0) {
>> +		dev_err(info->dev, "%s: fail to read time reg(%d)\n", __func__,
>> +			ret);
>> +		goto out;
>> +	}
>> +
>> +	max77802_rtc_data_to_tm(data, tm, info->rtc_24hr_mode);
>> +
>> +	ret = rtc_valid_tm(tm);
>> +
>> +out:
>> +	mutex_unlock(&info->lock);
>> +	return ret;
>> +}
>> +
>> +static int max77802_rtc_set_time(struct device *dev, struct rtc_time *tm)
>> +{
>> +	struct max77802_rtc_info *info = dev_get_drvdata(dev);
>> +	u8 data[RTC_NR_TIME];
>> +	int ret;
>> +
>> +	ret = max77802_rtc_tm_to_data(tm, data);
>> +	if (ret < 0)
>> +		return ret;
>> +
>> +	mutex_lock(&info->lock);
>> +
>> +	ret = regmap_bulk_write(info->max77802->regmap,
>> +				 MAX77802_RTC_SEC, data, RTC_NR_TIME);
>> +	if (ret < 0) {
>> +		dev_err(info->dev, "%s: fail to write time reg(%d)\n", __func__,
>> +			ret);
>> +		goto out;
>> +	}
>> +
>> +	ret = max77802_rtc_update(info, MAX77802_RTC_WRITE);
>> +
>> +out:
>> +	mutex_unlock(&info->lock);
>> +	return ret;
>> +}
>> +
>> +static int max77802_rtc_read_alarm(struct device *dev, struct rtc_wkalrm *alrm)
>> +{
>> +	struct max77802_rtc_info *info = dev_get_drvdata(dev);
>> +	u8 data[RTC_NR_TIME];
>> +	unsigned int val;
>> +	int ret;
>> +
>> +	mutex_lock(&info->lock);
>> +
>> +	ret = max77802_rtc_update(info, MAX77802_RTC_READ);
>> +	if (ret < 0)
>> +		goto out;
>> +
>> +	ret = regmap_bulk_read(info->max77802->regmap,
>> +				 MAX77802_ALARM1_SEC, data, RTC_NR_TIME);
>> +	if (ret < 0) {
>> +		dev_err(info->dev, "%s:%d fail to read alarm reg(%d)\n",
>> +				__func__, __LINE__, ret);
>> +		goto out;
>> +	}
>> +
>> +	max77802_rtc_data_to_tm(data, &alrm->time, info->rtc_24hr_mode);
>> +
>> +	alrm->enabled = 0;
>> +	ret = regmap_read(info->max77802->regmap,
>> +			  MAX77802_RTC_AE1, &val);
>> +	if (ret < 0) {
>> +		dev_err(info->dev, "%s:%d fail to read alarm enable(%d)\n",
>> +			__func__, __LINE__, ret);
>> +		goto out;
>> +	}
>> +	if (val)
>> +		alrm->enabled = 1;
>> +
>> +	alrm->pending = 0;
>> +	ret = regmap_read(info->max77802->regmap, MAX77802_REG_STATUS2, &val);
>> +	if (ret < 0) {
>> +		dev_err(info->dev, "%s:%d fail to read status2 reg(%d)\n",
>> +				__func__, __LINE__, ret);
>> +		goto out;
>> +	}
>> +
>> +	if (val & (1 << 2)) /* RTCA1 */
>> +		alrm->pending = 1;
>> +
>> +out:
>> +	mutex_unlock(&info->lock);
>> +	return 0;
>> +}
>> +
>> +static int max77802_rtc_stop_alarm(struct max77802_rtc_info *info)
>> +{
>> +	int ret;
>> +
>> +	if (!mutex_is_locked(&info->lock))
>> +		dev_warn(info->dev, "%s: should have mutex locked\n", __func__);
>> +
>> +	ret = max77802_rtc_update(info, MAX77802_RTC_READ);
>> +	if (ret < 0)
>> +		goto out;
>> +
>> +	ret = regmap_write(info->max77802->regmap,
>> +			   MAX77802_RTC_AE1, 0);
>> +	if (ret < 0) {
>> +		dev_err(info->dev, "%s: fail to write alarm reg(%d)\n",
>> +			__func__, ret);
>> +		goto out;
>> +	}
>> +
>> +	ret = max77802_rtc_update(info, MAX77802_RTC_WRITE);
>> +out:
>> +	return ret;
>> +}
>> +
>> +static int max77802_rtc_start_alarm(struct max77802_rtc_info *info)
>> +{
>> +	int ret;
>> +
>> +	if (!mutex_is_locked(&info->lock))
>> +		dev_warn(info->dev, "%s: should have mutex locked\n",
>> +			 __func__);
>> +
>> +	ret = max77802_rtc_update(info, MAX77802_RTC_READ);
>> +	if (ret < 0)
>> +		goto out;
>> +
>> +	ret = regmap_write(info->max77802->regmap,
>> +				   MAX77802_RTC_AE1,
>> +				   ALARM_ENABLE_VALUE);
>> +
>> +	if (ret < 0) {
>> +		dev_err(info->dev, "%s: fail to read alarm reg(%d)\n",
>> +				__func__, ret);
>> +		goto out;
>> +	}
>> +
>> +	ret = max77802_rtc_update(info, MAX77802_RTC_WRITE);
>> +out:
>> +	return ret;
>> +}
>> +
>> +static int max77802_rtc_set_alarm(struct device *dev, struct rtc_wkalrm *alrm)
>> +{
>> +	struct max77802_rtc_info *info = dev_get_drvdata(dev);
>> +	u8 data[RTC_NR_TIME];
>> +	int ret;
>> +
>> +	ret = max77802_rtc_tm_to_data(&alrm->time, data);
>> +	if (ret < 0)
>> +		return ret;
>> +
>> +	mutex_lock(&info->lock);
>> +
>> +	ret = max77802_rtc_stop_alarm(info);
>> +	if (ret < 0)
>> +		goto out;
>> +
>> +	ret = regmap_bulk_write(info->max77802->regmap,
>> +				 MAX77802_ALARM1_SEC, data, RTC_NR_TIME);
>> +
>> +	if (ret < 0) {
>> +		dev_err(info->dev, "%s: fail to write alarm reg(%d)\n",
>> +				__func__, ret);
>> +		goto out;
>> +	}
>> +
>> +	ret = max77802_rtc_update(info, MAX77802_RTC_WRITE);
>> +	if (ret < 0)
>> +		goto out;
>> +
>> +	if (alrm->enabled)
>> +		ret = max77802_rtc_start_alarm(info);
>> +out:
>> +	mutex_unlock(&info->lock);
>> +	return ret;
>> +}
>> +
>> +static int max77802_rtc_alarm_irq_enable(struct device *dev,
>> +					 unsigned int enabled)
>> +{
>> +	struct max77802_rtc_info *info = dev_get_drvdata(dev);
>> +	int ret;
>> +
>> +	mutex_lock(&info->lock);
>> +	if (enabled)
>> +		ret = max77802_rtc_start_alarm(info);
>> +	else
>> +		ret = max77802_rtc_stop_alarm(info);
>> +	mutex_unlock(&info->lock);
>> +
>> +	return ret;
>> +}
>> +
>> +static irqreturn_t max77802_rtc_alarm_irq(int irq, void *data)
>> +{
>> +	struct max77802_rtc_info *info = data;
>> +
>> +	dev_info(info->dev, "%s:irq(%d)\n", __func__, irq);
> 
> Doesn't seem so important message to user so use dev_dbg.
> 

Ok

>> +
>> +	rtc_update_irq(info->rtc_dev, 1, RTC_IRQF | RTC_AF);
>> +
>> +	return IRQ_HANDLED;
>> +}
>> +
>> +static const struct rtc_class_ops max77802_rtc_ops = {
>> +	.read_time = max77802_rtc_read_time,
>> +	.set_time = max77802_rtc_set_time,
>> +	.read_alarm = max77802_rtc_read_alarm,
>> +	.set_alarm = max77802_rtc_set_alarm,
>> +	.alarm_irq_enable = max77802_rtc_alarm_irq_enable,
>> +};
>> +
>> +#ifdef MAX77802_RTC_WTSR_SMPL
>> +static void max77802_rtc_enable_wtsr(struct max77802_rtc_info *info, bool enable)
>> +{
>> +	int ret;
>> +	unsigned int val, mask;
>> +
>> +	if (enable)
>> +		val = (1 << WTSR_EN_SHIFT) | (3 << WTSRT_SHIFT);
>> +	else
>> +		val = 0;
>> +
>> +	mask = WTSR_EN_MASK | WTSRT_MASK;
>> +
>> +	dev_info(info->dev, "%s: %s WTSR\n", __func__,
>> +			enable ? "enable" : "disable");
> 
> Doesn't seem so important message to user so use dev_dbg.
> 

Ok, this function is going to probably be removed on the next version anyways.

>> +
>> +	ret = regmap_update_bits(info->max77802->regmap,
>> +				 MAX77802_WTSR_SMPL_CNTL, mask, val);
>> +	if (ret < 0) {
>> +		dev_err(info->dev, "%s: fail to update WTSR reg(%d)\n",
>> +				__func__, ret);
>> +		return;
>> +	}
>> +
>> +	max77802_rtc_update(info, MAX77802_RTC_WRITE);
>> +}
>> +
>> +static void max77802_rtc_enable_smpl(struct max77802_rtc_info *info, bool enable)
>> +{
>> +	int ret;
>> +	unsigned int val, mask;
>> +
>> +	if (enable)
>> +		val = (1 << SMPL_EN_SHIFT) | (0 << SMPLT_SHIFT);
>> +	else
>> +		val = 0;
>> +
>> +	mask = SMPL_EN_MASK | SMPLT_MASK;
>> +
>> +	dev_info(info->dev, "%s: %s SMPL\n", __func__,
>> +			enable ? "enable" : "disable");
> 
> Doesn't seem so important message to user so use dev_dbg.
> 

Same here.

>> +
>> +	ret = regmap_update_bits(info->max77802->regmap,
>> +				 MAX77802_WTSR_SMPL_CNTL, mask, val);
>> +	if (ret < 0) {
>> +		dev_err(info->dev, "%s: fail to update SMPL reg(%d)\n",
>> +				__func__, ret);
>> +		return;
>> +	}
>> +
>> +	max77802_rtc_update(info, MAX77802_RTC_WRITE);
>> +
>> +	val = 0;
>> +	regmap_read(info->max77802->regmap, MAX77802_WTSR_SMPL_CNTL, &val);
>> +	dev_info(info->dev, "%s: WTSR_SMPL(0x%02x)\n", __func__, val);
>> +}
>> +#endif /* MAX77802_RTC_WTSR_SMPL */
>> +
>> +static int max77802_rtc_init_reg(struct max77802_rtc_info *info)
>> +{
>> +	u8 data[2];
>> +	int ret;
>> +
>> +	max77802_rtc_update(info, MAX77802_RTC_READ);
>> +
>> +	/* Set RTC control register : Binary mode, 24hour mdoe */
>> +	data[0] = (1 << BCD_EN_SHIFT) | (1 << MODEL24_SHIFT);
>> +	data[1] = (0 << BCD_EN_SHIFT) | (1 << MODEL24_SHIFT);
>> +
>> +	info->rtc_24hr_mode = 1;
>> +
>> +	ret = regmap_bulk_write(info->max77802->regmap,
>> +				MAX77802_RTC_CONTROLM, data, 2);
> 
> Use ARRAY_SIZE as last param?
> 

Ok

>> +	if (ret < 0) {
>> +		dev_err(info->dev, "%s: fail to write controlm reg(%d)\n",
>> +				__func__, ret);
>> +		return ret;
>> +	}
>> +
>> +	ret = max77802_rtc_update(info, MAX77802_RTC_WRITE);
>> +
>> +	/* Mask control register */
>> +	max77802_rtc_update(info, MAX77802_RTC_READ);
>> +
>> +	ret = regmap_update_bits(info->max77802->regmap,
>> +				 MAX77802_RTC_CONTROLM, 0x0, 0x3);
> 
> Can you define/comment the magic number '0x3' (and probably 0x0)?
> 
> Anyway I'm confused here. If I'm correct few lines above you wrote the
> same to the MAX77802_RTC_CONTROLM register. Why doing this again?
> 

Right, the second update is not needed indeed so I'll remove it on the next version.

>> +	if (ret < 0) {
>> +		dev_err(info->dev, "%s: fail to mask CONTROLM reg(%d)\n",
>> +				__func__, ret);
>> +		return ret;
>> +	}
>> +
>> +	ret = max77802_rtc_update(info, MAX77802_RTC_WRITE);
>> +
>> +	return ret;
>> +}
>> +
>> +static int max77802_rtc_probe(struct platform_device *pdev)
>> +{
>> +	struct max77686_dev *max77802 = dev_get_drvdata(pdev->dev.parent);
>> +	struct max77802_rtc_info *info;
>> +	int ret;
>> +
>> +	dev_info(&pdev->dev, "%s\n", __func__);
>> +
>> +	info = devm_kzalloc(&pdev->dev, sizeof(struct max77802_rtc_info),
>> +			    GFP_KERNEL);
>> +	if (!info)
>> +		return -ENOMEM;
>> +
>> +	mutex_init(&info->lock);
>> +	info->dev = &pdev->dev;
>> +	info->max77802 = max77802;
>> +	info->rtc = max77802->i2c;
>> +
>> +	platform_set_drvdata(pdev, info);
>> +
>> +	ret = max77802_rtc_init_reg(info);
>> +
>> +	if (ret < 0) {
>> +		dev_err(&pdev->dev, "Failed to initialize RTC reg:%d\n", ret);
>> +		return ret;
>> +	}
>> +
>> +#ifdef MAX77802_RTC_WTSR_SMPL
>> +	max77802_rtc_enable_wtsr(info, true);
>> +	max77802_rtc_enable_smpl(info, true);
>> +#endif
>> +
>> +	device_init_wakeup(&pdev->dev, 1);
>> +
>> +	info->rtc_dev = devm_rtc_device_register(&pdev->dev, "max77802-rtc",
>> +						 &max77802_rtc_ops, THIS_MODULE);
>> +
>> +	if (IS_ERR(info->rtc_dev)) {
>> +		dev_info(&pdev->dev, "%s: fail\n", __func__);
>> +
>> +		ret = PTR_ERR(info->rtc_dev);
>> +		dev_err(&pdev->dev, "Failed to register RTC device: %d\n", ret);
>> +		if (ret == 0)
>> +			ret = -EINVAL;
>> +		return ret;
>> +	}
>> +	info->virq = regmap_irq_get_virq(max77802->rtc_irq_data,
>> +					 MAX77686_RTCIRQ_RTCA1);
>> +
>> +	if (info->virq <= 0) {
>> +		dev_err(&pdev->dev, "Failed to get virtual IRQ %d\n",
>> +			MAX77686_RTCIRQ_RTCA1);
>> +		ret = -EINVAL;
>> +		return ret;
>> +	}
>> +
>> +	ret = devm_request_threaded_irq(&pdev->dev, info->virq, NULL,
>> +					max77802_rtc_alarm_irq, 0, "rtc-alarm1",
>> +					info);
>> +	if (ret < 0)
>> +		dev_err(&pdev->dev, "Failed to request alarm IRQ: %d: %d\n",
>> +			info->virq, ret);
>> +
>> +	return ret;
>> +}
>> +
>> +static int max77802_rtc_remove(struct platform_device *pdev)
>> +{
>> +	struct max77802_rtc_info *info = platform_get_drvdata(pdev);
>> +
>> +	free_irq(info->virq, info);
>> +	rtc_device_unregister(info->rtc_dev);
> 
> Both are allocated with devm() code so this will lead to double free and
> unregister.
> 

You are right, in fact the whole .remove function handler can go away in that
case. I'll do in the next version as well.

> Best regards,
> Krzysztof

Best regards,
Javier
