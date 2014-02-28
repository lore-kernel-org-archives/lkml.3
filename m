Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751698AbaB1K3M (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Feb 2014 05:29:12 -0500
Received: from fw-tnat.austin.arm.com ([217.140.110.23]:57059 "EHLO
	collaborate-mta1.arm.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751067AbaB1K3J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Feb 2014 05:29:09 -0500
Date: Fri, 28 Feb 2014 10:29:32 +0000
From: Morten Rasmussen <morten.rasmussen@arm.com>
To: "Du, Yuyang" <yuyang.du@intel.com>
Cc: Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        "Van De Ven, Arjan" <arjan.van.de.ven@intel.com>,
        "Brown, Len" <len.brown@intel.com>,
        "Wysocki, Rafael J" <rafael.j.wysocki@intel.com>
Subject: Re: [RFC] Splitting scheduler into two halves
Message-ID: <20140228102932.GI19029@e103034-lin>
References: <0DA73B5D686AEC4AAEF6054BE04DA1CD116C50EA@SHSMSX102.ccr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0DA73B5D686AEC4AAEF6054BE04DA1CD116C50EA@SHSMSX102.ccr.corp.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Yuyang,

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
> 
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

Interesting proposal. While we could declare the load-balance function
independent from the rest of CFS, I don't think the can be separated as
cleanly as your proposal suggests.

If I understand your proposal correctly, you are proposing to have a
pluggable scheduler where it is possible to have many different
load-balance (bottom half) implementations. These may require different
statistics and metrics for their load-balancing heuristics that need to
be updated by the task scheduling (top half). Having worked with
big.LITTLE systems for quite a while, I know this is indeed the case if
you want to schedule more efficiently for big.LITTLE.

For heterogeneous systems and energy awareness in general, the current
load tracking isn't very good for low utilization situations. Fixing
that would mean changes in both halves. If go for extreme optimizations
for heterogeneous systems, you may even want the top half to keep track
of light and heavy tasks so you don't have to search through the
runqueues as part of load-balance in the bottom half to try to match
tasks to an appropriate cpu. I'm not saying that the latter is a
requirement, but just an example of things that people may try to do.

If you don't allow stuff to be added to the top half, there isn't much
room to do diverse implementations in the bottom half.

The current sched_class abstraction is already having the issue of not
abstracting everything. Functions in core.c are manipulating data inside
CFS directly.

> We take an incremental development method. As a starting point, we did
> three things (but did not change one single line of real-work code):
> 	1)	Remove load balance from fair.c into load_balance.c
> 	(~3000 lines of codes). As a result, fair.c/rt.c and
> 	load_balance.c have very little intersection.
> 	2)	Define struct sched_lb_class that consists of the
> 	following members to umbrella the load balance entry points.
> 		a.	const struct sched_lb_class *next;
> 		b.	int (*fork_balance) (struct task_struct *p, int sd_flags, int wake_flags);
> 		c.	int (*exec_balance) (struct task_struct *p, int sd_flags, int wake_flags);
> 		d.	int (*wakeup_balance) (struct task_struct *p, int sd_flags, int wake_flags);
> 		e.	void (*idle_balance) (int this_cpu, struct rq *this_rq);
> 		f.	void (*periodic_rebalance) (int cpu, enum cpu_idle_type idle);
> 		g.	void (*nohz_idle_balance) (int this_cpu, enum cpu_idle_type idle);
> 		h.	void (*start_periodic_balance) (struct rq *rq, int cpu);
> 		i.	void (*check_nohz_idle_balance) (struct rq *rq, int cpu);
> 	3)	Insert another layer of indirection to wrap the
> 	implemented functions in sched_lb_class. Implement a default
> 	load balance class that is just the previous load balance.
> 
> The next to do is to continue redesigning and refactoring to make life
> easier toward more powerful and diverse load balance. And more
> importantly, this RFC solicits a discussion to get early feedback on
> the big proposed change.

Is sched_lb_class supposed to implement load-balancing for all
sched_class'es (rt, deadline, and fair) or just fair?

Morten
