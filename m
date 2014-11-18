Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755656AbaKRTmr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Nov 2014 14:42:47 -0500
Received: from mail-la0-f49.google.com ([209.85.215.49]:37458 "EHLO
	mail-la0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755571AbaKRTml (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Nov 2014 14:42:41 -0500
From: =?UTF-8?q?Matias=20Bj=C3=B8rling?= <m@bjorling.me>
To: hch@infradead.org, axboe@fb.com, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc: thornber@redhat.com, bvanassche@acm.org, jmad@itu.dk,
        =?UTF-8?q?Matias=20Bj=C3=B8rling?= <m@bjorling.me>
Subject: [RFC PATCH 5/5] null_blk: LightNVM integration
Date: Tue, 18 Nov 2014 20:41:59 +0100
Message-Id: <1416339719-8488-6-git-send-email-m@bjorling.me>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1416339719-8488-1-git-send-email-m@bjorling.me>
References: <1416339719-8488-1-git-send-email-m@bjorling.me>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Allows the null_blk driver to hook into LightNVM for performance
evaluation.

It is activated by passing lightnvm_enable parameter at module load.

The number of channels exposed to LightNVM can be configured
through the lightnvm_num_channels module parameter.

Contributions in this patch from:

  Jesper Madsen <jmad@itu.dk>

Signed-off-by: Matias Bjørling <m@bjorling.me>
---
 Documentation/block/null_blk.txt |  8 ++++
 drivers/block/null_blk.c         | 89 +++++++++++++++++++++++++++++++++++++---
 2 files changed, 92 insertions(+), 5 deletions(-)

diff --git a/Documentation/block/null_blk.txt b/Documentation/block/null_blk.txt
index b2830b4..a35e928 100644
--- a/Documentation/block/null_blk.txt
+++ b/Documentation/block/null_blk.txt
@@ -70,3 +70,11 @@ use_per_node_hctx=[0/1]: Default: 0
      parameter.
   1: The multi-queue block layer is instantiated with a hardware dispatch
      queue for each CPU node in the system.
+
+IV: LightNVM specific parameters
+
+lightnvm_enable=[x]: Default: 0
+  Enable LightNVM for null block devices. Requires blk-mq to be used.
+
+lightnvm_num_channels=[x]: Default: 1
+  Number of LightNVM channels that are exposed to the LightNVM driver.
diff --git a/drivers/block/null_blk.c b/drivers/block/null_blk.c
index 00d469c..4462941 100644
--- a/drivers/block/null_blk.c
+++ b/drivers/block/null_blk.c
@@ -7,6 +7,7 @@
 #include <linux/init.h>
 #include <linux/slab.h>
 #include <linux/blk-mq.h>
+#include <linux/lightnvm.h>
 #include <linux/hrtimer.h>
 
 struct nullb_cmd {
@@ -109,6 +110,14 @@ static bool use_per_node_hctx = false;
 module_param(use_per_node_hctx, bool, S_IRUGO);
 MODULE_PARM_DESC(use_per_node_hctx, "Use per-node allocation for hardware context queues. Default: false");
 
+static bool lightnvm_enable = false;
+module_param(lightnvm_enable, bool, S_IRUGO);
+MODULE_PARM_DESC(lightnvm_enable, "Enable LightNVM. Default: false");
+
+static int lightnvm_num_channels = 1;
+module_param(lightnvm_num_channels, int, S_IRUGO);
+MODULE_PARM_DESC(lightnvm_num_channels, "Number of channels to be exposed to LightNVM. Default: 1");
+
 static void put_tag(struct nullb_queue *nq, unsigned int tag)
 {
 	clear_bit_unlock(tag, nq->tag_map);
@@ -313,6 +322,55 @@ static void null_request_fn(struct request_queue *q)
 	}
 }
 
+static int null_nvm_id(struct request_queue *q, struct nvm_id *id)
+{
+	sector_t size = gb * 1024 * 1024 * 1024ULL;
+	unsigned long per_chnl_size =
+				size / bs / lightnvm_num_channels;
+	struct nvm_id_chnl *chnl;
+	int i;
+
+	id->ver_id = 0x1;
+	id->nvm_type = NVM_NVMT_BLK;
+	id->nchannels = lightnvm_num_channels;
+
+	id->chnls = kmalloc(sizeof(struct nvm_id_chnl) * id->nchannels,
+								GFP_KERNEL);
+	if (!id->chnls)
+		return -ENOMEM;
+
+	for (i = 0; i < id->nchannels; i++) {
+		chnl = &id->chnls[i];
+		chnl->queue_size = hw_queue_depth;
+		chnl->gran_read = bs;
+		chnl->gran_write = bs;
+		chnl->gran_erase = bs * 256;
+		chnl->oob_size = 0;
+		chnl->t_r = chnl->t_sqr = 25000; /* 25us */
+		chnl->t_w = chnl->t_sqw = 500000; /* 500us */
+		chnl->t_e = 1500000; /* 1.500us */
+		chnl->io_sched = NVM_IOSCHED_CHANNEL;
+		chnl->laddr_begin = per_chnl_size * i;
+		chnl->laddr_end = per_chnl_size * (i + 1) - 1;
+	}
+
+	return 0;
+}
+
+static int null_nvm_get_features(struct request_queue *q,
+						struct nvm_get_features *gf)
+{
+	gf->rsp[0] = (1 << NVM_RSP_L2P);
+	gf->rsp[0] |= (1 << NVM_RSP_P2L);
+	gf->rsp[0] |= (1 << NVM_RSP_GC);
+	return 0;
+}
+
+static int null_nvm_set_rsp(struct request_queue *q, u8 rsp, u8 val)
+{
+	return NVM_RID_NOT_CHANGEABLE | NVM_DNR;
+}
+
 static int null_queue_rq(struct blk_mq_hw_ctx *hctx, struct request *rq)
 {
 	struct nullb_cmd *cmd = blk_mq_rq_to_pdu(rq);
@@ -346,6 +404,12 @@ static int null_init_hctx(struct blk_mq_hw_ctx *hctx, void *data,
 	return 0;
 }
 
+static struct lightnvm_dev_ops null_nvm_dev_ops = {
+	.identify		= null_nvm_id,
+	.get_features		= null_nvm_get_features,
+	.set_responsibility	= null_nvm_set_rsp,
+};
+
 static struct blk_mq_ops null_mq_ops = {
 	.queue_rq       = null_queue_rq,
 	.map_queue      = blk_mq_map_queue,
@@ -488,6 +552,11 @@ static int null_add_dev(void)
 		nullb->tag_set.flags = BLK_MQ_F_SHOULD_MERGE;
 		nullb->tag_set.driver_data = nullb;
 
+		if (lightnvm_enable) {
+			nullb->tag_set.flags &= ~BLK_MQ_F_SHOULD_MERGE;
+			nullb->tag_set.flags |= BLK_MQ_F_LIGHTNVM;
+		}
+
 		rv = blk_mq_alloc_tag_set(&nullb->tag_set);
 		if (rv)
 			goto out_cleanup_queues;
@@ -525,11 +594,6 @@ static int null_add_dev(void)
 		goto out_cleanup_blk_queue;
 	}
 
-	mutex_lock(&lock);
-	list_add_tail(&nullb->list, &nullb_list);
-	nullb->index = nullb_indexes++;
-	mutex_unlock(&lock);
-
 	blk_queue_logical_block_size(nullb->q, bs);
 	blk_queue_physical_block_size(nullb->q, bs);
 
@@ -543,10 +607,25 @@ static int null_add_dev(void)
 	disk->fops		= &null_fops;
 	disk->private_data	= nullb;
 	disk->queue		= nullb->q;
+
+	if (lightnvm_enable && queue_mode == NULL_Q_MQ) {
+		if (blk_lightnvm_register(nullb->q, &null_nvm_dev_ops))
+			goto out_cleanup_nvm;
+
+		nullb->q->nvm->drv_cmd_size = sizeof(struct nullb_cmd);
+	}
+
+	mutex_lock(&lock);
+	list_add_tail(&nullb->list, &nullb_list);
+	nullb->index = nullb_indexes++;
+	mutex_unlock(&lock);
+
 	sprintf(disk->disk_name, "nullb%d", nullb->index);
 	add_disk(disk);
 	return 0;
 
+out_cleanup_nvm:
+	put_disk(disk);
 out_cleanup_blk_queue:
 	blk_cleanup_queue(nullb->q);
 out_cleanup_tags:
-- 
1.9.1

