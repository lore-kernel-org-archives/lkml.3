Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752010AbaGZO7h (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Jul 2014 10:59:37 -0400
Received: from forward5l.mail.yandex.net ([84.201.143.138]:45121 "EHLO
	forward5l.mail.yandex.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751741AbaGZO7f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Jul 2014 10:59:35 -0400
X-Yandex-Uniq: fd632ec5-785d-4416-aae9-56a6a9051e2f
Authentication-Results: smtp4h.mail.yandex.net; dkim=pass header.i=@yandex.ru
Subject: [PATCH v2 3/5] sched: Remove double_rq_lock() from __migrate_task()
From: Kirill Tkhai <tkhai@yandex.ru>
To: linux-kernel@vger.kernel.org
Cc: nicolas.pitre@linaro.org, peterz@infradead.org, pjt@google.com,
        oleg@redhat.com, rostedt@goodmis.org, umgwanakikbuti@gmail.com,
        ktkhai@parallels.com, tim.c.chen@linux.intel.com, mingo@kernel.org
Date: Sat, 26 Jul 2014 18:59:30 +0400
Message-ID: <20140726145928.6308.99197.stgit@localhost>
In-Reply-To: <20140726145508.6308.69121.stgit@localhost>
References: <20140726145508.6308.69121.stgit@localhost>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Let's use ONRQ_MIGRATING instead.

Signed-off-by: Kirill Tkhai <ktkhai@parallels.com>
---
 kernel/sched/core.c |   23 +++++++++++++++--------
 1 file changed, 15 insertions(+), 8 deletions(-)

diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index 772f791..9bfc4a9 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -4693,20 +4693,20 @@ EXPORT_SYMBOL_GPL(set_cpus_allowed_ptr);
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
@@ -4716,15 +4716,22 @@ static int __migrate_task(struct task_struct *p, int src_cpu, int dest_cpu)
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
+		BUG_ON(task_rq(p) != rq);
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

