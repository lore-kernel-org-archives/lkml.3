Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753167Ab3LCDQ6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Dec 2013 22:16:58 -0500
Received: from nasmtp01.atmel.com ([192.199.1.245]:23622 "EHLO
	DVREDG01.corp.atmel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751025Ab3LCDQ4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Dec 2013 22:16:56 -0500
X-Greylist: delayed 305 seconds by postgrey-1.27 at vger.kernel.org; Mon, 02 Dec 2013 22:16:56 EST
Message-ID: <529D4B58.9020700@atmel.com>
Date: Tue, 3 Dec 2013 11:09:12 +0800
From: Bo Shen <voice.shen@atmel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: Thierry Reding <thierry.reding@gmail.com>
CC: Bo Shen <voice.shen@atmel.com>, <linux-pwm@vger.kernel.org>,
        <devicetree@vger.kernel.org>, <nicolas.ferre@atmel.com>,
        <linux-kernel@vger.kernel.org>, <alexandre.belloni@free-electrons.com>,
        <galak@codeaurora.org>, <plagnioj@jcrosoft.com>,
        <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH v8 1/2] PWM: atmel-pwm: add PWM controller driver
References: <1384766002-2852-1-git-send-email-voice.shen@atmel.com> <20131202105957.GD18060@ulmo.nvidia.com>
In-Reply-To: <20131202105957.GD18060@ulmo.nvidia.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.168.5.13]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Thierry,

On 12/02/2013 06:59 PM, Thierry Reding wrote:
> On Mon, Nov 18, 2013 at 05:13:21PM +0800, Bo Shen wrote:
> [...]
>> diff --git a/drivers/pwm/pwm-atmel.c b/drivers/pwm/pwm-atmel.c
> [...]
>> +/* Max value for duty and period
>
> Block comments should be of this form:
>
> 	/*
> 	 * Max value ...
> 	 * ...
> 	 */

OK, I will use this style.

