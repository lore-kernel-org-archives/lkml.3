Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752713Ab3EFFkv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 May 2013 01:40:51 -0400
Received: from mga03.intel.com ([143.182.124.21]:4356 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752438Ab3EFFku (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 May 2013 01:40:50 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,619,1363158000"; 
   d="scan'208";a="298097608"
Message-ID: <51874229.8050202@intel.com>
Date: Mon, 06 May 2013 13:39:53 +0800
From: Alex Shi <alex.shi@intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130329 Thunderbird/17.0.5
MIME-Version: 1.0
To: Michael Wang <wangyun@linux.vnet.ibm.com>
CC: mingo@redhat.com, peterz@infradead.org, tglx@linutronix.de,
        akpm@linux-foundation.org, bp@alien8.de, pjt@google.com,
        namhyung@kernel.org, efault@gmx.de, morten.rasmussen@arm.com,
        vincent.guittot@linaro.org, preeti@linux.vnet.ibm.com,
        viresh.kumar@linaro.org, linux-kernel@vger.kernel.org, mgorman@suse.de,
        riel@redhat.com
Subject: Re: [PATCH v5 7/7] sched: consider runnable load average in effective_load
References: <1367804711-30308-1-git-send-email-alex.shi@intel.com> <1367804711-30308-8-git-send-email-alex.shi@intel.com> <518724D1.9040006@linux.vnet.ibm.com>
In-Reply-To: <518724D1.9040006@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/06/2013 11:34 AM, Michael Wang wrote:
>> > @@ -3045,7 +3045,7 @@ static long effective_load(struct task_group *tg, int cpu, long wl, long wg)
>> >  		/*
>> >  		 * w = rw_i + @wl
>> >  		 */
>> > -		w = se->my_q->load.weight + wl;
>> > +		w = se->my_q->tg_load_contrib + wl;
> I've tested the patch set, seems like the last patch caused big
> regression on pgbench:
> 
> 			base	patch 1~6	patch 1~7
> | db_size | clients |  tps  |   |  tps  |	|  tps  |
> +---------+---------+-------+	+-------+	+-------+
> | 22 MB   |      32 | 43420 |	| 53387 |	| 41625 |
> 
> I guess some magic thing happened in effective_load() while calculating
> group decay combined with load decay, what's your opinion?


thanks for testing, Michael!

Maybe 2 fix worth to try.

1, change back the tg_weight in calc_tg_weight() to use tg_load_contrib not direct load.

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index 6f4f14b..c770f8d 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -1037,8 +1037,8 @@ static inline long calc_tg_weight(struct task_group *tg, struct cfs_rq *cfs_rq)
 	 * update_cfs_rq_load_contribution().
 	 */
 	tg_weight = atomic64_read(&tg->load_avg);
-	tg_weight -= cfs_rq->tg_load_contrib;
-	tg_weight += cfs_rq->load.weight;
+	//tg_weight -= cfs_rq->tg_load_contrib;
+	//tg_weight += cfs_rq->load.weight;
 
 	return tg_weight;
 }

2, another try is follow the current calc_tg_weight, so remove the follow change.

>> > @@ -3045,7 +3045,7 @@ static long effective_load(struct task_group *tg, int cpu, long wl, long wg)
>> >  		/*
>> >  		 * w = rw_i + @wl
>> >  		 */
>> > -		w = se->my_q->load.weight + wl;
>> > +		w = se->my_q->tg_load_contrib + wl;

Would you like to try them?


-- 
Thanks
    Alex
