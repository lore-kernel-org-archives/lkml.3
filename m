Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752631AbaFDLxL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jun 2014 07:53:11 -0400
Received: from mail-oa0-f50.google.com ([209.85.219.50]:62326 "EHLO
	mail-oa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751967AbaFDLxH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jun 2014 07:53:07 -0400
MIME-Version: 1.0
In-Reply-To: <20140604112342.GN29593@e103034-lin>
References: <20140528121001.GI19967@e103034-lin> <CAKfTPtDxeBfZK1AxCRqEG91pi--Ti1RYFoQPDhvMVnGTCspQ-g@mail.gmail.com>
 <20140528154703.GJ19967@e103034-lin> <20140603155007.GZ30445@twins.programming.kicks-ass.net>
 <CAKfTPtDUvH--WxFATTW6YRAvLuohzyNHDUq6DRdfxc7gRKCX6Q@mail.gmail.com>
 <20140604080809.GK30445@twins.programming.kicks-ass.net> <CAKfTPtBCG1Jq2b+fyoGuA=7yG_yUbsmaD+j-ZXXsPNGp5giKpg@mail.gmail.com>
 <20140604101724.GD11096@twins.programming.kicks-ass.net> <20140604103619.GL29593@e103034-lin>
 <CAKfTPtCVyLRG-fSge1shdw5aSDB3y=_qzU1DOVgCx0VBnn6mnA@mail.gmail.com> <20140604112342.GN29593@e103034-lin>
From: Vincent Guittot <vincent.guittot@linaro.org>
Date: Wed, 4 Jun 2014 13:52:46 +0200
Message-ID: <CAKfTPtCsxkypo_4e9zTHV_XPUt7-Bybot2uNOHUZVfbd=7vXHw@mail.gmail.com>
Subject: Re: [PATCH v2 08/11] sched: get CPU's activity statistic
To: Morten Rasmussen <morten.rasmussen@arm.com>
Cc: Peter Zijlstra <peterz@infradead.org>,
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
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 4 June 2014 13:23, Morten Rasmussen <morten.rasmussen@arm.com> wrote:
> On Wed, Jun 04, 2014 at 12:07:29PM +0100, Vincent Guittot wrote:
>> On 4 June 2014 12:36, Morten Rasmussen <morten.rasmussen@arm.com> wrote:
>> > On Wed, Jun 04, 2014 at 11:17:24AM +0100, Peter Zijlstra wrote:
>> >> On Wed, Jun 04, 2014 at 11:32:10AM +0200, Vincent Guittot wrote:
>> >> > On 4 June 2014 10:08, Peter Zijlstra <peterz@infradead.org> wrote:
>> >> > > On Wed, Jun 04, 2014 at 09:47:26AM +0200, Vincent Guittot wrote:
>> >> > >> On 3 June 2014 17:50, Peter Zijlstra <peterz@infradead.org> wrote:
>> >> > >> > On Wed, May 28, 2014 at 04:47:03PM +0100, Morten Rasmussen wrote:
>> >> > >> >> Since we may do periodic load-balance every 10 ms or so, we will perform
>> >> > >> >> a number of load-balances where runnable_avg_sum will mostly be
>> >> > >> >> reflecting the state of the world before a change (new task queued or
>> >> > >> >> moved a task to a different cpu). If you had have two tasks continuously
>> >> > >> >> on one cpu and your other cpu is idle, and you move one of the tasks to
>> >> > >> >> the other cpu, runnable_avg_sum will remain unchanged, 47742, on the
>> >> > >> >> first cpu while it starts from 0 on the other one. 10 ms later it will
>> >> > >> >> have increased a bit, 32 ms later it will be 47742/2, and 345 ms later
>> >> > >> >> it reaches 47742. In the mean time the cpu doesn't appear fully utilized
>> >> > >> >> and we might decide to put more tasks on it because we don't know if
>> >> > >> >> runnable_avg_sum represents a partially utilized cpu (for example a 50%
>> >> > >> >> task) or if it will continue to rise and eventually get to 47742.
>> >> > >> >
>> >> > >> > Ah, no, since we track per task, and update the per-cpu ones when we
>> >> > >> > migrate tasks, the per-cpu values should be instantly updated.
>> >> > >> >
>> >> > >> > If we were to increase per task storage, we might as well also track
>> >> > >> > running_avg not only runnable_avg.
>> >> > >>
>> >> > >> I agree that the removed running_avg should give more useful
>> >> > >> information about the the load of a CPU.
>> >> > >>
>> >> > >> The main issue with running_avg is that it's disturbed by other tasks
>> >> > >> (as point out previously). As a typical example,  if we have 2 tasks
>> >> > >> with a load of 25% on 1 CPU, the unweighted runnable_load_avg will be
>> >> > >> in the range of [100% - 50%] depending of the parallelism of the
>> >> > >> runtime of the tasks whereas the reality is 50% and the use of
>> >> > >> running_avg will return this value
>> >> > >
>> >> > > I'm not sure I see how 100% is possible, but yes I agree that runnable
>> >> > > can indeed be inflated due to this queueing effect.
>> >>
>> >> Let me explain the 75%, take any one of the above scenarios. Lets call
>> >> the two tasks A and B, and let for a moment assume A always wins and
>> >> runs first, and then B.
>> >>
>> >> So A will be runnable for 25%, B otoh will be runnable the entire time A
>> >> is actually running plus its own running time, giving 50%. Together that
>> >> makes 75%.
>> >>
>> >> If you release the assumption that A runs first, but instead assume they
>> >> equally win the first execution, you get them averaging at 37.5% each,
>> >> which combined will still give 75%.
>> >
>> > But that is assuming that the first task gets to run to completion of it
>> > busy period. If it uses up its sched_slice and we switch to the other
>> > tasks, they both get to wait.
>> >
>> > For example, if the sched_slice is 5 ms and the busy period is 10 ms,
>> > the execution pattern would be: A, B, A, B, idle, ... In that case A is
>> > runnable for 15 ms and B is for 20 ms. Assuming that the overall period
>> > is 40 ms, the A runnable is 37.5% and B is 50%.
>>
>> The exact value for your scheduling example above is:
>> A runnable will be 47% and B runnable will be 60% (unless i make a
>> mistake in my computation)
>
> I get:
>
> A: 15/40 ms = 37.5%
> B: 20/40 ms = 50%
>
> Schedule:
>
>    | 5 ms | 5 ms | 5 ms | 5 ms | 5 ms | 5 ms | 5 ms | 5 ms | 5 ms |
> A:   run     rq     run  ----------- sleeping -------------  run
> B:   rq      run    rq    run   ---- sleeping -------------  rq
>
>> and CPU runnable will be 60% too
>
> rq->avg.runnable_avg_sum should be 50%. You have two tasks running for
> 20 ms every 40 ms.
>
> Right?

ok, i see the misunderstood.
it's depends of what we mean by runnable. You take the % of time
whereas i take the runnable_avg_sum/period

so A is on_rq 15/40 ms = 37.5% of the time which gives a
runnable_avg_sum/runnable_avg_period of 47%
B is on_rq  20/40 ms = 50% of the time which gives a
runnable_avg_sum/runnable_avg_period of 60%
and CPU has a task on its rq 20/40ms = 50% of the time which gives a
runnable_avg_sum/runnable_avg_period of 60%

Vincent

>
> Morten
