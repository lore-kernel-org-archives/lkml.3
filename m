Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756510AbaFQX0N (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jun 2014 19:26:13 -0400
Received: from mail-we0-f172.google.com ([74.125.82.172]:37331 "EHLO
	mail-we0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753597AbaFQX0K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jun 2014 19:26:10 -0400
Date: Wed, 18 Jun 2014 01:26:06 +0200
From: Thierry Reding <thierry.reding@gmail.com>
To: Alexandre Belloni <alexandre.belloni@free-electrons.com>
Cc: Maxime Ripard <maxime.ripard@free-electrons.com>,
        linux-pwm@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCHv5 1/2] pwm: Add Allwinner SoC support
Message-ID: <20140617232605.GB25525@mithrandir>
References: <1400523003-27082-1-git-send-email-alexandre.belloni@free-electrons.com>
 <1400523003-27082-2-git-send-email-alexandre.belloni@free-electrons.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="i9LlY+UWpKt15+FH"
Content-Disposition: inline
In-Reply-To: <1400523003-27082-2-git-send-email-alexandre.belloni@free-electrons.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--i9LlY+UWpKt15+FH
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, May 19, 2014 at 08:10:02PM +0200, Alexandre Belloni wrote:
[...]
> diff --git a/drivers/pwm/pwm-sunxi.c b/drivers/pwm/pwm-sunxi.c
[...]
> +#include <linux/bitops.h>
> +#include <linux/clk.h>
> +#include <linux/err.h>
> +#include <linux/io.h>
> +#include <linux/of.h>
> +#include <linux/of_device.h>
> +#include <linux/platform_device.h>
> +#include <linux/pwm.h>
> +#include <linux/module.h>
> +#include <linux/mutex.h>
> +#include <linux/slab.h>

These should be ordered alphabetically.

> +#define PWM_CTRL_REG		0x0
> +
> +#define PWM_CH_PRD_BASE		0x4
> +#define PWM_CH_PRD_OFF		0x4

Is this supposed to be an offset? If so, then maybe it should be named
PWM_CH_PRD_OFFSET?

> +#define PWM_CH_PRD(x)		(PWM_CH_PRD_BASE + PWM_CH_PRD_OFF * (x))

x is the channel number? If so maybe call that parameter "ch"?

> +#define PWMCH_OFFSET		15
> +#define PWM_PRESCAL_MASK	GENMASK(3, 0)
> +#define PWM_PRESCAL_OFF		0
> +#define PWM_EN			BIT(4)
> +#define PWM_ACT_STATE		BIT(5)
> +#define PWM_CLK_GATING		BIT(6)
> +#define PWM_MODE		BIT(7)
> +#define PWM_PULSE		BIT(8)
> +#define PWM_BYPASS		BIT(9)
> +
> +#define PWM_RDY_BASE		28
> +#define PWM_RDY_OFF		1
> +#define PWM_RDY(x)		BIT(PWM_RDY_BASE + PWM_RDY_OFF * (x))

Some comments as for PWM_CH_PRD above.

> +#define PWM_PRD_ACT_MASK	GENMASK(7, 0)

This seems to be unused.

> +#define PWM_PRD(x)		((x - 1) << 16)

x should be enclosed in ().

> +#define PWM_PRD_MASK		GENMASK(7, 0)
> +
> +#define	BIT_CH(bit, chan)	(bit << (chan * PWMCH_OFFSET))

There should be a space instead of a tab between "define" and
"BIT_CH(...)".

> +u32 prescal_table[] = { 120, 180, 240, 360, 480, 0, 0, 0,
> +			12000, 24000, 36000, 48000, 72000,
> +			0, 0, 1 };

static const? Also this is oddly formatted. I'd prefer:

	static const u32 prescal_table[] = {
		...
		...
	};

Also for readability I'd go for "prescaler_table" or "prescale_table".

> +struct sunxi_pwm_data {
> +	bool has_rdy;
> +};
> +
> +struct sunxi_pwm_chip {
> +	struct pwm_chip chip;
> +	struct clk *clk;
> +	void __iomem *base;
> +	struct mutex ctrl_lock;
> +	const struct sunxi_pwm_data *data;
> +};
> +
> +#define to_sunxi_pwm_chip(chip) container_of(chip, struct sunxi_pwm_chip, chip)

This should be a static inline function.

> +static inline u32 sunxi_pwm_readl(struct sunxi_pwm_chip *chip,
> +				  unsigned long offset)
> +{
> +	return readl(chip->base + offset);
> +}
> +
> +static inline void sunxi_pwm_writel(struct sunxi_pwm_chip *chip,
> +				    unsigned long offset, unsigned long val)

Make val u32 for consistency with sunxi_pwm_readl()? Also I'd prefer if
this function preserved the same parameter order as writel().

> +static int sunxi_pwm_config(struct pwm_chip *chip, struct pwm_device *pwm,
> +			    int duty_ns, int period_ns)
> +{
> +	struct sunxi_pwm_chip *sunxi_pwm = to_sunxi_pwm_chip(chip);
> +	u32 clk_rate, prd, dty;
> +	u64 div;
> +	u32 val, clk_gate;

These can both go onto the same line as the other u32s above.

> +	int i, ret;

I think i should be unsigned. And maybe rename ret to err since it's not
used as a return value at all.

> +
> +	clk_rate = clk_get_rate(sunxi_pwm->clk);
> +
> +	/* First, test without any divider */
> +	i = PWM_PRESCAL_MASK;

I don't see where this value of I is used.

> +	div = clk_rate * period_ns;
> +	do_div(div, 1000000000);
> +	if (div > PWM_PRD_MASK) {
> +		/* Then go up from the first divider */
> +		for (i = 0; i < PWM_PRESCAL_MASK; i++) {
> +			if (!prescal_table[i])
> +				continue;
> +			div = clk_rate / prescal_table[i];
> +			div = div * period_ns;
> +			do_div(div, 1000000000);

Maybe:

	div = clk_rate / prescal_table[i];
	do_div(div * period_ns, 1000000000);

? Also 1000000000 == NSEC_PER_SEC, so maybe use that instead.

> +			if (div <= PWM_PRD_MASK)
> +				break;
> +		}
> +	}
> +
> +	if (div > PWM_PRD_MASK) {
> +		dev_err(chip->dev, "prescaler exceeds the maximum value\n");

Nit: the prescaler doesn't exceed anything. Rather the period exceeds
the maximum.

> +		return -EINVAL;
> +	}
> +
> +	prd = div;
> +	div *= duty_ns;
> +	do_div(div, period_ns);
> +	dty = div;
> +
> +	ret = clk_prepare_enable(sunxi_pwm->clk);
> +	if (ret) {
> +		dev_err(chip->dev, "failed to enable PWM clock\n");
> +		return ret;
> +	}
> +
> +	mutex_lock(&sunxi_pwm->ctrl_lock);
> +	val = sunxi_pwm_readl(sunxi_pwm, PWM_CTRL_REG);
> +
> +	if (sunxi_pwm->data->has_rdy && (val & PWM_RDY(pwm->hwpwm))) {
> +		mutex_unlock(&sunxi_pwm->ctrl_lock);
> +		clk_disable_unprepare(sunxi_pwm->clk);
> +		return -EBUSY;
> +	}
> +
> +	clk_gate = val & BIT_CH(PWM_CLK_GATING, pwm->hwpwm);
> +	if (clk_gate) {
> +		val &= ~BIT_CH(PWM_CLK_GATING, pwm->hwpwm);
> +		sunxi_pwm_writel(sunxi_pwm, PWM_CTRL_REG, val);
> +	}
> +
> +	val = sunxi_pwm_readl(sunxi_pwm, PWM_CTRL_REG);
> +	val &= ~BIT_CH(PWM_PRESCAL_MASK, pwm->hwpwm);
> +	val |= i;

Ah, this is where the initial value is used. Perhaps rename i to
prescaler to make it more obvious what it is.

> +	sunxi_pwm_writel(sunxi_pwm, PWM_CTRL_REG, val);
> +
> +	sunxi_pwm_writel(sunxi_pwm, PWM_CH_PRD(pwm->hwpwm), dty | PWM_PRD(prd));

Maybe split this into two lines for readability:

	val = dty | PWM_PRD(prd);
	sunxi_pwm_writel(...);

Also does dty need to be range-checked so it doesn't spill over into the
PRD field?

> +static int sunxi_pwm_set_polarity(struct pwm_chip *chip, struct pwm_device *pwm,
> +				  enum pwm_polarity polarity)
> +{
> +	struct sunxi_pwm_chip *sunxi_pwm = to_sunxi_pwm_chip(chip);
> +	u32 val;
> +	int ret;
> +
> +	ret = clk_prepare_enable(sunxi_pwm->clk);
> +	if (ret) {
> +		dev_err(chip->dev, "failed to enable PWM clock\n");
> +		return ret;
> +	}
> +
> +	mutex_lock(&sunxi_pwm->ctrl_lock);
> +	val = sunxi_pwm_readl(sunxi_pwm, PWM_CTRL_REG);
> +
> +	if (polarity != PWM_POLARITY_NORMAL)
> +		val &= ~BIT_CH(PWM_ACT_STATE, pwm->hwpwm);
> +	else
> +		val |= BIT_CH(PWM_ACT_STATE, pwm->hwpwm);
> +
> +

There's an extra blank line here.

> +static int sunxi_pwm_probe(struct platform_device *pdev)
> +{
> +	struct sunxi_pwm_chip *sunxi_pwm;

Perhaps just "pwm" or "sunxi"? sunxi_pwm is kind of redundant.

> +	struct resource *res;
> +	int ret;
> +
> +	const struct of_device_id *match;

There should be no blank line above this one.

> +
> +	match = of_match_device(sunxi_pwm_dt_ids, &pdev->dev);
> +	if (!match || !match->data)

None of this can ever happen. match would only be NULL if the table
doesn't contain a matching entry for this device. But in that case the
driver's .probe() wouldn't have been called anyway. And none of the
entries have a NULL .data field, so no need to check for that either.

> +		return -ENODEV;
> +
> +	sunxi_pwm = devm_kzalloc(&pdev->dev, sizeof(*sunxi_pwm), GFP_KERNEL);
> +	if (!sunxi_pwm)
> +		return -ENOMEM;
> +
> +	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
> +	sunxi_pwm->base = devm_ioremap_resource(&pdev->dev, res);
> +	if (IS_ERR(sunxi_pwm->base))
> +		return PTR_ERR(sunxi_pwm->base);
> +
> +	sunxi_pwm->clk = devm_clk_get(&pdev->dev, NULL);
> +	if (IS_ERR(sunxi_pwm->clk))
> +		return PTR_ERR(sunxi_pwm->clk);
> +
> +	sunxi_pwm->chip.dev = &pdev->dev;
> +	sunxi_pwm->chip.ops = &sunxi_pwm_ops;
> +
> +	sunxi_pwm->chip.base = -1;

Why the blank line between the above?

> +	sunxi_pwm->chip.npwm = 2;
> +	sunxi_pwm->chip.can_sleep = true;
> +	sunxi_pwm->chip.of_xlate = of_pwm_xlate_with_flags;
> +	sunxi_pwm->chip.of_pwm_n_cells = 3;
> +	sunxi_pwm->data = match->data;
> +
> +	mutex_init(&sunxi_pwm->ctrl_lock);
> +
> +	ret = clk_prepare_enable(sunxi_pwm->clk);
> +	if (ret) {
> +		dev_err(&pdev->dev, "failed to enable PWM clock\n");
> +		goto error;
> +	}
> +
> +	/* By default, the polarity is inversed, set it to normal */
> +	sunxi_pwm_writel(sunxi_pwm, PWM_CTRL_REG,
> +			 BIT_CH(PWM_ACT_STATE, 0) |
> +			 BIT_CH(PWM_ACT_STATE, 1));
> +	clk_disable_unprepare(sunxi_pwm->clk);

Why do you need to do this here? Doesn't this potentially cause
transients if a bootloader had this configured with inversed polarity?

Thierry

--i9LlY+UWpKt15+FH
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJToM6NAAoJEN0jrNd/PrOhIt4P/A7i4tMP0DWFcoWSO8d9CFKP
8+bs86AfppvIH9xvZVe7kHWZWNKv/768pe62Wwry5hkvb26y/VYrXuhZCjLeW9zd
+Wn/gdo46tGuBORzf0wuJxpcuzgKgYQicI7Hh4vEvqEP678DJCMq1qmWoRE+mAK3
gTYjfZwiz1eudvaBGefPdzXijVI2WJ7vTUAp+dgH9a/OdGQRLjH7lg0+sBQn32CL
QC3mcW838Z57bIv63gQad7PYFLA9atJLFWKzQxcbe/Sp9jWuz10a92WabVJoIAbp
p6OhZzjoON2fxuNbOUCdzeNAkOIW/Z5LKi5uoWzLEKEWvADVweVfi1FsEkf5De62
W15zP9BQrLViNSrfbNEWJVGmBQfobhx84jw+T8Sc5sPe5guINpcClUU6QksWMsSR
tsYjd/UT1cBxTb2gxKsnoTuGacPW1OjMneXnDO7f2NMKjYOe1ugGj8QbmjR+u0F6
xYUlHKRN3REFxXKXVa9/avOiJMD16cuZQFq5dS90qVyZrF8ZsW0m8zg3XrLeADw7
Tj1n0bdpPfls8zLOQLCUTYZQVhhCCtjrVJ/mbQMUUCEbeVn4sjuNJM1x37YKwt7l
UjJ4DtQRM4lNU55bWdldD5p0LsaiIHWqSMqr/grV/MZaTobenC5yP3QSF6XNXgft
cpUHcvnV+tHGYEzriM+x
=MPpa
-----END PGP SIGNATURE-----

--i9LlY+UWpKt15+FH--
