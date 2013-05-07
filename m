Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756973Ab3EGFSL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 May 2013 01:18:11 -0400
Received: from mga03.intel.com ([143.182.124.21]:15663 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752590Ab3EGFSJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 May 2013 01:18:09 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,625,1363158000"; 
   d="scan'208";a="237860892"
Message-ID: <51888E87.2090506@intel.com>
Date: Tue, 07 May 2013 13:17:59 +0800
From: Alex Shi <alex.shi@intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130329 Thunderbird/17.0.5
MIME-Version: 1.0
To: Paul Turner <pjt@google.com>
CC: Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Borislav Petkov <bp@alien8.de>, Namhyung Kim <namhyung@kernel.org>,
        Mike Galbraith <efault@gmx.de>,
        Morten Rasmussen <morten.rasmussen@arm.com>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        Preeti U Murthy <preeti@linux.vnet.ibm.com>,
        Viresh Kumar <viresh.kumar@linaro.org>,
        LKML <linux-kernel@vger.kernel.org>, Mel Gorman <mgorman@suse.de>,
        Rik van Riel <riel@redhat.com>,
        Michael Wang <wangyun@linux.vnet.ibm.com>
Subject: Re: [PATCH v5 6/7] sched: consider runnable load average in move_tasks
References: <1367804711-30308-1-git-send-email-alex.shi@intel.com> <1367804711-30308-7-git-send-email-alex.shi@intel.com> <CAPM31RK71tBPdnXzLmr1o6nmFhbhU9+b_DqX9zNSbDc4EhC8FQ@mail.gmail.com> <20130506150428.GD15446@dyad.programming.kicks-ass.net> <CAPM31RKqMGAvFh1JmUjCjBo4EJWqA39i8=YPiUw8GUkG9dj7Fw@mail.gmail.com>
In-Reply-To: <CAPM31RKqMGAvFh1JmUjCjBo4EJWqA39i8=YPiUw8GUkG9dj7Fw@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/07/2013 04:59 AM, Paul Turner wrote:
>>> Similarly, I think you also want to at least include blocked_load_avg here.
>> >
>> > I'm puzzled, this is an entity weight. Entity's don't have blocked_load_avg.
>> >
>> > The purpose here is to compute the amount of weight that's being moved by this
>> > task; to subtract from the imbalance.
> Sorry, what I meant to say here is:
> If we're going to be using a runnable average based load here the
> fraction we take (currently instantaneous) in tg_load_down should be
> consistent.

yes. I think so.

So, here is the patch, could you like take a look?
---

>From 8a98af9578154ce5d755b2c6ea7da0109cd6efa8 Mon Sep 17 00:00:00 2001
From: Alex Shi <alex.shi@intel.com>
Date: Mon, 3 Dec 2012 23:00:53 +0800
Subject: [PATCH 6/7] sched: consider runnable load average in move_tasks

Except using runnable load average in background, move_tasks is also
the key functions in load balance. We need consider the runnable load
average in it in order to the apple to apple load comparison.

Signed-off-by: Alex Shi <alex.shi@intel.com>
---
 kernel/sched/fair.c | 12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index 407ef61..ca0e051 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -4121,11 +4121,12 @@ static int tg_load_down(struct task_group *tg, void *data)
 	long cpu = (long)data;
 
 	if (!tg->parent) {
-		load = cpu_rq(cpu)->load.weight;
+		load = cpu_rq(cpu)->avg.load_avg_contrib;
 	} else {
 		load = tg->parent->cfs_rq[cpu]->h_load;
-		load *= tg->se[cpu]->load.weight;
-		load /= tg->parent->cfs_rq[cpu]->load.weight + 1;
+		load *= tg->se[cpu]->avg.load_avg_contrib;
+		load /= tg->parent->cfs_rq[cpu]->runnable_load_avg
+			+ tg->parent->cfs_rq[cpu]->blocked_load_avg + 1;
 	}
 
 	tg->cfs_rq[cpu]->h_load = load;
@@ -4153,8 +4154,9 @@ static unsigned long task_h_load(struct task_struct *p)
 	struct cfs_rq *cfs_rq = task_cfs_rq(p);
 	unsigned long load;
 
-	load = p->se.load.weight;
-	load = div_u64(load * cfs_rq->h_load, cfs_rq->load.weight + 1);
+	load = p->se.avg.load_avg_contrib;
+	load = div_u64(load * cfs_rq->h_load,
+		cfs_rq->runnable_load_avg + cfs_rq->blocked_load_avg + 1);
 
 	return load;
 }
-- 
1.7.12

-- 
Thanks
    Alex
