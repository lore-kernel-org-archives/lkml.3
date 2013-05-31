Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755389Ab3EaPH5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 May 2013 11:07:57 -0400
Received: from mga14.intel.com ([143.182.124.37]:64142 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751289Ab3EaPHv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 May 2013 11:07:51 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,779,1363158000"; 
   d="scan'208";a="249130232"
Message-ID: <51A8BCB9.2060902@intel.com>
Date: Fri, 31 May 2013 23:07:37 +0800
From: Alex Shi <alex.shi@intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120912 Thunderbird/15.0.1
MIME-Version: 1.0
To: Morten Rasmussen <morten.rasmussen@arm.com>
CC: "mingo@redhat.com" <mingo@redhat.com>,
        "peterz@infradead.org" <peterz@infradead.org>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "bp@alien8.de" <bp@alien8.de>, "pjt@google.com" <pjt@google.com>,
        "namhyung@kernel.org" <namhyung@kernel.org>,
        "efault@gmx.de" <efault@gmx.de>,
        "vincent.guittot@linaro.org" <vincent.guittot@linaro.org>,
        "preeti@linux.vnet.ibm.com" <preeti@linux.vnet.ibm.com>,
        "viresh.kumar@linaro.org" <viresh.kumar@linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "mgorman@suse.de" <mgorman@suse.de>,
        "riel@redhat.com" <riel@redhat.com>,
        "wangyun@linux.vnet.ibm.com" <wangyun@linux.vnet.ibm.com>,
        Jason Low <jason.low2@hp.com>,
        Changlong Xie <changlongx.xie@intel.com>
Subject: Re: [patch v7 7/8] sched: consider runnable load average in move_tasks
References: <1369897324-16646-1-git-send-email-alex.shi@intel.com> <1369897324-16646-8-git-send-email-alex.shi@intel.com> <20130531101940.GC32728@e103034-lin>
In-Reply-To: <20130531101940.GC32728@e103034-lin>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> 
> runnable_load_avg is u64, so you need to use div_u64() similar to how it
> is already done in task_h_load() further down in this patch. It doesn't
> build on ARM as is.
> 
> Fix:
> -               load /= tg->parent->cfs_rq[cpu]->runnable_load_avg + 1;
> +               load = div_u64(load,
> 				tg->parent->cfs_rq[cpu]->runnable_load_avg + 1);
> 
> Morten

Thank a lot for review!

div_u64 or do_div will do force cast u32 on the divisor, so in 64bit machine, 
the divisor may become incorrect.
Since cfs_rq->runnable_load_avg is always smaller the cfs_rq.load.weight. and 
load.weight is 'unsigned long', we can cast the runnable_load_avg to 
'unsigned long' too. Than the div will fit on both 64/32 bit machine and no 
data concatenate!

So the patch changed as following.

BTW, Paul & Peter:
in cfs_rq, runnable_load_avg, blocked_load_avg, tg_load_contrib are all
u64, but their are similar with 'unsigned long' load.weight. So could we change
them to 'unsigned long'?

---

>From 4a17564363f6d65c9d513ad206b54ebd032d3f46 Mon Sep 17 00:00:00 2001
From: Alex Shi <alex.shi@intel.com>
Date: Mon, 3 Dec 2012 23:00:53 +0800
Subject: [PATCH 7/8] sched: consider runnable load average in move_tasks

Except using runnable load average in background, move_tasks is also
the key functions in load balance. We need consider the runnable load
average in it in order to the apple to apple load comparison.

Morten catch a div u64 bug on ARM, thanks!

Signed-off-by: Alex Shi <alex.shi@intel.com>
---
 kernel/sched/fair.c |   17 ++++++++++-------
 1 files changed, 10 insertions(+), 7 deletions(-)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index eadd2e7..73e4507 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -4178,11 +4178,14 @@ static int tg_load_down(struct task_group *tg, void *data)
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
@@ -4208,12 +4211,12 @@ static void update_h_load(long cpu)
 static unsigned long task_h_load(struct task_struct *p)
 {
 	struct cfs_rq *cfs_rq = task_cfs_rq(p);
-	unsigned long load;
+	unsigned long load, tmp_rla;
 
-	load = p->se.load.weight;
-	load = div_u64(load * cfs_rq->h_load, cfs_rq->load.weight + 1);
+	load = p->se.avg.load_avg_contrib * cfs_rq->h_load;
+	tmp_rla = cfs_rq->runnable_load_avg + 1;
 
-	return load;
+	return load / tmp_rla;
 }
 #else
 static inline void update_blocked_averages(int cpu)
-- 
1.7.5.4

