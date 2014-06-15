Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752833AbaFOUjN (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Jun 2014 16:39:13 -0400
Received: from smtprelay0102.hostedemail.com ([216.40.44.102]:40135 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752656AbaFOUjI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Jun 2014 16:39:08 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::,RULES_HIT:41:69:355:379:541:800:960:973:988:989:1260:1345:1359:1437:1534:1542:1711:1730:1747:1777:1792:2194:2199:2393:2559:2562:3138:3139:3140:3141:3142:3352:3865:3866:3868:4225:4250:4321:4605:5007:6261:10004:10026:10848:11026:11473:11658:11914:12043:12296:12517:12519:12555,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: bikes07_6c99d1e94e01e
X-Filterd-Recvd-Size: 2821
From: Joe Perches <joe@perches.com>
To: linux-kernel@vger.kernel.org
Cc: "James E.J. Bottomley" <JBottomley@parallels.com>,
        linux-scsi@vger.kernel.org
Subject: [PATCH -next 21/26] mvsas: Use dma_zalloc_coherent
Date: Sun, 15 Jun 2014 13:37:50 -0700
Message-Id: <14794c36cbcb12d3ceac3f99773d4c8921d13734.1402863905.git.joe@perches.com>
X-Mailer: git-send-email 1.8.1.2.459.gbcd45b4.dirty
In-Reply-To: <cover.1402863904.git.joe@perches.com>
References: <cover.1402863904.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use the zeroing function instead of dma_alloc_coherent & memset(,0,)

Signed-off-by: Joe Perches <joe@perches.com>
---
 drivers/scsi/mvsas/mv_init.c | 26 +++++++++++---------------
 1 file changed, 11 insertions(+), 15 deletions(-)

diff --git a/drivers/scsi/mvsas/mv_init.c b/drivers/scsi/mvsas/mv_init.c
index eacee48..9aedbd5 100644
--- a/drivers/scsi/mvsas/mv_init.c
+++ b/drivers/scsi/mvsas/mv_init.c
@@ -263,33 +263,29 @@ static int mvs_alloc(struct mvs_info *mvi, struct Scsi_Host *shost)
 	/*
 	 * alloc and init our DMA areas
 	 */
-	mvi->tx = dma_alloc_coherent(mvi->dev,
-				     sizeof(*mvi->tx) * MVS_CHIP_SLOT_SZ,
-				     &mvi->tx_dma, GFP_KERNEL);
+	mvi->tx = dma_zalloc_coherent(mvi->dev,
+				      sizeof(*mvi->tx) * MVS_CHIP_SLOT_SZ,
+				      &mvi->tx_dma, GFP_KERNEL);
 	if (!mvi->tx)
 		goto err_out;
-	memset(mvi->tx, 0, sizeof(*mvi->tx) * MVS_CHIP_SLOT_SZ);
-	mvi->rx_fis = dma_alloc_coherent(mvi->dev, MVS_RX_FISL_SZ,
-					 &mvi->rx_fis_dma, GFP_KERNEL);
+
+	mvi->rx_fis = dma_zalloc_coherent(mvi->dev, MVS_RX_FISL_SZ,
+					  &mvi->rx_fis_dma, GFP_KERNEL);
 	if (!mvi->rx_fis)
 		goto err_out;
-	memset(mvi->rx_fis, 0, MVS_RX_FISL_SZ);
 
-	mvi->rx = dma_alloc_coherent(mvi->dev,
-				     sizeof(*mvi->rx) * (MVS_RX_RING_SZ + 1),
-				     &mvi->rx_dma, GFP_KERNEL);
+	mvi->rx = dma_zalloc_coherent(mvi->dev,
+				      sizeof(*mvi->rx) * (MVS_RX_RING_SZ + 1),
+				      &mvi->rx_dma, GFP_KERNEL);
 	if (!mvi->rx)
 		goto err_out;
-	memset(mvi->rx, 0, sizeof(*mvi->rx) * (MVS_RX_RING_SZ + 1));
 	mvi->rx[0] = cpu_to_le32(0xfff);
 	mvi->rx_cons = 0xfff;
 
-	mvi->slot = dma_alloc_coherent(mvi->dev,
-				       sizeof(*mvi->slot) * slot_nr,
-				       &mvi->slot_dma, GFP_KERNEL);
+	mvi->slot = dma_zalloc_coherent(mvi->dev, sizeof(*mvi->slot) * slot_nr,
+					&mvi->slot_dma, GFP_KERNEL);
 	if (!mvi->slot)
 		goto err_out;
-	memset(mvi->slot, 0, sizeof(*mvi->slot) * slot_nr);
 
 	mvi->bulk_buffer = dma_alloc_coherent(mvi->dev,
 				       TRASH_BUCKET_SIZE,
-- 
1.8.1.2.459.gbcd45b4.dirty

