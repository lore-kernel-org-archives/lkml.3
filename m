Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752345Ab3EFIeX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 May 2013 04:34:23 -0400
Received: from e28smtp01.in.ibm.com ([122.248.162.1]:49704 "EHLO
	e28smtp01.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752133Ab3EFIeV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 May 2013 04:34:21 -0400
Message-ID: <51876AFE.80906@linux.vnet.ibm.com>
Date: Mon, 06 May 2013 16:34:06 +0800
From: Michael Wang <wangyun@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:16.0) Gecko/20121011 Thunderbird/16.0.1
MIME-Version: 1.0
To: Alex Shi <alex.shi@intel.com>
CC: pjt@google.com, mingo@redhat.com, peterz@infradead.org, tglx@linutronix.de,
        akpm@linux-foundation.org, bp@alien8.de, namhyung@kernel.org,
        efault@gmx.de, morten.rasmussen@arm.com, vincent.guittot@linaro.org,
        preeti@linux.vnet.ibm.com, viresh.kumar@linaro.org,
        linux-kernel@vger.kernel.org, mgorman@suse.de, riel@redhat.com
Subject: Re: [PATCH v5 7/7] sched: consider runnable load average in effective_load
References: <1367804711-30308-1-git-send-email-alex.shi@intel.com> <1367804711-30308-8-git-send-email-alex.shi@intel.com> <518724D1.9040006@linux.vnet.ibm.com> <51874229.8050202@intel.com> <5187609C.5050209@linux.vnet.ibm.com> <518763B0.30200@intel.com>
In-Reply-To: <518763B0.30200@intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13050608-4790-0000-0000-0000082CDF71
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/06/2013 04:02 PM, Alex Shi wrote:
> On 05/06/2013 03:49 PM, Michael Wang wrote:
>> On 05/06/2013 01:39 PM, Alex Shi wrote:
>> [snip]
>>
>> Rough test done:
>>
>>>
>>> 1, change back the tg_weight in calc_tg_weight() to use tg_load_contrib not direct load.
>>
>> This way stop the regression of patch 7.
>>
>>>
>>> diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
>>> index 6f4f14b..c770f8d 100644
>>> --- a/kernel/sched/fair.c
>>> +++ b/kernel/sched/fair.c
>>> @@ -1037,8 +1037,8 @@ static inline long calc_tg_weight(struct task_group *tg, struct cfs_rq *cfs_rq)
>>>  	 * update_cfs_rq_load_contribution().
>>>  	 */
>>>  	tg_weight = atomic64_read(&tg->load_avg);
>>> -	tg_weight -= cfs_rq->tg_load_contrib;
>>> -	tg_weight += cfs_rq->load.weight;
>>> +	//tg_weight -= cfs_rq->tg_load_contrib;
>>> +	//tg_weight += cfs_rq->load.weight;
>>>
>>>  	return tg_weight;
>>>  }
>>>
>>> 2, another try is follow the current calc_tg_weight, so remove the follow change.
>>
>> This way show even better results than only patch 1~6.
> 
> how much better to the first change?

Nevermind, it's just a rough test, consider them as same...

>>
>> But the way Preeti suggested doesn't works...
> 
> What's the Preeti suggestion? :)

Paste at last.

>>
>> May be we should record some explanation about this change here, do we?
> 
> I don't know why we need this, PJT, would you like to tell us why the
> calc_tg_weight use cfs_rq->load.weight not cfs_rq->tg_load_contrib?

The comment said this is more accurate, but that was for the world
without decay load I suppose...

But if it using 'cfs_rq->load.weight', which means denominator M contain
that factor, than numerator w has to contain it also...

Regards,
Michael Wang

> 
> 
>>
>> Regards,
>> Michael Wang
>>

sched: Modify effective_load() to use runnable load average

From: Preeti U Murthy <preeti@linux.vnet.ibm.com>

The runqueue weight distribution should update the runnable load average of
the cfs_rq on which the task will be woken up.

However since the computation of se->load.weight takes into consideration
the runnable load average in update_cfs_shares(),no need to modify this in
effective_load().
---
 kernel/sched/fair.c |    9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index 790e23d..5489022 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -3045,7 +3045,7 @@ static long effective_load(struct task_group *tg,
int cpu, long wl, long wg)
 		/*
 		 * w = rw_i + @wl
 		 */
-		w = se->my_q->load.weight + wl;
+		w = se->my_q->runnable_load_avg + wl;

 		/*
 		 * wl = S * s'_i; see (2)
@@ -3066,6 +3066,9 @@ static long effective_load(struct task_group *tg,
int cpu, long wl, long wg)
 		/*
 		 * wl = dw_i = S * (s'_i - s_i); see (3)
 		 */
+		/* Do not modify the below as it already contains runnable
+		 * load average in its computation
+		 */
 		wl -= se->load.weight;

 		/*
@@ -3112,14 +3115,14 @@ static int wake_affine(struct sched_domain *sd,
struct task_struct *p, int sync)
 	 */
 	if (sync) {
 		tg = task_group(current);
-		weight = current->se.load.weight;
+		weight = current->se.avg.load_avg_contrib;

 		this_load += effective_load(tg, this_cpu, -weight, -weight);
 		load += effective_load(tg, prev_cpu, 0, -weight);
 	}

 	tg = task_group(p);
-	weight = p->se.load.weight;
+	weight = p->se.avg.load_avg_contrib;

 	/*
 	 * In low-load situations, where prev_cpu is idle and this_cpu is idle


Regards
Preeti U Murthy




