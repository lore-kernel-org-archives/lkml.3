Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753031Ab3CBDZV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Mar 2013 22:25:21 -0500
Received: from mail-da0-f54.google.com ([209.85.210.54]:34094 "EHLO
	mail-da0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752292Ab3CBDZO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Mar 2013 22:25:14 -0500
From: Tejun Heo <tj@kernel.org>
To: linux-kernel@vger.kernel.org, laijs@cn.fujitsu.com
Cc: axboe@kernel.dk, jmoyer@redhat.com, zab@redhat.com,
        Tejun Heo <tj@kernel.org>
Subject: [PATCH 27/31] workqueue: make it clear that WQ_DRAINING is an internal flag
Date: Fri,  1 Mar 2013 19:24:18 -0800
Message-Id: <1362194662-2344-28-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1362194662-2344-1-git-send-email-tj@kernel.org>
References: <1362194662-2344-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We're gonna add another internal WQ flag.  Let's make the distinction
clear.  Prefix WQ_DRAINING with __ and move it to bit 16.

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 include/linux/workqueue.h | 2 +-
 kernel/workqueue.c        | 8 ++++----
 2 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/include/linux/workqueue.h b/include/linux/workqueue.h
index c8c3bf4..fc7f882 100644
--- a/include/linux/workqueue.h
+++ b/include/linux/workqueue.h
@@ -293,7 +293,7 @@ enum {
 	WQ_HIGHPRI		= 1 << 4, /* high priority */
 	WQ_CPU_INTENSIVE	= 1 << 5, /* cpu instensive workqueue */
 
-	WQ_DRAINING		= 1 << 6, /* internal: workqueue is draining */
+	__WQ_DRAINING		= 1 << 16, /* internal: workqueue is draining */
 
 	WQ_MAX_ACTIVE		= 512,	  /* I like 512, better ideas? */
 	WQ_MAX_UNBOUND_PER_CPU	= 4,	  /* 4 * #cpus for unbound wq */
diff --git a/kernel/workqueue.c b/kernel/workqueue.c
index 36fcf9c..2016c9e 100644
--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -1222,7 +1222,7 @@ static void __queue_work(int cpu, struct workqueue_struct *wq,
 	debug_work_activate(work);
 
 	/* if dying, only works from the same workqueue are allowed */
-	if (unlikely(wq->flags & WQ_DRAINING) &&
+	if (unlikely(wq->flags & __WQ_DRAINING) &&
 	    WARN_ON_ONCE(!is_chained_work(wq)))
 		return;
 retry:
@@ -2761,11 +2761,11 @@ void drain_workqueue(struct workqueue_struct *wq)
 	/*
 	 * __queue_work() needs to test whether there are drainers, is much
 	 * hotter than drain_workqueue() and already looks at @wq->flags.
-	 * Use WQ_DRAINING so that queue doesn't have to check nr_drainers.
+	 * Use __WQ_DRAINING so that queue doesn't have to check nr_drainers.
 	 */
 	spin_lock_irq(&workqueue_lock);
 	if (!wq->nr_drainers++)
-		wq->flags |= WQ_DRAINING;
+		wq->flags |= __WQ_DRAINING;
 	spin_unlock_irq(&workqueue_lock);
 reflush:
 	flush_workqueue(wq);
@@ -2793,7 +2793,7 @@ reflush:
 
 	spin_lock(&workqueue_lock);
 	if (!--wq->nr_drainers)
-		wq->flags &= ~WQ_DRAINING;
+		wq->flags &= ~__WQ_DRAINING;
 	spin_unlock(&workqueue_lock);
 
 	local_irq_enable();
-- 
1.8.1.2

