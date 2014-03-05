Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932292AbaCEOhu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Mar 2014 09:37:50 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:41632 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932231AbaCEOho (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Mar 2014 09:37:44 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Lai Jiangshan <laijs@cn.fujitsu.com>, Tejun Heo <tj@kernel.org>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.5 22/62] workqueue: ensure @task is valid across kthread_stop()
Date: Wed,  5 Mar 2014 14:36:26 +0000
Message-Id: <1394030226-26652-23-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <1394030226-26652-1-git-send-email-luis.henriques@canonical.com>
References: <1394030226-26652-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.32 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Lai Jiangshan <laijs@cn.fujitsu.com>

commit 5bdfff96c69a4d5ab9c49e60abf9e070ecd2acbb upstream.

When a kworker should die, the kworkre is notified through WORKER_DIE
flag instead of kthread_should_stop().  This, IIRC, is primarily to
keep the test synchronized inside worker_pool lock.  WORKER_DIE is
first set while holding pool->lock, the lock is dropped and
kthread_stop() is called.

Unfortunately, this means that there's a slight chance that the target
kworker may see WORKER_DIE before kthread_stop() finishes and exits
and frees the target task before or during kthread_stop().

Fix it by pinning the target task before setting WORKER_DIE and
putting it after kthread_stop() is done.

tj: Improved patch description and comment.  Moved pinning above
    WORKER_DIE for better signify what it's protecting.

Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
Signed-off-by: Tejun Heo <tj@kernel.org>
[ luis: backported to 3.5: adjusted context ]
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 kernel/workqueue.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/kernel/workqueue.c b/kernel/workqueue.c
index 89743ae..d19727f 100644
--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -1472,12 +1472,19 @@ static void destroy_worker(struct worker *worker)
 	if (worker->flags & WORKER_IDLE)
 		gcwq->nr_idle--;
 
+	/*
+	 * Once WORKER_DIE is set, the kworker may destroy itself at any
+	 * point.  Pin to ensure the task stays until we're done with it.
+	 */
+	get_task_struct(worker->task);
+
 	list_del_init(&worker->entry);
 	worker->flags |= WORKER_DIE;
 
 	spin_unlock_irq(&gcwq->lock);
 
 	kthread_stop(worker->task);
+	put_task_struct(worker->task);
 	kfree(worker);
 
 	spin_lock_irq(&gcwq->lock);
-- 
1.9.0

