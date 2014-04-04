Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751943AbaDDCsT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Apr 2014 22:48:19 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:48455 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750891AbaDDCsQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Apr 2014 22:48:16 -0400
X-SecurityPolicyCheck: OK by SHieldMailChecker v1.7.4
Message-ID: <533E1D30.7060503@jp.fujitsu.com>
Date: Fri, 04 Apr 2014 11:47:12 +0900
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
References: <5338CC86.9080602@jp.fujitsu.com> <5338CE0B.1050100@jp.fujitsu.com> <CAK1hOcMmmq=5EVLBrAd44HC+EHrnztABU48gd9BgK+LUNBJSOQ@mail.gmail.com> <533D077D.4080503@jp.fujitsu.com> <CAK1hOcO3tmzK7JnuNGYCeFBk=nEoo5ke0Tr58zi52ccv0CzEvQ@mail.gmail.com>
In-Reply-To: <CAK1hOcO3tmzK7JnuNGYCeFBk=nEoo5ke0Tr58zi52ccv0CzEvQ@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2014/04/03 18:51), Denys Vlasenko wrote:
> On Thu, Apr 3, 2014 at 9:02 AM, Hidetoshi Seto
> <seto.hidetoshi@jp.fujitsu.com> wrote:
>>>> [PROBLEM 2]: broken iowait accounting.
>>>>
>>>> As historical nature, cpu's idle time was accounted as either
>>>> idle or iowait depending on the presence of tasks blocked by
>>>> I/O. No one complain about it for a long time. However:
>>>>
>>>>   > Still trying to wrap my head around it, but conceptually
>>>>   > get_cpu_iowait_time_us() doesn't make any kind of sense.
>>>>   > iowait isn't per cpu since effectively tasks that aren't
>>>>   > running aren't assigned a cpu (as Oleg already pointed out).
>>>>   -- Peter Zijlstra
>>>>
>>>> Now some kernel folks realized that accounting iowait as per-cpu
>>>> does not make sense in SMP world. When we were in traditional
>>>> UP era, cpu is considered to be waiting I/O if it is idle while
>>>> nr_iowait > 0. But in these days with SMP systems, tasks easily
>>>> migrate from a cpu where they issued an I/O to another cpu where
>>>> they are queued after I/O completion.
>>>
>>> However, if we would put ourselves into admin's seat, iowait
>>> immediately starts to make sense: for admin, the system state
>>> where a lot of CPU time is genuinely idle is qualitatively different
>>> form the state where a lot of CPU time is "idle" because
>>> we are I/O bound.
>>>
>>> Admins probably wouldn't insist that iowait accounting must be
>>> very accurate. I would hazard to guess that admins would settle
>>> for the following rules:
>>>
>>> * (idle + iowait) should accurately represent amount of time
>>> CPUs were idle.
>>> * both idle and iowait should never go backwards
>>> * when system is truly idle, only idle should increase
>>> * when system is truly I/O bound on all CPUs, only iowait should increase
>>> * when the situation is in between of the above two cases,
>>> both iowait and idle counters should grow. It's ok if they
>>> represent idle/IO-bound ratio only approximately
>>
>> Yep. Admins are at the mercy of iowait value, though they know it
>> is not accurate.
>>
>> Assume there are task X,Y,Z (X issues io, Y sleeps moderately,
>> and Z has low priority):
>>
>> Case 1:
>>   cpu A: <--run X--><--iowait--><--run X--><--iowait--><--run X ...
>>   cpu B: <---run Y--><--run Z--><--run Y--><--run Z--><--run Y ...
>>   io:               <-- io X -->           <-- io X -->
>>
>> Case 2:
>>   cpu A: <--run X--><--run Z---><--run X--><--run Z---><--run X ...
>>   cpu B: <---run Y---><--idle--><---run Y---><--idle--><--run Y ...
>>   io:               <-- io X -->           <-- io X -->
>>
>> So case 1 tend to be iowait while case 2 is idle, despite
>> almost same workloads. Then what should admins do...?
> 
> This happens with current code too, right?
> No regression then.

Yes, problem 2 is not regression. As I state it at first place,
it is fundamental problem of current iowait stuff. And my patch
set does not aim at this problem 2.

>>>> Back to NO_HZ mechanism. Totally terrible thing here is that
>>>> observer need to handle duration "delta" without knowing that
>>>> nr_iowait of sleeping cpu can be changed easily by migration
>>>> even if cpu is sleeping.
>>>
>>> How about the following: when CPU enters idle, it remembers
>>> in struct tick_sched->idle_active whether it was "truly" idle
>>> or I/O bound: something like
>>>
>>> ts->idle_active = nr_iowait_cpu(smp_processor_id()) ? 2 : 1;
>>>
>>> Then, when we exit idle, we account entire idle period as
>>> "true" idle or as iowait depending on ts->idle_active value,
>>> regardless of what happened to I/O bound task (whether
>>> it migrated or not).
>>
>> It will not be acceptable. CPU can sleep significantly long
>> time after all I/O bound tasks are migrated. e.g.:
>>
>> cpu A: <-run X-><-- iowait ---... (few days) ...--><-run Z ..
>> cpu B: <----run Y------><-run X->..
>> io:             <-io X->
> 
> Does task migrate from an *idle* CPU? If yes, why?
> Since its CPU is idle (i.e. immediately available
> for it to be scheduled on),
> I would imagine normally IO-blocked task stays
> on its CPU's rq if it is idle.

I found an answer from Peter Zijlstra in following threads:
    [PATCH RESEND 0/4] nohz: Fix racy sleeptime stats
    https://lkml.org/lkml/2013/8/16/274

(Sorry, I could not reach lkml.org today due to some network
 error, so I could not get direct link to following reply.
 I hope you can find it from parent post started from link
 above. I quote the important part instead.)

<quote> 
> Option B:
> 
>> Or we can live with that and still account the whole idle time slept until
>> tick_nohz_stop_idle() to iowait if we called tick_nohz_start_idle() with nr_iowait > 0.
>> All we need is just a new field in ts-> that records on which state we entered
>> idle.
>>
>> What do you think?
> 
> I think option B is unworkable. Afaict it could basically caused
> unlimited iowait time. Suppose we have a load-balancer that tries it
> bestestest to sort-left (ie. run a task on the lowest 'free' cpu
> possible) -- the power aware folks are pondering such schemes.
</quote>

Another answer: we cannot stop user to do cpuset (=force migration
by hand) to task which is waiting io.

>> I agree on removing get_cpu_{idle,iowait}_time_us() (or marking
>> it as obsolete) with some conditions.
> 
> Er?
> My proposal does not eliminate or change
> get_cpu_{idle,iowait}_time_us() API.

Sorry to making confuse.
Well, I should revise my previous comment in different proper words.

At first, it was my fault to use "API change" for your proposal.
It does not change number/type of function's argument etc.
I guess I should use "semantics change" for "removing update
functionality".

<source kernel/time/tick-sched.c>
> /**
>  * get_cpu_idle_time_us - get the total idle time of a cpu
>  * @cpu: CPU number to query
>  * @last_update_time: variable to store update time in. Do not update
>  * counters if NULL.
</source>

Second, it was only my opinion to remove these functions.
You did not mention about it.

So revised comment would be:
  - I agree on removing update functionality from
    get_cpu_{idle,iowait}_time_us() if it is acceptable
    semantics change for cpufreq people.
  - By the way, IMHO we can remove these functions
    completely. (Or if required mark it as obsolete for
    a certain period.)
  - Anyway such change could be a single patch separated
    from current patch set.

Thanks,
H.Seto

