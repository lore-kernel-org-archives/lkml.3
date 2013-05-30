Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967731Ab3E3HDX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 May 2013 03:03:23 -0400
Received: from mga02.intel.com ([134.134.136.20]:55254 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S967695Ab3E3HDL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 May 2013 03:03:11 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,769,1363158000"; 
   d="scan'208";a="345550410"
From: Alex Shi <alex.shi@intel.com>
To: mingo@redhat.com, peterz@infradead.org, tglx@linutronix.de,
        akpm@linux-foundation.org, bp@alien8.de, pjt@google.com,
        namhyung@kernel.org, efault@gmx.de, morten.rasmussen@arm.com
Cc: vincent.guittot@linaro.org, preeti@linux.vnet.ibm.com,
        viresh.kumar@linaro.org, linux-kernel@vger.kernel.org,
        alex.shi@intel.com, mgorman@suse.de, riel@redhat.com,
        wangyun@linux.vnet.ibm.com, Jason Low <jason.low2@hp.com>,
        Changlong Xie <changlongx.xie@intel.com>
Subject: [patch v7 4/8] sched: fix slept time double counting in enqueue entity
Date: Thu, 30 May 2013 15:02:00 +0800
Message-Id: <1369897324-16646-5-git-send-email-alex.shi@intel.com>
X-Mailer: git-send-email 1.7.12
In-Reply-To: <1369897324-16646-1-git-send-email-alex.shi@intel.com>
References: <1369897324-16646-1-git-send-email-alex.shi@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The wakeuped migrated task will __synchronize_entity_decay(se); in
migrate_task_fair, then it needs to set
`se->avg.last_runnable_update -= (-se->avg.decay_count) << 20'
before update_entity_load_avg, in order to avoid slept time is updated
twice for se.avg.load_avg_contrib in both __syncchronize and
update_entity_load_avg.

but if the slept task is waked up from self cpu, it miss the
last_runnable_update before update_entity_load_avg(se, 0, 1), then the
slept time was used twice in both functions.
So we need to remove the double slept time counting.

Signed-off-by: Alex Shi <alex.shi@intel.com>
---
 kernel/sched/fair.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index 1fc30b9..42c7be0 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -1570,7 +1570,8 @@ static inline void enqueue_entity_load_avg(struct cfs_rq *cfs_rq,
 		}
 		wakeup = 0;
 	} else {
-		__synchronize_entity_decay(se);
+		se->avg.last_runnable_update += __synchronize_entity_decay(se)
+							<< 20;
 	}
 
 	/* migrated tasks did not contribute to our blocked load */
-- 
1.7.12

