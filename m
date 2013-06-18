Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932451Ab3FRL5g (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Jun 2013 07:57:36 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:56136 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756018Ab3FRLot (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Jun 2013 07:44:49 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Michael Chan <mchan@broadcom.com>, "David S. Miller" <davem@davemloft.net>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 53/93] tg3: Add New 5719 Read DMA workaround
Date: Tue, 18 Jun 2013 12:43:01 +0100
Message-Id: <1371555821-12820-54-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1371555821-12820-1-git-send-email-luis.henriques@canonical.com>
References: <1371555821-12820-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.15 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Michael Chan <mchan@broadcom.com>

commit 091f0ea30074bc43f9250961b3247af713024bc6 upstream.

After Power-on-reset, the 5719's TX DMA length registers may contain
uninitialized values and cause TX DMA to stall.  Check for invalid
values and set a register bit to flush the TX channels.  The bit
needs to be turned off after the DMA channels have been flushed.

Signed-off-by: Michael Chan <mchan@broadcom.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/net/ethernet/broadcom/tg3.c | 23 +++++++++++++++++++++++
 drivers/net/ethernet/broadcom/tg3.h |  7 ++++++-
 2 files changed, 29 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/broadcom/tg3.c b/drivers/net/ethernet/broadcom/tg3.c
index 99d4d07..8f2b8aa 100644
--- a/drivers/net/ethernet/broadcom/tg3.c
+++ b/drivers/net/ethernet/broadcom/tg3.c
@@ -9208,6 +9208,19 @@ static int tg3_reset_hw(struct tg3 *tp, int reset_phy)
 	tw32_f(RDMAC_MODE, rdmac_mode);
 	udelay(40);
 
+	if (GET_ASIC_REV(tp->pci_chip_rev_id) == ASIC_REV_5719) {
+		for (i = 0; i < TG3_NUM_RDMA_CHANNELS; i++) {
+			if (tr32(TG3_RDMA_LENGTH + (i << 2)) > TG3_MAX_MTU(tp))
+				break;
+		}
+		if (i < TG3_NUM_RDMA_CHANNELS) {
+			val = tr32(TG3_LSO_RD_DMA_CRPTEN_CTRL);
+			val |= TG3_LSO_RD_DMA_TX_LENGTH_WA;
+			tw32(TG3_LSO_RD_DMA_CRPTEN_CTRL, val);
+			tg3_flag_set(tp, 5719_RDMA_BUG);
+		}
+	}
+
 	tw32(RCVDCC_MODE, RCVDCC_MODE_ENABLE | RCVDCC_MODE_ATTN_ENABLE);
 	if (!tg3_flag(tp, 5705_PLUS))
 		tw32(MBFREE_MODE, MBFREE_MODE_ENABLE);
@@ -9463,6 +9476,16 @@ static void tg3_periodic_fetch_stats(struct tg3 *tp)
 	TG3_STAT_ADD32(&sp->tx_ucast_packets, MAC_TX_STATS_UCAST);
 	TG3_STAT_ADD32(&sp->tx_mcast_packets, MAC_TX_STATS_MCAST);
 	TG3_STAT_ADD32(&sp->tx_bcast_packets, MAC_TX_STATS_BCAST);
+	if (unlikely(tg3_flag(tp, 5719_RDMA_BUG) &&
+		     (sp->tx_ucast_packets.low + sp->tx_mcast_packets.low +
+		      sp->tx_bcast_packets.low) > TG3_NUM_RDMA_CHANNELS)) {
+		u32 val;
+
+		val = tr32(TG3_LSO_RD_DMA_CRPTEN_CTRL);
+		val &= ~TG3_LSO_RD_DMA_TX_LENGTH_WA;
+		tw32(TG3_LSO_RD_DMA_CRPTEN_CTRL, val);
+		tg3_flag_clear(tp, 5719_RDMA_BUG);
+	}
 
 	TG3_STAT_ADD32(&sp->rx_octets, MAC_RX_STATS_OCTETS);
 	TG3_STAT_ADD32(&sp->rx_fragments, MAC_RX_STATS_FRAGMENTS);
diff --git a/drivers/net/ethernet/broadcom/tg3.h b/drivers/net/ethernet/broadcom/tg3.h
index 93865f8..024c9c9 100644
--- a/drivers/net/ethernet/broadcom/tg3.h
+++ b/drivers/net/ethernet/broadcom/tg3.h
@@ -1376,7 +1376,11 @@
 #define TG3_LSO_RD_DMA_CRPTEN_CTRL	0x00004910
 #define TG3_LSO_RD_DMA_CRPTEN_CTRL_BLEN_BD_4K	 0x00030000
 #define TG3_LSO_RD_DMA_CRPTEN_CTRL_BLEN_LSO_4K	 0x000c0000
-/* 0x4914 --> 0x4c00 unused */
+#define TG3_LSO_RD_DMA_TX_LENGTH_WA	 0x02000000
+/* 0x4914 --> 0x4be0 unused */
+
+#define TG3_NUM_RDMA_CHANNELS		4
+#define TG3_RDMA_LENGTH			0x00004be0
 
 /* Write DMA control registers */
 #define WDMAC_MODE			0x00004c00
@@ -2920,6 +2924,7 @@ enum TG3_FLAGS {
 	TG3_FLAG_L1PLLPD_EN,
 	TG3_FLAG_APE_HAS_NCSI,
 	TG3_FLAG_4K_FIFO_LIMIT,
+	TG3_FLAG_5719_RDMA_BUG,
 	TG3_FLAG_RESET_TASK_PENDING,
 	TG3_FLAG_5705_PLUS,
 	TG3_FLAG_IS_5788,
-- 
1.8.1.2

