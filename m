Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967742Ab3E3HDd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 May 2013 03:03:33 -0400
Received: from mga02.intel.com ([134.134.136.20]:60718 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S967667Ab3E3HDZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 May 2013 03:03:25 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,769,1363158000"; 
   d="scan'208";a="345550532"
From: Alex Shi <alex.shi@intel.com>
To: mingo@redhat.com, peterz@infradead.org, tglx@linutronix.de,
        akpm@linux-foundation.org, bp@alien8.de, pjt@google.com,
        namhyung@kernel.org, efault@gmx.de, morten.rasmussen@arm.com
Cc: vincent.guittot@linaro.org, preeti@linux.vnet.ibm.com,
        viresh.kumar@linaro.org, linux-kernel@vger.kernel.org,
        alex.shi@intel.com, mgorman@suse.de, riel@redhat.com,
        wangyun@linux.vnet.ibm.com, Jason Low <jason.low2@hp.com>,
        Changlong Xie <changlongx.xie@intel.com>
Subject: [patch v7 8/8] sched: remove blocked_load_avg in tg
Date: Thu, 30 May 2013 15:02:04 +0800
Message-Id: <1369897324-16646-9-git-send-email-alex.shi@intel.com>
X-Mailer: git-send-email 1.7.12
In-Reply-To: <1369897324-16646-1-git-send-email-alex.shi@intel.com>
References: <1369897324-16646-1-git-send-email-alex.shi@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

blocked_load_avg sometime is too heavy and far bigger than runnable load
avg, that make balance make wrong decision. So remove it.

Changlong tested this patch, found ltp cgroup stress testing get better
performance: https://lkml.org/lkml/2013/5/23/65
---
3.10-rc1          patch1-7         patch1-8
duration=764   duration=754   duration=750
duration=764   duration=754   duration=751
duration=763   duration=755   duration=751

duration means the seconds of testing cost.
---

And Jason also tested this patchset on his 8 sockets machine:
https://lkml.org/lkml/2013/5/29/673
---
When using a 3.10-rc2 tip kernel with patches 1-8, there was about a 40%
improvement in performance of the workload compared to when using the
vanilla 3.10-rc2 tip kernel with no patches. When using a 3.10-rc2 tip
kernel with just patches 1-7, the performance improvement of the
workload over the vanilla 3.10-rc2 tip kernel was about 25%.
---

Signed-off-by: Alex Shi <alex.shi@intel.com>
Tested-by: Changlong Xie <changlongx.xie@intel.com>
Tested-by: Jason Low <jason.low2@hp.com>
---
 kernel/sched/fair.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index bb2470a..163d9ce 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -1358,7 +1358,7 @@ static inline void __update_cfs_rq_tg_load_contrib(struct cfs_rq *cfs_rq,
 	struct task_group *tg = cfs_rq->tg;
 	s64 tg_contrib;
 
-	tg_contrib = cfs_rq->runnable_load_avg + cfs_rq->blocked_load_avg;
+	tg_contrib = cfs_rq->runnable_load_avg;
 	tg_contrib -= cfs_rq->tg_load_contrib;
 
 	if (force_update || abs64(tg_contrib) > cfs_rq->tg_load_contrib / 8) {
-- 
1.7.12

