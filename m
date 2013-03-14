Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964860Ab3CNC5o (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Mar 2013 22:57:44 -0400
Received: from mail-qc0-f178.google.com ([209.85.216.178]:63233 "EHLO
	mail-qc0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934386Ab3CNC5j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Mar 2013 22:57:39 -0400
From: Tejun Heo <tj@kernel.org>
To: linux-kernel@vger.kernel.org
Cc: laijs@cn.fujitsu.com, Tejun Heo <tj@kernel.org>
Subject: [PATCH 4/7] workqueue: relocate global variable defs and function decls in workqueue.c
Date: Wed, 13 Mar 2013 19:57:22 -0700
Message-Id: <1363229845-6831-5-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1363229845-6831-1-git-send-email-tj@kernel.org>
References: <1363229845-6831-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

They're split across debugobj code for some reason.  Collect them.

This patch is pure relocation.

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 kernel/workqueue.c | 38 +++++++++++++++++++-------------------
 1 file changed, 19 insertions(+), 19 deletions(-)

diff --git a/kernel/workqueue.c b/kernel/workqueue.c
index ce1ab06..9a0cbb2 100644
--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -248,6 +248,21 @@ struct workqueue_struct {
 
 static struct kmem_cache *pwq_cache;
 
+/* Serializes the accesses to the list of workqueues. */
+static DEFINE_SPINLOCK(workqueue_lock);
+static LIST_HEAD(workqueues);
+static bool workqueue_freezing;		/* W: have wqs started freezing? */
+
+/* the per-cpu worker pools */
+static DEFINE_PER_CPU_SHARED_ALIGNED(struct worker_pool [NR_STD_WORKER_POOLS],
+				     cpu_worker_pools);
+
+/*
+ * R: idr of all pools.  Modifications are protected by workqueue_lock.
+ * Read accesses are protected by sched-RCU protected.
+ */
+static DEFINE_IDR(worker_pool_idr);
+
 /* W: hash of all unbound pools keyed by pool->attrs */
 static DEFINE_HASHTABLE(unbound_pool_hash, UNBOUND_POOL_HASH_ORDER);
 
@@ -265,6 +280,10 @@ EXPORT_SYMBOL_GPL(system_unbound_wq);
 struct workqueue_struct *system_freezable_wq __read_mostly;
 EXPORT_SYMBOL_GPL(system_freezable_wq);
 
+static int worker_thread(void *__worker);
+static void copy_workqueue_attrs(struct workqueue_attrs *to,
+				 const struct workqueue_attrs *from);
+
 #define CREATE_TRACE_POINTS
 #include <trace/events/workqueue.h>
 
@@ -431,25 +450,6 @@ static inline void debug_work_activate(struct work_struct *work) { }
 static inline void debug_work_deactivate(struct work_struct *work) { }
 #endif
 
-/* Serializes the accesses to the list of workqueues. */
-static DEFINE_SPINLOCK(workqueue_lock);
-static LIST_HEAD(workqueues);
-static bool workqueue_freezing;		/* W: have wqs started freezing? */
-
-/* the per-cpu worker pools */
-static DEFINE_PER_CPU_SHARED_ALIGNED(struct worker_pool [NR_STD_WORKER_POOLS],
-				     cpu_worker_pools);
-
-/*
- * R: idr of all pools.  Modifications are protected by workqueue_lock.
- * Read accesses are protected by sched-RCU protected.
- */
-static DEFINE_IDR(worker_pool_idr);
-
-static int worker_thread(void *__worker);
-static void copy_workqueue_attrs(struct workqueue_attrs *to,
-				 const struct workqueue_attrs *from);
-
 /* allocate ID and assign it to @pool */
 static int worker_pool_assign_id(struct worker_pool *pool)
 {
-- 
1.8.1.4

