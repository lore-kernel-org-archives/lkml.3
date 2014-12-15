Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751388AbaLOM26 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Dec 2014 07:28:58 -0500
Received: from mx07-00178001.pphosted.com ([62.209.51.94]:52986 "EHLO
	mx07-00178001.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750747AbaLOM25 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Dec 2014 07:28:57 -0500
Message-ID: <548ED3D6.5070707@st.com>
Date: Mon, 15 Dec 2014 13:28:06 +0100
From: David Paris <david.paris@st.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Lee Jones <lee.jones@linaro.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>
Cc: <a.zummo@towertech.it>, <kernel@stlinux.com>, <rtc-linux@googlegroups.com>,
        <devicetree@vger.kernel.org>, <wim@iguana.be>,
        <linux-watchdog@vger.kernel.org>
Subject: Re: [STLinux Kernel] [PATCH 7/8] rtc: st: add new driver for ST's
 LPC RTC
References: <1418642738-17407-1-git-send-email-lee.jones@linaro.org> <1418642738-17407-8-git-send-email-lee.jones@linaro.org>
In-Reply-To: <1418642738-17407-8-git-send-email-lee.jones@linaro.org>
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.201.23.83]
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.13.68,1.0.33,0.0.0000
 definitions=2014-12-15_01:2014-12-15,2014-12-14,1970-01-01 signatures=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Lee,

     See my comment below.
     David

