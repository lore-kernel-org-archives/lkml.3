Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752303AbaFFSuZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jun 2014 14:50:25 -0400
Received: from mailout.micron.com ([137.201.242.129]:28415 "EHLO
	mailout.micron.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751856AbaFFSuY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jun 2014 14:50:24 -0400
Message-ID: <53921024.6080808@micron.com>
Date: Fri, 6 Jun 2014 12:01:56 -0700
From: Sam Bradshaw <sbradshaw@micron.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.23) Gecko/20110928 Red Hat/3.1.15-1.el6_1 Thunderbird/3.1.15
MIME-Version: 1.0
To: <axboe@kernel.dk>
CC: <linux-kernel@vger.kernel.org>
Subject: [PATCH] mtip32xx: minor performance enhancements
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-TM-AS-Product-Ver: SMEX-10.0.0.4152-7.000.1014-20742.001
X-TM-AS-Result: No--9.421500-0.000000-31
X-TM-AS-User-Approved-Sender: Yes
X-TM-AS-User-Blocked-Sender: No
X-MT-CheckInternalSenderRule: True
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds the following:

1) Compiler hinting in the fast path.
2) A prefetch of port->flags to eliminate moderate cpu stalling later 
in mtip_hw_submit_io().
3) Eliminate a redundant rq_data_dir().
4) Reorder members of driver_data to eliminate false cacheline sharing 
between irq_workers_active and unal_qdepth.

With some workload and topology configurations, I'm seeing ~1.5% 
throughput improvement in small block random read benchmarks as well
as improved latency std. dev.

Signed-off-by: Sam Bradshaw <sbradshaw@micron.com>
---
diff --git a/drivers/block/mtip32xx/mtip32xx.c b/drivers/block/mtip32xx/mtip32xx.c
index 74abd49..fcbac54 100644
--- a/drivers/block/mtip32xx/mtip32xx.c
+++ b/drivers/block/mtip32xx/mtip32xx.c
@@ -2380,6 +2380,8 @@ static void mtip_hw_submit_io(struct driver_data *dd, struct request *rq,
 	/* Map the scatter list for DMA access */
 	nents = dma_map_sg(&dd->pdev->dev, command->sg, nents, dma_dir);
 
+	prefetch(&port->flags);
+
 	command->scatter_ents = nents;
 
 	/*
@@ -2392,7 +2394,7 @@ static void mtip_hw_submit_io(struct driver_data *dd, struct request *rq,
 	fis = command->command;
 	fis->type        = 0x27;
 	fis->opts        = 1 << 7;
-	if (rq_data_dir(rq) == READ)
+	if (dma_dir == DMA_FROM_DEVICE)
 		fis->command = ATA_CMD_FPDMA_READ;
 	else
 		fis->command = ATA_CMD_FPDMA_WRITE;
@@ -2412,7 +2414,7 @@ static void mtip_hw_submit_io(struct driver_data *dd, struct request *rq,
 	fis->res3        = 0;
 	fill_command_sg(dd, command, nents);
 
-	if (command->unaligned)
+	if (unlikely(command->unaligned))
 		fis->device |= 1 << 7;
 
 	/* Populate the command header */
@@ -2433,7 +2435,7 @@ static void mtip_hw_submit_io(struct driver_data *dd, struct request *rq,
 	 * To prevent this command from being issued
 	 * if an internal command is in progress or error handling is active.
 	 */
-	if (port->flags & MTIP_PF_PAUSE_IO) {
+	if (unlikely(port->flags & MTIP_PF_PAUSE_IO)) {
 		set_bit(rq->tag, port->cmds_to_issue);
 		set_bit(MTIP_PF_ISSUE_CMDS_BIT, &port->flags);
 		return;
@@ -3754,7 +3756,7 @@ static bool mtip_check_unal_depth(struct blk_mq_hw_ctx *hctx,
 	struct driver_data *dd = hctx->queue->queuedata;
 	struct mtip_cmd *cmd = blk_mq_rq_to_pdu(rq);
 
-	if (!dd->unal_qdepth || rq_data_dir(rq) == READ)
+	if (rq_data_dir(rq) == READ || !dd->unal_qdepth)
 		return false;
 
 	/*
@@ -3776,11 +3778,11 @@ static int mtip_queue_rq(struct blk_mq_hw_ctx *hctx, struct request *rq)
 {
 	int ret;
 
-	if (mtip_check_unal_depth(hctx, rq))
+	if (unlikely(mtip_check_unal_depth(hctx, rq)))
 		return BLK_MQ_RQ_QUEUE_BUSY;
 
 	ret = mtip_submit_request(hctx, rq);
-	if (!ret)
+	if (likely(!ret))
 		return BLK_MQ_RQ_QUEUE_OK;
 
 	rq->errors = ret;
diff --git a/drivers/block/mtip32xx/mtip32xx.h b/drivers/block/mtip32xx/mtip32xx.h
index 4b9b554..ba1b31e 100644
--- a/drivers/block/mtip32xx/mtip32xx.h
+++ b/drivers/block/mtip32xx/mtip32xx.h
@@ -493,19 +493,19 @@ struct driver_data {
 
 	struct workqueue_struct *isr_workq;
 
-	struct mtip_work work[MTIP_MAX_SLOT_GROUPS];
-
 	atomic_t irq_workers_active;
 
+	struct mtip_work work[MTIP_MAX_SLOT_GROUPS];
+
 	int isr_binding;
 
 	struct block_device *bdev;
 
-	int unal_qdepth; /* qdepth of unaligned IO queue */
-
 	struct list_head online_list; /* linkage for online list */
 
 	struct list_head remove_list; /* linkage for removing list */
+
+	int unal_qdepth; /* qdepth of unaligned IO queue */
 };
 
 #endif

