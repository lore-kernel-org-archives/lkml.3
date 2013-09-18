Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752129Ab3IRI4n (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Sep 2013 04:56:43 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:57148 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751902Ab3IRI4l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Sep 2013 04:56:41 -0400
Date: Wed, 18 Sep 2013 10:56:27 +0200
From: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Ludovic Desroches <ludovic.desroches@atmel.com>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Marc Kleine-Budde <mkl@pengutronix.de>, nicolas.ferre@atmel.com,
        LKML <linux-kernel@vger.kernel.org>, Marc Pignat <marc.pignat@hevs.ch>,
        john.stultz@linaro.org, kernel@pengutronix.de,
        Ronald Wahl <ronald.wahl@raritan.com>,
        LAK <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH] clockevents: Sanitize ticks to nsec conversion
Message-ID: <20130918085627.GN24802@pengutronix.de>
References: <1379077365-18458-1-git-send-email-mkl@pengutronix.de>
 <20130917095600.GJ26819@ludovic.desroches@atmel.com>
 <20130917100417.GQ12758@n2100.arm.linux.org.uk>
 <alpine.DEB.2.02.1309171210450.4089@ionos.tec.linutronix.de>
 <20130917130153.GL26819@ludovic.desroches@atmel.com>
 <alpine.DEB.2.02.1309172228400.4089@ionos.tec.linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <alpine.DEB.2.02.1309172228400.4089@ionos.tec.linutronix.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:21e:67ff:fe11:9c5c
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Thomas,

On Tue, Sep 17, 2013 at 11:15:20PM +0200, Thomas Gleixner wrote:
> Marc Kleine-Budde pointed out, that commit 77cc982 "clocksource: use
> clockevents_config_and_register() where possible" caused a regression
> for some of the converted subarchs.
> 
> The reason is, that the clockevents core code converts the minimal
> hardware tick delta to a nanosecond value for core internal
> usage. This conversion is affected by integer math rounding loss, so
> the backwards conversion to hardware ticks will likely result in a
> value which is less than the configured hardware limitation. The
> affected subarchs used their own workaround (SIGH!) which got lost in
> the conversion.
> 
> Now instead of fixing the underlying core code problem, Marcs patch
s/Marcs/Marc's/

> tried to work around the core code issue by increasing the minimal
> tick delta at clockevents registration time so the resulting limit in
> the core code backwards conversion did not violate the hardware
> limits. More SIGH!
> 
> The solution for the issue at hand is simple: adding evt->mult - 1 to
> the shifted value before the integer divison in the core conversion
> function takes care of it.
> 
> Though looking closer at the details of that function reveals another
> bogosity: The upper bounds check is broken as well. Checking for a
> resulting "clc" value greater than KTIME_MAX after the conversion is
> pointless. The conversion does:
> 
>       u64 clc = (latch << evt->shift) / evt->mult;
> 
> So there is no sanity check for (latch << evt->shift) exceeding the
> 64bit boundary. The latch argument is "unsigned long", so on a 64bit
> arch the handed in argument could easily lead to an unnoticed shift
> overflow. With the above rounding fix applied the calculation before
> the divison is:
> 
>        u64 clc = (latch << evt->shift) + evt->mult - 1;
> 
> Now we can easily verify whether the whole equation fits into the
> 64bit boundary. Shifting the "clc" result back by evt->shift MUST
> result in "latch". If that's not the case, we have a clear indicator
But this is only the case if evt->mult is <= (1 << evt->shift). Is this
always given?
Is it more sensible to adjust dev->max_delta_ns once at register time
and so save the often recurrent overflow check in
clockevents_program_event?

Another doubt I have is: You changed clockevent_delta2ns to round up now
unconditionally. For the numbers on at91 that doesn't matter, but I
wonder if there are situations that make the timer core violate the
max_delta_ticks condition now.

> for boundary violation and can limit "clc" to (1 << 63) - 1 before the
Where does this magic constant come from?

Best regards
Uwe

> divison by evt->mult. The resulting nsec * evt->mult in the
> programming path will therefor always be in the 64bit boundary.
> 
> Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
> ---
> diff --git a/kernel/time/clockevents.c b/kernel/time/clockevents.c
> index 38959c8..4fc4826 100644
> --- a/kernel/time/clockevents.c
> +++ b/kernel/time/clockevents.c
> @@ -49,13 +49,25 @@ u64 clockevent_delta2ns(unsigned long latch, struct clock_event_device *evt)
>  		WARN_ON(1);
>  	}
>  
> +	/*
> +	 * Prevent integer rounding loss, otherwise the backward
> +	 * conversion from nsec to ticks could result in a value less
> +	 * than evt->min_delta_ticks.
> +	 */
> +	clc += evt->mult - 1;
> +
> +	/*
> +	 * Upper bound sanity check. If the backwards conversion is
> +	 * not equal latch, we know that the above (shift + rounding
> +	 * correction) exceeded the 64 bit boundary.
> +	 */
> +	if ((clc >> evt->shift) != (u64)latch)
> +		clc = ((u64)1 << 63) - 1;
> +
>  	do_div(clc, evt->mult);
> -	if (clc < 1000)
> -		clc = 1000;
> -	if (clc > KTIME_MAX)
> -		clc = KTIME_MAX;
>  
> -	return clc;
> +	/* Deltas less than 1usec are pointless noise */
> +	return clc > 1000 ? clc : 1000;
>  }
>  EXPORT_SYMBOL_GPL(clockevent_delta2ns);
> 

-- 
Pengutronix e.K.                           | Uwe Kleine-König            |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
