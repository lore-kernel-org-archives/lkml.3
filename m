Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755739Ab3IISvb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Sep 2013 14:51:31 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:57083 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753427Ab3IISpV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Sep 2013 14:45:21 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Tejun Heo <tj@kernel.org>, Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 20/24] workqueue: cond_resched() after processing each work item
Date: Mon,  9 Sep 2013 11:45:10 -0700
Message-Id: <1378752314-2416-21-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1378752314-2416-1-git-send-email-kamal@canonical.com>
References: <1378752314-2416-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.9 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tejun Heo <tj@kernel.org>

commit b22ce2785d97423846206cceec4efee0c4afd980 upstream.

If !PREEMPT, a kworker running work items back to back can hog CPU.
This becomes dangerous when a self-requeueing work item which is
waiting for something to happen races against stop_machine.  Such
self-requeueing work item would requeue itself indefinitely hogging
the kworker and CPU it's running on while stop_machine would wait for
that CPU to enter stop_machine while preventing anything else from
happening on all other CPUs.  The two would deadlock.

Jamie Liu reports that this deadlock scenario exists around
scsi_requeue_run_queue() and libata port multiplier support, where one
port may exclude command processing from other ports.  With the right
timing, scsi_requeue_run_queue() can end up requeueing itself trying
to execute an IO which is asked to be retried while another device has
an exclusive access, which in turn can't make forward progress due to
stop_machine.

Fix it by invoking cond_resched() after executing each work item.

Signed-off-by: Tejun Heo <tj@kernel.org>
Reported-by: Jamie Liu <jamieliu@google.com>
References: http://thread.gmane.org/gmane.linux.kernel/1552567
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 kernel/workqueue.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/kernel/workqueue.c b/kernel/workqueue.c
index 3a3a98f..338b3bd 100644
--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -2278,6 +2278,15 @@ __acquires(&gcwq->lock)
 		dump_stack();
 	}
 
+	/*
+	 * The following prevents a kworker from hogging CPU on !PREEMPT
+	 * kernels, where a requeueing work item waiting for something to
+	 * happen could deadlock with stop_machine as such work item could
+	 * indefinitely requeue itself while all other CPUs are trapped in
+	 * stop_machine.
+	 */
+	cond_resched();
+
 	spin_lock_irq(&gcwq->lock);
 
 	/* clear cpu intensive status */
-- 
1.8.1.2

