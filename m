Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758562Ab3CDSaK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Mar 2013 13:30:10 -0500
Received: from mail-da0-f52.google.com ([209.85.210.52]:48523 "EHLO
	mail-da0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757248Ab3CDSaG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Mar 2013 13:30:06 -0500
Date: Mon, 4 Mar 2013 10:30:01 -0800
From: Tejun Heo <tj@kernel.org>
To: linux-kernel@vger.kernel.org, laijs@cn.fujitsu.com
Cc: axboe@kernel.dk, jmoyer@redhat.com, zab@redhat.com
Subject: [PATCH UPDATED 28/31] workqueue: reject adjusting max_active or
 applying attrs to ordered workqueues
Message-ID: <20130304183001.GG30413@htj.dyndns.org>
References: <1362194662-2344-1-git-send-email-tj@kernel.org>
 <1362194662-2344-29-git-send-email-tj@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1362194662-2344-29-git-send-email-tj@kernel.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adjusting max_active of or applying new workqueue_attrs to an ordered
workqueue breaks its ordering guarantee.  The former is obvious.  The
latter is because applying attrs creates a new pwq (pool_workqueue)
and there is no ordering constraint between the old and new pwqs.

Make apply_workqueue_attrs() and workqueue_set_max_active() trigger
WARN_ON() if those operations are requested on an ordered workqueue
and fail / ignore respectively.

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 include/linux/workqueue.h |    3 ++-
 kernel/workqueue.c        |    9 +++++++++
 2 files changed, 11 insertions(+), 1 deletion(-)

--- a/include/linux/workqueue.h
+++ b/include/linux/workqueue.h
@@ -294,6 +294,7 @@ enum {
 	WQ_CPU_INTENSIVE	= 1 << 5, /* cpu instensive workqueue */
 
 	__WQ_DRAINING		= 1 << 16, /* internal: workqueue is draining */
+	__WQ_ORDERED		= 1 << 17, /* internal: workqueue is ordered */
 
 	WQ_MAX_ACTIVE		= 512,	  /* I like 512, better ideas? */
 	WQ_MAX_UNBOUND_PER_CPU	= 4,	  /* 4 * #cpus for unbound wq */
@@ -396,7 +397,7 @@ __alloc_workqueue_key(const char *fmt, u
  * Pointer to the allocated workqueue on success, %NULL on failure.
  */
 #define alloc_ordered_workqueue(fmt, flags, args...)			\
-	alloc_workqueue(fmt, WQ_UNBOUND | (flags), 1, ##args)
+	alloc_workqueue(fmt, WQ_UNBOUND | __WQ_ORDERED | (flags), 1, ##args)
 
 #define create_workqueue(name)						\
 	alloc_workqueue((name), WQ_MEM_RECLAIM, 1)
--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -3487,9 +3487,14 @@ int apply_workqueue_attrs(struct workque
 	struct pool_workqueue *pwq, *last_pwq;
 	struct worker_pool *pool;
 
+	/* only unbound workqueues can change attributes */
 	if (WARN_ON(!(wq->flags & WQ_UNBOUND)))
 		return -EINVAL;
 
+	/* creating multiple pwqs breaks ordering guarantee */
+	if (WARN_ON((wq->flags & __WQ_ORDERED) && !list_empty(&wq->pwqs)))
+		return -EINVAL;
+
 	pwq = kmem_cache_zalloc(pwq_cache, GFP_KERNEL);
 	if (!pwq)
 		return -ENOMEM;
@@ -3745,6 +3750,10 @@ void workqueue_set_max_active(struct wor
 {
 	struct pool_workqueue *pwq;
 
+	/* disallow meddling with max_active for ordered workqueues */
+	if (WARN_ON(wq->flags & __WQ_ORDERED))
+		return;
+
 	max_active = wq_clamp_max_active(max_active, wq->flags, wq->name);
 
 	spin_lock_irq(&workqueue_lock);
