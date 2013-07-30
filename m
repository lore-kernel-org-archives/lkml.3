Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932659Ab3G3Jp7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jul 2013 05:45:59 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:53232 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932427Ab3G3JdX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jul 2013 05:33:23 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Neil Horman <nhorman@tuxdriver.com>,
        Ben Hutchings <bhutchings@solarflare.com>,
        Jay Cliburn <jcliburn@gmail.com>, Chris Snook <chris.snook@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 063/106] atl1e: unmap partially mapped skb on dma error and free skb
Date: Tue, 30 Jul 2013 10:31:22 +0100
Message-Id: <1375176725-5825-64-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1375176725-5825-1-git-send-email-luis.henriques@canonical.com>
References: <1375176725-5825-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.18 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Neil Horman <nhorman@tuxdriver.com>

commit 584ec4355355ffac43571b02a314d43eb2f7fcbf upstream.

Ben Hutchings pointed out that my recent update to atl1e
in commit 352900b583b2852152a1e05ea0e8b579292e731e
("atl1e: fix dma mapping warnings") was missing a bit of code.

Specifically it reset the hardware tx ring to its origional state when
we hit a dma error, but didn't unmap any exiting mappings from the
operation.  This patch fixes that up.  It also remembers to free the
skb in the event that an error occurs, so we don't leak.  Untested, as
I don't have hardware.  I think its pretty straightforward, but please
review closely.

Signed-off-by: Neil Horman <nhorman@tuxdriver.com>
CC: Ben Hutchings <bhutchings@solarflare.com>
CC: Jay Cliburn <jcliburn@gmail.com>
CC: Chris Snook <chris.snook@gmail.com>
CC: "David S. Miller" <davem@davemloft.net>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/net/ethernet/atheros/atl1e/atl1e_main.c | 24 +++++++++++++++++++++++-
 1 file changed, 23 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/atheros/atl1e/atl1e_main.c b/drivers/net/ethernet/atheros/atl1e/atl1e_main.c
index 1dfe5f7..05e72c8 100644
--- a/drivers/net/ethernet/atheros/atl1e/atl1e_main.c
+++ b/drivers/net/ethernet/atheros/atl1e/atl1e_main.c
@@ -1701,6 +1701,7 @@ static int atl1e_tx_map(struct atl1e_adapter *adapter,
 	u16 f;
 	int segment;
 	int ring_start = adapter->tx_ring.next_to_use;
+	int ring_end;
 
 	nr_frags = skb_shinfo(skb)->nr_frags;
 	segment = (tpd->word3 >> TPD_SEGMENT_EN_SHIFT) & TPD_SEGMENT_EN_MASK;
@@ -1744,6 +1745,15 @@ static int atl1e_tx_map(struct atl1e_adapter *adapter,
 					map_len, PCI_DMA_TODEVICE);
 
 		if (dma_mapping_error(&adapter->pdev->dev, tx_buffer->dma)) {
+			/* We need to unwind the mappings we've done */
+			ring_end = adapter->tx_ring.next_to_use;
+			adapter->tx_ring.next_to_use = ring_start;
+			while (adapter->tx_ring.next_to_use != ring_end) {
+				tpd = atl1e_get_tpd(adapter);
+				tx_buffer = atl1e_get_tx_buffer(adapter, tpd);
+				pci_unmap_single(adapter->pdev, tx_buffer->dma,
+						 tx_buffer->length, PCI_DMA_TODEVICE);
+			}
 			/* Reset the tx rings next pointer */
 			adapter->tx_ring.next_to_use = ring_start;
 			return -ENOSPC;
@@ -1786,6 +1796,16 @@ static int atl1e_tx_map(struct atl1e_adapter *adapter,
 							  DMA_TO_DEVICE);
 
 			if (dma_mapping_error(&adapter->pdev->dev, tx_buffer->dma)) {
+				/* We need to unwind the mappings we've done */
+				ring_end = adapter->tx_ring.next_to_use;
+				adapter->tx_ring.next_to_use = ring_start;
+				while (adapter->tx_ring.next_to_use != ring_end) {
+					tpd = atl1e_get_tpd(adapter);
+					tx_buffer = atl1e_get_tx_buffer(adapter, tpd);
+					dma_unmap_page(&adapter->pdev->dev, tx_buffer->dma,
+						       tx_buffer->length, DMA_TO_DEVICE);
+				}
+
 				/* Reset the ring next to use pointer */
 				adapter->tx_ring.next_to_use = ring_start;
 				return -ENOSPC;
@@ -1876,8 +1896,10 @@ static netdev_tx_t atl1e_xmit_frame(struct sk_buff *skb,
 		return NETDEV_TX_OK;
 	}
 
-	if (atl1e_tx_map(adapter, skb, tpd))
+	if (atl1e_tx_map(adapter, skb, tpd)) {
+		dev_kfree_skb_any(skb);
 		goto out;
+	}
 
 	atl1e_tx_queue(adapter, tpd_req, tpd);
 
-- 
1.8.3.2

