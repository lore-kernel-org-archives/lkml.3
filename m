Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751732AbaFFLqv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jun 2014 07:46:51 -0400
Received: from mail-la0-f53.google.com ([209.85.215.53]:52976 "EHLO
	mail-la0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750939AbaFFLqg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jun 2014 07:46:36 -0400
From: =?UTF-8?q?Matias=20Bj=C3=B8rling?= <m@bjorling.me>
To: axboe@fb.com
Cc: linux-kernel@vger.kernel.org,
        =?UTF-8?q?Matias=20Bj=C3=B8rling?= <m@bjorling.me>
Subject: [PATCH] block: blk_rq_set_block_pc overwrites __data_len
Date: Fri,  6 Jun 2014 13:46:01 +0200
Message-Id: <1402055161-25533-2-git-send-email-m@bjorling.me>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1402055161-25533-1-git-send-email-m@bjorling.me>
References: <1402055161-25533-1-git-send-email-m@bjorling.me>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Drivers that issue REQ_TYPE_BLOCK_PC command, calls blk_rq_map_kern() before
the command is intialized to REQ_TYPE_BLOCK_PC. As blk_rq_map_kern() increases
rq->__data_len, and blk_rq_set_block_pc sets it to zero. Results in a zero
request being sent to hw.

Signed-off-by: Matias Bjørling <m@bjorling.me>
---
 drivers/block/pktcdvd.c                    | 2 +-
 drivers/cdrom/cdrom.c                      | 2 +-
 drivers/scsi/device_handler/scsi_dh_alua.c | 2 +-
 drivers/scsi/device_handler/scsi_dh_rdac.c | 2 +-
 drivers/scsi/scsi_lib.c                    | 2 +-
 5 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/block/pktcdvd.c b/drivers/block/pktcdvd.c
index 0ce8a3e..758ac44 100644
--- a/drivers/block/pktcdvd.c
+++ b/drivers/block/pktcdvd.c
@@ -704,6 +704,7 @@ static int pkt_generic_packet(struct pktcdvd_device *pd, struct packet_command *
 
 	rq = blk_get_request(q, (cgc->data_direction == CGC_DATA_WRITE) ?
 			     WRITE : READ, __GFP_WAIT);
+	blk_rq_set_block_pc(rq);
 
 	if (cgc->buflen) {
 		ret = blk_rq_map_kern(q, rq, cgc->buffer, cgc->buflen,
@@ -712,7 +713,6 @@ static int pkt_generic_packet(struct pktcdvd_device *pd, struct packet_command *
 			goto out;
 	}
 
-	blk_rq_set_block_pc(rq);
 	rq->cmd_len = COMMAND_SIZE(cgc->cmd[0]);
 	memcpy(rq->cmd, cgc->cmd, CDROM_PACKET_SIZE);
 
diff --git a/drivers/cdrom/cdrom.c b/drivers/cdrom/cdrom.c
index 4d10024..0f40c95 100644
--- a/drivers/cdrom/cdrom.c
+++ b/drivers/cdrom/cdrom.c
@@ -2184,6 +2184,7 @@ static int cdrom_read_cdda_bpc(struct cdrom_device_info *cdi, __u8 __user *ubuf,
 			ret = -ENOMEM;
 			break;
 		}
+		blk_rq_set_block_pc(rq);
 
 		ret = blk_rq_map_user(q, rq, NULL, ubuf, len, GFP_KERNEL);
 		if (ret) {
@@ -2191,7 +2192,6 @@ static int cdrom_read_cdda_bpc(struct cdrom_device_info *cdi, __u8 __user *ubuf,
 			break;
 		}
 
-		blk_rq_set_block_pc(rq);
 		rq->cmd[0] = GPCMD_READ_CD;
 		rq->cmd[1] = 1 << 2;
 		rq->cmd[2] = (lba >> 24) & 0xff;
diff --git a/drivers/scsi/device_handler/scsi_dh_alua.c b/drivers/scsi/device_handler/scsi_dh_alua.c
index 3dcd93f..7bcf67e 100644
--- a/drivers/scsi/device_handler/scsi_dh_alua.c
+++ b/drivers/scsi/device_handler/scsi_dh_alua.c
@@ -120,6 +120,7 @@ static struct request *get_alua_req(struct scsi_device *sdev,
 			    "%s: blk_get_request failed\n", __func__);
 		return NULL;
 	}
+	blk_rq_set_block_pc(rq);
 
 	if (buflen && blk_rq_map_kern(q, rq, buffer, buflen, GFP_NOIO)) {
 		blk_put_request(rq);
@@ -128,7 +129,6 @@ static struct request *get_alua_req(struct scsi_device *sdev,
 		return NULL;
 	}
 
-	blk_rq_set_block_pc(rq);
 	rq->cmd_flags |= REQ_FAILFAST_DEV | REQ_FAILFAST_TRANSPORT |
 			 REQ_FAILFAST_DRIVER;
 	rq->retries = ALUA_FAILOVER_RETRIES;
diff --git a/drivers/scsi/device_handler/scsi_dh_rdac.c b/drivers/scsi/device_handler/scsi_dh_rdac.c
index ea35f0a..826069d 100644
--- a/drivers/scsi/device_handler/scsi_dh_rdac.c
+++ b/drivers/scsi/device_handler/scsi_dh_rdac.c
@@ -279,6 +279,7 @@ static struct request *get_rdac_req(struct scsi_device *sdev,
 				"get_rdac_req: blk_get_request failed.\n");
 		return NULL;
 	}
+	blk_rq_set_block_pc(rq);
 
 	if (buflen && blk_rq_map_kern(q, rq, buffer, buflen, GFP_NOIO)) {
 		blk_put_request(rq);
@@ -287,7 +288,6 @@ static struct request *get_rdac_req(struct scsi_device *sdev,
 		return NULL;
 	}
 
-	blk_rq_set_block_pc(rq);
 	rq->cmd_flags |= REQ_FAILFAST_DEV | REQ_FAILFAST_TRANSPORT |
 			 REQ_FAILFAST_DRIVER;
 	rq->retries = RDAC_RETRIES;
diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index 6660e43..c3c1697 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -195,12 +195,12 @@ int scsi_execute(struct scsi_device *sdev, const unsigned char *cmd,
 	req = blk_get_request(sdev->request_queue, write, __GFP_WAIT);
 	if (!req)
 		return ret;
+	blk_rq_set_block_pc(req);
 
 	if (bufflen &&	blk_rq_map_kern(sdev->request_queue, req,
 					buffer, bufflen, __GFP_WAIT))
 		goto out;
 
-	blk_rq_set_block_pc(req);
 	req->cmd_len = COMMAND_SIZE(cmd[0]);
 	memcpy(req->cmd, cmd, req->cmd_len);
 	req->sense = sense;
-- 
1.9.1

