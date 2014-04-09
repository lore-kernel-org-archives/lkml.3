Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934022AbaDIQLm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Apr 2014 12:11:42 -0400
Received: from mail-we0-f175.google.com ([74.125.82.175]:40268 "EHLO
	mail-we0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933858AbaDIQLi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Apr 2014 12:11:38 -0400
From: Frederic Weisbecker <fweisbec@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Ingo Molnar <mingo@kernel.org>, Oleg Nesterov <oleg@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>
Subject: [PATCH 5/5] sched: Convert tasks iteration to use for_each_process_thread()
Date: Wed,  9 Apr 2014 18:11:22 +0200
Message-Id: <1397059882-23063-6-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1397059882-23063-1-git-send-email-fweisbec@gmail.com>
References: <1397059882-23063-1-git-send-email-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

do_each_thread/while_each_thread iterators are deprecated by
for_each_thread/for_each_process_thread() APIs.

Lets convert the callers in the sched subsystem. The ultimate
goal is to remove the struct task_struct::thread_group field and
the corresponding do_each_thread/while_each_thread iterators that are
RCU unsafe.

Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
---
 kernel/sched/core.c | 13 ++++++-------
 1 file changed, 6 insertions(+), 7 deletions(-)

diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index 0ff3f34..82df639 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -4389,7 +4389,7 @@ void show_state_filter(unsigned long state_filter)
 		"  task                        PC stack   pid father\n");
 #endif
 	rcu_read_lock();
-	do_each_thread(g, p) {
+	for_each_process_thread(g, p) {
 		/*
 		 * reset the NMI-timeout, listing all files on a slow
 		 * console might take a lot of time:
@@ -4397,8 +4397,7 @@ void show_state_filter(unsigned long state_filter)
 		touch_nmi_watchdog();
 		if (!state_filter || (p->state & state_filter))
 			sched_show_task(p);
-	} while_each_thread(g, p);
-
+	}
 	touch_all_softlockup_watchdogs();
 
 #ifdef CONFIG_SCHED_DEBUG
@@ -6997,7 +6996,7 @@ void normalize_rt_tasks(void)
 	struct rq *rq;
 
 	read_lock_irqsave(&tasklist_lock, flags);
-	do_each_thread(g, p) {
+	for_each_process_thread(g, p) {
 		/*
 		 * Only normalize user tasks:
 		 */
@@ -7028,7 +7027,7 @@ void normalize_rt_tasks(void)
 
 		__task_rq_unlock(rq);
 		raw_spin_unlock(&p->pi_lock);
-	} while_each_thread(g, p);
+	}
 
 	read_unlock_irqrestore(&tasklist_lock, flags);
 }
@@ -7217,10 +7216,10 @@ static inline int tg_has_rt_tasks(struct task_group *tg)
 {
 	struct task_struct *g, *p;
 
-	do_each_thread(g, p) {
+	for_each_process_thread(g, p) {
 		if (rt_task(p) && task_rq(p)->rt.tg == tg)
 			return 1;
-	} while_each_thread(g, p);
+	}
 
 	return 0;
 }
-- 
1.8.3.1

