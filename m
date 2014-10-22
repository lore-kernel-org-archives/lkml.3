Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752863AbaJVDen (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Oct 2014 23:34:43 -0400
Received: from regular2.263xmail.com ([211.157.152.3]:42631 "EHLO
	regular2.263xmail.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751267AbaJVDel (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Oct 2014 23:34:41 -0400
X-263anti-spam: KSV:0;
X-MAIL-GRAY: 0
X-MAIL-DELIVERY: 1
X-KSVirus-check: 0
X-ABS-CHECKED: 4
X-RL-SENDER: jinkun.hong@rock-chips.com
X-FST-TO: jack.dai@rock-chips.com
X-SENDER-IP: 58.22.7.114
X-LOGIN-NAME: jinkun.hong@rock-chips.com
X-UNIQUE-TAG: <1dcb3af630e8522547f6ee06bc998e90>
X-ATTACHMENT-NUM: 0
X-DNS-TYPE: 0
Message-ID: <544725C4.4040703@rock-chips.com>
Date: Wed, 22 Oct 2014 11:34:28 +0800
From: Hong jinkun <jinkun.hong@rock-chips.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
CC: linus.walleij@linaro.org, linux-arm-kernel@lists.infradead.org,
        Russell King <linux@arm.linux.org.uk>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Grant Likely <grant.likely@linaro.org>, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org, Randy Dunlap <rdunlap@infradead.org>,
        linux-doc@vger.kernel.org, dianders@chromium.org,
        Heiko Stuebner <heiko@sntech.de>, linux-rockchip@lists.infradead.org,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Jack Dai <jack.dai@rock-chips.com>
Subject: Re: [PATCH v5 1/3] power-domain: add power domain drivers for Rockchip
 platform
References: <1413882808-4669-1-git-send-email-jinkun.hong@rock-chips.com> <1413882808-4669-2-git-send-email-jinkun.hong@rock-chips.com> <20141021195854.GE8609@dtor-ws>
In-Reply-To: <20141021195854.GE8609@dtor-ws>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On 2014/10/22 3:58, Dmitry Torokhov wrote:
> Hi Jinkun,
>
> On Tue, Oct 21, 2014 at 02:13:26AM -0700, jinkun.hong wrote:
>> From: "jinkun.hong" <jinkun.hong@rock-chips.com>
>>
>> Add power domain drivers based on generic power domain for Rockchip platform,
>> and support RK3288.
>>
>> Signed-off-by: Jack Dai <jack.dai@rock-chips.com>
>> Signed-off-by: jinkun.hong <jinkun.hong@rock-chips.com>
>>
>> ---
>>
>> Changes in v5:
>> - delete idle_lock
>> - add timeout in rockchip_pmu_set_idle_request()
>>
>> Changes in v4:
>> - use list storage dev
>>
>> Changes in v3:
>> - change use pm_clk_resume() and pm_clk_suspend()
>>
>> Changes in v2:
>> - remove the "pd->pd.of_node = np"
>>
>>   arch/arm/mach-rockchip/Kconfig      |    1 +
>>   arch/arm/mach-rockchip/Makefile     |    1 +
>>   arch/arm/mach-rockchip/pm_domains.c |  368 +++++++++++++++++++++++++++++++++++
>>   3 files changed, 370 insertions(+)
>>   create mode 100644 arch/arm/mach-rockchip/pm_domains.c
>>
>> diff --git a/arch/arm/mach-rockchip/Kconfig b/arch/arm/mach-rockchip/Kconfig
>> index d168669..4920a88 100644
>> --- a/arch/arm/mach-rockchip/Kconfig
>> +++ b/arch/arm/mach-rockchip/Kconfig
>> @@ -12,6 +12,7 @@ config ARCH_ROCKCHIP
>>   	select DW_APB_TIMER_OF
>>   	select ARM_GLOBAL_TIMER
>>   	select CLKSRC_ARM_GLOBAL_TIMER_SCHED_CLOCK
>> +	select PM_GENERIC_DOMAINS if PM
>>   	help
>>   	  Support for Rockchip's Cortex-A9 Single-to-Quad-Core-SoCs
>>   	  containing the RK2928, RK30xx and RK31xx series.
>> diff --git a/arch/arm/mach-rockchip/Makefile b/arch/arm/mach-rockchip/Makefile
>> index b29d8ea..805268d 100644
>> --- a/arch/arm/mach-rockchip/Makefile
>> +++ b/arch/arm/mach-rockchip/Makefile
>> @@ -2,3 +2,4 @@ CFLAGS_platsmp.o := -march=armv7-a
>>   
>>   obj-$(CONFIG_ARCH_ROCKCHIP) += rockchip.o
>>   obj-$(CONFIG_SMP) += headsmp.o platsmp.o
>> +obj-$(CONFIG_PM_GENERIC_DOMAINS) += pm_domains.o
>> diff --git a/arch/arm/mach-rockchip/pm_domains.c b/arch/arm/mach-rockchip/pm_domains.c
>> new file mode 100644
>> index 0000000..8f13445
>> --- /dev/null
>> +++ b/arch/arm/mach-rockchip/pm_domains.c
>> @@ -0,0 +1,368 @@
>> +/*
>> + * Rockchip Generic power domain support.
>> + *
>> + * Copyright (c) 2014 ROCKCHIP, Co. Ltd.
>> + * Author: Hong Jinkun <jinkun.hong@rock-chips.com>
>> + *
>> + * This program is free software; you can redistribute it and/or modify
>> + * it under the terms of the GNU General Public License version 2 as
>> + * published by the Free Software Foundation.
>> + */
>> +#include <linux/module.h>
>> +#include <linux/io.h>
>> +#include <linux/err.h>
>> +#include <linux/slab.h>
>> +#include <linux/pm_domain.h>
>> +#include <linux/of_address.h>
>> +#include <linux/of_platform.h>
>> +#include <linux/sched.h>
>> +#include <linux/clk.h>
>> +#include <linux/regmap.h>
>> +#include <linux/mfd/syscon.h>
>> +#include <linux/spinlock.h>
>> +#include <linux/pm_clock.h>
>> +#include <linux/delay.h>
>> +
>> +#define PWR_OFFSET		0x08
>> +#define STATUS_OFFSET	0x0c
>> +#define REQ_OFFSET		0x10
>> +#define IDLE_OFFSET		0x14
>> +#define ACK_OFFSET		0x14
>> +
>> +struct rockchip_dev_entry {
>> +	struct list_head node;
>> +	struct device *dev;
>> +};
>> +
>> +struct rockchip_domain {
>> +	struct generic_pm_domain base;
>> +	struct device *dev;
>> +	struct regmap *regmap_pmu;
>> +	struct list_head dev_list;
>> +	/* spin lock for read/write pmu reg */
>> +	spinlock_t pmu_lock;
>> +	/* spin lock for dev_list */
>> +	spinlock_t dev_lock;
>> +	u32 pwr_shift;
>> +	u32 status_shift;
>> +	u32 req_shift;
>> +	u32 idle_shift;
>> +	u32 ack_shift;
>> +};
>> +
>> +#define to_rockchip_pd(_gpd) container_of(_gpd, struct rockchip_domain, base)
>> +
>> +static int rockchip_pmu_set_idle_request(struct rockchip_domain *pd,
>> +					 bool idle)
>> +{
>> +	u32 idle_mask = BIT(pd->idle_shift);
>> +	u32 idle_target = idle << (pd->idle_shift);
>> +	u32 ack_mask = BIT(pd->ack_shift);
>> +	u32 ack_target = idle << (pd->ack_shift);
>> +	unsigned int mask = BIT(pd->req_shift);
>> +	unsigned int val;
>> +	unsigned long flags;
>> +	int timeout = 0;
>> +
>> +	val = (idle) ? mask : 0;
>> +	regmap_update_bits(pd->regmap_pmu, REQ_OFFSET, mask, val);
>> +	dsb();
>> +
>> +	do {
>> +		regmap_read(pd->regmap_pmu, ACK_OFFSET, &val);
>> +		udelay(1);
>> +		if (timeout > 10) {
>> +			pr_err("%s wait pmu ack timeout!\n", __func__);
>> +			break;
>> +		}
>> +		timeout += 1;
>> +	} while ((val & ack_mask) != ack_target);
>> +
>> +	timeout = 0;
>> +	do {
>> +		regmap_read(pd->regmap_pmu, IDLE_OFFSET, &val);
>> +		udelay(1);
>> +		if (timeout > 10) {
>> +			pr_err("%s wait pmu idle timeout!\n", __func__);
>> +			break;
>> +		}
>> +		timeout += 1;
>> +	} while ((val & idle_mask) != idle_target);
>> +	return 0;
>> +}
>> +
>> +static bool rockchip_pmu_power_domain_is_on(struct rockchip_domain *pd)
>> +{
>> +	unsigned int val;
>> +
>> +	regmap_read(pd->regmap_pmu, STATUS_OFFSET, &val);
>> +
>> +	/* 1'b0: power on, 1'b1: power off */
>> +	return !(val & BIT(pd->status_shift));
>> +}
>> +
>> +static void rockchip_do_pmu_set_power_domain(
>> +		struct rockchip_domain *pd, bool on)
>> +{
>> +	unsigned int mask = BIT(pd->pwr_shift);
>> +	unsigned int val;
>> +
>> +	val = (on) ? 0 : mask;
>> +	regmap_update_bits(pd->regmap_pmu, PWR_OFFSET, mask, val);
>> +	dsb();
>> +
>> +	do {
>> +		regmap_read(pd->regmap_pmu, STATUS_OFFSET, &val);
>> +	} while ((val & BIT(pd->status_shift)) == on);
>> +}
>> +
>> +static int rockchip_pmu_set_power_domain(struct rockchip_domain *pd,
>> +					 bool on)
>> +{
>> +	unsigned long flags;
>> +
>> +	spin_lock_irqsave(&pd->pmu_lock, flags);
> You only call rockchip_pmu_set_power_domain() with pd->dev_lock held,
> why do you need this spinlock?
I will remove the pmu_lock.
>> +	if (rockchip_pmu_power_domain_is_on(pd) == on)
>> +		goto out;
>> +
>> +	if (!on) {
>> +		/* FIXME: add code to save AXI_QOS */
>> +		/* if power down, idle request to NIU first */
>> +		rockchip_pmu_set_idle_request(pd, true);
>> +	}
>> +
>> +	rockchip_do_pmu_set_power_domain(pd, on);
>> +
>> +	if (on) {
>> +		/* if power up, idle request release to NIU */
>> +		rockchip_pmu_set_idle_request(pd, false);
>> +		/* FIXME: add code to restore AXI_QOS */
>> +	}
>> +out:
>> +	spin_unlock_irqrestore(&pd->pmu_lock, flags);
>> +	return 0;
>> +}
>> +
>> +static int rockchip_pd_power(struct rockchip_domain *pd, bool power_on)
>> +{
>> +	int i = 0;
>> +	int ret = 0;
>> +	struct rockchip_dev_entry *de;
>> +
>> +	spin_lock_irq(&pd->dev_lock);
> Do you really need to run here with interrupts off? Maybe a mutex would
> be better here?
Ok,I use mutex.
>> +
>> +	list_for_each_entry(de, &pd->dev_list, node) {
>> +		i += 1;
>> +		pm_clk_resume(pd->dev);
> Do you really need to call pm_clk_resume() number of times that there
> are devices in power domain? Did you want it to be
>
> 		pm_clk_resume(de->dev);
>
> by any chance?
You are right.I will modify in the next version.
>> +	}
>> +
>> +	/* no clk, set power domain will fail */
>> +	if (i == 0) {
>> +		pr_err("%s: failed to on/off power domain!", __func__);
>> +		spin_unlock_irq(&pd->dev_lock);
>> +		return ret;
>> +	}
> Instead of counting I'd do
>
> 	if (list_empty(&pd->dev_list)) {
> 		pr_waen("%s: no devices in power domain\n", __func__);
> 		goto out;
> 	}
>
> in the beginning of the function.
This is a good idea.
>> +
>> +	ret = rockchip_pmu_set_power_domain(pd, power_on);
>> +
>> +	list_for_each_entry(de, &pd->dev_list, node) {
>> +		pm_clk_suspend(pd->dev);
> Same here?
>
>> +	}
>> +
>> +	spin_unlock_irq(&pd->dev_lock);
>> +
>> +	return ret;
>> +}
>> +
>> +static int rockchip_pd_power_on(struct generic_pm_domain *domain)
>> +{
>> +	struct rockchip_domain *pd = to_rockchip_pd(domain);
>> +
>> +	return rockchip_pd_power(pd, true);
>> +}
>> +
>> +static int rockchip_pd_power_off(struct generic_pm_domain *domain)
>> +{
>> +	struct rockchip_domain *pd = to_rockchip_pd(domain);
>> +
>> +	return rockchip_pd_power(pd, false);
>> +}
>> +
>> +void rockchip_pm_domain_attach_dev(struct device *dev)
>> +{
>> +	int ret;
>> +	int i = 0;
>> +	struct clk *clk;
>> +	struct rockchip_domain *pd;
>> +	struct rockchip_dev_entry *de;
>> +
>> +	pd = (struct rockchip_domain *)dev->pm_domain;
>> +	ret = pm_clk_create(dev);
>> +	if (ret) {
>> +		dev_err(dev, "pm_clk_create failed %d\n", ret);
>> +		return;
>> +	};
> Stray semicolon.
>> +
>> +	while ((clk = of_clk_get(dev->of_node, i++)) && !IS_ERR(clk)) {
>> +		ret = pm_clk_add_clk(dev, clk);
>> +		if (ret) {
>> +			dev_err(dev, "pm_clk_add_clk failed %d\n", ret);
>> +			goto clk_err;
>> +		};
>> +	}
>> +
>> +	de = devm_kcalloc(pd->dev, 1,
>> +			sizeof(struct rockchip_dev_entry *), GFP_KERNEL);
> Why devm_calloc for a single element and not devm_kzalloc? Also, I am a
> bit concerned about using devm_* API here. They are better reserved fir
> driver's ->probe() paths whereas we are called from
> dev_pm_domain_attach() which is more general API (yes, currently it is
> used by buses probing code, but that might change in the future).
>
> Also, where is OOM error handling?
Ok,I will change the use  devm_kzalloc.
Register to pm domain devices, the number is not a lot.
>> +	spin_lock_irq(&pd->dev_lock);
>> +	list_add_tail(&de->node, &pd->dev_list);
>> +	spin_unlock_irq(&pd->dev_lock);
>> +
>> +	return;
>> +clk_err:
>> +	pm_clk_destroy(dev);
>> +}
>> +
>> +void rockchip_pm_domain_detach_dev(struct device *dev)
>> +{
>> +	struct rockchip_domain *pd;
>> +	struct rockchip_dev_entry *de;
>> +
>> +	pd = (struct rockchip_domain *)dev->pm_domain;
>> +	spin_lock_irq(&pd->dev_lock);
>> +
>> +	list_for_each_entry(de, &pd->dev_list, node) {
>> +		if (de->dev == dev)
>> +			goto remove;
> If you use mutex instead of spinlock I think you'll be able to do
> list_del/pm_clk_destroy() right here. I'd free memory here as well.
OK
> Thanks.
>

Thank you for your review.


