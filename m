Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756084AbaCYRpK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Mar 2014 13:45:10 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:55829 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754915AbaCYRVR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Mar 2014 13:21:17 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Lai Jiangshan <laijs@cn.fujitsu.com>, Tejun Heo <tj@kernel.org>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.8 39/81] workqueue: ensure @task is valid across kthread_stop()
Date: Tue, 25 Mar 2014 10:15:52 -0700
Message-Id: <1395767794-5012-40-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1395767794-5012-1-git-send-email-kamal@canonical.com>
References: <1395767794-5012-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.20 -stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 kernel/workqueue.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/kernel/workqueue.c b/kernel/workqueue.c
index 338b3bd..1fd7e24 100644
--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -1902,12 +1902,19 @@ static void destroy_worker(struct worker *worker)
 	if (worker->flags & WORKER_IDLE)
 		pool->nr_idle--;
 
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
1.8.3.2

