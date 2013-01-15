Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756754Ab3AOQBt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2013 11:01:49 -0500
Received: from wolverine01.qualcomm.com ([199.106.114.254]:27912 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752734Ab3AOQBr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2013 11:01:47 -0500
X-IronPort-AV: E=Sophos;i="4.84,473,1355126400"; 
   d="scan'208";a="19985805"
From: Subhash Jadavani <subhashj@codeaurora.org>
To: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
Cc: linux-mmc@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        Subhash Jadavani <subhashj@codeaurora.org>
Subject: [PATCH v2 1/1] block: blk-merge: don't merge the pages with non-contiguous descriptors
Date: Tue, 15 Jan 2013 21:31:21 +0530
Message-Id: <1358265681-25671-1-git-send-email-subhashj@codeaurora.org>
X-Mailer: git-send-email 1.7.8.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

blk_rq_map_sg() function merges the physically contiguous pages to use same
scatter-gather node without checking if their page descriptors are
contiguous or not.

Now when dma_map_sg() is called on the scatter gather list, it would
take the base page pointer from each node (one by one) and iterates
through all of the pages in same sg node by keep incrementing the base
page pointer with the assumption that physically contiguous pages will
have their page descriptor address contiguous which may not be true
if SPARSEMEM config is enabled. So here we may end referring to invalid
page descriptor.

Following table shows the example of physically contiguous pages but
their page descriptor addresses non-contiguous.
-------------------------------------------
| Page Descriptor    |   Physical Address |
------------------------------------------
| 0xc1e43fdc         |   0xdffff000       |
| 0xc2052000         |   0xe0000000       |
-------------------------------------------

With this patch, relevant blk-merge functions will also check if the
physically contiguous pages are having page descriptors address contiguous
or not? If not then, these pages are separated to be in different
scatter-gather nodes.

Signed-off-by: Subhash Jadavani <subhashj@codeaurora.org>
---
 block/blk-merge.c |    6 ++++++
 1 files changed, 6 insertions(+), 0 deletions(-)

diff --git a/block/blk-merge.c b/block/blk-merge.c
index 936a110..6eaef3d4 100644
--- a/block/blk-merge.c
+++ b/block/blk-merge.c
@@ -42,6 +42,9 @@ static unsigned int __blk_recalc_rq_segments(struct request_queue *q,
 					goto new_segment;
 				if (!BIOVEC_SEG_BOUNDARY(q, bvprv, bv))
 					goto new_segment;
+				if ((bvprv->bv_page != bv->bv_page) &&
+				    (bvprv->bv_page + 1) != bv->bv_page)
+					goto new_segment;
 
 				seg_size += bv->bv_len;
 				bvprv = bv;
@@ -126,6 +129,9 @@ __blk_segment_map_sg(struct request_queue *q, struct bio_vec *bvec,
 			goto new_segment;
 		if (!BIOVEC_SEG_BOUNDARY(q, *bvprv, bvec))
 			goto new_segment;
+		if (((*bvprv)->bv_page != bvec->bv_page) &&
+		    (((*bvprv)->bv_page + 1) != bvec->bv_page))
+			goto new_segment;
 
 		(*sg)->length += nbytes;
 	} else {
-- 
--
QUALCOMM INDIA, on behalf of Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum, hosted by The Linux Foundation

