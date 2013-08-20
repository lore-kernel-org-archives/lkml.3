Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752063Ab3HTEDa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Aug 2013 00:03:30 -0400
Received: from nasmtp01.atmel.com ([192.199.1.245]:49314 "EHLO
	DVREDG01.corp.atmel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751804Ab3HTED3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Aug 2013 00:03:29 -0400
Message-ID: <5212EA88.1090100@atmel.com>
Date: Tue, 20 Aug 2013 12:03:20 +0800
From: Bo Shen <voice.shen@atmel.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:17.0) Gecko/20130801 Thunderbird/17.0.8
MIME-Version: 1.0
To: Thierry Reding <thierry.reding@gmail.com>
CC: <plagnioj@jcrosoft.com>, <nicolas.ferre@atmel.com>,
        <linux-pwm@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <devicetree@vger.kernel.org>
Subject: Re: [RFC PATCH] pwm: atmel-pwm: add pwm controller driver
References: <1376881866-14214-1-git-send-email-voice.shen@atmel.com> <20130819212054.GA9885@mithrandir>
In-Reply-To: <20130819212054.GA9885@mithrandir>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.168.5.13]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Thierry,

On 8/20/2013 05:20, Thierry Reding wrote:
> On Mon, Aug 19, 2013 at 11:11:06AM +0800, Bo Shen wrote:
>> add atmel pwm controller driver based on PWM framework
>>
>> this is basic function implementation of pwm controller
>> it can work with pwm based led and backlight
>
> Please use the proper spelling "PWM" in prose. Variable names and such
> should be "pwm", though. Also sentences should start with a capital
> letter and end with a full stop ('.').

I will do in next version.

>> Signed-off-by: Bo Shen <voice.shen@atmel.com>
>>
>> ---
>> This patch is based on Linux v3.11 rc6
>
> It's usually safer to work on top of the latest subsystem branch because
> it may contain patches that influence your patch as well. For most
> subsystems that branch is merged into linux-next, so that usually works
> well as the basis when writing patches.

For next version, I will base on for-next branch on Linux PWM tree

>> diff --git a/Documentation/devicetree/bindings/pwm/atmel-pwm.txt b/Documentation/devicetree/bindings/pwm/atmel-pwm.txt
> [...]
>> +  - #pwm-cells: Should be 3.
>> +    - The first cell specifies the per-chip index of the PWM to use
>> +    - The second cell is the period in nanoseconds
>> +    - The third cell is used to encode the polarity of PWM output
>
> For instance, patches were recently added to make the description of
> this property more consistent across the bindings documentation of PWM
> drivers. The more canonical form now is:
>
>   - #pwm-cells: Should be 3. See pwm.txt in this directory for a
>     description of the cells format.

Thanks, I will use this in next version.

>> diff --git a/drivers/pwm/pwm-atmel.c b/drivers/pwm/pwm-atmel.c
> [...]
>> +#define PWM_MR		0x00
>
> This doesn't seem to be used.

I will remove it in next version, If will it for new feature, I will add it.

>> +#define PWM_ENA		0x04
>> +#define PWM_DIS		0x08
>> +#define PWM_SR		0x0C
>
> Perhaps it'd be useful to add a comment that the above are global
> registers and the ones below are per-channel.

I will add the comments in next version.

>> +#define PWM_CMR		0x00
>> +
>> +/* The following register for PWM v1 */
>> +#define PWMv1_CDTY	0x04
>> +#define PWMv1_CPRD	0x08
>> +#define PWMv1_CUPD	0x10
>> +
>> +/* The following register for PWM v2 */
>> +#define PWMv2_CDTY	0x04
>> +#define PWMv2_CDTYUPD	0x08
>> +#define PWMv2_CPRD	0x0C
>> +#define PWMv2_CPRDUPD	0x10
>> +
>> +#define PWM_NUM		4
>
> The only place where this is used is in the .probe() function, so you
> can just as well drop it.

OK, I will hard code it in probe function.

