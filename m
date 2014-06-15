Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752286AbaFOUiT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Jun 2014 16:38:19 -0400
Received: from smtprelay0229.hostedemail.com ([216.40.44.229]:56010 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751762AbaFOUiO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Jun 2014 16:38:14 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::,RULES_HIT:41:355:379:541:800:960:973:982:988:989:1260:1345:1359:1437:1534:1542:1711:1730:1747:1777:1792:2393:2559:2562:3138:3139:3140:3141:3142:3352:3865:3866:3870:4605:5007:6261:8603:9592:10004:10026:10848:11026:11233:11473:11657:11658:11914:12043:12296:12438:12517:12519:12555:13095,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: leaf42_64c0bd1ca232c
X-Filterd-Recvd-Size: 2856
From: Joe Perches <joe@perches.com>
To: linux-kernel@vger.kernel.org
Cc: Olof Johansson <olof@lixom.net>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>, linuxppc-dev@lists.ozlabs.org
Subject: [PATCH -next 01/26] powerpc: Use dma_zalloc_coherent
Date: Sun, 15 Jun 2014 13:37:30 -0700
Message-Id: <ceb2b3214fbb7c5ea5e356d35df4d0b38b90a41a.1402863905.git.joe@perches.com>
X-Mailer: git-send-email 1.8.1.2.459.gbcd45b4.dirty
In-Reply-To: <cover.1402863904.git.joe@perches.com>
References: <cover.1402863904.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use the zeroing function instead of dma_alloc_coherent & memset(,0,)

Signed-off-by: Joe Perches <joe@perches.com>
---
 arch/powerpc/platforms/pasemi/dma_lib.c | 8 +++-----
 arch/powerpc/sysdev/fsl_rmu.c           | 9 ++++-----
 2 files changed, 7 insertions(+), 10 deletions(-)

diff --git a/arch/powerpc/platforms/pasemi/dma_lib.c b/arch/powerpc/platforms/pasemi/dma_lib.c
index aafa01ba..52b391f 100644
--- a/arch/powerpc/platforms/pasemi/dma_lib.c
+++ b/arch/powerpc/platforms/pasemi/dma_lib.c
@@ -255,15 +255,13 @@ int pasemi_dma_alloc_ring(struct pasemi_dmachan *chan, int ring_size)
 
 	chan->ring_size = ring_size;
 
-	chan->ring_virt = dma_alloc_coherent(&dma_pdev->dev,
-					     ring_size * sizeof(u64),
-					     &chan->ring_dma, GFP_KERNEL);
+	chan->ring_virt = dma_zalloc_coherent(&dma_pdev->dev,
+					      ring_size * sizeof(u64),
+					      &chan->ring_dma, GFP_KERNEL);
 
 	if (!chan->ring_virt)
 		return -ENOMEM;
 
-	memset(chan->ring_virt, 0, ring_size * sizeof(u64));
-
 	return 0;
 }
 EXPORT_SYMBOL(pasemi_dma_alloc_ring);
diff --git a/arch/powerpc/sysdev/fsl_rmu.c b/arch/powerpc/sysdev/fsl_rmu.c
index b48197a..34b49fc 100644
--- a/arch/powerpc/sysdev/fsl_rmu.c
+++ b/arch/powerpc/sysdev/fsl_rmu.c
@@ -744,15 +744,14 @@ fsl_open_outb_mbox(struct rio_mport *mport, void *dev_id, int mbox, int entries)
 	}
 
 	/* Initialize outbound message descriptor ring */
-	rmu->msg_tx_ring.virt = dma_alloc_coherent(priv->dev,
-				rmu->msg_tx_ring.size * RIO_MSG_DESC_SIZE,
-				&rmu->msg_tx_ring.phys, GFP_KERNEL);
+	rmu->msg_tx_ring.virt = dma_zalloc_coherent(priv->dev,
+						    rmu->msg_tx_ring.size * RIO_MSG_DESC_SIZE,
+						    &rmu->msg_tx_ring.phys,
+						    GFP_KERNEL);
 	if (!rmu->msg_tx_ring.virt) {
 		rc = -ENOMEM;
 		goto out_dma;
 	}
-	memset(rmu->msg_tx_ring.virt, 0,
-			rmu->msg_tx_ring.size * RIO_MSG_DESC_SIZE);
 	rmu->msg_tx_ring.tx_slot = 0;
 
 	/* Point dequeue/enqueue pointers at first entry in ring */
-- 
1.8.1.2.459.gbcd45b4.dirty

