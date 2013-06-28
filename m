Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752152Ab3F1Ufg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Jun 2013 16:35:36 -0400
Received: from mail-ee0-f52.google.com ([74.125.83.52]:57088 "EHLO
	mail-ee0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751557Ab3F1Uff (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Jun 2013 16:35:35 -0400
From: Tomasz Figa <tomasz.figa@gmail.com>
To: linux-arm-kernel@lists.infradead.org
Cc: Thomas Gleixner <tglx@linutronix.de>,
        Maxime Ripard <maxime.ripard@free-electrons.com>,
        Emilio Lopez <emilio@elopez.com.ar>, linux-kernel@vger.kernel.org,
        linux-sunxi@googlegroups.com, John Stultz <john.stultz@linaro.org>,
        sunny@allwinnertech.com, shuge@allwinnertech.com,
        kevin@allwinnertech.com
Subject: Re: [PATCHv2 4/8] clocksource: sun4i: Fix the next event code
Date: Fri, 28 Jun 2013 22:35:29 +0200
Message-ID: <7300725.devmrYGi4t@flatron>
User-Agent: KMail/4.10.4 (Linux/3.9.7-gentoo; KDE/4.10.4; x86_64; ; )
In-Reply-To: <alpine.DEB.2.02.1306282204220.4013@ionos.tec.linutronix.de>
References: <1372449386-1334-1-git-send-email-maxime.ripard@free-electrons.com> <1372449386-1334-5-git-send-email-maxime.ripard@free-electrons.com> <alpine.DEB.2.02.1306282204220.4013@ionos.tec.linutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 28 of June 2013 22:13:08 Thomas Gleixner wrote:
> On Fri, 28 Jun 2013, Maxime Ripard wrote:
> > The next_event logic was setting the next interval to fire in the
> > current timer value instead of the interval value register, which is
> > obviously wrong.
> 
> Ok.
> 
> > Plus the logic to set the actual value was wrong as well, so this
> > code has always been broken.
> 
> This lacks an explanation why the logic is wrong and what the actual
> fix is.
> 
> > Signed-off-by: Maxime Ripard <maxime.ripard@free-electrons.com>
> > ---
> > 
> >  drivers/clocksource/sun4i_timer.c | 12 +++++++++---
> >  1 file changed, 9 insertions(+), 3 deletions(-)
> > 
> > diff --git a/drivers/clocksource/sun4i_timer.c
> > b/drivers/clocksource/sun4i_timer.c index 84ace76..695c8c8 100644
> > --- a/drivers/clocksource/sun4i_timer.c
> > +++ b/drivers/clocksource/sun4i_timer.c
> > @@ -16,6 +16,7 @@
> > 
> >  #include <linux/clk.h>
> >  #include <linux/clockchips.h>
> > 
> > +#include <linux/delay.h>
> > 
> >  #include <linux/interrupt.h>
> >  #include <linux/irq.h>
> >  #include <linux/irqreturn.h>
> > 
> > @@ -61,9 +62,14 @@ static void sun4i_clkevt_mode(enum clock_event_mode
> > mode,> 
> >  static int sun4i_clkevt_next_event(unsigned long evt,
> >  
> >  				   struct clock_event_device *unused)
> >  
> >  {
> > 
> > -	u32 u = readl(timer_base + TIMER_CTL_REG(0));
> > -	writel(evt, timer_base + TIMER_CNTVAL_REG(0));
> > -	writel(u | TIMER_CTL_ENABLE | TIMER_CTL_AUTORELOAD,
> > +	u32 val = readl(timer_base + TIMER_CTL_REG(0));
> > +	writel(val & ~TIMER_CTL_ENABLE, timer_base + TIMER_CTL_REG(0));
> > +	udelay(1);
> 
> That udelay() is more than suspicious.

Not only it is suspicious, but also delays the event by 1 microsecond. Not 
much, given usual usage of clock events, but still.

>From what I understand from this code, you keep this timer running and 
just stop it to set new event. Can you simply disable autoreload and just 
program this timer to start counting from evt down to 0 when it generates 
interrupt and just stops itself?

I believe this would simplify the logic a bit, but is it possible with 
this hardware?

Best regards,
Tomasz

