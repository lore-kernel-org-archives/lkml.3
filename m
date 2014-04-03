Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1162377AbaDCHDm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Apr 2014 03:03:42 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:32980 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1162345AbaDCHDj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Apr 2014 03:03:39 -0400
X-SecurityPolicyCheck: OK by SHieldMailChecker v1.7.4
Message-ID: <533D077D.4080503@jp.fujitsu.com>
Date: Thu, 03 Apr 2014 16:02:21 +0900
From: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows NT 6.0; rv:24.0) Gecko/20100101 Thunderbird/24.0
MIME-Version: 1.0
To: Denys Vlasenko <vda.linux@googlemail.com>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Fernando Luis Vazquez Cao <fernando_b1@lab.ntt.co.jp>,
        Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Arjan van de Ven <arjan@linux.intel.com>,
        Oleg Nesterov <oleg@redhat.com>,
        Preeti U Murthy <preeti@linux.vnet.ibm.com>
Subject: Re: [PATCH 1/2] nohz: use seqlock to avoid race on idle time stats
 v2
References: <5338CC86.9080602@jp.fujitsu.com> <5338CE0B.1050100@jp.fujitsu.com> <CAK1hOcMmmq=5EVLBrAd44HC+EHrnztABU48gd9BgK+LUNBJSOQ@mail.gmail.com>
In-Reply-To: <CAK1hOcMmmq=5EVLBrAd44HC+EHrnztABU48gd9BgK+LUNBJSOQ@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2014/04/03 4:35), Denys Vlasenko wrote:
> On Mon, Mar 31, 2014 at 4:08 AM, Hidetoshi Seto
> <seto.hidetoshi@jp.fujitsu.com> wrote:
>> There are 2 problems:
>>
>> [PROBLEM 1]: there is no exclusive control.
>>
>> It is easy to understand that there are 2 different cpu - an
>> observing cpu where running a program observing idle cpu's stat
>> and an observed cpu where performing idle. It means race can
>> happen if observed cpu wakes up while it is observed. Observer
>> can accidentally add calculated duration time (say delta) to
>> time stats which is just updated by woken cpu. Soon correct
>> idle time is returned in next turn, so it will result in
>> backward time. Therefore readers must be excluded by writer.
>>
>> Then time stats are updated by woken cpu so there are only one
>> writer, right? No, unfortunately no. I'm not sure why are they,
>> but in some reason the function get_cpu_{idle,iowait}_time_us()
>> has ability to update sleeping cpu's time stats from observing
>> cpu. From grep of today's kernel tree, this feature is used by
>> cpufreq module. Calling this function with this feature in
>> periodically manner works like emulating tick for sleeping cpu.
> 
> Frederic's patches started by moving all updates
> to tick_nohz_stop_idle(), makign the above problem easier -
> get_cpu_{idle,iowait}_time_us() are pure readers.
> 
> The patches are here:
> 
> https://lkml.org/lkml/2013/10/19/86

My concern here was that get_cpu_{idle,iowait}_time_us() are
exported function so that removing update functionality from
these affects kernel ABI compatibility. Even though I guess
there would be no other user than known cpufreq and kins, I also
thought that it looks like a shotgun approach and rough stuff. 

However now I noticed that it is old mindset from when kernel
have Documentation/feature-removal.txt ... so I'm OK with
removing updates from these functions.

Still I'd prefer to see this change in separate patch that
modifies get_cpu_{idle,iowait}_time_us() only. It should
have CC and acked-by with cpufreq people.

>> [PROBLEM 2]: broken iowait accounting.
>>
>> As historical nature, cpu's idle time was accounted as either
>> idle or iowait depending on the presence of tasks blocked by
>> I/O. No one complain about it for a long time. However:
>>
>>   > Still trying to wrap my head around it, but conceptually
>>   > get_cpu_iowait_time_us() doesn't make any kind of sense.
>>   > iowait isn't per cpu since effectively tasks that aren't
>>   > running aren't assigned a cpu (as Oleg already pointed out).
>>   -- Peter Zijlstra
>>
>> Now some kernel folks realized that accounting iowait as per-cpu
>> does not make sense in SMP world. When we were in traditional
>> UP era, cpu is considered to be waiting I/O if it is idle while
>> nr_iowait > 0. But in these days with SMP systems, tasks easily
>> migrate from a cpu where they issued an I/O to another cpu where
>> they are queued after I/O completion.
> 
> However, if we would put ourselves into admin's seat, iowait
> immediately starts to make sense: for admin, the system state
> where a lot of CPU time is genuinely idle is qualitatively different
> form the state where a lot of CPU time is "idle" because
> we are I/O bound.
> 
> Admins probably wouldn't insist that iowait accounting must be
> very accurate. I would hazard to guess that admins would settle
> for the following rules:
> 
> * (idle + iowait) should accurately represent amount of time
> CPUs were idle.
> * both idle and iowait should never go backwards
> * when system is truly idle, only idle should increase
> * when system is truly I/O bound on all CPUs, only iowait should increase
> * when the situation is in between of the above two cases,
> both iowait and idle counters should grow. It's ok if they
> represent idle/IO-bound ratio only approximately

Yep. Admins are at the mercy of iowait value, though they know it
is not accurate.

Assume there are task X,Y,Z (X issues io, Y sleeps moderately,
and Z has low priority):

