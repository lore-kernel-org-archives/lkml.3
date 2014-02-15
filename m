Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753398AbaBOPOp (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Feb 2014 10:14:45 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:12609 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1753358AbaBOPOn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Feb 2014 10:14:43 -0500
X-IronPort-AV: E=Sophos;i="4.95,850,1384272000"; 
   d="scan'208";a="9531914"
From: Lai Jiangshan <laijs@cn.fujitsu.com>
To: linux-kernel@vger.kernel.org
Cc: Tejun Heo <tj@kernel.org>, Lai Jiangshan <laijs@cn.fujitsu.com>,
        stable@vger.kernel.org
Subject: [PATCH] workqueue: ensure @task is valid across kthread_stop()
Date: Sat, 15 Feb 2014 22:02:28 +0800
Message-Id: <1392472948-2486-1-git-send-email-laijs@cn.fujitsu.com>
X-Mailer: git-send-email 1.7.7.6
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2014/02/15 22:00:34,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2014/02/15 22:00:36,
	Serialize complete at 2014/02/15 22:00:36
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When a worker is set WORKER_DIE, it may die very quickly,
and kthread_stop() will access to a stale task stuct/stack.
To avoid this, we use get_task_struct() to ensure @task is valid.

See more comments in kthread_create_on_node()&kthread_stop().
Note: comments in kthread_create_on_node() does not elaborate
any use case like this patch, but it is a valid way to use
kthread_stop().

CC: stable@vger.kernel.org
Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
---
 kernel/workqueue.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/kernel/workqueue.c b/kernel/workqueue.c
index 82ef9f3..783d5f2 100644
--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -1856,9 +1856,12 @@ static void destroy_worker(struct worker *worker)
 
 	idr_remove(&pool->worker_idr, worker->id);
 
+	/* Enusre the @worker->task is valid across kthread_stop() */
+	get_task_struct(worker->task);
 	spin_unlock_irq(&pool->lock);
 
 	kthread_stop(worker->task);
+	put_task_struct(worker->task);
 	kfree(worker);
 
 	spin_lock_irq(&pool->lock);
-- 
1.7.7.6

