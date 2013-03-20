Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755844Ab3CTR4m (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Mar 2013 13:56:42 -0400
Received: from mail-vb0-f49.google.com ([209.85.212.49]:46851 "EHLO
	mail-vb0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752406Ab3CTR4k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Mar 2013 13:56:40 -0400
Date: Wed, 20 Mar 2013 10:56:33 -0700
From: Tejun Heo <tj@kernel.org>
To: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] workqueue: kick a worker in pwq_adjust_max_active()
Message-ID: <20130320175633.GA29523@htj.dyndns.org>
References: <1363721306-2030-1-git-send-email-laijs@cn.fujitsu.com>
 <1363721306-2030-6-git-send-email-laijs@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1363721306-2030-6-git-send-email-laijs@cn.fujitsu.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From 951a078a5285ad31bc22e190616ad54b78fac992 Mon Sep 17 00:00:00 2001
From: Lai Jiangshan <laijs@cn.fujitsu.com>
Date: Wed, 20 Mar 2013 10:52:30 -0700

If pwq_adjust_max_active() changes max_active from 0 to
saved_max_active, it needs to wakeup worker.  This is already done by
thaw_workqueues().

If pwq_adjust_max_active() increases max_active for an unbound wq,
while not strictly necessary for correctness, it's still desirable to
wake up a worker so that the requested concurrency level is reached
sooner.

Move wake_up_worker() call from thaw_workqueues() to
pwq_adjust_max_active() so that it can handle both of the above two
cases.  This also makes thaw_workqueues() simpler.

tj: Updated comments and description.

Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
Signed-off-by: Tejun Heo <tj@kernel.org>
---
 kernel/workqueue.c | 13 ++++++-------
 1 file changed, 6 insertions(+), 7 deletions(-)

diff --git a/kernel/workqueue.c b/kernel/workqueue.c
index d2ac6cb..79d1d34 100644
--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -3598,6 +3598,12 @@ static void pwq_adjust_max_active(struct pool_workqueue *pwq)
 		while (!list_empty(&pwq->delayed_works) &&
 		       pwq->nr_active < pwq->max_active)
 			pwq_activate_first_delayed(pwq);
+
+		/*
+		 * Need to kick a worker after thawed or an unbound wq's
+		 * max_active is bumped.  It's a slow path.  Do it always.
+		 */
+		wake_up_worker(pwq->pool);
 	} else {
 		pwq->max_active = 0;
 	}
@@ -4401,13 +4407,6 @@ void thaw_workqueues(void)
 	}
 	spin_unlock_irq(&pwq_lock);
 
-	/* kick workers */
-	for_each_pool(pool, pi) {
-		spin_lock_irq(&pool->lock);
-		wake_up_worker(pool);
-		spin_unlock_irq(&pool->lock);
-	}
-
 	workqueue_freezing = false;
 out_unlock:
 	mutex_unlock(&wq_mutex);
-- 
1.8.1.4

