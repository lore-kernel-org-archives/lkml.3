Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755901AbaAVQZ2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jan 2014 11:25:28 -0500
Received: from g1t0029.austin.hp.com ([15.216.28.36]:45227 "EHLO
	g1t0029.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751379AbaAVQZ1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jan 2014 11:25:27 -0500
Message-ID: <52DFF0DC.3050303@hp.com>
Date: Wed, 22 Jan 2014 11:25:00 -0500
From: Waiman Long <waiman.long@hp.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.12) Gecko/20130109 Thunderbird/10.0.12
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: Ingo Molnar <mingo@redhat.com>, linux-kernel@vger.kernel.org,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Serge Hallyn <serge.hallyn@canonical.com>,
        Aswin Chandramouleeswaran <aswin@hp.com>,
        Scott J Norton <scott.norton@hp.com>, Paul Turner <pjt@google.com>,
        Ben Segall <bsegall@google.com>
Subject: Re: [PATCH v2] sched: reduce contention on tg's load_avg & runnable_avg
References: <1389838956-56574-1-git-send-email-Waiman.Long@hp.com> <20140116124457.GR31570@twins.programming.kicks-ass.net>
In-Reply-To: <20140116124457.GR31570@twins.programming.kicks-ass.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/16/2014 07:44 AM, Peter Zijlstra wrote:
> First of.. WTF is v1?
>
> Secondly, please always CC the authors of the code you're changing.

The v1 patch was sent quite a while ago on 9/21/2013. See 
https://lkml.org/lkml/2013/9/23/551

There was no feedback at that time. As this was not a high priority 
patch for me, I didn't follow up at that time. I will include the change 
log in the next version.

> On Wed, Jan 15, 2014 at 09:22:36PM -0500, Waiman Long wrote:
>> It was found that with a perf profile of a compute workload (at 1500
>> users) of the AIM7 benchmark running on a glueless 4-socket 40-core
>> Westmere-EX system (HT on) on a 3.13-rc8 kernel that the scheduling
>> tick related functions account for quite a significant portion of
>> the total kernel cpu cycles.
>>
>>    0.62%  reaim  [kernel.kallsyms]  [k] update_cfs_rq_blocked_load
>>    0.47%  reaim  [kernel.kallsyms]  [k] entity_tick
>>    0.10%  reaim  [kernel.kallsyms]  [k] update_cfs_shares
>>    0.03%  reaim  [kernel.kallsyms]  [k] update_curr
>>
>> The scheduling tick functions account for about 1.22% of the total
>> CPU cycles. Of the top 2 function in the above list, the reading
>> and writing of the tg->load_avg variable account for over 90% of the
>> CPU cycles:
>>
>>    atomic_long_add(tg_contrib,&tg->load_avg);
>>    atomic_long_read(&tg->load_avg) + 1);
>>
>> This patch reduces the contention on the load_avg variable (and
>> secondarily on the runnable_avg variable) by the following 2 measures:
>>
>> 1. Make the load_avg and runnable_avg fields of the task_group
>>     structure sit in their own cacheline without sharing it with others.
>>     This only applies if the kernel is built for NUMA systems with
>>     multiple sockets.
> So why not for SMP?

The cache coherency traffic is generally not a problem for single-socket 
multi-core system, that is why I currently increase the data structure 
size only for kernel built for multi-socket systems. Of course, I can 
also enable it for SMP system in general.

> Also, what's the difference between having both of them in the same
> cacheline as opposed to a cacheline each?
> They're both touched from the same tick, so it makes sense to have them
> in one cacheline. Now you get to move two lines into exclusive state,
> instead of just the one.

Below is the performance data for different cacheline placements:

    Cacheline Placement | %CPU  |  JPM   |
   ---------------------+-------+--------+
   2 separate cachelines| 0.55% | 405803 |
   1 common cacheline   | 1.01% | 403462 |
   2nd change only      | 1.06% | 403820 |
   Original code        | 1.22% | 398509 |

It seems like forcing the 2 fields to be in the same cacheline actually 
make it perform a little bit worse. It is likely that the 2 fields just 
happen to be in 2 different cachelines in x86.

>> 2. Use atomic_long_add_return() to update the fields and save the
>>     returned value in a temporary location in the cfs structure to
>>     be used later instead of reading the fields directly.
> Then why aren't this two patches?

I will break it into 2 patches.

> Furthermore, I completely hate the way you implemented this; the stuff
> like in the first hunk below makes the entire code flow horrid. Its
> already difficult code, using conditional variables makes it even worse.

I can try to encapsulate the change in macros to not disrupt the current 
flow.

> Who's to say your 'cached' value is recent? You didn't put in a call
> chain analysis to show you always first pass through the add_return()
> before using the cached value.

Will provide a more detailed call chain analysis to show when and how 
the cache value is used.

>> The second change does require some changes in the ordering of how
>> some of the average counts are being computed and hence may have a
>> slight effect on their behavior.
> Might have is no good, either you work through it and make damn sure its
> solid or you walk.

I will do a more detailed analysis and provide that in the change log.

> Preserved the rest for the added Cc's.
>

Will do.

-Longman

