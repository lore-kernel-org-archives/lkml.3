Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756279Ab3GCSlU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Jul 2013 14:41:20 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:19628 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933287Ab3GCSlH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Jul 2013 14:41:07 -0400
X-Authority-Analysis: v=2.0 cv=Tr1kdUrh c=1 sm=0 a=Sro2XwOs0tJUSHxCKfOySw==:17 a=Drc5e87SC40A:10 a=Ciwy3NGCPMMA:10 a=Zxz_FBXQesQA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=KGjhK52YXX0A:10 a=6okoZ3tEBtkA:10 a=Q-fNiiVtAAAA:8 a=VwQbUJbxAAAA:8 a=WTJdmG3rAAAA:8 a=J1Y8HTJGAAAA:8 a=D1T3PCv0mcP-1l4hmToA:9 a=T0y53QVARpkA:10 a=lcTMV_K9oDIA:10 a=nsF78Xlgl7EA:10 a=4N9Db7Z2_RYA:10 a=jeBq3FmKZ4MA:10 a=KAsoWJWSM9Hd71lH:21 a=RqvJfq8Kad-UpGZX:21 a=Sro2XwOs0tJUSHxCKfOySw==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 67.255.60.225
Message-Id: <20130703184054.173120506@goodmis.org>
User-Agent: quilt/0.60-1
Date: Wed, 03 Jul 2013 14:39:55 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Roland Dreier <roland@purestorage.com>,
        Nithin Nayak Sujir <nsujir@broadcom.com>,
        Michael Chan <mchan@broadcom.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [058/141] tg3: Add read dma workaround for 5720
References: <20130703183857.307196999@goodmis.org>
Content-Disposition: inline; filename=0058-tg3-Add-read-dma-workaround-for-5720.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6.11.6 stable review patch.
If anyone has any objections, please let me know.

------------------

From: Nithin Sujir <nsujir@broadcom.com>

[ Upstream commit 9bc297ea0622bb2a6b3abfa2fa84f0a3b86ef8c8 ]

Commit 091f0ea30074bc43f9250961b3247af713024bc6 "tg3: Add New 5719 Read
DMA workaround" added a workaround for TX DMA stall on the 5719. This
workaround needs to be applied to the 5720 as well.

Cc: stable@vger.kernel.org
Reported-by: Roland Dreier <roland@purestorage.com>
Tested-by: Roland Dreier <roland@purestorage.com>
Signed-off-by: Nithin Nayak Sujir <nsujir@broadcom.com>
Signed-off-by: Michael Chan <mchan@broadcom.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 drivers/net/ethernet/broadcom/tg3.c |   21 +++++++++++++++------
 drivers/net/ethernet/broadcom/tg3.h |    5 +++--
 2 files changed, 18 insertions(+), 8 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/tg3.c b/drivers/net/ethernet/broadcom/tg3.c
index 1e7f1a8..06d075c 100644
--- a/drivers/net/ethernet/broadcom/tg3.c
+++ b/drivers/net/ethernet/broadcom/tg3.c
@@ -8699,6 +8699,14 @@ static void tg3_rss_write_indir_tbl(struct tg3 *tp)
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
@@ -9350,16 +9358,17 @@ static int tg3_reset_hw(struct tg3 *tp, int reset_phy)
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
 
@@ -9715,15 +9724,15 @@ static void tg3_periodic_fetch_stats(struct tg3 *tp)
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
index 0f8e583..786ae2d 100644
--- a/drivers/net/ethernet/broadcom/tg3.h
+++ b/drivers/net/ethernet/broadcom/tg3.h
@@ -1379,7 +1379,8 @@
 #define TG3_LSO_RD_DMA_CRPTEN_CTRL	0x00004910
 #define TG3_LSO_RD_DMA_CRPTEN_CTRL_BLEN_BD_4K	 0x00030000
 #define TG3_LSO_RD_DMA_CRPTEN_CTRL_BLEN_LSO_4K	 0x000c0000
-#define TG3_LSO_RD_DMA_TX_LENGTH_WA	 0x02000000
+#define TG3_LSO_RD_DMA_TX_LENGTH_WA_5719	 0x02000000
+#define TG3_LSO_RD_DMA_TX_LENGTH_WA_5720	 0x00200000
 /* 0x4914 --> 0x4be0 unused */
 
 #define TG3_NUM_RDMA_CHANNELS		4
@@ -2966,7 +2967,7 @@ enum TG3_FLAGS {
 	TG3_FLAG_L1PLLPD_EN,
 	TG3_FLAG_APE_HAS_NCSI,
 	TG3_FLAG_4K_FIFO_LIMIT,
-	TG3_FLAG_5719_RDMA_BUG,
+	TG3_FLAG_5719_5720_RDMA_BUG,
 	TG3_FLAG_RESET_TASK_PENDING,
 	TG3_FLAG_5705_PLUS,
 	TG3_FLAG_IS_5788,
-- 
1.7.10.4