>> +struct atmel_pwm_chip {
>> +	struct pwm_chip chip;
>> +	struct clk *clk;
>> +	void __iomem *base;
>> +
>> +	void (*config)(struct atmel_pwm_chip *chip, struct pwm_device *pwm,
>> +			unsigned int dty, unsigned int prd);
>
> Please use the same parameter names as the PWM core for consistency.

OK, I will use the same parameter names as the PWM core for consistency.

>> +};
>> +
>> +#define to_atmel_pwm_chip(chip) container_of(chip, struct atmel_pwm_chip, chip)
>
> This should be a static inline function so that types are properly
> checked

OK, I will change it as a static inline function.

>> +
>> +static inline u32 atmel_pwm_readl(struct atmel_pwm_chip *chip, int offset)
>
> "offset" is usually unsigned long.

OK, I will use unsigned long to define it. And change all related 
definition.

>> +{
>> +	return readl(chip->base + offset);
>> +}
>> +
>> +static inline void atmel_pwm_writel(struct atmel_pwm_chip *chip, int offset,
>> +		u32 val)
>
> And "value" is usually also unsigned long.
>
>> +{
>> +	writel(val, chip->base + offset);
>> +}
>> +
>> +static inline u32 atmel_pwm_ch_readl(struct atmel_pwm_chip *chip, int ch,
>> +		int offset)
>
> "channel" can be unsigned int, and "offset" unsigned long again. Also
> the alignment is wrong here. The arguments continued on a new line
> should be aligned with the arguments on the previous line.

I will fix the alignment in next version.

