Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759432Ab3CHCcR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Mar 2013 21:32:17 -0500
Received: from e23smtp08.au.ibm.com ([202.81.31.141]:58040 "EHLO
	e23smtp08.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759322Ab3CHCcP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Mar 2013 21:32:15 -0500
Message-ID: <51394D9F.70903@linux.vnet.ibm.com>
Date: Fri, 08 Mar 2013 10:31:59 +0800
From: Michael Wang <wangyun@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:16.0) Gecko/20121011 Thunderbird/16.0.1
MIME-Version: 1.0
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
CC: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@kernel.org>,
        Mike Galbraith <efault@gmx.de>, Namhyung Kim <namhyung@kernel.org>,
        Alex Shi <alex.shi@intel.com>, Paul Turner <pjt@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Nikunj A. Dadhania" <nikunj@linux.vnet.ibm.com>,
        Ram Pai <linuxram@us.ibm.com>
Subject: Re: [PATCH] sched: wakeup buddy
References: <5136EB06.2050905@linux.vnet.ibm.com> <1362645372.2606.11.camel@laptop> <51386207.5040808@linux.vnet.ibm.com> <1362675134.10972.21.camel@laptop>
In-Reply-To: <1362675134.10972.21.camel@laptop>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13030802-5140-0000-0000-000002DC4410
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/08/2013 12:52 AM, Peter Zijlstra wrote:
> On Thu, 2013-03-07 at 17:46 +0800, Michael Wang wrote:
> 
>> On 03/07/2013 04:36 PM, Peter Zijlstra wrote:
>>> On Wed, 2013-03-06 at 15:06 +0800, Michael Wang wrote:
>>>
>>>> wake_affine() stuff is trying to bind related tasks closely, but it doesn't
>>>> work well according to the test on 'perf bench sched pipe' (thanks to Peter).
>>>
>>> so sched-pipe is a poor benchmark for this.. 
>>>
>>> Ideally we'd write a new benchmark that has some actual data footprint
>>> and we'd measure the cost of tasks being apart on the various cache
>>> metrics and see what affine wakeup does for it.
>>
>> I think sched-pipe is still somewhat capable, 
> 
> Yeah, its not entirely crap for this, but its not ideal either. The
> very big difference you see between it running on a single cpu and on
> say two threads of a single core is mostly due to preemption
> 'artifacts' though. Not because of cache.
> 
> So we have 2 tasks -- lets call then A and B -- involved in a single
> word ping-pong. So we're both doing write(); read(); loops. Now what
> happens on a single cpu is that A's write()->wakeup() of B makes B
> preempt A before A hits read() and blocks. This in turn ensures that
> B's write()->wakeup() of A finds an already running A and doesn't
> actually need to do the full (and expensive) wakeup thing (and vice
> versa).

Exactly, I used to think that make them running on same cpu only gain
benefit when one is going to sleep, but you are right, in that case,
they get latency and performance at same time, amazing ;-)

One concern in my mind is that this cooperation is somewhat fragile, if
another task C join the fight on that cpu, it will be broken, but if we
have a way to detect that in select_task_rq_fair(), we will be able to
win the gamble.

> 
> So by constantly preempting one another they avoid the expensive bit of
> going to sleep and waking up again.

Amazing point :)

> 
> wake_affine() OTOH still has a (supposed) benefit if it gets the tasks
> running 'closer' (in a cache hierarchy sense) since then the data
> sharing is less expensive.
> 
>> the problem is that the
>> select_idle_sibling() doesn't take care the wakeup related case, it
>> doesn't contain the logical to locate an idle cpu closely.
> 
> I'm not entirely sure if I understand what you mean, do you mean to say
> its idea of 'closely' is not quite correct? If so, I tend to agree, see
> further down.
> 
>> So even we detect the relationship successfully, select_idle_sibling()
>> can only help to make sure the target cpu won't be outside of the
>> current package, it's a package level bind, not mc or smp level.
> 
> That is the entire point of select_idle_sibling(), selecting a cpu
> 'near' the target cpu that is currently idle.
> 
> Not too long ago we had a bit of a discussion on the unholy mess that
> is select_idle_sibling() and if it actually does the right thing.
> Arguably it doesn't for machines that have an effective L2 cache. The 
> issue is that the arch<->sched interface only knows about
> last-level-cache (L3 on anything modern) and SMT.

Yeah, that's the point I concerned, we make sure that the cpu returned
by select_idle_sibling() at least share the L3 cache with target, but
there is a chance to miss the better candidate which share L2 with the
target.

> 
> Expanding the topology description in a way that makes sense (and
> doesn't make it a bigger mess) is somewhere on the todo-list.
> 
>>> Before doing something like what you're proposing, I'd have a hard look
>>> at WF_SYNC, it is possible we should disable/fix select_idle_sibling
>>> for sync wakeups.
>>
>> The patch is supposed to stop using wake_affine() blindly, not improve
>> the wake_affine() stuff itself, the whole stuff still works, but since
>> we rely on select_idle_sibling() to make the choice, the benefit is not
>> so significant, especially on my one node box...
> 
> OK, I'll have to go read the actual patch for that, I'll get back to
> you on that :-)
> 
>>> The idea behind sync wakeups is that we try and detect the case where
>>> we wakeup up one task only to go to sleep ourselves and try and avoid
>>> the regular ping-pong this would otherwise create on account of the
>>> waking task still being alive and so the current cpu isn't actually
>>> idle yet but we know its going to be idle soon.
>>
>> Are you suggesting that we should separate the process of wakeup related
>> case, not just pass current cpu to select_idle_sibling()?
> 
> Depends a bit on what you're trying to fix, so far I'm just trying to
> write down what I remember about stuff and reacting to half-read
> changelogs ;-)

I see, and I get some good point here for me to think deeper, that's
great ;-)

Regards,
Michael Wang

> 

