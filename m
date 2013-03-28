Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755753Ab3C1G3y (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Mar 2013 02:29:54 -0400
Received: from mail-qc0-f171.google.com ([209.85.216.171]:63226 "EHLO
	mail-qc0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751253Ab3C1G3x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Mar 2013 02:29:53 -0400
Date: Wed, 27 Mar 2013 23:29:47 -0700
From: Tejun Heo <tj@kernel.org>
To: linux-kernel@vger.kernel.org, Lai Jiangshan <laijs@cn.fujitsu.com>
Subject: [PATCH 1/2] workqueue: fix race condition in unbound workqueue free
 path
Message-ID: <20130328062947.GA14088@htj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From b2277a4e655c0858da7d85b99f0925abeedc3b6c Mon Sep 17 00:00:00 2001
From: Tejun Heo <tj@kernel.org>
Date: Wed, 27 Mar 2013 23:27:41 -0700

8864b4e59 ("workqueue: implement get/put_pwq()") implemented pwq
(pool_workqueue) refcnting which frees workqueue when the last pwq
goes away.  It determined whether it was the last pwq by testing
wq->pwqs is empty.  Unfortunately, the test was done outside wq->mutex
and multiple pwq release could race and try to free wq multiple times
leading to oops.

Test wq->pwqs emptiness while holding wq->mutex.

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 kernel/workqueue.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/kernel/workqueue.c b/kernel/workqueue.c
index 04a8b98..4d34432 100644
--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -3534,6 +3534,7 @@ static void pwq_unbound_release_workfn(struct work_struct *work)
 						  unbound_release_work);
 	struct workqueue_struct *wq = pwq->wq;
 	struct worker_pool *pool = pwq->pool;
+	bool is_last;
 
 	if (WARN_ON_ONCE(!(wq->flags & WQ_UNBOUND)))
 		return;
@@ -3545,6 +3546,7 @@ static void pwq_unbound_release_workfn(struct work_struct *work)
 	 */
 	mutex_lock(&wq->mutex);
 	list_del_rcu(&pwq->pwqs_node);
+	is_last = list_empty(&wq->pwqs);
 	mutex_unlock(&wq->mutex);
 
 	put_unbound_pool(pool);
@@ -3554,7 +3556,7 @@ static void pwq_unbound_release_workfn(struct work_struct *work)
 	 * If we're the last pwq going away, @wq is already dead and no one
 	 * is gonna access it anymore.  Free it.
 	 */
-	if (list_empty(&wq->pwqs))
+	if (is_last)
 		kfree(wq);
 }
 
-- 
1.8.1.4

