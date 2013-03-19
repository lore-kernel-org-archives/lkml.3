Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933452Ab3CST2y (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Mar 2013 15:28:54 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:2827 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S933334Ab3CST2w (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Mar 2013 15:28:52 -0400
X-IronPort-AV: E=Sophos;i="4.84,874,1355068800"; 
   d="scan'208";a="6904504"
From: Lai Jiangshan <laijs@cn.fujitsu.com>
To: Tejun Heo <tj@kernel.org>, linux-kernel@vger.kernel.org
Cc: Lai Jiangshan <laijs@cn.fujitsu.com>
Subject: [PATCH 09/21] workqueue: use wq->mutex to protects ->nr_drainers and __WQ_DRAINING
Date: Wed, 20 Mar 2013 03:28:09 +0800
Message-Id: <1363721306-2030-10-git-send-email-laijs@cn.fujitsu.com>
X-Mailer: git-send-email 1.7.7.6
In-Reply-To: <1363721306-2030-1-git-send-email-laijs@cn.fujitsu.com>
References: <1363721306-2030-1-git-send-email-laijs@cn.fujitsu.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/03/20 03:27:26,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/03/20 03:27:26,
	Serialize complete at 2013/03/20 03:27:26
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

wq->nr_drainers is not workqueueS related field, it is just a field for
its own workqueue, it is not for all workqueueS.

convert it to protected by wq->mutex.

Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
---
 kernel/workqueue.c |   12 ++++++------
 1 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/kernel/workqueue.c b/kernel/workqueue.c
index 4ae6ba7..ad190cd 100644
--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -228,7 +228,7 @@ struct wq_device;
  * the appropriate worker_pool through its pool_workqueues.
  */
 struct workqueue_struct {
-	unsigned int		flags;		/* QS: WQ_* flags */
+	unsigned int		flags;		/* Q: WQ_* flags */
 	struct pool_workqueue __percpu *cpu_pwqs; /* I: per-cpu pwq's */
 	struct list_head	pwqs;		/* QR: all pwqs of this wq */
 	struct list_head	list;		/* QS: list of all workqueues */
@@ -244,7 +244,7 @@ struct workqueue_struct {
 	struct list_head	maydays;	/* MD: pwqs requesting rescue */
 	struct worker		*rescuer;	/* I: rescue worker */
 
-	int			nr_drainers;	/* QS: drain in progress */
+	int			nr_drainers;	/* Q: drain in progress */
 	int			saved_max_active; /* PW: saved pwq max_active */
 
 #ifdef CONFIG_SYSFS
@@ -2686,10 +2686,10 @@ void drain_workqueue(struct workqueue_struct *wq)
 	 * hotter than drain_workqueue() and already looks at @wq->flags.
 	 * Use __WQ_DRAINING so that queue doesn't have to check nr_drainers.
 	 */
-	mutex_lock(&wqs_mutex);
+	mutex_lock(&wq->mutex);
 	if (!wq->nr_drainers++)
 		wq->flags |= __WQ_DRAINING;
-	mutex_unlock(&wqs_mutex);
+	mutex_unlock(&wq->mutex);
 reflush:
 	flush_workqueue(wq);
 
@@ -2716,10 +2716,10 @@ reflush:
 
 	local_irq_enable();
 
-	mutex_lock(&wqs_mutex);
+	mutex_lock(&wq->mutex);
 	if (!--wq->nr_drainers)
 		wq->flags &= ~__WQ_DRAINING;
-	mutex_unlock(&wqs_mutex);
+	mutex_unlock(&wq->mutex);
 }
 EXPORT_SYMBOL_GPL(drain_workqueue);
 
-- 
1.7.7.6

