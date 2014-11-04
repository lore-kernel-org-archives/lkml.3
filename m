Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751751AbaKDSwd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2014 13:52:33 -0500
Received: from mail-qa0-f53.google.com ([209.85.216.53]:61550 "EHLO
	mail-qa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750796AbaKDSwb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2014 13:52:31 -0500
Date: Tue, 4 Nov 2014 13:52:27 -0500
From: Tejun Heo <tj@kernel.org>
To: Jens Axboe <axboe@kernel.dk>,
        Christian Borntraeger <borntraeger@de.ibm.com>
Cc: Kent Overstreet <kmo@daterainc.com>, Christoph Hellwig <hch@lst.de>,
        "linux-kernel@vger.kernel.org >> Linux Kernel Mailing List" 
	<linux-kernel@vger.kernel.org>,
        linux-s390 <linux-s390@vger.kernel.org>
Subject: [PATCH block/for-linus] blk-mq: make mq_queue_reinit_notify() freeze
 queues in parallel
Message-ID: <20141104185227.GH14459@htj.dyndns.org>
References: <544FF00B.8050403@de.ibm.com>
 <20141028200055.GA8205@htj.dyndns.org>
 <544FFAA7.1060705@de.ibm.com>
 <20141028202255.GB8205@htj.dyndns.org>
 <544FFC9C.60908@de.ibm.com>
 <20141028203040.GD8205@htj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141028203040.GD8205@htj.dyndns.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

q->mq_usage_counter is a percpu_ref which is killed and drained when
the queue is frozen.  On a CPU hotplug event, blk_mq_queue_reinit()
which involves freezing the queue is invoked on all existing queues.
Because percpu_ref killing and draining involve a RCU grace period,
doing the above on one queue after another may take a long time if
there are many queues on the system.

This patch splits out initiation of freezing and waiting for its
completion, and updates blk_mq_queue_reinit_notify() so that the
queues are frozen in parallel instead of one after another.  Note that
freezing and unfreezing are moved from blk_mq_queue_reinit() to
blk_mq_queue_reinit_notify().

Signed-off-by: Tejun Heo <tj@kernel.org>
Reported-by: Christian Borntraeger <borntraeger@de.ibm.com>
---
Christian, can you please verify that this resolves the latency issue
that you're seeing?  Jens, can you please route this patch once
Christian confirms it?

Thanks!

 block/blk-mq.c |   41 +++++++++++++++++++++++++++++++++--------
 1 file changed, 33 insertions(+), 8 deletions(-)

--- a/block/blk-mq.c
+++ b/block/blk-mq.c
@@ -107,11 +107,7 @@ static void blk_mq_usage_counter_release
 	wake_up_all(&q->mq_freeze_wq);
 }
 
-/*
- * Guarantee no request is in use, so we can change any data structure of
- * the queue afterward.
- */
-void blk_mq_freeze_queue(struct request_queue *q)
+static void blk_mq_freeze_queue_start(struct request_queue *q)
 {
 	bool freeze;
 
@@ -123,9 +119,23 @@ void blk_mq_freeze_queue(struct request_
 		percpu_ref_kill(&q->mq_usage_counter);
 		blk_mq_run_queues(q, false);
 	}
+}
+
+static void blk_mq_freeze_queue_wait(struct request_queue *q)
+{
 	wait_event(q->mq_freeze_wq, percpu_ref_is_zero(&q->mq_usage_counter));
 }
 
+/*
+ * Guarantee no request is in use, so we can change any data structure of
+ * the queue afterward.
+ */
+void blk_mq_freeze_queue(struct request_queue *q)
+{
+	blk_mq_freeze_queue_start(q);
+	blk_mq_freeze_queue_wait(q);
+}
+
 static void blk_mq_unfreeze_queue(struct request_queue *q)
 {
 	bool wake;
@@ -1921,7 +1931,7 @@ void blk_mq_free_queue(struct request_qu
 /* Basically redo blk_mq_init_queue with queue frozen */
 static void blk_mq_queue_reinit(struct request_queue *q)
 {
-	blk_mq_freeze_queue(q);
+	WARN_ON_ONCE(!q->mq_freeze_depth);
 
 	blk_mq_sysfs_unregister(q);
 
@@ -1936,8 +1946,6 @@ static void blk_mq_queue_reinit(struct r
 	blk_mq_map_swqueue(q);
 
 	blk_mq_sysfs_register(q);
-
-	blk_mq_unfreeze_queue(q);
 }
 
 static int blk_mq_queue_reinit_notify(struct notifier_block *nb,
@@ -1956,8 +1964,25 @@ static int blk_mq_queue_reinit_notify(st
 		return NOTIFY_OK;
 
 	mutex_lock(&all_q_mutex);
+
+	/*
+	 * We need to freeze and reinit all existing queues.  Freezing
+	 * involves synchronous wait for an RCU grace period and doing it
+	 * one by one may take a long time.  Start freezing all queues in
+	 * one swoop and then wait for the completions so that freezing can
+	 * take place in parallel.
+	 */
+	list_for_each_entry(q, &all_q_list, all_q_node)
+		blk_mq_freeze_queue_start(q);
+	list_for_each_entry(q, &all_q_list, all_q_node)
+		blk_mq_freeze_queue_wait(q);
+
 	list_for_each_entry(q, &all_q_list, all_q_node)
 		blk_mq_queue_reinit(q);
+
+	list_for_each_entry(q, &all_q_list, all_q_node)
+		blk_mq_unfreeze_queue(q);
+
 	mutex_unlock(&all_q_mutex);
 	return NOTIFY_OK;
 }
