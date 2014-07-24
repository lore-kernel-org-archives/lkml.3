Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755490AbaGXJaJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jul 2014 05:30:09 -0400
Received: from regular1.263xmail.com ([211.150.99.140]:42191 "EHLO
	regular1.263xmail.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751833AbaGXJaH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jul 2014 05:30:07 -0400
X-263anti-spam: KSV:0;
X-MAIL-GRAY: 0
X-MAIL-DELIVERY: 1
X-ABS-CHECKED: 4
X-KSVirus-check: 0
X-RL-SENDER: caesar.wang@rock-chips.com
X-FST-TO: addy.ke@rock-chips.com
X-SENDER-IP: 58.22.7.114
X-LOGIN-NAME: caesar.wang@rock-chips.com
X-UNIQUE-TAG: <ca0016ff2230cc656e6062f632dda785>
X-ATTACHMENT-NUM: 0
X-DNS-TYPE: 0
Message-ID: <53D0D212.40400@rock-chips.com>
Date: Thu, 24 Jul 2014 17:29:54 +0800
From: caesar <caesar.wang@rock-chips.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: =?UTF-8?B?SGVpa28gU3TDvGJuZXI=?= <heiko@sntech.de>
CC: thierry.reding@gmail.com, b.galvani@gmail.com,
        linux-arm-kernel@lists.infradead.org, linux-pwm@vger.kernel.org,
        linux-kernel@vger.kernel.org, cf@rock-chips.com,
        huangtao@rock-chips.com, hj@rock-chips.com, xjq@rock-chips.com,
        addy.ke@rock-chips.com
Subject: Re: [PATCH v3 2/2] pwm: rockchip: Added to support for RK3288 SoC
References: <1406097521-6457-1-git-send-email-caesar.wang@rock-chips.com> <1648580.P46ct6rREY@diego> <53D06BE3.7010509@rock-chips.com> <1949437.1N5XrQ9a4Y@diego>
In-Reply-To: <1949437.1N5XrQ9a4Y@diego>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Heiko,

在 2014年07月24日 16:05, Heiko Stübner 写道:
> Hi caesar.
>
> Am Donnerstag, 24. Juli 2014, 10:13:55 schrieb caesar:
>>>> +static void rockchip_pwm_set_enable_v1(struct pwm_chip *chip, bool
>>>> enable)
>>>> +{
>>>> +	struct rockchip_pwm_chip *pc = to_rockchip_pwm_chip(chip);
>>>> +	u32 val = 0;
>>>> +	u32 enable_conf = PWM_CTRL_OUTPUT_EN | PWM_CTRL_TIMER_EN;
>>>> +
>>>> +	val = readl_relaxed(pc->base + pc->data->regs.ctrl);
>>>> +
>>>> +	if (enable)
>>>> +		val |= enable_conf;
>>>> +	else
>>>> +		val &= ~enable_conf;
>>>> +
>>>> +	writel_relaxed(val, pc->base + pc->data->regs.ctrl);
>>>> +}
>>>> +
>>>> +static void rockchip_pwm_set_enable_v2(struct pwm_chip *chip, bool
>>>> enable)
>>>> +{
>>>> +	struct rockchip_pwm_chip *pc = to_rockchip_pwm_chip(chip);
>>>> +	u32 val = 0;
>>>> +	u32 enable_conf = PWM_OUTPUT_LEFT | PWM_LP_DISABLE | PWM_ENABLE |
>>>> +		PWM_CONTINUOUS | PWM_DUTY_POSITIVE | PWM_INACTIVE_NEGATIVE;
>>>> +
>>>> +	val = readl_relaxed(pc->base + pc->data->regs.ctrl);
>>>> +
>>>> +	if (enable)
>>>> +		val |= enable_conf;
>>>> +	else
>>>> +		val &= ~enable_conf;
>>>> +
>>>> +	writel_relaxed(val, pc->base + pc->data->regs.ctrl);
>>>> +}
>>>> +
>>>> +static void rockchip_pwm_set_enable_vop(struct pwm_chip *chip, bool
>>>> enable) +{
>>>> +	struct rockchip_pwm_chip *pc = to_rockchip_pwm_chip(chip);
>>>> +	u32 val = 0;
>>>> +	u32 enable_conf = PWM_OUTPUT_LEFT | PWM_LP_DISABLE | PWM_ENABLE |
>>>> +		PWM_CONTINUOUS | PWM_DUTY_POSITIVE | PWM_INACTIVE_NEGATIVE;
>>>> +
>>>> +	val = readl_relaxed(pc->base + pc->data->regs.ctrl);
>>>> +
>>>> +	if (enable)
>>>> +		val |= enable_conf;
>>>> +	else
>>>> +		val &= ~enable_conf;
>>>> +
>>>> +	writel_relaxed(val, pc->base + pc->data->regs.ctrl);
>>>> +}
>>> not sure if I'm just blind ... do rockchip_pwm_set_enable_v2 and
>>> rockchip_pwm_set_enable_vop differ at all?
>>>
>>> If they don't differ, I guess pwm_data_vop should just use
>>> rockchip_pwm_set_enable_v2 instead of duplicating it.
>>>
>> Yes, the rockchip_pwm_set_enable_v1 & v2 & vop is similar.
>>
>> So my v2 patch use "u32 enable_conf" instead of it .
>> +struct rockchip_pwm_data {
>>
>>   > + .........
>>   > + u32 enable_conf;
>>   > +};
>>
>> The thierry has suggested it [1] in my v2 patch:
>>
>> For this I think it would be more readable to provide function pointers
>> rather than a variable. That is:
>>
>> 	struct rockchip_pwm_data {
>> 		...
>> 		int (*enable)(struct pwm_chip *chip, struct pwm_device *pwm);
>> 		int (*disable)(struct pwm_chip *chip, struct pwm_device *pwm);
>> 	};
>> Then you can implement these for each variant of the chip and call them
>> from the common rockchip_pwm_enable(), somewhat like this.
>>
>>
>> Perhaps,thierry's suggestion I got it wrong.
> Using the function pointers like Thierry suggested looks nice, so no I don't
> think you got it wrong :-)
>
> What I meant was to simply reuse the existing function
> rockchip_pwm_set_enable_v2 when there is _no_ difference at all to
> rockchip_pwm_set_enable_vop, like
>
> static const struct rockchip_pwm_data pwm_data_v2 = {
> 	.regs.duty = PWM_LRC,
> 	.regs.period = PWM_HRC,
> 	.regs.cntr = PWM_CNTR,
> 	.regs.ctrl = PWM_CTRL,
> 	.prescaler = PRESCALER-1,
> 	.set_enable = rockchip_pwm_set_enable_v2,
> };
>
> static const struct rockchip_pwm_data pwm_data_vop = {
> 	.regs.duty = PWM_LRC,
> 	.regs.period = PWM_HRC,
> 	.regs.cntr = PWM_CTRL,
> 	.regs.ctrl = PWM_CNTR,
> 	.prescaler = PRESCALER-1,
> 	.set_enable = rockchip_pwm_set_enable_v2,
> };
>
>
> Heiko
:-( ok, I will fix this and the other issuses in v4, thanks.
>> Hi thierry& Heiko :-)
>> Maybe,could you suggest solve it reasonable? thanks.
>>
>> [1]: https://lkml.org/lkml/2014/7/21/113
>>
>>>> +
>>>>
>>>>    static int rockchip_pwm_config(struct pwm_chip *chip, struct pwm_device
>>>>
>>>> *pwm, int duty_ns, int period_ns)
>>>>
>>>>    {
>>>>
>>>> @@ -52,20 +126,20 @@ static int rockchip_pwm_config(struct pwm_chip
>>>> *chip,
>>>> struct pwm_device *pwm, * default prescaler value for all practical clock
>>>> rate values.
>>>>
>>>>    	 */
>>>>    	
>>>>    	div = clk_rate * period_ns;
>>>>
>>>> -	do_div(div, PRESCALER * NSEC_PER_SEC);
>>>> +	do_div(div, pc->data->prescaler * NSEC_PER_SEC);
>>>>
>>>>    	period = div;
>>>>    	
>>>>    	div = clk_rate * duty_ns;
>>>>
>>>> -	do_div(div, PRESCALER * NSEC_PER_SEC);
>>>> +	do_div(div, pc->data->prescaler * NSEC_PER_SEC);
>>>>
>>>>    	duty = div;
>>>>    	
>>>>    	ret = clk_enable(pc->clk);
>>>>    	if (ret)
>>>>    	
>>>>    		return ret;
>>>>
>>>> -	writel(period, pc->base + PWM_LRC);
>>>> -	writel(duty, pc->base + PWM_HRC);
>>>> -	writel(0, pc->base + PWM_CNTR);
>>>> +	writel(period, pc->base + pc->data->regs.period);
>>>> +	writel(duty, pc->base + pc->data->regs.duty);
>>>> +	writel(0, pc->base + pc->data->regs.cntr);
>>>>
>>>>    	clk_disable(pc->clk);
>>>>
>>>> @@ -76,15 +150,12 @@ static int rockchip_pwm_enable(struct pwm_chip
>>>> *chip,
>>>> struct pwm_device *pwm) {
>>>>
>>>>    	struct rockchip_pwm_chip *pc = to_rockchip_pwm_chip(chip);
>>>>    	int ret;
>>>>
>>>> -	u32 val;
>>>>
>>>>    	ret = clk_enable(pc->clk);
>>>>    	if (ret)
>>>>    	
>>>>    		return ret;
>>>>
>>>> -	val = readl_relaxed(pc->base + PWM_CTRL);
>>>> -	val |= PWM_CTRL_OUTPUT_EN | PWM_CTRL_TIMER_EN;
>>>> -	writel_relaxed(val, pc->base + PWM_CTRL);
>>>> +	pc->data->set_enable(chip, true);
>>>>
>>>>    	return 0;
>>>>    
>>>>    }
>>>>
>>>> @@ -92,11 +163,8 @@ static int rockchip_pwm_enable(struct pwm_chip *chip,
>>>> struct pwm_device *pwm) static void rockchip_pwm_disable(struct pwm_chip
>>>> *chip, struct pwm_device *pwm) {
>>>>
>>>>    	struct rockchip_pwm_chip *pc = to_rockchip_pwm_chip(chip);
>>>>
>>>> -	u32 val;
>>>>
>>>> -	val = readl_relaxed(pc->base + PWM_CTRL);
>>>> -	val &= ~(PWM_CTRL_OUTPUT_EN | PWM_CTRL_TIMER_EN);
>>>> -	writel_relaxed(val, pc->base + PWM_CTRL);
>>>> +	pc->data->set_enable(chip, false);
>>>>
>>>>    	clk_disable(pc->clk);
>>>>    
>>>>    }
>>>>
>>>> @@ -108,12 +176,52 @@ static const struct pwm_ops rockchip_pwm_ops = {
>>>>
>>>>    	.owner = THIS_MODULE,
>>>>    
>>>>    };
>>>>
>>>> +static const struct rockchip_pwm_data pwm_data_v1 = {
>>>> +	.regs.duty = PWM_HRC,
>>>> +	.regs.period = PWM_LRC,
>>>> +	.regs.cntr = PWM_CNTR,
>>>> +	.regs.ctrl = PWM_CTRL,
>>>> +	.prescaler = PRESCALER,
>>>> +	.set_enable = rockchip_pwm_set_enable_v1,
>>>> +};
>>>> +
>>>> +static const struct rockchip_pwm_data pwm_data_v2 = {
>>>> +	.regs.duty = PWM_LRC,
>>>> +	.regs.period = PWM_HRC,
>>>> +	.regs.cntr = PWM_CNTR,
>>>> +	.regs.ctrl = PWM_CTRL,
>>>> +	.prescaler = PRESCALER-1,
>>>> +	.set_enable = rockchip_pwm_set_enable_v2,
>>>> +};
>>>> +
>>>> +static const struct rockchip_pwm_data pwm_data_vop = {
>>>> +	.regs.duty = PWM_LRC,
>>>> +	.regs.period = PWM_HRC,
>>>> +	.regs.cntr = PWM_CTRL,
>>>> +	.regs.ctrl = PWM_CNTR,
>>>> +	.prescaler = PRESCALER-1,
>>>> +	.set_enable = rockchip_pwm_set_enable_vop,
>>>> +};
>>>> +
>>>> +static const struct of_device_id rockchip_pwm_dt_ids[] = {
>>>> +	{ .compatible = "rockchip,rk2928-pwm", .data = &pwm_data_v1},
>>>> +	{ .compatible = "rockchip,rk3288-pwm", .data = &pwm_data_v2},
>>>> +	{ .compatible = "rockchip,vop-pwm", .data = &pwm_data_vop},
>>>> +	{ /* sentinel */ }
>>>> +};
>>>> +MODULE_DEVICE_TABLE(of, rockchip_pwm_dt_ids);
>>>> +
>>>>
>>>>    static int rockchip_pwm_probe(struct platform_device *pdev)
>>>>    {
>>>>
>>>> +	const struct of_device_id *id;
>>>>
>>>>    	struct rockchip_pwm_chip *pc;
>>>>    	struct resource *r;
>>>>    	int ret;
>>>>
>>>> +	id = of_match_device(rockchip_pwm_dt_ids, &pdev->dev);
>>>> +	if (!id)
>>>> +		return -EINVAL;
>>>> +
>>>>
>>>>    	pc = devm_kzalloc(&pdev->dev, sizeof(*pc), GFP_KERNEL);
>>>>    	if (!pc)
>>>>    	
>>>>    		return -ENOMEM;
>>>>
>>>> @@ -133,6 +241,7 @@ static int rockchip_pwm_probe(struct platform_device
>>>> *pdev)
>>>>
>>>>    	platform_set_drvdata(pdev, pc);
>>>>
>>>> +	pc->data = id->data;
>>>>
>>>>    	pc->chip.dev = &pdev->dev;
>>>>    	pc->chip.ops = &rockchip_pwm_ops;
>>>>    	pc->chip.base = -1;
>>>>
>>>> @@ -156,12 +265,6 @@ static int rockchip_pwm_remove(struct
>>>> platform_device
>>>> *pdev) return pwmchip_remove(&pc->chip);
>>>>
>>>>    }
>>>>
>>>> -static const struct of_device_id rockchip_pwm_dt_ids[] = {
>>>> -	{ .compatible = "rockchip,rk2928-pwm" },
>>>> -	{ /* sentinel */ }
>>>> -};
>>>> -MODULE_DEVICE_TABLE(of, rockchip_pwm_dt_ids);
>>>> -
>>>>
>>>>    static struct platform_driver rockchip_pwm_driver = {
>>>>    
>>>>    	.driver = {
>>>>    	
>>>>    		.name = "rockchip-pwm",
>
>
>


