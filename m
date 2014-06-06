Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751877AbaFFOMB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jun 2014 10:12:01 -0400
Received: from fw-tnat.austin.arm.com ([217.140.110.23]:15158 "EHLO
	collaborate-mta1.arm.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751320AbaFFOL7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jun 2014 10:11:59 -0400
Date: Fri, 6 Jun 2014 15:11:54 +0100
From: Morten Rasmussen <morten.rasmussen@arm.com>
To: Ingo Molnar <mingo@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>, Yuyang Du <yuyang.du@intel.com>,
        Dirk Brandewie <dirk.brandewie@gmail.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        "vincent.guittot@linaro.org" <vincent.guittot@linaro.org>,
        "daniel.lezcano@linaro.org" <daniel.lezcano@linaro.org>,
        "preeti@linux.vnet.ibm.com" <preeti@linux.vnet.ibm.com>,
        Dietmar Eggemann <Dietmar.Eggemann@arm.com>,
        "len.brown@intel.com" <len.brown@intel.com>,
        "jacob.jun.pan@linux.intel.com" <jacob.jun.pan@linux.intel.com>
Subject: Re: [RFC PATCH 06/16] arm: topology: Define TC2 sched energy and
 provide it to scheduler
Message-ID: <20140606141154.GW29593@e103034-lin>
References: <20140604172712.GJ13930@laptop.programming.kicks-ass.net>
 <2484761.vkWavnsDx3@vostro.rjw.lan>
 <20140605065205.GA3213@twins.programming.kicks-ass.net>
 <539086B3.2010804@gmail.com>
 <20140605202930.GA15484@intel.com>
 <20140606080543.GR6758@twins.programming.kicks-ass.net>
 <20140606003520.GB22261@intel.com>
 <20140606105036.GQ3213@twins.programming.kicks-ass.net>
 <20140606121305.GA8571@gmail.com>
 <20140606122740.GA9318@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20140606122740.GA9318@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 06, 2014 at 01:27:40PM +0100, Ingo Molnar wrote:
> 
> * Ingo Molnar <mingo@kernel.org> wrote:
> 
> > * Peter Zijlstra <peterz@infradead.org> wrote:
> > 
> > > > Voltage is combined with frequency, roughly, voltage is 
> > > > proportional to freuquecy, so roughly, power is proportionaly to 
> > > > voltage^3. You
> > > 
> > > P ~ V^2, last time I checked.
> > 
> > Yes, that's a good approximation for CMOS gates:
> > 
> >   The switching power dissipated by a chip using static CMOS gates is 
> >   C·V^2·f, where C is the capacitance being switched per clock cycle, 
> >   V is the supply voltage, and f is the switching frequency,[1] so 
> >   this part of the power consumption decreases quadratically with 
> >   voltage. The formula is not exact however, as many modern chips are 
> >   not implemented using 100% CMOS, but also use special memory 
> >   circuits, dynamic logic such as domino logic, etc. Moreover, there 
> >   is also a static leakage current, which has become more and more 
> >   accentuated as feature sizes have become smaller (below 90 
> >   nanometres) and threshold levels lower.
> > 
> >   Accordingly, dynamic voltage scaling is widely used as part of 
> >   strategies to manage switching power consumption in battery powered 
> >   devices such as cell phones and laptop computers. Low voltage modes 
> >   are used in conjunction with lowered clock frequencies to minimize 
> >   power consumption associated with components such as CPUs and DSPs; 
> >   only when significant computational power is needed will the voltage 
> >   and frequency be raised.
> > 
> >   Some peripherals also support low voltage operational modes. For 
> >   example, low power MMC and SD cards can run at 1.8 V as well as at 
> >   3.3 V, and driver stacks may conserve power by switching to the 
> >   lower voltage after detecting a card which supports it.
> > 
> >   When leakage current is a significant factor in terms of power 
> >   consumption, chips are often designed so that portions of them can 
> >   be powered completely off. This is not usually viewed as being 
> >   dynamic voltage scaling, because it is not transparent to software. 
> >   When sections of chips can be turned off, as for example on TI OMAP3 
> >   processors, drivers and other support software need to support that.
> > 
> >   http://en.wikipedia.org/wiki/Dynamic_voltage_scaling
> > 
> > Leakage current typically gets higher with higher frequencies, but 
> > it's also highly process dependent AFAIK.

Strictly speaking leakage current gets higher with voltage, not
frequency (well, not to an extend where we should care). However,
frequency increase typically implies a voltage increase, so in that
sense I agree.

> > 
> > If switching power dissipation is the main factor in power use, then 
> > we can essentially assume that P ~ V^2, at the same frequency - and 
> > scales linearly with frequency - but real work performed also scales 
> > semi-linearly with frequency for many workloads, so that's an 
> > invariant for everything except highly memory bound workloads.

AFAIK, there isn't much sense in running a slower frequency than the
highest one supported at a given voltage unless there are specific
reasons not to (peripherals that keeps the system up anyway and such).
In the general case, I think it is safe to assume that energy-efficiency
goes down for every increase in frequency. Modern ARM platforms
typically have different voltages for more or less all frequencies (TC2
is quite atypical). The voltage increases more rapidly than the
frequency which makes the higher frequencies extremely expensive in
terms of energy-efficiency.

All of this is of course without considering power gating which allow us
to eliminate the leakage power (or at least partially eliminate it)
when idle. So, while energy-efficiency is bad at high frequencies, it
might pay off overall to use them anyway if we can save more leakage
energy while idle than we burn extra to race to idle. This is where the
platform energy model becomes useful.

> So in practice this probably means that Turbo probably has a somewhat 
> super-linear power use factor.

I'm not familiar with the voltage scaling on Intel platforms, but as
said above, I think power always scales up faster than performance. It
can probably be ignored for lower frequencies, but for the higher ones,
the extra energy per instruction executed is significant.

> At lower frequencies the leakage current difference is probably 
> negligible.

It is still there, but it is smaller due to the reduced voltage and so
is the dynamic power.

> In any case, even with turbo frequencies, switching power use is 
> probably an order of magnitude higher than leakage current power use, 
> on any marketable chip, 

That strongly depends on the process and the gate library used, but I
agree that dynamic power should be our primary focus.

> so we should concentrate on being able to 
> cover this first order effect (P/work ~ V^2), before considering any 
> second order effects (leakage current).

I think we should be fine as long as we include the leakage power in the
'busy' power consumption and know the idle-state power consumption in
the idle-states. I already do this in the TC2 model. That way we don't
have to distinguish between leakage and dynamic power.

Morten
