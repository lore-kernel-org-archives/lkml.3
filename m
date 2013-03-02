Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752554Ab3CBDY5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Mar 2013 22:24:57 -0500
Received: from mail-da0-f54.google.com ([209.85.210.54]:48358 "EHLO
	mail-da0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751991Ab3CBDYh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Mar 2013 22:24:37 -0500
From: Tejun Heo <tj@kernel.org>
To: linux-kernel@vger.kernel.org, laijs@cn.fujitsu.com
Cc: axboe@kernel.dk, jmoyer@redhat.com, zab@redhat.com,
        Tejun Heo <tj@kernel.org>
Subject: [PATCH 04/31] workqueue: add workqueue_struct->pwqs list
Date: Fri,  1 Mar 2013 19:23:55 -0800
Message-Id: <1362194662-2344-5-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1362194662-2344-1-git-send-email-tj@kernel.org>
References: <1362194662-2344-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add workqueue_struct->pwqs list and chain all pool_workqueues
belonging to a workqueue there.  This will be used to implement
generic pool_workqueue iteration and handle multiple pool_workqueues
for the scheduled unbound pools with custom attributes.

This patch doesn't introduce any visible behavior changes.

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 kernel/workqueue.c | 33 +++++++++++++++++++++++++++------
 1 file changed, 27 insertions(+), 6 deletions(-)

diff --git a/kernel/workqueue.c b/kernel/workqueue.c
index 69f1268..d493293 100644
--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -169,6 +169,7 @@ struct pool_workqueue {
 	int			nr_active;	/* L: nr of active works */
 	int			max_active;	/* L: max active works */
 	struct list_head	delayed_works;	/* L: delayed works */
+	struct list_head	pwqs_node;	/* I: node on wq->pwqs */
 } __aligned(1 << WORK_STRUCT_FLAG_BITS);
 
 /*
@@ -212,6 +213,7 @@ struct workqueue_struct {
 		struct pool_workqueue			*single;
 		unsigned long				v;
 	} pool_wq;				/* I: pwq's */
+	struct list_head	pwqs;		/* I: all pwqs of this wq */
 	struct list_head	list;		/* W: list of all workqueues */
 
 	struct mutex		flush_mutex;	/* protects wq flushing */
@@ -3098,14 +3100,32 @@ int keventd_up(void)
 	return system_wq != NULL;
 }
 
-static int alloc_pwqs(struct workqueue_struct *wq)
+static int alloc_and_link_pwqs(struct workqueue_struct *wq)
 {
-	if (!(wq->flags & WQ_UNBOUND))
+	int cpu;
+
+	if (!(wq->flags & WQ_UNBOUND)) {
 		wq->pool_wq.pcpu = alloc_percpu(struct pool_workqueue);
-	else
-		wq->pool_wq.single = kmem_cache_zalloc(pwq_cache, GFP_KERNEL);
+		if (!wq->pool_wq.pcpu)
+			return -ENOMEM;
+
+		for_each_possible_cpu(cpu) {
+			struct pool_workqueue *pwq = get_pwq(cpu, wq);
 
-	return wq->pool_wq.v ? 0 : -ENOMEM;
+			list_add_tail(&pwq->pwqs_node, &wq->pwqs);
+		}
+	} else {
+		struct pool_workqueue *pwq;
+
+		pwq = kmem_cache_zalloc(pwq_cache, GFP_KERNEL);
+		if (!pwq)
+			return -ENOMEM;
+
+		wq->pool_wq.single = pwq;
+		list_add_tail(&pwq->pwqs_node, &wq->pwqs);
+	}
+
+	return 0;
 }
 
 static void free_pwqs(struct workqueue_struct *wq)
@@ -3167,13 +3187,14 @@ struct workqueue_struct *__alloc_workqueue_key(const char *fmt,
 	wq->saved_max_active = max_active;
 	mutex_init(&wq->flush_mutex);
 	atomic_set(&wq->nr_pwqs_to_flush, 0);
+	INIT_LIST_HEAD(&wq->pwqs);
 	INIT_LIST_HEAD(&wq->flusher_queue);
 	INIT_LIST_HEAD(&wq->flusher_overflow);
 
 	lockdep_init_map(&wq->lockdep_map, lock_name, key, 0);
 	INIT_LIST_HEAD(&wq->list);
 
-	if (alloc_pwqs(wq) < 0)
+	if (alloc_and_link_pwqs(wq) < 0)
 		goto err;
 
 	for_each_pwq_cpu(cpu, wq) {
-- 
1.8.1.2

