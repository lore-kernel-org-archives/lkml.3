Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756182Ab3BRQOr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Feb 2013 11:14:47 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:50395 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1755287Ab3BRQOo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Feb 2013 11:14:44 -0500
X-IronPort-AV: E=Sophos;i="4.84,688,1355068800"; 
   d="scan'208";a="6724955"
From: Lai Jiangshan <laijs@cn.fujitsu.com>
To: Tejun Heo <tj@kernel.org>, linux-kernel@vger.kernel.org
Cc: Lai Jiangshan <laijs@cn.fujitsu.com>
Subject: [PATCH V2 15/15] workqueue: queue worker to busy list outside process_one_work()
Date: Tue, 19 Feb 2013 00:12:16 +0800
Message-Id: <1361203940-6300-16-git-send-email-laijs@cn.fujitsu.com>
X-Mailer: git-send-email 1.7.7.6
In-Reply-To: <1361203940-6300-1-git-send-email-laijs@cn.fujitsu.com>
References: <1361203940-6300-1-git-send-email-laijs@cn.fujitsu.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/02/19 00:14:05,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/02/19 00:14:05,
	Serialize complete at 2013/02/19 00:14:05
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

pool->busy_list is touched when the worker processes every work.
if this code is moved out, we reduce this touch.

Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
---
 kernel/workqueue.c |    6 ++++--
 1 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/kernel/workqueue.c b/kernel/workqueue.c
index 6d7dd78..8ae92a8 100644
--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -2170,7 +2170,6 @@ __acquires(&pool->lock)
 
 	/* claim and dequeue */
 	debug_work_deactivate(work);
-	list_add(&worker->entry, &pool->busy_list);
 	worker->current_work = work;
 	worker->current_func = work->func;
 	worker->current_cwq = cwq;
@@ -2231,7 +2230,6 @@ __acquires(&pool->lock)
 		worker_clr_flags(worker, WORKER_CPU_INTENSIVE);
 
 	/* we're done with it, release */
-	list_del_init(&worker->entry);
 	worker->current_work = NULL;
 	worker->current_func = NULL;
 	worker->current_cwq = NULL;
@@ -2327,6 +2325,7 @@ recheck:
 	 * assumed the manager role.
 	 */
 	worker_clr_flags(worker, WORKER_PREP);
+	list_add(&worker->entry, &pool->busy_list);
 
 	do {
 		struct work_struct *work =
@@ -2344,6 +2343,7 @@ recheck:
 		}
 	} while (keep_working(pool));
 
+	list_del_init(&worker->entry);
 	worker_set_flags(worker, WORKER_PREP, false);
 sleep:
 	if (unlikely(need_to_manage_workers(pool)) && manage_workers(worker))
@@ -2422,6 +2422,7 @@ repeat:
 		/* migrate to the target cpu if possible */
 		worker_maybe_bind_and_lock(pool);
 		rescuer->pool = pool;
+		list_add(&rescuer->entry, &pool->busy_list);
 
 		/*
 		 * Slurp in all works issued via this workqueue and
@@ -2442,6 +2443,7 @@ repeat:
 		if (keep_working(pool))
 			wake_up_worker(pool);
 
+		list_del_init(&rescuer->entry);
 		rescuer->pool = NULL;
 		spin_unlock_irq(&pool->lock);
 	}
-- 
1.7.7.6