On 12/15/2014 12:25 PM, Lee Jones wrote:
> ST's Low Power Controller (LPC) controls two devices; watchdog and RTC.
> Only one of the devices can be used at any one time.  This is enforced
> by the correlating MFD driver.  This portion of the driver-set controls
> the Real Time Clock.
>
> Signed-off-by: Lee Jones <lee.jones@linaro.org>
> ---
>   drivers/rtc/Kconfig      |  13 ++
>   drivers/rtc/Makefile     |   1 +
>   drivers/rtc/rtc-st-lpc.c | 330 +++++++++++++++++++++++++++++++++++++++++++++++
>   3 files changed, 344 insertions(+)
>   create mode 100644 drivers/rtc/rtc-st-lpc.c
>
> diff --git a/drivers/rtc/Kconfig b/drivers/rtc/Kconfig
> index a168e96..aa4bd90 100644
> --- a/drivers/rtc/Kconfig
> +++ b/drivers/rtc/Kconfig
> @@ -1355,6 +1355,18 @@ config RTC_DRV_SIRFSOC
>   	  Say "yes" here to support the real time clock on SiRF SOC chips.
>   	  This driver can also be built as a module called rtc-sirfsoc.
>   
> +config RTC_DRV_ST_LPC
> +	tristate "STMicroelectronics LPC RTC"
> +	depends on ARCH_STI
> +	depends on OF
> +	select MFD_ST_LPC
> +	help
> +	  Say Y here to include STMicroelectronics Low Power Controller
> +	  (LPC) based RTC support.
> +
> +	  To compile this driver as a module, choose M here: the
> +	  module will be called rtc-st-lpc.
> +
>   config RTC_DRV_MOXART
>   	tristate "MOXA ART RTC"
>   	depends on ARCH_MOXART || COMPILE_TEST
> @@ -1390,4 +1402,5 @@ config RTC_DRV_HID_SENSOR_TIME
>   	  rtc-hid-sensor-time.
>   
>   
> +
>   endif # RTC_CLASS
> diff --git a/drivers/rtc/Makefile b/drivers/rtc/Makefile
> index 56f061c..ce5860b 100644
> --- a/drivers/rtc/Makefile
> +++ b/drivers/rtc/Makefile
> @@ -145,4 +145,5 @@ obj-$(CONFIG_RTC_DRV_WM8350)	+= rtc-wm8350.o
>   obj-$(CONFIG_RTC_DRV_X1205)	+= rtc-x1205.o
>   obj-$(CONFIG_RTC_DRV_XGENE)	+= rtc-xgene.o
>   obj-$(CONFIG_RTC_DRV_SIRFSOC)	+= rtc-sirfsoc.o
> +obj-$(CONFIG_RTC_DRV_ST_LPC)	+= rtc-st-lpc.o
>   obj-$(CONFIG_RTC_DRV_MOXART)	+= rtc-moxart.o
> diff --git a/drivers/rtc/rtc-st-lpc.c b/drivers/rtc/rtc-st-lpc.c
> new file mode 100644
> index 0000000..60b1ab4
> --- /dev/null
> +++ b/drivers/rtc/rtc-st-lpc.c
> @@ -0,0 +1,330 @@
> +/*
> + * rtc-st-lpc.c - ST's LPC RTC, powered by the Low Power Timer
> + *
> + * Copyright (C) 2014 STMicroelectronics Limited
> + *
> + * Author: David Paris <david.paris@st.com> for STMicroelectronics
> + *         Lee Jones <lee.jones@linaro.org> for STMicroelectronics
> + *
> + * Based on the original driver written by Stuart Menefy.
> + *
> + * This program is free software; you can redistribute it and/or
> + * modify it under the terms of the GNU General Public Licence
> + * as published by the Free Software Foundation; either version
> + * 2 of the Licence, or (at your option) any later version.
> + */
> +
> +#include <linux/clk.h>
> +#include <linux/delay.h>
> +#include <linux/init.h>
> +#include <linux/io.h>
> +#include <linux/irq.h>
> +#include <linux/kernel.h>
> +#include <linux/module.h>
> +#include <linux/of.h>
> +#include <linux/of_irq.h>
> +#include <linux/platform_device.h>
> +#include <linux/rtc.h>
> +
> +/* Low Power Timer */
> +#define LPC_LPT_LSB_OFF		0x400
> +#define LPC_LPT_MSB_OFF		0x404
> +#define LPC_LPT_START_OFF	0x408
> +
> +/* Low Power Alarm */
> +#define LPC_LPA_LSB_OFF		0x410
> +#define LPC_LPA_MSB_OFF		0x414
> +#define LPC_LPA_START_OFF	0x418
> +
> +/* LPC as WDT */
> +#define LPC_WDT_OFF		0x510
> +#define LPC_WDT_FLAG_OFF	0x514
> +
> +struct st_rtc {
> +	struct rtc_device *rtc_dev;
> +	struct rtc_wkalrm alarm;
> +	struct resource *res;
> +	struct clk *clk;
> +	void __iomem *ioaddr;
> +	bool irq_enabled:1;
> +	spinlock_t lock;
> +	short irq;
> +};
> +
> +static void st_rtc_set_hw_alarm(struct st_rtc *rtc,
> +				unsigned long msb, unsigned long  lsb)
> +{
> +	unsigned long flags;
> +
> +	spin_lock_irqsave(&rtc->lock, flags);
> +
> +	writel(1, rtc->ioaddr + LPC_WDT_OFF);
> +
> +	writel(msb, rtc->ioaddr + LPC_LPA_MSB_OFF);
> +	writel(lsb, rtc->ioaddr + LPC_LPA_LSB_OFF);
> +	writel(1, rtc->ioaddr + LPC_LPA_START_OFF);
> +
> +	writel(0, rtc->ioaddr + LPC_WDT_OFF);
> +
> +	spin_unlock_irqrestore(&rtc->lock, flags);
> +}
> +
> +static irqreturn_t st_rtc_handler(int this_irq, void *data)
> +{
> +	struct st_rtc *rtc = (struct st_rtc *)data;
> +
> +	rtc_update_irq(rtc->rtc_dev, 1, RTC_AF);
> +
> +	return IRQ_HANDLED;
> +}
> +
> +static int st_rtc_read_time(struct device *dev, struct rtc_time *tm)
> +{
> +	struct st_rtc *rtc = dev_get_drvdata(dev);
> +	unsigned long lpt_lsb, lpt_msb;
> +	unsigned long long lpt;
> +	unsigned long flags;
> +
> +	spin_lock_irqsave(&rtc->lock, flags);
> +
> +	do {
> +		lpt_msb = readl(rtc->ioaddr + LPC_LPT_MSB_OFF);
> +		lpt_lsb = readl(rtc->ioaddr + LPC_LPT_LSB_OFF);
> +	} while (readl(rtc->ioaddr + LPC_LPT_MSB_OFF) != lpt_msb);
> +
> +	spin_unlock_irqrestore(&rtc->lock, flags);
> +
> +	lpt = ((unsigned long long)lpt_msb << 32) | lpt_lsb;
> +	do_div(lpt, clk_get_rate(rtc->clk));
> +	rtc_time_to_tm(lpt, tm);
> +
> +	return 0;
> +}
> +
> +static int st_rtc_set_time(struct device *dev, struct rtc_time *tm)
> +{
> +	struct st_rtc *rtc = dev_get_drvdata(dev);
> +	unsigned long long lpt;
> +	unsigned long secs, flags;
> +	int ret;
> +
> +	ret = rtc_tm_to_time(tm, &secs);
> +	if (ret)
> +		return ret;
> +
> +	lpt = (unsigned long long)secs * clk_get_rate(rtc->clk);
> +
> +	spin_lock_irqsave(&rtc->lock, flags);
> +
> +	writel(lpt >> 32, rtc->ioaddr + LPC_LPT_MSB_OFF);
> +	writel(lpt, rtc->ioaddr + LPC_LPT_LSB_OFF);
> +	writel(1, rtc->ioaddr + LPC_LPT_START_OFF);
> +
> +	spin_unlock_irqrestore(&rtc->lock, flags);
> +
> +	return 0;
> +}
> +
> +static int st_rtc_read_alarm(struct device *dev, struct rtc_wkalrm *wkalrm)
> +{
> +	struct st_rtc *rtc = dev_get_drvdata(dev);
> +	unsigned long flags;
> +
> +	spin_lock_irqsave(&rtc->lock, flags);
> +
> +	memcpy(wkalrm, &rtc->alarm, sizeof(struct rtc_wkalrm));
> +
> +	spin_unlock_irqrestore(&rtc->lock, flags);
> +
> +	return 0;
> +}
> +
> +static int st_rtc_alarm_irq_enable(struct device *dev, unsigned int enabled)
> +{
> +	struct st_rtc *rtc = dev_get_drvdata(dev);
> +
> +	if (enabled && !rtc->irq_enabled) {
> +		enable_irq(rtc->irq);
> +		rtc->irq_enabled = true;
> +	} else if (!enabled && rtc->irq_enabled) {
> +		disable_irq(rtc->irq);
> +		rtc->irq_enabled = false;
> +	}
> +
> +	return 0;
> +}
> +
> +static int st_rtc_set_alarm(struct device *dev, struct rtc_wkalrm *t)
> +{
> +	struct st_rtc *rtc = dev_get_drvdata(dev);
> +	struct rtc_time now;
> +	unsigned long now_secs;
> +	unsigned long alarm_secs;
> +	unsigned long long lpa;
> +
> +	st_rtc_read_time(dev, &now);
> +	rtc_tm_to_time(&now, &now_secs);
> +	rtc_tm_to_time(&t->time, &alarm_secs);
> +
> +	/* Invalid alarm time */
> +	if (now_secs > alarm_secs)
> +		return -EINVAL;
> +
> +	memcpy(&rtc->alarm, t, sizeof(struct rtc_wkalrm));
> +
> +	/* Now many secs to fire */
> +	alarm_secs -= now_secs;
> +	lpa = (unsigned long long)alarm_secs * clk_get_rate(rtc->clk);
> +
> +	st_rtc_set_hw_alarm(rtc, lpa >> 32, lpa);
> +	st_rtc_alarm_irq_enable(dev, t->enabled);
> +
> +	return 0;
> +}
> +
> +static struct rtc_class_ops st_rtc_ops = {
> +	.read_time		= st_rtc_read_time,
> +	.set_time		= st_rtc_set_time,
> +	.read_alarm		= st_rtc_read_alarm,
> +	.set_alarm		= st_rtc_set_alarm,
> +	.alarm_irq_enable	= st_rtc_alarm_irq_enable,
> +};
> +
> +static int st_rtc_probe(struct platform_device *pdev)
> +{
> +	struct device_node *np;
> +	struct st_rtc *rtc;
> +	struct resource *res;
> +	struct rtc_time tm_check;
> +	int ret = 0;
> +
> +	/* This is a single [shared] node MFD device. */
> +	np = pdev->dev.of_node = pdev->dev.parent->of_node;
> +
> +	rtc = devm_kzalloc(&pdev->dev, sizeof(struct st_rtc), GFP_KERNEL);
> +	if (!rtc)
> +		return -ENOMEM;
> +
> +	spin_lock_init(&rtc->lock);
> +
> +	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
> +	rtc->ioaddr = devm_ioremap_resource(&pdev->dev, res);
> +	if (IS_ERR(rtc->ioaddr))
> +		return PTR_ERR(rtc->ioaddr);
> +
> +	rtc->irq = irq_of_parse_and_map(np, 0);
> +	if (!rtc->irq) {
> +		dev_err(&pdev->dev, "IRQ missing or invalid\n");
> +		return -EINVAL;
> +	}
> +
> +	ret = devm_request_irq(&pdev->dev, rtc->irq, st_rtc_handler, 0,
> +			       pdev->name, rtc);
> +	if (ret) {
> +		dev_err(&pdev->dev, "Failed to request irq %i\n", rtc->irq);
> +		return ret;
> +	}
> +
> +	enable_irq_wake(rtc->irq);
> +	disable_irq(rtc->irq);
> +
> +	rtc->clk = clk_get(&pdev->dev, NULL);
> +	if (IS_ERR(rtc->clk)) {
> +		dev_err(&pdev->dev, "Unable to request clock\n");
> +		return PTR_ERR(rtc->clk);
> +	}
> +
> +	clk_prepare_enable(rtc->clk);
> +
> +	device_set_wakeup_capable(&pdev->dev, 1);
> +
> +	platform_set_drvdata(pdev, rtc);
> +
> +	/*
> +	 * The RTC-LPC is able to manage date.year > 2038
> +	 * but currently the kernel can not manage this date!
> +	 * If the RTC-LPC has a date.year > 2038 then
> +	 * it's set to the epoch "Jan 1st 2000"
> +	 */
> +	st_rtc_read_time(&pdev->dev, &tm_check);
> +
> +	if (tm_check.tm_year >=  (2038 - 1900)) {
> +		memset(&tm_check, 0, sizeof(tm_check));
> +		tm_check.tm_year = 100;
> +		tm_check.tm_mday = 1;
> +		st_rtc_set_time(&pdev->dev, &tm_check);
> +	}
> +
> +	rtc->rtc_dev = rtc_device_register("st-lpc-rtc", &pdev->dev,
> +					   &st_rtc_ops, THIS_MODULE);
> +	if (IS_ERR(rtc->rtc_dev)) {
> +		clk_disable_unprepare(rtc->clk);
> +		return PTR_ERR(rtc->rtc_dev);
> +	}
> +
> +	return 0;
> +}
> +
> +static int st_rtc_remove(struct platform_device *pdev)
> +{
> +	struct st_rtc *rtc = platform_get_drvdata(pdev);
> +
> +	if (likely(rtc->rtc_dev))
> +		rtc_device_unregister(rtc->rtc_dev);
> +
> +	return 0;
> +}
> +
> +#ifdef CONFIG_PM
CONFIG_PM_SLEEP is enough. If CONFIG_PM_SLEEP unset and 
CONFIG_PM_RUNTIME set, this will lead in a compilation warning. API 
defined but not used.
> +static int st_rtc_suspend(struct device *dev)
> +{
> +	struct st_rtc *rtc = dev_get_drvdata(dev);
> +
> +	if (device_may_wakeup(dev))
> +		return 0;
> +
> +	writel(1, rtc->ioaddr + LPC_WDT_OFF);
> +	writel(0, rtc->ioaddr + LPC_LPA_START_OFF);
> +	writel(0, rtc->ioaddr + LPC_WDT_OFF);
> +
> +	return 0;
> +}
> +
> +static int st_rtc_resume(struct device *dev)
> +{
> +	struct st_rtc *rtc = dev_get_drvdata(dev);
> +
> +	rtc_alarm_irq_enable(rtc->rtc_dev, 0);
> +
> +	/*
> +	 * clean 'rtc->alarm' to allow a new
> +	 * a new .set_alarm to the upper RTC layer
> +	 */
duplicate "a new"
> +	memset(&rtc->alarm, 0, sizeof(struct rtc_wkalrm));
> +
> +	writel(0, rtc->ioaddr + LPC_LPA_MSB_OFF);
> +	writel(0, rtc->ioaddr + LPC_LPA_LSB_OFF);
> +	writel(1, rtc->ioaddr + LPC_WDT_OFF);
> +	writel(1, rtc->ioaddr + LPC_LPA_START_OFF);
> +	writel(0, rtc->ioaddr + LPC_WDT_OFF);
> +
> +	return 0;
> +}
> +#endif
> +
> +static SIMPLE_DEV_PM_OPS(st_rtc_pm_ops, st_rtc_suspend, st_rtc_resume);
> +
> +static struct platform_driver st_rtc_platform_driver = {
> +	.driver = {
> +		.name = "st-lpc-rtc",
> +		.pm = &st_rtc_pm_ops,
> +	},
> +	.probe = st_rtc_probe,
> +	.remove = st_rtc_remove,
> +};
> +
> +module_platform_driver(st_rtc_platform_driver);
> +
> +MODULE_DESCRIPTION("STMicroelectronics LPC RTC driver");
> +MODULE_AUTHOR("David Paris <david.paris@st.com>");
> +MODULE_LICENSE("GPLv2");

