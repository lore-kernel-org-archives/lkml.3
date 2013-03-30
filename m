Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757055Ab3C3RLm (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Mar 2013 13:11:42 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:32289 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1756871Ab3C3RLl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Mar 2013 13:11:41 -0400
X-IronPort-AV: E=Sophos;i="4.87,379,1363104000"; 
   d="scan'208";a="6974906"
From: Lai Jiangshan <laijs@cn.fujitsu.com>
To: Tejun Heo <tj@kernel.org>, linux-kernel@vger.kernel.org
Cc: Lai Jiangshan <laijs@cn.fujitsu.com>
Subject: [PATCH 2/2 tj/for-3.10] workqueue: modify wq->freezing only when freezable
Date: Sun, 31 Mar 2013 00:29:15 +0800
Message-Id: <1364660955-5217-2-git-send-email-laijs@cn.fujitsu.com>
X-Mailer: git-send-email 1.7.7.6
In-Reply-To: <1364660955-5217-1-git-send-email-laijs@cn.fujitsu.com>
References: <1364660955-5217-1-git-send-email-laijs@cn.fujitsu.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/03/31 00:28:43,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/03/31 00:28:44,
	Serialize complete at 2013/03/31 00:28:44
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

simplify pwq_adjust_max_active().
make freeze_workqueues_begin() and thaw_workqueues() fast skip non-freezable wq.

Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
---
 kernel/workqueue.c |   16 +++++++++-------
 1 files changed, 9 insertions(+), 7 deletions(-)

diff --git a/kernel/workqueue.c b/kernel/workqueue.c
index 6b7e5a4..0a38852 100644
--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -3566,18 +3566,15 @@ static void pwq_unbound_release_workfn(struct work_struct *work)
 static void pwq_adjust_max_active(struct pool_workqueue *pwq)
 {
 	struct workqueue_struct *wq = pwq->wq;
-	bool freezable = wq->flags & WQ_FREEZABLE;
 
 	/* for @wq->saved_max_active and @wq->freezing */
 	lockdep_assert_held(&wq->mutex);
-
-	/* fast exit for non-freezable wqs */
-	if (!freezable && pwq->max_active == wq->saved_max_active)
-		return;
+	if (WARN_ON_ONCE(!(wq->flags & WQ_FREEZABLE) && wq->freezing))
+		wq->freezing = false;
 
 	spin_lock_irq(&pwq->pool->lock);
 
-	if (!freezable || !wq->freezing) {
+	if (!wq->freezing) {
 		pwq->max_active = wq->saved_max_active;
 
 		while (!list_empty(&pwq->delayed_works) &&
@@ -3792,7 +3789,8 @@ struct workqueue_struct *__alloc_workqueue_key(const char *fmt,
 	mutex_lock(&wq_pool_mutex);
 
 	mutex_lock(&wq->mutex);
-	wq->freezing = workqueue_freezing;
+	if (wq->flags & WQ_FREEZABLE)
+		wq->freezing = workqueue_freezing;
 	for_each_pwq(pwq, wq)
 		pwq_adjust_max_active(pwq);
 	mutex_unlock(&wq->mutex);
@@ -4289,6 +4287,8 @@ void freeze_workqueues_begin(void)
 	workqueue_freezing = true;
 
 	list_for_each_entry(wq, &workqueues, list) {
+		if (!(wq->flags & WQ_FREEZABLE))
+			continue;
 		mutex_lock(&wq->mutex);
 		WARN_ON_ONCE(wq->freezing);
 		wq->freezing = true;
@@ -4367,6 +4367,8 @@ void thaw_workqueues(void)
 
 	/* restore max_active and repopulate worklist */
 	list_for_each_entry(wq, &workqueues, list) {
+		if (!(wq->flags & WQ_FREEZABLE))
+			continue;
 		mutex_lock(&wq->mutex);
 		wq->freezing = false;
 		for_each_pwq(pwq, wq)
-- 
1.7.7.6

