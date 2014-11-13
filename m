Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933995AbaKMTZQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Nov 2014 14:25:16 -0500
Received: from mail-yk0-f174.google.com ([209.85.160.174]:33792 "EHLO
	mail-yk0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933974AbaKMTZD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Nov 2014 14:25:03 -0500
From: Pranith Kumar <bobby.prani@gmail.com>
To: Dan Williams <dan.j.williams@intel.com>, Vinod Koul <vinod.koul@intel.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        "David S. Miller" <davem@davemloft.net>,
        Thomas Gleixner <tglx@linutronix.de>,
        =?UTF-8?q?Manuel=20Sch=C3=B6lling?= <manuel.schoelling@gmx.de>,
        Dave Jiang <dave.jiang@intel.com>, Rashika <rashika.kheria@gmail.com>,
        dmaengine@vger.kernel.org (open list:DMA GENERIC OFFLO...),
        linux-kernel@vger.kernel.org (open list)
Cc: paulmck@linux.vnet.ibm.com
Subject: [PATCH 03/16] drivers: dma: Replace smp_read_barrier_depends() with lockless_dereference()
Date: Thu, 13 Nov 2014 14:24:09 -0500
Message-Id: <1415906662-4576-4-git-send-email-bobby.prani@gmail.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1415906662-4576-1-git-send-email-bobby.prani@gmail.com>
References: <1415906662-4576-1-git-send-email-bobby.prani@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Recently lockless_dereference() was added which can be used in place of
hard-coding smp_read_barrier_depends(). The following PATCH makes the change.

Signed-off-by: Pranith Kumar <bobby.prani@gmail.com>
---
 drivers/dma/ioat/dma_v2.c | 3 +--
 drivers/dma/ioat/dma_v3.c | 3 +--
 2 files changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/dma/ioat/dma_v2.c b/drivers/dma/ioat/dma_v2.c
index 695483e..0f94d72 100644
--- a/drivers/dma/ioat/dma_v2.c
+++ b/drivers/dma/ioat/dma_v2.c
@@ -142,10 +142,9 @@ static void __cleanup(struct ioat2_dma_chan *ioat, dma_addr_t phys_complete)
 
 	active = ioat2_ring_active(ioat);
 	for (i = 0; i < active && !seen_current; i++) {
-		smp_read_barrier_depends();
 		prefetch(ioat2_get_ring_ent(ioat, idx + i + 1));
 		desc = ioat2_get_ring_ent(ioat, idx + i);
-		tx = &desc->txd;
+		tx = &lockless_dereference(desc)->txd;
 		dump_desc_dbg(ioat, desc);
 		if (tx->cookie) {
 			dma_descriptor_unmap(tx);
diff --git a/drivers/dma/ioat/dma_v3.c b/drivers/dma/ioat/dma_v3.c
index 895f869..cbd0537 100644
--- a/drivers/dma/ioat/dma_v3.c
+++ b/drivers/dma/ioat/dma_v3.c
@@ -389,7 +389,6 @@ static void __cleanup(struct ioat2_dma_chan *ioat, dma_addr_t phys_complete)
 	for (i = 0; i < active && !seen_current; i++) {
 		struct dma_async_tx_descriptor *tx;
 
-		smp_read_barrier_depends();
 		prefetch(ioat2_get_ring_ent(ioat, idx + i + 1));
 		desc = ioat2_get_ring_ent(ioat, idx + i);
 		dump_desc_dbg(ioat, desc);
@@ -398,7 +397,7 @@ static void __cleanup(struct ioat2_dma_chan *ioat, dma_addr_t phys_complete)
 		if (device->cap & IOAT_CAP_DWBES)
 			desc_get_errstat(ioat, desc);
 
-		tx = &desc->txd;
+		tx = &lockless_dereference(desc)->txd;
 		if (tx->cookie) {
 			dma_cookie_complete(tx);
 			dma_descriptor_unmap(tx);
-- 
1.9.1

