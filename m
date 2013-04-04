Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933031Ab3DDCGF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Apr 2013 22:06:05 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:53380 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S932840Ab3DDCF6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Apr 2013 22:05:58 -0400
X-IronPort-AV: E=Sophos;i="4.87,404,1363104000"; 
   d="scan'208";a="6998069"
From: Lai Jiangshan <laijs@cn.fujitsu.com>
To: Tejun Heo <tj@kernel.org>, linux-kernel@vger.kernel.org
Cc: Lai Jiangshan <laijs@cn.fujitsu.com>
Subject: [PATCH 2/7] workqueue: set __WQ_FREEZING only when freezable
Date: Thu, 4 Apr 2013 10:05:33 +0800
Message-Id: <1365041143-3088-2-git-send-email-laijs@cn.fujitsu.com>
X-Mailer: git-send-email 1.7.7.6
In-Reply-To: <1365041143-3088-1-git-send-email-laijs@cn.fujitsu.com>
References: <1365041143-3088-1-git-send-email-laijs@cn.fujitsu.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/04/04 10:04:55,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/04/04 10:04:55,
	Serialize complete at 2013/04/04 10:04:55
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

simplify pwq_adjust_max_active().
make freeze_workqueues_begin() and thaw_workqueues() fast skip non-freezable wq.

Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
---
 kernel/workqueue.c |   13 ++++++-------
 1 files changed, 6 insertions(+), 7 deletions(-)

diff --git a/kernel/workqueue.c b/kernel/workqueue.c
index e06a5b0..66a9d71 100644
--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -3644,18 +3644,13 @@ static void pwq_unbound_release_workfn(struct work_struct *work)
 static void pwq_adjust_max_active(struct pool_workqueue *pwq)
 {
 	struct workqueue_struct *wq = pwq->wq;
-	bool freezable = wq->flags & WQ_FREEZABLE;
 
 	/* for @wq->saved_max_active and @wq->flags */
 	lockdep_assert_held(&wq->mutex);
 
-	/* fast exit for non-freezable wqs */
-	if (!freezable && pwq->max_active == wq->saved_max_active)
-		return;
-
 	spin_lock_irq(&pwq->pool->lock);
 
-	if (!freezable || !(wq->flags & __WQ_FREEZING)) {
+	if (!(wq->flags & __WQ_FREEZING)) {
 		pwq->max_active = wq->saved_max_active;
 
 		while (!list_empty(&pwq->delayed_works) &&
@@ -4151,7 +4146,7 @@ struct workqueue_struct *__alloc_workqueue_key(const char *fmt,
 	mutex_lock(&wq_pool_mutex);
 
 	mutex_lock(&wq->mutex);
-	if (workqueue_freezing)
+	if ((wq->flags & WQ_FREEZABLE) && workqueue_freezing)
 		wq->flags |= __WQ_FREEZING;
 	for_each_pwq(pwq, wq)
 		pwq_adjust_max_active(pwq);
@@ -4677,6 +4672,8 @@ void freeze_workqueues_begin(void)
 	workqueue_freezing = true;
 
 	list_for_each_entry(wq, &workqueues, list) {
+		if (!(wq->flags & WQ_FREEZABLE))
+			continue;
 		mutex_lock(&wq->mutex);
 		WARN_ON_ONCE(wq->flags & __WQ_FREEZING);
 		wq->flags |= __WQ_FREEZING;
@@ -4755,6 +4752,8 @@ void thaw_workqueues(void)
 
 	/* restore max_active and repopulate worklist */
 	list_for_each_entry(wq, &workqueues, list) {
+		if (!(wq->flags & WQ_FREEZABLE))
+			continue;
 		mutex_lock(&wq->mutex);
 		wq->flags &= ~__WQ_FREEZING;
 		for_each_pwq(pwq, wq)
-- 
1.7.7.6

