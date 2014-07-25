Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760509AbaGYWtL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jul 2014 18:49:11 -0400
Received: from v094114.home.net.pl ([79.96.170.134]:50138 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752445AbaGYWtI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jul 2014 18:49:08 -0400
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org,
        Linux PM list <linux-pm@vger.kernel.org>
Subject: Re: [RFC][PATCH] irq: Rework IRQF_NO_SUSPENDED
Date: Sat, 26 Jul 2014 01:07:35 +0200
Message-ID: <2363344.XLlmCjS7fv@vostro.rjw.lan>
User-Agent: KMail/4.11.5 (Linux/3.16.0-rc5+; KDE/4.11.5; x86_64; ; )
In-Reply-To: <1663327.PISiM9sMHC@vostro.rjw.lan>
References: <20140724212620.GO3935@laptop> <alpine.DEB.2.10.1407252217350.23352@nanos> <1663327.PISiM9sMHC@vostro.rjw.lan>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday, July 26, 2014 12:25:29 AM Rafael J. Wysocki wrote:
> On Friday, July 25, 2014 11:00:12 PM Thomas Gleixner wrote:
> > On Fri, 25 Jul 2014, Rafael J. Wysocki wrote:
> > > On Friday, July 25, 2014 03:25:41 PM Peter Zijlstra wrote:
> > > > OK, so Rafael said there's devices that keep on raising their interrupt
> > > > until they get attention. Ideally this won't happen because the device
> > > > is suspended etc.. But I'm sure there's some broken piece of hardware
> > > > out there that'll make it go boom.
> > > 
> > > So here's an idea.
> > > 
> > > What about returning IRQ_NONE rather than IRQ_HANDLED for "suspended"
> > > interrupts (after all, that's what a sane driver would do for a
> > > suspended device I suppose)?
> > > 
> > > If the line is really shared and the interrupt is taken care of by
> > > the other guy sharing the line, we'll be all fine.
> > > 
> > > If that is not the case, on the other hand, and something's really
> > > broken, we'll end up disabling the interrupt and marking it as
> > > IRQS_SPURIOUS_DISABLED (if I understand things correctly).
> > 
> > We should not wait 100k unhandled interrupts in that case. We know
> > already at the first unhandled interrupt that the shit hit the fan.
> 
> The first one may be a bus glitch or some such.  Also I guess we still need to
> allow the legitimate "no suspend" guy to handle his interrupts until it gets
> too worse.

s/worse/bad/ (ah, grammar).

> Also does it really hurt to rely on the generic mechanism here?  We regard
> it as fine at all other times after all.
> 
> > I'll have a deeper look how we can sanitize the whole wake/no_suspend
> > logic vs. shared interrupts.
> 
> Cool, thanks!
> 
> > Need to look at the usage sites first.
> 
> There will be more of them, like this:
> 
> https://patchwork.kernel.org/patch/4618531/
> 
> Essentially, all wakeup interrupts will need at least one no_suspend irqaction
> going forward.
> 
> Below is my take on this (untested) in case it is useful for anything.
> 
> It is targeted at the problematic case (that is, a shared interrupt with at least
> one irqaction that has IRQF_NO_SUSPEND set and at least one that doesn't) only and
> is not supposed to change behavior in the other cases (the do_irqaction thing
> shamelessly stolen from the Peter's patch).  It drops the IRQD_WAKEUP_STATE check,
> because that has the same problem with shared interrupts as no_suspend.

Self-correction ->

> ---
>  kernel/irq/handle.c |   21 ++++++++++++++++++---
>  kernel/irq/manage.c |   30 +++++++++++++++++++++++++-----
>  2 files changed, 43 insertions(+), 8 deletions(-)
> 
> Index: linux-pm/kernel/irq/manage.c
> ===================================================================
> --- linux-pm.orig/kernel/irq/manage.c
> +++ linux-pm/kernel/irq/manage.c

[cut]

> @@ -446,7 +459,15 @@ EXPORT_SYMBOL(disable_irq);
>  void __enable_irq(struct irq_desc *desc, unsigned int irq, bool resume)
>  {
>  	if (resume) {
> -		if (!(desc->istate & IRQS_SUSPENDED)) {
> +		if (desc->istate & IRQS_SUSPENDED) {
> +			desc->istate &= ~IRQS_SUSPENDED;
> +			if (desc->istate & IRQS_SPURIOUS_DISABLED) {
> +				pr_err("WARNING! Unhandled events during suspend for IRQ %d\n", irq);

-> This should be printed for desc->irqs_unhandled > 0 I suppose.  That will cover
the cases when we don't have to disable it too.  The value of desc->irqs_unhandled
can be included into the warning too.

Rafael

