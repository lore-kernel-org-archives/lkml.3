Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753792AbaBLIgw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Feb 2014 03:36:52 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:50078 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751815AbaBLINu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Feb 2014 03:13:50 -0500
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "Dmitry Kravkov" <dmitry@broadcom.com>,
        "David S. Miller" <davem@davemloft.net>,
        "Michal Schmidt" <mschmidt@redhat.com>,
        "Eric Dumazet" <edumazet@google.com>
Date: Wed, 12 Feb 2014 08:10:12 +0000
Message-ID: <lsq.1392192612.510678529@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [PATCH 3.2 15/79] bnx2x: fix DMA unmapping of TSO split BDs
In-Reply-To: <lsq.1392192611.998273004@decadent.org.uk>
X-SA-Exim-Connect-IP: 91.84.160.45
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.55-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Michal Schmidt <mschmidt@redhat.com>

[ Upstream commit 95e92fd40c967c363ad66b2fd1ce4dcd68132e54 ]

bnx2x triggers warnings with CONFIG_DMA_API_DEBUG=y:

  WARNING: CPU: 0 PID: 2253 at lib/dma-debug.c:887 check_unmap+0xf8/0x920()
  bnx2x 0000:28:00.0: DMA-API: device driver frees DMA memory with
  different size [device address=0x00000000da2b389e] [map size=1490 bytes]
  [unmap size=66 bytes]

The reason is that bnx2x splits a TSO BD into two BDs (headers + data)
using one DMA mapping for both, but it uses only the length of the first
BD when unmapping.

This patch fixes the bug by unmapping the whole length of the two BDs.

Signed-off-by: Michal Schmidt <mschmidt@redhat.com>
Reviewed-by: Eric Dumazet <edumazet@google.com>
Acked-by: Dmitry Kravkov <dmitry@broadcom.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/net/ethernet/broadcom/bnx2x/bnx2x_cmn.c | 13 +++++++++----
 1 file changed, 9 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/bnx2x/bnx2x_cmn.c b/drivers/net/ethernet/broadcom/bnx2x/bnx2x_cmn.c
index bbb6692..e367ab1 100644
--- a/drivers/net/ethernet/broadcom/bnx2x/bnx2x_cmn.c
+++ b/drivers/net/ethernet/broadcom/bnx2x/bnx2x_cmn.c
@@ -108,6 +108,7 @@ static u16 bnx2x_free_tx_pkt(struct bnx2x *bp, struct bnx2x_fp_txdata *txdata,
 	struct sk_buff *skb = tx_buf->skb;
 	u16 bd_idx = TX_BD(tx_buf->first_bd), new_cons;
 	int nbd;
+	u16 split_bd_len = 0;
 
 	/* prefetch skb end pointer to speedup dev_kfree_skb() */
 	prefetch(&skb->end);
@@ -115,11 +116,8 @@ static u16 bnx2x_free_tx_pkt(struct bnx2x *bp, struct bnx2x_fp_txdata *txdata,
 	DP(BNX2X_MSG_FP, "fp[%d]: pkt_idx %d  buff @(%p)->skb %p\n",
 	   txdata->txq_index, idx, tx_buf, skb);
 
-	/* unmap first bd */
 	DP(BNX2X_MSG_OFF, "free bd_idx %d\n", bd_idx);
 	tx_start_bd = &txdata->tx_desc_ring[bd_idx].start_bd;
-	dma_unmap_single(&bp->pdev->dev, BD_UNMAP_ADDR(tx_start_bd),
-			 BD_UNMAP_LEN(tx_start_bd), DMA_TO_DEVICE);
 
 
 	nbd = le16_to_cpu(tx_start_bd->nbd) - 1;
@@ -138,12 +136,19 @@ static u16 bnx2x_free_tx_pkt(struct bnx2x *bp, struct bnx2x_fp_txdata *txdata,
 	--nbd;
 	bd_idx = TX_BD(NEXT_TX_IDX(bd_idx));
 
-	/* ...and the TSO split header bd since they have no mapping */
+	/* TSO headers+data bds share a common mapping. See bnx2x_tx_split() */
 	if (tx_buf->flags & BNX2X_TSO_SPLIT_BD) {
+		tx_data_bd = &txdata->tx_desc_ring[bd_idx].reg_bd;
+		split_bd_len = BD_UNMAP_LEN(tx_data_bd);
 		--nbd;
 		bd_idx = TX_BD(NEXT_TX_IDX(bd_idx));
 	}
 
+	/* unmap first bd */
+	dma_unmap_single(&bp->pdev->dev, BD_UNMAP_ADDR(tx_start_bd),
+			 BD_UNMAP_LEN(tx_start_bd) + split_bd_len,
+			 DMA_TO_DEVICE);
+
 	/* now free frags */
 	while (nbd > 0) {
 

