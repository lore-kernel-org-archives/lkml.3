Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752559AbaBZNLQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Feb 2014 08:11:16 -0500
Received: from mail-ea0-f176.google.com ([209.85.215.176]:43754 "EHLO
	mail-ea0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750814AbaBZNLO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Feb 2014 08:11:14 -0500
Date: Wed, 26 Feb 2014 14:11:11 +0100
From: Thierry Reding <thierry.reding@gmail.com>
To: Xiubo Li <Li.Xiubo@freescale.com>
Cc: linux-pwm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Alison Wang <b18965@freescale.com>,
        Jingchang Lu <b35083@freescale.com>
Subject: Re: [PATCHv9 Resend 1/4] pwm: Add Freescale FTM PWM driver support
Message-ID: <20140226131109.GA29779@ulmo.nvidia.com>
References: <1392799137-17188-1-git-send-email-Li.Xiubo@freescale.com>
 <1392799137-17188-2-git-send-email-Li.Xiubo@freescale.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="IS0zKkzwUGydFO0o"
Content-Disposition: inline
In-Reply-To: <1392799137-17188-2-git-send-email-Li.Xiubo@freescale.com>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--IS0zKkzwUGydFO0o
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi,

Sorry for taking so long to get back to you. Things have been quite busy
lately. A few more comments below, but we're getting there.

On Wed, Feb 19, 2014 at 04:38:54PM +0800, Xiubo Li wrote:
[...]
> diff --git a/drivers/pwm/pwm-fsl-ftm.c b/drivers/pwm/pwm-fsl-ftm.c
[...]
> +static unsigned long fsl_pwm_calculate_period(struct fsl_pwm_chip *fpc,
> +					      unsigned long period_ns)
> +{
> +	struct clk *cnt_clk[3];
> +	enum fsl_pwm_clk m0, m1;
> +	unsigned long fix_rate, ext_rate, cycles;
> +
> +	fpc->counter_clk = fpc->sys_clk;
> +	cycles = fsl_pwm_calculate_period_cycles(fpc, period_ns,
> +			FSL_PWM_CLK_SYS);
> +	if (cycles)
> +		return cycles;
> +
> +	cnt_clk[FSL_PWM_CLK_FIX] = devm_clk_get(fpc->chip.dev, "ftm_fix");
> +	if (IS_ERR(cnt_clk[FSL_PWM_CLK_FIX]))
> +		return PTR_ERR(cnt_clk[FSL_PWM_CLK_FIX]);
> +
> +	cnt_clk[FSL_PWM_CLK_EXT] = devm_clk_get(fpc->chip.dev, "ftm_ext");
> +	if (IS_ERR(cnt_clk[FSL_PWM_CLK_EXT]))
> +		return PTR_ERR(cnt_clk[FSL_PWM_CLK_EXT]);
> +
> +	fpc->counter_clk_en = devm_clk_get(fpc->chip.dev, "ftm_cnt_clk_en");
> +	if (IS_ERR(fpc->counter_clk_en))
> +		return PTR_ERR(fpc->counter_clk_en);

You shouldn't do this. You're obtaining a reference to each of these
clocks whenever pwm_config() is called. And devres will only clean those
up after the driver is unbound. Can't you simply keep a reference to
these within struct fsl_pwm_chip?

> +static int fsl_counter_clock_enable(struct fsl_pwm_chip *fpc)
> +{
> +	u32 val;
> +	int ret;
> +
> +	if (fpc->counter_clk_enable++)

This function is always called with the fpc->lock held, so you could
make this much easier by incrementing the .counter_clk_enable field only
at the very end of the function. That way...

> +		return 0;
> +
> +	ret = clk_prepare_enable(fpc->counter_clk);
> +	if (ret) {
> +		fpc->counter_clk_enable--;

... this won't be necessary...

> +		return ret;
> +	}
> +
> +	ret = clk_prepare_enable(fpc->counter_clk_en);
> +	if (ret) {
> +		fpc->counter_clk_enable--;

... and neither will this.

> +static int fsl_pwm_enable(struct pwm_chip *chip, struct pwm_device *pwm)
> +{
> +	struct fsl_pwm_chip *fpc = to_fsl_chip(chip);
> +	u32 val;
> +	int ret;
> +
> +	val = readl(fpc->base + FTM_OUTMASK);
> +	val &= ~BIT(pwm->hwpwm);
> +	writel(val, fpc->base + FTM_OUTMASK);
> +
> +	mutex_lock(&fpc->lock);

I think you want to extend the lock to cover the FTM_OUTMASK register
access as well because there could be a race between pwm_enable() and
pwm_disable().

> +	ret = fsl_counter_clock_enable(fpc);
> +	mutex_unlock(&fpc->lock);
> +
> +	return ret;
> +}

Can this function be moved somewhere else so fsl_counter_clock_enable()
and fsl_counter_clock_disable() are grouped together?

> +static void fsl_counter_clock_disable(struct fsl_pwm_chip *fpc)
> +{
> +	u32 val;
> +
> +	if (--fpc->counter_clk_enable)
> +		return;

This is going to break. Consider the case where you call pwm_disable()
on a PWM device and fpc->counter_clk_enable == 1. In that case, this
will decrement counter_clk_enable to 0 and proceed with the remainder of
this function.

Now you call pwm_disable() again. The above will decrement again and
cause fpc->counter_clk_enable to wrap around to UINT_MAX.

So I think a more correct implementation would be:

	/*
	 * already disabled, do nothing (perhaps output warning message
	 * to catch unbalanced calls? )
	 */
	if (fpc->counter_clk_enable == 0)
		return;

	/* there are still users, so can't disable yet */
	if (--fpc->counter_clk_enable > 0)
		return;

	/* no users left, disable clock */

> +static void fsl_pwm_disable(struct pwm_chip *chip, struct pwm_device *pwm)
> +{
> +	struct fsl_pwm_chip *fpc = to_fsl_chip(chip);
> +	u32 val;
> +
> +	val = readl(fpc->base + FTM_OUTMASK);
> +	val |= BIT(pwm->hwpwm);
> +	writel(val, fpc->base + FTM_OUTMASK);
> +
> +	mutex_lock(&fpc->lock);

This lock should also include the access to FTM_OUTMASK above.

> +static int fsl_pwm_probe(struct platform_device *pdev)
> +{
[...]
> +	fpc->sys_clk = devm_clk_get(&pdev->dev, "ftm_sys");
> +	if (IS_ERR(fpc->sys_clk)) {
> +		dev_err(&pdev->dev,
> +				"failed to get \"ftm_sys\" clock\n");

The above easily fits on a single line, no need for the wrapping.

> +		return PTR_ERR(fpc->sys_clk);
> +	}
> +
> +	ret = clk_prepare_enable(fpc->sys_clk);
> +	if (ret)
> +		return ret;
> +
> +	writel(0x00, fpc->base + FTM_CNTIN);
> +	writel(0x00, fpc->base + FTM_OUTINIT);
> +	writel(0xFF, fpc->base + FTM_OUTMASK);
> +	clk_disable_unprepare(fpc->sys_clk);

This looks out of place somehow, perhaps it should be moved off into a
separate function? fsl_pwm_init() perhaps.

Thierry

--IS0zKkzwUGydFO0o
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJTDeftAAoJEN0jrNd/PrOh6x4P/3tRxYP+9Ny2cp7q4GmmULZO
usUiyphxWx8cka6+r/WwiK/nMPnkdxQna8JruMyh6TAMGBCIldBqUnOBih4VANaU
PpcXKF4Zxs157n5i30VqAKRveJNnWi2a+sRJcssT9mXaUryHDIecsjr9uOWTzMqc
uXy9lBS3qIU8TvLO3tzVMj4g49FBRiPGPmwMGOh5Zo7C8o+C4q7MJfAsys0L4/m4
0QjevaIebw5NGxFpMGjCw7Fc6yY6Tm4C5RnE4GcBCwC+wveF6FueHW/nsJXZEiYD
ojcHmxKWeY7wC0su7AEL08gz0ybonuYBSRoOFVfo1H4qt6znv/Ig2JxCu7rOH3+9
M0nWqVG5LmqFQ+zC17G1vXD9d18+eV5fERS/bGLM72jkr2WO7bsUMh82W/e4+Opy
0vTG93gqy8TAF7RESf7VT6BCMcYjUixJY5ppnmjHsAMunv9bcvDiR7vEFFpfXcZe
orh5rwh+SWlDxHwTTTyvJBUwpb6+6tMVVl+rog7HCuvKn/NaTRYGKvp69ERHRwoN
MgDq2vEzKQ0fx8diS1qwHuryGKK4lpVkaWrMVhTxL6tsyKR+wNaEOAwZP9pc60bl
R6rUZtGQCj/dezhqU9jFRLCOX/QFxmOIxXGZdpqaLTrgOJlSz4lfB13PXwUyDdgW
1Ux78LoaUBFwHE8MshW1
=AYPX
-----END PGP SIGNATURE-----

--IS0zKkzwUGydFO0o--
