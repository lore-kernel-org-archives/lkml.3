Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752528AbaHTSs2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Aug 2014 14:48:28 -0400
Received: from terminus.zytor.com ([198.137.202.10]:52810 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751137AbaHTSs0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Aug 2014 14:48:26 -0400
Date: Wed, 20 Aug 2014 11:46:08 -0700
From: tip-bot for Kirill Tkhai <tipbot@zytor.com>
Message-ID: <tip-a1e01829796aa7a993e28ffd7fee5c8d525be175@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, ktkhai@parallels.com, hpa@zytor.com,
        mingo@kernel.org, torvalds@linux-foundation.org, pjt@google.com,
        peterz@infradead.org, nicolas.pitre@linaro.org,
        tim.c.chen@linux.intel.com, umgwanakikbuti@gmail.com,
        rostedt@goodmis.org, tkhai@yandex.ru, tglx@linutronix.de,
        oleg@redhat.com
Reply-To: mingo@kernel.org, hpa@zytor.com, ktkhai@parallels.com,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        peterz@infradead.org, pjt@google.com, tim.c.chen@linux.intel.com,
        nicolas.pitre@linaro.org, umgwanakikbuti@gmail.com,
        rostedt@goodmis.org, tkhai@yandex.ru, oleg@redhat.com,
        tglx@linutronix.de
In-Reply-To: <1408528070.23412.89.camel@tkhai>
References: <1408528070.23412.89.camel@tkhai>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/core] sched: Remove double_rq_lock()
  from __migrate_task()
Git-Commit-ID: a1e01829796aa7a993e28ffd7fee5c8d525be175
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

Commit-ID:  a1e01829796aa7a993e28ffd7fee5c8d525be175
Gitweb:     http://git.kernel.org/tip/a1e01829796aa7a993e28ffd7fee5c8d525be175
Author:     Kirill Tkhai <ktkhai@parallels.com>
AuthorDate: Wed, 20 Aug 2014 13:47:50 +0400
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Wed, 20 Aug 2014 14:53:02 +0200

sched: Remove double_rq_lock() from __migrate_task()

Avoid double_rq_lock() and use TASK_ON_RQ_MIGRATING for
__migrate_task(). The advantage is (obviously) not holding two
rq->lock's at the same time and thereby increasing parallelism.

The important point to note is that because we acquire dst->lock
immediately after releasing src->lock the potential wait time of
task_rq_lock() callers on TASK_ON_RQ_MIGRATING is not longer
than it would have been in the double rq lock scenario.

Signed-off-by: Kirill Tkhai <ktkhai@parallels.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Paul Turner <pjt@google.com>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Mike Galbraith <umgwanakikbuti@gmail.com>
Cc: Kirill Tkhai <tkhai@yandex.ru>
Cc: Tim Chen <tim.c.chen@linux.intel.com>
Cc: Nicolas Pitre <nicolas.pitre@linaro.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Link: http://lkml.kernel.org/r/1408528070.23412.89.camel@tkhai
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 kernel/sched/core.c | 23 +++++++++++++++--------
 1 file changed, 15 insertions(+), 8 deletions(-)

diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index 71b8360..a773c91 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -4679,20 +4679,20 @@ EXPORT_SYMBOL_GPL(set_cpus_allowed_ptr);
  */
 static int __migrate_task(struct task_struct *p, int src_cpu, int dest_cpu)
 {
-	struct rq *rq_dest, *rq_src;
+	struct rq *rq;
 	int ret = 0;
 
 	if (unlikely(!cpu_active(dest_cpu)))
 		return ret;
 
-	rq_src = cpu_rq(src_cpu);
-	rq_dest = cpu_rq(dest_cpu);
+	rq = cpu_rq(src_cpu);
 
 	raw_spin_lock(&p->pi_lock);
-	double_rq_lock(rq_src, rq_dest);
+	raw_spin_lock(&rq->lock);
 	/* Already moved. */
 	if (task_cpu(p) != src_cpu)
 		goto done;
+
 	/* Affinity changed (again). */
 	if (!cpumask_test_cpu(dest_cpu, tsk_cpus_allowed(p)))
 		goto fail;
@@ -4702,15 +4702,22 @@ static int __migrate_task(struct task_struct *p, int src_cpu, int dest_cpu)
 	 * placed properly.
 	 */
 	if (task_on_rq_queued(p)) {
-		dequeue_task(rq_src, p, 0);
+		dequeue_task(rq, p, 0);
+		p->on_rq = TASK_ON_RQ_MIGRATING;
 		set_task_cpu(p, dest_cpu);
-		enqueue_task(rq_dest, p, 0);
-		check_preempt_curr(rq_dest, p, 0);
+		raw_spin_unlock(&rq->lock);
+
+		rq = cpu_rq(dest_cpu);
+		raw_spin_lock(&rq->lock);
+		BUG_ON(task_rq(p) != rq);
+		p->on_rq = TASK_ON_RQ_QUEUED;
+		enqueue_task(rq, p, 0);
+		check_preempt_curr(rq, p, 0);
 	}
 done:
 	ret = 1;
 fail:
-	double_rq_unlock(rq_src, rq_dest);
+	raw_spin_unlock(&rq->lock);
 	raw_spin_unlock(&p->pi_lock);
 	return ret;
 }
