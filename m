Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756560AbaIPAG6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Sep 2014 20:06:58 -0400
Received: from service87.mimecast.com ([91.220.42.44]:50675 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755005AbaIPAG5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Sep 2014 20:06:57 -0400
From: Morten Rasmussen <morten.rasmussen@arm.com>
To: peterz@infradead.org, mingo@kernel.org
Cc: linux-kernel@vger.kernel.org, Morten Rasmussen <morten.rasmussen@arm.com>,
        Paul Turner <pjt@google.com>, Ben Segall <bsegall@google.com>
Subject: [PATCH] sched: Update task group load contributions during active load-balancing
Date: Tue, 16 Sep 2014 01:07:10 +0100
Message-Id: <1410826030-26301-1-git-send-email-morten.rasmussen@arm.com>
X-Mailer: git-send-email 1.7.9.5
X-OriginalArrivalTime: 16 Sep 2014 00:06:51.0918 (UTC) FILETIME=[1E0BF2E0:01CFD142]
X-MC-Unique: 114091601065301501
Content-Type: text/plain; charset=WINDOWS-1252
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from quoted-printable to 8bit by mail.home.local id s8G073Y9023806

Task group load-contributions are not updated when tasks belonging to
task groups are migrated by active load-balancing. If no other task
belonging to the same task group is already queued at the destination
cpu the group sched_entity will be enqueued with load_avg_contrib=0.
Hence, weighted_cpuload() won't reflect the newly added load.

The load may remain invisible until the next tick, when the sched_entity
load_avg_contrib and task group contributions are reevaluated.

The enqueue loop

	for_each_entity(se) {
	   enqueue_entity(cfs_rq,se)
	      ...
	      enqueue_entity_load_avg(cfs_rq,se)
	         ...
	         update_entity_load_avg(se)
		    ...
		    __update_entity_load_avg_contrib(se)
		    ...
		 ...
	         update_cfs_rq_blocked_load(cfs_rq)
		    ...
		    __update_cfs_rq_tg_load_contrib(cfs_rq)
		    ...
	}

currently skips __update_entity_load_avg_contrib() and
__update_cfs_rq_tg_load_contrib() for group entities for active
load-balance migrations. The former updates the sched_entity
load_avg_contrib, and the latter updates the task group contribution
which is needed by the former. They must both be called to ensure that
load doesn't temporarily disappear.

cc: Paul Turner <pjt@google.com>
cc: Ben Segall <bsegall@google.com>

Signed-off-by: Morten Rasmussen <morten.rasmussen@arm.com>
---
 kernel/sched/fair.c |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index be9e97b..2b6e2eb 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -2521,7 +2521,8 @@ static inline void update_entity_load_avg(struct sched_entity *se,
 	else
 		now = cfs_rq_clock_task(group_cfs_rq(se));
 
-	if (!__update_entity_runnable_avg(now, &se->avg, se->on_rq))
+	if (!__update_entity_runnable_avg(now, &se->avg, se->on_rq) &&
+							entity_is_task(se))
 		return;
 
 	contrib_delta = __update_entity_load_avg_contrib(se);
@@ -2609,6 +2610,10 @@ static inline void enqueue_entity_load_avg(struct cfs_rq *cfs_rq,
 	cfs_rq->runnable_load_avg += se->avg.load_avg_contrib;
 	/* we force update consideration on load-balancer moves */
 	update_cfs_rq_blocked_load(cfs_rq, !wakeup);
+
+	/* We force update group contributions on load-balancer moves */
+	if (wakeup && !entity_is_task(se))
+		__update_cfs_rq_tg_load_contrib(cfs_rq, 0);
 }
 
 /*
-- 
1.7.9.5


