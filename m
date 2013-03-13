Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934513Ab3CMX6x (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Mar 2013 19:58:53 -0400
Received: from mail-qc0-f176.google.com ([209.85.216.176]:57516 "EHLO
	mail-qc0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934446Ab3CMX6a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Mar 2013 19:58:30 -0400
From: Tejun Heo <tj@kernel.org>
To: linux-kernel@vger.kernel.org
Cc: laijs@cn.fujitsu.com, Tejun Heo <tj@kernel.org>
Subject: [PATCH 3/6] workqueue: fix max_active handling in init_and_link_pwq()
Date: Wed, 13 Mar 2013 16:58:15 -0700
Message-Id: <1363219098-16083-4-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1363219098-16083-1-git-send-email-tj@kernel.org>
References: <1363219098-16083-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since 9e8cd2f589 ("workqueue: implement apply_workqueue_attrs()"),
init_and_link_pwq() may be called to initialize a new pool_workqueue
for a workqueue which is already online, but the function was setting
pwq->max_active to wq->saved_max_active without proper
synchronization.

Fix it by calling pwq_adjust_max_active() under proper locking instead
of manually setting max_active.

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 kernel/workqueue.c | 14 +++++++++-----
 1 file changed, 9 insertions(+), 5 deletions(-)

diff --git a/kernel/workqueue.c b/kernel/workqueue.c
index 9e2ec4c..7567614 100644
--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -3771,21 +3771,25 @@ static void init_and_link_pwq(struct pool_workqueue *pwq,
 	pwq->wq = wq;
 	pwq->flush_color = -1;
 	pwq->refcnt = 1;
-	pwq->max_active = wq->saved_max_active;
 	INIT_LIST_HEAD(&pwq->delayed_works);
 	INIT_LIST_HEAD(&pwq->mayday_node);
 	INIT_WORK(&pwq->unbound_release_work, pwq_unbound_release_workfn);
 
-	/*
-	 * Link @pwq and set the matching work_color.  This is synchronized
-	 * with flush_mutex to avoid confusing flush_workqueue().
-	 */
 	mutex_lock(&wq->flush_mutex);
 	spin_lock_irq(&workqueue_lock);
 
+	/*
+	 * Set the matching work_color.  This is synchronized with
+	 * flush_mutex to avoid confusing flush_workqueue().
+	 */
 	if (p_last_pwq)
 		*p_last_pwq = first_pwq(wq);
 	pwq->work_color = wq->work_color;
+
+	/* sync max_active to the current setting */
+	pwq_adjust_max_active(pwq);
+
+	/* link in @pwq */
 	list_add_rcu(&pwq->pwqs_node, &wq->pwqs);
 
 	spin_unlock_irq(&workqueue_lock);
-- 
1.8.1.4

