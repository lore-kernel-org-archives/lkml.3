Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757951Ab3EBAcV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 May 2013 20:32:21 -0400
Received: from e9.ny.us.ibm.com ([32.97.182.139]:42731 "EHLO e9.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757385Ab3EBAcU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 May 2013 20:32:20 -0400
Date: Wed, 1 May 2013 19:32:13 -0500
From: "Philip J. Kelleher" <pjk1939@linux.vnet.ibm.com>
To: axboe@kernel.dk
Cc: linux-kernel@vger.kernel.org, klebers@linux.vnet.ibm.com,
        brking@linux.vnet.ibm.com
Subject: [PATCH 8/8] rsxx: Fixes CPU usage issues on RHEL 6 Kernels.
Message-ID: <20130502003213.GB6657@oc6784271780.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-12-10)
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13050200-7182-0000-0000-0000067F6D66
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Philip J Kelleher <pjk1939@linux.vnet.ibm.com>

The RHEL 6.x version of the driver is using the legacy
worqueue create function, 'create_singlethread_workqueue'.
This would cause heavy usage of one CPU if data was being
thrashed pretty hard. So, in order to fix it, workqueues
are now being created with 'create_workqueue' and
synchronization with mutexes.

Signed-off-by: Philip J Kelleher <pjk1939@linux.vnet.ibm.com>
-------------------------------------------------------------------------------


diff -uprN -X linux-block-vanilla/Documentation/dontdiff linux-block-vanilla/drivers/block/rsxx/dma.c linux-block/drivers/block/rsxx/dma.c
--- linux-block-vanilla/drivers/block/rsxx/dma.c	2013-05-01 18:58:43.428185108 -0500
+++ linux-block/drivers/block/rsxx/dma.c	2013-05-01 19:03:48.504367557 -0500
@@ -383,15 +383,13 @@ static void dma_engine_stalled(unsigned 
 	}
 }
 
-static void rsxx_issue_dmas(struct work_struct *work)
+static void rsxx_issue_dmas(struct rsxx_dma_ctrl *ctrl)
 {
-	struct rsxx_dma_ctrl *ctrl;
 	struct rsxx_dma *dma;
 	int tag;
 	int cmds_pending = 0;
 	struct hw_cmd *hw_cmd_buf;
 
-	ctrl = container_of(work, struct rsxx_dma_ctrl, issue_dma_work);
 	hw_cmd_buf = ctrl->cmd.buf;
 
 	if (unlikely(ctrl->card->halt) ||
@@ -471,9 +469,8 @@ static void rsxx_issue_dmas(struct work_
 	}
 }
 
-static void rsxx_dma_done(struct work_struct *work)
+static void rsxx_dma_done(struct rsxx_dma_ctrl *ctrl)
 {
-	struct rsxx_dma_ctrl *ctrl;
 	struct rsxx_dma *dma;
 	unsigned long flags;
 	u16 count;
@@ -481,7 +478,6 @@ static void rsxx_dma_done(struct work_st
 	u8 tag;
 	struct hw_status *hw_st_buf;
 
-	ctrl = container_of(work, struct rsxx_dma_ctrl, dma_done_work);
 	hw_st_buf = ctrl->status.buf;
 
 	if (unlikely(ctrl->card->halt) ||
@@ -557,6 +553,28 @@ static void rsxx_dma_done(struct work_st
 	spin_unlock_bh(&ctrl->queue_lock);
 }
 
+static void rsxx_schedule_issue(struct work_struct *work)
+{
+	struct rsxx_dma_ctrl *ctrl;
+
+	ctrl = container_of(work, struct rsxx_dma_ctrl, issue_dma_work);
+
+	mutex_lock(&ctrl->work_lock);
+	rsxx_issue_dmas(ctrl);
+	mutex_unlock(&ctrl->work_lock);
+}
+
+static void rsxx_schedule_done(struct work_struct *work)
+{
+	struct rsxx_dma_ctrl *ctrl;
+
+	ctrl = container_of(work, struct rsxx_dma_ctrl, dma_done_work);
+
+	mutex_lock(&ctrl->work_lock);
+	rsxx_dma_done(ctrl);
+	mutex_unlock(&ctrl->work_lock);
+}
+
 static int rsxx_queue_discard(struct rsxx_cardinfo *card,
 				  struct list_head *q,
 				  unsigned int laddr,
@@ -801,6 +819,7 @@ static int rsxx_dma_ctrl_init(struct pci
 	spin_lock_init(&ctrl->trackers->lock);
 
 	spin_lock_init(&ctrl->queue_lock);
+	mutex_init(&ctrl->work_lock);
 	INIT_LIST_HEAD(&ctrl->queue);
 
 	setup_timer(&ctrl->activity_timer, dma_engine_stalled,
@@ -814,8 +833,8 @@ static int rsxx_dma_ctrl_init(struct pci
 	if (!ctrl->done_wq)
 		return -ENOMEM;
 
-	INIT_WORK(&ctrl->issue_dma_work, rsxx_issue_dmas);
-	INIT_WORK(&ctrl->dma_done_work, rsxx_dma_done);
+	INIT_WORK(&ctrl->issue_dma_work, rsxx_schedule_issue);
+	INIT_WORK(&ctrl->dma_done_work, rsxx_schedule_done);
 
 	st = rsxx_hw_buffers_init(dev, ctrl);
 	if (st)
diff -uprN -X linux-block-vanilla/Documentation/dontdiff linux-block-vanilla/drivers/block/rsxx/rsxx_priv.h linux-block/drivers/block/rsxx/rsxx_priv.h
--- linux-block-vanilla/drivers/block/rsxx/rsxx_priv.h	2013-05-01 18:58:43.434186795 -0500
+++ linux-block/drivers/block/rsxx/rsxx_priv.h	2013-05-01 19:04:14.938188138 -0500
@@ -115,6 +115,7 @@ struct rsxx_dma_ctrl {
 	struct timer_list		activity_timer;
 	struct dma_tracker_list		*trackers;
 	struct rsxx_dma_stats		stats;
+	struct mutex			work_lock;
 };
 
 struct rsxx_cardinfo {

