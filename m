Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933756Ab3CSTaE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Mar 2013 15:30:04 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:14097 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1757317Ab3CST3G (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Mar 2013 15:29:06 -0400
X-IronPort-AV: E=Sophos;i="4.84,874,1355068800"; 
   d="scan'208";a="6904514"
From: Lai Jiangshan <laijs@cn.fujitsu.com>
To: Tejun Heo <tj@kernel.org>, linux-kernel@vger.kernel.org
Cc: Lai Jiangshan <laijs@cn.fujitsu.com>
Subject: [PATCH 19/21] workqueue: remove @p_last_pwq from init_and_link_pwq()
Date: Wed, 20 Mar 2013 03:28:19 +0800
Message-Id: <1363721306-2030-20-git-send-email-laijs@cn.fujitsu.com>
X-Mailer: git-send-email 1.7.7.6
In-Reply-To: <1363721306-2030-1-git-send-email-laijs@cn.fujitsu.com>
References: <1363721306-2030-1-git-send-email-laijs@cn.fujitsu.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/03/20 03:27:40,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/03/20 03:27:40,
	Serialize complete at 2013/03/20 03:27:40
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

make init_and_link_pwq() simplier.

Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
---
 kernel/workqueue.c |   19 +++++++++----------
 1 files changed, 9 insertions(+), 10 deletions(-)

diff --git a/kernel/workqueue.c b/kernel/workqueue.c
index 0c692d4..882fe87 100644
--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -3519,10 +3519,10 @@ static void pwq_adjust_max_active(struct pool_workqueue *pwq)
 
 static void init_and_link_pwq(struct pool_workqueue *pwq,
 			      struct workqueue_struct *wq,
-			      struct worker_pool *pool,
-			      struct pool_workqueue **p_last_pwq)
+			      struct worker_pool *pool)
 {
 	BUG_ON((unsigned long)pwq & WORK_STRUCT_FLAG_MASK);
+	lockdep_assert_held(&wq->mutex);
 
 	pwq->pool = pool;
 	pwq->wq = wq;
@@ -3532,14 +3532,10 @@ static void init_and_link_pwq(struct pool_workqueue *pwq,
 	INIT_LIST_HEAD(&pwq->mayday_node);
 	INIT_WORK(&pwq->unbound_release_work, pwq_unbound_release_workfn);
 
-	mutex_lock(&wq->mutex);
-
 	/*
 	 * Set the matching work_color.  This is synchronized with
 	 * wq->mutex to avoid confusing flush_workqueue().
 	 */
-	if (p_last_pwq)
-		*p_last_pwq = first_pwq(wq);
 	pwq->work_color = wq->work_color;
 
 	/* sync max_active to the current setting */
@@ -3547,8 +3543,6 @@ static void init_and_link_pwq(struct pool_workqueue *pwq,
 
 	/* link in @pwq */
 	list_add_rcu(&pwq->pwqs_node, &wq->pwqs);
-
-	mutex_unlock(&wq->mutex);
 }
 
 /**
@@ -3589,12 +3583,15 @@ int apply_workqueue_attrs(struct workqueue_struct *wq,
 		return -ENOMEM;
 	}
 
-	init_and_link_pwq(pwq, wq, pool, &last_pwq);
+	mutex_lock(&wq->mutex);
+	last_pwq = first_pwq(wq);
+	init_and_link_pwq(pwq, wq, pool);
 	if (last_pwq) {
 		spin_lock_irq(&last_pwq->pool->lock);
 		put_pwq(last_pwq);
 		spin_unlock_irq(&last_pwq->pool->lock);
 	}
+	mutex_unlock(&wq->mutex);
 
 	return 0;
 }
@@ -3609,14 +3606,16 @@ static int alloc_and_link_pwqs(struct workqueue_struct *wq)
 		if (!wq->cpu_pwqs)
 			return -ENOMEM;
 
+		mutex_lock(&wq->mutex);
 		for_each_possible_cpu(cpu) {
 			struct pool_workqueue *pwq =
 				per_cpu_ptr(wq->cpu_pwqs, cpu);
 			struct worker_pool *cpu_pools =
 				per_cpu(cpu_worker_pools, cpu);
 
-			init_and_link_pwq(pwq, wq, &cpu_pools[highpri], NULL);
+			init_and_link_pwq(pwq, wq, &cpu_pools[highpri]);
 		}
+		mutex_unlock(&wq->mutex);
 		return 0;
 	} else {
 		return apply_workqueue_attrs(wq, unbound_std_wq_attrs[highpri]);
-- 
1.7.7.6

