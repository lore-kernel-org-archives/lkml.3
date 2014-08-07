Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757694AbaHGNEm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Aug 2014 09:04:42 -0400
Received: from regular1.263xmail.com ([211.150.99.135]:54563 "EHLO
	regular1.263xmail.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757644AbaHGNEj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Aug 2014 09:04:39 -0400
X-263anti-spam: KSV:0;
X-MAIL-GRAY: 0
X-MAIL-DELIVERY: 1
X-ABS-CHECKED: 4
X-KSVirus-check: 0
X-RL-SENDER: caesar.wang@rock-chips.com
X-FST-TO: linux-doc@vger.kernel.org
X-SENDER-IP: 58.22.7.114
X-LOGIN-NAME: caesar.wang@rock-chips.com
X-UNIQUE-TAG: <d3eb862ce6892c3eb8f5fff85b80653a>
X-ATTACHMENT-NUM: 0
X-DNS-TYPE: 0
Message-ID: <53E3795E.4080607@rock-chips.com>
Date: Thu, 07 Aug 2014 21:04:30 +0800
From: caesar <caesar.wang@rock-chips.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: Thierry Reding <thierry.reding@gmail.com>
CC: heiko@sntech.de, b.galvani@gmail.com, robh+dt@kernel.org,
        ijc+devicetree@hellion.org.uk, rdunlap@infradead.org,
        galak@codeaurora.org, cf@rock-chips.com, huangtao@rock-chips.com,
        xjq@rock-chips.com, addy.ke@rock-chips.com, cjf@rock-chips.com,
        hj@rock-chips.com, linux-arm-kernel@lists.infradead.org,
        linux-pwm@vger.kernel.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org, linux-doc@vger.kernel.org
Subject: Re: [PATCH v4 2/2] pwm: rockchip: Added to support for RK3288 SoC
References: <1406197295-10604-1-git-send-email-caesar.wang@rock-chips.com> <1406197295-10604-3-git-send-email-caesar.wang@rock-chips.com> <20140807061842.GB17340@ulmo>
In-Reply-To: <20140807061842.GB17340@ulmo>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thierry,

在 2014年08月07日 14:18, Thierry Reding 写道:
> On Thu, Jul 24, 2014 at 06:21:35PM +0800, Caesar Wang wrote:
>> This patch added to support the PWM controller found on
>> RK3288 SoC.
>>
>> Signed-off-by: Caesar Wang <caesar.wang@rock-chips.com>
>> ---
>>   drivers/pwm/pwm-rockchip.c | 124 ++++++++++++++++++++++++++++++++++++++-------
>>   1 file changed, 105 insertions(+), 19 deletions(-)
>>
>> diff --git a/drivers/pwm/pwm-rockchip.c b/drivers/pwm/pwm-rockchip.c
>> index eec2145..59c2513 100644
>> --- a/drivers/pwm/pwm-rockchip.c
>> +++ b/drivers/pwm/pwm-rockchip.c
>> @@ -2,6 +2,7 @@
>>    * PWM driver for Rockchip SoCs
>>    *
>>    * Copyright (C) 2014 Beniamino Galvani <b.galvani@gmail.com>
>> + * Copyright (C) 2014 ROCKCHIP, Inc.
>>    *
>>    * This program is free software; you can redistribute it and/or
>>    * modify it under the terms of the GNU General Public License
>> @@ -12,6 +13,7 @@
>>   #include <linux/io.h>
>>   #include <linux/module.h>
>>   #include <linux/of.h>
>> +#include <linux/of_device.h>
>>   #include <linux/platform_device.h>
>>   #include <linux/pwm.h>
>>   #include <linux/time.h>
>> @@ -25,17 +27,72 @@
>>   
>>   #define PRESCALER		2
>>   
>> +#define PWM_ENABLE		(1 << 0)
>> +#define PWM_CONTINUOUS		(1 << 1)
>> +#define PWM_DUTY_POSITIVE	(1 << 3)
>> +#define PWM_INACTIVE_NEGATIVE	(0 << 4)
>> +#define PWM_OUTPUT_LEFT		(0 << 5)
>> +#define PWM_LP_DISABLE		(0 << 8)
>> +
>>   struct rockchip_pwm_chip {
>>   	struct pwm_chip chip;
>>   	struct clk *clk;
>> +	const struct rockchip_pwm_data *data;
>>   	void __iomem *base;
>>   };
>>   
>> +struct rockchip_pwm_regs {
>> +	unsigned long duty;
>> +	unsigned long period;
>> +	unsigned long cntr;
>> +	unsigned long ctrl;
>> +};
>> +
>> +struct rockchip_pwm_data {
>> +	struct rockchip_pwm_regs regs;
>> +	unsigned int prescaler;
>> +
>> +	void (*set_enable)(struct pwm_chip *chip, bool enable);
>> +};
>> +
>>   static inline struct rockchip_pwm_chip *to_rockchip_pwm_chip(struct pwm_chip *c)
>>   {
>>   	return container_of(c, struct rockchip_pwm_chip, chip);
>>   }
>>   
>> +static void rockchip_pwm_set_enable_v1(struct pwm_chip *chip, bool enable)
>> +{
>> +	struct rockchip_pwm_chip *pc = to_rockchip_pwm_chip(chip);
>> +	u32 val = 0;
>> +	u32 enable_conf = PWM_CTRL_OUTPUT_EN | PWM_CTRL_TIMER_EN;
>> +
>> +	val = readl_relaxed(pc->base + pc->data->regs.ctrl);
>> +
>> +	if (enable)
>> +		val |= enable_conf;
>> +	else
>> +		val &= ~enable_conf;
>> +
>> +	writel_relaxed(val, pc->base + pc->data->regs.ctrl);
>> +}
>> +
>> +static void rockchip_pwm_set_enable_v2(struct pwm_chip *chip, bool enable)
>> +{
>> +	struct rockchip_pwm_chip *pc = to_rockchip_pwm_chip(chip);
>> +	u32 val = 0;
>> +	u32 enable_conf = PWM_OUTPUT_LEFT | PWM_LP_DISABLE | PWM_ENABLE |
>> +		PWM_CONTINUOUS | PWM_DUTY_POSITIVE | PWM_INACTIVE_NEGATIVE;
>> +
>> +	val = readl_relaxed(pc->base + pc->data->regs.ctrl);
>> +
>> +	if (enable)
>> +		val |= enable_conf;
>> +	else
>> +		val &= ~enable_conf;
>> +
>> +	writel_relaxed(val, pc->base + pc->data->regs.ctrl);
>> +}
>> +
>>   static int rockchip_pwm_config(struct pwm_chip *chip, struct pwm_device *pwm,
>>   			       int duty_ns, int period_ns)
>>   {
>> @@ -52,20 +109,20 @@ static int rockchip_pwm_config(struct pwm_chip *chip, struct pwm_device *pwm,
>>   	 * default prescaler value for all practical clock rate values.
>>   	 */
>>   	div = clk_rate * period_ns;
>> -	do_div(div, PRESCALER * NSEC_PER_SEC);
>> +	do_div(div, pc->data->prescaler * NSEC_PER_SEC);
>>   	period = div;
>>   
>>   	div = clk_rate * duty_ns;
>> -	do_div(div, PRESCALER * NSEC_PER_SEC);
>> +	do_div(div, pc->data->prescaler * NSEC_PER_SEC);
>>   	duty = div;
>>   
>>   	ret = clk_enable(pc->clk);
>>   	if (ret)
>>   		return ret;
>>   
>> -	writel(period, pc->base + PWM_LRC);
>> -	writel(duty, pc->base + PWM_HRC);
>> -	writel(0, pc->base + PWM_CNTR);
>> +	writel(period, pc->base + pc->data->regs.period);
>> +	writel(duty, pc->base + pc->data->regs.duty);
>> +	writel(0, pc->base + pc->data->regs.cntr);
>>   
>>   	clk_disable(pc->clk);
>>   
>> @@ -76,15 +133,12 @@ static int rockchip_pwm_enable(struct pwm_chip *chip, struct pwm_device *pwm)
>>   {
>>   	struct rockchip_pwm_chip *pc = to_rockchip_pwm_chip(chip);
>>   	int ret;
>> -	u32 val;
>>   
>>   	ret = clk_enable(pc->clk);
>>   	if (ret)
>>   		return ret;
>>   
>> -	val = readl_relaxed(pc->base + PWM_CTRL);
>> -	val |= PWM_CTRL_OUTPUT_EN | PWM_CTRL_TIMER_EN;
>> -	writel_relaxed(val, pc->base + PWM_CTRL);
>> +	pc->data->set_enable(chip, true);
>>   
>>   	return 0;
>>   }
>> @@ -92,11 +146,8 @@ static int rockchip_pwm_enable(struct pwm_chip *chip, struct pwm_device *pwm)
>>   static void rockchip_pwm_disable(struct pwm_chip *chip, struct pwm_device *pwm)
>>   {
>>   	struct rockchip_pwm_chip *pc = to_rockchip_pwm_chip(chip);
>> -	u32 val;
>>   
>> -	val = readl_relaxed(pc->base + PWM_CTRL);
>> -	val &= ~(PWM_CTRL_OUTPUT_EN | PWM_CTRL_TIMER_EN);
>> -	writel_relaxed(val, pc->base + PWM_CTRL);
>> +	pc->data->set_enable(chip, false);
>>   
>>   	clk_disable(pc->clk);
>>   }
>> @@ -108,12 +159,52 @@ static const struct pwm_ops rockchip_pwm_ops = {
>>   	.owner = THIS_MODULE,
>>   };
>>   
>> +static const struct rockchip_pwm_data pwm_data_v1 = {
>> +	.regs.duty = PWM_HRC,
>> +	.regs.period = PWM_LRC,
>> +	.regs.cntr = PWM_CNTR,
>> +	.regs.ctrl = PWM_CTRL,
> Perhaps a slightly more idiomatic way to write this would be:
>
> 	static const struct rockchip_pwm_data pwm_data_v1 = {
> 		.regs = {
> 			.duty = PWM_HRC,
> 			.period = PWM_LRC,
> 			.cntr = PWM_CNTR,
> 			.ctrl = PWM_CTRL,
> 		},
> 		...
> 	};
>
> And similar for the v2 and vop structures. And like I said in another
> reply, since the defines are now only used in this structure it's a
> little redundant to give them symbolic names, so the above could equally
> well be:
>
> 	static const struct rockchip_pwm_data pwm_data_v1 = {
> 		.regs = {
> 			.duty = 0x04,
> 			.period = 0x08,
> 			.cntr = 0x00,
> 			.ctrl = 0x0c,
> 		},
> 		...
> 	};
>
>> +	.prescaler = PRESCALER,
> Similarly for the prescaler value, it can now simply be 2 here.
>
>> +	.set_enable = rockchip_pwm_set_enable_v1,
>> +};
>> +
>> +static const struct rockchip_pwm_data pwm_data_v2 = {
>> +	.regs.duty = PWM_LRC,
>> +	.regs.period = PWM_HRC,
>> +	.regs.cntr = PWM_CNTR,
>> +	.regs.ctrl = PWM_CTRL,
>> +	.prescaler = PRESCALER-1,
> And 1 here.
>
>> +	.set_enable = rockchip_pwm_set_enable_v2,
>> +};
>> +
>> +static const struct rockchip_pwm_data pwm_data_vop = {
>> +	.regs.duty = PWM_LRC,
>> +	.regs.period = PWM_HRC,
>> +	.regs.cntr = PWM_CTRL,
>> +	.regs.ctrl = PWM_CNTR,
>> +	.prescaler = PRESCALER-1,
> And 1 here.

As you say, I will rewrite the about if it's really need  do so it.
For example:

static const struct rockchip_pwm_data pwm_data_v1 = {
     .regs = {
                 .duty = 0x04,
                 .period = 0x08,
                 .cntr = 0x00,
                 .ctrl = 0x0c,
     },
     .prescaler = 2,
     .set_enable = rockchip_pwm_set_enable_v1,
};

static const struct rockchip_pwm_data pwm_data_v2 = {
     .regs = {
                 .duty = 0x08,
                 .period = 0x04,
                 .cntr = 0x00,
                 .ctrl = 0x0c,
     },
     .prescaler = 1,
     .set_enable = rockchip_pwm_set_enable_v2,
};

static const struct rockchip_pwm_data pwm_data_vop = {
     .regs = {
                 .duty = 0x08,
                 .period = 0x04,
                 .cntr = 0x0c,
                 .ctrl = 0x00,
     },
     .prescaler = 1,
     .set_enable = rockchip_pwm_set_enable_v2,
};

Is that right?

>> +	.set_enable = rockchip_pwm_set_enable_v2,
>> +};
> No need for the double indirection.

Sorry, I think is need if you mean a double indirection for ".set_enable".



Caesar
>
> Thierry


