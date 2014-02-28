Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751698AbaB1MB6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Feb 2014 07:01:58 -0500
Received: from merlin.infradead.org ([205.233.59.134]:53911 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751083AbaB1MB4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Feb 2014 07:01:56 -0500
Date: Fri, 28 Feb 2014 13:01:47 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Morten Rasmussen <morten.rasmussen@arm.com>
Cc: "Du, Yuyang" <yuyang.du@intel.com>, Ingo Molnar <mingo@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        "Van De Ven, Arjan" <arjan.van.de.ven@intel.com>,
        "Brown, Len" <len.brown@intel.com>,
        "Wysocki, Rafael J" <rafael.j.wysocki@intel.com>
Subject: Re: [RFC] Splitting scheduler into two halves
Message-ID: <20140228120147.GJ3104@twins.programming.kicks-ass.net>
References: <0DA73B5D686AEC4AAEF6054BE04DA1CD116C50EA@SHSMSX102.ccr.corp.intel.com>
 <20140228102932.GI19029@e103034-lin>
 <20140228114459.GM27965@twins.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140228114459.GM27965@twins.programming.kicks-ass.net>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 28, 2014 at 12:44:59PM +0100, Peter Zijlstra wrote:
> On Fri, Feb 28, 2014 at 10:29:32AM +0000, Morten Rasmussen wrote:
> > If I understand your proposal correctly, you are proposing to have a
> > pluggable scheduler where it is possible to have many different
> > load-balance (bottom half) implementations.
> 
> Yeah, that's not _ever_ going to happen. We've had that discussion many
> times, use your favourite search engine.

*groan*, the version in my inbox to which I replied earlier seems
private; and then I'm not CC'd to the list one.


---
Please use a sane MUA and teach it to wrap at around ~78 chars.

On Fri, Feb 28, 2014 at 02:13:32AM +0000, Du, Yuyang wrote:
> Hi Peter/Ingo and all,
> 
> With the advent of more cores and heterogeneous architectures, the
> scheduler is required to be more complex (power efficiency) and
> diverse (big.little). For the scheduler to address that challenge as a
> whole, it is costly but not necessary. This proposal argues that the
> scheduler be spitted into two parts: top half (task scheduling) and
> bottom half (load balance). Let the bottom half take charge of the
> incoming requirements.

This is already so.

> The two halves are rather orthogonal in functionality. The task
> scheduling (top half) seeks for *ONE* CPU to execute running tasks
> fairly (priority included), while the load balance (bottom half) aims
> for *ALL* CPUs to maximize the throughput of the computing power. The
> goal of task scheduling is pretty unique and clear, and CFS and RT in
> that part are exactly approaching the goal. The load balance, however,
> is constrained to meet more goals, to name a few, performance
> (throughput/responsiveness), power consumption, architecture
> differences, etc. Those things are often hard to achieve because they
> may conflict and are difficult to estimate and plan. So, shall we
> declare the independence of the two, give them freedom to pursue their
> own "happiness".

You cannot treat them completely independent, as fairness must extend
across CPUs. And there's good reasons to integrate them further still;
our current min_vruntime is a poor substitute for the per-cpu zero-lag
point. But with some of the runtime tracking we did for SMP-cgroup we
can approximate the global zero-lag point.

Using a global zero-lag point has advantages in that task latency is
petter preserved in the face of migrations.

So no; you cannot completely separate them. But even if you could;
I don't see the point in doing so.

> We take an incremental development method. As a starting point, we did three things (but did not change one single line of real-work code):
> 	1)	Remove load balance from fair.c into load_balance.c
> 	(~3000 lines of codes). As a result, fair.c/rt.c and
> 	load_balance.c have very little intersection.

You're very much overlooking the fact that RT and DL have their own
SMP logic. So the sched_class interface must very much include the
SMP logic.

The best you can try is creating fair_smp.c, but I'm not seeing how
that's going to be anything but pure code movement. You're not going to
suddenly make it all easier.

> 	2)	Define struct sched_lb_class that consists of the following members to umbrella the load balance entry points.
> 		a.	const struct sched_lb_class *next;
> 		b.	int (*fork_balance) (struct task_struct *p, int sd_flags, int wake_flags);
> 		c.	int (*exec_balance) (struct task_struct *p, int sd_flags, int wake_flags);
> 		d.	int (*wakeup_balance) (struct task_struct *p, int sd_flags, int wake_flags);
> 		e.	void (*idle_balance) (int this_cpu, struct rq *this_rq);
> 		f.	void (*periodic_rebalance) (int cpu, enum cpu_idle_type idle);
> 		g.	void (*nohz_idle_balance) (int this_cpu, enum cpu_idle_type idle);
> 		h.	void (*start_periodic_balance) (struct rq *rq, int cpu);
> 		i.	void (*check_nohz_idle_balance) (struct rq *rq, int cpu);

No point in doing that; as there will only ever be the one consumer.

> 	3)	Insert another layer of indirection to wrap the
> 	implemented functions in sched_lb_class. Implement a default
> 	load balance class that is just the previous load balance.

Every problem in CS can be solved by another layer of abstraction;
except for the problem of too many layers.

> The next to do is to continue redesigning and refactoring to make life
> easier toward more powerful and diverse load balance. And more
> importantly, this RFC solicits a discussion to get early feedback on
> the big proposed change.

I'm not seeing the point. Abstraction and indirection for a single user
are bloody pointless.
