Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753805AbaAWQrZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jan 2014 11:47:25 -0500
Received: from terminus.zytor.com ([198.137.202.10]:55084 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753731AbaAWQrV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jan 2014 11:47:21 -0500
Date: Thu, 23 Jan 2014 08:46:23 -0800
From: tip-bot for Vincent Guittot <tipbot@zytor.com>
Message-ID: <tip-9390675af0835ae1d654d33bfcf16096028550ad@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, bsegall@google.com, hpa@zytor.com,
        mingo@kernel.org, peterz@infradead.org, vincent.guittot@linaro.org,
        tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, bsegall@google.com,
        linux-kernel@vger.kernel.org, peterz@infradead.org,
        vincent.guittot@linaro.org, tglx@linutronix.de
In-Reply-To: <1390376734-6800-1-git-send-email-vincent.guittot@linaro.org>
References: <1390376734-6800-1-git-send-email-vincent.guittot@linaro.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/urgent] Revert "sched:
  Fix sleep time double accounting in enqueue entity"
Git-Commit-ID: 9390675af0835ae1d654d33bfcf16096028550ad
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.1 (terminus.zytor.com [127.0.0.1]); Thu, 23 Jan 2014 08:46:29 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  9390675af0835ae1d654d33bfcf16096028550ad
Gitweb:     http://git.kernel.org/tip/9390675af0835ae1d654d33bfcf16096028550ad
Author:     Vincent Guittot <vincent.guittot@linaro.org>
AuthorDate: Wed, 22 Jan 2014 08:45:34 +0100
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Thu, 23 Jan 2014 14:48:34 +0100

Revert "sched: Fix sleep time double accounting in enqueue entity"

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
---
 kernel/sched/fair.c | 8 +-------
 1 file changed, 1 insertion(+), 7 deletions(-)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index b24b6cf..efe6457 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -2356,13 +2356,7 @@ static inline void enqueue_entity_load_avg(struct cfs_rq *cfs_rq,
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
