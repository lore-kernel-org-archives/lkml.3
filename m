Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753599AbaATLrB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jan 2014 06:47:01 -0500
Received: from merlin.infradead.org ([205.233.59.134]:54459 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750738AbaATLq6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jan 2014 06:46:58 -0500
Date: Mon, 20 Jan 2014 12:46:06 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Henrik Austad <henrik@austad.us>
Cc: Juri Lelli <juri.lelli@gmail.com>, tglx@linutronix.de, mingo@redhat.com,
        rostedt@goodmis.org, oleg@redhat.com, fweisbec@gmail.com,
        darren@dvhart.com, johan.eker@ericsson.com, p.faure@akatech.ch,
        linux-kernel@vger.kernel.org, claudio@evidence.eu.com,
        michael@amarulasolutions.com, fchecconi@gmail.com,
        tommaso.cucinotta@sssup.it, nicola.manica@disi.unitn.it,
        luca.abeni@unitn.it, dhaval.giani@gmail.com, hgu1972@gmail.com,
        paulmck@linux.vnet.ibm.com, raistlin@linux.it, insop.song@gmail.com,
        liming.wang@windriver.com, jkacur@redhat.com,
        harald.gustafsson@ericsson.com, vincent.guittot@linaro.org,
        bruce.ashfield@windriver.com, rob@landley.net
Subject: Re: [PATCH] sched/deadline: Add sched_dl documentation
Message-ID: <20140120114606.GA31570@twins.programming.kicks-ass.net>
References: <1390214440-2711-1-git-send-email-juri.lelli@gmail.com>
 <20140120112442.GA8907@austad.us>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140120112442.GA8907@austad.us>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 20, 2014 at 12:24:42PM +0100, Henrik Austad wrote:
> > +2. Task scheduling
> > +==================
> > +
> > + The typical -deadline task is composed of a computation phase (instance)
> > + which is activated on a periodic or sporadic fashion. The expected (maximum)
> > + duration of such computation is called the task's runtime; the time interval
> > + by which each instance needs to be completed is called the task's relative
> > + deadline. The task's absolute deadline is dynamically calculated as the
> > + time instant a task (or, more properly) activates plus the relative
> > + deadline.
> 
> activates - released?
> 
> Since real-time papers from different rt-campus around the academia insist 
> on using *slightly* different terminology, perhaps add a short dictionary 
> for some of the more common terms?

Oh gawd, they really don't conform with their definitions? I'd not
noticed that.

> D: relative deadline, typically N ms after release

You failed to define release :-) Its the 'wakeup' event, right? Where
the activation would be the moment we actually schedule the
job/instance?

> d: absolute deadline, the physical time when a given instance of a job 
>    needs to be completed
> R: relative release time, for periodic tasks, this is typically 'every N 
>    ms'
> r: absolute release time
> C: Worst-case execution time
> 
>    ...you get the idea.
> 
> Perhaps too academic?

I think not, one can never be too clear about these things.

> > +4. Tasks CPU affinity
> > +=====================
> > +
> > + -deadline tasks cannot have an affinity mask smaller that the entire
> > + root_domain they are created on. However, affinities can be specified
> > + through the cpuset facility (Documentation/cgroups/cpusets.txt).
> 
> Does this mean that sched_deadline is a somewhat global implementation? 

Yes, its a GEDF like thing.

> Or 
> rather, at what point in time will sched_deadline take all cpus in a set 
> into consideration and when will it only look at the current CPU? Where is 
> the line drawn between global and fully partitioned?

Its drawn >< that close to global.

So I think adding a SCHED_FLAG_DL_HARD option which would reduce to
strict per-cpu affinity and deliver 0 tardiness is a future work.

Its slightly complicated in that you cannot share the DL tree between
the GEDF and EDF jobs, because while a GEDF job might have an earlier
deadline an EDF job might have a lesser laxity. Not running the EDF job
in that case would result in a deadline miss (although, assuming we'd
still have function GEDF admission control, still have bounded
tardiness).

I'm not entirely sure we want to do anything in between the fully global
and per-cpu 'hard' mode -- random affinity masks seems like a terribly
hard problem.

NOTE: the 'global' nature is per root_domain, so cpusets can be used to
carve the thing into smaller balance sets.

> Also, how do you account the budget when a resource holder is boosted in 
> order to release a resource? (IIRC, you use BWI, right?)

Boosting is still work in progress, but yes, it does a BWI like thing.
