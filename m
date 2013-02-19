Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934064Ab3BSUW6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Feb 2013 15:22:58 -0500
Received: from mail-pb0-f44.google.com ([209.85.160.44]:37666 "EHLO
	mail-pb0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932738Ab3BSUW5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Feb 2013 15:22:57 -0500
Date: Tue, 19 Feb 2013 12:22:53 -0800
From: Tejun Heo <tj@kernel.org>
To: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 4/4] workqueue: better define synchronization rule around
 rescuer->pool updates
Message-ID: <20130219202253.GX17414@htj.dyndns.org>
References: <1361203940-6300-1-git-send-email-laijs@cn.fujitsu.com>
 <1361203940-6300-9-git-send-email-laijs@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1361203940-6300-9-git-send-email-laijs@cn.fujitsu.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From 7bceeff75e5599f5c026797229d897f518dc028e Mon Sep 17 00:00:00 2001
From: Lai Jiangshan <laijs@cn.fujitsu.com>
Date: Tue, 19 Feb 2013 12:17:02 -0800

Rescuers visit different worker_pools to process work items from pools
under pressure.  Currently, rescuer->pool is updated outside any
locking and when an outsider looks at a rescuer, there's no way to
tell when and whether rescuer->pool is gonna change.  While this
doesn't currently cause any problem, it is nasty.

With recent worker_maybe_bind_and_lock() changes, we can move
rescuer->pool updates inside pool locks such that if rescuer->pool
equals a locked pool, it's guaranteed to stay that way until the pool
is unlocked.

Move rescuer->pool inside pool->lock.

This patch doesn't introduce any visible behavior difference.

tj: Updated the description.

Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
Signed-off-by: Tejun Heo <tj@kernel.org>
---
Applied to wq/for-3.10-tmp.  Note that I'm gonna reabse the branch
once 3.9-rc1 is out.

Thanks.

 kernel/workqueue.c          | 3 ++-
 kernel/workqueue_internal.h | 1 +
 2 files changed, 3 insertions(+), 1 deletion(-)

diff --git a/kernel/workqueue.c b/kernel/workqueue.c
index 1770b09..0b1e6f2 100644
--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -2359,8 +2359,8 @@ repeat:
 		mayday_clear_cpu(cpu, wq->mayday_mask);
 
 		/* migrate to the target cpu if possible */
-		rescuer->pool = pool;
 		worker_maybe_bind_and_lock(pool);
+		rescuer->pool = pool;
 
 		/*
 		 * Slurp in all works issued via this workqueue and
@@ -2381,6 +2381,7 @@ repeat:
 		if (keep_working(pool))
 			wake_up_worker(pool);
 
+		rescuer->pool = NULL;
 		spin_unlock_irq(&pool->lock);
 	}
 
diff --git a/kernel/workqueue_internal.h b/kernel/workqueue_internal.h
index 0765026..f9c8877 100644
--- a/kernel/workqueue_internal.h
+++ b/kernel/workqueue_internal.h
@@ -32,6 +32,7 @@ struct worker {
 	struct list_head	scheduled;	/* L: scheduled works */
 	struct task_struct	*task;		/* I: worker task */
 	struct worker_pool	*pool;		/* I: the associated pool */
+						/* L: for rescuers */
 	/* 64 bytes boundary on 64bit, 32 on 32bit */
 	unsigned long		last_active;	/* L: last active timestamp */
 	unsigned int		flags;		/* X: flags */
-- 
1.8.1

