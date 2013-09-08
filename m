Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759773Ab3IHDjC (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Sep 2013 23:39:02 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:56049 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755098Ab3IHDTU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Sep 2013 23:19:20 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "Tejun Heo" <tj@kernel.org>,
        "Jamie Liu" <jamieliu@google.com>
Date: Sun, 08 Sep 2013 03:52:01 +0100
Message-ID: <lsq.1378608721.335265157@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [107/121] workqueue: cond_resched() after processing each work item
In-Reply-To: <lsq.1378608720.401499712@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.101
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.51-rc1 review patch.  If anyone has any objections, please let me know.

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
[bwh: Backported to 3.2: adjust context]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 kernel/workqueue.c | 9 +++++++++
 1 file changed, 9 insertions(+)

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

