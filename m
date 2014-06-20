Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966952AbaFTWBy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jun 2014 18:01:54 -0400
Received: from mail-we0-f177.google.com ([74.125.82.177]:49378 "EHLO
	mail-we0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965046AbaFTWBw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jun 2014 18:01:52 -0400
Date: Sat, 21 Jun 2014 00:00:36 +0200
From: Beniamino Galvani <b.galvani@gmail.com>
To: Thierry Reding <thierry.reding@gmail.com>
Cc: Heiko Stuebner <heiko@sntech.de>, linux-pwm@vger.kernel.org,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Randy Dunlap <rdunlap@infradead.org>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org
Subject: Re: [PATCH 1/3] pwm: add Rockchip SoC PWM support
Message-ID: <20140620220034.GA927@gmail.com>
References: <1399504115-16257-1-git-send-email-b.galvani@gmail.com>
 <1399504115-16257-2-git-send-email-b.galvani@gmail.com>
 <20140617214253.GA24743@mithrandir>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140617214253.GA24743@mithrandir>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 17, 2014 at 11:42:58PM +0200, Thierry Reding wrote:
> On Thu, May 08, 2014 at 01:08:33AM +0200, Beniamino Galvani wrote:
> > This commit adds a driver for the PWM controller found on Rockchip
> > RK29, RK30 and RK31 SoCs.
> > 
> > Signed-off-by: Beniamino Galvani <b.galvani@gmail.com>
> > ---
> >  drivers/pwm/Kconfig        |    8 ++
> >  drivers/pwm/Makefile       |    1 +
> >  drivers/pwm/pwm-rockchip.c |  180 ++++++++++++++++++++++++++++++++++++++++++++
> >  3 files changed, 189 insertions(+)
> >  create mode 100644 drivers/pwm/pwm-rockchip.c
> > 
> > diff --git a/drivers/pwm/Kconfig b/drivers/pwm/Kconfig
> > index 5b34ff2..2e92245 100644
> > --- a/drivers/pwm/Kconfig
> > +++ b/drivers/pwm/Kconfig
> > @@ -197,6 +197,14 @@ config PWM_RENESAS_TPU
> >  	  To compile this driver as a module, choose M here: the module
> >  	  will be called pwm-renesas-tpu.
> >  
> > +config PWM_ROCKCHIP
> > +	tristate "Rockchip PWM support"
> > +	depends on ARCH_ROCKCHIP
> > +	depends on OF
> 
> It seems like ARCH_ROCKCHIP depends on OF already (via ARCH_MULTI_V7 and
> ARCH_MULTIPLATFORM), so having the dependency explicitly here seems
> redundant.

Right, I will remove the dependency.

> 
> > diff --git a/drivers/pwm/pwm-rockchip.c b/drivers/pwm/pwm-rockchip.c
> [...]
> > +#define PRESCALER		2
> > +#define NSECS_PER_SEC		1000000000
> 
> You should use NSEC_PER_SEC from include/linux/time.h.

Ok.

> 
> > +struct rockchip_pwm_chip {
> > +	struct pwm_chip	chip;
> > +	struct clk	*clk;
> > +	void __iomem	*base;
> > +};
> 
> I prefer no artificial padding within structure definitions.
> 
> > +static int rockchip_pwm_config(struct pwm_chip *chip, struct pwm_device *pwm,
> > +			       int duty_ns, int period_ns)
> > +{
> > +	struct rockchip_pwm_chip *pc = to_rockchip_pwm_chip(chip);
> > +	unsigned long clk_rate, period, duty;
> > +	u64 div;
> > +	int ret;
> > +
> > +	clk_rate = clk_get_rate(pc->clk);
> > +
> > +	/*
> > +	 * Since period and duty cycle registers have a width of 32
> > +	 * bits, every possible input period can be obtained using the
> > +	 * default prescaler value for all practical clock rate values.
> > +	 */
> > +	div = clk_rate;
> > +	div *= period_ns;
> 
> Perhaps shorten this to "div = clk_rate * period_ns;"?

I will change this, adding a cast to avoid the truncation of the
result to 32 bits: "div = (u64)clk_rate * period_ns;"

> 
> > +	do_div(div, PRESCALER * NSECS_PER_SEC);
> > +	period = div;
> > +
> > +	div = clk_rate;
> > +	div *= duty_ns;
> 
> And this to "div = clk_rate * duty_ns;"?

Ditto.

> 
> > +	do_div(div, PRESCALER * NSECS_PER_SEC);
> > +	duty = div;
> > +
> > +	ret = clk_enable(pc->clk);
> > +	if (ret)
> > +		return ret;
> > +
> > +	writel(period, pc->base + PWM_LRC);
> > +	writel(duty, pc->base + PWM_HRC);
> > +	writel(0, pc->base + PWM_CNTR);
> > +
> > +	clk_disable(pc->clk);
> > +
> > +	return 0;
> > +}
> [...]
> > +static struct pwm_ops rockchip_pwm_ops = {
> 
> static const please.
> 
> > +	.config	= rockchip_pwm_config,
> 
> There's a tab between .config and = above. It should be a space.
> 
> > +static const struct of_device_id rockchip_pwm_dt_ids[] = {
> > +	{ .compatible = "rockchip,rk2928-pwm" },
> > +	{ /* sentinel */ }
> > +};
> > +MODULE_DEVICE_TABLE(of, rockchip_pwm_id_ids);
> 
> The name in the MODULE_DEVICE_TABLE doesn't match the array name above.
> Does this even build?

Sorry, I didn't test the driver as a module, which indeed doesn't
compile.

> 
> > +static struct platform_driver rockchip_pwm_driver = {
> > +	.driver = {
> > +		.name = "rockchip-pwm",
> > +		.owner = THIS_MODULE,
> 
> You no longer need to initialize this explicitly, module_platform_driver
> does it for you.
> 
> > +		.of_match_table = rockchip_pwm_dt_ids,
> > +	},
> > +	.probe	= rockchip_pwm_probe,
> 
> There's another tab instead of space here.
> 
> > +	.remove = rockchip_pwm_remove,
> > +};
> > +module_platform_driver(rockchip_pwm_driver);
> > +
> > +MODULE_AUTHOR("Beniamino Galvani <b.galvani@gmail.com>");
> > +MODULE_DESCRIPTION("Rockchip PWM driver");
> 
> Perhaps "Rockchip SoC PWM driver"?

Seems reasonable; I will fix this and the other issues in v2, thanks.

Beniamino
