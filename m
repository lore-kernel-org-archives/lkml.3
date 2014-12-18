Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752395AbaLRI1A (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Dec 2014 03:27:00 -0500
Received: from mail-oi0-f45.google.com ([209.85.218.45]:47600 "EHLO
	mail-oi0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752360AbaLRI06 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Dec 2014 03:26:58 -0500
Date: Thu, 18 Dec 2014 08:26:52 +0000
From: Lee Jones <lee.jones@linaro.org>
To: Guenter Roeck <linux@roeck-us.net>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        kernel@stlinux.com, a.zummo@towertech.it, rtc-linux@googlegroups.com,
        wim@iguana.be, linux-watchdog@vger.kernel.org,
        devicetree@vger.kernel.org, arnd@arndb.de,
        David Paris <david.paris@st.com>
Subject: Re: [PATCH 6/8] watchdog: st_wdt: Add new driver for ST's LPC
 Watchdog
Message-ID: <20141218082652.GP13885@x1>
References: <1418834727-1602-1-git-send-email-lee.jones@linaro.org>
 <1418834727-1602-7-git-send-email-lee.jones@linaro.org>
 <20141217180251.GA29914@roeck-us.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20141217180251.GA29914@roeck-us.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 17 Dec 2014, Guenter Roeck wrote:
> On Wed, Dec 17, 2014 at 04:45:25PM +0000, Lee Jones wrote:
> > Signed-off-by: David Paris <david.paris@st.com>
> > Signed-off-by: Lee Jones <lee.jones@linaro.org>
> 
> Hi Lee and David,
> 
> I still have a couple of comments below. Sorry I didn't catch those earlier.
> 
> Thanks,
> Guenter
> 
> > ---
> >  drivers/watchdog/Kconfig  |  13 ++
> >  drivers/watchdog/Makefile |   1 +
> >  drivers/watchdog/st_wdt.c | 323 ++++++++++++++++++++++++++++++++++++++++++++++
> >  3 files changed, 337 insertions(+)
> >  create mode 100644 drivers/watchdog/st_wdt.c

Chopping all the crud.

[...]

> > +static struct of_device_id st_wdog_match[] = {
> > +	{
> > +		.compatible = "st,stih407-lpc",
> > +		.data = (void *)&stih407_syscfg,
> 
> Nitpick: typecast to and from void * is not necessary.

Actually that's not true, but it is superfluous in this case.

I will fix-up.

[...]

> > +static int st_wdog_probe(struct platform_device *pdev)
> > +{
> > +	const struct of_device_id *match;
> > +	struct device_node *np = pdev->dev.of_node;
> > +	struct st_wdog *st_wdog;
> > +	struct regmap *regmap;
> > +	struct resource *res;
> > +	struct clk *clk;
> > +	void __iomem *base;
> > +	uint32_t mode;
> > +	int ret;

[...]

> > +	clk = clk_get(&pdev->dev, NULL);
> > +	if (IS_ERR(clk)) {
> > +		dev_err(&pdev->dev, "Unable to request clock\n");
> > +		return PTR_ERR(clk);
> > +	}
> > +	clk_prepare_enable(st_wdog->clk);
> 
> How does this work ? st_wdog->clk isn't set yet.

Great spot.  That should be 'clk'.

It works because the LPC clk is already on.

> > +
> > +	st_wdog->dev		= &pdev->dev;
> > +	st_wdog->base		= base;
> > +	st_wdog->clk		= clk;
> > +	st_wdog->syscfg->regmap = regmap;
> > +	st_wdog->warm_reset	= of_property_read_bool(np, "st,warm_reset");
> > +	st_wdog->clkrate	= clk_get_rate(st_wdog->clk);
> > +
> > +	if (!st_wdog->clkrate) {
> > +		dev_err(&pdev->dev, "Unable to fetch clock rate\n");
> 
> I think this is missing
> 	clk_disable_unprepare();
> 	clk_put();
> 
> Same for the rest of the error path handling below.

Actually instead of clk_put we should be using s/clk_get/devm_clk_get/.

You're right about the error paths.  I will enforce a better one.

Thanks.

[...]

> > +#ifdef CONFIG_PM
> 
> I think this needs to be CONFIG_PM_SLEEP.
> Another option might be to drop the #ifdef entirely and use
> __maybe_unused instead.

Hmmm... what version is this?

[2 mins pass]

Oh rubbish.  I've been a silly boy!

[spoiler alert: take a look at the end of the RTC driver patch]

Will be fixed in v3.

[...]

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
