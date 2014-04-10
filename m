Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934731AbaDJDWO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Apr 2014 23:22:14 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:40812 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934618AbaDJDVd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Apr 2014 23:21:33 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Tejun Heo <tj@kernel.org>, Jamie Liu <jamieliu@google.com>,
        Ben Hutchings <ben@decadent.org.uk>,
        Qiang Huang <h.huangqiang@huawei.com>, Li Zefan <lizefan@huawei.com>,
        Jianguo Wu <wujianguo@huawei.com>
Subject: [PATCH 3.4 005/134] workqueue: cond_resched() after processing each work item
Date: Wed,  9 Apr 2014 20:22:01 -0700
Message-Id: <20140410032300.361536830@linuxfoundation.org>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <20140410032259.587501440@linuxfoundation.org>
References: <20140410032259.587501440@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

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
Cc: Qiang Huang <h.huangqiang@huawei.com>
Cc: Li Zefan <lizefan@huawei.com>
Cc: Jianguo Wu <wujianguo@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 kernel/workqueue.c |    9 +++++++++
 1 file changed, 9 insertions(+)

--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -1922,6 +1922,15 @@ __acquires(&gcwq->lock)
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


