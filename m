Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932073Ab3FPWUJ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Jun 2013 18:20:09 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:46446 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755793Ab3FPWI7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Jun 2013 18:08:59 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "Michael Chan" <mchan@broadcom.com>,
        "David S. Miller" <davem@davemloft.net>
Date: Sun, 16 Jun 2013 23:01:37 +0100
Message-ID: <lsq.1371420097.956381700@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [11/83] tg3: Add New 5719 Read DMA workaround
In-Reply-To: <lsq.1371420097.958132574@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.101
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.47-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Michael Chan <mchan@broadcom.com>

commit 091f0ea30074bc43f9250961b3247af713024bc6 upstream.

After Power-on-reset, the 5719's TX DMA length registers may contain
uninitialized values and cause TX DMA to stall.  Check for invalid
values and set a register bit to flush the TX channels.  The bit
needs to be turned off after the DMA channels have been flushed.

Signed-off-by: Michael Chan <mchan@broadcom.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/net/ethernet/broadcom/tg3.c |   23 +++++++++++++++++++++++
 drivers/net/ethernet/broadcom/tg3.h |    7 ++++++-
 2 files changed, 29 insertions(+), 1 deletion(-)

--- a/drivers/net/ethernet/broadcom/tg3.c
+++ b/drivers/net/ethernet/broadcom/tg3.c
@@ -8920,6 +8920,19 @@ static int tg3_reset_hw(struct tg3 *tp,
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
@@ -9200,6 +9213,16 @@ static void tg3_periodic_fetch_stats(str
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
--- a/drivers/net/ethernet/broadcom/tg3.h
+++ b/drivers/net/ethernet/broadcom/tg3.h
@@ -1368,7 +1368,11 @@
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
@@ -2921,6 +2925,7 @@ enum TG3_FLAGS {
 	TG3_FLAG_APE_HAS_NCSI,
 	TG3_FLAG_5717_PLUS,
 	TG3_FLAG_4K_FIFO_LIMIT,
+	TG3_FLAG_5719_RDMA_BUG,
 	TG3_FLAG_RESET_TASK_PENDING,
 
 	/* Add new flags before this comment and TG3_FLAG_NUMBER_OF_FLAGS */

