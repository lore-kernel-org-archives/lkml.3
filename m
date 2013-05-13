Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753552Ab3EMCaG (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 May 2013 22:30:06 -0400
Received: from mail-wg0-f47.google.com ([74.125.82.47]:59712 "EHLO
	mail-wg0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753080Ab3EMCaF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 May 2013 22:30:05 -0400
MIME-Version: 1.0
Date: Mon, 13 May 2013 10:30:03 +0800
Message-ID: <CAPgLHd9dfox_xSu3Fb2JD_=UPC=-PVs=juiv3k408D1ns2CVJQ@mail.gmail.com>
Subject: [PATCH] NVMe: fix error return code in nvme_submit_bio_queue()
From: Wei Yongjun <weiyj.lk@gmail.com>
To: matthew.r.wilcox@intel.com, keith.busch@intel.com,
        vishal.l.verma@intel.com
Cc: yongjun_wei@trendmicro.com.cn, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>

Fix to return -ENOMEM in the nvem iod alloc error handling case instead
of 0(possible overwrite to 0 by above nvme_submit_flush_data()), as done
elsewhere in this function.

Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
---
 drivers/block/nvme-core.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/block/nvme-core.c b/drivers/block/nvme-core.c
index 8efdfaa..750c337 100644
--- a/drivers/block/nvme-core.c
+++ b/drivers/block/nvme-core.c
@@ -629,7 +629,7 @@ static int nvme_submit_bio_queue(struct nvme_queue *nvmeq, struct nvme_ns *ns,
 	struct nvme_command *cmnd;
 	struct nvme_iod *iod;
 	enum dma_data_direction dma_dir;
-	int cmdid, length, result = -ENOMEM;
+	int cmdid, length, result;
 	u16 control;
 	u32 dsmgmt;
 	int psegs = bio_phys_segments(ns->queue, bio);
@@ -641,8 +641,10 @@ static int nvme_submit_bio_queue(struct nvme_queue *nvmeq, struct nvme_ns *ns,
 	}
 
 	iod = nvme_alloc_iod(psegs, bio->bi_size, GFP_ATOMIC);
-	if (!iod)
+	if (!iod) {
+		result = -ENOMEM;
 		goto nomem;
+	}
 	iod->private = bio;
 
 	result = -EBUSY;

