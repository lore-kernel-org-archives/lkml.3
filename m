Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754065Ab3CZWnS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Mar 2013 18:43:18 -0400
Received: from mga03.intel.com ([143.182.124.21]:4199 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751845Ab3CZWnQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Mar 2013 18:43:16 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,915,1355126400"; 
   d="scan'208";a="219198759"
Subject: [PATCH 07/10] ioatdma: skip silicon bug workaround for pq_align for
 cb3.3
To: djbw@fb.com
From: Dave Jiang <dave.jiang@intel.com>
Cc: vinod.koul@intel.com, linux-kernel@vger.kernel.org
Date: Tue, 26 Mar 2013 15:43:15 -0700
Message-ID: <20130326224315.15072.95238.stgit@djiang5-linux2.ch.intel.com>
In-Reply-To: <20130326223953.15072.26605.stgit@djiang5-linux2.ch.intel.com>
References: <20130326223953.15072.26605.stgit@djiang5-linux2.ch.intel.com>
User-Agent: StGit/0.16
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The alignment workaround is only necessary for cb3.2 or earlier platforms.

Signed-off-by: Dave Jiang <dave.jiang@intel.com>
---
 drivers/dma/ioat/dma_v3.c |   12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

diff --git a/drivers/dma/ioat/dma_v3.c b/drivers/dma/ioat/dma_v3.c
index a6d4175..a55c346 100644
--- a/drivers/dma/ioat/dma_v3.c
+++ b/drivers/dma/ioat/dma_v3.c
@@ -1549,10 +1549,14 @@ int ioat3_dma_probe(struct ioatdma_device *device, int dca)
 		dma_cap_set(DMA_XOR_VAL, dma->cap_mask);
 		dma->device_prep_dma_xor_val = ioat3_prep_xor_val;
 	}
+
 	if (cap & IOAT_CAP_PQ) {
 		is_raid_device = true;
 		dma_set_maxpq(dma, 8, 0);
-		dma->pq_align = 6;
+		if (is_xeon_cb32(pdev))
+			dma->pq_align = 6;
+		else
+			dma->pq_align = 0;
 
 		dma_cap_set(DMA_PQ, dma->cap_mask);
 		dma->device_prep_dma_pq = ioat3_prep_pq;
@@ -1562,7 +1566,10 @@ int ioat3_dma_probe(struct ioatdma_device *device, int dca)
 
 		if (!(cap & IOAT_CAP_XOR)) {
 			dma->max_xor = 8;
-			dma->xor_align = 6;
+			if (is_xeon_cb32(pdev))
+				dma->xor_align = 6;
+			else
+				dma->xor_align = 0;
 
 			dma_cap_set(DMA_XOR, dma->cap_mask);
 			dma->device_prep_dma_xor = ioat3_prep_pqxor;
@@ -1571,6 +1578,7 @@ int ioat3_dma_probe(struct ioatdma_device *device, int dca)
 			dma->device_prep_dma_xor_val = ioat3_prep_pqxor_val;
 		}
 	}
+
 	if (is_raid_device && (cap & IOAT_CAP_FILL_BLOCK)) {
 		dma_cap_set(DMA_MEMSET, dma->cap_mask);
 		dma->device_prep_dma_memset = ioat3_prep_memset_lock;

