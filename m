Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752602Ab3CBDY7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Mar 2013 22:24:59 -0500
Received: from mail-pb0-f53.google.com ([209.85.160.53]:61051 "EHLO
	mail-pb0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752090Ab3CBDYi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Mar 2013 22:24:38 -0500
From: Tejun Heo <tj@kernel.org>
To: linux-kernel@vger.kernel.org, laijs@cn.fujitsu.com
Cc: axboe@kernel.dk, jmoyer@redhat.com, zab@redhat.com,
        Tejun Heo <tj@kernel.org>
Subject: [PATCH 05/31] workqueue: replace for_each_pwq_cpu() with for_each_pwq()
Date: Fri,  1 Mar 2013 19:23:56 -0800
Message-Id: <1362194662-2344-6-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1362194662-2344-1-git-send-email-tj@kernel.org>
References: <1362194662-2344-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Introduce for_each_pwq() which iterates all pool_workqueues of a
workqueue using the recently added workqueue->pwqs list and replace
for_each_pwq_cpu() usages with it.

This is primarily to remove the single unbound CPU assumption from pwq
iteration for the scheduled unbound pools with custom attributes
support which would introduce multiple unbound pwqs per workqueue;
however, it also simplifies iterator users.

Note that pwq->pool initialization is moved to alloc_and_link_pwqs()
as that now is the only place which is explicitly handling the two pwq
types.

This patch doesn't introduce any visible behavior changes.

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 kernel/workqueue.c | 53 ++++++++++++++++++++++-------------------------------
 1 file changed, 22 insertions(+), 31 deletions(-)

diff --git a/kernel/workqueue.c b/kernel/workqueue.c
index d493293..0055a31 100644
--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -273,12 +273,6 @@ static inline int __next_wq_cpu(int cpu, const struct cpumask *mask,
 	return WORK_CPU_END;
 }
 
-static inline int __next_pwq_cpu(int cpu, const struct cpumask *mask,
-				 struct workqueue_struct *wq)
-{
-	return __next_wq_cpu(cpu, mask, !(wq->flags & WQ_UNBOUND) ? 1 : 2);
-}
-
 /*
  * CPU iterators
  *
@@ -289,8 +283,6 @@ static inline int __next_pwq_cpu(int cpu, const struct cpumask *mask,
  *
  * for_each_wq_cpu()		: possible CPUs + WORK_CPU_UNBOUND
  * for_each_online_wq_cpu()	: online CPUs + WORK_CPU_UNBOUND
- * for_each_pwq_cpu()		: possible CPUs for bound workqueues,
- *				  WORK_CPU_UNBOUND for unbound workqueues
  */
 #define for_each_wq_cpu(cpu)						\
 	for ((cpu) = __next_wq_cpu(-1, cpu_possible_mask, 3);		\
@@ -302,10 +294,13 @@ static inline int __next_pwq_cpu(int cpu, const struct cpumask *mask,
 	     (cpu) < WORK_CPU_END;					\
 	     (cpu) = __next_wq_cpu((cpu), cpu_online_mask, 3))
 
-#define for_each_pwq_cpu(cpu, wq)					\
-	for ((cpu) = __next_pwq_cpu(-1, cpu_possible_mask, (wq));	\
-	     (cpu) < WORK_CPU_END;					\
-	     (cpu) = __next_pwq_cpu((cpu), cpu_possible_mask, (wq)))
+/**
+ * for_each_pwq - iterate through all pool_workqueues of the specified workqueue
+ * @pwq: iteration cursor
+ * @wq: the target workqueue
+ */
+#define for_each_pwq(pwq, wq)						\
+	list_for_each_entry((pwq), &(wq)->pwqs, pwqs_node)
 
 #ifdef CONFIG_DEBUG_OBJECTS_WORK
 
@@ -2507,15 +2502,14 @@ static bool flush_workqueue_prep_pwqs(struct workqueue_struct *wq,
 				      int flush_color, int work_color)
 {
 	bool wait = false;
-	unsigned int cpu;
+	struct pool_workqueue *pwq;
 
 	if (flush_color >= 0) {
 		WARN_ON_ONCE(atomic_read(&wq->nr_pwqs_to_flush));
 		atomic_set(&wq->nr_pwqs_to_flush, 1);
 	}
 
-	for_each_pwq_cpu(cpu, wq) {
-		struct pool_workqueue *pwq = get_pwq(cpu, wq);
+	for_each_pwq(pwq, wq) {
 		struct worker_pool *pool = pwq->pool;
 
 		spin_lock_irq(&pool->lock);
@@ -2714,7 +2708,7 @@ EXPORT_SYMBOL_GPL(flush_workqueue);
 void drain_workqueue(struct workqueue_struct *wq)
 {
 	unsigned int flush_cnt = 0;
-	unsigned int cpu;
+	struct pool_workqueue *pwq;
 
 	/*
 	 * __queue_work() needs to test whether there are drainers, is much
@@ -2728,8 +2722,7 @@ void drain_workqueue(struct workqueue_struct *wq)
 reflush:
 	flush_workqueue(wq);
 
-	for_each_pwq_cpu(cpu, wq) {
-		struct pool_workqueue *pwq = get_pwq(cpu, wq);
+	for_each_pwq(pwq, wq) {
 		bool drained;
 
 		spin_lock_irq(&pwq->pool->lock);
@@ -3102,6 +3095,7 @@ int keventd_up(void)
 
 static int alloc_and_link_pwqs(struct workqueue_struct *wq)
 {
+	bool highpri = wq->flags & WQ_HIGHPRI;
 	int cpu;
 
 	if (!(wq->flags & WQ_UNBOUND)) {
@@ -3112,6 +3106,7 @@ static int alloc_and_link_pwqs(struct workqueue_struct *wq)
 		for_each_possible_cpu(cpu) {
 			struct pool_workqueue *pwq = get_pwq(cpu, wq);
 
+			pwq->pool = get_std_worker_pool(cpu, highpri);
 			list_add_tail(&pwq->pwqs_node, &wq->pwqs);
 		}
 	} else {
@@ -3122,6 +3117,7 @@ static int alloc_and_link_pwqs(struct workqueue_struct *wq)
 			return -ENOMEM;
 
 		wq->pool_wq.single = pwq;
+		pwq->pool = get_std_worker_pool(WORK_CPU_UNBOUND, highpri);
 		list_add_tail(&pwq->pwqs_node, &wq->pwqs);
 	}
 
@@ -3156,7 +3152,7 @@ struct workqueue_struct *__alloc_workqueue_key(const char *fmt,
 {
 	va_list args, args1;
 	struct workqueue_struct *wq;
-	unsigned int cpu;
+	struct pool_workqueue *pwq;
 	size_t namelen;
 
 	/* determine namelen, allocate wq and format name */
@@ -3197,11 +3193,8 @@ struct workqueue_struct *__alloc_workqueue_key(const char *fmt,
 	if (alloc_and_link_pwqs(wq) < 0)
 		goto err;
 
-	for_each_pwq_cpu(cpu, wq) {
-		struct pool_workqueue *pwq = get_pwq(cpu, wq);
-
+	for_each_pwq(pwq, wq) {
 		BUG_ON((unsigned long)pwq & WORK_STRUCT_FLAG_MASK);
-		pwq->pool = get_std_worker_pool(cpu, flags & WQ_HIGHPRI);
 		pwq->wq = wq;
 		pwq->flush_color = -1;
 		pwq->max_active = max_active;
@@ -3236,8 +3229,8 @@ struct workqueue_struct *__alloc_workqueue_key(const char *fmt,
 	spin_lock_irq(&workqueue_lock);
 
 	if (workqueue_freezing && wq->flags & WQ_FREEZABLE)
-		for_each_pwq_cpu(cpu, wq)
-			get_pwq(cpu, wq)->max_active = 0;
+		for_each_pwq(pwq, wq)
+			pwq->max_active = 0;
 
 	list_add(&wq->list, &workqueues);
 
@@ -3263,14 +3256,13 @@ EXPORT_SYMBOL_GPL(__alloc_workqueue_key);
  */
 void destroy_workqueue(struct workqueue_struct *wq)
 {
-	unsigned int cpu;
+	struct pool_workqueue *pwq;
 
 	/* drain it before proceeding with destruction */
 	drain_workqueue(wq);
 
 	/* sanity checks */
-	for_each_pwq_cpu(cpu, wq) {
-		struct pool_workqueue *pwq = get_pwq(cpu, wq);
+	for_each_pwq(pwq, wq) {
 		int i;
 
 		for (i = 0; i < WORK_NR_COLORS; i++)
@@ -3332,7 +3324,7 @@ static void pwq_set_max_active(struct pool_workqueue *pwq, int max_active)
  */
 void workqueue_set_max_active(struct workqueue_struct *wq, int max_active)
 {
-	unsigned int cpu;
+	struct pool_workqueue *pwq;
 
 	max_active = wq_clamp_max_active(max_active, wq->flags, wq->name);
 
@@ -3340,8 +3332,7 @@ void workqueue_set_max_active(struct workqueue_struct *wq, int max_active)
 
 	wq->saved_max_active = max_active;
 
-	for_each_pwq_cpu(cpu, wq) {
-		struct pool_workqueue *pwq = get_pwq(cpu, wq);
+	for_each_pwq(pwq, wq) {
 		struct worker_pool *pool = pwq->pool;
 
 		spin_lock(&pool->lock);
-- 
1.8.1.2

