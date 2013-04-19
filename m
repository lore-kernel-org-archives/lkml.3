Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757680Ab3DSJhg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Apr 2013 05:37:36 -0400
Received: from mout.gmx.net ([212.227.17.22]:57852 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755281Ab3DSJhf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Apr 2013 05:37:35 -0400
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX19moBoYNoxmwEXDnSEFrTMbRwBNmehtV2f2yuXvkQ
	TdTyp0VO7korlK
Message-ID: <1366364246.4708.79.camel@marge.simpson.net>
Subject: Re: [PATCH Resend v6] sched: fix wrong rq's runnable_avg update
 with rt tasks
From: Mike Galbraith <efault@gmx.de>
To: Vincent Guittot <vincent.guittot@linaro.org>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
        "linaro-kernel@lists.linaro.org" <linaro-kernel@lists.linaro.org>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@kernel.org>,
        Paul Turner <pjt@google.com>, Steven Rostedt <rostedt@goodmis.org>,
        =?ISO-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec@gmail.com>
Date: Fri, 19 Apr 2013 11:37:26 +0200
In-Reply-To: <1366363304.4708.75.camel@marge.simpson.net>
References: <1366302867-5055-1-git-send-email-vincent.guittot@linaro.org>
	 <1366345833.4708.17.camel@marge.simpson.net>
	 <CAKfTPtAaUG4Yi5xienLRvnO7Q8nTWjk9a0azRWwdqmvCu3NSrA@mail.gmail.com>
	 <1366359290.4708.48.camel@marge.simpson.net>
	 <CAKfTPtBuAwyiNYk17SnW066FhvGF18n+HaiKwhKLgsii8ntcHA@mail.gmail.com>
	 <1366363304.4708.75.camel@marge.simpson.net>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2013-04-19 at 11:21 +0200, Mike Galbraith wrote: 
> On Fri, 2013-04-19 at 10:50 +0200, Vincent Guittot wrote: 
> > On 19 April 2013 10:14, Mike Galbraith <efault@gmx.de> wrote:
> > > On Fri, 2013-04-19 at 09:49 +0200, Vincent Guittot wrote:
> > >> On 19 April 2013 06:30, Mike Galbraith <efault@gmx.de> wrote:
> > >> > On Thu, 2013-04-18 at 18:34 +0200, Vincent Guittot wrote:
> > >> >> The current update of the rq's load can be erroneous when RT tasks are
> > >> >> involved
> > >> >>
> > >> >> The update of the load of a rq that becomes idle, is done only if the avg_idle
> > >> >> is less than sysctl_sched_migration_cost. If RT tasks and short idle duration
> > >> >> alternate, the runnable_avg will not be updated correctly and the time will be
> > >> >> accounted as idle time when a CFS task wakes up.
> > >> >>
> > >> >> A new idle_enter function is called when the next task is the idle function
> > >> >> so the elapsed time will be accounted as run time in the load of the rq,
> > >> >> whatever the average idle time is. The function update_rq_runnable_avg is
> > >> >> removed from idle_balance.
> > >> >>
> > >> >> When a RT task is scheduled on an idle CPU, the update of the rq's load is
> > >> >> not done when the rq exit idle state because CFS's functions are not
> > >> >> called. Then, the idle_balance, which is called just before entering the
> > >> >> idle function, updates the rq's load and makes the assumption that the
> > >> >> elapsed time since the last update, was only running time.
> > >> >>
> > >> >> As a consequence, the rq's load of a CPU that only runs a periodic RT task,
> > >> >> is close to LOAD_AVG_MAX whatever the running duration of the RT task is.
> > >> >
> > >> > Why do we care what rq's load says, if the only thing running is a
> > >> > periodic RT task?  I _think_ I recall that stuff being put under the
> > >>
> > >> cfs scheduler will use a wrong rq load the next time it wants to schedule a task
> > >>
> > >> > throttle specifically to not waste cycles doing that on every
> > >> > microscopic idle.
> > >>
> > >> yes but this lead to the wrong computation of runnable_avg_sum. To be
> > >> more precise, we only need to call __update_entity_runnable_avg,
> > >> __update_tg_runnable_avg is not mandatory in this step.
> > >
> > > If it only scares fair class tasks away from the periodic rt load, that
> > > seems like a benefit to me, not a liability.  If we really really need
> > 
> > I'm not sure that such behavior that is only based on erroneous value,
> > is good one.
> > 
> > > perfect load numbers, fine, we have to eat some cycles, but when I look
> > > at it, it looks like one of those "Perfect is the enemy of good" things.
> > 
> > The target is not perfect number but good enough to be usable. The
> > systctl_migration_cost threshold is good for idle balancing but can
> > generates wrong load value
> 
> But again, why do we care?  To be able to mix rt and fair loads and
> still make pretty mixed load utilization numbers?  Paying a general case
> fast path price to make strange (to me) load utilization numbers pretty
> is not very attractive.

So I'm not convinced this is a good thing to do, but it's not my call,
that's Peter and Ingos job, so having expressed my opinion, I'll shut up
and let them do their thing ;-)

-Mike

