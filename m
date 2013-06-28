Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755563Ab3F1K0S (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Jun 2013 06:26:18 -0400
Received: from www.linutronix.de ([62.245.132.108]:45385 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754975Ab3F1K0R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Jun 2013 06:26:17 -0400
Date: Fri, 28 Jun 2013 12:26:10 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Siarhei Siamashka <siarhei.siamashka@gmail.com>
cc: kevin <kevin@allwinnertech.com>,
        "linux-sunxi@googlegroups.com" <linux-sunxi@googlegroups.com>,
        "maxime.ripard" <maxime.ripard@free-electrons.com>,
        Hans de Goede <hdegoede@redhat.com>,
        John Stultz <john.stultz@linaro.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Emilio Lopez <emilio@elopez.com.ar>,
        =?GB2312?B?y+/R5bDu?= <sunny@allwinnertech.com>,
        =?GB2312?B?zuLK6bj7?= <shuge@allwinnertech.com>
Subject: Re: [linux-sunxi] [PATCH 0/8] clocksource: sunxi: Timer fixes and
 cleanup
In-Reply-To: <20130628124843.242df804@i7>
Message-ID: <alpine.DEB.2.02.1306281211330.4013@ionos.tec.linutronix.de>
References: <1372281421-2099-1-git-send-email-maxime.ripard@free-electrons.com> <51CC0566.8010302@redhat.com> <20130627094307.GC8437@lukather> <51CC0BC3.5090309@redhat.com> <20130627165436.GB4319@lukather> <20130627232608.1174558b@i7> <2013062809433715678058@allwinnertech.com>
 <20130628124843.242df804@i7>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="8323329-596350683-1372415171=:4013"
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--8323329-596350683-1372415171=:4013
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: 8BIT

On Fri, 28 Jun 2013, Siarhei Siamashka wrote:
> On Fri, 28 Jun 2013 09:43:37 +0800
> 张猛 <kevin@allwinnertech.com> wrote:
> 
> > > The A10 manual from http://free-electrons.com/~maxime/pub/datasheet/
> > > does not seem to contain any details about what bad things may happen
> > > if we try to read CNT64_LO_REG while latching is still in progress and
> > > CNT64_RL_EN bit in CNT64_CTRL_REG has not changed to zero yet.
> > > I can imagine the following possible scenarios:
> > >  1. We read either the old stale CNT64_LO_REG value or the new
> > >     correct value.
> > >  2. We read either the old stale CNT64_LO_REG value or the new
> > >     correct value, or some random garbage.
> > >  3. The processor may deadlock, eat your dog, or do some other
> > >     nasty thing.
> > >
> > > In the case of 1, we probably can get away without using any spinlocks?
> > 
> > About the 64bits counter, the latch bit is needed because of the
> > asynchronous circuit. The internal circuit of 64bits counter is
> > working under 24Mhz clock, and CNT_LO/HI is read with APB clock.
> > So the clock synchronize is needed. The function of the latch is
> > synchronous the 64bits counter from 24Mhz clock domain to APB clock
> > domain. So, if the latch is not completely, value of the CNT_LO/HI
> > maybe a random value, because some bits are latched, but others are
> > not. So, the CNT_LO/HI should be read after latch is completely.
> > The latch just takes 3 cycles of 24Mhz clock, the time is nearly
> > 0.125 micro-second.
> 
> Thanks for the clarification! It is very much appreciated.
> 
> So basically we get scenario 2, which still allows some optimizations
> compared to scenario 3. On single-core systems (Allwinner A10), it
> probably makes sense to avoid spinlocks overhead and just place

Spinlocks are NOPs on UP and just disable preemption, but they
provide you the same ordering guarantees as spinlocks on SMP. So no
special case optimization necessary.

Thanks,

	tglx
	
--8323329-596350683-1372415171=:4013--
