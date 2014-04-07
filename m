Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755287AbaDGM0a (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Apr 2014 08:26:30 -0400
Received: from mail-out.m-online.net ([212.18.0.9]:40703 "EHLO
	mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755257AbaDGM0Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Apr 2014 08:26:24 -0400
X-Auth-Info: 5fIYYa92P4PH94udB8vMpVYkeGfnPedtqRKjimIt2mM=
Date: Mon, 7 Apr 2014 14:26:20 +0200
From: Gerhard Sittig <gsi@denx.de>
To: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: jamie@jamieiles.com, atull@altera.com, gnurou@gmail.com,
        linux-gpio@vger.kernel.org, linux-kernel@vger.kernel.org,
        dinguyen@altera.com, linus.walleij@linaro.org,
        sebastian.hesselbarth@gmail.com
Subject: Re: [PATCH 5/5] gpio: dwapb: use d->mask instead od BIT(bit)
Message-ID: <20140407122620.GX11339@book.gsilab.sittig.org>
References: <1396865589-9972-1-git-send-email-bigeasy@linutronix.de>
 <1396865589-9972-6-git-send-email-bigeasy@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1396865589-9972-6-git-send-email-bigeasy@linutronix.de>
Organization: DENX Software Engineering GmbH
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2014-04-07 at 12:13 +0200, Sebastian Andrzej Siewior wrote:
> 
> d->mask contains exact the same information as BIT(bit) so we could save
> a few cycles here.

ISTR that the benefit of saving cycles was questioned in previous
review comments.  On ARM, the shift "comes for free".

I'm not saying that the patch is doing something wrong.  But I
suggest to rephrase the commit message (and put the version
number into the subject prefix, should you have to resend).

Reducing the number of variables involved, or hiding details
behind common abstractions, or eliminating redundancy, all of
those benefits are as valuable.  It's just that this patch does
not save any computation time.

> --- a/drivers/gpio/gpio-dwapb.c
> +++ b/drivers/gpio/gpio-dwapb.c
> @@ -113,7 +113,7 @@ static void dwapb_irq_enable(struct irq_data *d)
>  
>  	irq_gc_lock(igc);
>  	val = readl(gpio->regs + GPIO_INTEN);
> -	val |= BIT(d->hwirq);
> +	val |= d->mask;

these are equally costly or cheap, nothing saved here

>  	struct dwapb_gpio *gpio = igc->private;
> -	int bit = d->hwirq;
> +	u32 mask = d->mask;
>  	unsigned long level, polarity;
>  
>  	if (type & ~(IRQ_TYPE_EDGE_RISING | IRQ_TYPE_EDGE_FALLING |
> @@ -171,24 +171,24 @@ static int dwapb_irq_set_type(struct irq_data *d, u32 type)
>  
>  	switch (type) {
>  	case IRQ_TYPE_EDGE_BOTH:
> -		level |= BIT(bit);
> -		dwapb_toggle_trigger(gpio, bit);
> +		level |= mask;
> +		dwapb_toggle_trigger(gpio, d->hwirq);

these introduce another pointer dereference, unless 'bit' was
assigned from a pointer dereference (as is shown above), so
nothing was gained


virtually yours
Gerhard Sittig
-- 
DENX Software Engineering GmbH,     MD: Wolfgang Denk & Detlev Zundel
HRB 165235 Munich, Office: Kirchenstr. 5, D-82194 Groebenzell, Germany
Phone: +49-8142-66989-0 Fax: +49-8142-66989-80  Email: office@denx.de
