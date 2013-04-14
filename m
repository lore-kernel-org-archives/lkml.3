Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932162Ab3DNQmr (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Apr 2013 12:42:47 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:7156 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752560Ab3DNQmp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Apr 2013 12:42:45 -0400
X-IronPort-AV: E=Sophos;i="4.87,471,1363104000"; 
   d="scan'208";a="7051544"
From: Lai Jiangshan <laijs@cn.fujitsu.com>
To: Tejun Heo <tj@kernel.org>, linux-kernel@vger.kernel.org
Cc: Lai Jiangshan <laijs@cn.fujitsu.com>
Subject: [PATCH 3/8] workqueue: remove cpu_intensive from process_one_work()
Date: Mon, 15 Apr 2013 00:41:51 +0800
Message-Id: <1365957716-7631-4-git-send-email-laijs@cn.fujitsu.com>
X-Mailer: git-send-email 1.7.7.6
In-Reply-To: <1365957716-7631-1-git-send-email-laijs@cn.fujitsu.com>
References: <1365957716-7631-1-git-send-email-laijs@cn.fujitsu.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/04/15 00:41:04,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/04/15 00:41:04,
	Serialize complete at 2013/04/15 00:41:04
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In process_one_work(), we can use "worker->flags & WORKER_CPU_INTENSIVE"
instead "cpu_intensive" and because worker->flags is hot field
(accessed when process each work item). so this change will not cause
any performance down.

It prepare for also clearing WORKER_QUIT_CM in the same place.

Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
---
 kernel/workqueue.c |    7 +++----
 1 files changed, 3 insertions(+), 4 deletions(-)

diff --git a/kernel/workqueue.c b/kernel/workqueue.c
index d1e10c5..a4bc589 100644
--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -2068,7 +2068,6 @@ __acquires(&pool->lock)
 {
 	struct pool_workqueue *pwq = get_work_pwq(work);
 	struct worker_pool *pool = worker->pool;
-	bool cpu_intensive = pwq->wq->flags & WQ_CPU_INTENSIVE;
 	int work_color;
 	struct worker *collision;
 #ifdef CONFIG_LOCKDEP
@@ -2118,7 +2117,7 @@ __acquires(&pool->lock)
 	 * CPU intensive works don't participate in concurrency
 	 * management.  They're the scheduler's responsibility.
 	 */
-	if (unlikely(cpu_intensive))
+	if (unlikely(pwq->wq->flags & WQ_CPU_INTENSIVE))
 		worker_set_flags(worker, WORKER_CPU_INTENSIVE, true);
 
 	/*
@@ -2161,8 +2160,8 @@ __acquires(&pool->lock)
 
 	spin_lock_irq(&pool->lock);
 
-	/* clear cpu intensive status */
-	if (unlikely(cpu_intensive))
+	/* clear cpu intensive status if it is set */
+	if (unlikely(worker->flags & WORKER_CPU_INTENSIVE))
 		worker_clr_flags(worker, WORKER_CPU_INTENSIVE);
 
 	/* we're done with it, release */
-- 
1.7.7.6

