Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755163Ab3AZBtS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2013 20:49:18 -0500
Received: from mga09.intel.com ([134.134.136.24]:41584 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754636Ab3AZBtB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2013 20:49:01 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,542,1355126400"; 
   d="scan'208";a="276820841"
From: Alex Shi <alex.shi@intel.com>
To: mingo@redhat.com, peterz@infradead.org, tglx@linutronix.de,
        akpm@linux-foundation.org, arjan@linux.intel.com, bp@alien8.de,
        pjt@google.com, namhyung@kernel.org, efault@gmx.de
Cc: vincent.guittot@linaro.org, gregkh@linuxfoundation.org,
        preeti@linux.vnet.ibm.com, viresh.kumar@linaro.org,
        linux-kernel@vger.kernel.org, alex.shi@intel.com
Subject: [RFC patch v2 1/7] sched: give initial value for runnable avg of sched entities.
Date: Sat, 26 Jan 2013 09:49:18 +0800
Message-Id: <1359164964-29052-2-git-send-email-alex.shi@intel.com>
X-Mailer: git-send-email 1.7.12
In-Reply-To: <1359164964-29052-1-git-send-email-alex.shi@intel.com>
References: <1359164964-29052-1-git-send-email-alex.shi@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We need initialize the se.avg.{decay_count, load_avg_contrib} to zero
after a new task forked.
Otherwise random values of above variables cause mess when do new task
enqueue:
    enqueue_task_fair
        enqueue_entity
            enqueue_entity_load_avg

Signed-off-by: Alex Shi <alex.shi@intel.com>
---
 kernel/sched/core.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index 257002c..66c1718 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -1558,6 +1558,8 @@ static void __sched_fork(struct task_struct *p)
 #if defined(CONFIG_SMP) && defined(CONFIG_FAIR_GROUP_SCHED)
 	p->se.avg.runnable_avg_period = 0;
 	p->se.avg.runnable_avg_sum = 0;
+	p->se.avg.decay_count = 0;
+	p->se.avg.load_avg_contrib = 0;
 #endif
 #ifdef CONFIG_SCHEDSTATS
 	memset(&p->se.statistics, 0, sizeof(p->se.statistics));
-- 
1.7.12

