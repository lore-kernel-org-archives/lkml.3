Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755487Ab3J2NU2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Oct 2013 09:20:28 -0400
Received: from mail-lb0-f181.google.com ([209.85.217.181]:39120 "EHLO
	mail-lb0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755389Ab3J2NUX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Oct 2013 09:20:23 -0400
Date: Tue, 29 Oct 2013 14:20:18 +0100
From: Johan Hovold <jhovold@gmail.com>
To: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
Cc: Johan Hovold <jhovold@gmail.com>, Richard Purdie <rpurdie@rpsys.net>,
        Jingoo Han <jg1.han@samsung.com>,
        Nicolas Ferre <nicolas.ferre@atmel.com>,
        Tomi Valkeinen <tomi.valkeinen@ti.com>,
        Andrew Morton <akpm@linux-foundation.org>, linux-fbdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 9/9] backlight: atmel-pwm-bl: use gpio_request_one
Message-ID: <20131029132018.GC29615@localhost>
References: <1382522143-32072-1-git-send-email-jhovold@gmail.com>
 <1382522143-32072-10-git-send-email-jhovold@gmail.com>
 <20131025111543.GV18477@ns203013.ovh.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131025111543.GV18477@ns203013.ovh.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 25, 2013 at 01:15:43PM +0200, Jean-Christophe PLAGNIOL-VILLARD wrote:
> On 11:55 Wed 23 Oct     , Johan Hovold wrote:
> > Use devm_gpio_request_one rather than requesting and setting direction
> > in two calls.
> 
> this is the same I do not see any advantage

It removes one error path.

> and as I said for ather backligth It's wrong to enable or disable it at probe
> as the bootloader might have already enable it for splash screen

I agree with you on that, and it's actually the reason for the below
clean up. I use a second patch:

        if (gpio_is_valid(pwmbl->gpio_on)) {
-               /* Turn display off by default. */
-               if (pdata->on_active_low)
+               /* Turn display off unless already enabled. */
+               if (pdata->gpio_on_enabled ^ pdata->on_active_low)
                        flags = GPIOF_OUT_INIT_HIGH;
                else
                        flags = GPIOF_OUT_INIT_LOW;

to make sure the driver does not temporarily disable the backlight at
probe.

Decided not to submit it as part of this series when I realised that
several other backlight drivers did the same, but perhaps I should?

Thanks,
Johan

> > 
> > Acked-by: Jingoo Han <jg1.han@samsung.com>:w
> > Signed-off-by: Johan Hovold <jhovold@gmail.com>
> > ---
> >  drivers/video/backlight/atmel-pwm-bl.c | 15 ++++++++-------
> >  1 file changed, 8 insertions(+), 7 deletions(-)
> > 
> > diff --git a/drivers/video/backlight/atmel-pwm-bl.c b/drivers/video/backlight/atmel-pwm-bl.c
> > index 1277e0c..5ea2517 100644
> > --- a/drivers/video/backlight/atmel-pwm-bl.c
> > +++ b/drivers/video/backlight/atmel-pwm-bl.c
> > @@ -124,6 +124,7 @@ static int atmel_pwm_bl_probe(struct platform_device *pdev)
> >  	const struct atmel_pwm_bl_platform_data *pdata;
> >  	struct backlight_device *bldev;
> >  	struct atmel_pwm_bl *pwmbl;
> > +	int flags;
> >  	int retval;
> >  
> >  	pdata = dev_get_platdata(&pdev->dev);
> > @@ -149,14 +150,14 @@ static int atmel_pwm_bl_probe(struct platform_device *pdev)
> >  		return retval;
> >  
> >  	if (gpio_is_valid(pwmbl->gpio_on)) {
> > -		retval = devm_gpio_request(&pdev->dev, pwmbl->gpio_on,
> > -					"gpio_atmel_pwm_bl");
> > -		if (retval)
> > -			goto err_free_pwm;
> > -
> >  		/* Turn display off by default. */
> > -		retval = gpio_direction_output(pwmbl->gpio_on,
> > -				0 ^ pdata->on_active_low);
> > +		if (pdata->on_active_low)
> > +			flags = GPIOF_OUT_INIT_HIGH;
> > +		else
> > +			flags = GPIOF_OUT_INIT_LOW;
> > +
> > +		retval = devm_gpio_request_one(&pdev->dev, pwmbl->gpio_on,
> > +						flags, "gpio_atmel_pwm_bl");
> >  		if (retval)
> >  			goto err_free_pwm;
> >  	}
> > -- 
> > 1.8.4
> > 
