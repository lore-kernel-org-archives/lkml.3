Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761434Ab3JPWRR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Oct 2013 18:17:17 -0400
Received: from mail-qc0-f169.google.com ([209.85.216.169]:56172 "EHLO
	mail-qc0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760717Ab3JPWRP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Oct 2013 18:17:15 -0400
MIME-Version: 1.0
In-Reply-To: <20131016220122.GM10651@twins.programming.kicks-ass.net>
References: <20131016181548.22647.17161.stgit@sword-of-the-dawn.mtv.corp.google.com>
 <20131016181627.22647.47543.stgit@sword-of-the-dawn.mtv.corp.google.com> <20131016220122.GM10651@twins.programming.kicks-ass.net>
From: Paul Turner <pjt@google.com>
Date: Wed, 16 Oct 2013 15:16:44 -0700
Message-ID: <CAPM31RKnCkjL1Rf8_0-9ok_ZMi0G2iQtxi0KWnW4rSbsEtbQbw@mail.gmail.com>
Subject: Re: [PATCH 4/5] sched: Guarantee new group-entities always have weight
To: Peter Zijlstra <peterz@infradead.org>
Cc: Ben Segall <bsegall@google.com>, Ingo Molnar <mingo@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 16, 2013 at 3:01 PM, Peter Zijlstra <peterz@infradead.org> wrote:
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
>>               se->cfs_rq = parent->my_q;
>>
>>       se->my_q = cfs_rq;
>> -     update_load_set(&se->load, 0);
>> +     /* guarantee group entities always have weight */
>> +     update_load_set(&se->load, NICE_0_LOAD);
>>       se->parent = parent;
>>  }
>
> Hurm.. this gives new groups a massive weight; nr_cpus * NICE_0. ISTR
> there being some issues with this; or was that on the wakeup path where
> a task woke on a cpu who's group entity had '0' load because it used to
> run on another cpu -- I can't remember.

This could also arbitrarily be MIN_WEIGHT.

I don't think it actually matters, in practice the set of conditions
for this weight to ever see use are very specific (e.g. the race
described above). Otherwise it's always going to be re-initialized (on
first actual enqueue) to the right value.  (NICE_0_LOAD seemed to make
sense since this is what you'd "expect" for a new, single thread,
autogroup/group.)

>
> But please do expand how this isn't a problem. I suppose for the regular
> cgroup case, group creation is a rare event so nobody cares, but
> autogroups can come and go far too quickly I think.
>

This isn't typically a problem since the first enqueue will almost
universally set a weight.

An alternative considered was to remove the throttled-hierarchy check
in the re-weight; however it seemed better to make this actually an
invariant (e.g. an entity ALWAYS has some weight).
