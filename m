Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753530Ab3KYLJq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Nov 2013 06:09:46 -0500
Received: from mail-bk0-f49.google.com ([209.85.214.49]:57517 "EHLO
	mail-bk0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751994Ab3KYLJm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Nov 2013 06:09:42 -0500
Date: Mon, 25 Nov 2013 12:08:56 +0100
From: Thierry Reding <thierry.reding@gmail.com>
To: Tim Kryger <tim.kryger@linaro.org>
Cc: Rob Herring <rob.herring@calxeda.com>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Rob Landley <rob@landley.net>, Christian Daudt <bcm@fixthebug.org>,
        Grant Likely <grant.likely@linaro.org>,
        Linux PWM List <linux-pwm@vger.kernel.org>,
        Device Tree List <devicetree@vger.kernel.org>,
        Linux Doc List <linux-doc@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Broadcom Kernel Feedback List 
	<bcm-kernel-feedback-list@broadcom.com>,
        Linux ARM Kernel List <linux-arm-kernel@lists.infradead.org>,
        Linaro Patches List <patches@linaro.org>
Subject: Re: [PATCH 2/5] pwm: kona: Introduce Kona PWM controller support
Message-ID: <20131125110854.GI22043@ulmo.nvidia.com>
References: <1384800901-21711-1-git-send-email-tim.kryger@linaro.org>
 <1384800901-21711-3-git-send-email-tim.kryger@linaro.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="uJWb33pM2TcUAXIl"
Content-Disposition: inline
In-Reply-To: <1384800901-21711-3-git-send-email-tim.kryger@linaro.org>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--uJWb33pM2TcUAXIl
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Nov 18, 2013 at 10:54:58AM -0800, Tim Kryger wrote:
[...]
> diff --git a/drivers/pwm/Kconfig b/drivers/pwm/Kconfig
[...]
> +config PWM_BCM_KONA
> +	tristate "Kona PWM support"
> +	depends on ARCH_BCM_MOBILE
> +	default y

Why do you want this to be the default? Shouldn't this be something that
a default configuration selects explicitly?

> diff --git a/drivers/pwm/Makefile b/drivers/pwm/Makefile
[...]
>  obj-$(CONFIG_PWM_BFIN)		+= pwm-bfin.o
> +obj-$(CONFIG_PWM_BCM_KONA)	+= pwm-bcm-kona.o

'C' < 'F'

> diff --git a/drivers/pwm/pwm-bcm-kona.c b/drivers/pwm/pwm-bcm-kona.c
[...]
> +#include <linux/clk.h>
> +#include <linux/err.h>
> +#include <linux/io.h>
> +#include <linux/ioport.h>
> +#include <linux/math64.h>
> +#include <linux/module.h>
> +#include <linux/of.h>
> +#include <linux/platform_device.h>
> +#include <linux/pwm.h>
> +#include <linux/slab.h>
> +#include <linux/types.h>
> +
> +#define KONA_PWM_CHANNEL_CNT		6

You use this exactly once, so there's no need for this define.

> +#define PWM_CONTROL_OFFSET		(0x00000000)

I'd prefer if you dropped the _OFFSET suffix here.

> +#define PWM_CONTROL_INITIAL		(0x3f3f3f00)

Can this not be expressed as a bitmask of values for the individual
fields.

> +#define PWMOUT_POLARITY(chan)		(0x1 << (8 + chan))

This seems to only account for bits 8-13, what about the others?

> +#define PWMOUT_ENABLE(chan)		(0x1 << chan)

Well, this accounts for bits 0-5, that still leaves 16-21 and 24-29.

Also perhaps PWMOUT_POLARITY and PWMOUT_ENABLE should be defined as
PWM_CONTROL_POLARITY and PWM_CONTROL_ENABLE. That makes it easy to see
which register they are related to.

> +#define PRESCALE_OFFSET			(0x00000004)
> +#define PRESCALE_SHIFT(chan)		(chan << 2)

I'm confused. This allocates 2 bits for each channel...

> +#define PRESCALE_MASK(chan)		(~(0x7 << (chan << 2)))
> +#define PRESCALE_MIN			(0x00000000)
> +#define PRESCALE_MAX			(0x00000007)

... but 0x7 requires at least 3 bits.

> +#define PERIOD_COUNT_OFFSET(chan)	(0x00000008 + (chan << 3))
> +#define PERIOD_COUNT_MIN		(0x00000002)
> +#define PERIOD_COUNT_MAX		(0x00ffffff)

Why PERIOD_COUNT? PERIOD is descriptive enough. Or is this the name as
found in the manual?

> +#define DUTY_CYCLE_HIGH_OFFSET(chan)	(0x0000000c + (chan << 3))
> +#define DUTY_CYCLE_HIGH_MIN		(0x00000000)
> +#define DUTY_CYCLE_HIGH_MAX		(0x00ffffff)

By definition the duty-cycle is where the signal is high. Again, if this
is how the manual names the registers it's fine.

> +struct kona_pwmc {
> +	struct pwm_chip chip;
> +	void __iomem *base;
> +	struct clk *clk;
> +};
> +
> +static void kona_pwmc_apply_settings(struct kona_pwmc *kp, int chan)

unsigned int for "chan"?

> +{
> +	/* New settings take effect on rising edge of enable  bit */
> +	writel(readl(kp->base + PWM_CONTROL_OFFSET) & ~PWMOUT_ENABLE(chan),
> +	       kp->base + PWM_CONTROL_OFFSET);
> +	writel(readl(kp->base + PWM_CONTROL_OFFSET) | PWMOUT_ENABLE(chan),
> +	       kp->base + PWM_CONTROL_OFFSET);

That's too cluttered for my taste. Please make this more explicit:

	value = readl(...);
	value &= ~...;
	writel(value, ...);

	value = readl(...);
	value |= ...;
	writel(value, ...);

> +}
> +
> +static int kona_pwmc_config(struct pwm_chip *chip, struct pwm_device *pwm,
> +				int duty_ns, int period_ns)
> +{
> +	struct kona_pwmc *kp = dev_get_drvdata(chip->dev);
> +	u64 val, div, clk_rate;
> +	unsigned long prescale = PRESCALE_MIN, pc, dc;
> +	int chan = pwm->hwpwm;

pwm->hwpwm is unsigned, so chan should be as well.

> +
> +	/*
> +	 * Find period count, duty count and prescale to suit duty_ns and
> +	 * period_ns. This is done according to formulas described below:
> +	 *
> +	 * period_ns = 10^9 * (PRESCALE + 1) * PC / PWM_CLK_RATE
> +	 * duty_ns = 10^9 * (PRESCALE + 1) * DC / PWM_CLK_RATE
> +	 *
> +	 * PC = (PWM_CLK_RATE * period_ns) / (10^9 * (PRESCALE + 1))
> +	 * DC = (PWM_CLK_RATE * duty_ns) / (10^9 * (PRESCALE + 1))
> +	 */
> +
> +	clk_rate = clk_get_rate(kp->clk);
> +	while (1) {

Newline between the above two lines please.

> +		div = 1000000000;
> +		div *= 1 + prescale;
> +		val = clk_rate * period_ns;
> +		pc = div64_u64(val, div);
> +		val = clk_rate * duty_ns;
> +		dc = div64_u64(val, div);
> +
> +		/* If duty_ns or period_ns are not achievable then return */
> +		if (pc < PERIOD_COUNT_MIN || dc < DUTY_CYCLE_HIGH_MIN)
> +			return -EINVAL;
> +
> +		/*
> +		 * If pc or dc have crossed their upper limit, then increase
> +		 * prescale and recalculate pc and dc.
> +		 */
> +		if (pc > PERIOD_COUNT_MAX || dc > DUTY_CYCLE_HIGH_MAX) {
> +			if (++prescale > PRESCALE_MAX)
> +				return -EINVAL;
> +			continue;
> +		}

This looks unintuitive to me, perhaps:

		if (pc <= PERIOD_COUNT_MAX && dc <= DUTY_CYCLE_HIGH_MAX)
			break;

		if (++prescale > PRESCALE_MAX)
			return -EINVAL;

?

> +	/* Program prescale */
> +	writel((readl(kp->base + PRESCALE_OFFSET) & PRESCALE_MASK(chan)) |
> +	       prescale << PRESCALE_SHIFT(chan),
> +	       kp->base + PRESCALE_OFFSET);

Again, please split this into separate read/modify/write steps.

> +
> +	/* Program period count */
> +	writel(pc, kp->base + PERIOD_COUNT_OFFSET(chan));
> +
> +	/* Program duty cycle high count */
> +	writel(dc, kp->base + DUTY_CYCLE_HIGH_OFFSET(chan));

I don't think we need the comments. The register names are fairly
descriptive, so the comments add no value.

> +
> +	if (test_bit(PWMF_ENABLED, &pwm->flags))
> +		kona_pwmc_apply_settings(kp, chan);
> +
> +	return 0;
> +}
> +
> +static int kona_pwmc_enable(struct pwm_chip *chip, struct pwm_device *pwm)
> +{
> +	return kona_pwmc_config(chip, pwm, pwm->duty_cycle, pwm->period);
> +}

Why can't this just enable the channel? Why go through all the trouble
of running the whole computations again?

> +
> +static void kona_pwmc_disable(struct pwm_chip *chip, struct pwm_device *pwm)
> +{
> +	struct kona_pwmc *kp = dev_get_drvdata(chip->dev);
> +	int chan = pwm->hwpwm;
> +
> +	/*
> +	 * The PWM hardware lacks a proper way to be disabled so
> +	 * we just program zero duty cycle high count instead
> +	 */

So clearing the enable bit doesn't disable the PWM channel?

> +
> +	writel(0, kp->base + DUTY_CYCLE_HIGH_OFFSET(chan));
> +	kona_pwmc_apply_settings(kp, chan);
> +}
> +
> +static const struct pwm_ops kona_pwm_ops = {
> +	.config = kona_pwmc_config,
> +	.owner = THIS_MODULE,
> +	.enable = kona_pwmc_enable,
> +	.disable = kona_pwmc_disable,
> +};

Please move the .owner field to be the last field. Also you did define
the PWMOUT_POLARITY field, which indicates that the hardware supports
changing the signal's polarity, yet you don't implement the polarity
feature. Why not?

> +static int kona_pwmc_probe(struct platform_device *pdev)
> +{
> +	struct kona_pwmc *kp;
> +	struct resource *res;
> +	int ret = 0;

I don't think this needs to be initialized.

> +
> +	dev_dbg(&pdev->dev, "bcm_kona_pwmc probe\n");

Can this be removed?

> +
> +	kp = devm_kzalloc(&pdev->dev, sizeof(*kp), GFP_KERNEL);
> +	if (kp == NULL)
> +		return -ENOMEM;
> +
> +	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
> +	kp->base = devm_ioremap_resource(&pdev->dev, res);
> +	if (IS_ERR(kp->base))
> +		return PTR_ERR(kp->base);
> +
> +	kp->clk = devm_clk_get(&pdev->dev, NULL);
> +	if (IS_ERR(kp->clk)) {
> +		dev_err(&pdev->dev, "Clock get failed : Err %d\n", ret);

ret would be 0 here, indicating no error. This should probably be
PTR_ERR(kp->clk). Also please make the error message more consistent,
this one and the one below use completely different styles. Also, "Err"
isn't very useful in an error message. Something like:

		dev_err(&pdev->dev, "failed to get clock: %d\n",
			PTR_ERR(kp->clk));

would be good.

> +		return PTR_ERR(kp->clk);
> +	}
> +
> +	ret = clk_prepare_enable(kp->clk);
> +	if (ret < 0)
> +		return ret;

Do you really want the clock enabled all the time? Why not just
clk_enable() whenever a PWM is enabled? If you need the clock for
register access, you can also bracket register accesses with
clk_enable() and clk_disable(). Perhaps the power savings aren't worth
the added effort, so if you'd rather not do that, I'm fine with it, too.

> +
> +	/* Set smooth mode, push/pull, and normal polarity for all channels */
> +	writel(PWM_CONTROL_INITIAL, kp->base + PWM_CONTROL_OFFSET);

I'd expect to see bitfield definitions for smooth mode and push/pull,
and PWM_CONTROL_INITIAL to be defined in terms of those. Better yet
would be to have a value constructed at runtime with the initial value.

> +	dev_set_drvdata(&pdev->dev, kp);

platform_set_drvdata(), please.

> +	kp->chip.dev = &pdev->dev;
> +	kp->chip.ops = &kona_pwm_ops;
> +	kp->chip.base = -1;
> +	kp->chip.npwm = KONA_PWM_CHANNEL_CNT;
> +
> +	ret = pwmchip_add(&kp->chip);
> +	if (ret < 0) {
> +		clk_disable_unprepare(kp->clk);
> +		dev_err(&pdev->dev, "pwmchip_add() failed: Err %d\n", ret);

For consistency with my above recommendation:

		dev_err(&pdev->dev, "failed to add PWM chip: %d\n", ret);

Also, I'd move the error message before clk_disable_unprepare(). There's
no technical reason really, but it's far more common that way around.

> +	}
> +
> +	return ret;
> +}
> +
> +static int kona_pwmc_remove(struct platform_device *pdev)
> +{
> +	struct kona_pwmc *kp = platform_get_drvdata(pdev);
> +
> +	clk_disable_unprepare(kp->clk);
> +	return pwmchip_remove(&kp->chip);
> +}
> +
> +static const struct of_device_id bcm_kona_pwmc_dt[] = {
> +	{.compatible = "brcm,kona-pwm"},

Needs spaces after { and before }.

> +	{},

Should be: { }.

> +};
> +MODULE_DEVICE_TABLE(of, bcm_kona_pwmc_dt);
> +
> +static struct platform_driver kona_pwmc_driver = {
> +
> +	.driver = {
> +		   .name = "bcm-kona-pwm",
> +		   .owner = THIS_MODULE,
> +		   .of_match_table = bcm_kona_pwmc_dt,
> +		   },

The alignment is weird, should be:

	.driver = {
		.name = "bcm-kona-pwm",
		.owner = THIS_MODULE,
		.of_match_table = bcm_kona_pwmc_dt,
	},

You can also leave out the .owner field, that's assigned automatically
by the driver core.

> +
> +	.probe = kona_pwmc_probe,

No blank line before this one.

> +	.remove = kona_pwmc_remove,
> +};
> +
> +module_platform_driver(kona_pwmc_driver);

No blank line before this one.

> +
> +MODULE_AUTHOR("Broadcom");

I don't think Broadcom qualifies as author. This should be the name of
whoever wrote the code. There are a few drivers that contain the company
name in the MODULE_AUTHOR, but I don't think those are correct either.

> +MODULE_DESCRIPTION("Driver for KONA PWMC");

"Driver for KONA PWM controller"?

> +MODULE_LICENSE("GPL");

According to the header comment this should be "GPL v2".

> +MODULE_VERSION("1.0");

I don't think we need this.

Thierry

--uJWb33pM2TcUAXIl
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJSky/GAAoJEN0jrNd/PrOhbtgP/jSEYm7ziwyXr0nz1IRnqxnR
UGj42yXiSosLyXHBStoHAMDpVLJhLlrN/rQcr0mk8sXbJXyFR++tyDQrqxYh6pit
juArAF1XeFwhh8PXvvdNNMDlSbaA5UyXS5UsWAeeEZKNnQbpTXcltLD1XcfPX5A1
sDYh3QdSWi8V83im/QczYi59eaMpzgyfi/uA1boF49ZRyCoIuOgtRN08jHJUKMyd
arLavgAtyFcGf6Y6gVdymcQUeuhlyWaKJDWHQF3iavDGDv/+d4kUNnoOClnpoOiQ
eta3WYMy/aC141IiCRAzjg3jqLF1PBM+gY33bz/JWHKZlDPY1zUZ/Npu7pvpkTCX
OZrydAea25uEYHXPhdDzqFSx7c8HyhXOO3bhcMYz+beJQB2oFl2L9EBNH5ftj5ww
IXZsPA2tX3NbzlD6zNq1Fr8tCMnU2Wbnp1qEmIM4agxXd1XpoOpEyAVIxo2OYz2t
m6Y1oRC81GRQafUtfA49+HZQNpvim7huNUygvQRozfJPJlddXkbvo2gXKgxt7/4K
z1VltmwAxGGDf7axDAMp4MLT8kfDnqAtTRc/H9+O1LB67pCtQBp9r95QT0jT1XqW
jSP8kQQAjUA9tqSPOJ4WJDkpD73ZboNPVyz9BKGr0HnlmiTMWlRw/GBRhM9hzQG0
T1wzycceFdRgcDjMnFcg
=JGjo
-----END PGP SIGNATURE-----

--uJWb33pM2TcUAXIl--
