Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756691AbbA2JAs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jan 2015 04:00:48 -0500
Received: from ip4-83-240-67-251.cust.nbox.cz ([83.240.67.251]:44737 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1756266AbbA2JAi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jan 2015 04:00:38 -0500
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Brian King <brking@linux.vnet.ibm.com>,
        Christoph Hellwig <hch@lst.de>, Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 147/176] ipr: wait for aborted command responses
Date: Wed, 28 Jan 2015 15:29:37 +0100
Message-Id: <75ddcd068c810282f57747c3d3bb05ca8a93f0a2.1422455352.git.jslaby@suse.cz>
X-Mailer: git-send-email 2.2.2
In-Reply-To: <ce4a451f616a1e7ab58cfeceea5e49c8b1c68c81.1422455352.git.jslaby@suse.cz>
References: <ce4a451f616a1e7ab58cfeceea5e49c8b1c68c81.1422455352.git.jslaby@suse.cz>
In-Reply-To: <cover.1422455352.git.jslaby@suse.cz>
References: <cover.1422455352.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Brian King <brking@linux.vnet.ibm.com>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

commit 6cdb08172bc89f0a39e1643c5e7eab362692fd1b upstream.

Fixes a race condition in abort handling that was injected
when multiple interrupt support was added. When only a single
interrupt is present, the adapter guarantees it will send
responses for aborted commands prior to the response for the
abort command itself. With multiple interrupts, these responses
generally come back on different interrupts, so we need to
ensure the abort thread waits until the aborted command is
complete so we don't perform a double completion. This race
condition was being hit frequently in environments which
were triggering command timeouts, which was resulting in
a double completion causing a kernel oops.

Signed-off-by: Brian King <brking@linux.vnet.ibm.com>
Reviewed-by: Wendy Xiong <wenxiong@linux.vnet.ibm.com>
Tested-by: Wendy Xiong <wenxiong@linux.vnet.ibm.com>
Signed-off-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 drivers/scsi/ipr.c | 92 ++++++++++++++++++++++++++++++++++++++++++++++++++++++
 drivers/scsi/ipr.h |  1 +
 2 files changed, 93 insertions(+)

diff --git a/drivers/scsi/ipr.c b/drivers/scsi/ipr.c
index 074f278f7dab..5f841652886e 100644
--- a/drivers/scsi/ipr.c
+++ b/drivers/scsi/ipr.c
@@ -683,6 +683,7 @@ static void ipr_init_ipr_cmnd(struct ipr_cmnd *ipr_cmd,
 	ipr_reinit_ipr_cmnd(ipr_cmd);
 	ipr_cmd->u.scratch = 0;
 	ipr_cmd->sibling = NULL;
+	ipr_cmd->eh_comp = NULL;
 	ipr_cmd->fast_done = fast_done;
 	init_timer(&ipr_cmd->timer);
 }
@@ -848,6 +849,8 @@ static void ipr_scsi_eh_done(struct ipr_cmnd *ipr_cmd)
 
 	scsi_dma_unmap(ipr_cmd->scsi_cmd);
 	scsi_cmd->scsi_done(scsi_cmd);
+	if (ipr_cmd->eh_comp)
+		complete(ipr_cmd->eh_comp);
 	list_add_tail(&ipr_cmd->queue, &ipr_cmd->hrrq->hrrq_free_q);
 }
 
@@ -4805,6 +4808,84 @@ static int ipr_slave_alloc(struct scsi_device *sdev)
 	return rc;
 }
 
