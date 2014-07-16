Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935135AbaGPTXi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2014 15:23:38 -0400
Received: from terminus.zytor.com ([198.137.202.10]:44505 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934984AbaGPTXb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2014 15:23:31 -0400
Date: Wed, 16 Jul 2014 12:22:23 -0700
From: tip-bot for Oleg Nesterov <tipbot@zytor.com>
Message-ID: <tip-466af29bf4270e84261712428a1304c28e3743fa@git.kernel.org>
Cc: mingo@kernel.org, torvalds@linux-foundation.org, peterz@infradead.org,
        akpm@linux-foundation.org, tglx@linutronix.de, oleg@redhat.com,
        rientjes@google.com, davidlohr@hp.com, juri.lelli@gmail.com,
        linux-kernel@vger.kernel.org, hpa@zytor.com, daeseok.youn@gmail.com,
        raistlin@linux.it, michal.simek@xilinx.com, ebiederm@xmission.com,
        athorlton@sgi.com, mdempsky@chromium.org
Reply-To: mingo@kernel.org, torvalds@linux-foundation.org,
        peterz@infradead.org, akpm@linux-foundation.org, tglx@linutronix.de,
        oleg@redhat.com, rientjes@google.com, davidlohr@hp.com,
        juri.lelli@gmail.com, linux-kernel@vger.kernel.org, hpa@zytor.com,
        daeseok.youn@gmail.com, raistlin@linux.it, michal.simek@xilinx.com,
        ebiederm@xmission.com, athorlton@sgi.com, mdempsky@chromium.org
In-Reply-To: <20140606165206.GB29465@redhat.com>
References: <20140606165206.GB29465@redhat.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/core] sched/deadline: Kill task_struct->pi_top_task
Git-Commit-ID: 466af29bf4270e84261712428a1304c28e3743fa
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

Commit-ID:  466af29bf4270e84261712428a1304c28e3743fa
Gitweb:     http://git.kernel.org/tip/466af29bf4270e84261712428a1304c28e3743fa
Author:     Oleg Nesterov <oleg@redhat.com>
AuthorDate: Fri, 6 Jun 2014 18:52:06 +0200
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Wed, 16 Jul 2014 13:38:18 +0200

sched/deadline: Kill task_struct->pi_top_task

Remove task_struct->pi_top_task. The only user, rt_mutex_setprio(),
can use a local.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Signed-off-by: Peter Zijlstra <peterz@infradead.org>
Cc: Juri Lelli <juri.lelli@gmail.com>
Cc: Alex Thorlton <athorlton@sgi.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Daeseok Youn <daeseok.youn@gmail.com>
Cc: Dario Faggioli <raistlin@linux.it>
Cc: Davidlohr Bueso <davidlohr@hp.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Eric W. Biederman <ebiederm@xmission.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Matthew Dempsky <mdempsky@chromium.org>
Cc: Michal Simek <michal.simek@xilinx.com>
Cc: Oleg Nesterov <oleg@redhat.com>
Link: http://lkml.kernel.org/r/20140606165206.GB29465@redhat.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 include/linux/sched.h | 2 --
 kernel/fork.c         | 1 -
 kernel/sched/core.c   | 6 +++---
 3 files changed, 3 insertions(+), 6 deletions(-)

diff --git a/include/linux/sched.h b/include/linux/sched.h
index 306f4f0..c9c9ff7 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -1440,8 +1440,6 @@ struct task_struct {
 	struct rb_node *pi_waiters_leftmost;
 	/* Deadlock detection and priority inheritance handling */
 	struct rt_mutex_waiter *pi_blocked_on;
-	/* Top pi_waiters task */
-	struct task_struct *pi_top_task;
 #endif
 
 #ifdef CONFIG_DEBUG_MUTEXES
diff --git a/kernel/fork.c b/kernel/fork.c
index d2799d1..6ff87f442 100644
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -1095,7 +1095,6 @@ static void rt_mutex_init_task(struct task_struct *p)
 	p->pi_waiters = RB_ROOT;
 	p->pi_waiters_leftmost = NULL;
 	p->pi_blocked_on = NULL;
-	p->pi_top_task = NULL;
 #endif
 }
 
diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index 2dbc63d..cf7695a 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -2980,7 +2980,6 @@ void rt_mutex_setprio(struct task_struct *p, int prio)
 	}
 
 	trace_sched_pi_setprio(p, prio);
-	p->pi_top_task = rt_mutex_get_top_task(p);
 	oldprio = p->prio;
 	prev_class = p->sched_class;
 	on_rq = p->on_rq;
@@ -3000,8 +2999,9 @@ void rt_mutex_setprio(struct task_struct *p, int prio)
 	 *          running task
 	 */
 	if (dl_prio(prio)) {
-		if (!dl_prio(p->normal_prio) || (p->pi_top_task &&
-			dl_entity_preempt(&p->pi_top_task->dl, &p->dl))) {
+		struct task_struct *pi_task = rt_mutex_get_top_task(p);
+		if (!dl_prio(p->normal_prio) ||
+		    (pi_task && dl_entity_preempt(&pi_task->dl, &p->dl))) {
 			p->dl.dl_boosted = 1;
 			p->dl.dl_throttled = 0;
 			enqueue_flag = ENQUEUE_REPLENISH;
