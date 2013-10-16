Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932923Ab3JPBWK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Oct 2013 21:22:10 -0400
Received: from p3plex2out02.prod.phx3.secureserver.net ([184.168.131.14]:47162
	"EHLO p3plex2out02.prod.phx3.secureserver.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751277Ab3JPBWJ convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Oct 2013 21:22:09 -0400
From: Hartley Sweeten <HartleyS@visionengravers.com>
To: Thierry Reding <thierry.reding@gmail.com>
CC: "linux-pwm@vger.kernel.org" <linux-pwm@vger.kernel.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Ryan Mallon <rmallon@gmail.com>, "arnd@arndb.de" <arnd@arndb.de>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>
Subject: RE: [PATCH] pwm: add ep93xx PWM support
Thread-Topic: [PATCH] pwm: add ep93xx PWM support
Thread-Index: AQHOyZMnZxZpkoOYQUeFKsUjpfVQCpn2he0g
Date: Wed, 16 Oct 2013 01:22:07 +0000
Message-ID: <DC148C5AA1CEBA4E87973D432B1C2D8817DAE318@P3PWEX4MB008.ex4.secureserver.net>
References: <201310141457.49208.hartleys@visionengravers.com>
 <20131015103932.GN7856@ulmo.nvidia.com>
In-Reply-To: <20131015103932.GN7856@ulmo.nvidia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [184.183.19.121]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, October 15, 2013 3:40 AM, Thierry Reding wrote:
> On Mon, Oct 14, 2013 at 02:57:48PM -0700, H Hartley Sweeten wrote:
>> Remove the non-standard EP93xx pwm driver in drivers/misc and add
>
> pwm -> PWM

OK

>> a new driver for the PWM chips on the EP93xx platforms based on the
>> PWM framework.
>> 
>> These PWM chips each support 1 PWM channel with programmable duty
>
> Perhaps "chips" -> "controllers"?

OK

>> cycle, frequency, and polarity inversion.
>> 
>> Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
>> Cc: Ryan Mallon <rmallon@gmail.com>
>> Cc: Thierry Reding <thierry.reding@gmail.com>
>> Cc: Arnd Bergmann <arnd@arndb.de>
>> Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
>> 
>> diff --git a/drivers/misc/ep93xx_pwm.c b/drivers/misc/ep93xx_pwm.c
> [...]
>> - *	(c) Copyright 2009  Matthieu Crapet <mcrapet@gmail.com>
>> - *	(c) Copyright 2009  H Hartley Sweeten <hsweeten@visionengravers.com>
> [...]
>> -MODULE_AUTHOR("Matthieu Crapet <mcrapet@gmail.com>, "
>> -	      "H Hartley Sweeten <hsweeten@visionengravers.com>");
> [...]
>
>> diff --git a/drivers/pwm/pwm-ep93xx.c b/drivers/pwm/pwm-ep93xx.c
> [...]
>> + * Copyright (C) 2013 H Hartley Sweeten <hsweeten@visionengravers.com>
> [...]
>> +MODULE_AUTHOR("H Hartley Sweeten <hsweeten@visionengravers.com>");
>
> Why are you removing Matthieu from the list of authors and copyright
> here? From a brief look it seems like this new driver is still based on
> code from the old driver and not a complete rewrite.

My bad. It is based on the misc driver but I forgot to put Matthieu in as
one of the original authors when I wrote it.

I'll fix that.

>> +#include <mach/platform.h>	/* for ep93xx_pwm_{acquire,release}_gpio() */
>
> I'm not sure how well that will play together with multiplatform support
> but perhaps that's not an issue for ep93xx?

For multiplatform it would probably be a problem. But I don't think anyone
would be including ep93xx in a multiplatform kernel. If the problem comes up
I'll figure out some way to deal with it, probably with a pinctrl driver.

>> +static int ep93xx_pwm_request(struct pwm_chip *chip, struct pwm_device *pwm)
>> +{
>> +	struct platform_device *pdev = to_platform_device(chip->dev);
>> +
>> +	return ep93xx_pwm_acquire_gpio(pdev);
>> +}
>> +
>> +static void ep93xx_pwm_free(struct pwm_chip *chip, struct pwm_device *pwm)
>> +{
>> +	struct platform_device *pdev = to_platform_device(chip->dev);
>> +
>> +	ep93xx_pwm_release_gpio(pdev);
>> +}
>
> This looks like it would belong in the domain of pinctrl, but I suspect
> that ep93xx doesn't support that.

It should be but I have not worked out how to support EP93xx GPIOs with a
pinctrl driver yet. The GPIOs are pretty limited on this platform compared to
the other pinctrl users.

>> +static int ep93xx_pwm_config(struct pwm_chip *chip, struct pwm_device *pwm,
>> +			     int duty_ns, int period_ns)
>> +{
>> +	struct ep93xx_pwm *ep93xx_pwm = to_ep93xx_pwm(chip);
>> +	void __iomem *base = ep93xx_pwm->base;
>> +	unsigned long long c;
>> +	unsigned long period_cycles;
>> +	unsigned long duty_cycles;
>> +	unsigned long term;
>> +	int ret = 0;
>> +
>> +	/*
>> +	 * The clock needs to be enabled to access the PWM registers.
>> +	 * Configuration can be changed at any time.
>> +	 */
>> +	if (!test_bit(PWMF_ENABLED, &pwm->flags))
>> +		clk_enable(ep93xx_pwm->clk);
>
> clk_enable() can fail, so you should check the return value and
> propagate errors.

I overlooked that. This will be fixed in the next version.

>> +static int ep93xx_pwm_polarity(struct pwm_chip *chip, struct pwm_device *pwm,
>> +			       enum pwm_polarity polarity)
>> +{
>> +	struct ep93xx_pwm *ep93xx_pwm = to_ep93xx_pwm(chip);
>> +
>> +	/*
>> +	 * The clock needs to be enabled to access the PWM registers.
>> +	 * Polarity can only be changed when the PWM is disabled.
>> +	  */
>
> Nit: the closing */ is wrongly aligned.

OK

>> +	clk_enable(ep93xx_pwm->clk);
>
> Needs a check of the return value.

OK

>> +	writew(polarity, ep93xx_pwm->base + EP93XX_PWMx_INVERT);
>
> I'd prefer if this did some explicit conversion from the PWM framework
> value to the driver-specific value, even if they happen to be the same
> in this case.

OK

>> +static int ep93xx_pwm_enable(struct pwm_chip *chip, struct pwm_device *pwm)
>> +{
>> +	struct ep93xx_pwm *ep93xx_pwm = to_ep93xx_pwm(chip);
>> +
>> +	clk_enable(ep93xx_pwm->clk);
>
> Also needs to check the return value.

OK

>> +static struct pwm_ops ep93xx_pwm_ops = {
>
> static const, please.

OK

>> +static int ep93xx_pwm_remove(struct platform_device *pdev)
>> +{
>> +	struct ep93xx_pwm *ep93xx_pwm;
>> +
>> +	ep93xx_pwm = platform_get_drvdata(pdev);
>> +	if (!ep93xx_pwm)
>> +		return -ENODEV;
>
> No need for this check. It will never happen.

OK

>> +
>> +	return pwmchip_remove(&ep93xx_pwm->chip);
>> +}
>> +
>> +static struct platform_driver ep93xx_pwm_driver = {
>> +	.driver		= {
>> +		.name	= "ep93xx-pwm",
>> +		.owner	= THIS_MODULE,
>
> This is no longer required because the core sets it to the proper value.

OK

>> +	},
>> +	.probe		= ep93xx_pwm_probe,
>> +	.remove		= ep93xx_pwm_remove,
>> +};
>
> Oh, and I didn't mention it before, but please get rid of all the
> needless tabs for alignment. It's completely useless and doesn't help
> with readability at all in my opinion.

Opinions differ.. But I'll remove the tabs.

Thanks for the review,
Hartley

