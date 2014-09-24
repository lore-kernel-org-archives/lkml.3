Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752739AbaIXO5Z (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2014 10:57:25 -0400
Received: from terminus.zytor.com ([198.137.202.10]:59637 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751239AbaIXO45 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2014 10:56:57 -0400
Date: Wed, 24 Sep 2014 07:56:06 -0700
From: tip-bot for Oleg Nesterov <tipbot@zytor.com>
Message-ID: <tip-3472eaa1f12e217e2b8b0ef658ff861b2308cbbd@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        torvalds@linux-foundation.org, peterz@infradead.org,
        umgwanakikbuti@gmail.com, tkhai@yandex.ru, tglx@linutronix.de,
        oleg@redhat.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, peterz@infradead.org,
        umgwanakikbuti@gmail.com, tkhai@yandex.ru, oleg@redhat.com,
        tglx@linutronix.de
In-Reply-To: <20140921193338.GA28621@redhat.com>
References: <20140921193338.GA28621@redhat.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/core] sched: normalize_rt_tasks(): Don'
 t use _irqsave for tasklist_lock, use task_rq_lock()
Git-Commit-ID: 3472eaa1f12e217e2b8b0ef658ff861b2308cbbd
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  3472eaa1f12e217e2b8b0ef658ff861b2308cbbd
Gitweb:     http://git.kernel.org/tip/3472eaa1f12e217e2b8b0ef658ff861b2308cbbd
Author:     Oleg Nesterov <oleg@redhat.com>
AuthorDate: Sun, 21 Sep 2014 21:33:38 +0200
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Wed, 24 Sep 2014 14:47:03 +0200

sched: normalize_rt_tasks(): Don't use _irqsave for tasklist_lock, use task_rq_lock()

1. read_lock(tasklist_lock) does not need to disable irqs.

2. ->mm != NULL is a common mistake, use PF_KTHREAD.

3. The second ->mm check can be simply removed.

4. task_rq_lock() looks better than raw_spin_lock(&p->pi_lock) +
   __task_rq_lock().

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Cc: Kirill Tkhai <tkhai@yandex.ru>
Cc: Mike Galbraith <umgwanakikbuti@gmail.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Link: http://lkml.kernel.org/r/20140921193338.GA28621@redhat.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 kernel/sched/core.c | 16 ++++++----------
 1 file changed, 6 insertions(+), 10 deletions(-)

diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index 0abfb7e..d65566d 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -7220,12 +7220,12 @@ void normalize_rt_tasks(void)
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
@@ -7240,20 +7240,16 @@ void normalize_rt_tasks(void)
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
