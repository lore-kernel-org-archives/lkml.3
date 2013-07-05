Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752400Ab3GEXpU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Jul 2013 19:45:20 -0400
Received: from www.linutronix.de ([62.245.132.108]:47311 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751599Ab3GEXpS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Jul 2013 19:45:18 -0400
Date: Sat, 6 Jul 2013 01:45:09 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: =?ISO-8859-15?Q?Heiko_St=FCbner?= <heiko@sntech.de>
cc: John Stultz <john.stultz@linaro.org>, Jamie Iles <jamie@jamieiles.com>,
        Dinh Nguyen <dinguyen@altera.com>,
        Grant Likely <grant.likely@linaro.org>,
        linux-arm-kernel@lists.infradead.org,
        Rob Herring <rob.herring@calxeda.com>,
        devicetree-discuss@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        Arnd Bergmann <arnd@arndb.de>, Olof Johansson <olof@lixom.net>,
        Ulrich Prinz <ulrich.prinz@googlemail.com>
Subject: Re: [PATCH 3/9] clocksource: dw_apb_timer: quirk for variants with
 64bit counter
In-Reply-To: <201307060053.10182.heiko@sntech.de>
Message-ID: <alpine.DEB.2.02.1307060129340.32106@ionos.tec.linutronix.de>
References: <201307060051.09716.heiko@sntech.de> <201307060053.10182.heiko@sntech.de>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="8323329-2090385007-1373067910=:32106"
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--8323329-2090385007-1373067910=:32106
Content-Type: TEXT/PLAIN; charset=utf-8
Content-Transfer-Encoding: 8BIT

On Sat, 6 Jul 2013, Heiko Stübner wrote:

> This adds a quirk for IP variants containing two load_count and value
> registers that are used to provide 64bit accuracy on 32bit systems.
> 
> The added accuracy is currently not used, the driver is only adapted to
> handle the different register layout and make it work on affected devices.
> 
> Signed-off-by: Heiko Stuebner <heiko@sntech.de>
> ---
>  drivers/clocksource/dw_apb_timer.c |   27 +++++++++++++++++++++++++++
>  include/linux/dw_apb_timer.h       |    6 ++++++
>  2 files changed, 33 insertions(+)
> 
> diff --git a/drivers/clocksource/dw_apb_timer.c b/drivers/clocksource/dw_apb_timer.c
> index f5e7be8..bd45351 100644
> --- a/drivers/clocksource/dw_apb_timer.c
> +++ b/drivers/clocksource/dw_apb_timer.c
> @@ -56,6 +56,17 @@ static void apbt_init_regs(struct dw_apb_timer *timer, int quirks)
>  	timer->reg_control = APBTMR_N_CONTROL;
>  	timer->reg_eoi = APBTMR_N_EOI;
>  	timer->reg_int_status = APBTMR_N_INT_STATUS;
> +
> +	/*
> +	 * On variants with 64bit counters some registers are
> +	 * moved further down.
> +	 */
> +	if (quirks & APBTMR_QUIRK_64BIT_COUNTER) {
> +		timer->reg_current_value += 0x4;
> +		timer->reg_control += 0x8;
> +		timer->reg_eoi += 0x8;
> +		timer->reg_int_status += 0x8;
> +	}
>  }

Oh, no. this is not how we handle these things.

1) We want proper constants for this 64bit IP block 

2) This is not a quirk, it's a property of that particular IP block

You already made the register offsets a part of the timer structure,
so why don't you supply a proper structure filled with that values to
the init function?

That's what we do all over the place. Either we instantiate those
structs at compile time or runtime fed by device tree or any other
configuration mechanism.
  
>  static unsigned long apbt_readl(struct dw_apb_timer *timer, unsigned long offs)
> @@ -145,6 +156,10 @@ static void apbt_set_mode(enum clock_event_mode mode,
>  		udelay(1);
>  		pr_debug("Setting clock period %lu for HZ %d\n", period, HZ);
>  		apbt_writel(timer, period, timer->reg_load_count);
> +
> +		if (timer->quirks & APBTMR_QUIRK_64BIT_COUNTER)
> +			apbt_writel(timer, 0, timer->reg_load_count + 0x4);
> +

No. We are not adding such conditional constructs when we can deal
with them just by providing a proper set of function pointers. And
definitely not with hardcoded magic 0x4 constants involved.

     timer->load_count(timer, value);

Provide a 32 bit and a 64 bit version of that function and be done
with it.

>  		ctrl |= APBTMR_CONTROL_ENABLE;
>  		apbt_writel(timer, ctrl, timer->reg_control);
>  		break;
> @@ -168,6 +183,10 @@ static void apbt_set_mode(enum clock_event_mode mode,
>  		 * running mode.
>  		 */
>  		apbt_writel(timer, ~0, timer->reg_load_count);
> +
> +		if (timer->quirks & APBTMR_QUIRK_64BIT_COUNTER)
> +			apbt_writel(timer, 0, timer->reg_load_count + 0x4);
> +

Makes this copy go away.

>  		ctrl &= ~APBTMR_CONTROL_INT;
>  		ctrl |= APBTMR_CONTROL_ENABLE;
>  		apbt_writel(timer, ctrl, timer->reg_control);
> @@ -199,6 +218,10 @@ static int apbt_next_event(unsigned long delta,
>  	apbt_writel(timer, ctrl, timer->reg_control);
>  	/* write new count */
>  	apbt_writel(timer, delta, timer->reg_load_count);
> +
> +	if (timer->quirks & APBTMR_QUIRK_64BIT_COUNTER)
> +		apbt_writel(timer, 0, timer->reg_load_count + 0x4);
> +

And this one as well.

>  	ctrl |= APBTMR_CONTROL_ENABLE;
>  	apbt_writel(timer, ctrl, timer->reg_control);
>  
> @@ -325,6 +348,10 @@ void dw_apb_clocksource_start(struct dw_apb_clocksource *dw_cs)
>  	ctrl &= ~APBTMR_CONTROL_ENABLE;
>  	apbt_writel(timer, ctrl, timer->reg_control);
>  	apbt_writel(timer, ~0, timer->reg_load_count);
> +
> +	if (timer->quirks & APBTMR_QUIRK_64BIT_COUNTER)
> +		apbt_writel(timer, 0, timer->reg_load_count + 0x4);
> +

Copy and paste is a conveniant thing, right? It just should have a pop
up window assigned which asks at the second instance of copying the
same thing whether you really thought about it.

Thanks,

	tglx
--8323329-2090385007-1373067910=:32106--
