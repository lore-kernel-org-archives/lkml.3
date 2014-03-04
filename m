Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757739AbaCDUPH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2014 15:15:07 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:41768 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932316AbaCDUFi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2014 15:05:38 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Lai Jiangshan <laijs@cn.fujitsu.com>, Tejun Heo <tj@kernel.org>
Subject: [PATCH 3.10 74/97] workqueue: ensure @task is valid across kthread_stop()
Date: Tue,  4 Mar 2014 12:04:27 -0800
Message-Id: <20140304200348.426743094@linuxfoundation.org>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <20140304200345.895517495@linuxfoundation.org>
References: <20140304200345.895517495@linuxfoundation.org>
User-Agent: quilt/0.61-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 kernel/workqueue.c |    7 +++++++
 1 file changed, 7 insertions(+)

--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -1823,6 +1823,12 @@ static void destroy_worker(struct worker
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
 
@@ -1831,6 +1837,7 @@ static void destroy_worker(struct worker
 	spin_unlock_irq(&pool->lock);
 
 	kthread_stop(worker->task);
+	put_task_struct(worker->task);
 	kfree(worker);
 
 	spin_lock_irq(&pool->lock);


