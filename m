Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754731AbaFWVF3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jun 2014 17:05:29 -0400
Received: from mail-pa0-f46.google.com ([209.85.220.46]:64945 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754483AbaFWVFX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jun 2014 17:05:23 -0400
From: bsegall@google.com
To: tkhai@yandex.ru
Cc: Peter Zijlstra <peterz@infradead.org>, Kirill Tkhai <ktkhai@parallels.com>,
        linux-kernel@vger.kernel.org, Ingo Molnar <mingo@kernel.org>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Mike Galbraith <umgwanakikbuti@gmail.com>,
        Konstantin Khorenko <khorenko@parallels.com>, pjt@google.com
Subject: Re: [PATCH 1/3] sched/fair: Disable runtime_enabled on dying rq
References: <20140617130442.29933.54945.stgit@tkhai>
	<1403011450.27674.44.camel@tkhai>
	<20140623100724.GU19860@laptop.programming.kicks-ass.net>
	<xm2661jr1qmw.fsf@sword-of-the-dawn.mtv.corp.google.com>
	<53A892E6.7040905@yandex.ru>
Date: Mon, 23 Jun 2014 14:05:15 -0700
In-Reply-To: <53A892E6.7040905@yandex.ru> (Kirill Tkhai's message of "Tue, 24
	Jun 2014 00:49:42 +0400")
Message-ID: <xm261tuf1gms.fsf@sword-of-the-dawn.mtv.corp.google.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Kirill Tkhai <tkhai@yandex.ru> writes:

> On 23.06.2014 21:29, bsegall@google.com wrote:
>> Peter Zijlstra <peterz@infradead.org> writes:
>> 
>>> On Tue, Jun 17, 2014 at 05:24:10PM +0400, Kirill Tkhai wrote:
>>>> @@ -3790,6 +3803,12 @@ static void __maybe_unused unthrottle_offline_cfs_rqs(struct rq *rq)
>>>>  		cfs_rq->runtime_remaining = 1;
>>>>  		if (cfs_rq_throttled(cfs_rq))
>>>>  			unthrottle_cfs_rq(cfs_rq);
>>>> +
>>>> +		/*
>>>> +		 * Offline rq is schedulable till cpu is completely disabled
>>>> +		 * in take_cpu_down(), so we prevent new cfs throttling here.
>>>> +		 */
>>>> +		cfs_rq->runtime_enabled = 0;
>>>
>>> Does it make sense to clear this before calling unthrottle_cfs_rq()?
>>> Just to make sure they're in the right order..
>> 
>> I believe that order is irrelevant here - I do not believe that
>> unthrottle_cfs_rq(a) can cause a throttle_cfs_rq(a). In fact, I don't
>> see any code that will check it at all from unthrottle, although I might
>> be missing something. It _can_ cause a throttle_cfs_rq(parent_cfs_rq(a)),
>> but that should be fine as long as for_each_leaf_cfs_rq is sorted
>> correctly.
>
> I think this is correct. We may change the order just for the hope, that
> anybody will work on it in some way in the future, and this person could
> skip this opaque place. Ok, I don't know how is better :)
>
>> That said, migrate_tasks drops rq->lock, and I /think/ another cpu could
>> wake another task onto this cpu, which could then enqueue_throttle its
>> cfs_rq (which previously had no tasks and thus wasn't on
>> leaf_cfs_rq_list). You certainly could have tg_set_bandwidth come in and
>> turn runtime_enabled on.
>
> We mask cpu inactive on CPU_DOWN_PREPARE stage (in sched_cpu_inactive).
> Other cpu is not able to wake a task there after that.
>
> rq is masked offline in cpuset_cpu_inactive() (during the same stage).
> But priority of sched_cpu_inactive() is higher than priority of
> cpuset_cpu_inactive().
>
>         CPU_PRI_SCHED_INACTIVE  = INT_MIN + 1,
>         CPU_PRI_CPUSET_INACTIVE = INT_MIN,
>
> This guarantees that nobody could use dying_cpu even before we start
> unthrottling. Another cpu will see dying_cpu is inactive.
>
> So, it looks like we are free of this problem.

Ah, ok, I haven't looked that hard at hotplug, and wasn't sure of the
ordering there. We still have the tg_set_cfs_bandwidth issue, because
that uses for_each_possible_cpu. However, with the addition of
rq_online_fair, that can probably be changed to for_each_active_cpu, and
then I think we would be fine.
