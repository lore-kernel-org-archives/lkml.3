Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935841Ab3BTETt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Feb 2013 23:19:49 -0500
Received: from e28smtp04.in.ibm.com ([122.248.162.4]:45710 "EHLO
	e28smtp04.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933954Ab3BTETs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Feb 2013 23:19:48 -0500
Message-ID: <51244E9D.6050709@linux.vnet.ibm.com>
Date: Wed, 20 Feb 2013 09:48:37 +0530
From: Preeti U Murthy <preeti@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120717 Thunderbird/14.0
MIME-Version: 1.0
To: Paul Turner <pjt@google.com>
CC: Alex Shi <alex.shi@intel.com>, Peter Zijlstra <peterz@infradead.org>,
        torvalds@linux-foundation.org, mingo@redhat.com, tglx@linutronix.de,
        akpm@linux-foundation.org, arjan@linux.intel.com, bp@alien8.de,
        namhyung@kernel.org, efault@gmx.de, vincent.guittot@linaro.org,
        gregkh@linuxfoundation.org, viresh.kumar@linaro.org,
        linux-kernel@vger.kernel.org
Subject: Re: [patch v4 07/18] sched: set initial load avg of new forked task
References: <1358996820-23036-1-git-send-email-alex.shi@intel.com> <1358996820-23036-8-git-send-email-alex.shi@intel.com> <1360664784.4485.17.camel@laptop> <511BADE3.4050009@intel.com> <CAPM31RJw7a-+QNRwwukg3h3bHCQs++cnT3DgCyHaJTZY7qDsXA@mail.gmail.com> <511CE1AB.5020503@intel.com> <CAPM31RKf6Gint-fPxfuFkXxxbpJfkk=5=5v3W0uxvTnnvOoM-A@mail.gmail.com>
In-Reply-To: <CAPM31RKf6Gint-fPxfuFkXxxbpJfkk=5=5v3W0uxvTnnvOoM-A@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13022004-5564-0000-0000-000006ACFD87
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi everyone,

On 02/19/2013 05:04 PM, Paul Turner wrote:
> On Fri, Feb 15, 2013 at 2:07 AM, Alex Shi <alex.shi@intel.com> wrote:
>>
>>> diff --git a/kernel/sched/core.c b/kernel/sched/core.c
>>> index 1dff78a..9d1c193 100644
>>> --- a/kernel/sched/core.c
>>> +++ b/kernel/sched/core.c
>>> @@ -1557,8 +1557,8 @@ static void __sched_fork(struct task_struct *p)
>>>   * load-balance).
>>>   */
>>>  #if defined(CONFIG_SMP) && defined(CONFIG_FAIR_GROUP_SCHED)
>>> -       p->se.avg.runnable_avg_period = 0;
>>> -       p->se.avg.runnable_avg_sum = 0;
>>> +       p->se.avg.runnable_avg_period = 1024;
>>> +       p->se.avg.runnable_avg_sum = 1024;
>>
>> It can't work.
>> avg.decay_count needs to be set to 0 before enqueue_entity_load_avg(), then
>> update_entity_load_avg() can't be called, so, runnable_avg_period/sum
>> are unusable.
> 
> Well we _could_ also use a negative decay_count here and treat it like
> a migration; but the larger problem is the visibility of p->on_rq;
> which is gates whether we account the time as runnable and occurs
> after activate_task() so that's out.
> 
>>
>> Even we has chance to call __update_entity_runnable_avg(),
>> avg.last_runnable_update needs be set before that, usually, it needs to
>> be set as 'now', that cause __update_entity_runnable_avg() function
>> return 0, then update_entity_load_avg() still can not reach to
>> __update_entity_load_avg_contrib().
>>
>> If we embed a simple new task load initialization to many functions,
>> that is too hard for future reader.
> 
> This is my concern about making this a special case with the
> introduction ENQUEUE_NEWTASK flag; enqueue jumps through enough hoops
> as it is.
> 
> I still don't see why we can't resolve this at init time in
> __sched_fork(); your patch above just moves an explicit initialization
> of load_avg_contrib into the enqueue path.  Adding a call to
> __update_task_entity_contrib() to the previous alternate suggestion
> would similarly seem to resolve this?

We could do this(Adding a call to __update_task_entity_contrib()),but the
cfs_rq->runnable_load_avg gets updated only if the task is on the runqueue.
But in the forked task's case the on_rq flag is not yet set.Something like
the below:

---
 kernel/sched/fair.c |   18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index 8691b0d..841e156 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -1451,14 +1451,20 @@ static inline void update_entity_load_avg(struct sched_entity *se,
 	else
 		now = cfs_rq_clock_task(group_cfs_rq(se));
 
-	if (!__update_entity_runnable_avg(now, &se->avg, se->on_rq))
-		return;
-
+	if (!__update_entity_runnable_avg(now, &se->avg, se->on_rq)) {
+		if (!(flags & ENQUEUE_NEWTASK))
+			return;
+	}
 	contrib_delta = __update_entity_load_avg_contrib(se);
 
 	if (!update_cfs_rq)
 		return;
 
+	/* But the cfs_rq->runnable_load_avg does not get updated in case of
+	 * a forked task,because the se->on_rq = 0,although we update the
+	 * task's load_avg_contrib above in
+	 * __update_entity_laod_avg_contrib().
+	 */
 	if (se->on_rq)
 		cfs_rq->runnable_load_avg += contrib_delta;
 	else
@@ -1538,12 +1544,6 @@ static inline void enqueue_entity_load_avg(struct cfs_rq *cfs_rq,
 		subtract_blocked_load_contrib(cfs_rq, se->avg.load_avg_contrib);
 		update_entity_load_avg(se, 0);
 	}
-	/*
-	 * set the initial load avg of new task same as its load
-	 * in order to avoid brust fork make few cpu too heavier
-	 */
-	if (flags & ENQUEUE_NEWTASK)
-		se->avg.load_avg_contrib = se->load.weight;
 
 	cfs_rq->runnable_load_avg += se->avg.load_avg_contrib;
 	/* we force update consideration on load-balancer moves */

Thanks

Regards
Preeti U Murthy

