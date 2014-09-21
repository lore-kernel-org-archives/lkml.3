Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752598AbaIUTgl (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Sep 2014 15:36:41 -0400
Received: from mx1.redhat.com ([209.132.183.28]:56825 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752222AbaIUTgi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Sep 2014 15:36:38 -0400
Date: Sun, 21 Sep 2014 21:33:38 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>
Cc: Kirill Tkhai <tkhai@yandex.ru>, Mike Galbraith <umgwanakikbuti@gmail.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 2/3] sched: normalize_rt_tasks: don't use _irqsave for
	tasklist_lock, use task_rq_lock()
Message-ID: <20140921193338.GA28621@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140921193316.GA28596@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

1. read_lock(tasklist_lock) does not need to disable irqs.

2. ->mm != NULL is the common mistake, use PF_KTHREAD.

3. The second ->mm check can be simply removed.

4. task_rq_lock() looks better than raw_spin_lock(&p->pi_lock) +
   __task_rq_lock().

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
---
 kernel/sched/core.c |   16 ++++++----------
 1 files changed, 6 insertions(+), 10 deletions(-)

diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index 8a6506f..eee12b3 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -7137,12 +7137,12 @@ void normalize_rt_tasks(void)
 	unsigned long flags;
 	struct rq *rq;
 
-	read_lock_irqsave(&tasklist_lock, flags);
+	read_lock(&tasklist_lock);
 	for_each_process_thread(g, p) {
 		/*
 		 * Only normalize user tasks:
 		 */
-		if (!p->mm)
+		if (p->flags & PF_KTHREAD)
 			continue;
 
 		p->se.exec_start		= 0;
@@ -7157,20 +7157,16 @@ void normalize_rt_tasks(void)
 			 * Renice negative nice level userspace
 			 * tasks back to 0:
 			 */
-			if (task_nice(p) < 0 && p->mm)
+			if (task_nice(p) < 0)
 				set_user_nice(p, 0);
 			continue;
 		}
 
-		raw_spin_lock(&p->pi_lock);
-		rq = __task_rq_lock(p);
-
+		rq = task_rq_lock(p, &flags);
 		normalize_task(rq, p);
-
-		__task_rq_unlock(rq);
-		raw_spin_unlock(&p->pi_lock);
+		task_rq_unlock(rq, p, &flags);
 	}
-	read_unlock_irqrestore(&tasklist_lock, flags);
+	read_unlock(&tasklist_lock);
 }
 
 #endif /* CONFIG_MAGIC_SYSRQ */
-- 
1.5.5.1

