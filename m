Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754386AbaAUKWL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jan 2014 05:22:11 -0500
Received: from mail-lb0-f182.google.com ([209.85.217.182]:36479 "EHLO
	mail-lb0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754023AbaAUKWI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jan 2014 05:22:08 -0500
Date: Tue, 21 Jan 2014 11:20:16 +0100
From: Henrik Austad <henrik@austad.us>
To: Luca Abeni <luca.abeni@unitn.it>
Cc: Juri Lelli <juri.lelli@gmail.com>, peterz@infradead.org,
        tglx@linutronix.de, mingo@redhat.com, rostedt@goodmis.org,
        oleg@redhat.com, fweisbec@gmail.com, darren@dvhart.com,
        johan.eker@ericsson.com, p.faure@akatech.ch,
        linux-kernel@vger.kernel.org, claudio@evidence.eu.com,
        michael@amarulasolutions.com, fchecconi@gmail.com,
        tommaso.cucinotta@sssup.it, nicola.manica@disi.unitn.it,
        dhaval.giani@gmail.com, hgu1972@gmail.com, paulmck@linux.vnet.ibm.com,
        raistlin@linux.it, insop.song@gmail.com, liming.wang@windriver.com,
        jkacur@redhat.com, harald.gustafsson@ericsson.com,
        vincent.guittot@linaro.org, bruce.ashfield@windriver.com,
        rob@landley.net
Subject: Re: [PATCH] sched/deadline: Add sched_dl documentation
Message-ID: <20140121102016.GA12002@austad.us>
References: <1390214440-2711-1-git-send-email-juri.lelli@gmail.com>
 <20140120112442.GA8907@austad.us>
 <52DD1377.5090201@gmail.com>
 <20140120131616.GB8907@austad.us>
 <52DD2711.9080504@unitn.it>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <52DD2711.9080504@unitn.it>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 20, 2014 at 02:39:29PM +0100, Luca Abeni wrote:
> Hi all,
> 
> On 01/20/2014 02:16 PM, Henrik Austad wrote:
> [...]
> >>>>+ The typical -deadline task is composed of a computation phase (instance)
> >>>>+ which is activated on a periodic or sporadic fashion. The expected (maximum)
> >>>>+ duration of such computation is called the task's runtime; the time interval
> >>>>+ by which each instance needs to be completed is called the task's relative
> >>>>+ deadline. The task's absolute deadline is dynamically calculated as the
> >>>>+ time instant a task (or, more properly) activates plus the relative
> >>>>+ deadline.
> >>>
> >>>activates - released?
> >>>
> >>
> >>I'd keep (modifying a bit):
> >>
> >>"time instant a task activates plus the relative deadline."
> >>
> >>This is probably the nearest thing to what is implemented that we can say
> >>(without entering into the theory too much), a task that "activates" can mean
> >>that it is first released, enqueued, woken-up, etc.
> >
> >So, if we look at release (yes, I'm avoiding activates for a little while)
> >as the time at the *beginning* of a new period, then, and only then should
> >the *absolute* deadline be computed.
> >
> >If you den move on to use 'activate' as a term for when a task becomes
> >eligble to run, then 'release' becomes a subset of 'activate', and you
> >should only compute the absolute deadline at that time. Did that make
> >sense?

> I think things are a little bit complex here, because there are 2 different
> "deadlines" we can think about:
> - the "jobs deadlines" (the absolute job deadline can be computed at job
>   arrival, as the arrival time + the relative deadline). These are generally
>   used for performance metrics, to see if a job is respecting its timing
>   constraints or not
>
> - the "scheduling deadlines", which are the ones used by the scheduler to
>   schedule the tasks. These are computed at tasks' wake-up time - notice that
>   for self-suspending jobs there can be wake-up times that are not job arrival
>   times. And are assigned according to the rules described in the CBS paper.
>
> I think this can easily become very confusing, so I currently have no concrete
> proposals for improving the documentation... But I wanted to point out that
> things here are more complex than in the "traditional" real-time task model.

Traditional real-time as in the current real-time model used in Linux, or 
traditional as in EDF terminology used by Liu & Layland?

> Maybe a solution could be to simply describe scheduling deadlines (which are
> what sched_deadline uses) without going into the details of jobs' deadlines.

Huh?

We definately need a short dictionary. In fact, I'd like to have a 
paragraph describing what deadline driven scheduling is.

For instance, I'm getting *Really* confused wrt to arrival time - you seem 
to wrap several types of arrival into the same name,  yet treat it 
differently.

- arrival: when a job gets ready to run for the first time
- arrival: when a job unblocks on some resource

Or did I misunderstand?

So, the terminology I'm used to, an attempt to write up something to 
clear up the terminology and establish common grounds. Please 
edit/elaborate or shoot down as appropriate:

"""
N. Crashcourse in deadline-terminology:

In a system, we typically look at a set of tasks. In Linux-kernel 
terminology, a particular task is normally a thread. When a thread is 
ready to run, we say that a *job* of that task is running. It is 
perhaps easiest to grasp this if one think only of periodic tasks, i.e. a 
thread that need to run for 2ms every 10ms. Normally, we want one job to 
finish before a new (of the same task) start, which implies that the 
deadline for this task is also 10ms. Once this is clear, expanding one's 
mind to aperiodic and/or sporadic tasks is easier.

* Periodic task: a task that needs to run for a while every N us.
* Sporadic task: a tasks that needs tor un for a while at most every N us 
  (jobs start no closer than N us apart)
* Aperiodic task: a task that have no particular period, but once 
  released, needs to complete before a given deadline.

* Set of all deadline-tasks in the system: \tau
* One particluar task: \tau_i
* The j'th job of task i: \tau_{i,j}
* The (relative) deadline of task i: D_i
* The (periodic, relative) release time of task i: R_i
* Required execution time a tasks's job needs to complete. C_i
* Absolute release-time, the time when a new job is ready (when a thread is 
  woken up for a new period).
* The absolute deadline of a job, the actual point in time where a job 
  needs to be finished. This is what the scheduler looks at when it picks 
  the next thread to run.

We can now construct a 3-tuple describing a perioic and sporadic tasks: 

          (C_i, R_i, D_i).

These 3 items is what you can use to describe your task to the scheduler.
"""

> So, the document could avoid talking about instances (or jobs), and can say
> that a task is guaranteed to receive "runtime" time units every "period" time
> units (and these "runtime" time units are available within "deadline" time
> units from the beginning of the period). Every time the task wakes up, the
> scheduler computes a scheduling deadline consistent with this constraint,
> and tasks are scheduled using EDF on these scheduling deadlines.
> Every time "runtime" time units are consumed in a period, the scheduling
> deadline is postponed by a period.

What is wrong with using the CORRECT TERMINOLOGY? People looking at using 
sched_deadline _need_ to understand what a _deadline_ scheduler is.

If the only goal of sched_deadline is to act as a bandwidth-gauge, then 
fine, but *I* want to use sched_deadline for systems that HAVE DEADLINES. I 
do NOT want to mess around with mapping deadlines to priorities in order to 
meet my deadlines. I suspect others would like to use sched_deadline for 
the same.

> This is of course an approximative description, but I think it can give an
> intuitive idea of how the scheduler works, and about the meaning of the three
> scheduling parameters.

Look, I'm not in favour of turning sched_deadline.txt into an academic 
paper, but it is clear that we need to establish a baseline here, and then 
we need to include tasks, instances/jobs, deadline, arrival/release and so 
on.

-- 
Henrik Austad