+/**
+ * ipr_match_lun - Match function for specified LUN
+ * @ipr_cmd:	ipr command struct
+ * @device:		device to match (sdev)
+ *
+ * Returns:
+ *	1 if command matches sdev / 0 if command does not match sdev
+ **/
+static int ipr_match_lun(struct ipr_cmnd *ipr_cmd, void *device)
+{
+	if (ipr_cmd->scsi_cmd && ipr_cmd->scsi_cmd->device == device)
+		return 1;
+	return 0;
+}
+
+/**
+ * ipr_wait_for_ops - Wait for matching commands to complete
+ * @ipr_cmd:	ipr command struct
+ * @device:		device to match (sdev)
+ * @match:		match function to use
+ *
+ * Returns:
+ *	SUCCESS / FAILED
+ **/
+static int ipr_wait_for_ops(struct ipr_ioa_cfg *ioa_cfg, void *device,
+			    int (*match)(struct ipr_cmnd *, void *))
+{
+	struct ipr_cmnd *ipr_cmd;
+	int wait;
+	unsigned long flags;
+	struct ipr_hrr_queue *hrrq;
+	signed long timeout = IPR_ABORT_TASK_TIMEOUT;
+	DECLARE_COMPLETION_ONSTACK(comp);
+
+	ENTER;
+	do {
+		wait = 0;
+
+		for_each_hrrq(hrrq, ioa_cfg) {
+			spin_lock_irqsave(hrrq->lock, flags);
+			list_for_each_entry(ipr_cmd, &hrrq->hrrq_pending_q, queue) {
+				if (match(ipr_cmd, device)) {
+					ipr_cmd->eh_comp = &comp;
+					wait++;
+				}
+			}
+			spin_unlock_irqrestore(hrrq->lock, flags);
+		}
+
+		if (wait) {
+			timeout = wait_for_completion_timeout(&comp, timeout);
+
+			if (!timeout) {
+				wait = 0;
+
+				for_each_hrrq(hrrq, ioa_cfg) {
+					spin_lock_irqsave(hrrq->lock, flags);
+					list_for_each_entry(ipr_cmd, &hrrq->hrrq_pending_q, queue) {
+						if (match(ipr_cmd, device)) {
+							ipr_cmd->eh_comp = NULL;
+							wait++;
+						}
+					}
+					spin_unlock_irqrestore(hrrq->lock, flags);
+				}
+
+				if (wait)
+					dev_err(&ioa_cfg->pdev->dev, "Timed out waiting for aborted commands\n");
+				LEAVE;
+				return wait ? FAILED : SUCCESS;
+			}
+		}
+	} while (wait);
+
+	LEAVE;
+	return SUCCESS;
+}
+
 static int ipr_eh_host_reset(struct scsi_cmnd *cmd)
 {
 	struct ipr_ioa_cfg *ioa_cfg;
@@ -5023,11 +5104,17 @@ static int __ipr_eh_dev_reset(struct scsi_cmnd *scsi_cmd)
 static int ipr_eh_dev_reset(struct scsi_cmnd *cmd)
 {
 	int rc;
+	struct ipr_ioa_cfg *ioa_cfg;
+
+	ioa_cfg = (struct ipr_ioa_cfg *) cmd->device->host->hostdata;
 
 	spin_lock_irq(cmd->device->host->host_lock);
 	rc = __ipr_eh_dev_reset(cmd);
 	spin_unlock_irq(cmd->device->host->host_lock);
 
+	if (rc == SUCCESS)
+		rc = ipr_wait_for_ops(ioa_cfg, cmd->device, ipr_match_lun);
+
 	return rc;
 }
 
@@ -5205,13 +5292,18 @@ static int ipr_eh_abort(struct scsi_cmnd *scsi_cmd)
 {
 	unsigned long flags;
 	int rc;
+	struct ipr_ioa_cfg *ioa_cfg;
 
 	ENTER;
 
+	ioa_cfg = (struct ipr_ioa_cfg *) scsi_cmd->device->host->hostdata;
+
 	spin_lock_irqsave(scsi_cmd->device->host->host_lock, flags);
 	rc = ipr_cancel_op(scsi_cmd);
 	spin_unlock_irqrestore(scsi_cmd->device->host->host_lock, flags);
 
+	if (rc == SUCCESS)
+		rc = ipr_wait_for_ops(ioa_cfg, scsi_cmd->device, ipr_match_lun);
 	LEAVE;
 	return rc;
 }
diff --git a/drivers/scsi/ipr.h b/drivers/scsi/ipr.h
index 58c6630fe3e2..c5f2e9a0a4a4 100644
--- a/drivers/scsi/ipr.h
+++ b/drivers/scsi/ipr.h
@@ -1588,6 +1588,7 @@ struct ipr_cmnd {
 		struct scsi_device *sdev;
 	} u;
 
+	struct completion *eh_comp;
 	struct ipr_hrr_queue *hrrq;
 	struct ipr_ioa_cfg *ioa_cfg;
 };
-- 
2.2.2

