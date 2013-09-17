Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752732Ab3IQKEw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Sep 2013 06:04:52 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:55072 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752598Ab3IQKEv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Sep 2013 06:04:51 -0400
Date: Tue, 17 Sep 2013 11:04:17 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Ludovic Desroches <ludovic.desroches@atmel.com>,
        Thomas Gleixner <tglx@linutronix.de>
Cc: Marc Kleine-Budde <mkl@pengutronix.de>, nicolas.ferre@atmel.com,
        linux-kernel@vger.kernel.org, Marc Pignat <marc.pignat@hevs.ch>,
        john.stultz@linaro.org, kernel@pengutronix.de,
        Ronald Wahl <ronald.wahl@raritan.com>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH] [PATCH] clocksource: tcb: fix min_delta calculation
Message-ID: <20130917100417.GQ12758@n2100.arm.linux.org.uk>
References: <1379077365-18458-1-git-send-email-mkl@pengutronix.de> <20130917095600.GJ26819@ludovic.desroches@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130917095600.GJ26819@ludovic.desroches@atmel.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 17, 2013 at 11:56:00AM +0200, Ludovic Desroches wrote:
> Any reason to not do this:
> 
> --- a/drivers/clocksource/tcb_clksrc.c
> +++ b/drivers/clocksource/tcb_clksrc.c
> @@ -144,6 +144,9 @@ static void tc_mode(enum clock_event_mode m, struct
> clock_event_device *d)
>  
>  static int tc_next_event(unsigned long delta, struct clock_event_device
> *d)
>  {
> +       if (delta < d->min_delta_ticks)
> +               delta = d->min_delta_ticks;
> +
>         __raw_writel(delta, tcaddr + ATMEL_TC_REG(2, RC));
>  
>         /* go go gadget! */
> 
> Then we can keep the same min_delta.

You really should not play such games in your set_next_event() code - if
the interval is not supported, you should return -ETIME so that the core
code knows about it and can adjust things to suit.  If you're getting
deltas which are too small for the hardware, that'll either be because
the bounds are wrong, or there's a bug in the core code.
