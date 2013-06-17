Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754026Ab3FQR7O (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Jun 2013 13:59:14 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:50424 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753344Ab3FQRbn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Jun 2013 13:31:43 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Nithin Nayak Sujir <nsujir@broadcom.com>,
        Michael Chan <mchan@broadcom.com>,
        "David S. Miller" <davem@davemloft.net>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 07/84] tg3: Add read dma workaround for 5720
Date: Mon, 17 Jun 2013 10:30:11 -0700
Message-Id: <1371490288-23167-8-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1371490288-23167-1-git-send-email-kamal@canonical.com>
References: <1371490288-23167-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.3 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nithin Sujir <nsujir@broadcom.com>

commit 9bc297ea0622bb2a6b3abfa2fa84f0a3b86ef8c8 upstream.

Commit 091f0ea30074bc43f9250961b3247af713024bc6 "tg3: Add New 5719 Read
DMA workaround" added a workaround for TX DMA stall on the 5719. This
workaround needs to be applied to the 5720 as well.

Reported-by: Roland Dreier <roland@purestorage.com>
Tested-by: Roland Dreier <roland@purestorage.com>
Signed-off-by: Nithin Nayak Sujir <nsujir@broadcom.com>
Signed-off-by: Michael Chan <mchan@broadcom.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
[ kamal: backport to 3.8 ]
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/net/ethernet/broadcom/tg3.c | 21 +++++++++++++++------
 drivers/net/ethernet/broadcom/tg3.h |  5 +++--
 2 files changed, 18 insertions(+), 8 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/tg3.c b/drivers/net/ethernet/broadcom/tg3.c
index 6917998..591ba95 100644
--- a/drivers/net/ethernet/broadcom/tg3.c
+++ b/drivers/net/ethernet/broadcom/tg3.c
@@ -8981,6 +8981,14 @@ static void tg3_rss_write_indir_tbl(struct tg3 *tp)
 	}
 }
 
+static inline u32 tg3_lso_rd_dma_workaround_bit(struct tg3 *tp)
+{
+	if (GET_ASIC_REV(tp->pci_chip_rev_id) == ASIC_REV_5719)
+		return TG3_LSO_RD_DMA_TX_LENGTH_WA_5719;
+	else
+		return TG3_LSO_RD_DMA_TX_LENGTH_WA_5720;
+}
+
 /* tp->lock is held. */
 static int tg3_reset_hw(struct tg3 *tp, int reset_phy)
 {
@@ -9638,16 +9646,17 @@ static int tg3_reset_hw(struct tg3 *tp, int reset_phy)
 	tw32_f(RDMAC_MODE, rdmac_mode);
 	udelay(40);
 
-	if (GET_ASIC_REV(tp->pci_chip_rev_id) == ASIC_REV_5719) {
+	if (GET_ASIC_REV(tp->pci_chip_rev_id) == ASIC_REV_5719 ||
+	    GET_ASIC_REV(tp->pci_chip_rev_id) == ASIC_REV_5720) {
 		for (i = 0; i < TG3_NUM_RDMA_CHANNELS; i++) {
 			if (tr32(TG3_RDMA_LENGTH + (i << 2)) > TG3_MAX_MTU(tp))
 				break;
 		}
 		if (i < TG3_NUM_RDMA_CHANNELS) {
 			val = tr32(TG3_LSO_RD_DMA_CRPTEN_CTRL);
-			val |= TG3_LSO_RD_DMA_TX_LENGTH_WA;
+			val |= tg3_lso_rd_dma_workaround_bit(tp);
 			tw32(TG3_LSO_RD_DMA_CRPTEN_CTRL, val);
-			tg3_flag_set(tp, 5719_RDMA_BUG);
+			tg3_flag_set(tp, 5719_5720_RDMA_BUG);
 		}
 	}
 
@@ -10003,15 +10012,15 @@ static void tg3_periodic_fetch_stats(struct tg3 *tp)
 	TG3_STAT_ADD32(&sp->tx_ucast_packets, MAC_TX_STATS_UCAST);
 	TG3_STAT_ADD32(&sp->tx_mcast_packets, MAC_TX_STATS_MCAST);
 	TG3_STAT_ADD32(&sp->tx_bcast_packets, MAC_TX_STATS_BCAST);
-	if (unlikely(tg3_flag(tp, 5719_RDMA_BUG) &&
+	if (unlikely(tg3_flag(tp, 5719_5720_RDMA_BUG) &&
 		     (sp->tx_ucast_packets.low + sp->tx_mcast_packets.low +
 		      sp->tx_bcast_packets.low) > TG3_NUM_RDMA_CHANNELS)) {
 		u32 val;
 
 		val = tr32(TG3_LSO_RD_DMA_CRPTEN_CTRL);
-		val &= ~TG3_LSO_RD_DMA_TX_LENGTH_WA;
+		val &= ~tg3_lso_rd_dma_workaround_bit(tp);
 		tw32(TG3_LSO_RD_DMA_CRPTEN_CTRL, val);
-		tg3_flag_clear(tp, 5719_RDMA_BUG);
+		tg3_flag_clear(tp, 5719_5720_RDMA_BUG);
 	}
 
 	TG3_STAT_ADD32(&sp->rx_octets, MAC_RX_STATS_OCTETS);
diff --git a/drivers/net/ethernet/broadcom/tg3.h b/drivers/net/ethernet/broadcom/tg3.h
index 6f9b74c..3deec2b 100644
--- a/drivers/net/ethernet/broadcom/tg3.h
+++ b/drivers/net/ethernet/broadcom/tg3.h
@@ -1417,7 +1417,8 @@
 #define TG3_LSO_RD_DMA_CRPTEN_CTRL	0x00004910
 #define TG3_LSO_RD_DMA_CRPTEN_CTRL_BLEN_BD_4K	 0x00030000
 #define TG3_LSO_RD_DMA_CRPTEN_CTRL_BLEN_LSO_4K	 0x000c0000
-#define TG3_LSO_RD_DMA_TX_LENGTH_WA	 0x02000000
+#define TG3_LSO_RD_DMA_TX_LENGTH_WA_5719	 0x02000000
+#define TG3_LSO_RD_DMA_TX_LENGTH_WA_5720	 0x00200000
 /* 0x4914 --> 0x4be0 unused */
 
 #define TG3_NUM_RDMA_CHANNELS		4
@@ -3021,7 +3022,7 @@ enum TG3_FLAGS {
 	TG3_FLAG_APE_HAS_NCSI,
 	TG3_FLAG_TX_TSTAMP_EN,
 	TG3_FLAG_4K_FIFO_LIMIT,
-	TG3_FLAG_5719_RDMA_BUG,
+	TG3_FLAG_5719_5720_RDMA_BUG,
 	TG3_FLAG_RESET_TASK_PENDING,
 	TG3_FLAG_PTP_CAPABLE,
 	TG3_FLAG_5705_PLUS,
-- 
1.8.1.2

