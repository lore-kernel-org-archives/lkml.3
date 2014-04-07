Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756427AbaDGTBk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Apr 2014 15:01:40 -0400
Received: from mail-out.m-online.net ([212.18.0.9]:60892 "EHLO
	mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756127AbaDGTBh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Apr 2014 15:01:37 -0400
X-Auth-Info: XyiMGGC7yTYauDe1tN8eeAxp3FoB/d0geKey5nRNGjs=
Date: Mon, 7 Apr 2014 21:01:26 +0200
From: Gerhard Sittig <gsi@denx.de>
To: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: jamie@jamieiles.com, atull@altera.com, gnurou@gmail.com,
        linux-gpio@vger.kernel.org, linux-kernel@vger.kernel.org,
        dinguyen@altera.com, linus.walleij@linaro.org,
        sebastian.hesselbarth@gmail.com
Subject: Re: [PATCH 5/5] gpio: dwapb: use d->mask instead od BIT(bit)
Message-ID: <20140407190126.GG11339@book.gsilab.sittig.org>
References: <1396865589-9972-1-git-send-email-bigeasy@linutronix.de>
 <1396865589-9972-6-git-send-email-bigeasy@linutronix.de>
 <20140407122620.GX11339@book.gsilab.sittig.org>
 <5342EDD6.3050706@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5342EDD6.3050706@linutronix.de>
Organization: DENX Software Engineering GmbH
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[ ignore this if you are busy :) ]

On Mon, 2014-04-07 at 20:26 +0200, Sebastian Andrzej Siewior wrote:
> 
> On 04/07/2014 02:26 PM, Gerhard Sittig wrote:
> > On Mon, 2014-04-07 at 12:13 +0200, Sebastian Andrzej Siewior wrote:
> >>
> >> d->mask contains exact the same information as BIT(bit) so we could save
> >> a few cycles here.
> > 
> > ISTR that the benefit of saving cycles was questioned in previous
> > review comments.  On ARM, the shift "comes for free".
> 
> I can't recall that some pointed this out.

http://article.gmane.org/gmane.linux.kernel.gpio/2410 raises a
concern about the cost of dereferencing pointers

That shifts might not involve additional cost appears to not have
been stated explicitly in earlier feedback, or I have missed it
in the search, doesn't matter much.  Might as well have confused
this submission with another one.

> However:
> - you load one variable in both cases. Not performing the shift means
>   there is at least one instruction less to be performed.
> - that gpio controller is generic IP core from Synopsys. Every can buy
>   it and but into their IP core so it is not limited to ARM.

You assume that the shift is done in an individual instruction.
That does not necessarily apply to the ARM architecture, which
has a barrel shifter and can fold shifts into other instructions
"for free".

This IP core has "APB" in its name, which is a memory bus that
I've never seen in use outside of the ARM ecosphere.  Whatever
that may be worth, anyway.  We are not talking about the kind of
GPIO block that resides in FPGAs, we are talking about an IP
block that is "on the CPU side" of SoCs.

But see below, I do not want to block anything, feel free to
ignore my concerns as they are not strong here.

> >> --- a/drivers/gpio/gpio-dwapb.c
> >> +++ b/drivers/gpio/gpio-dwapb.c
> >> @@ -113,7 +113,7 @@ static void dwapb_irq_enable(struct irq_data *d)
> >>  
> >>  	irq_gc_lock(igc);
> >>  	val = readl(gpio->regs + GPIO_INTEN);
> >> -	val |= BIT(d->hwirq);
> >> +	val |= d->mask;
> > 
> > these are equally costly or cheap, nothing saved here
> 
> I still thing not performing an instruction is more efficient than
> performing one.
> 
> >>  	struct dwapb_gpio *gpio = igc->private;
> >> -	int bit = d->hwirq;
> >> +	u32 mask = d->mask;
> >>  	unsigned long level, polarity;
> >>  
> >>  	if (type & ~(IRQ_TYPE_EDGE_RISING | IRQ_TYPE_EDGE_FALLING |
> >> @@ -171,24 +171,24 @@ static int dwapb_irq_set_type(struct irq_data *d, u32 type)
> >>  
> >>  	switch (type) {
> >>  	case IRQ_TYPE_EDGE_BOTH:
> >> -		level |= BIT(bit);
> >> -		dwapb_toggle_trigger(gpio, bit);
> >> +		level |= mask;
> >> +		dwapb_toggle_trigger(gpio, d->hwirq);
> > 
> > these introduce another pointer dereference, unless 'bit' was
> > assigned from a pointer dereference (as is shown above), so
> > nothing was gained
> 
> dwapb_toggle_trigger() is a bit special and it needs both. However,
> size on ARM says
> 
>    text    data     bss     dec     hex filename
>    3264      96       0    3360     d20 drivers/gpio/gpio-dwapb.o.before
>    3224      96       0    3320     cf8 drivers/gpio/gpio-dwapb.o.after
> 
> that with the patch the code is smaller by 40 bytes. Does 40 bytes
> smaller code quality for "safe a few cycles" statement?

I would not necessarily jump to the conclusion that code of
smaller size translates into fewer instructions.  It may be an
educated guess here in this specific situation (given the very
nature of the change), but does not apply in general.  Actually
you can reduce code size by adding instruction overhead, and
speed up code by unrolling it.  There always is the compromise
between space and time.

It's hard to tell without further analysis of the generated code
whether this specific reduction in size comes from eliminated
shifts, or from the re-use of already pre-loaded variables.  I'd
rather assume the latter, and suggested such a potential cause in
my earlier reply.

Anyway, it's not that I would have strong feelings about this
change.  It's just that I wanted to check whether the motivation
and the description are correct, and observed effects are not
assigned to unrelated components.  Never did I question the
benefit of cleaning up redundancy, I was questioning whether the
commit message appropriately reflects what is observed.

You have presented numbers that were not available before.  The
assumption that your change reduces code size is supported.  The
explanation is an educated guess, concerns are small.  Nevermind.


virtually yours
Gerhard Sittig
-- 
DENX Software Engineering GmbH,     MD: Wolfgang Denk & Detlev Zundel
HRB 165235 Munich, Office: Kirchenstr. 5, D-82194 Groebenzell, Germany
Phone: +49-8142-66989-0 Fax: +49-8142-66989-80  Email: office@denx.de
