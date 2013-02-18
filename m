Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755608Ab3BRQOT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Feb 2013 11:14:19 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:39550 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751652Ab3BRQON (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Feb 2013 11:14:13 -0500
X-IronPort-AV: E=Sophos;i="4.84,688,1355068800"; 
   d="scan'208";a="6724947"
From: Lai Jiangshan <laijs@cn.fujitsu.com>
To: Tejun Heo <tj@kernel.org>, linux-kernel@vger.kernel.org
Cc: Lai Jiangshan <laijs@cn.fujitsu.com>
Subject: [PATCH V2 08/15] workqueue: only change worker->pool with pool lock held
Date: Tue, 19 Feb 2013 00:12:09 +0800
Message-Id: <1361203940-6300-9-git-send-email-laijs@cn.fujitsu.com>
X-Mailer: git-send-email 1.7.7.6
In-Reply-To: <1361203940-6300-1-git-send-email-laijs@cn.fujitsu.com>
References: <1361203940-6300-1-git-send-email-laijs@cn.fujitsu.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/02/19 00:13:34,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/02/19 00:13:34,
	Serialize complete at 2013/02/19 00:13:34
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We ensure these semantics:
	worker->pool is set to pool if the worker is associated to the pool.
		(normal worker is associated to its pool when created,
		 rescuer is associated to a pool dynamically.)
	worker->pool is set to NULL if the worker is de-associated to the pool.
	It is done with pool->lock held in ether set of above

Thus we have this semantic:
	If pool->lock is held and worker->pool==pool, we can determine that
	the worker is associated to the pool now.


Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
---
 kernel/workqueue.c          |    3 ++-
 kernel/workqueue_internal.h |    1 +
 2 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/kernel/workqueue.c b/kernel/workqueue.c
index b987195..9086a33 100644
--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -2412,8 +2412,8 @@ repeat:
 		mayday_clear_cpu(cpu, wq->mayday_mask);
 
 		/* migrate to the target cpu if possible */
-		rescuer->pool = pool;
 		worker_maybe_bind_and_lock(pool);
+		rescuer->pool = pool;
 
 		/*
 		 * Slurp in all works issued via this workqueue and
@@ -2434,6 +2434,7 @@ repeat:
 		if (keep_working(pool))
 			wake_up_worker(pool);
 
+		rescuer->pool = NULL;
 		spin_unlock_irq(&pool->lock);
 	}
 
diff --git a/kernel/workqueue_internal.h b/kernel/workqueue_internal.h
index 3694bc1..1040abc 100644
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
1.7.7.6

