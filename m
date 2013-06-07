Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753111Ab3FGHWH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Jun 2013 03:22:07 -0400
Received: from mga03.intel.com ([143.182.124.21]:10416 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752576Ab3FGHWE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Jun 2013 03:22:04 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,820,1363158000"; 
   d="scan'208";a="251855766"
From: Alex Shi <alex.shi@intel.com>
To: mingo@redhat.com, peterz@infradead.org, tglx@linutronix.de,
        akpm@linux-foundation.org, bp@alien8.de, pjt@google.com,
        namhyung@kernel.org, efault@gmx.de, morten.rasmussen@arm.com
Cc: vincent.guittot@linaro.org, preeti@linux.vnet.ibm.com,
        viresh.kumar@linaro.org, linux-kernel@vger.kernel.org,
        alex.shi@intel.com, mgorman@suse.de, riel@redhat.com,
        wangyun@linux.vnet.ibm.com, Jason Low <jason.low2@hp.com>,
        Changlong Xie <changlongx.xie@intel.com>, sgruszka@redhat.com,
        fweisbec@gmail.com
Subject: [patch v8 4/9] sched: fix slept time double counting in enqueue entity
Date: Fri,  7 Jun 2013 15:20:47 +0800
Message-Id: <1370589652-24549-5-git-send-email-alex.shi@intel.com>
X-Mailer: git-send-email 1.7.12
In-Reply-To: <1370589652-24549-1-git-send-email-alex.shi@intel.com>
References: <1370589652-24549-1-git-send-email-alex.shi@intel.com>
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

