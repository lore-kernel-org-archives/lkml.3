Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756805Ab3JKHXY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Oct 2013 03:23:24 -0400
Received: from mail-ie0-f178.google.com ([209.85.223.178]:55054 "EHLO
	mail-ie0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756190Ab3JKHXW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Oct 2013 03:23:22 -0400
Message-Id: <20131011072300.494245221@kernel.org>
User-Agent: quilt/0.60-1
Date: Fri, 11 Oct 2013 15:18:03 +0800
From: Shaohua Li <shli@kernel.org>
To: linux-kernel@vger.kernel.org, axboe@kernel.dk
Cc: kmo@daterainc.com
Subject: [patch 1/4] percpu_ida: make percpu_ida percpu size/batch
 configurable
References: <20131011071802.148101321@kernel.org>
Content-Disposition: inline; filename=0001-percpu_ida-make-percpu_ida-percpu-size-batch-configu.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Make percpu_ida percpu size/batch configurable. The block-mq-tag will use it.

Signed-off-by: Shaohua Li <shli@fusionio.com>
---
 include/linux/percpu_ida.h |   18 +++++++++++++++++-
 lib/percpu_ida.c           |   28 +++++++++++-----------------
 2 files changed, 28 insertions(+), 18 deletions(-)

Index: master/include/linux/percpu_ida.h
===================================================================
--- master.orig/include/linux/percpu_ida.h	2013-10-11 12:14:44.472699999 +0800
+++ master/include/linux/percpu_ida.h	2013-10-11 12:14:44.472699999 +0800
@@ -16,6 +16,8 @@ struct percpu_ida {
 	 * percpu_ida_init()
 	 */
 	unsigned			nr_tags;
+	unsigned			percpu_max_size;
+	unsigned			percpu_batch_size;
 
 	struct percpu_ida_cpu __percpu	*tag_cpu;
 
@@ -51,10 +53,24 @@ struct percpu_ida {
 	} ____cacheline_aligned_in_smp;
 };
 
+/*
+ * Number of tags we move between the percpu freelist and the global freelist at
+ * a time
+ */
+#define IDA_DEFAULT_PCPU_BATCH_MOVE	32U
+/* Max size of percpu freelist, */
+#define IDA_DEFAULT_PCPU_SIZE	((IDA_DEFAULT_PCPU_BATCH_MOVE * 3) / 2)
+
 int percpu_ida_alloc(struct percpu_ida *pool, gfp_t gfp);
 void percpu_ida_free(struct percpu_ida *pool, unsigned tag);
 
 void percpu_ida_destroy(struct percpu_ida *pool);
-int percpu_ida_init(struct percpu_ida *pool, unsigned long nr_tags);
+int __percpu_ida_init(struct percpu_ida *pool, unsigned long nr_tags,
+	unsigned long max_size, unsigned long batch_size);
+static inline int percpu_ida_init(struct percpu_ida *pool, unsigned long nr_tags)
+{
+	return __percpu_ida_init(pool, nr_tags, IDA_DEFAULT_PCPU_SIZE,
+		IDA_DEFAULT_PCPU_BATCH_MOVE);
+}
 
 #endif /* __PERCPU_IDA_H__ */
Index: master/lib/percpu_ida.c
===================================================================
--- master.orig/lib/percpu_ida.c	2013-10-11 12:14:44.472699999 +0800
+++ master/lib/percpu_ida.c	2013-10-11 12:14:44.472699999 +0800
@@ -30,15 +30,6 @@
 #include <linux/spinlock.h>
 #include <linux/percpu_ida.h>
 
-/*
- * Number of tags we move between the percpu freelist and the global freelist at
- * a time
- */
-#define IDA_PCPU_BATCH_MOVE	32U
-
-/* Max size of percpu freelist, */
-#define IDA_PCPU_SIZE		((IDA_PCPU_BATCH_MOVE * 3) / 2)
-
 struct percpu_ida_cpu {
 	/*
 	 * Even though this is percpu, we need a lock for tag stealing by remote
@@ -78,7 +69,7 @@ static inline void steal_tags(struct per
 	struct percpu_ida_cpu *remote;
 
 	for (cpus_have_tags = cpumask_weight(&pool->cpus_have_tags);
-	     cpus_have_tags * IDA_PCPU_SIZE > pool->nr_tags / 2;
+	     cpus_have_tags * pool->percpu_max_size > pool->nr_tags / 2;
 	     cpus_have_tags--) {
 		cpu = cpumask_next(cpu, &pool->cpus_have_tags);
 
@@ -123,7 +114,7 @@ static inline void alloc_global_tags(str
 {
 	move_tags(tags->freelist, &tags->nr_free,
 		  pool->freelist, &pool->nr_free,
-		  min(pool->nr_free, IDA_PCPU_BATCH_MOVE));
+		  min(pool->nr_free, pool->percpu_batch_size));
 }
 
 static inline unsigned alloc_local_tag(struct percpu_ida *pool,
@@ -245,17 +236,17 @@ void percpu_ida_free(struct percpu_ida *
 		wake_up(&pool->wait);
 	}
 
-	if (nr_free == IDA_PCPU_SIZE) {
+	if (nr_free == pool->percpu_max_size) {
 		spin_lock(&pool->lock);
 
 		/*
 		 * Global lock held and irqs disabled, don't need percpu
 		 * lock
 		 */
-		if (tags->nr_free == IDA_PCPU_SIZE) {
+		if (tags->nr_free == pool->percpu_max_size) {
 			move_tags(pool->freelist, &pool->nr_free,
 				  tags->freelist, &tags->nr_free,
-				  IDA_PCPU_BATCH_MOVE);
+				  pool->percpu_batch_size);
 
 			wake_up(&pool->wait);
 		}
@@ -292,7 +283,8 @@ EXPORT_SYMBOL_GPL(percpu_ida_destroy);
  * Allocation is percpu, but sharding is limited by nr_tags - for best
  * performance, the workload should not span more cpus than nr_tags / 128.
  */
-int percpu_ida_init(struct percpu_ida *pool, unsigned long nr_tags)
+int __percpu_ida_init(struct percpu_ida *pool, unsigned long nr_tags,
+	unsigned long max_size, unsigned long batch_size)
 {
 	unsigned i, cpu, order;
 
@@ -301,6 +293,8 @@ int percpu_ida_init(struct percpu_ida *p
 	init_waitqueue_head(&pool->wait);
 	spin_lock_init(&pool->lock);
 	pool->nr_tags = nr_tags;
+	pool->percpu_max_size = max_size;
+	pool->percpu_batch_size = batch_size;
 
 	/* Guard against overflow */
 	if (nr_tags > (unsigned) INT_MAX + 1) {
@@ -319,7 +313,7 @@ int percpu_ida_init(struct percpu_ida *p
 	pool->nr_free = nr_tags;
 
 	pool->tag_cpu = __alloc_percpu(sizeof(struct percpu_ida_cpu) +
-				       IDA_PCPU_SIZE * sizeof(unsigned),
+				       pool->percpu_max_size * sizeof(unsigned),
 				       sizeof(unsigned));
 	if (!pool->tag_cpu)
 		goto err;
@@ -332,4 +326,4 @@ err:
 	percpu_ida_destroy(pool);
 	return -ENOMEM;
 }
-EXPORT_SYMBOL_GPL(percpu_ida_init);
+EXPORT_SYMBOL_GPL(__percpu_ida_init);

