Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754908Ab3H1Vdo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Aug 2013 17:33:44 -0400
Received: from mail-ye0-f181.google.com ([209.85.213.181]:59215 "EHLO
	mail-ye0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752927Ab3H1Vdm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Aug 2013 17:33:42 -0400
Date: Wed, 28 Aug 2013 17:33:37 -0400
From: Tejun Heo <tj@kernel.org>
To: Jamie Liu <jamieliu@google.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org
Subject: [PATCH] workqueue: cond_resched() after processing each work item
Message-ID: <20130828213337.GC18971@mtj.dyndns.org>
References: <1377724032-12199-1-git-send-email-jamieliu@google.com>
 <20130828211312.GB18971@mtj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130828211312.GB18971@mtj.dyndns.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Would something like the following work?  Can you please verify it?

Thanks.
---- 8< ----
If !PREEMPT, a kworker running work items back to back can hog CPU.
This becomes dangerous when a self-requeueing work item which is
waiting for something to happen races against stop_machine.  Such
self-requeueing work item would requeue itself indefinitely hogging
the kworker and CPU it's running on while stop_machine would wait for
that CPU to enter stop_machine while preventing anything else from
happening on all other CPUs.  The two would deadlock.

Jmamie Liu reports that this deadlock scenario exists around
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
Cc: stable@vger.kernel.org
--
 kernel/workqueue.c |    9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/kernel/workqueue.c b/kernel/workqueue.c
index f02c4a4..73b662b 100644
--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -2201,6 +2201,15 @@ __acquires(&pool->lock)
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
 	spin_lock_irq(&pool->lock);
 
 	/* clear cpu intensive status */
