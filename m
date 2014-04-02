Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030253AbaDBTgP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Apr 2014 15:36:15 -0400
Received: from mail-qa0-f47.google.com ([209.85.216.47]:53076 "EHLO
	mail-qa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964780AbaDBTgI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Apr 2014 15:36:08 -0400
MIME-Version: 1.0
In-Reply-To: <5338CE0B.1050100@jp.fujitsu.com>
References: <5338CC86.9080602@jp.fujitsu.com> <5338CE0B.1050100@jp.fujitsu.com>
From: Denys Vlasenko <vda.linux@googlemail.com>
Date: Wed, 2 Apr 2014 21:35:47 +0200
Message-ID: <CAK1hOcMmmq=5EVLBrAd44HC+EHrnztABU48gd9BgK+LUNBJSOQ@mail.gmail.com>
Subject: Re: [PATCH 1/2] nohz: use seqlock to avoid race on idle time stats v2
To: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Fernando Luis Vazquez Cao <fernando_b1@lab.ntt.co.jp>,
        Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Arjan van de Ven <arjan@linux.intel.com>,
        Oleg Nesterov <oleg@redhat.com>,
        Preeti U Murthy <preeti@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 31, 2014 at 4:08 AM, Hidetoshi Seto
<seto.hidetoshi@jp.fujitsu.com> wrote:
> There are 2 problems:
>
> [PROBLEM 1]: there is no exclusive control.
>
> It is easy to understand that there are 2 different cpu - an
> observing cpu where running a program observing idle cpu's stat
> and an observed cpu where performing idle. It means race can
> happen if observed cpu wakes up while it is observed. Observer
> can accidentally add calculated duration time (say delta) to
> time stats which is just updated by woken cpu. Soon correct
> idle time is returned in next turn, so it will result in
> backward time. Therefore readers must be excluded by writer.
>
> Then time stats are updated by woken cpu so there are only one
> writer, right? No, unfortunately no. I'm not sure why are they,
> but in some reason the function get_cpu_{idle,iowait}_time_us()
> has ability to update sleeping cpu's time stats from observing
> cpu. From grep of today's kernel tree, this feature is used by
> cpufreq module. Calling this function with this feature in
> periodically manner works like emulating tick for sleeping cpu.

Frederic's patches started by moving all updates
to tick_nohz_stop_idle(), makign the above problem easier -
get_cpu_{idle,iowait}_time_us() are pure readers.

The patches are here:

https://lkml.org/lkml/2013/10/19/86

> [PROBLEM 2]: broken iowait accounting.
>
> As historical nature, cpu's idle time was accounted as either
> idle or iowait depending on the presence of tasks blocked by
> I/O. No one complain about it for a long time. However:
>
>   > Still trying to wrap my head around it, but conceptually
>   > get_cpu_iowait_time_us() doesn't make any kind of sense.
>   > iowait isn't per cpu since effectively tasks that aren't
>   > running aren't assigned a cpu (as Oleg already pointed out).
>   -- Peter Zijlstra
>
> Now some kernel folks realized that accounting iowait as per-cpu
> does not make sense in SMP world. When we were in traditional
> UP era, cpu is considered to be waiting I/O if it is idle while
> nr_iowait > 0. But in these days with SMP systems, tasks easily
> migrate from a cpu where they issued an I/O to another cpu where
> they are queued after I/O completion.

However, if we would put ourselves into admin's seat, iowait
immediately starts to make sense: for admin, the system state
where a lot of CPU time is genuinely idle is qualitatively different
form the state where a lot of CPU time is "idle" because
we are I/O bound.

Admins probably wouldn't insist that iowait accounting must be
very accurate. I would hazard to guess that admins would settle
for the following rules:

* (idle + iowait) should accurately represent amount of time
CPUs were idle.
* both idle and iowait should never go backwards
* when system is truly idle, only idle should increase
* when system is truly I/O bound on all CPUs, only iowait should increase
* when the situation is in between of the above two cases,
both iowait and idle counters should grow. It's ok if they
represent idle/IO-bound ratio only approximately

> Back to NO_HZ mechanism. Totally terrible thing here is that
> observer need to handle duration "delta" without knowing that
> nr_iowait of sleeping cpu can be changed easily by migration
> even if cpu is sleeping.

How about the following: when CPU enters idle, it remembers
in struct tick_sched->idle_active whether it was "truly" idle
or I/O bound: something like

ts->idle_active = nr_iowait_cpu(smp_processor_id()) ? 2 : 1;

Then, when we exit idle, we account entire idle period as
"true" idle or as iowait depending on ts->idle_active value,
regardless of what happened to I/O bound task (whether
it migrated or not).


> [WHAT THIS PATCH PROPOSED]: fix problem 1 first.
>
> To fix problem 1, this patch adds seqlock for NO_HZ idle
> accounting to avoid possible races between multiple reader/writer.

That's what Frederic proposed too.
However, he thought it adds too much overhead. It adds
a new field, two memory barriers and a RMW cycle
in the updater (tick_nohz_stop_idle),
and similarly two memory barriers in readers too.

How about a slightly different approach.
We take his first two patches:

"nohz: Convert a few places to use local per cpu accesses"
"nohz: Only update sleeptime stats locally"

then on top of that we fix racy access by readers as follows:

updater does not need ts->idle_entrytime field
after it is done. We can reuse it as "updater in progress" flag.
We set it to a sentinel value (say, zero),
then increase idle or iowait, then clear ts->idle_active.
With two memory barriers to ensure other CPUs see
updates exactly in that order:

tick_nohz_stop_idle(struct tick_sched *ts, ktime_t now):
...
        /* Updates the per cpu time idle statistics counters */
        delta = ktime_sub(now, ts->idle_entrytime);
-       if (nr_iowait_cpu(smp_processor_id()) > 0)
+       ts->idle_entrytime.tv64 = 0;
+       smp_wmb();
+       if (ts->idle_active == 2)
                ts->iowait_sleeptime = ktime_add(ts->iowait_sleeptime, delta);
        else
                ts->idle_sleeptime = ktime_add(ts->idle_sleeptime, delta);
+       smp_wmb();
        ts->idle_active = 0;

Compared to seqlock approach, we don't need a new field (seqlock counter)
and don't need to increment it twice (two RMW cycles). We have the same
number of wmb's as seqlock approach has - two.

The iowait reader reads these three fields in reverse order,
with correct read barriers:

get_cpu_iowait_time_us(int cpu, u64 *last_update_time):
...
+ again:
+       active = ACCESS_ONCE(ts->idle_active);
+       smp_rmb();
+       count = ACCESS_ONCE(ts->iowait_sleeptime);
+       if (active == 2) {   // 2 means "idle was entered with pending I/O"
+               smp_rmb();
+               start = ACCESS_ONCE(ts->idle_entrytime);
....
+       }
+       return count;

Compared to seqlock approach, we can avoid second rmb (as shown above)
if we see that idle_active was not set: we know that in this case,
we already have the result in "count", no need to correct it.

Now, if idle_active was set (for iowait case, to 2). We can check the
sentinel in idle_entrytime. If it is there, we are racing with updater.
in this case, we loop back:

+       if (active == 2) {
+               smp_rmb();
+               start = ACCESS_ONCE(ts->idle_entrytime);
+               if (start.tv64 == 0)
+                       /* Other CPU is updating the count.
+                        * We don't know whether fetched count is valid.
+                        */
+                       goto again;
+               delta = ktime_sub(now, start);
+               count = ktime_add(count, delta);
        }

If we don't see sentinel, we adjust "count" and we are done.

I will send the full patches shortly.

Thoughts?
