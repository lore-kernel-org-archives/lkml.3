Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755913AbaG3VnJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2014 17:43:09 -0400
Received: from forward8l.mail.yandex.net ([84.201.143.141]:48653 "EHLO
	forward8l.mail.yandex.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752332AbaG3VnF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2014 17:43:05 -0400
X-Yandex-Uniq: 9300b599-7204-42ad-8003-3a4b461bef5f
Authentication-Results: smtp11.mail.yandex.net; dkim=pass header.i=@yandex.ru
Subject: [PATCH v3 3/5] sched: Remove double_rq_lock() from __migrate_task()
From: Kirill Tkhai <tkhai@yandex.ru>
To: linux-kernel@vger.kernel.org
Cc: nicolas.pitre@linaro.org, peterz@infradead.org, pjt@google.com,
        oleg@redhat.com, rostedt@goodmis.org, umgwanakikbuti@gmail.com,
        ktkhai@parallels.com, tim.c.chen@linux.intel.com, mingo@kernel.org
Date: Thu, 31 Jul 2014 01:42:55 +0400
Message-ID: <20140730214255.27604.14735.stgit@localhost>
In-Reply-To: <20140730213219.27604.11218.stgit@localhost>
References: <20140730213219.27604.11218.stgit@localhost>
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
index 75b0517..9494daf 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -4681,20 +4681,20 @@ EXPORT_SYMBOL_GPL(set_cpus_allowed_ptr);
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
@@ -4704,15 +4704,22 @@ static int __migrate_task(struct task_struct *p, int src_cpu, int dest_cpu)
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

