Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757132AbaIIOyP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Sep 2014 10:54:15 -0400
Received: from terminus.zytor.com ([198.137.202.10]:41092 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753569AbaIIOyI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Sep 2014 10:54:08 -0400
Date: Tue, 9 Sep 2014 07:52:22 -0700
From: tip-bot for Lai Jiangshan <tipbot@zytor.com>
Message-ID: <tip-5cd038f53ed9ec7a17ab7d536a727363080f4210@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, sasha.levin@oracle.com, hpa@zytor.com,
        mingo@kernel.org, torvalds@linux-foundation.org, peterz@infradead.org,
        tglx@linutronix.de, laijs@cn.fujitsu.com, jjherne@linux.vnet.ibm.com
Reply-To: mingo@kernel.org, hpa@zytor.com, sasha.levin@oracle.com,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        peterz@infradead.org, tglx@linutronix.de, jjherne@linux.vnet.ibm.com,
        laijs@cn.fujitsu.com
In-Reply-To: <538ED7EB.5050303@cn.fujitsu.com>
References: <538ED7EB.5050303@cn.fujitsu.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/core] sched: Migrate waking tasks
Git-Commit-ID: 5cd038f53ed9ec7a17ab7d536a727363080f4210
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

Commit-ID:  5cd038f53ed9ec7a17ab7d536a727363080f4210
Gitweb:     http://git.kernel.org/tip/5cd038f53ed9ec7a17ab7d536a727363080f4210
Author:     Lai Jiangshan <laijs@cn.fujitsu.com>
AuthorDate: Wed, 4 Jun 2014 16:25:15 +0800
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Tue, 9 Sep 2014 06:47:27 +0200

sched: Migrate waking tasks

Current code can fail to migrate a waking task (silently) when TTWU_QUEUE is
enabled.

When a task is waking, it is pending on the wake_list of the rq, but it is not
queued (task->on_rq == 0). In this case, set_cpus_allowed_ptr() and
__migrate_task() will not migrate it because its invisible to them.

This behavior is incorrect, because the task has been already woken, it will be
running on the wrong CPU without correct placement until the next wake-up or
update for cpus_allowed.

To fix this problem, we need to finish the wakeup (so they appear on
the runqueue) before we migrate them.

Reported-by: Sasha Levin <sasha.levin@oracle.com>
Reported-by: Jason J. Herne <jjherne@linux.vnet.ibm.com>
Tested-by: Jason J. Herne <jjherne@linux.vnet.ibm.com>
Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Link: http://lkml.kernel.org/r/538ED7EB.5050303@cn.fujitsu.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 kernel/sched/core.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index a814b3c..78e5c83 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -4666,7 +4666,7 @@ int set_cpus_allowed_ptr(struct task_struct *p, const struct cpumask *new_mask)
 		goto out;
 
 	dest_cpu = cpumask_any_and(cpu_active_mask, new_mask);
-	if (task_on_rq_queued(p)) {
+	if (task_on_rq_queued(p) || p->state == TASK_WAKING) {
 		struct migration_arg arg = { p, dest_cpu };
 		/* Need help from migration thread: drop lock and wait. */
 		task_rq_unlock(rq, p, &flags);
@@ -4799,6 +4799,12 @@ static int migration_cpu_stop(void *data)
 	 * be on another cpu but it doesn't matter.
 	 */
 	local_irq_disable();
+	/*
+	 * We need to explicitly wake pending tasks before running
+	 * __migrate_task() such that we will not miss enforcing cpus_allowed
+	 * during wakeups, see set_cpus_allowed_ptr()'s TASK_WAKING test.
+	 */
+	sched_ttwu_pending();
 	__migrate_task(arg->task, raw_smp_processor_id(), arg->dest_cpu);
 	local_irq_enable();
 	return 0;