>> +static int atmel_pwm_config(struct pwm_chip *chip, struct pwm_device *pwm,
>> +		int duty_ns, int period_ns)
>> +{
>> +	struct atmel_pwm_chip *atmel_pwm = to_atmel_pwm_chip(chip);
>> +	unsigned long clk_rate, prd, dty;
>> +	unsigned long long div;
>> +	int ret, pres = 0;
>> +
>> +	clk_rate = clk_get_rate(atmel_pwm->clk);
>> +	div = clk_rate;
>> +
>> +	/* Calculate the period cycles */
>> +	while (div > PWM_MAX_PRD) {
>> +		div = clk_rate / (1 << pres);
>> +		div = div * period_ns;
>> +		/* 1/Hz = 100000000 ns */
>
> I don't think that comment is needed.

This is asked to be added.
And, I think keep it and it won't hurt, what do you think?

>> +		do_div(div, 1000000000);
>> +
>> +		if (pres++ > PRD_MAX_PRES) {
>> +			dev_err(chip->dev, "pres exceed the maximum value\n");
>
> "exceeds"

Thanks for correct it.

>> +			return -EINVAL;
>> +		}
>> +	}
>> +
>> +	/* Calculate the duty cycles */
>> +	prd = div;
>> +	div *= duty_ns;
>> +	do_div(div, period_ns);
>> +	dty = div;
>> +
>> +	ret = clk_enable(atmel_pwm->clk);
>> +	if (ret) {
>> +		dev_err(chip->dev, "failed to enable pwm clock\n");
>
> "PWM clock"

OK, I will change all low case pwm to upper case PWM.

>> +static void atmel_pwm_config_v1(struct pwm_chip *chip, struct pwm_device *pwm,
>> +				int dty, int prd)
>> +{
>> +	struct atmel_pwm_chip *atmel_pwm = to_atmel_pwm_chip(chip);
>> +	unsigned int val;
>> +
>> +	/*
>> +	 * If the PWM channel is disabled, write value to duty and period
>> +	 * registers directly.
>> +	 * If the PWM channel is enabled, using the update register, it needs
>> +	 * to set bit 10 of CMR to 0
>> +	 */
>
> I think it would make sense to split this comment and move each part
> into the respective conditional branch.

OK, I will split them.

>> +	if (test_bit(PWMF_ENABLED, &pwm->flags)) {
>> +		atmel_pwm_ch_writel(atmel_pwm, pwm->hwpwm, PWMV1_CUPD, dty);
>> +
>> +		val = atmel_pwm_ch_readl(atmel_pwm, pwm->hwpwm, PWM_CMR);
>> +		val &= ~PWM_CMR_UPD_CDTY;
>> +		atmel_pwm_ch_writel(atmel_pwm, pwm->hwpwm, PWM_CMR, val);
>> +	} else {
>> +		atmel_pwm_ch_writel(atmel_pwm, pwm->hwpwm, PWMV1_CDTY, dty);
>> +		atmel_pwm_ch_writel(atmel_pwm, pwm->hwpwm, PWMV1_CPRD, prd);
>> +	}
>> +}
>> +
>> +static void atmel_pwm_config_v2(struct pwm_chip *chip, struct pwm_device *pwm,
>> +				int dty, int prd)
>> +{
>> +	struct atmel_pwm_chip *atmel_pwm = to_atmel_pwm_chip(chip);
>> +
>> +	/*
>> +	 * If the PWM channel is disabled, write value to duty and period
>> +	 * registers directly.
>> +	 * If the PWM channel is enabled, using the duty update register to
>> +	 * update the value.
>> +	 */
>
> Same here.
>
>> +	if (test_bit(PWMF_ENABLED, &pwm->flags)) {
>> +		atmel_pwm_ch_writel(atmel_pwm, pwm->hwpwm, PWMV2_CDTYUPD, dty);
>> +	} else {
>> +		atmel_pwm_ch_writel(atmel_pwm, pwm->hwpwm, PWMV2_CDTY, dty);
>> +		atmel_pwm_ch_writel(atmel_pwm, pwm->hwpwm, PWMV2_CPRD, prd);
>> +	}
>> +}
>
> Neither version 1 nor version 2 seem to be able to change the period
> while the channel is enabled. Perhaps that should be checked for in
> atmel_pwm_config() and an error (-EBUSY) returned?

The period is configured in dt in device tree, or platform data in non 
device tree. Nowhere will update period. So, not code to update period.
Am I right? If not, please figure out.

>> +
>> +static int atmel_pwm_set_polarity(struct pwm_chip *chip, struct pwm_device *pwm,
>> +		enum pwm_polarity polarity)
>> +{
>> +	struct atmel_pwm_chip *atmel_pwm = to_atmel_pwm_chip(chip);
>> +	u32 val = 0;
>> +	int ret;
>> +
>> +	if (polarity == PWM_POLARITY_NORMAL)
>> +		val &= ~PWM_CMR_CPOL;
>> +	else
>> +		val |= PWM_CMR_CPOL;
>
> I think I've mentioned this before, but val is always assigned to 0, so
> clearing a bit is a superfluous. Perhaps you need to readl the CMR
> register first before toggling the bit here?

Thanks, we should read CMR, and set the CPOL accordingly.

>> +
>> +	ret = clk_enable(atmel_pwm->clk);
>> +	if (ret) {
>> +		dev_err(chip->dev, "failed to enable pwm clock\n");
>
> "PWM clock"
>
>> +#ifdef CONFIG_OF
>> +static const struct of_device_id atmel_pwm_dt_ids[] = {
>> +	{
>> +		.compatible = "atmel,at91sam9rl-pwm",
>> +		.data = &atmel_pwm_data_v1,
>> +	}, {
>> +		.compatible = "atmel,sama5d3-pwm",
>> +		.data = &atmel_pwm_data_v2,
>> +	}, {
>> +		/* sentinel */
>> +	},
>> +};
>> +MODULE_DEVICE_TABLE(of, atmel_pwm_dt_ids);
>> +#endif
>
> I don't think you can do this. You use this table in a call to
> of_match_device() later on, in code which isn't protected by a
> corresponding #ifdef.

I will remove #ifdef.

>> +static inline const struct atmel_pwm_data * __init
>> +	atmel_pwm_get_driver_data(struct platform_device *pdev)
>
> I don't think __init is warranted here. In fact I think this will give
> you a build warning, because this code is called from atmel_pwm_probe(),
> which in turn isn't marked __init.

OK, I will remove __init.

> Also it's probably not worth marking this inline explicitly. It isn't
> all that short, and the compiler will likely inline it anyway since it's
> only called once.

It only called one, so, it can be inline.

>> +{
>> +	if (pdev->dev.of_node) {
>> +		const struct of_device_id *match;
>> +		match = of_match_device(atmel_pwm_dt_ids, &pdev->dev);
>
> Blank line between the above two for readability.

OK, I will add one blank line.

>> +		if (match == NULL)
>> +			return NULL;
>> +		return match->data;
>
> Same here. And "if (!match)" rather than "if (match == NULL)".

OK, I will change like this.

>> +	}
>> +
>> +	return (struct atmel_pwm_data *)
>> +		platform_get_device_id(pdev)->driver_data;
>
> Please use a temporary variable here to make this more readable, like
> so:
>
> 	struct platform_device_id *id = platform_get_device_id(pdev);
>
> 	...
>
> 	return (struct atmel_pwm_data *)id->driver;
>
>> +}

OK, I will change like this.

>> +static int atmel_pwm_probe(struct platform_device *pdev)
>> +{
>> +	const struct atmel_pwm_data *data;
>> +	struct atmel_pwm_chip *atmel_pwm;
>> +	struct resource *res;
>> +	int ret;
>> +
>> +	atmel_pwm = devm_kzalloc(&pdev->dev, sizeof(*atmel_pwm), GFP_KERNEL);
>> +	if (!atmel_pwm)
>> +		return -ENOMEM;
>
> You could move this further down, so that memory doesn't get allocated
> if atmel_pwm_get_driver_data() or platform_get_resource() fails.

OK, I will move this down.

>> +
>> +	data = atmel_pwm_get_driver_data(pdev);
>> +	if (!data)
>> +		return -ENODEV;
>> +
>> +	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
>> +	if (!res)
>> +		return -ENODEV;
>
> No need to check the return value here. devm_ioremap_resource() checks
> it for you.

OK, I will remove this check.

>> +
>> +	atmel_pwm->base = devm_ioremap_resource(&pdev->dev, res);
>> +	if (IS_ERR(atmel_pwm->base))
>> +		return PTR_ERR(atmel_pwm->base);
>> +
>> +	atmel_pwm->clk = devm_clk_get(&pdev->dev, NULL);
>> +	if (IS_ERR(atmel_pwm->clk))
>> +		return PTR_ERR(atmel_pwm->clk);
>> +
>> +	ret = clk_prepare(atmel_pwm->clk);
>> +	if (ret) {
>> +		dev_err(&pdev->dev, "failed to prepare pwm clock\n");
>
> "PWM clock"
>
>> +		return ret;
>> +	}
>> +
>> +	atmel_pwm->chip.dev = &pdev->dev;
>> +	atmel_pwm->chip.ops = &atmel_pwm_ops;
>> +	if (pdev->dev.of_node) {
>
> Blank line between the above two for readability.

OK, I will add blank line.

>> +		atmel_pwm->chip.of_xlate = of_pwm_xlate_with_flags;
>> +		atmel_pwm->chip.of_pwm_n_cells = 3;
>> +		atmel_pwm->chip.base = -1;
>> +	} else {
>> +		atmel_pwm->chip.base = pdev->id;
>
> That's not correct. The chip cannot be tied to pdev->id, because that ID
> is the instance number of the device. So typically you would have
> devices name like this:
>
> 	atmel-pwm.0
> 	atmel-pwm.1
> 	...
>
> Now, if you have that, then you won't be able to register the second
> instance because the first instance will already have requested PWMs
> 0-3, and setting .base to 1 will cause PWMs 1-4 to be requested, which
> intersects with the range of the first instance.
>
> The same applies of course if you have other PWM controllers in the
> system which have similar instance names.
>
> So the right thing to do here is to provide that number via platform
> data so that platform code can define it, knowing in advance all ranges
> for all other PWM controllers and thereby make sure there's no
> intersection.

OK, I will fix this.

>> +	}
>> +	atmel_pwm->chip.npwm = 4;
>
> Blank line between the above two for readability.

OK, I will add blank line.

>> +	atmel_pwm->config = data->config;
>> +
>> +	ret = pwmchip_add(&atmel_pwm->chip);
>> +	if (ret < 0) {
>> +		dev_err(&pdev->dev, "failed to add pwm chip %d\n", ret);
>
> "PWM chip"
>
> Thierry

Best Regards,
Bo Shen

