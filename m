Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757958AbaGBTjR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jul 2014 15:39:17 -0400
Received: from p02c11o142.mxlogic.net ([208.65.144.75]:33195 "EHLO
	p02c11o142.mxlogic.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754729AbaGBTjO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jul 2014 15:39:14 -0400
X-MXL-Hash: 53b45fe249bbeee6-32f93dcc6a0f6158fc4021879c795120c43262c6
X-MXL-Hash: 53b45f1273f9de4a-9a7b707e521d385c7a729048e83c0d501b0ee945
From: Joe Lawrence <joe.lawrence@stratus.com>
To: <linux-kernel@vger.kernel.org>
CC: Jens Axboe <axboe@kernel.dk>, Jiri Kosina <jkosina@suse.cz>,
        Jeff Moyer <jmoyer@redhat.com>, Boaz Harrosh <bharrosh@panasas.com>,
        Joe Lawrence <joe.lawrence@stratus.com>
Subject: [PATCH v3 1/2] block,scsi: verify return pointer from blk_get_request
Date: Wed, 2 Jul 2014 15:35:16 -0400
Message-ID: <1404329718-19367-2-git-send-email-joe.lawrence@stratus.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1404329718-19367-1-git-send-email-joe.lawrence@stratus.com>
References: <1404329718-19367-1-git-send-email-joe.lawrence@stratus.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [134.111.199.152]
X-AnalysisOut: [v=2.1 cv=MdPiuvPf c=1 sm=1 tr=0 a=o2bo05G+d1rlxuoNbFVhCw==]
X-AnalysisOut: [:117 a=o2bo05G+d1rlxuoNbFVhCw==:17 a=8ajrTaa51A4A:10 a=_KQ]
X-AnalysisOut: [qW7t0BisA:10 a=CdzKgOd8jloA:10 a=BLceEmwcHowA:10 a=uelBKuK]
X-AnalysisOut: [pAAAA:8 a=YlVTAMxIAAAA:8 a=20KFwNOVAAAA:8 a=Z9csNxIN4_CVcZ]
X-AnalysisOut: [s66Q0A:9 a=kSViFEBMy1sA:10 a=jEp0ucaQiEUA:10]
X-Spam: [F=0.5000000000; CM=0.500; MH=0.500(2014070216); S=0.200(2014051901)]
X-MAIL-FROM: <joe.lawrence@stratus.com>
X-SOURCE-IP: [134.111.1.18]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The blk-core dead queue checks introduce an error scenario to
blk_get_request that returns NULL if the request queue has been
shutdown. This affects the behavior for __GFP_WAIT callers, who should
verify the return value before dereferencing.

Signed-off-by: Joe Lawrence <joe.lawrence@stratus.com>
Acked-by: Jiri Kosina <jkosina@suse.cz> [for pktdvd]
Reviewed-by: Jeff Moyer <jmoyer@redhat.com>
---
 block/scsi_ioctl.c        |    9 ++++++++-
 drivers/block/paride/pd.c |    2 ++
 drivers/block/pktcdvd.c   |    2 ++
 drivers/scsi/scsi_error.c |    2 ++
 4 files changed, 14 insertions(+), 1 deletion(-)

diff --git a/block/scsi_ioctl.c b/block/scsi_ioctl.c
index 14695c6..3e1d80c 100644
--- a/block/scsi_ioctl.c
+++ b/block/scsi_ioctl.c
@@ -438,6 +438,10 @@ int sg_scsi_ioctl(struct request_queue *q, struct gendisk *disk, fmode_t mode,
 	}
 
 	rq = blk_get_request(q, in_len ? WRITE : READ, __GFP_WAIT);
+	if (!rq) {
+		err = -ENODEV;
+		goto error_free_buffer;
+	}
 
 	cmdlen = COMMAND_SIZE(opcode);
 
@@ -510,8 +514,9 @@ out:
 	}
 	
 error:
-	kfree(buffer);
 	blk_put_request(rq);
+error_free_buffer:
+	kfree(buffer);
 	return err;
 }
 EXPORT_SYMBOL_GPL(sg_scsi_ioctl);
@@ -524,6 +529,8 @@ static int __blk_send_generic(struct request_queue *q, struct gendisk *bd_disk,
 	int err;
 
 	rq = blk_get_request(q, WRITE, __GFP_WAIT);
+	if (!rq)
+		return -ENODEV;
 	blk_rq_set_block_pc(rq);
 	rq->timeout = BLK_DEFAULT_SG_TIMEOUT;
 	rq->cmd[0] = cmd;
diff --git a/drivers/block/paride/pd.c b/drivers/block/paride/pd.c
index fea7e76..ca831f7 100644
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
index 758ac44..7fa8c80 100644
--- a/drivers/block/pktcdvd.c
+++ b/drivers/block/pktcdvd.c
@@ -704,6 +704,8 @@ static int pkt_generic_packet(struct pktcdvd_device *pd, struct packet_command *
 
 	rq = blk_get_request(q, (cgc->data_direction == CGC_DATA_WRITE) ?
 			     WRITE : READ, __GFP_WAIT);
+	if (!rq)
+		return -ENODEV;
 	blk_rq_set_block_pc(rq);
 
 	if (cgc->buflen) {
diff --git a/drivers/scsi/scsi_error.c b/drivers/scsi/scsi_error.c
index cbe38e5..b403b04 100644
--- a/drivers/scsi/scsi_error.c
+++ b/drivers/scsi/scsi_error.c
@@ -1951,6 +1951,8 @@ static void scsi_eh_lock_door(struct scsi_device *sdev)
 	 * request becomes available
 	 */
 	req = blk_get_request(sdev->request_queue, READ, GFP_KERNEL);
+	if (!req)
+		return;
 
 	blk_rq_set_block_pc(req);
 
-- 
1.7.10.4

