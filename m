Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754063Ab3F0TvJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Jun 2013 15:51:09 -0400
Received: from mail-la0-f43.google.com ([209.85.215.43]:60653 "EHLO
	mail-la0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753475Ab3F0TvI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Jun 2013 15:51:08 -0400
Date: Thu, 27 Jun 2013 22:51:01 +0300
From: Siarhei Siamashka <siarhei.siamashka@gmail.com>
To: Maxime Ripard <maxime.ripard@free-electrons.com>
Cc: linux-sunxi@googlegroups.com, John Stultz <john.stultz@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Emilio Lopez <emilio@elopez.com.ar>, kevin@allwinnertech.com,
        sunny@allwinnertech.com, shuge@allwinnertech.com
Subject: Re: [linux-sunxi] [PATCH 2/8] clocksource: sun4i: Add clocksource
 and sched clock drivers
Message-ID: <20130627225101.358208c1@i7>
In-Reply-To: <20130627170228.GC4319@lukather>
References: <1372281421-2099-1-git-send-email-maxime.ripard@free-electrons.com>
	<1372281421-2099-3-git-send-email-maxime.ripard@free-electrons.com>
	<20130627131729.5fff8468@i7>
	<20130627170228.GC4319@lukather>
X-Mailer: Claws Mail 3.9.0 (GTK+ 2.24.17; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 27 Jun 2013 19:02:28 +0200
Maxime Ripard <maxime.ripard@free-electrons.com> wrote:

> Hi Siarhei,
> 
> On Thu, Jun 27, 2013 at 01:17:29PM +0300, Siarhei Siamashka wrote:
> > On Wed, 26 Jun 2013 23:16:55 +0200
> > Maxime Ripard <maxime.ripard@free-electrons.com> wrote:
> > 
> > > The A10 and the A13 has a 64 bits free running counter that we can use
> > > as a clocksource and a sched clock, that were both not used yet on these
> > > platforms.
> > > 
> > > Signed-off-by: Maxime Ripard <maxime.ripard@free-electrons.com>
> > > ---
> > >  drivers/clocksource/sun4i_timer.c | 27 +++++++++++++++++++++++++++
> > >  1 file changed, 27 insertions(+)
> > > 
> > > diff --git a/drivers/clocksource/sun4i_timer.c b/drivers/clocksource/sun4i_timer.c
> > > index bdf34d9..1d2eaa0 100644
> > > --- a/drivers/clocksource/sun4i_timer.c
> > > +++ b/drivers/clocksource/sun4i_timer.c
> > > @@ -23,6 +23,8 @@
> > >  #include <linux/of_address.h>
> > >  #include <linux/of_irq.h>
> > >  
> > > +#include <asm/sched_clock.h>
> > > +
> > >  #define TIMER_IRQ_EN_REG	0x00
> > >  #define TIMER_IRQ_EN(val)		BIT(val)
> > >  #define TIMER_IRQ_ST_REG	0x04
> > > @@ -34,6 +36,11 @@
> > >  #define TIMER_CNTVAL_REG(val)	(0x10 * val + 0x18)
> > >  
> > >  #define TIMER_SCAL		16
> > > +#define TIMER_CNT64_CTL_REG	0xa0
> > > +#define TIMER_CNT64_CTL_CLR		BIT(0)
> > > +#define TIMER_CNT64_CTL_RL		BIT(1)
> > > +#define TIMER_CNT64_LOW_REG	0xa4
> > > +#define TIMER_CNT64_HIGH_REG	0xa8
> > >  
> > >  static void __iomem *timer_base;
> > >  
> > > @@ -96,6 +103,20 @@ static struct irqaction sun4i_timer_irq = {
> > >  	.dev_id = &sun4i_clockevent,
> > >  };
> > >  
> > > +static u32 sun4i_timer_sched_read(void)
> > > +{
> > > +	u32 reg = readl(timer_base + TIMER_CNT64_CTL_REG);
> > 
> > If we can be absolutely sure that nothing else may ever change
> > the TIMER_CNT64_CTL_REG, then its default value can be probably
> > cached instead of doing expensive read from the hardware register
> > each time?
> 
> Since it's a free-running counter, its value will always change, so the
> caching will bring no additions at all, right?

Sorry, 'caching' was not a very good description for something that is
already a compile time constant. I mean just replace

    u32 reg = readl(timer_base + TIMER_CNT64_CTL_REG);

with 

    u32 reg = TIMER_CNT64_CTL_CLR;

Because we know that the TIMER_CNT64_CTL_REG is already supposed
to have the default TIMER_CNT64_CTL_CLR value (initialized in the
'sun4i_timer_init' function) between calls to 'sun4i_timer_sched_read'.
Inside of 'sun4i_timer_sched_read' we set an extra TIMER_CNT64_CTL_RL
bit in this register, but wait until it clears, effectively reverting
TIMER_CNT64_CTL_REG register back to the default TIMER_CNT64_CTL_CLR
value.

Removing this extra HW register read can save roughly a hundred of CPU
cycles here and provide a ~10% overall improvement for gettimeofday
(these estimates are based on the earlier benchmarks done with the
Allwinner 3.4 kernel).

Or maybe I'm overlooking something?

-- 
Best regards,
Siarhei Siamashka
