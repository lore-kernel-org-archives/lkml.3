Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756272AbaE2VAJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2014 17:00:09 -0400
Received: from p01c11o144.mxlogic.net ([208.65.144.67]:44484 "EHLO
	p01c11o144.mxlogic.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754596AbaE2VAH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2014 17:00:07 -0400
X-Greylist: delayed 534 seconds by postgrey-1.27 at vger.kernel.org; Thu, 29 May 2014 17:00:07 EDT
X-MXL-Hash: 53879fd72716eb68-b455df0edf5b1d32113a3b388e0d0d898ae269ff
X-MXL-Hash: 53879dc17a407a08-94af89b4087929987de7c9d6a9de67ad64f8995b
From: Joe Lawrence <joe.lawrence@stratus.com>
To: <linux-kernel@vger.kernel.org>
CC: Jens Axboe <axboe@kernel.dk>, Joe Lawrence <joe.lawrence@stratus.com>
Subject: [PATCH 1/2] block,scsi: verify return pointer from blk_get_request
Date: Thu, 29 May 2014 16:48:48 -0400
Message-ID: <1401396529-17275-2-git-send-email-joe.lawrence@stratus.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1401396529-17275-1-git-send-email-joe.lawrence@stratus.com>
References: <1401396529-17275-1-git-send-email-joe.lawrence@stratus.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [134.111.199.152]
X-AnalysisOut: [v=2.1 cv=YpmBRuoX c=1 sm=1 tr=0 a=VNTQBUOG7PJoPU2GWtE7Ww==]
X-AnalysisOut: [:117 a=VNTQBUOG7PJoPU2GWtE7Ww==:17 a=DQC5WzL9fVsA:10 a=_KQ]
X-AnalysisOut: [qW7t0BisA:10 a=CdzKgOd8jloA:10 a=BLceEmwcHowA:10 a=uelBKuK]
X-AnalysisOut: [pAAAA:8 a=YlVTAMxIAAAA:8 a=Dwc-Mzq7TLr0DBKDF_4A:9 a=kSViFE]
X-AnalysisOut: [BMy1sA:10]
X-Spam: [F=0.5000000000; CM=0.500; MH=0.500(2014052925); S=0.200(2014051901)]
X-MAIL-FROM: <joe.lawrence@stratus.com>
X-SOURCE-IP: [134.111.1.17]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The blk-core dead queue checks introduce an error scenario to
blk_get_request that returns NULL if the request queue has been
shutdown. This affects the behavior for __GFP_WAIT callers, who should
verify the return value before dereferencing.

Signed-off-by: Joe Lawrence <joe.lawrence@stratus.com>
Acked-by: Jiri Kosina <jkosina@suse.cz> [for pktdvd]
---
 block/scsi_ioctl.c        | 9 ++++++++-
 drivers/block/paride/pd.c | 2 ++
 drivers/block/pktcdvd.c   | 2 ++
 drivers/scsi/scsi_error.c | 2 ++
 4 files changed, 14 insertions(+), 1 deletion(-)

diff --git a/block/scsi_ioctl.c b/block/scsi_ioctl.c
index 2648797..e6485c9 100644
--- a/block/scsi_ioctl.c
+++ b/block/scsi_ioctl.c
@@ -442,6 +442,10 @@ int sg_scsi_ioctl(struct request_queue *q, struct gendisk *disk, fmode_t mode,
 	}
 
 	rq = blk_get_request(q, in_len ? WRITE : READ, __GFP_WAIT);
+	if (!rq) {
+		err = -ENODEV;
+		goto error_free_buffer;
+	}
 
 	cmdlen = COMMAND_SIZE(opcode);
 
@@ -514,8 +518,9 @@ out:
 	}
 	
 error:
-	kfree(buffer);
 	blk_put_request(rq);
+error_free_buffer:
+	kfree(buffer);
 	return err;
 }
 EXPORT_SYMBOL_GPL(sg_scsi_ioctl);
@@ -528,6 +533,8 @@ static int __blk_send_generic(struct request_queue *q, struct gendisk *bd_disk,
 	int err;
 
 	rq = blk_get_request(q, WRITE, __GFP_WAIT);
+	if (!rq)
+		return -ENODEV;
 	rq->cmd_type = REQ_TYPE_BLOCK_PC;
 	rq->timeout = BLK_DEFAULT_SG_TIMEOUT;
 	rq->cmd[0] = cmd;
diff --git a/drivers/block/paride/pd.c b/drivers/block/paride/pd.c
index 19ad8f0..856178a 100644
--- a/drivers/block/paride/pd.c
+++ b/drivers/block/paride/pd.c
@@ -722,6 +722,8 @@ static int pd_special_command(struct pd_unit *disk,
 	int err = 0;
 
 	rq = blk_get_request(disk->gd->queue, READ, __GFP_WAIT);
+	if (!rq)
+		return -ENODEV;
 
 	rq->cmd_type = REQ_TYPE_SPECIAL;
 	rq->special = func;
diff --git a/drivers/block/pktcdvd.c b/drivers/block/pktcdvd.c
index a2af73d..ff39837 100644
--- a/drivers/block/pktcdvd.c
+++ b/drivers/block/pktcdvd.c
@@ -704,6 +704,8 @@ static int pkt_generic_packet(struct pktcdvd_device *pd, struct packet_command *
 
 	rq = blk_get_request(q, (cgc->data_direction == CGC_DATA_WRITE) ?
 			     WRITE : READ, __GFP_WAIT);
+	if (!rq)
+		return -ENODEV;
 
 	if (cgc->buflen) {
 		ret = blk_rq_map_kern(q, rq, cgc->buffer, cgc->buflen,
diff --git a/drivers/scsi/scsi_error.c b/drivers/scsi/scsi_error.c
index f17aa7a..d50531f 100644
--- a/drivers/scsi/scsi_error.c
+++ b/drivers/scsi/scsi_error.c
@@ -1950,6 +1950,8 @@ static void scsi_eh_lock_door(struct scsi_device *sdev)
 	 * request becomes available
 	 */
 	req = blk_get_request(sdev->request_queue, READ, GFP_KERNEL);
+	if (!req)
+		return;
 
 	req->cmd[0] = ALLOW_MEDIUM_REMOVAL;
 	req->cmd[1] = 0;
-- 
1.8.3.1

