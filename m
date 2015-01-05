Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754568AbbAETlk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jan 2015 14:41:40 -0500
Received: from mho-03-ewr.mailhop.org ([204.13.248.66]:65361 "EHLO
	mho-01-ewr.mailhop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754494AbbAETli (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jan 2015 14:41:38 -0500
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 104.193.169.186
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX1+cJnI0hb8IUhqEEsLaxB/r
Date: Mon, 5 Jan 2015 11:37:45 -0800
From: Tony Lindgren <tony@atomide.com>
To: Nishanth Menon <nm@ti.com>
Cc: Lokesh Vutla <lokeshvutla@ti.com>,
        Lennart Sorensen <lsorense@csclub.uwaterloo.ca>,
        linux-omap@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, "Kristo, Tero" <t-kristo@ti.com>,
        Sekhar Nori <nsekhar@ti.com>
Subject: Re: [PATCH V2 2/2] ARM: dra7xx: Fix counter frequency drift for
 AM572x errata i856.
Message-ID: <20150105193745.GJ4081@atomide.com>
References: <cover.1418762900.git.lsorense@csclub.uwaterloo.ca>
 <89b793993eaa492af531bd7aa9dff1f871fb4a77.1418762900.git.lsorense@csclub.uwaterloo.ca>
 <54914096.9060206@ti.com>
 <20141217153026.GB838@kahuna>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141217153026.GB838@kahuna>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Nishanth Menon <nm@ti.com> [141217 07:33]:
> On 14:06-20141217, Lokesh Vutla wrote:
> > Hi Len,
> > On Wednesday 17 December 2014 02:38 AM, Lennart Sorensen wrote:
> > > Errata i856 for the AM572x (DRA7xx) points out that the 32.768KHz external
> > > crystal is not enabled at power up.  Instead the CPU falls back to using
> > > an emulation for the 32KHz clock which is SYSCLK1/610.  SYSCLK1 is usually
> > > 20MHz on boards so far (which gives an emulated frequency of 32.786KHz),
> > > but can also be 19.2 or 27MHz which result in much larger drift.
> > > 
> > > Since this is used to drive the master counter at 32.768KHz * 375 /
> > > 2 = 6.144MHz, the emulated speed for 20MHz is of by 570ppm, or about 43
> > > seconds per day, and more than the 500ppm NTP is able to tolerate.
> > > 
> > > Checking the CTRL_CORE_BOOTSTRAP register can determine if the CPU
> > > is using the real 32.768KHz crystal or the emulated SYSCLK1/610, and
> > > by known that the real counter frequency can be determined and used.
> > > The real speed is then SYSCLK1 / 610 * 375 / 2 or SYSCLK1 * 75 / 244.
> > Looks good to me.
> > Tested this on DRA7 evm.
> > 
> > Tested-by: Lokesh Vutla <lokeshvutla@ti.com>
> > 
> > Thanks and regards,
> > Lokesh
> > 
> > > 
> > > Signed-off-by: Len Sorensen <lsorense@csclub.uwaterloo.ca>
> > > ---
> > >  arch/arm/mach-omap2/control.h |    4 ++++
> > >  arch/arm/mach-omap2/timer.c   |   36 ++++++++++++++++++++++++++++++++++--
> > >  2 files changed, 38 insertions(+), 2 deletions(-)
> > > 
> > > diff --git a/arch/arm/mach-omap2/control.h b/arch/arm/mach-omap2/control.h
> > > index a3c0133..a80ac2d 100644
> > > --- a/arch/arm/mach-omap2/control.h
> > > +++ b/arch/arm/mach-omap2/control.h
> > > @@ -286,6 +286,10 @@
> > >  #define OMAP5XXX_CONTROL_STATUS                0x134
> > >  #define OMAP5_DEVICETYPE_MASK          (0x7 << 6)
> > >  
> > > +/* DRA7XX CONTROL CORE BOOTSTRAP */
> > > +#define DRA7_CTRL_CORE_BOOTSTRAP	0x6c4
> > > +#define DRA7_SPEEDSELECT_MASK		(0x3 << 8)
> > > +
> > >  /*
> > >   * REVISIT: This list of registers is not comprehensive - there are more
> > >   * that should be added.
> > > diff --git a/arch/arm/mach-omap2/timer.c b/arch/arm/mach-omap2/timer.c
> > > index fb0cb2b..7d45c84 100644
> > > --- a/arch/arm/mach-omap2/timer.c
> > > +++ b/arch/arm/mach-omap2/timer.c
> > > @@ -54,6 +54,7 @@
> > >  
> > >  #include "soc.h"
> > >  #include "common.h"
> > > +#include "control.h"
> > >  #include "powerdomain.h"
> > >  #include "omap-secure.h"
> > >  
> > > @@ -496,7 +497,8 @@ static void __init realtime_counter_init(void)
> > >  	void __iomem *base;
> > >  	static struct clk *sys_clk;
> > >  	unsigned long rate;
> > > -	unsigned int reg, num, den;
> > > +	unsigned int reg;
> > > +	unsigned long long num, den;
> > >  
> > >  	base = ioremap(REALTIME_COUNTER_BASE, SZ_32);
> > >  	if (!base) {
> > > @@ -511,6 +513,35 @@ static void __init realtime_counter_init(void)
> > >  	}
> > >  
> > >  	rate = clk_get_rate(sys_clk);
> > > +
> > > +	if (soc_is_dra7xx()) {
> > > +		/*
> > > +		 * Errata i856 says the 32.768KHz crystal does not start at
> > > +		 * power on, so the CPU falls back to an emulated 32KHz clock
> > > +		 * based on sysclk / 610 instead. This causes the master counter
> > > +		 * frequency to not be 6.144MHz but at sysclk / 610 * 375 / 2
> > > +		 * (OR sysclk * 75 / 244)
> > > +		 *
> > > +		 * This affects at least the DRA7/AM572x 1.0, 1.1 revisions.
> > > +		 * Of course any board built without a populated 32.768KHz
> > > +		 * crystal would also need this fix even if the CPU is fixed
> > > +		 * later.
> > > +		 *
> > > +		 * Either case can be detected by using the two speedselect bits
> > > +		 * If they are not 0, then the 32.768KHz clock driving the
> > > +		 * coarse counter that corrects the fine counter every time it
> > > +		 * ticks is actually rate/610 rather than 32.768KHz and we
> > > +		 * should compensate to avoid the 570ppm (at 20MHz, much worse
> > > +		 * at other rates) too fast system time.
> > > +		 */
> > > +		reg = omap_ctrl_readl(DRA7_CTRL_CORE_BOOTSTRAP);
> > > +		if (reg & DRA7_SPEEDSELECT_MASK) {
> > > +			num = 75;
> > > +			den = 244;
> > > +			goto sysclk1_based;
> > > +		}
> > > +	}
> > > +
> > >  	/* Numerator/denumerator values refer TRM Realtime Counter section */
> > >  	switch (rate) {
> > >  	case 12000000:
> > > @@ -545,6 +576,7 @@ static void __init realtime_counter_init(void)
> > >  		break;
> > >  	}
> > >  
> > > +sysclk1_based:
> > >  	/* Program numerator and denumerator registers */
> > >  	reg = readl_relaxed(base + INCREMENTER_NUMERATOR_OFFSET) &
> > >  			NUMERATOR_DENUMERATOR_MASK;
> > > @@ -556,7 +588,7 @@ static void __init realtime_counter_init(void)
> > >  	reg |= den;
> > >  	writel_relaxed(reg, base + INCREMENTER_DENUMERATOR_RELOAD_OFFSET);
> > >  
> > > -	arch_timer_freq = (rate / den) * num;
> > > +	arch_timer_freq = DIV_ROUND_UP_ULL(rate * num, den);
> > >  	set_cntfreq();
> > >  
> > >  	iounmap(base);
> > > 
> > 
> If tony is ok with the arch_timer_freq change in this patch, I am ok
> with it as well.

Looks good to me thanks. Applying both into omap-for-v3.19/fixes with
the first cc stable v3.7+ and the second cc stable v3.14+.

Regards,

Tony
