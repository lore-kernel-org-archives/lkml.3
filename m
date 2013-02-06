Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758465Ab3BFXC7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Feb 2013 18:02:59 -0500
Received: from mail-ia0-f172.google.com ([209.85.210.172]:53979 "EHLO
	mail-ia0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758246Ab3BFXC4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Feb 2013 18:02:56 -0500
Date: Wed, 6 Feb 2013 15:02:50 -0800
From: Tejun Heo <tj@kernel.org>
To: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH wq/for-3.9] workqueue: make work_busy() test
 WORK_STRUCT_PENDING first
Message-ID: <20130206230250.GF2875@htj.dyndns.org>
References: <1359657696-2767-1-git-send-email-laijs@cn.fujitsu.com>
 <1359657696-2767-3-git-send-email-laijs@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1359657696-2767-3-git-send-email-laijs@cn.fujitsu.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Lai Jiangshan <laijs@cn.fujitsu.com>

Currently, work_busy() first tests whether the work has a pool
associated with it and if not, considers it idle.  This works fine
even for delayed_work.work queued on timer, as __queue_delayed_work()
sets cwq on delayed_work.work - a queued delayed_work always has its
cwq and thus pool associated with it.

However, we're about to update delayed_work queueing and this won't
hold.  Update work_busy() such that it tests WORK_STRUCT_PENDING
before the associated pool.  This doesn't make any noticeable behavior
difference now.

With work_pending() test moved, the function read a lot better with
"if (!pool)" test flipped to positive.  Flip it.

While at it, lose the comment about now non-existent reentrant
workqueues.

tj: Reorganized the function and rewrote the description.

Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
Signed-off-by: Tejun Heo <tj@kernel.org>
---
Hey, Lai.

Did I get the reason right?  Can you *please* try to explain "why" a
patch is needed / beneficial for future postings like I did above?  I
get that writing in English could be a bit stressful (it's not my
mother tongue either and I struggled with it a lot and still do to
certain extent) but the language doesn't have to be perfect.  You just
need to communicate main points of your rationale somehow.

Thanks.

 kernel/workqueue.c |   16 ++++++----------
 1 file changed, 6 insertions(+), 10 deletions(-)

--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -3443,8 +3443,6 @@ EXPORT_SYMBOL_GPL(workqueue_congested);
  * Test whether @work is currently pending or running.  There is no
  * synchronization around this function and the test result is
  * unreliable and only useful as advisory hints or for debugging.
- * Especially for reentrant wqs, the pending state might hide the
- * running state.
  *
  * RETURNS:
  * OR'd bitmask of WORK_BUSY_* bits.
@@ -3455,17 +3453,15 @@ unsigned int work_busy(struct work_struc
 	unsigned long flags;
 	unsigned int ret = 0;
 
-	if (!pool)
-		return 0;
-
-	spin_lock_irqsave(&pool->lock, flags);
-
 	if (work_pending(work))
 		ret |= WORK_BUSY_PENDING;
-	if (find_worker_executing_work(pool, work))
-		ret |= WORK_BUSY_RUNNING;
 
-	spin_unlock_irqrestore(&pool->lock, flags);
+	if (pool) {
+		spin_lock_irqsave(&pool->lock, flags);
+		if (find_worker_executing_work(pool, work))
+			ret |= WORK_BUSY_RUNNING;
+		spin_unlock_irqrestore(&pool->lock, flags);
+	}
 
 	return ret;
 }
