Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751879AbaFDIzp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jun 2014 04:55:45 -0400
Received: from fw-tnat.austin.arm.com ([217.140.110.23]:29338 "EHLO
	collaborate-mta1.arm.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751710AbaFDIzn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jun 2014 04:55:43 -0400
Date: Wed, 4 Jun 2014 09:55:42 +0100
From: Morten Rasmussen <morten.rasmussen@arm.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Vincent Guittot <vincent.guittot@linaro.org>,
        "mingo@kernel.org" <mingo@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux@arm.linux.org.uk" <linux@arm.linux.org.uk>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "preeti@linux.vnet.ibm.com" <preeti@linux.vnet.ibm.com>,
        "efault@gmx.de" <efault@gmx.de>,
        "nicolas.pitre@linaro.org" <nicolas.pitre@linaro.org>,
        "linaro-kernel@lists.linaro.org" <linaro-kernel@lists.linaro.org>,
        "daniel.lezcano@linaro.org" <daniel.lezcano@linaro.org>
Subject: Re: [PATCH v2 08/11] sched: get CPU's activity statistic
Message-ID: <20140604085542.GH29593@e103034-lin>
References: <1400860385-14555-1-git-send-email-vincent.guittot@linaro.org>
 <1400860385-14555-9-git-send-email-vincent.guittot@linaro.org>
 <20140528121001.GI19967@e103034-lin>
 <CAKfTPtDxeBfZK1AxCRqEG91pi--Ti1RYFoQPDhvMVnGTCspQ-g@mail.gmail.com>
 <20140528154703.GJ19967@e103034-lin>
 <20140603155007.GZ30445@twins.programming.kicks-ass.net>
 <CAKfTPtDUvH--WxFATTW6YRAvLuohzyNHDUq6DRdfxc7gRKCX6Q@mail.gmail.com>
 <20140604080809.GK30445@twins.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140604080809.GK30445@twins.programming.kicks-ass.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 04, 2014 at 09:08:09AM +0100, Peter Zijlstra wrote:
> On Wed, Jun 04, 2014 at 09:47:26AM +0200, Vincent Guittot wrote:
> > On 3 June 2014 17:50, Peter Zijlstra <peterz@infradead.org> wrote:
> > > On Wed, May 28, 2014 at 04:47:03PM +0100, Morten Rasmussen wrote:
> > >> Since we may do periodic load-balance every 10 ms or so, we will perform
> > >> a number of load-balances where runnable_avg_sum will mostly be
> > >> reflecting the state of the world before a change (new task queued or
> > >> moved a task to a different cpu). If you had have two tasks continuously
> > >> on one cpu and your other cpu is idle, and you move one of the tasks to
> > >> the other cpu, runnable_avg_sum will remain unchanged, 47742, on the
> > >> first cpu while it starts from 0 on the other one. 10 ms later it will
> > >> have increased a bit, 32 ms later it will be 47742/2, and 345 ms later
> > >> it reaches 47742. In the mean time the cpu doesn't appear fully utilized
> > >> and we might decide to put more tasks on it because we don't know if
> > >> runnable_avg_sum represents a partially utilized cpu (for example a 50%
> > >> task) or if it will continue to rise and eventually get to 47742.
> > >
> > > Ah, no, since we track per task, and update the per-cpu ones when we
> > > migrate tasks, the per-cpu values should be instantly updated.
> > >
> > > If we were to increase per task storage, we might as well also track
> > > running_avg not only runnable_avg.
> > 
> > I agree that the removed running_avg should give more useful
> > information about the the load of a CPU.
> > 
> > The main issue with running_avg is that it's disturbed by other tasks
> > (as point out previously). As a typical example,  if we have 2 tasks
> > with a load of 25% on 1 CPU, the unweighted runnable_load_avg will be
> > in the range of [100% - 50%] depending of the parallelism of the
> > runtime of the tasks whereas the reality is 50% and the use of
> > running_avg will return this value

Both running_avg and runnable_avg are affected by other tasks on the
same cpus, but in different ways. They are equal if you only have one
task on a cpu. If you have more, running_avg will give you the true
requirement of the tasks until the cpu is fully utilized. At which point
the task running_avg will drop if you add more tasks (the unweighted sum
of task running_avgs remains constant).

runnable_avg on the other hand, might be affected as soon as you have
two task running on the same cpu if they are runnable at the same time.
That isn't necessarily a bad thing for load-balancing purposes, because
tasks that are runnable at the same time are likely to be run more
efficiently by placing them on different cpus. You might view as at sort
of built in concurrency factor, somewhat similar to what Yuyang is
proposing. runnable_avg increases rapidly when the cpu is over-utilized.

> I'm not sure I see how 100% is possible, but yes I agree that runnable
> can indeed be inflated due to this queueing effect.

You should only be able to get to 75% worst case for runnable_avg for
that example. The total running_avg is 50% no matter if the tasks
overlaps or not.

f you had five tasks on one cpu that each have a 25% requirement you can
get individual task runnable_avgs of up to 100% (cpu unweighted
runnable_load_avg can get up 500%, I think), but the task running_avgs
would be 20% each (total of 100%). 
