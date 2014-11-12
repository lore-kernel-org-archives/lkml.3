Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934791AbaKLDW5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2014 22:22:57 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:59633 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933394AbaKLBef (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2014 20:34:35 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Christoph Hellwig <hch@lst.de>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Jens Axboe <axboe@kernel.dk>, Meelis Roos <mroos@linux.ee>
Subject: [PATCH 3.17 251/319] scsi: set REQ_QUEUE for the blk-mq case
Date: Wed, 12 Nov 2014 10:16:29 +0900
Message-Id: <20141112011034.333856967@linuxfoundation.org>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <20141112010952.553519040@linuxfoundation.org>
References: <20141112010952.553519040@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Christoph Hellwig <hch@lst.de>

commit b1dd2aac4cc0892b82ec60232ed37e3b0af776cc upstream.

To generate the right SPI tag messages we need to properly set
QUEUE_FLAG_QUEUED in the request_queue and mirror it to the
request.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Martin K. Petersen <martin.petersen@oracle.com>
Acked-by: Jens Axboe <axboe@kernel.dk>
Reported-by: Meelis Roos <mroos@linux.ee>
Tested-by: Meelis Roos <mroos@linux.ee>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/scsi/scsi_lib.c |    5 +++++
 include/scsi/scsi_tcq.h |    8 ++++----
 2 files changed, 9 insertions(+), 4 deletions(-)

--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -1887,6 +1887,11 @@ static int scsi_queue_rq(struct blk_mq_h
 		req->cmd_flags |= REQ_DONTPREP;
 	}
 
+	if (blk_queue_tagged(q))
+		req->cmd_flags |= REQ_QUEUED;
+	else
+		req->cmd_flags &= ~REQ_QUEUED;
+
 	scsi_init_cmd_errh(cmd);
 	cmd->scsi_done = scsi_mq_done;
 
--- a/include/scsi/scsi_tcq.h
+++ b/include/scsi/scsi_tcq.h
@@ -67,8 +67,9 @@ static inline void scsi_activate_tcq(str
 	if (!sdev->tagged_supported)
 		return;
 
-	if (!shost_use_blk_mq(sdev->host) &&
-	    !blk_queue_tagged(sdev->request_queue))
+	if (shost_use_blk_mq(sdev->host))
+		queue_flag_set_unlocked(QUEUE_FLAG_QUEUED, sdev->request_queue);
+	else if (!blk_queue_tagged(sdev->request_queue))
 		blk_queue_init_tags(sdev->request_queue, depth,
 				    sdev->host->bqt);
 
@@ -81,8 +82,7 @@ static inline void scsi_activate_tcq(str
  **/
 static inline void scsi_deactivate_tcq(struct scsi_device *sdev, int depth)
 {
-	if (!shost_use_blk_mq(sdev->host) &&
-	    blk_queue_tagged(sdev->request_queue))
+	if (blk_queue_tagged(sdev->request_queue))
 		blk_queue_free_tags(sdev->request_queue);
 	scsi_adjust_queue_depth(sdev, 0, depth);
 }