Case 1:
  cpu A: <--run X--><--iowait--><--run X--><--iowait--><--run X ...
  cpu B: <---run Y--><--run Z--><--run Y--><--run Z--><--run Y ...
  io:               <-- io X -->           <-- io X -->

Case 2:
  cpu A: <--run X--><--run Z---><--run X--><--run Z---><--run X ...
  cpu B: <---run Y---><--idle--><---run Y---><--idle--><--run Y ...
  io:               <-- io X -->           <-- io X -->

So case 1 tend to be iowait while case 2 is idle, despite
almost same workloads. Then what should admins do...?
(How silly! :-p)

>> Back to NO_HZ mechanism. Totally terrible thing here is that
>> observer need to handle duration "delta" without knowing that
>> nr_iowait of sleeping cpu can be changed easily by migration
>> even if cpu is sleeping.
> 
> How about the following: when CPU enters idle, it remembers
> in struct tick_sched->idle_active whether it was "truly" idle
> or I/O bound: something like
> 
> ts->idle_active = nr_iowait_cpu(smp_processor_id()) ? 2 : 1;
> 
> Then, when we exit idle, we account entire idle period as
> "true" idle or as iowait depending on ts->idle_active value,
> regardless of what happened to I/O bound task (whether
> it migrated or not).

It will not be acceptable. CPU can sleep significantly long
time after all I/O bound tasks are migrated. e.g.:

cpu A: <-run X-><-- iowait ---... (few days) ...--><-run Z ..
cpu B: <----run Y------><-run X->..
io:             <-io X->

Since NO_HZ fits well to systems where want to keep CPUs in
sleeping to save battery/power, situation like above is
likely common. You'll see amazing iowait on system in idle,
and also see increasing iowait despite no tasks waiting io...

>> [WHAT THIS PATCH PROPOSED]: fix problem 1 first.
>>
>> To fix problem 1, this patch adds seqlock for NO_HZ idle
>> accounting to avoid possible races between multiple reader/writer.
> 
> That's what Frederic proposed too.
> However, he thought it adds too much overhead. It adds
> a new field, two memory barriers and a RMW cycle
> in the updater (tick_nohz_stop_idle),
> and similarly two memory barriers in readers too.
> 
> How about a slightly different approach.
> We take his first two patches:
> 
> "nohz: Convert a few places to use local per cpu accesses"
> "nohz: Only update sleeptime stats locally"
> 
> then on top of that we fix racy access by readers as follows:
> 
> updater does not need ts->idle_entrytime field
> after it is done. We can reuse it as "updater in progress" flag.
> We set it to a sentinel value (say, zero),
> then increase idle or iowait, then clear ts->idle_active.
> With two memory barriers to ensure other CPUs see
> updates exactly in that order:
> 
> tick_nohz_stop_idle(struct tick_sched *ts, ktime_t now):
> ...
>         /* Updates the per cpu time idle statistics counters */
>         delta = ktime_sub(now, ts->idle_entrytime);
> -       if (nr_iowait_cpu(smp_processor_id()) > 0)
> +       ts->idle_entrytime.tv64 = 0;
> +       smp_wmb();
> +       if (ts->idle_active == 2)
>                 ts->iowait_sleeptime = ktime_add(ts->iowait_sleeptime, delta);
>         else
>                 ts->idle_sleeptime = ktime_add(ts->idle_sleeptime, delta);
> +       smp_wmb();
>         ts->idle_active = 0;
> 

I just noted that "delta might be big, such as days."

> Compared to seqlock approach, we don't need a new field (seqlock counter)
> and don't need to increment it twice (two RMW cycles). We have the same
> number of wmb's as seqlock approach has - two.
> 
> The iowait reader reads these three fields in reverse order,
> with correct read barriers:
> 
> get_cpu_iowait_time_us(int cpu, u64 *last_update_time):
> ...
> + again:
> +       active = ACCESS_ONCE(ts->idle_active);
> +       smp_rmb();
> +       count = ACCESS_ONCE(ts->iowait_sleeptime);
> +       if (active == 2) {   // 2 means "idle was entered with pending I/O"
> +               smp_rmb();
> +               start = ACCESS_ONCE(ts->idle_entrytime);
> ....
> +       }
> +       return count;
> 
> Compared to seqlock approach, we can avoid second rmb (as shown above)
> if we see that idle_active was not set: we know that in this case,
> we already have the result in "count", no need to correct it.
> 
> Now, if idle_active was set (for iowait case, to 2). We can check the
> sentinel in idle_entrytime. If it is there, we are racing with updater.
> in this case, we loop back:
> 
> +       if (active == 2) {
> +               smp_rmb();
> +               start = ACCESS_ONCE(ts->idle_entrytime);
> +               if (start.tv64 == 0)
> +                       /* Other CPU is updating the count.
> +                        * We don't know whether fetched count is valid.
> +                        */
> +                       goto again;
> +               delta = ktime_sub(now, start);
> +               count = ktime_add(count, delta);
>         }
> 
> If we don't see sentinel, we adjust "count" and we are done.
> 
> I will send the full patches shortly.
> 
> Thoughts?

I agree on removing get_cpu_{idle,iowait}_time_us() (or marking
it as obsolete) with some conditions.

However your approach to make "pure reader" is considered to be
a failure. Thank you for providing good counter design!

Thanks,
H.Seto

