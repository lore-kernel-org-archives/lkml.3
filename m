Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755466AbaF3LzR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2014 07:55:17 -0400
Received: from ip4-83-240-18-248.cust.nbox.cz ([83.240.18.248]:52076 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753955AbaF3Lx0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2014 07:53:26 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Vincent Guittot <vincent.guittot@linaro.org>,
        Peter Zijlstra <peterz@infradead.org>, pjt@google.com,
        alex.shi@linaro.org, Ingo Molnar <mingo@kernel.org>,
        Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 001/181] Revert "sched: Fix sleep time double accounting in enqueue entity"
Date: Mon, 30 Jun 2014 13:50:22 +0200
Message-Id: <61844d8e25eb8899b0836afa9796fa239db80f1f.1404128997.git.jslaby@suse.cz>
X-Mailer: git-send-email 2.0.0
In-Reply-To: <cover.1404128997.git.jslaby@suse.cz>
References: <cover.1404128997.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Vincent Guittot <vincent.guittot@linaro.org>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

commit 9390675af0835ae1d654d33bfcf16096028550ad upstream.

This reverts commit 282cf499f03ec1754b6c8c945c9674b02631fb0f.

With the current implementation, the load average statistics of a sched entity
change according to other activity on the CPU even if this activity is done
between the running window of the sched entity and have no influence on the
running duration of the task.

When a task wakes up on the same CPU, we currently update last_runnable_update
with the return  of __synchronize_entity_decay without updating the
runnable_avg_sum and runnable_avg_period accordingly. In fact, we have to sync
the load_contrib of the se with the rq's blocked_load_contrib before removing
it from the latter (with __synchronize_entity_decay) but we must keep
last_runnable_update unchanged for updating runnable_avg_sum/period during the
next update_entity_load_avg.

Signed-off-by: Vincent Guittot <vincent.guittot@linaro.org>
Signed-off-by: Peter Zijlstra <peterz@infradead.org>
Reviewed-by: Ben Segall <bsegall@google.com>
Cc: pjt@google.com
Cc: alex.shi@linaro.org
Link: http://lkml.kernel.org/r/1390376734-6800-1-git-send-email-vincent.guittot@linaro.org
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 kernel/sched/fair.c | 8 +-------
 1 file changed, 1 insertion(+), 7 deletions(-)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index 790e2fc808da..25658d2c68d0 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -1579,13 +1579,7 @@ static inline void enqueue_entity_load_avg(struct cfs_rq *cfs_rq,
 		}
 		wakeup = 0;
 	} else {
-		/*
-		 * Task re-woke on same cpu (or else migrate_task_rq_fair()
-		 * would have made count negative); we must be careful to avoid
-		 * double-accounting blocked time after synchronizing decays.
-		 */
-		se->avg.last_runnable_update += __synchronize_entity_decay(se)
-							<< 20;
+		__synchronize_entity_decay(se);
 	}
 
 	/* migrated tasks did not contribute to our blocked load */
-- 
2.0.0

