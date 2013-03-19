Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933759Ab3CST3N (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Mar 2013 15:29:13 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:46591 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S933708Ab3CST3H (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Mar 2013 15:29:07 -0400
X-IronPort-AV: E=Sophos;i="4.84,874,1355068800"; 
   d="scan'208";a="6904515"
From: Lai Jiangshan <laijs@cn.fujitsu.com>
To: Tejun Heo <tj@kernel.org>, linux-kernel@vger.kernel.org
Cc: Lai Jiangshan <laijs@cn.fujitsu.com>
Subject: [PATCH 20/21] workqueue: modify wq->freezing only when freezable
Date: Wed, 20 Mar 2013 03:28:20 +0800
Message-Id: <1363721306-2030-21-git-send-email-laijs@cn.fujitsu.com>
X-Mailer: git-send-email 1.7.7.6
In-Reply-To: <1363721306-2030-1-git-send-email-laijs@cn.fujitsu.com>
References: <1363721306-2030-1-git-send-email-laijs@cn.fujitsu.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/03/20 03:27:41,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/03/20 03:27:41,
	Serialize complete at 2013/03/20 03:27:41
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

simplify pwq_adjust_max_active().
make freeze_workqueues_begin() and thaw_workqueues() fast skip non-freezable wq.

Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
---
 kernel/workqueue.c |   18 ++++++++++--------
 1 files changed, 10 insertions(+), 8 deletions(-)

diff --git a/kernel/workqueue.c b/kernel/workqueue.c
index 882fe87..ce8fd7b 100644
--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -3487,18 +3487,15 @@ static void pwq_unbound_release_workfn(struct work_struct *work)
 static void pwq_adjust_max_active(struct pool_workqueue *pwq)
 {
 	struct workqueue_struct *wq = pwq->wq;
-	bool freezable = wq->flags & WQ_FREEZABLE;
 
 	/* for @wq->saved_max_active and @wq->freezing */
 	lockdep_assert_held(&wq->mutex);
+	if (WARN_ON_ONCE(!(wq->flags & WQ_FREEZABLE) && wq->freezing))
+		wq->freezing = false;
 
-	/* fast exit for non-freezable wqs */
-	if (!freezable && pwq->max_active == wq->saved_max_active)
-		return;
-
-	if (freezable && wq->freezing) {
+	if (wq->freezing) {
 		pwq->max_active = 0;
-	} else {
+	} else if (pwq->max_active != wq->saved_max_active) {
 		spin_lock_irq(&pwq->pool->lock);
 		pwq->max_active = wq->saved_max_active;
 
@@ -3711,7 +3708,8 @@ struct workqueue_struct *__alloc_workqueue_key(const char *fmt,
 	mutex_lock(&wqs_mutex);
 
 	mutex_lock(&wq->mutex);
-	wq->freezing = workqueue_freezing;
+	if (wq->flags & WQ_FREEZABLE)
+		wq->freezing = workqueue_freezing;
 	for_each_pwq(pwq, wq)
 		pwq_adjust_max_active(pwq);
 	mutex_unlock(&wq->mutex);
@@ -4206,6 +4204,8 @@ void freeze_workqueues_begin(void)
 	workqueue_freezing = true;
 
 	list_for_each_entry(wq, &workqueues, list) {
+		if (!(wq->flags & WQ_FREEZABLE))
+			continue;
 		mutex_lock(&wq->mutex);
 		/* set FREEZING */
 		WARN_ON_ONCE(wq->freezing);
@@ -4286,6 +4286,8 @@ void thaw_workqueues(void)
 	workqueue_freezing = false;
 
 	list_for_each_entry(wq, &workqueues, list) {
+		if (!(wq->flags & WQ_FREEZABLE))
+			continue;
 		mutex_lock(&wq->mutex);
 		/* clear FREEZING */
 		WARN_ON_ONCE(!wq->freezing);
-- 
1.7.7.6

