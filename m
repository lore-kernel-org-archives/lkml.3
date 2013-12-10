Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753785Ab3LJOXQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Dec 2013 09:23:16 -0500
Received: from am1ehsobe001.messaging.microsoft.com ([213.199.154.204]:4818
	"EHLO am1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753339Ab3LJOXO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Dec 2013 09:23:14 -0500
X-Forefront-Antispam-Report: CIP:66.35.236.232;KIP:(null);UIP:(null);IPV:NLI;H:SJ-ITEXEDGE02.altera.priv.altera.com;RD:none;EFVD:NLI
X-SpamScore: 5
X-BigFish: VS5(z551biz98dI936eI1432I4015Izz1f42h2148h208ch1ee6h1de0h1fdah2073h2146h1202h1e76h2189h1d1ah1d2ah1fc6hzz1de098h8275dh1de097hz2fh2a8h839h93fhd24hd2bhf0ah1288h12a5h12a9h12bdh137ah139eh13b6h1441h1504h1537h162dh1631h1758h1898h18e1h1946h19b5h1ad9h1b0ah224fh1d0ch1d2eh1d3fh1dfeh1dffh1e1dh1e23h1fe8h1ff5h2218h2216h226dh22d0h2327h2336h286p1155h)
Message-ID: <1386685286.6211.1.camel@linux-builds1>
Subject: Re: [GIT PULL RESEND] clocksource/clockevents fixes for 3.13
From: Dinh Nguyen <dinguyen@altera.com>
To: Ingo Molnar <mingo@kernel.org>
CC: Daniel Lezcano <daniel.lezcano@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>, Axel Lin <axel.lin@ingics.com>,
        Ezequiel Garcia <ezequiel.garcia@free-electrons.com>,
        Marc Zyngier <marc.zyngier@arm.com>,
        Thierry Reding <thierry.reding@gmail.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Tue, 10 Dec 2013 08:21:26 -0600
In-Reply-To: <20131210134133.GC31366@gmail.com>
References: <52A716E0.4080103@linaro.org> <20131210134133.GC31366@gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
X-OriginatorOrg: altera.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2013-12-10 at 14:41 +0100, Ingo Molnar wrote:
> * Daniel Lezcano <daniel.lezcano@linaro.org> wrote:
> 
> > 
> > Hi Thomas, Ingo,
> > 
> > here are the fixes for 3.13 based on timers/urgent
> > 
> >  * Axel Lin added a missing dependency on CLKSRC_MMIO in the Kconfig
> > for the time-efm32.
> > 
> >  * Dinh Nguyen fixed read_sched_clock to return the right value for
> > the dw_apb_timer.
> > 
> >  * Ezequiel Garcia registered the sched clock after the counter,
> > thus preventing time jump in the traces for the armada-370-xp.
> > 
> >  * Marc Zyngier stopped the timer before enabling the irq in order
> > to prevent it to be fired before the clockevent is registered for
> > the sunxi.
> > 
> >  * Thierry Reding removed a of_node_put in clksrc-of because the
> > reference is not held.
> 
> (For future reference, please post all patches not just a combo 
> patch.)
> 
> > Dinh Nguyen (2):
> >       clocksource: dw_apb_timer: Move timer defines to header file.
> >       clocksource: dw_apb_timer_of: Fix read_sched_clock
> 
> Nit: we generally don't use periods at the end of titles, it looks 
> inconsistent in shortlogs.
> 
> > diff --git a/drivers/clocksource/dw_apb_timer.c
> > b/drivers/clocksource/dw_apb_timer.c
> > index e54ca10..c3a8f52 100644
> > --- a/drivers/clocksource/dw_apb_timer.c
> > +++ b/drivers/clocksource/dw_apb_timer.c
> > @@ -18,25 +18,6 @@
> >  #include <linux/io.h>
> >  #include <linux/slab.h>
> > 
> > -#define APBT_MIN_PERIOD			4
> > -#define APBT_MIN_DELTA_USEC		200
> > -
> > -#define APBTMR_N_LOAD_COUNT		0x00
> > -#define APBTMR_N_CURRENT_VALUE		0x04
> > -#define APBTMR_N_CONTROL		0x08
> > -#define APBTMR_N_EOI			0x0c
> > -#define APBTMR_N_INT_STATUS		0x10
> > -
> > -#define APBTMRS_INT_STATUS		0xa0
> > -#define APBTMRS_EOI			0xa4
> > -#define APBTMRS_RAW_INT_STATUS		0xa8
> > -#define APBTMRS_COMP_VERSION		0xac
> > -
> > -#define APBTMR_CONTROL_ENABLE		(1 << 0)
> > -/* 1: periodic, 0:free running. */
> > -#define APBTMR_CONTROL_MODE_PERIODIC	(1 << 1)
> > -#define APBTMR_CONTROL_INT		(1 << 2)
> > -
> >  static inline struct dw_apb_clock_event_device *
> >  ced_to_dw_apb_ced(struct clock_event_device *evt)
> >  {
> > diff --git a/drivers/clocksource/dw_apb_timer_of.c
> > b/drivers/clocksource/dw_apb_timer_of.c
> > index 45ba8ae..c3fe17e 100644
> > --- a/drivers/clocksource/dw_apb_timer_of.c
> > +++ b/drivers/clocksource/dw_apb_timer_of.c
> > @@ -102,18 +102,17 @@ static void __init add_clocksource(struct
> > device_node *source_timer)
> >  	 * timer is found. sched_io_base then points to the current_value
> >  	 * register of the clocksource timer.
> >  	 */
> > -	sched_io_base = iobase + 0x04;
> > +	sched_io_base = iobase;
> >  	sched_rate = rate;
> >  }
> > 
> >  static u64 read_sched_clock(void)
> >  {
> > -	return __raw_readl(sched_io_base);
> > +	return ~__raw_readl(sched_io_base + APBTMR_N_CURRENT_VALUE);
> 
> AFAICS the minimal fix here for v3.13 would be to just do:
> 
> > -	return __raw_readl(sched_io_base);
> > +	return ~__raw_readl(sched_io_base);
> 
> Right? That way the fix is just a oneliner and we could delay the 
> header file and magic-constants use cleanups to v3.14.

Yes. That will be fine. Do you need me to send a new patch that does
just that?

Thanks,
Dinh
> 
> Thanks,
> 
> 	Ingo
> 



