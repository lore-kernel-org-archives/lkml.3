Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752640AbaGVFDa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2014 01:03:30 -0400
Received: from cn.fujitsu.com ([59.151.112.132]:63818 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752508AbaGVFD3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2014 01:03:29 -0400
X-IronPort-AV: E=Sophos;i="5.00,931,1396972800"; 
   d="scan'208";a="33612989"
From: Lai Jiangshan <laijs@cn.fujitsu.com>
To: <linux-kernel@vger.kernel.org>
CC: Tejun Heo <tj@kernel.org>, Lai Jiangshan <laijs@cn.fujitsu.com>
Subject: [PATCH] workqueue: remove the stale comment in pwq_unbound_release_workfn()
Date: Tue, 22 Jul 2014 13:04:27 +0800
Message-ID: <1406005467-12106-1-git-send-email-laijs@cn.fujitsu.com>
X-Mailer: git-send-email 1.7.4.4
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.167.226.103]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In 75ccf5950f82 ("workqueue: prepare flush_workqueue() for dynamic
creation and destrucion of unbound pool_workqueues"), a comment
about the synchronization for the pwq in pwq_unbound_release_workfn()
was added. The comment clained the flush_mutex was isn't strictly
necessary, it was correct in that time, due to the pwq was protected
by workqueue_lock.

But it is incorrect now since the wq->flush_mutex was renamed to
wq->mutex and workqueue_lock was removed, the wq->mutex is strictly
needed. But the comment was miss-updated when the synchronization
was changed.

This patch removes the incorrect comments directly, and it doesn't
add any new comment to explain why wq->mutex is needed here,
which is definitely obvious and wq->pwqs_node has "WQ" notation
in its definition which is better comment.

The old commit mentioned above also introduced a comment in link_pwq()
about the synchronization. This comment is also removed in this patch
since the whole link_pwq() is proteced by wq->mutex.

Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
---
 kernel/workqueue.c |   10 +---------
 1 files changed, 1 insertions(+), 9 deletions(-)

diff --git a/kernel/workqueue.c b/kernel/workqueue.c
index 942103d9..b8990cf 100644
--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -3527,11 +3527,6 @@ static void pwq_unbound_release_workfn(struct work_struct *work)
 	if (WARN_ON_ONCE(!(wq->flags & WQ_UNBOUND)))
 		return;
 
-	/*
-	 * Unlink @pwq.  Synchronization against wq->mutex isn't strictly
-	 * necessary on release but do it anyway.  It's easier to verify
-	 * and consistent with the linking path.
-	 */
 	mutex_lock(&wq->mutex);
 	list_del_rcu(&pwq->pwqs_node);
 	is_last = list_empty(&wq->pwqs);
@@ -3628,10 +3623,7 @@ static void link_pwq(struct pool_workqueue *pwq)
 	if (!list_empty(&pwq->pwqs_node))
 		return;
 
-	/*
-	 * Set the matching work_color.  This is synchronized with
-	 * wq->mutex to avoid confusing flush_workqueue().
-	 */
+	/* Set the matching work_color.  */
 	pwq->work_color = wq->work_color;
 
 	/* sync max_active to the current setting */
-- 
1.7.4.4

