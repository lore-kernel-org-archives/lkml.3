Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755658AbaBGL7E (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Feb 2014 06:59:04 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:42476 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755339AbaBGLwe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Feb 2014 06:52:34 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Michal Schmidt <mschmidt@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 212/233] bnx2x: fix DMA unmapping of TSO split BDs
Date: Fri,  7 Feb 2014 11:47:11 +0000
Message-Id: <1391773652-25214-213-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1391773652-25214-1-git-send-email-luis.henriques@canonical.com>
References: <1391773652-25214-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.4 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Michal Schmidt <mschmidt@redhat.com>

commit 95e92fd40c967c363ad66b2fd1ce4dcd68132e54 upstream.

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
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/net/ethernet/broadcom/bnx2x/bnx2x_cmn.c | 13 +++++++++----
 1 file changed, 9 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/bnx2x/bnx2x_cmn.c b/drivers/net/ethernet/broadcom/bnx2x/bnx2x_cmn.c
index 4b0877e..6e49403 100644
--- a/drivers/net/ethernet/broadcom/bnx2x/bnx2x_cmn.c
+++ b/drivers/net/ethernet/broadcom/bnx2x/bnx2x_cmn.c
@@ -160,6 +160,7 @@ static u16 bnx2x_free_tx_pkt(struct bnx2x *bp, struct bnx2x_fp_txdata *txdata,
 	struct sk_buff *skb = tx_buf->skb;
 	u16 bd_idx = TX_BD(tx_buf->first_bd), new_cons;
 	int nbd;
+	u16 split_bd_len = 0;
 
 	/* prefetch skb end pointer to speedup dev_kfree_skb() */
 	prefetch(&skb->end);
@@ -167,10 +168,7 @@ static u16 bnx2x_free_tx_pkt(struct bnx2x *bp, struct bnx2x_fp_txdata *txdata,
 	DP(NETIF_MSG_TX_DONE, "fp[%d]: pkt_idx %d  buff @(%p)->skb %p\n",
 	   txdata->txq_index, idx, tx_buf, skb);
 
-	/* unmap first bd */
 	tx_start_bd = &txdata->tx_desc_ring[bd_idx].start_bd;
-	dma_unmap_single(&bp->pdev->dev, BD_UNMAP_ADDR(tx_start_bd),
-			 BD_UNMAP_LEN(tx_start_bd), DMA_TO_DEVICE);
 
 	nbd = le16_to_cpu(tx_start_bd->nbd) - 1;
 #ifdef BNX2X_STOP_ON_ERROR
@@ -188,12 +186,19 @@ static u16 bnx2x_free_tx_pkt(struct bnx2x *bp, struct bnx2x_fp_txdata *txdata,
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
 
-- 
1.8.3.2

