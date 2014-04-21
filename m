Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752019AbaDUL4H (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Apr 2014 07:56:07 -0400
Received: from cn.fujitsu.com ([59.151.112.132]:60774 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751836AbaDUL4F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Apr 2014 07:56:05 -0400
X-IronPort-AV: E=Sophos;i="4.97,896,1389715200"; 
   d="scan'208";a="29519611"
From: Lai Jiangshan <laijs@cn.fujitsu.com>
To: Tejun Heo <tj@kernel.org>, <linux-kernel@vger.kernel.org>
CC: Lai Jiangshan <laijs@cn.fujitsu.com>
Subject: [PATCH 2/2 V3] workqueue: simple refactor pwq_adjust_max_active()
Date: Mon, 21 Apr 2014 19:59:21 +0800
Message-ID: <1398081561-12618-2-git-send-email-laijs@cn.fujitsu.com>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1398081561-12618-1-git-send-email-laijs@cn.fujitsu.com>
References: <1398081561-12618-1-git-send-email-laijs@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.167.226.103]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Caculate the value(max_active) for pwq->max_active earlier.

Fast exit for max_active is not changed.
	"if (!freezable && pwq->max_active == wq->saved_max_active)" is hardly
	hit after __WQ_FREEZING was introduced. So we change the exit-condition
	to a more possible condition.

Reduce wake_up_worker() rate.

Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
---
 kernel/workqueue.c |   21 +++++++++++----------
 1 files changed, 11 insertions(+), 10 deletions(-)

diff --git a/kernel/workqueue.c b/kernel/workqueue.c
index beca98b..59bad6e 100644
--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -198,7 +198,7 @@ struct pool_workqueue {
 	int			nr_in_flight[WORK_NR_COLORS];
 						/* L: nr of in_flight works */
 	int			nr_active;	/* L: nr of active works */
-	int			max_active;	/* L: max active works */
+	int			max_active;	/* L&WQ: max active works */
 	struct list_head	delayed_works;	/* L: delayed works */
 	struct list_head	pwqs_node;	/* WR: node on wq->pwqs */
 	struct list_head	mayday_node;	/* MD: node on wq->maydays */
@@ -3756,20 +3756,23 @@ static void pwq_unbound_release_workfn(struct work_struct *work)
 static void pwq_adjust_max_active(struct pool_workqueue *pwq)
 {
 	struct workqueue_struct *wq = pwq->wq;
-	bool freezable = wq->flags & WQ_FREEZABLE;
+	int max_active = wq->saved_max_active;
 
 	/* for @wq->saved_max_active and @wq->flags */
 	lockdep_assert_held(&wq->mutex);
 
-	/* fast exit for non-freezable wqs */
-	if (!freezable && pwq->max_active == wq->saved_max_active)
+	if (wq->flags & __WQ_FREEZING) {
+		if (!WARN_ON_ONCE(!(wq->flags & WQ_FREEZABLE)))
+			max_active = 0;
+	}
+
+	/* fast exit for max_active is not changed */
+	if (pwq->max_active == max_active)
 		return;
 
 	spin_lock_irq(&pwq->pool->lock);
-
-	if (!freezable || !(wq->flags & __WQ_FREEZING)) {
-		pwq->max_active = wq->saved_max_active;
-
+	pwq->max_active = max_active;
+	if (pwq->nr_active < pwq->max_active) {
 		while (!list_empty(&pwq->delayed_works) &&
 		       pwq->nr_active < pwq->max_active)
 			pwq_activate_first_delayed(pwq);
@@ -3779,8 +3782,6 @@ static void pwq_adjust_max_active(struct pool_workqueue *pwq)
 		 * max_active is bumped.  It's a slow path.  Do it always.
 		 */
 		wake_up_worker(pwq->pool);
-	} else {
-		pwq->max_active = 0;
 	}
 
 	spin_unlock_irq(&pwq->pool->lock);
-- 
1.7.4.4

