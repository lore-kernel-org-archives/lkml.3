Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755657AbaBEUNG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Feb 2014 15:13:06 -0500
Received: from mail1.windriver.com ([147.11.146.13]:48645 "EHLO
	mail1.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754182AbaBEUIR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Feb 2014 15:08:17 -0500
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: <stable@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC: Bart Van Assche <bvanassche@acm.org>,
        James Bottomley <JBottomley@Parallels.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [v2.6.34-stable 204/213] Avoid dangling pointer in scsi_requeue_command()
Date: Wed, 5 Feb 2014 15:02:39 -0500
Message-ID: <1391630568-49251-205-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.8.5.2
In-Reply-To: <1391630568-49251-1-git-send-email-paul.gortmaker@windriver.com>
References: <1391630568-49251-1-git-send-email-paul.gortmaker@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bart Van Assche <bvanassche@acm.org>

                   -------------------
    This is a commit scheduled for the next v2.6.34 longterm release.
    http://git.kernel.org/?p=linux/kernel/git/paulg/longterm-queue-2.6.34.git
    If you see a problem with using this for longterm, please comment.
                   -------------------

commit 940f5d47e2f2e1fa00443921a0abf4822335b54d upstream.

When we call scsi_unprep_request() the command associated with the request
gets destroyed and therefore drops its reference on the device.  If this was
the only reference, the device may get released and we end up with a NULL
pointer deref when we call blk_requeue_request.

Reported-by: Mike Christie <michaelc@cs.wisc.edu>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
Reviewed-by: Mike Christie <michaelc@cs.wisc.edu>
Reviewed-by: Tejun Heo <tj@kernel.org>
[jejb: enhance commend and add commit log for stable]
Signed-off-by: James Bottomley <JBottomley@Parallels.com>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 drivers/scsi/scsi_lib.c | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index 6712297407bb..a7e6572940ef 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -484,15 +484,26 @@ static void scsi_run_queue(struct request_queue *q)
  */
 static void scsi_requeue_command(struct request_queue *q, struct scsi_cmnd *cmd)
 {
+	struct scsi_device *sdev = cmd->device;
 	struct request *req = cmd->request;
 	unsigned long flags;
 
+	/*
+	 * We need to hold a reference on the device to avoid the queue being
+	 * killed after the unlock and before scsi_run_queue is invoked which
+	 * may happen because scsi_unprep_request() puts the command which
+	 * releases its reference on the device.
+	 */
+	get_device(&sdev->sdev_gendev);
+
 	spin_lock_irqsave(q->queue_lock, flags);
 	scsi_unprep_request(req);
 	blk_requeue_request(q, req);
 	spin_unlock_irqrestore(q->queue_lock, flags);
 
 	scsi_run_queue(q);
+
+	put_device(&sdev->sdev_gendev);
 }
 
 void scsi_next_command(struct scsi_cmnd *cmd)
-- 
1.8.5.2

