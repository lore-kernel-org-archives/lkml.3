Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934477Ab3CMX6i (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Mar 2013 19:58:38 -0400
Received: from mail-qc0-f169.google.com ([209.85.216.169]:64213 "EHLO
	mail-qc0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934407Ab3CMX61 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Mar 2013 19:58:27 -0400
From: Tejun Heo <tj@kernel.org>
To: linux-kernel@vger.kernel.org
Cc: laijs@cn.fujitsu.com, Tejun Heo <tj@kernel.org>
Subject: [PATCH 1/6] workqueue: relocate pwq_set_max_active()
Date: Wed, 13 Mar 2013 16:58:13 -0700
Message-Id: <1363219098-16083-2-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1363219098-16083-1-git-send-email-tj@kernel.org>
References: <1363219098-16083-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

pwq_set_max_active() is gonna be modified and used during
pool_workqueue init.  Move it above init_and_link_pwq().

This patch is pure code reorganization and doesn't introduce any
functional changes.

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 kernel/workqueue.c | 40 ++++++++++++++++++++--------------------
 1 file changed, 20 insertions(+), 20 deletions(-)

diff --git a/kernel/workqueue.c b/kernel/workqueue.c
index f5c8bbb..d519289 100644
--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -3725,6 +3725,26 @@ static void pwq_unbound_release_workfn(struct work_struct *work)
 		kfree(wq);
 }
 
+/**
+ * pwq_set_max_active - adjust max_active of a pwq
+ * @pwq: target pool_workqueue
+ * @max_active: new max_active value.
+ *
+ * Set @pwq->max_active to @max_active and activate delayed works if
+ * increased.
+ *
+ * CONTEXT:
+ * spin_lock_irq(pool->lock).
+ */
+static void pwq_set_max_active(struct pool_workqueue *pwq, int max_active)
+{
+	pwq->max_active = max_active;
+
+	while (!list_empty(&pwq->delayed_works) &&
+	       pwq->nr_active < pwq->max_active)
+		pwq_activate_first_delayed(pwq);
+}
+
 static void init_and_link_pwq(struct pool_workqueue *pwq,
 			      struct workqueue_struct *wq,
 			      struct worker_pool *pool,
@@ -4012,26 +4032,6 @@ void destroy_workqueue(struct workqueue_struct *wq)
 EXPORT_SYMBOL_GPL(destroy_workqueue);
 
 /**
- * pwq_set_max_active - adjust max_active of a pwq
- * @pwq: target pool_workqueue
- * @max_active: new max_active value.
- *
- * Set @pwq->max_active to @max_active and activate delayed works if
- * increased.
- *
- * CONTEXT:
- * spin_lock_irq(pool->lock).
- */
-static void pwq_set_max_active(struct pool_workqueue *pwq, int max_active)
-{
-	pwq->max_active = max_active;
-
-	while (!list_empty(&pwq->delayed_works) &&
-	       pwq->nr_active < pwq->max_active)
-		pwq_activate_first_delayed(pwq);
-}
-
-/**
  * workqueue_set_max_active - adjust max_active of a workqueue
  * @wq: target workqueue
  * @max_active: new max_active value.
-- 
1.8.1.4

