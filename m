Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754263AbaC3Xmf (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Mar 2014 19:42:35 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:37332 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753812AbaC3Xmb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Mar 2014 19:42:31 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "Tejun Heo" <tj@kernel.org>,
        "Lai Jiangshan" <laijs@cn.fujitsu.com>
Date: Mon, 31 Mar 2014 00:23:35 +0100
Message-ID: <lsq.1396221815.149912745@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [PATCH 3.2 128/200] workqueue: ensure @task is valid across
 kthread_stop()
In-Reply-To: <lsq.1396221814.369444335@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.249
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.56-rc1 review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 kernel/workqueue.c | 7 +++++++
 1 file changed, 7 insertions(+)

--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -1474,12 +1474,19 @@ static void destroy_worker(struct worker
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

