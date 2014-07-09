Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932068AbaGILlf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2014 07:41:35 -0400
Received: from e9.ny.us.ibm.com ([32.97.182.139]:43955 "EHLO e9.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756077AbaGILlc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2014 07:41:32 -0400
Message-ID: <53BD2A60.3060106@linux.vnet.ibm.com>
Date: Wed, 09 Jul 2014 17:11:20 +0530
From: Preeti U Murthy <preeti@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>,
        Vincent Guittot <vincent.guittot@linaro.org>
CC: Rik van Riel <riel@redhat.com>, Ingo Molnar <mingo@kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        LAK <linux-arm-kernel@lists.infradead.org>,
        Morten Rasmussen <Morten.Rasmussen@arm.com>,
        Mike Galbraith <efault@gmx.de>,
        Nicolas Pitre <nicolas.pitre@linaro.org>,
        "linaro-kernel@lists.linaro.org" <linaro-kernel@lists.linaro.org>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Dietmar Eggemann <dietmar.eggemann@arm.com>
Subject: Re: [PATCH v3 01/12] sched: fix imbalance flag reset
References: <1404144343-18720-1-git-send-email-vincent.guittot@linaro.org> <1404144343-18720-2-git-send-email-vincent.guittot@linaro.org> <53BB61E9.80200@linux.vnet.ibm.com> <CAKfTPtA8BVPtRRLzomqnGp7_uaSbFYmFTrrt4fpQTOb7qyjddg@mail.gmail.com> <53BCBD0E.2070609@linux.vnet.ibm.com> <20140709104332.GS19379@twins.programming.kicks-ass.net>
In-Reply-To: <20140709104332.GS19379@twins.programming.kicks-ass.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14070911-7182-0000-0000-00000B145DAC
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/09/2014 04:13 PM, Peter Zijlstra wrote:
> On Wed, Jul 09, 2014 at 09:24:54AM +0530, Preeti U Murthy wrote:
>> In the example that I mention above, t1 and t2 are on the rq of cpu0;
>> while t1 is running on cpu0, t2 is on the rq but does not have cpu1 in
>> its cpus allowed mask. So during load balance, cpu1 tries to pull t2,
>> cannot do so, and hence LBF_ALL_PINNED flag is set and it jumps to
>> out_balanced. Note that there are only two sched groups at this level of
>> sched domain.one with cpu0 and the other with cpu1. In this scenario we
>> do not try to do active load balancing, atleast thats what the code does
>> now if LBF_ALL_PINNED flag is set.
> 
> I think Vince is right in saying that in this scenario ALL_PINNED won't
> be set. move_tasks() will iterate cfs_rq::cfs_tasks, that list will also
> include the current running task.

Hmm.. really? Because while dequeueing a task from the rq so as to
schedule it on a cpu, we delete its entry from the list of cfs_tasks on
the rq.

list_del_init(&se->group_node) in account_entity_dequeue() does that.

> 
> And can_migrate_task() only checks for current after the pinning bits.
> 
>> Continuing with the above explanation; when LBF_ALL_PINNED flag is
>> set,and we jump to out_balanced, we clear the imbalance flag for the
>> sched_group comprising of cpu0 and cpu1,although there is actually an
>> imbalance. t2 could still be migrated to say cpu2/cpu3 (t2 has them in
>> its cpus allowed mask) in another sched group when load balancing is
>> done at the next sched domain level.
> 
> And this is where Vince is wrong; note how
> update_sg_lb_stats()/sg_imbalance() uses group->sgc->imbalance, but
> load_balance() sets: sd_parent->groups->sgc->imbalance, so explicitly
> one level up.

One level up? The group->sgc->imbalance flag is checked during
update_sg_lb_stats(). This flag is *set during the load balancing at a
lower level sched domain*.IOW, when the 'group' formed the sched domain.

> 
> So what we can do I suppose is clear 'group->sgc->imbalance' at
> out_balanced.

You mean 'set'? If we clear it we will have no clue about imbalances at
lower level sched domains due to pinning. Specifically in LBF_ALL_PINNED
case. This might prevent us from balancing out these tasks to other
groups at a higher level domain. update_sd_pick_busiest() specifically
relies on this flag to choose the busiest group.

> 
> In any case, the entirely of this group imbalance crap is just that,
> crap. Its a terribly difficult situation and the current bits more or
> less fudge around some of the common cases. Also see the comment near
> sg_imbalanced(). Its not a solid and 'correct' anything. Its a bunch of
> hacks trying to deal with hard cases.
> 
> A 'good' solution would be prohibitively expensive I fear.

So the problem that Vincent is trying to bring to the fore with this
patchset is that, when the busy group has cpus with only 1 running task
but imbalance flag set due to affinity constraints, we unnecessarily try
to do active balancing on this group. Active load balancing will not
succeed when there is only one task. To solve this issue will a simple
check on (busiest->nr_running > 1) in addition to !(ld_moved) before
doing active load balancing not work?


Thanks

Regards
Preeti U Murthy




> 

