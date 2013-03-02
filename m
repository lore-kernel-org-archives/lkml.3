Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752472Ab3CBDYz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Mar 2013 22:24:55 -0500
Received: from mail-pb0-f43.google.com ([209.85.160.43]:63066 "EHLO
	mail-pb0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751988Ab3CBDYf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Mar 2013 22:24:35 -0500
From: Tejun Heo <tj@kernel.org>
To: linux-kernel@vger.kernel.org, laijs@cn.fujitsu.com
Cc: axboe@kernel.dk, jmoyer@redhat.com, zab@redhat.com,
        Tejun Heo <tj@kernel.org>
Subject: [PATCH 03/31] workqueue: introduce kmem_cache for pool_workqueues
Date: Fri,  1 Mar 2013 19:23:54 -0800
Message-Id: <1362194662-2344-4-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1362194662-2344-1-git-send-email-tj@kernel.org>
References: <1362194662-2344-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

pool_workqueues need to be aligned to 1 << WORK_STRUCT_FLAG_BITS as
the lower bits of work->data are used for flags when they're pointing
to pool_workqueues.

Due to historical reasons, unbound pool_workqueues are allocated using
kzalloc() with sufficient buffer area for alignment and aligned
manually.  The original pointer is stored at the end which free_pwqs()
retrieves when freeing it.

There's no reason for this hackery anymore.  Set alignment of struct
pool_workqueue to 1 << WORK_STRUCT_FLAG_BITS, add kmem_cache for
pool_workqueues with proper alignment and replace the hacky alloc and
free implementation with plain kmem_cache_zalloc/free().

In case WORK_STRUCT_FLAG_BITS gets shrunk too much and makes fields of
pool_workqueues misaligned, trigger WARN if the alignment of struct
pool_workqueue becomes smaller than that of long long.

Note that assertion on IS_ALIGNED() is removed from alloc_pwqs().  We
already have another one in pwq init loop in __alloc_workqueue_key().

This patch doesn't introduce any visible behavior changes.

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 kernel/workqueue.c | 43 ++++++++++++-------------------------------
 1 file changed, 12 insertions(+), 31 deletions(-)

diff --git a/kernel/workqueue.c b/kernel/workqueue.c
index 61f78ef..69f1268 100644
--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -169,7 +169,7 @@ struct pool_workqueue {
 	int			nr_active;	/* L: nr of active works */
 	int			max_active;	/* L: max active works */
 	struct list_head	delayed_works;	/* L: delayed works */
-};
+} __aligned(1 << WORK_STRUCT_FLAG_BITS);
 
 /*
  * Structure used to wait for workqueue flush.
@@ -233,6 +233,8 @@ struct workqueue_struct {
 	char			name[];		/* I: workqueue name */
 };
 
+static struct kmem_cache *pwq_cache;
+
 struct workqueue_struct *system_wq __read_mostly;
 EXPORT_SYMBOL_GPL(system_wq);
 struct workqueue_struct *system_highpri_wq __read_mostly;
@@ -3098,34 +3100,11 @@ int keventd_up(void)
 
 static int alloc_pwqs(struct workqueue_struct *wq)
 {
-	/*
-	 * pwqs are forced aligned according to WORK_STRUCT_FLAG_BITS.
-	 * Make sure that the alignment isn't lower than that of
-	 * unsigned long long.
-	 */
-	const size_t size = sizeof(struct pool_workqueue);
-	const size_t align = max_t(size_t, 1 << WORK_STRUCT_FLAG_BITS,
-				   __alignof__(unsigned long long));
-
 	if (!(wq->flags & WQ_UNBOUND))
-		wq->pool_wq.pcpu = __alloc_percpu(size, align);
-	else {
-		void *ptr;
-
-		/*
-		 * Allocate enough room to align pwq and put an extra
-		 * pointer at the end pointing back to the originally
-		 * allocated pointer which will be used for free.
-		 */
-		ptr = kzalloc(size + align + sizeof(void *), GFP_KERNEL);
-		if (ptr) {
-			wq->pool_wq.single = PTR_ALIGN(ptr, align);
-			*(void **)(wq->pool_wq.single + 1) = ptr;
-		}
-	}
+		wq->pool_wq.pcpu = alloc_percpu(struct pool_workqueue);
+	else
+		wq->pool_wq.single = kmem_cache_zalloc(pwq_cache, GFP_KERNEL);
 
-	/* just in case, make sure it's actually aligned */
-	BUG_ON(!IS_ALIGNED(wq->pool_wq.v, align));
 	return wq->pool_wq.v ? 0 : -ENOMEM;
 }
 
@@ -3133,10 +3112,8 @@ static void free_pwqs(struct workqueue_struct *wq)
 {
 	if (!(wq->flags & WQ_UNBOUND))
 		free_percpu(wq->pool_wq.pcpu);
-	else if (wq->pool_wq.single) {
-		/* the pointer to free is stored right after the pwq */
-		kfree(*(void **)(wq->pool_wq.single + 1));
-	}
+	else
+		kmem_cache_free(pwq_cache, wq->pool_wq.single);
 }
 
 static int wq_clamp_max_active(int max_active, unsigned int flags,
@@ -3737,6 +3714,10 @@ static int __init init_workqueues(void)
 	BUILD_BUG_ON((1LU << (BITS_PER_LONG - WORK_OFFQ_POOL_SHIFT)) <
 		     WORK_CPU_END * NR_STD_WORKER_POOLS);
 
+	WARN_ON(__alignof__(struct pool_workqueue) < __alignof__(long long));
+
+	pwq_cache = KMEM_CACHE(pool_workqueue, SLAB_PANIC);
+
 	cpu_notifier(workqueue_cpu_up_callback, CPU_PRI_WORKQUEUE_UP);
 	hotcpu_notifier(workqueue_cpu_down_callback, CPU_PRI_WORKQUEUE_DOWN);
 
-- 
1.8.1.2

