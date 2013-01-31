Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755221Ab3AaICB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jan 2013 03:02:01 -0500
Received: from mail-wi0-f177.google.com ([209.85.212.177]:59568 "EHLO
	mail-wi0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755101Ab3AaIB5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jan 2013 03:01:57 -0500
Date: Thu, 31 Jan 2013 08:01:51 +0000
From: Lee Jones <lee.jones@linaro.org>
To: Stephen Warren <swarren@wwwdotorg.org>
Cc: Linus Walleij <linus.walleij@stericsson.com>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Stephen Warren <swarren@nvidia.com>,
        Anmar Oueja <anmar.oueja@linaro.org>,
        Linus Walleij <linus.walleij@linaro.org>
Subject: Re: [PATCH 4/4] pinctrl/abx500: destroy mutex if returning early due
 to error
Message-ID: <20130131080151.GA5301@gmail.com>
References: <1359574822-15729-1-git-send-email-linus.walleij@stericsson.com>
 <51097E35.6080100@wwwdotorg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <51097E35.6080100@wwwdotorg.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 30 Jan 2013, Stephen Warren wrote:

> On 01/30/2013 12:40 PM, Linus Walleij wrote:
> > From: Lee Jones <lee.jones@linaro.org>
> > 
> > Current failure path neglects to mutex_destroy() before returning
> > an error due to an invalid parameter or an error received from
> > gpiochip_add(). This patch aims to remedy that behaviour.
> 
> > diff --git a/drivers/pinctrl/pinctrl-abx500.c b/drivers/pinctrl/pinctrl-abx500.c
> 
> > @@ -1155,11 +1155,13 @@ static int abx500_gpio_probe(struct platform_device *pdev)
> >  	default:
> >  		dev_err(&pdev->dev, "Unsupported pinctrl sub driver (%d)\n",
> >  				(int) platid->driver_data);
> > +		mutex_destroy(&pct->lock);
> >  		return -EINVAL;
> 
> Especially given there's already a label out_free which performs this
> mutex_destroy(), those last two lines would be better as:
> 
> ret = -EINVAL;
> goto out_free;

Yes, that's one way of doing it. I figured it was 6 of one and half a
dozen of the other to be honest.

Either I:

 +           mutex_destroy(&pct->lock);

Or:

 +           ret = -EINVAL; 
 +           goto out_free;
 -           return -EINVAL;

I figured the smallest diff would be best. To be honest, I'm not
bothered either way. If it offends you, I can do it the other way, no
problem. Just let me know quick, so I can get the fixed up patch to
Linus.

NB: There is no 'out_free:' at this point, it has already been
removed.

I'll leave it up to you.

> >  	}
> >  
> >  	if (!pct->soc) {
> >  		dev_err(&pdev->dev, "Invalid SOC data\n");
> > +		mutex_destroy(&pct->lock);
> >  		return -EINVAL;
> 
> Same there.
> 
> >  	}
> >  
> > @@ -1176,6 +1178,7 @@ static int abx500_gpio_probe(struct platform_device *pdev)
> >  	ret = gpiochip_add(&pct->chip);
> >  	if (ret) {
> >  		dev_err(&pdev->dev, "unable to add gpiochip: %d\n", ret);
> > +		mutex_destroy(&pct->lock);
> >  		goto out_rem_irq;
> 
> And here, just change the goto target to out_free rather than adding the
> mutex_destroy() call.


-- 
Lee Jones
Linaro ST-Ericsson Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
