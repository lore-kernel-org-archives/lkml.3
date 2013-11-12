Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756078Ab3KLQ1k (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Nov 2013 11:27:40 -0500
Received: from mail-pd0-f181.google.com ([209.85.192.181]:37455 "EHLO
	mail-pd0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753484Ab3KLQ1f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Nov 2013 11:27:35 -0500
Date: Tue, 12 Nov 2013 08:27:31 -0800
From: Guenter Roeck <linux@roeck-us.net>
To: Santosh Shilimkar <santosh.shilimkar@ti.com>
Cc: "ivan.khoronzhuk" <ivan.khoronzhuk@ti.com>, wim@iguana.be, nsekhar@ti.com,
        linux-watchdog@vger.kernel.org, devicetree@vger.kernel.org,
        grant.likely@linaro.org, rob.herring@calxeda.com, pawel.moll@arm.com,
        mark.rutland@arm.com, swarren@wwwdotorg.org, galak@kernel.crashing.org,
        ijc+devicetree@hellion.org.uk, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: Fwd: [PATCH 2/8] watchdog: davinci: use davinci_wdt_device
 structure to hold device data
Message-ID: <20131112162731.GA5449@roeck-us.net>
References: <1383680783-12114-3-git-send-email-ivan.khoronzhuk@ti.com>
 <527A2888.5030604@ti.com>
 <52824B20.9080002@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <52824B20.9080002@ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 12, 2013 at 10:37:04AM -0500, Santosh Shilimkar wrote:
> On Wednesday 06 November 2013 06:31 AM, ivan.khoronzhuk wrote:
> > Some SoCs, like Keystone 2, can support more than one WDT and each
> > watchdog device has to use it's own base address, clock source,
> > wdd device, so add new davinci_wdt_device structure to hold device
> In commit avoid struct names ;)
> s/wdd/watchdog device
> > data.
> > 
> > Signed-off-by: Ivan Khoronzhuk <ivan.khoronzhuk@ti.com>
> > ---
> >  drivers/watchdog/davinci_wdt.c |   74 ++++++++++++++++++++++++++--------------
> >  1 file changed, 48 insertions(+), 26 deletions(-)
> > 
> > diff --git a/drivers/watchdog/davinci_wdt.c b/drivers/watchdog/davinci_wdt.c
> > index a6eef71..1fc2093 100644
> > --- a/drivers/watchdog/davinci_wdt.c
> > +++ b/drivers/watchdog/davinci_wdt.c
> 
> [...]
> 
> > @@ -123,14 +135,21 @@ static int davinci_wdt_probe(struct platform_device *pdev)
> >  	struct device *dev = &pdev->dev;
> >  	struct resource  *wdt_mem;
> >  	struct watchdog_device *wdd;
> > +	struct davinci_wdt_device *davinci_wdt;
> > +
> > +	davinci_wdt = devm_kzalloc(dev, sizeof(*davinci_wdt), GFP_KERNEL);
> > +	if (!davinci_wdt)
> > +		return -ENOMEM;
> >  
> > -	wdt_clk = devm_clk_get(dev, NULL);
> > -	if (WARN_ON(IS_ERR(wdt_clk)))
> > -		return PTR_ERR(wdt_clk);
> > +	davinci_wdt->clk = devm_clk_get(dev, NULL);
> > +	if (WARN_ON(IS_ERR(davinci_wdt->clk)))
> > +		return PTR_ERR(davinci_wdt->clk);
> >  
> > -	clk_prepare_enable(wdt_clk);
> > +	clk_prepare_enable(davinci_wdt->clk);
> >  
> > -	wdd			= &wdt_wdd;
> > +	platform_set_drvdata(pdev, davinci_wdt);
> > +
> > +	wdd			= &davinci_wdt->wdd;
> >  	wdd->info		= &davinci_wdt_info;
> >  	wdd->ops		= &davinci_wdt_ops;
> >  	wdd->min_timeout 	= 1;
> > @@ -142,12 +161,13 @@ static int davinci_wdt_probe(struct platform_device *pdev)
> >  
> >  	dev_info(dev, "heartbeat %d sec\n", wdd->timeout);
> >  
> > +	watchdog_set_drvdata(wdd, davinci_wdt);
> >  	watchdog_set_nowayout(wdd, WATCHDOG_NOWAYOUT);
> >  
> >  	wdt_mem = platform_get_resource(pdev, IORESOURCE_MEM, 0);
> > -	wdt_base = devm_ioremap_resource(dev, wdt_mem);
> > -	if (IS_ERR(wdt_base))
> > -		return PTR_ERR(wdt_base);
> > +	davinci_wdt->base = devm_ioremap_resource(dev, wdt_mem);
> > +	if (IS_ERR(davinci_wdt->base))
> > +		return PTR_ERR(davinci_wdt->base);
> You should free up davinci_wdt memory before returning, right ?
> 
No, devm should take care of that.

Guenter

> Other than that patch looks fine to me. With above fixed,
> Acked-by: Santosh Shilimkar <santosh.shilimkar@ti.com>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-watchdog" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
