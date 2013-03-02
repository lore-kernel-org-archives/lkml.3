Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752846Ab3CBDZL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Mar 2013 22:25:11 -0500
Received: from mail-pb0-f47.google.com ([209.85.160.47]:52155 "EHLO
	mail-pb0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752283Ab3CBDYq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Mar 2013 22:24:46 -0500
From: Tejun Heo <tj@kernel.org>
To: linux-kernel@vger.kernel.org, laijs@cn.fujitsu.com
Cc: axboe@kernel.dk, jmoyer@redhat.com, zab@redhat.com,
        Tejun Heo <tj@kernel.org>
Subject: [PATCH 10/31] workqueue: remove workqueue_struct->pool_wq.single
Date: Fri,  1 Mar 2013 19:24:01 -0800
Message-Id: <1362194662-2344-11-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1362194662-2344-1-git-send-email-tj@kernel.org>
References: <1362194662-2344-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

workqueue->pool_wq union is used to point either to percpu pwqs
(pool_workqueues) or single unbound pwq.  As the first pwq can be
accessed via workqueue->pwqs list, there's no reason for the single
pointer anymore.

Use list_first_entry(workqueue->pwqs) to access the unbound pwq and
drop workqueue->pool_wq.single pointer and the pool_wq union.  It
simplifies the code and eases implementing multiple unbound pools w/
custom attributes.

This patch doesn't introduce any visible behavior changes.

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 kernel/workqueue.c | 26 ++++++++++++--------------
 1 file changed, 12 insertions(+), 14 deletions(-)

diff --git a/kernel/workqueue.c b/kernel/workqueue.c
index cbdc2ac..79840b9 100644
--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -188,11 +188,7 @@ struct wq_flusher {
  */
 struct workqueue_struct {
 	unsigned int		flags;		/* W: WQ_* flags */
-	union {
-		struct pool_workqueue __percpu		*pcpu;
-		struct pool_workqueue			*single;
-		unsigned long				v;
-	} pool_wq;				/* I: pwq's */
+	struct pool_workqueue __percpu *cpu_pwqs; /* I: per-cpu pwq's */
 	struct list_head	pwqs;		/* I: all pwqs of this wq */
 	struct list_head	list;		/* W: list of all workqueues */
 
@@ -471,9 +467,11 @@ static struct pool_workqueue *get_pwq(int cpu, struct workqueue_struct *wq)
 {
 	if (!(wq->flags & WQ_UNBOUND)) {
 		if (likely(cpu < nr_cpu_ids))
-			return per_cpu_ptr(wq->pool_wq.pcpu, cpu);
-	} else if (likely(cpu == WORK_CPU_UNBOUND))
-		return wq->pool_wq.single;
+			return per_cpu_ptr(wq->cpu_pwqs, cpu);
+	} else if (likely(cpu == WORK_CPU_UNBOUND)) {
+		return list_first_entry(&wq->pwqs, struct pool_workqueue,
+					pwqs_node);
+	}
 	return NULL;
 }
 
@@ -3087,8 +3085,8 @@ static int alloc_and_link_pwqs(struct workqueue_struct *wq)
 	int cpu;
 
 	if (!(wq->flags & WQ_UNBOUND)) {
-		wq->pool_wq.pcpu = alloc_percpu(struct pool_workqueue);
-		if (!wq->pool_wq.pcpu)
+		wq->cpu_pwqs = alloc_percpu(struct pool_workqueue);
+		if (!wq->cpu_pwqs)
 			return -ENOMEM;
 
 		for_each_possible_cpu(cpu) {
@@ -3104,7 +3102,6 @@ static int alloc_and_link_pwqs(struct workqueue_struct *wq)
 		if (!pwq)
 			return -ENOMEM;
 
-		wq->pool_wq.single = pwq;
 		pwq->pool = get_std_worker_pool(WORK_CPU_UNBOUND, highpri);
 		list_add_tail(&pwq->pwqs_node, &wq->pwqs);
 	}
@@ -3115,9 +3112,10 @@ static int alloc_and_link_pwqs(struct workqueue_struct *wq)
 static void free_pwqs(struct workqueue_struct *wq)
 {
 	if (!(wq->flags & WQ_UNBOUND))
-		free_percpu(wq->pool_wq.pcpu);
-	else
-		kmem_cache_free(pwq_cache, wq->pool_wq.single);
+		free_percpu(wq->cpu_pwqs);
+	else if (!list_empty(&wq->pwqs))
+		kmem_cache_free(pwq_cache, list_first_entry(&wq->pwqs,
+					struct pool_workqueue, pwqs_node));
 }
 
 static int wq_clamp_max_active(int max_active, unsigned int flags,
-- 
1.8.1.2

