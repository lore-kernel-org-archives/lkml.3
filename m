Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754478Ab3BXJup (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Feb 2013 04:50:45 -0500
Received: from e28smtp01.in.ibm.com ([122.248.162.1]:37384 "EHLO
	e28smtp01.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750986Ab3BXJun (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Feb 2013 04:50:43 -0500
Message-ID: <5129E223.9020807@linux.vnet.ibm.com>
Date: Sun, 24 Feb 2013 15:19:23 +0530
From: Preeti U Murthy <preeti@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120717 Thunderbird/14.0
MIME-Version: 1.0
To: Alex Shi <alex.shi@intel.com>
CC: Peter Zijlstra <peterz@infradead.org>, torvalds@linux-foundation.org,
        mingo@redhat.com, tglx@linutronix.de, akpm@linux-foundation.org,
        arjan@linux.intel.com, bp@alien8.de, pjt@google.com,
        namhyung@kernel.org, efault@gmx.de, vincent.guittot@linaro.org,
        gregkh@linuxfoundation.org, viresh.kumar@linaro.org,
        linux-kernel@vger.kernel.org, morten.rasmussen@arm.com
Subject: Re: [patch v5 09/15] sched: add power aware scheduling in fork/exec/wake
References: <1361164062-20111-1-git-send-email-alex.shi@intel.com> <1361164062-20111-10-git-send-email-alex.shi@intel.com> <1361353360.10155.9.camel@laptop> <5124BCEB.8030606@intel.com> <1361367371.10155.32.camel@laptop> <5124DC76.2010801@intel.com> <1361453587.26780.18.camel@laptop> <512631C7.8060103@intel.com> <1361523279.26780.45.camel@laptop> <5129DD1A.8070509@intel.com>
In-Reply-To: <5129DD1A.8070509@intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13022409-4790-0000-0000-0000070E88F3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Alex,

On 02/24/2013 02:57 PM, Alex Shi wrote:
> On 02/22/2013 04:54 PM, Peter Zijlstra wrote:
>> On Thu, 2013-02-21 at 22:40 +0800, Alex Shi wrote:
>>>> The name is a secondary issue, first you need to explain why you
>>> think
>>>> nr_running is a useful metric at all.
>>>>
>>>> You can have a high nr_running and a low utilization (a burst of
>>>> wakeups, each waking a process that'll instantly go to sleep again),
>>> or
>>>> low nr_running and high utilization (a single process cpu bound
>>>> process).
>>>
>>> It is true in periodic balance. But in fork/exec/waking timing, the
>>> incoming processes usually need to do something before sleep again.
>>
>> You'd be surprised, there's a fair number of workloads that have
>> negligible runtime on wakeup.
> 
> will appreciate if you like introduce some workload. :)
> BTW, do you has some idea to handle them?
> Actually, if tasks is just like transitory, it is also hard to catch
> them in balance, like 'cyclitest -t 100' on my 4 LCPU laptop, vmstat
> just can catch 1 or 2 tasks very second.
>>
>>> I use nr_running to measure how the group busy, due to 3 reasons:
>>> 1, the current performance policy doesn't use utilization too.
>>
>> We were planning to fix that now that its available.
> 
> I had tried, but failed on aim9 benchmark. As a result I give up to use
> utilization in performance balance.
> Some trying and talking in the thread.
> https://lkml.org/lkml/2013/1/6/96
> https://lkml.org/lkml/2013/1/22/662
>>
>>> 2, the power policy don't care load weight.
>>
>> Then its broken, it should very much still care about weight.
> 
> Here power policy just use nr_running as the criteria to check if it's
> eligible for power aware balance. when do balancing the load weight is
> still the key judgment.
> 
>>
>>> 3, I tested some benchmarks, kbuild/tbench/hackbench/aim7 etc, some
>>> benchmark results looks clear bad when use utilization. if my memory
>>> right, the hackbench/aim7 both looks bad. I had tried many ways to
>>> engage utilization into this balance, like use utilization only, or
>>> use
>>> utilization * nr_running etc. but still can not find a way to recover
>>> the lose. But with nr_running, the performance seems doesn't lose much
>>> with power policy.
>>
>> You're failing to explain why utilization performs bad and you don't
>> explain why nr_running is better. That things work simply isn't good
> 
> Um, let me try to explain again, The utilisation need much time to
> accumulate itself(345ms). Whenever with or without load weight, many
> bursting tasks just give a minimum weight to the carrier CPU at the
> first few ms. So, it is too easy to do a incorrect distribution here and
> need migration on later periodic balancing.

I dont understand why forked tasks are taking time to accumulate the
load.I understand this if it were to be a woken up task.The first time
the forked task gets a chance to update the load itself,it needs to
reflect full utilization.In __update_entity_runnable_avg both
runnable_avg_period and runnable_avg_sum get equally incremented for a
forked task since it is runnable.Hence where is the chance for the load
to get incremented in steps?

In sleeping tasks since runnable_avg_sum progresses much slower than
runnable_avg_period,these tasks take much time to accumulate the load
when they wake up.This makes sense of course.But how does this happen
for forked tasks?

Regards
Preeti U Murthy

