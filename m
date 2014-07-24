Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759439AbaGXR5Z (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jul 2014 13:57:25 -0400
Received: from fw-tnat.austin.arm.com ([217.140.110.23]:51332 "EHLO
	collaborate-mta1.arm.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752185AbaGXR5X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jul 2014 13:57:23 -0400
Date: Thu, 24 Jul 2014 18:57:10 +0100
From: Morten Rasmussen <morten.rasmussen@arm.com>
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>
Cc: Peter Zijlstra <peterz@infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        "mingo@kernel.org" <mingo@kernel.org>,
        "vincent.guittot@linaro.org" <vincent.guittot@linaro.org>,
        "daniel.lezcano@linaro.org" <daniel.lezcano@linaro.org>,
        "preeti@linux.vnet.ibm.com" <preeti@linux.vnet.ibm.com>,
        Dietmar Eggemann <Dietmar.Eggemann@arm.com>,
        "pjt@google.com" <pjt@google.com>
Subject: Re: [RFCv2 PATCH 01/23] sched: Documentation for scheduler energy
 cost model
Message-ID: <20140724175709.GA11501@e103034-lin>
References: <1404404770-323-1-git-send-email-morten.rasmussen@arm.com>
 <3288345.jvzVvqTJvD@vostro.rjw.lan>
 <20140724072609.GI3935@laptop>
 <14224056.9QdYi5f1q1@vostro.rjw.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <14224056.9QdYi5f1q1@vostro.rjw.lan>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 24, 2014 at 03:28:27PM +0100, Rafael J. Wysocki wrote:
> On Thursday, July 24, 2014 09:26:09 AM Peter Zijlstra wrote:
> > On Thu, Jul 24, 2014 at 02:53:20AM +0200, Rafael J. Wysocki wrote:
> > > I am used to slightly different terminology here.  Namely, there are voltage
> > > domains (parts sharing a voltage rail or a voltage regulator, such that you
> > > can only apply/remove/change voltage to all of them at the same time) and clock
> > > domains (analogously, but for clocks).  A power domain (which in your description
> > > above seems to correspond to a voltage domain) may be a voltage domain, a clock
> > > domain or a combination thereof.

Your terminology is closer how the hardware actually operates, agreed. I
was hoping to keep things a bit simpler if we can get away with it. In
the simplified view a frequency domain is the combination of voltage and
clock domain (using your terminology). Since clock and voltage usually
scale together (DVFS) the assumption is that those domains are
equivalent. Thus, the frequency domain defines the subset of cpus that
scale P-state together.

A power domain (in my terminology) defines a subset of cpus that share
C-states (do-nothing-states at reduced power consumption). The actual
technique applied for the C-state implementation is not considered. It
may anything between just clock gating up to and including completely
powering the domain off. So it isn't necessarily equivalent to the clock
or voltage domain. For example on ARM is quite typical to have clock
gating per cpu and sometimes also per core power gating, while the
clock/voltage domain covers multiple cpus. It is worth noting that power
gating if often hierarchical meaning that you can power gate larger
subsets of cpus in one go as well to save more power as you can power
down (some) shared resources as well. I think that is equivalent to
package C-states in Intel terminology.

> > > In addition to that, in a voltage domain it may be possible to apply many
> > > different levels of voltage, which case doesn't seem to be covered at all by
> > > the above (or I'm missing something).

I don't include it explicitly, but it is factored into the capacity
state data (which is really frequency states on SMP, but that is another
story). Each capacity state is represented by a compute capacity
(proportional to frequency on SMP) and the associated power consumption.
The energy-efficiency (work/energy) for the capacity state is basically
the ratio of the two. Hence the voltage is include in the power figure
associated with the P-state. It is assumed that you don't scale voltage
without scaling frequency. I hope that is a valid assumption for Intel
systems as well?

> > > Also a P-state is not just a frequency level, but a combination of frequency
> > > and voltage that has to be applied for that frequency to be stable.  You may
> > > regard them as Operation Performance Points of the CPU, but that very well may
> > > go beyond frequencies and voltages.  Thus it actually is better not to talk
> > > about P-states as "frequencies".

Agreed. In my world voltage and frequency are always linked, so I might
have been a bit sloppy in my definitions. I will fix that to use P-state
instead.

Capacity states are equal to P-states on SMP but not for big.LITTLE as
we also have to factor in performance differences between different
micro-architectures. Any objections to that? It is in line with the
recent renaming of cpu_power to cpu_capacity in fair.c.

> > > Now, P-states may or may not have to be coordinated between all CPUs in a
> > > package (cluster), by hardware or software, such that all CPUs in a cluster
> > > need to be kept in the same P-state.  That you can regard as a "P-state
> > > domain", but it usually means a specific combination of voltage and frequency.
> > 
> > I think Morton is aware of this, but for the sake of sanity dropped the
> > whole lot into something simpler (while hoping reality would not ruin
> > his life).

Spot on :-) (except for the spelling of my name ;-))

> > 
> > > C-states in turn are states in which CPUs don't execute instructions.
> > > That need not mean the removal of voltage or even frequency from them.
> > > Of course, they do mean some sort of power draw reduction, but that may
> > > be achieved in many different ways.  Some C-states require coordination
> > > too (for example, a single C-state may apply to a whole package or cluster
> > > at the same time) and you can think about "domains" here too, but there
> > > need not be a direct mapping to physical parameters such as the frequency
> > > or the voltage.

That is "power domains" in my simplified terminology as described above.

> > One thing that wasn't clear to me is if you allow for C-domain and
> > P-domain to overlap or if they're always inclusive (where one is wholly
> > contained in the other).
> 
> On the CPUs I worked with so far they were always inclusive.  Previously, the
> whole package was a P-state domain.  Today some CPUs (Haswell server chips
> for example) have per-core P-states.

