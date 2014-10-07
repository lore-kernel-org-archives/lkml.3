Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752667AbaJGDfd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Oct 2014 23:35:33 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:55378 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751380AbaJGDfc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Oct 2014 23:35:32 -0400
Message-ID: <54335F80.9050005@wwwdotorg.org>
Date: Mon, 06 Oct 2014 20:35:28 -0700
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.1.2
MIME-Version: 1.0
To: Bart Tanghe <bart.tanghe@thomasmore.be>, thierry.reding@gmail.com
CC: matt.porter@linaro.org, linux-kernel@vger.kernel.org,
        linux-pwm@vger.kernel.org, linux-rpi-kernel@lists.infradead.org
Subject: Re: [resend rfc v5]pwm: add BCM2835 PWM driver
References: <1412250075-3082-1-git-send-email-bart.tanghe@thomasmore.be>
In-Reply-To: <1412250075-3082-1-git-send-email-bart.tanghe@thomasmore.be>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/02/2014 04:41 AM, Bart Tanghe wrote:
> Add pwm driver for Broadcom BCM2835 processor (Raspberry Pi)
> 
> Signed-off-by: Bart Tanghe <bart.tanghe@thomasmore.be>
> ---
> Changes in v5:

By v5, I would drop "rfc" from the email subject.

> diff --git a/Documentation/devicetree/bindings/pwm/pwm-bcm2835.txt b/Documentation/devicetree/bindings/pwm/pwm-bcm2835.txt

> +Required properties:
> +- compatible: should be "brcm,bcm2835-pwm"
> +- reg: physical base address and length of the controller's registers

You need to document the clocks property here too.

> +Examples:
> +
> +pwm@2020c000 {
> +	compatible = "brcm,bcm2835-pwm";
> +	reg = <0x2020c000 0x28>;
> +	clocks = <&clk_pwm>;
> +};
>
> +clocks {
> +	....
> +		clk_pwm: pwm {
> +			compatible = "fixed-clock";
> +			reg = <3>;
> +			#clock-cells = <0>;
> +			clock-frequency = <9200000>;
> +		};
> +	....
> +};

You typically wouldn't bother including an example for the nodes
references by phandles, but it's not a big deal.

> diff --git a/drivers/pwm/Kconfig b/drivers/pwm/Kconfig

> +config PWM_BCM2835
> +	tristate "BCM2835 PWM support"
> +	depends on MACH_BCM2835 || MACH_BCM2708

There is no MACH_BCM2708 in the mainline kernel, just MACH_BCM2835.
Actually, it looks like that should be ARCH_BCM2835 not MACH_BCM2835.

> diff --git a/drivers/pwm/pwm-bcm2835.c b/drivers/pwm/pwm-bcm2835.c

> +static int bcm2835_pwm_request(struct pwm_chip *chip, struct pwm_device *pwm)
> +{
> +	struct bcm2835_pwm *pc = to_bcm2835_pwm(chip);
> +	u32 value;
> +
> +	value = readl(pc->base);
> +	value &= ~(PWM_CONTROL_MASK << PWM_CONTROL_STRIDE * pwm->pwm);
> +	value |= (PWM_MODE << (PWM_CONTROL_STRIDE * pwm->pwm));
> +	writel(value, pc->base);
> +	return 0;
> +}
> +
> +static void bcm2835_pwm_free(struct pwm_chip *chip, struct pwm_device *pwm)
> +{
> +	struct bcm2835_pwm *pc = to_bcm2835_pwm(chip);
> +	u32 value;
> +
> +	value = readl(pc->base)
> +	value &= ~(PWM_CONTROL_MASK << PWM_CONTROL_STRIDE * pwm->pwm);
> +	value &= (~DEFAULT << (PWM_CONTROL_STRIDE * pwm->pwm));

What is this second mask operation intended to do? The first mask
operation already clears all the control bits, so clearing them again
doesn't seem useful.


> +static int bcm2835_pwm_config(struct pwm_chip *chip, struct pwm_device *pwm,
> +			      int duty_ns, int period_ns)
> +{
> +	struct bcm2835_pwm *pc = to_bcm2835_pwm(chip);
> +
> +	if (period_ns <= MIN_PERIOD) {
> +		dev_err(pc->dev, "Period not supported\n");
> +		return -EINVAL;
> +	} else {

There's no need for the else { here; simply close the if with }, and put
the rest of the code at the top-level of the function.

> +		writel(duty_ns / pc->scaler,
> +			 pc->base + DUTY + pwm->pwm * CHANNEL);
> +		writel(period_ns / pc->scaler,
> +			pc->base + PERIOD + pwm->pwm * CHANNEL);

It looks like CHANNEL should be CHANNEL_STRIDE?

> +static void bcm2835_pwm_disable(struct pwm_chip *chip,
> +				struct pwm_device *pwm)
...
> +	value &= ~(PWM_ENABLE << (PWM_CONTROL_STRIDE * pwm->pwm));

It's not a big deal, but this code has brackets around <<
(PWM_CONTROL_STRIDE * pwm->pwm), but other places don't.

> +static int bcm2835_set_polarity(struct pwm_chip *chip, struct pwm_device *pwm,
> +				enum pwm_polarity polarity)
> +{
> +	struct bcm2835_pwm *pc = to_bcm2835_pwm(chip);
> +	u32 value;
> +
> +	if (polarity == PWM_POLARITY_NORMAL) {
> +		value = readl(pc->base);
> +		value &= ~(PWM_POLARITY << PWM_CONTROL_STRIDE * pwm->pwm);
> +	} else if (polarity == PWM_POLARITY_INVERSED) {
> +		value = readl(pc->base);
> +		value |= PWM_POLARITY << (PWM_CONTROL_STRIDE * pwm->pwm);
> +	}

The readl() call is identical in both branches; it can come before the if.

> +static int bcm2835_pwm_probe(struct platform_device *pdev)

> +	pwm->clk = clk;
> +	ret = clk_prepare_enable(pwm->clk);
> +	if (ret)
> +		return ret;

The error paths after this point don't call clk_disable_unprepare().
Perhaps there's a devm_clk_prepare_enable() you can use to solve this,
or the error handling paths need to do more.

> +	pwm->scaler = NSEC_PER_SEC / clk_get_rate(clk);
> +
> +	r = platform_get_resource(pdev, IORESOURCE_MEM, 0);
> +	pwm->base = devm_ioremap_resource(&pdev->dev, r);
> +	if (IS_ERR(pwm->base))
> +		return PTR_ERR(pwm->base);

> +	platform_set_drvdata(pdev, pwm);

Personally, I'd put that right after pwm is allocated, but it's not a
big deal.
