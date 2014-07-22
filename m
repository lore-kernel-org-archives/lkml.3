Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754799AbaGVLai (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2014 07:30:38 -0400
Received: from relay.parallels.com ([195.214.232.42]:55877 "EHLO
	relay.parallels.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754552AbaGVLac (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2014 07:30:32 -0400
Message-ID: <1406028622.3526.21.camel@tkhai>
Subject: [PATCH 3/5] sched: Remove double_rq_lock() from __migrate_task()
From: Kirill Tkhai <ktkhai@parallels.com>
To: <linux-kernel@vger.kernel.org>
CC: Peter Zijlstra <peterz@infradead.org>,
        Mike Galbraith <umgwanakikbuti@gmail.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Tim Chen <tim.c.chen@linux.intel.com>,
        Nicolas Pitre <nicolas.pitre@linaro.org>,
        Ingo Molnar <mingo@kernel.org>, Paul Turner <pjt@google.com>,
        <tkhai@yandex.ru>
Date: Tue, 22 Jul 2014 15:30:22 +0400
In-Reply-To: <20140722102425.29682.24086.stgit@tkhai>
References: <20140722102425.29682.24086.stgit@tkhai>
Organization: Parallels
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.8.5-2+b3 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.30.26.172]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Let's use ONRQ_MIGRATING instead.

Signed-off-by: Kirill Tkhai <ktkhai@parallels.com>
---
 kernel/sched/core.c |   22 ++++++++++++++--------
 1 file changed, 14 insertions(+), 8 deletions(-)

diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index 78388b0..4d62deb 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -4680,20 +4680,20 @@ EXPORT_SYMBOL_GPL(set_cpus_allowed_ptr);
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
@@ -4703,15 +4703,21 @@ static int __migrate_task(struct task_struct *p, int src_cpu, int dest_cpu)
 	 * placed properly.
 	 */
 	if (task_queued(p)) {
-		dequeue_task(rq_src, p, 0);
+		dequeue_task(rq, p, 0);
+		p->on_rq = ONRQ_MIGRATING;
 		set_task_cpu(p, dest_cpu);
-		enqueue_task(rq_dest, p, 0);
-		check_preempt_curr(rq_dest, p, 0);
+		raw_spin_unlock(&rq->lock);
+
+		rq = cpu_rq(dest_cpu);
+		raw_spin_lock(&rq->lock);
+		p->on_rq = ONRQ_QUEUED;
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



