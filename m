Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753496AbaFDNtv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jun 2014 09:49:51 -0400
Received: from fw-tnat.austin.arm.com ([217.140.110.23]:11675 "EHLO
	collaborate-mta1.arm.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752598AbaFDNtt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jun 2014 09:49:49 -0400
Date: Wed, 4 Jun 2014 14:49:50 +0100
From: Morten Rasmussen <morten.rasmussen@arm.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        "mingo@kernel.org" <mingo@kernel.org>,
        "rjw@rjwysocki.net" <rjw@rjwysocki.net>,
        "vincent.guittot@linaro.org" <vincent.guittot@linaro.org>,
        "daniel.lezcano@linaro.org" <daniel.lezcano@linaro.org>,
        "preeti@linux.vnet.ibm.com" <preeti@linux.vnet.ibm.com>,
        Dietmar Eggemann <Dietmar.Eggemann@arm.com>
Subject: Re: [RFC PATCH 06/16] arm: topology: Define TC2 sched energy and
 provide it to scheduler
Message-ID: <20140604134950.GQ29593@e103034-lin>
References: <1400869003-27769-1-git-send-email-morten.rasmussen@arm.com>
 <1400869003-27769-7-git-send-email-morten.rasmussen@arm.com>
 <20140530120424.GD30445@twins.programming.kicks-ass.net>
 <20140602141536.GL19967@e103034-lin>
 <20140603114145.GX11096@twins.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140603114145.GX11096@twins.programming.kicks-ass.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 03, 2014 at 12:41:45PM +0100, Peter Zijlstra wrote:
> On Mon, Jun 02, 2014 at 03:15:36PM +0100, Morten Rasmussen wrote:
> > > 
> > > Talk to me about this core vs cluster thing.
> > > 
> > > Why would an architecture have multiple energy domains like this?
> 
> > The reason is that power domains are often organized in a hierarchy
> > where you may be able to power down just a cpu or the entire cluster
> > along with cluster wide shared resources. This is quite typical for ARM
> > systems. Frequency domains (P-states) typically cover the same hardware
> > as one of the power domain levels. That is, there might be several
> > smaller power domains sharing the same frequency (P-state) or there
> > might be a power domain spanning multiple frequency domains.
> > 
> > The main reason why we need to worry about all this is that it typically
> > cost a lot more energy to use the first cpu in a cluster since you
> > also need to power up all the shared hardware resources than the energy
> > cost of waking and using additional cpus in the same cluster.
> > 
> > IMHO, the most natural way to model the energy is therefore something
> > like:
> > 
> >     energy = energy_cluster + n * energy_cpu
> > 
> > Where 'n' is the number of cpus powered up and energy_cluster is the
> > cost paid as soon as any cpu in the cluster is powered up.
> 
> OK, that makes sense, thanks! Maybe expand the doc/changelogs with this
> because it wasn't immediately clear to me.

I will add more documention to the next round, it is indeed needed.

> 
> > > Also, in general, why would we need to walk the domain tree all the way
> > > up, typically I would expect to stop walking once we've covered the two
> > > cpu's we're interested in, because above that nothing changes.
> > 
> > True. In some cases we don't have to go all the way up. There is a
> > condition in energy_diff_load() that bails out if the energy doesn't
> > change further up the hierarchy. There might be scope for improving that
> > condition though.
> > 
> > We can basically stop going up if the utilization of the domain is
> > unchanged by the change we want to do. For example, we can ignore the
> > next level above if a third cpu is keeping the domain up all the time
> > anyway. In the 100% + 50% case above, putting another 50% task on the
> > 50% cpu wouldn't affect the cluster according the proposed model, so it
> > can be ignored. However, if we did the same on any of the two cpus in
> > the 50% + 25% example we affect the cluster utilization and have to do
> > the cluster level maths.
> > 
> > So we do sometimes have to go all the way up even if we are balancing
> > two sibling cpus to determine the energy implications. At least if we
> > want an energy score like energy_diff_load() produces. However, we might
> > be able to take some other shortcuts if we are balancing load between
> > two specific cpus (not wakeup/fork/exec balancing) as you point out. But
> > there are cases where we need to continue up until the domain
> > utilization is unchanged.
> 
> Right.. so my worry with this is scalability. We typically want to avoid
> having to scan the entire machine, even for power aware balancing.

I haven't looked at power management for really big machines, but I hope
that we can stop a socket level or wherever utilization changes won't
affect the energy of the rest of the system. If we can power off groups
of sockets or something like that, we could scan at that level less
frequently (like we do now). The cost and latency of powering off
multiple sockets is probably high and not something we want to do often.

> That said, I don't think we have a 'sane' model for really big hardware
> (yet). Intel still hasn't really said anything much on that iirc, as
> long as a single core is up, all the memory controllers in the numa
> fabric need to be awake, not to mention to cost of keeping the dram
> alive.

Right. I'm hoping that we can roll that in once we know more about power
management on big hardware.
