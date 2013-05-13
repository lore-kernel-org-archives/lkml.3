Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752570Ab3EMO3I (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 May 2013 10:29:08 -0400
Received: from mail-bk0-f48.google.com ([209.85.214.48]:44993 "EHLO
	mail-bk0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751205Ab3EMO3G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 May 2013 10:29:06 -0400
MIME-Version: 1.0
Date: Mon, 13 May 2013 22:29:04 +0800
Message-ID: <CAPgLHd8a0UuopsM53j5NsZz1UaqZoRK0_aK2m=XqC2iv-i9rAw@mail.gmail.com>
Subject: [PATCH v2] NVMe: fix error return code in nvme_submit_bio_queue()
From: Wei Yongjun <weiyj.lk@gmail.com>
To: willy@linux.intel.com, vishal.l.verma@intel.com
Cc: yongjun_wei@trendmicro.com.cn, linux-nvme@lists.infradead.org,
        linux-kernel@vger.kernel.org
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
v1 -> v2: send to mail list from MAINTAINERS
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

