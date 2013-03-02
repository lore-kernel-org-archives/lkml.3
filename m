Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753219Ab3CBD0j (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Mar 2013 22:26:39 -0500
Received: from mail-da0-f47.google.com ([209.85.210.47]:54332 "EHLO
	mail-da0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752300Ab3CBDZQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Mar 2013 22:25:16 -0500
From: Tejun Heo <tj@kernel.org>
To: linux-kernel@vger.kernel.org, laijs@cn.fujitsu.com
Cc: axboe@kernel.dk, jmoyer@redhat.com, zab@redhat.com,
        Tejun Heo <tj@kernel.org>
Subject: [PATCH 28/31] workqueue: reject increasing max_active for ordered workqueues
Date: Fri,  1 Mar 2013 19:24:19 -0800
Message-Id: <1362194662-2344-29-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1362194662-2344-1-git-send-email-tj@kernel.org>
References: <1362194662-2344-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Workqueue will soon allow exposing control knobs to userland via
sysfs.  Increasing max_active for an ordered workqueue breaks
correctness.  Tag ordered workqueues with __WQ_ORDERED and always
limit max_active at 1.

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 include/linux/workqueue.h |  3 ++-
 kernel/workqueue.c        | 11 ++++++++++-
 2 files changed, 12 insertions(+), 2 deletions(-)

diff --git a/include/linux/workqueue.h b/include/linux/workqueue.h
index fc7f882..e1e5748 100644
--- a/include/linux/workqueue.h
+++ b/include/linux/workqueue.h
@@ -294,6 +294,7 @@ enum {
 	WQ_CPU_INTENSIVE	= 1 << 5, /* cpu instensive workqueue */
 
 	__WQ_DRAINING		= 1 << 16, /* internal: workqueue is draining */
+	__WQ_ORDERED		= 1 << 17, /* internal: workqueue is ordered */
 
 	WQ_MAX_ACTIVE		= 512,	  /* I like 512, better ideas? */
 	WQ_MAX_UNBOUND_PER_CPU	= 4,	  /* 4 * #cpus for unbound wq */
@@ -396,7 +397,7 @@ __alloc_workqueue_key(const char *fmt, unsigned int flags, int max_active,
  * Pointer to the allocated workqueue on success, %NULL on failure.
  */
 #define alloc_ordered_workqueue(fmt, flags, args...)			\
-	alloc_workqueue(fmt, WQ_UNBOUND | (flags), 1, ##args)
+	alloc_workqueue(fmt, WQ_UNBOUND | __WQ_ORDERED | (flags), 1, ##args)
 
 #define create_workqueue(name)						\
 	alloc_workqueue((name), WQ_MEM_RECLAIM, 1)
diff --git a/kernel/workqueue.c b/kernel/workqueue.c
index 2016c9e..8d487f6 100644
--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -3537,7 +3537,16 @@ static int alloc_and_link_pwqs(struct workqueue_struct *wq)
 static int wq_clamp_max_active(int max_active, unsigned int flags,
 			       const char *name)
 {
-	int lim = flags & WQ_UNBOUND ? WQ_UNBOUND_MAX_ACTIVE : WQ_MAX_ACTIVE;
+	int lim;
+
+	if (flags & WQ_UNBOUND) {
+		if (flags & __WQ_ORDERED)
+			lim = 1;
+		else
+			lim = WQ_UNBOUND_MAX_ACTIVE;
+	} else {
+		lim = WQ_MAX_ACTIVE;
+	}
 
 	if (max_active < 1 || max_active > lim)
 		pr_warn("workqueue: max_active %d requested for %s is out of range, clamping between %d and %d\n",
-- 
1.8.1.2

