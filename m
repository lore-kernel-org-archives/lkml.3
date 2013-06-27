Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753572Ab3F0JCb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Jun 2013 05:02:31 -0400
Received: from terminus.zytor.com ([198.137.202.10]:46023 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752051Ab3F0JC1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Jun 2013 05:02:27 -0400
Date: Thu, 27 Jun 2013 02:01:57 -0700
From: tip-bot for Alex Shi <tipbot@zytor.com>
Message-ID: <tip-282cf499f03ec1754b6c8c945c9674b02631fb0f@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        peterz@infradead.org, pjt@google.com, alex.shi@intel.com,
        tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        pjt@google.com, peterz@infradead.org, tglx@linutronix.de,
        alex.shi@intel.com
In-Reply-To: <1371694737-29336-5-git-send-email-alex.shi@intel.com>
References: <1371694737-29336-5-git-send-email-alex.shi@intel.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/core] sched:
  Fix sleep time double accounting in enqueue entity
Git-Commit-ID: 282cf499f03ec1754b6c8c945c9674b02631fb0f
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Thu, 27 Jun 2013 02:02:03 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  282cf499f03ec1754b6c8c945c9674b02631fb0f
Gitweb:     http://git.kernel.org/tip/282cf499f03ec1754b6c8c945c9674b02631fb0f
Author:     Alex Shi <alex.shi@intel.com>
AuthorDate: Thu, 20 Jun 2013 10:18:48 +0800
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Thu, 27 Jun 2013 10:07:32 +0200

sched: Fix sleep time double accounting in enqueue entity

The woken migrated task will __synchronize_entity_decay(se); in
migrate_task_rq_fair, then it needs to set
`se->avg.last_runnable_update -= (-se->avg.decay_count) << 20' before
update_entity_load_avg, in order to avoid sleep time is updated twice
for se.avg.load_avg_contrib in both __syncchronize and
update_entity_load_avg.

However if the sleeping task is woken up from the same cpu, it miss
the last_runnable_update before update_entity_load_avg(se, 0, 1), then
the sleep time was used twice in both functions.  So we need to remove
the double sleep time accounting.

Paul also contributed some code comments in this commit.

Signed-off-by: Alex Shi <alex.shi@intel.com>
Reviewed-by: Paul Turner <pjt@google.com>
Signed-off-by: Peter Zijlstra <peterz@infradead.org>
Link: http://lkml.kernel.org/r/1371694737-29336-5-git-send-email-alex.shi@intel.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 kernel/sched/fair.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index e1602a0..9bbc303 100644
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