>> +static int atmel_pwm_config(struct pwm_chip *chip, struct pwm_device *pwm,
>> +		int duty_ns, int period_ns)
>> +{
>> +	struct atmel_pwm_chip *atmel_pwm = to_atmel_pwm_chip(chip);
>> +	unsigned long long val, prd, dty;
>> +	unsigned long long div, clk_rate;
>
> All of these unsigned long long can be declared on one line.

I will fix in next version.

>> +	int ret, pres = 0;
>> +
>> +	clk_rate = clk_get_rate(atmel_pwm->clk);
>> +
>> +	while (1) {
>> +		div = 1000000000;
>> +		div *= 1 << pres;
>> +		val = clk_rate * period_ns;
>> +		prd = div_u64(val, div);
>> +		val = clk_rate * duty_ns;
>> +		dty = div_u64(val, div);
>> +
>> +		if (prd < 0x0001 || dty < 0x0)
>> +			return -EINVAL;
>
> I find the usage of hexadecimal literals a bit strange here. Perhaps
> just change this to:
>
> 		if (prd < 1 || dty < 0)
>
>> +		if (prd > 0xffff || dty > 0xffff) {
>
> This makes some sense, because I would assume that these are restricted
> by register fields. Might be good to add a comment to that effect,
> though.

I will add the comments.

>> +			if (++pres > 0x10)
>> +				return -EINVAL;
>
> But here again, I think writing:
>
> 			if (++pres > 16)
>
> would be clearer.
>
>> +	/* Enable clock */
>> +	ret = clk_prepare_enable(atmel_pwm->clk);
>
> You should probably call clk_prepare() in .probe() already and only call
> clk_enable() here. The reason is that clk_get_rate() might actually fail
> if you haven't called clk_prepare() on it. Furthermore clk_prepare()
> potentially involves a lot more than clk_enable() so it makes sense to
> call it earlier, where the delay doesn't matter.

I will do this in next version.

>> +	if (ret) {
>> +		pr_err("failed to enable pwm clock\n");
>> +		return ret;
>> +	}
>> +
>> +	atmel_pwm->config(atmel_pwm, pwm, dty, prd);
>> +
>> +	/* Check whether need to disable clock */
>> +	val = atmel_pwm_readl(atmel_pwm, PWM_SR);
>> +	if ((val & 0xf) == 0)
>
> Can we have a symbolic name for the 0xf constant here?

I will use symbol to replace hard code.

>> +		clk_disable_unprepare(atmel_pwm->clk);
>
> Similarly this should just call clk_disable() and .remove() should call
> clk_unprepare().
>
>> +static void atmel_pwm_config_v1(struct atmel_pwm_chip *atmel_pwm,
>> +		struct pwm_device *pwm, unsigned int dty, unsigned int prd)
>
> Parameter alignment again.

OK.

>> +{
>> +	unsigned int val;
>> +
>> +	/*
>> +	 * if the pwm channel is enabled, using update register to update
>> +	 * related register value, or else write it directly
>> +	 */
>
> This comment is somewhat confusing, can you rewrite it to make it more
> clear what is meant?

I will make it more clearly.

>> +	if (test_bit(PWMF_ENABLED, &pwm->flags)) {
>> +		atmel_pwm_ch_writel(atmel_pwm, pwm->hwpwm, PWMv1_CUPD, dty);
>> +
>> +		val = atmel_pwm_ch_readl(atmel_pwm, pwm->hwpwm, PWM_CMR);
>> +		val &= ~(1 << 10);
>
> Symbolic constant for 1 << 10, please.

OK.

>> +		atmel_pwm_ch_writel(atmel_pwm, pwm->hwpwm, PWM_CMR, val);
>> +	} else {
>> +		atmel_pwm_ch_writel(atmel_pwm, pwm->hwpwm, PWMv1_CDTY, dty);
>> +		atmel_pwm_ch_writel(atmel_pwm, pwm->hwpwm, PWMv1_CPRD, prd);
>> +	}
>> +}
>> +
>> +static void atmel_pwm_config_v2(struct atmel_pwm_chip *atmel_pwm,
>> +		struct pwm_device *pwm, unsigned int dty, unsigned int prd)
>> +{
>> +	/*
>> +	 * if the pwm channel is enabled, using update register to update
>> +	 * related register value, or else write it directly
>> +	 */
>> +	if (test_bit(PWMF_ENABLED, &pwm->flags)) {
>> +		atmel_pwm_ch_writel(atmel_pwm, pwm->hwpwm, PWMv2_CDTYUPD, dty);
>> +		atmel_pwm_ch_writel(atmel_pwm, pwm->hwpwm, PWMv2_CPRDUPD, prd);
>> +	} else {
>> +		atmel_pwm_ch_writel(atmel_pwm, pwm->hwpwm, PWMv2_CDTY, dty);
>> +		atmel_pwm_ch_writel(atmel_pwm, pwm->hwpwm, PWMv2_CPRD, prd);
>> +	}
>> +}
>
> Same comments as for atmel_pwm_config_v1().
>
>> +
>> +static int atmel_pwm_set_polarity(struct pwm_chip *chip, struct pwm_device *pwm,
>> +		enum pwm_polarity polarity)
>> +{
>> +	struct atmel_pwm_chip *atmel_pwm = to_atmel_pwm_chip(chip);
>> +	u32 val = 0;
>> +	int ret;
>> +
>> +	/* Enable clock */
>> +	ret = clk_prepare_enable(atmel_pwm->clk);
>
> That comment doesn't add anything valuable. Also split clk_prepare() and
> clk_enable() again.
>
>> +	if (ret) {
>> +		pr_err("failed to enable pwm clock\n");
>> +		return ret;
>> +	}
>> +
>> +	if (polarity == PWM_POLARITY_NORMAL)
>> +		val &= ~(1 << 9);
>> +	else
>> +		val |= 1 << 9;
>
> 1 << 9 should be a symbolic constant.
>
>> +	atmel_pwm_ch_writel(atmel_pwm, pwm->hwpwm, PWM_CMR, val);
>> +
>> +	/* Disable clock */
>> +	clk_disable_unprepare(atmel_pwm->clk);
>
> That comment isn't useful either.

I will remove the comment.

>> +static void atmel_pwm_disable(struct pwm_chip *chip, struct pwm_device *pwm)
>> +{
>> +	struct atmel_pwm_chip *atmel_pwm = to_atmel_pwm_chip(chip);
>> +	u32 val;
>> +
>> +	atmel_pwm_writel(atmel_pwm, PWM_DIS, 1 << pwm->hwpwm);
>> +
>> +	/* Disable clock */
>> +	val = atmel_pwm_readl(atmel_pwm, PWM_SR);
>> +	if ((val & 0xf) == 0)
>> +		clk_disable_unprepare(atmel_pwm->clk);
>
> The intent of this would be much clearer if 0xf was a symbolic constant.
>
>> +}
>> +struct atmel_pwm_data {
>> +	void (*config)(struct atmel_pwm_chip *chip, struct pwm_device *pwm,
>> +			unsigned int dty, unsigned int prd);
>> +};
>
> I think it would be nicer to use the same parameter names as the PWM
> core uses.
>
>> +static struct atmel_pwm_data atmel_pwm_data_v1 = {
>> +	.config = atmel_pwm_config_v1,
>> +};
>> +
>> +static struct atmel_pwm_data atmel_pwm_data_v2 = {
>> +	.config = atmel_pwm_config_v2,
>> +};
>
> Can both of these not be "static const"?

OK.

>> +static const struct of_device_id atmel_pwm_dt_ids[] = {
>> +	{
>> +		.compatible = "atmel,at91sam9rl-pwm",
>> +		.data = &atmel_pwm_data_v1,
>> +	}, {
>> +		.compatible = "atmel,sama5-pwm",
>> +		.data = &atmel_pwm_data_v2,
>> +	}, {
>> +		/* sentinel */
>> +	},
>> +};
>> +MODULE_DEVICE_TABLE(of, atmel_pwm_dt_ids);
>
> Given that you use of_match_ptr() in the driver structure, you should
> probably protect this using #ifdef CONFIG_OF, otherwise non-OF builds
> will warn about this table being unused.

OK. I will add it.

>> +	pinctrl = devm_pinctrl_get_select_default(&pdev->dev);
>> +	if (IS_ERR(pinctrl)) {
>> +		dev_err(&pdev->dev, "failed get pinctrl\n");
>> +		return PTR_ERR(pinctrl);
>> +	}
>
> That should be taken care of by the core and therefore not needed to be
> done by the driver explicitly. When you remove this, make sure to remove
> the linux/pinctrl/consumer.h include along with it.

I will remove it.

>> +	atmel_pwm = devm_kzalloc(&pdev->dev, sizeof(*atmel_pwm), GFP_KERNEL);
>> +	if (!atmel_pwm) {
>> +		dev_err(&pdev->dev, "out of memory\n");
>> +		return -ENOMEM;
>> +	}
>
> I don't think that error message provides a lot of useful information.
> If the probe() function fails then the core will output an error message
> that includes the error code, so the reason for the failure can easily
> be reconstructed from that already.

OK, I will fix it.

>> +	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
>> +	if (!res) {
>> +		dev_err(&pdev->dev, "no memory resource defined\n");
>> +		return -ENODEV;
>> +	}
>
> devm_ioremap_resource() checks for the validity of the res parameter, so
> you can drop the checks here.
>
>> +	atmel_pwm->base = devm_ioremap_resource(&pdev->dev, res);
>> +	if (IS_ERR(atmel_pwm->base)) {
>> +		dev_err(&pdev->dev, "ioremap failed\n");
>
> devm_ioremap_resource() provides it's own error messages, so you don't
> have to duplicate it here.

I will remove it.

>> +	atmel_pwm->clk = devm_clk_get(&pdev->dev, "pwm_clk");
>
> If this is the only clock that the driver uses, why do you need to
> specify the consumer ID at all? Doesn't a simple:
>
> 	atmel_pwm->clk = devm_clk_get(&pdev->dev, NULL);
>
> work?

It works.

>> +	dev_info(&pdev->dev, "successfully register pwm\n");
>
> That's not necessary. You should provide an error message if probing
> failed. If everything went as expected there's no need to be verbose.
>
>> +MODULE_LICENSE("GPL v2");
>
> I think that "GPL v2" means "GPL v2", not "GPL v2 (and later)" and
> therefore is in conflict with the license note in the file header.
>
> Thierry
>

Best Regards,
Bo Shen

