Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755566Ab3F1LOS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Jun 2013 07:14:18 -0400
Received: from mail-la0-f41.google.com ([209.85.215.41]:41140 "EHLO
	mail-la0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755224Ab3F1LOR convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Jun 2013 07:14:17 -0400
Date: Fri, 28 Jun 2013 14:14:12 +0300
From: Siarhei Siamashka <siarhei.siamashka@gmail.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: kevin <kevin@allwinnertech.com>,
        "linux-sunxi@googlegroups.com" <linux-sunxi@googlegroups.com>,
        "maxime.ripard" <maxime.ripard@free-electrons.com>,
        Hans de Goede <hdegoede@redhat.com>,
        John Stultz <john.stultz@linaro.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Emilio Lopez <emilio@elopez.com.ar>,
        =?UTF-8?B?5a2Z5b2m6YKm?= <sunny@allwinnertech.com>,
        =?UTF-8?B?5ZC05Lmm?= =?UTF-8?B?6ICV?= <shuge@allwinnertech.com>
Subject: Re: [linux-sunxi] [PATCH 0/8] clocksource: sunxi: Timer fixes and
 cleanup
Message-ID: <20130628141412.2bf3f68f@i7>
In-Reply-To: <alpine.DEB.2.02.1306281211330.4013@ionos.tec.linutronix.de>
References: <1372281421-2099-1-git-send-email-maxime.ripard@free-electrons.com>
	<51CC0566.8010302@redhat.com>
	<20130627094307.GC8437@lukather>
	<51CC0BC3.5090309@redhat.com>
	<20130627165436.GB4319@lukather>
	<20130627232608.1174558b@i7>
	<2013062809433715678058@allwinnertech.com>
	<20130628124843.242df804@i7>
	<alpine.DEB.2.02.1306281211330.4013@ionos.tec.linutronix.de>
X-Mailer: Claws Mail 3.9.0 (GTK+ 2.24.17; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 28 Jun 2013 12:26:10 +0200 (CEST)
Thomas Gleixner <tglx@linutronix.de> wrote:

> On Fri, 28 Jun 2013, Siarhei Siamashka wrote:
> > On Fri, 28 Jun 2013 09:43:37 +0800
> > 张猛 <kevin@allwinnertech.com> wrote:
> > 
> > > > The A10 manual from http://free-electrons.com/~maxime/pub/datasheet/
> > > > does not seem to contain any details about what bad things may happen
> > > > if we try to read CNT64_LO_REG while latching is still in progress and
> > > > CNT64_RL_EN bit in CNT64_CTRL_REG has not changed to zero yet.
> > > > I can imagine the following possible scenarios:
> > > >  1. We read either the old stale CNT64_LO_REG value or the new
> > > >     correct value.
> > > >  2. We read either the old stale CNT64_LO_REG value or the new
> > > >     correct value, or some random garbage.
> > > >  3. The processor may deadlock, eat your dog, or do some other
> > > >     nasty thing.
> > > >
> > > > In the case of 1, we probably can get away without using any spinlocks?
> > > 
> > > About the 64bits counter, the latch bit is needed because of the
> > > asynchronous circuit. The internal circuit of 64bits counter is
> > > working under 24Mhz clock, and CNT_LO/HI is read with APB clock.
> > > So the clock synchronize is needed. The function of the latch is
> > > synchronous the 64bits counter from 24Mhz clock domain to APB clock
> > > domain. So, if the latch is not completely, value of the CNT_LO/HI
> > > maybe a random value, because some bits are latched, but others are
> > > not. So, the CNT_LO/HI should be read after latch is completely.
> > > The latch just takes 3 cycles of 24Mhz clock, the time is nearly
> > > 0.125 micro-second.
> > 
> > Thanks for the clarification! It is very much appreciated.
> > 
> > So basically we get scenario 2, which still allows some optimizations
> > compared to scenario 3. On single-core systems (Allwinner A10), it
> > probably makes sense to avoid spinlocks overhead and just place
> 
> Spinlocks are NOPs on UP and just disable preemption, but they
> provide you the same ordering guarantees as spinlocks on SMP. So no
> special case optimization necessary.

Still I would not want some high priority and latency sensitive junk
(such as pulseaudio for example) not to get scheduled at the right
time because of some low priority gettimeofday spammer application.
The time spent latching and reading these counters is non negligible.

Though I agree Maxime that first we need an initial implementation,
which just works safely. And then we can optimize it by testing real
use cases and providing the relevant benchmark numbers. Knowing the
precise details about the hardware helps.

But enough bikeshedding, it's time for me to shut up :)

-- 
Best regards,
Siarhei Siamashka
