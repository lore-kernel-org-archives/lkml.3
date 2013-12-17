Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753224Ab3LQLLx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Dec 2013 06:11:53 -0500
Received: from mail-bk0-f41.google.com ([209.85.214.41]:63432 "EHLO
	mail-bk0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751410Ab3LQLLu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Dec 2013 06:11:50 -0500
Date: Tue, 17 Dec 2013 12:10:22 +0100
From: Thierry Reding <thierry.reding@gmail.com>
To: Xiubo Li <Li.Xiubo@freescale.com>
Cc: mark.rutland@arm.com, s.hauer@pengutronix.de, galak@codeaurora.org,
        swarren@wwwdotorg.org, t.figa@samsung.com, grant.likely@linaro.org,
        matt.porter@linaro.org, linux@arm.linux.org.uk, rob@landley.net,
        tomasz.figa@gmail.com, ian.campbell@citrix.com, pawel.moll@arm.com,
        rob.herring@calxeda.com, linux-arm-kernel@lists.infradead.org,
        linux-pwm@vger.kernel.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org, linux-doc@vger.kernel.org,
        Alison Wang <b18965@freescale.com>,
        Jingchang Lu <b35083@freescale.com>
Subject: Re: [PATCHv7 1/4] pwm: Add Freescale FTM PWM driver support
Message-ID: <20131217111020.GF13823@ulmo.nvidia.com>
References: <1386925027-16288-1-git-send-email-Li.Xiubo@freescale.com>
 <1386925027-16288-2-git-send-email-Li.Xiubo@freescale.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="w2JjAQZceEVGylhD"
Content-Disposition: inline
In-Reply-To: <1386925027-16288-2-git-send-email-Li.Xiubo@freescale.com>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--w2JjAQZceEVGylhD
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Dec 13, 2013 at 04:57:04PM +0800, Xiubo Li wrote:
[...]
> diff --git a/drivers/pwm/Makefile b/drivers/pwm/Makefile
> index 8b754e4..9029a12 100644
> --- a/drivers/pwm/Makefile
> +++ b/drivers/pwm/Makefile
> @@ -5,6 +5,7 @@ obj-$(CONFIG_PWM_ATMEL_TCB)	+= pwm-atmel-tcb.o
>  obj-$(CONFIG_PWM_BFIN)		+= pwm-bfin.o
>  obj-$(CONFIG_PWM_EP93XX)	+= pwm-ep93xx.o
>  obj-$(CONFIG_PWM_IMX)		+= pwm-imx.o
> +obj-$(CONFIG_PWM_FSL_FTM)	+= pwm-fsl-ftm.o

This needs to move up one line to preserve the alphabetical ordering.

> diff --git a/drivers/pwm/pwm-fsl-ftm.c b/drivers/pwm/pwm-fsl-ftm.c
[...]
> +struct fsl_pwm_chip {
[...]
> +	int big_endian;

This should be of type bool.

> +};
> +
> +static inline u32 fsl_pwm_readl(struct fsl_pwm_chip *fpc,
> +		const void __iomem *addr)
> +{
> +	u32 val;
> +
> +	val = __raw_readl(addr);
> +
> +	if (likely(fpc->big_endian))

The likely() probably isn't very useful in this case. But if you want to
keep it, it should at least be reversed, since little-endian is actually
the default (you have to specify the big-endian property to activate the
big endian mode).

> +		val = be32_to_cpu(val);
> +	else
> +		val = le32_to_cpu(val);
> +	rmb();

I'd prefer the rmb() to follow the __raw_readl() immediately to make the
relationship more explicit.

> +
> +	return val;
> +}
> +
> +static inline void fsl_pwm_writel(struct fsl_pwm_chip *fpc,
> +		u32 val, void __iomem *addr)
> +{
> +	wmb();
> +	if (likely(fpc->big_endian))
> +		val = cpu_to_be32(val);
> +	else
> +		val = cpu_to_le32(val);
> +
> +	__raw_writel(val, addr);

Same here. wmb() should precede __raw_writel() immediately.

> +static inline int fsl_pwm_calculate_default_ps(struct fsl_pwm_chip *fpc,
> +		int index)

Please align arguments on subsequent lines with the first argument on
the first line. There are a few more of those in this file, please check
all other functions as well.

Also I think it's better to turn the FSL_PWM_CLK_* enum into a named
enum and reuse the type here. That way you get proper type-checking.

> +	switch (index) {
[...]
> +	default:
> +		return -EINVAL;

And with proper type checking you don't need this default case anymore.

> +static unsigned long fsl_pwm_calculate_period_cycles(struct fsl_pwm_chip *fpc,
> +		unsigned long period_ns, int index)
> +{
> +	int ret;
> +	unsigned long cycles;
> +
> +	fpc->counter_clk_select = FTM_SC_CLK(index);
> +
> +	ret = fsl_pwm_calculate_default_ps(fpc, index);
> +	if (ret) {
> +		dev_err(fpc->chip.dev, "failed to calculate default ps.\n");

No need for the terminating fullstop (.) here, but perhaps you could
write out what "ps" actually stands for. Also including the error code
in the error message would be good since you're not propagating the
error to the caller.

> +	cycles = fsl_pwm_calculate_cycles(fpc, period_ns);
> +
> +	return cycles;

This can simply be "return fsl_pwm_calculate_cycles(fpc, period_ns);",
in which case you can get rid of the cycles variable.

> +static unsigned long fsl_pwm_calculate_period(struct fsl_pwm_chip *fpc,
> +		unsigned long period_ns)
> +{
[...]
> +	if (fix_rate > ext_rate) {
> +		m0 = FSL_PWM_CLK_FIX;
> +		m1 = FSL_PWM_CLK_EXT;
> +	} else {
> +		m0 = FSL_PWM_CLK_EXT;
> +		m1 = FSL_PWM_CLK_FIX;
> +
> +	}

There's a gratuitous blank line above this one.

> +static int fsl_pwm_config(struct pwm_chip *chip, struct pwm_device *pwm,
> +			  int duty_ns, int period_ns)
> +{
> +	u32 val, period, duty;
> +	struct fsl_pwm_chip *fpc = to_fsl_chip(chip);
> +
> +	mutex_lock(&fpc->lock);
> +	if (fpc->period_ns && fpc->period_ns != period_ns) {

There should be a blank line between the above two.

> +		dev_err(fpc->chip.dev, "fail to config pwm%d, the period "
> +				"time should be the same with the current "
> +				"running pwm(s).\n", pwm->hwpwm);

I think I'd make this error message more terse and put more information
into a comment. Perhaps something like this:

	/*
	 * The FSL FTM controller supports only a single period for all PWM
	 * channels, therefore incompatible changes need to be refused.
	 */
	if (fpc->period_ns && fpc->period_ns != period_ns) {
		dev_err(fpc->chip.dev,
			"conflicting period requested for PWM %u\n",
			pwm->hwpwm);
		...
	}

> +		mutex_unlock(&fpc->lock);
> +		return -EINVAL;

I think something like -EBUSY would be more appropriate here.

> +	if (!fpc->period_ns && duty_ns) {
> +		period = fsl_pwm_calculate_period(fpc, period_ns);
> +		if (!period) {
> +			dev_err(fpc->chip.dev, "fail to calculate the "

"failed"

> +					"period cycles.\n");

And no fullstop either. Also I don't think you need "cycles" here. In
fact something equally accurate like this:

			dev_err(fpc->chip.dev, "failed to calculate period\n");

Still fits within 80 characters.

> +		fpc->period_ns = period_ns;
> +	}
> +	mutex_unlock(&fpc->lock);

This could use a blank line as well.

> +static int fsl_pwm_set_polarity(struct pwm_chip *chip, struct pwm_device *pwm,
> +				enum pwm_polarity polarity)
> +{
> +	u32 val;
> +	struct fsl_pwm_chip *fpc = to_fsl_chip(chip);
> +
> +	val = fsl_pwm_readl(fpc, fpc->base + FTM_POL);
> +	if (polarity == PWM_POLARITY_INVERSED)

Blank line between the above.

> +		val |= BIT(pwm->hwpwm);
> +	else
> +		val &= ~BIT(pwm->hwpwm);
> +	fsl_pwm_writel(fpc, val, fpc->base + FTM_POL);

And here.

> +static void fsl_pwm_disable(struct pwm_chip *chip, struct pwm_device *pwm)
> +{
> +	u32 val;
> +	struct fsl_pwm_chip *fpc = to_fsl_chip(chip);
> +
> +	val = fsl_pwm_readl(fpc, fpc->base + FTM_OUTMASK);
> +	val |= BIT(pwm->hwpwm);
> +	fsl_pwm_writel(fpc, val, fpc->base + FTM_OUTMASK);
> +
> +	mutex_lock(&fpc->lock);
> +	fsl_counter_clock_disable(fpc);
> +
> +	val = fsl_pwm_readl(fpc, fpc->base + FTM_OUTMASK);
> +	if ((val & 0xFF) == 0xFF) {
> +		fpc->period_ns = 0;
> +		fpc->counter_clk_en = NULL;
> +	}
> +	mutex_unlock(&fpc->lock);

Same here.

> +static int fsl_pwm_probe(struct platform_device *pdev)
> +{
> +	int ret;
> +	struct fsl_pwm_chip *fpc;
> +	struct resource *res;
> +	struct device_node *np = pdev->dev.of_node;
> +
> +	fpc = devm_kzalloc(&pdev->dev, sizeof(*fpc), GFP_KERNEL);
> +	if (!fpc)
> +		return -ENOMEM;
> +
> +	mutex_init(&fpc->lock);
> +
> +	fpc->chip.dev = &pdev->dev;
> +
> +	fpc->big_endian = of_property_read_bool(np, "big-endian");
> +
> +	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
> +	fpc->base = devm_ioremap_resource(&pdev->dev, res);
> +	if (IS_ERR(fpc->base))
> +		return PTR_ERR(fpc->base);
> +
> +	fpc->sys_clk = devm_clk_get(fpc->chip.dev, "ftm_sys");

For consistency I'd use &pdev->dev here...

> +	if (IS_ERR(fpc->sys_clk)) {
> +		dev_err(fpc->chip.dev,

... and here.

> +	ret = pwmchip_add(&fpc->chip);
> +	if (ret < 0) {
> +		dev_err(&pdev->dev, "failed to add PWM chip %d\n", ret);

Perhaps "failed to add PWM chip: %d\n", so that %d isn't confused to
mean the PWM chip number?

> +static int fsl_pwm_remove(struct platform_device *pdev)
> +{
> +	struct fsl_pwm_chip *fpc = platform_get_drvdata(pdev);
> +
> +	mutex_destroy(&fpc->lock);

I think you can drop this. Once fsl_pwm_remove() exists, the memory
pointed to by fpc will be freed, so you won't be able to access the
mutex anyway.

Thierry

--w2JjAQZceEVGylhD
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJSsDEcAAoJEN0jrNd/PrOhv2IQAKU9l/TVy/tkOS5OWlvNATgD
9bsqGH4EAfSeTza/3Kdsu2hOQZnosYOIhzX7f3RiJ8OwFOKFh+jpE0XGz1iGdTnc
xvOm9lPSqw1cYMsie1y+qigyATzaWFvr1dL1MNtoBv+bIqb3CHNfYXPj8o9zTEgC
ViyNTC9npI+J7oB7zAjopwB97QhkEBnr93zg7lHJxozcs/yTAVPehOIu2EdciIHZ
9XhDMWSOvEiSTxiCJgA7+Ztb6/7ZYiJcZFC90GdgnlIhio15QWDb5Tx15QNvfP1Y
+Fy0aKvN3yxpAMzvJz9VdEIEG7hG0gbzSrKMKNwSQBntylzpxSZiEW4EFy+OhRkk
LB6KUSLHvWc0tk+GXhfrFx4nzSFX/BRVf3bewgw7fAESaGw5IVjuMdFtpjK4JNiV
8BBqTUa/So2T6HBLyxtrt5HtANSDLaZAVpqn9E3m1bGpq0IQu2jsciUgwFL+DvOx
RBMde9RAm0siF3MLUwWoDz4oOrYoRxWjXmOY+gELtY47eKg/1lGfZbCgkpm+ORr4
WgTGd1wazF8Tx0MYvI/bbNEMql5SJIHq14jgKmA0s1JJSYn996f1BBewRtFsVivj
QBFjE75v0SA8Evig//vbf/KFot5BD9mrPFBLWcRLFOv4gRPWlaf08ahdMgtkUY3V
rVmazIh1UB+4euq30sc3
=QOUj
-----END PGP SIGNATURE-----

--w2JjAQZceEVGylhD--
