Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761949Ab3JPWkz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Oct 2013 18:40:55 -0400
Received: from mail-pb0-f51.google.com ([209.85.160.51]:53394 "EHLO
	mail-pb0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756143Ab3JPWky (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Oct 2013 18:40:54 -0400
From: bsegall@google.com
To: Peter Zijlstra <peterz@infradead.org>
Cc: mingo@redhat.com, pjt@google.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4/5] sched: Guarantee new group-entities always have weight
References: <20131016181548.22647.17161.stgit@sword-of-the-dawn.mtv.corp.google.com>
	<20131016181627.22647.47543.stgit@sword-of-the-dawn.mtv.corp.google.com>
	<20131016220122.GM10651@twins.programming.kicks-ass.net>
Date: Wed, 16 Oct 2013 15:40:52 -0700
In-Reply-To: <20131016220122.GM10651@twins.programming.kicks-ass.net> (Peter
	Zijlstra's message of "Thu, 17 Oct 2013 00:01:22 +0200")
Message-ID: <xm261u3kzvnv.fsf@sword-of-the-dawn.mtv.corp.google.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Peter Zijlstra <peterz@infradead.org> writes:

> On Wed, Oct 16, 2013 at 11:16:27AM -0700, Ben Segall wrote:
>> From: Paul Turner <pjt@google.com>
>> 
>> Currently, group entity load-weights are initialized to zero. This
>> admits some races with respect to the first time they are re-weighted in
>> earlty use. ( Let g[x] denote the se for "g" on cpu "x". )
>> 
>> Suppose that we have root->a and that a enters a throttled state,
>> immediately followed by a[0]->t1 (the only task running on cpu[0])
>> blocking:
>> 
>> put_prev_task(group_cfs_rq(a[0]), t1)
>> put_prev_entity(..., t1)
>> check_cfs_rq_runtime(group_cfs_rq(a[0]))
>> throttle_cfs_rq(group_cfs_rq(a[0]))
>> 
>> Then, before unthrottling occurs, let a[0]->b[0]->t2 wake for the first
>> time:
>> 
>> enqueue_task_fair(rq[0], t2)
>> enqueue_entity(group_cfs_rq(b[0]), t2)
>> enqueue_entity_load_avg(group_cfs_rq(b[0]), t2)
>> account_entity_enqueue(group_cfs_ra(b[0]), t2)
>> update_cfs_shares(group_cfs_rq(b[0]))
>> < skipped because b is part of a throttled hierarchy >
>> enqueue_entity(group_cfs_rq(a[0]), b[0])
>> ...
>> 
>> We now have b[0] enqueued, yet group_cfs_rq(a[0])->load.weight == 0
>> which violates invariants in several code-paths. Eliminate the
>> possibility of this by initializing group entity weight.
>> 
>> Signed-off-by: Paul Turner <pjt@google.com>
>> ---
>>  kernel/sched/fair.c |    3 ++-
>>  1 file changed, 2 insertions(+), 1 deletion(-)
>> 
>> diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
>> index fc44cc3..424c294 100644
>> --- a/kernel/sched/fair.c
>> +++ b/kernel/sched/fair.c
>> @@ -7207,7 +7207,8 @@ void init_tg_cfs_entry(struct task_group *tg, struct cfs_rq *cfs_rq,
>>  		se->cfs_rq = parent->my_q;
>>  
>>  	se->my_q = cfs_rq;
>> -	update_load_set(&se->load, 0);
>> +	/* guarantee group entities always have weight */
>> +	update_load_set(&se->load, NICE_0_LOAD);
>>  	se->parent = parent;
>>  }
>
> Hurm.. this gives new groups a massive weight; nr_cpus * NICE_0. ISTR
> there being some issues with this; or was that on the wakeup path where
> a task woke on a cpu who's group entity had '0' load because it used to
> run on another cpu -- I can't remember.
>
> But please do expand how this isn't a problem. I suppose for the regular
> cgroup case, group creation is a rare event so nobody cares, but
> autogroups can come and go far too quickly I think.

I wouldn't expect this to be a problem in the common case because the
first enqueue onto one of the new group's tg->cfs_rq[cpu] will
cause an update_cfs_shares(tg->cfs_rq[cpu]), which will correct it (and
this is before the new group gets to enqueue_entity(... tg->se[cpu], ...) or
anything, so placement shouldn't be an issue). I don't think anything
cares about the weights of a !on_rq se, so it shouldn't be an issue
until enqueue.

Now, that said, in the racing case Paul wrote up, the update_cfs_shares
could get skipped, and unthrottle wouldn't fix the weight either, so
you'd wind up with the wrong weight until another enqueue/dequeue or
tick with it as current happened. I suppose this could be fixed by doing
an update_cfs_shares on unthrottle (or just removing the restriction on
update_cfs_shares, if it seems to be more trouble than it's worth).

It's possible the old walk_tg_tree based and ratelimited computation of
h_load might have had issues, but the new code looks safe since it won't
ratelimit, and in order to do an h_load computation you'll need a task
in the group, and that requires enqueue_entity->update_cfs_shares.
