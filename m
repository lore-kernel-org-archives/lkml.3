Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933970Ab3CZAI7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Mar 2013 20:08:59 -0400
Received: from mail-ve0-f176.google.com ([209.85.128.176]:60669 "EHLO
	mail-ve0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759148Ab3CZAHr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Mar 2013 20:07:47 -0400
From: Tejun Heo <tj@kernel.org>
To: laijs@cn.fujitsu.com
Cc: linux-kernel@vger.kernel.org, js1304@gmail.com, Tejun Heo <tj@kernel.org>
Subject: [PATCH 3/6] workqueue: protect wq->nr_drainers and ->flags with wq->mutex
Date: Mon, 25 Mar 2013 17:07:26 -0700
Message-Id: <1364256449-11401-4-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1364256449-11401-1-git-send-email-tj@kernel.org>
References: <1364256449-11401-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Lai Jiangshan <laijs@cn.fujitsu.com>

We're expanding wq->mutex to cover all fields specific to each
workqueue with the end goal of replacing pwq_lock which will make
locking simpler and easier to understand.

wq->nr_drainers and ->flags are specific to each workqueue.  Protect
->nr_drainers and ->flags with wq->mutex instead of pool_mutex.

tj: Rebased on top of the current dev branch.  Updated description.

Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
Signed-off-by: Tejun Heo <tj@kernel.org>
---
 kernel/workqueue.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/kernel/workqueue.c b/kernel/workqueue.c
index d448eda..3ac2c4d 100644
--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -226,7 +226,7 @@ struct wq_device;
  * the appropriate worker_pool through its pool_workqueues.
  */
 struct workqueue_struct {
-	unsigned int		flags;		/* PL: WQ_* flags */
+	unsigned int		flags;		/* WQ: WQ_* flags */
 	struct pool_workqueue __percpu *cpu_pwqs; /* I: per-cpu pwq's */
 	struct list_head	pwqs;		/* WR: all pwqs of this wq */
 	struct list_head	list;		/* PL: list of all workqueues */
@@ -242,7 +242,7 @@ struct workqueue_struct {
 	struct list_head	maydays;	/* MD: pwqs requesting rescue */
 	struct worker		*rescuer;	/* I: rescue worker */
 
-	int			nr_drainers;	/* PL: drain in progress */
+	int			nr_drainers;	/* WQ: drain in progress */
 	int			saved_max_active; /* PW: saved pwq max_active */
 
 #ifdef CONFIG_SYSFS
@@ -2684,10 +2684,10 @@ void drain_workqueue(struct workqueue_struct *wq)
 	 * hotter than drain_workqueue() and already looks at @wq->flags.
 	 * Use __WQ_DRAINING so that queue doesn't have to check nr_drainers.
 	 */
-	mutex_lock(&wq_pool_mutex);
+	mutex_lock(&wq->mutex);
 	if (!wq->nr_drainers++)
 		wq->flags |= __WQ_DRAINING;
-	mutex_unlock(&wq_pool_mutex);
+	mutex_unlock(&wq->mutex);
 reflush:
 	flush_workqueue(wq);
 
@@ -2714,10 +2714,10 @@ reflush:
 
 	local_irq_enable();
 
-	mutex_lock(&wq_pool_mutex);
+	mutex_lock(&wq->mutex);
 	if (!--wq->nr_drainers)
 		wq->flags &= ~__WQ_DRAINING;
-	mutex_unlock(&wq_pool_mutex);
+	mutex_unlock(&wq->mutex);
 }
 EXPORT_SYMBOL_GPL(drain_workqueue);
 
-- 
1.8.1.4

