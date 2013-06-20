Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935630Ab3FTCVD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Jun 2013 22:21:03 -0400
Received: from mga03.intel.com ([143.182.124.21]:6154 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935556Ab3FTCVB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Jun 2013 22:21:01 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,901,1363158000"; 
   d="scan'208";a="319759473"
From: Alex Shi <alex.shi@intel.com>
To: mingo@redhat.com, peterz@infradead.org, tglx@linutronix.de,
        akpm@linux-foundation.org, arjan@linux.intel.com, bp@alien8.de,
        pjt@google.com, namhyung@kernel.org, efault@gmx.de,
        morten.rasmussen@arm.com
Cc: vincent.guittot@linaro.org, gregkh@linuxfoundation.org,
        preeti@linux.vnet.ibm.com, viresh.kumar@linaro.org,
        linux-kernel@vger.kernel.org, alex.shi@intel.com, len.brown@intel.com,
        rafael.j.wysocki@intel.com, jkosina@suse.cz, clark.williams@gmail.com,
        tony.luck@intel.com, keescook@chromium.org, mgorman@suse.de,
        riel@redhat.com
Subject: [Resend patch v8 04/13] sched: fix slept time double counting in enqueue entity
Date: Thu, 20 Jun 2013 10:18:48 +0800
Message-Id: <1371694737-29336-5-git-send-email-alex.shi@intel.com>
X-Mailer: git-send-email 1.7.12
In-Reply-To: <1371694737-29336-1-git-send-email-alex.shi@intel.com>
References: <1371694737-29336-1-git-send-email-alex.shi@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The wakeuped migrated task will __synchronize_entity_decay(se); in
migrate_task_rq_fair, then it needs to set
`se->avg.last_runnable_update -= (-se->avg.decay_count) << 20'
before update_entity_load_avg, in order to avoid slept time is updated
twice for se.avg.load_avg_contrib in both __syncchronize and
update_entity_load_avg.

but if the slept task is waked up from self cpu, it miss the
last_runnable_update before update_entity_load_avg(se, 0, 1), then the
slept time was used twice in both functions.
So we need to remove the double slept time counting.

Paul also contribute some code comments in this commit.

Signed-off-by: Alex Shi <alex.shi@intel.com>
Reviewed-by: Paul Turner <pjt@google.com>
---
 kernel/sched/fair.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index df5b8a9..1e5a5e6 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -1571,7 +1571,13 @@ static inline void enqueue_entity_load_avg(struct cfs_rq *cfs_rq,
 		}
 		wakeup = 0;
 	} else {
-		__synchronize_entity_decay(se);
+		/*
+		 * Task re-woke on same cpu (or else migrate_task_rq_fair()
+		 * would have made count negative); we must be careful to avoid
+		 * double-accounting blocked time after synchronizing decays.
+		 */
+		se->avg.last_runnable_update += __synchronize_entity_decay(se)
+							<< 20;
 	}
 
 	/* migrated tasks did not contribute to our blocked load */
-- 
1.7.12

