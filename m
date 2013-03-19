Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933188Ab3CST2s (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Mar 2013 15:28:48 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:44169 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S932983Ab3CST2q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Mar 2013 15:28:46 -0400
X-IronPort-AV: E=Sophos;i="4.84,874,1355068800"; 
   d="scan'208";a="6904500"
From: Lai Jiangshan <laijs@cn.fujitsu.com>
To: Tejun Heo <tj@kernel.org>, linux-kernel@vger.kernel.org
Cc: Lai Jiangshan <laijs@cn.fujitsu.com>
Subject: [PATCH 05/21] workqueue: kick workers in pwq_adjust_max_active()
Date: Wed, 20 Mar 2013 03:28:05 +0800
Message-Id: <1363721306-2030-6-git-send-email-laijs@cn.fujitsu.com>
X-Mailer: git-send-email 1.7.7.6
In-Reply-To: <1363721306-2030-1-git-send-email-laijs@cn.fujitsu.com>
References: <1363721306-2030-1-git-send-email-laijs@cn.fujitsu.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/03/20 03:27:19,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/03/20 03:27:19,
	Serialize complete at 2013/03/20 03:27:19
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

if pwq_adjust_max_active() changes max_active from 0 to saved_max_active,
it needs to wakeup worker. This action is already done by thaw_workqueues().

if pwq_adjust_max_active() increase the max_active for unbound wq,
it also needs to wakeup worker. This action is missing.

To make these two cases happy, we move kicking workers code from
thaw_workqueues() to pwq_adjust_max_active().

It also makes thaw_workqueues() simpler.

Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
---
 kernel/workqueue.c |   15 ++++++++-------
 1 files changed, 8 insertions(+), 7 deletions(-)

diff --git a/kernel/workqueue.c b/kernel/workqueue.c
index 8c882ae..fb81159 100644
--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -3600,6 +3600,14 @@ static void pwq_adjust_max_active(struct pool_workqueue *pwq)
 		while (!list_empty(&pwq->delayed_works) &&
 		       pwq->nr_active < pwq->max_active)
 			pwq_activate_first_delayed(pwq);
+
+		/*
+		 * Need to wake up worker in any of these cases:
+		 *	wq is just thawed
+		 *	unbound wq's max_active is just increased
+		 * But this function is slowpath, wake up worker unconditionally
+		 */
+		wake_up_worker(pwq->pool);
 	}
 
 	spin_unlock(&pwq->pool->lock);
@@ -4401,13 +4409,6 @@ void thaw_workqueues(void)
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
1.7.7.6

