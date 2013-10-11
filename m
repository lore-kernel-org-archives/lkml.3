Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932439Ab3JKLHu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Oct 2013 07:07:50 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:58437 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757743Ab3JKKms (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Oct 2013 06:42:48 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Tejun Heo <tj@kernel.org>, Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 024/100] workqueue: cond_resched() after processing each work item
Date: Fri, 11 Oct 2013 11:40:54 +0100
Message-Id: <1381488130-30235-25-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1381488130-30235-1-git-send-email-luis.henriques@canonical.com>
References: <1381488130-30235-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.23 -stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 kernel/workqueue.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/kernel/workqueue.c b/kernel/workqueue.c
index 0395ca8..89743ae 100644
--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -1920,6 +1920,15 @@ __acquires(&gcwq->lock)
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
1.8.3.2

