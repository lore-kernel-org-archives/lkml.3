Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752888Ab3DUIyy (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Apr 2013 04:54:54 -0400
Received: from mail-wi0-f176.google.com ([209.85.212.176]:54481 "EHLO
	mail-wi0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752520Ab3DUIyv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Apr 2013 04:54:51 -0400
Date: Sun, 21 Apr 2013 10:54:47 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Rakib Mullick <rakib.mullick@gmail.com>
Cc: Paul Gortmaker <paul.gortmaker@windriver.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [RFC PATCH 0/2] sched: move content out of core files for load
 average
Message-ID: <20130421085447.GB31470@gmail.com>
References: <1365811457-31924-1-git-send-email-paul.gortmaker@windriver.com>
 <20130415093330.GC17715@gmail.com>
 <1366283681.19383.5.camel@laptop>
 <51701722.1070407@windriver.com>
 <20130419082546.GA25370@gmail.com>
 <CADZ9YHiy59tASG3uMXqdOv=RY79SMSzZb47oBh2uZGqfbCR+YQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CADZ9YHiy59tASG3uMXqdOv=RY79SMSzZb47oBh2uZGqfbCR+YQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Rakib Mullick <rakib.mullick@gmail.com> wrote:

> On Fri, Apr 19, 2013 at 2:25 PM, Ingo Molnar <mingo@kernel.org> wrote:
> >
> > * Paul Gortmaker <paul.gortmaker@windriver.com> wrote:
> >
> >> On 13-04-18 07:14 AM, Peter Zijlstra wrote:
> >> > On Mon, 2013-04-15 at 11:33 +0200, Ingo Molnar wrote:
> >> >> * Paul Gortmaker <paul.gortmaker@windriver.com> wrote:
> >> >>
> >> >>> Recent activity has had a focus on moving functionally related blocks of stuff
> >> >>> out of sched/core.c into stand-alone files.  The code relating to load average
> >> >>> calculations has grown significantly enough recently to warrant placing it in a
> >> >>> separate file.
> >> >>>
> >> >>> Here we do that, and in doing so, we shed ~20k of code from sched/core.c (~10%).
> >> >>>
> >> >>> A couple small static functions in the core sched.h header were also localized
> >> >>> to their singular user in sched/fair.c at the same time, with the goal to also
> >> >>> reduce the amount of "broadcast" content in that sched.h file.
> >> >>
> >> >> Nice!
> >> >>
> >> >> Peter, is this (and the naming of the new file) fine with you too?
> >> >
> >> > Yes and no.. that is I do like the change, but I don't like the
> >> > filename. We have _waaaay_ too many different things we call load_avg.
> >> >
> >> > That said, I'm having a somewhat hard time coming up with a coherent
> >> > alternative :/
> >>
> >> Several of the relocated functions start their name with "calc_load..."
> >> Does "calc_load.c" sound any better?
> >
> > Peter has a point about load_avg being somewhat of a misnomer: that's not your
> > fault in any way, we created overlapping naming within the scheduler and are now
> > hurting from it.
> >
> > Here are the main scheduler 'load' concepts we have right now:
> >
> >  - The externally visible 'average load' value extracted by tools like 'top' via
> >    /proc/loadavg and handled by fs/proc/loadavg.c. Internally the naming is all
> >    over the map: the fields that are updated are named 'avenrun[]', most other
> >    variables and methods are named calc_load_*(), and a few callbacks are named
> >    *_cpu_load_*().
> >
> >  - rq->cpu_load, a weighted, vectored scheduler-internal notion of task load
> >    average with multiple run length averages. Only exposed by debug interfaces but
> >    otherwise relied on by the scheduler for SMP load balancing.
> >
> >  - se->avg - per entity (per task) load average. This is integrated differently
> >    from the cpu_load - but work is ongoing to possibly integrate it with the
> >    rq->cpu_load metric. This metric is used for CPU internal execution time
> >    allocation and timeslicing, based on nice value priorities and cgroup
> >    weights and constraints.
> >
> > Work is ongoing to integrate rq->cpu_load and se->avg - eventually they will
> > become one metric.
> >
> > It might eventually make sense to integrate the 'average load' calculation as well
> > with all this - as they really have a similar purpose, the avenload[] vector of
> > averages is conceptually similar to the rq->cpu_load[] vector of averages.
> >
> > So I'd suggest to side-step all that existing confusion and simply name the new
> > file kernel/sched/proc.c - our external /proc scheduler ABI towards userspace.
> > This is similar to the already existing kernel/irq/proc.c pattern.
> >
> Well, kernel/sched/stat.c - also exposes scheduler ABI to userspace.

schedstats is more like a debug API, used by a low number of tools.

So I don't think it's particularly confusing.

Thanks,

	Ingo
