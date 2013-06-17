Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751678Ab3FQO32 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Jun 2013 10:29:28 -0400
Received: from mga09.intel.com ([134.134.136.24]:53968 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751575Ab3FQO30 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Jun 2013 10:29:26 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,881,1363158000"; 
   d="scan'208";a="354919477"
Message-ID: <51BF1D3E.6050407@intel.com>
Date: Mon, 17 Jun 2013 22:29:18 +0800
From: Alex Shi <alex.shi@intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120912 Thunderbird/15.0.1
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: mingo@redhat.com, tglx@linutronix.de, akpm@linux-foundation.org,
        bp@alien8.de, pjt@google.com, namhyung@kernel.org, efault@gmx.de,
        morten.rasmussen@arm.com, vincent.guittot@linaro.org,
        preeti@linux.vnet.ibm.com, viresh.kumar@linaro.org,
        linux-kernel@vger.kernel.org, mgorman@suse.de, riel@redhat.com,
        wangyun@linux.vnet.ibm.com, Jason Low <jason.low2@hp.com>,
        Changlong Xie <changlongx.xie@intel.com>, sgruszka@redhat.com,
        fweisbec@gmail.com
Subject: Re: [patch v8 8/9] sched: consider runnable load average in move_tasks
References: <1370589652-24549-1-git-send-email-alex.shi@intel.com> <1370589652-24549-9-git-send-email-alex.shi@intel.com> <20130617135909.GY3204@twins.programming.kicks-ass.net>
In-Reply-To: <20130617135909.GY3204@twins.programming.kicks-ass.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/17/2013 09:59 PM, Peter Zijlstra wrote:
>> >  #else
>> >  static inline void update_blocked_averages(int cpu)
> Should we not also change the !FAIR_GROUP_SCHED version of task_h_load()
> for this?

yes, it is needed. Sorry for omit this.
---

>From dc6a4b052c05d793938f6fbf40190d8cec959ca4 Mon Sep 17 00:00:00 2001
From: Alex Shi <alex.shi@intel.com>
Date: Mon, 3 Dec 2012 23:00:53 +0800
Subject: [PATCH 1/2] sched: consider runnable load average in move_tasks

Except using runnable load average in background, move_tasks is also
the key functions in load balance. We need consider the runnable load
average in it in order to the apple to apple load comparison.

Morten had caught a div u64 bug on ARM, thanks!

Signed-off-by: Alex Shi <alex.shi@intel.com>
---
 kernel/sched/fair.c |   18 +++++++++---------
 1 files changed, 9 insertions(+), 9 deletions(-)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index 4b68f9f..0ca9cc3 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -4179,11 +4179,14 @@ static int tg_load_down(struct task_group *tg, void *data)
 	long cpu = (long)data;
 
 	if (!tg->parent) {
-		load = cpu_rq(cpu)->load.weight;
+		load = cpu_rq(cpu)->avg.load_avg_contrib;
 	} else {
+		unsigned long tmp_rla;
+		tmp_rla = tg->parent->cfs_rq[cpu]->runnable_load_avg + 1;
+
 		load = tg->parent->cfs_rq[cpu]->h_load;
-		load *= tg->se[cpu]->load.weight;
-		load /= tg->parent->cfs_rq[cpu]->load.weight + 1;
+		load *= tg->se[cpu]->avg.load_avg_contrib;
+		load /= tmp_rla;
 	}
 
 	tg->cfs_rq[cpu]->h_load = load;
@@ -4209,12 +4212,9 @@ static void update_h_load(long cpu)
 static unsigned long task_h_load(struct task_struct *p)
 {
 	struct cfs_rq *cfs_rq = task_cfs_rq(p);
-	unsigned long load;
-
-	load = p->se.load.weight;
-	load = div_u64(load * cfs_rq->h_load, cfs_rq->load.weight + 1);
 
-	return load;
+	return div64_ul(p->se.avg.load_avg_contrib * cfs_rq->h_load,
+			cfs_rq->runnable_load_avg + 1);
 }
 #else
 static inline void update_blocked_averages(int cpu)
@@ -4227,7 +4227,7 @@ static inline void update_h_load(long cpu)
 
 static unsigned long task_h_load(struct task_struct *p)
 {
-	return p->se.load.weight;
+	return p->se.avg.load_avg_contrib;
 }
 #endif
 
-- 
1.7.5.4