I don't know of any design where they overlap. My assumption is that it
won't happen ;-)

> > > Moreover, P-states and C-states may overlap.  That is, a CPU may be in Px
> > > and Cy at the same time, which means that after leaving Cy it will execute
> > > instructions in Px.  Things like leakage may depend on x in that case and
> > > the total power draw may depend on the combination of x and y.

Right, I have ignored that aspect so far (along with a lot of other
things) hoping that it wouldn't make too much difference. I haven't
investigated it in detail yet. I guess that main difference would be in
the shallowest C-states as you would be power gating in the deeper ones?

It could be factored in but it would mean providing platform data.

> > Right, and I suppose the domain thing makes it impossible to drop to the
> > lowest P state on going idle. Tricky that.
> 
> That's the case for older chips.  I'm not sure about the newest lot entirely
> to be honest, need to ask.

I think some ARM do the lowest P-state trick before entering idle. But
yeah, it only makes sense if you are the last cpu in the P-state domain
to go down.

> > > The concern is that if a scaling governor is running in parallel with the above
> > > algorithm and it has its own utilization goal (it usually does), it may change
> > > the P-state under you to match that utilization goal and you'll end up with
> > > something different from what you expected.
> > > 
> > > That may be addressed either by trying to predict what the scaling governor will
> > > do (and good luck with that) or by taking care of P-states by yourself.  The
> > > latter would require changes to the algorithm I think, though.
> > 
> > The idea was that we'll do P states ourselves based on these utilization
> > figures. If we find we cannot fit the 'new' task into the current set
> > without either raising P or waking an idle cpu (if at all available), we
> > compute the cost of either option and pick the cheapest.
> 
> Yeah.  One subtle thing is that ramping up P may affect the other guys
> (if the whole chip is a P-domain, for example), but I guess that can be
> taken into account.

For now I have assumed that the P-state governor will provide select a
P-state which is sufficient for handling the utilization. But, as Peter
already said, the plan is to try at least guide the P-state selection
based on the decisions made by the scheduler.

Affected cpus are actually already take into account when trying to
figure out whether to raise the P-state or waking an idle cpu.

Morten
