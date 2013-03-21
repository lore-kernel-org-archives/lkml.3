Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755344Ab3CUK50 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Mar 2013 06:57:26 -0400
Received: from mail-oa0-f51.google.com ([209.85.219.51]:39286 "EHLO
	mail-oa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753998Ab3CUK5Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Mar 2013 06:57:24 -0400
MIME-Version: 1.0
In-Reply-To: <20130321001211.GC31256@htj.dyndns.org>
References: <cover.1363617402.git.viresh.kumar@linaro.org>
	<fb2e721fc43fbc3517a7ebb905aa573b12bb83a5.1363617402.git.viresh.kumar@linaro.org>
	<20130321001211.GC31256@htj.dyndns.org>
Date: Thu, 21 Mar 2013 16:27:23 +0530
Message-ID: <CAKohponKUGbwEZ_edu353Y7YVZKgFOhZunTSUi04FGYWveftkw@mail.gmail.com>
Subject: Re: [PATCH V3 3/7] workqueue: Add helpers to schedule work on any cpu
From: Viresh Kumar <viresh.kumar@linaro.org>
To: Tejun Heo <tj@kernel.org>
Cc: pjt@google.com, paul.mckenney@linaro.org, tglx@linutronix.de,
        suresh.b.siddha@intel.com, venki@google.com, mingo@redhat.com,
        peterz@infradead.org, rostedt@goodmis.org,
        linaro-kernel@lists.linaro.org, robin.randhawa@arm.com,
        Steve.Bannister@arm.com, Liviu.Dudau@arm.com,
        charles.garcia-tobin@arm.com, Arvind.Chauhan@arm.com,
        linux-rt-users@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 21 March 2013 05:42, Tejun Heo <tj@kernel.org> wrote:
> On Mon, Mar 18, 2013 at 08:53:25PM +0530, Viresh Kumar wrote:

> For some reason, I've been always unsure about this patchset.  I've
> been thinking about it past few days and I think I now know why.

I knew this since the beginning and thought power numbers i showed might
change your view. My hard luck :)

> I can see that strategy like this being useful for timer, and
> impressive power saving numbers BTW - we definitely want that.  While
> workqueue shares a lot of attributes with timers, there's one
> important difference - scheduler is involved in work item executions.

Yes, scheduler is involved for queuing works queued on a UNBOUND wq.

> Work item scheduling for per-cpu work items artificially removes the
> choice of CPU from the scheduler with the assumption that such
> restrictions would lead to lower overall overhead.

Yes.. We aren't touching them here and we can't :)

> There is another
> variant of workqueue - WQ_UNBOUND - when such assumption wouldn't hold
> too well and it would be best to give the scheduler full latitude
> regarding scheduling work item execution including choice of CPU.

I liked this point of yours and what you said is correct too. But there is a
difference here with our approach.

I here see two parallel solutions:

1. What we proposed:
- Add another wq api and used sched_select_non_idle_cpu() to choose
the right cpu
- Fix user drivers we care about

2. What you proposed:
- Fix user drivers we care about by using UNBOUNDED workqueues rather than
system_wq or other private wq's. And let the scheduler do everything. Right?


Now there are two things i am worried about.

A.
About the difference in behavior of scheduler and sched_select_non_idle_cpu().
Scheduler will treat this work as any normal task and can schedule it anywhere
based on what it feels is the right place and may still wake up an idle one for
load balancing.

In our approach, We aren't switching CPU for a work if that cpu (or system) is
busy enough, like in case of high IOPS for block layer. We will find that cpu as
busy, most of the time on such situations and so we will stay where we were.

In case system is fairly idle, then also we stay on the same cpu.
The only time we migrate is when current cpu is idle but the whole system
isn't.

B.
It is sort of difficult to teach users about BOUND and UNBOUND workqueues
and people have used them without thinking too much about them since some
time. We need a straightforward API to make this more transparent. And
queue_work_on_any_cpu() was a good candidate here. I am not talking about
its implementation but about the interface.


Though in both suggestions we need to fix user drivers one by one to use
queue_work_on_any_cpu() or use WQ_UNBOUND..

> Now, this patchset, kinda sorta adds back CPU selection by scheduler
> in an ad-hoc way, right?

Yes.

> If we're gonna do that, why not just make it
> unbound workqueues?  Then, the scheduler would have full discretion
> over them and we don't need to implement this separate ad-hoc thing on
> the side.  It's the roundaboutness that bothers me.

I had my own reasons as explained earlier.

> I'm not sure about other workqueues but the block one can be very
> performance sensitive on machines with high IOPS and it would
> definitely be advisable to keep it CPU-affine unless power consumption
> is the overriding concern, so how about introducing another workqueue
> flag, say WQ_UNBOUND_FOR_POWER (it's terrible, please come up with
> something better), which is WQ_UNBOUND on configurations where this
> matters and becomes noop if not?

Maybe people wouldn't suffer much because of the reasons i told you earlier.
On a busy system we will never switch cpus.

This static configuration might not work well with multiplatform images.

--
viresh
