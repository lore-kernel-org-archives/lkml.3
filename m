Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759956Ab3GaN0a (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Jul 2013 09:26:30 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:47130 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759874Ab3GaN0J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Jul 2013 09:26:09 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "Neil Horman" <nhorman@tuxdriver.com>,
        "Jay Cliburn" <jcliburn@gmail.com>,
        "Ben Hutchings" <bhutchings@solarflare.com>,
        "David S. Miller" <davem@davemloft.net>,
        "Chris Snook" <chris.snook@gmail.com>
Date: Wed, 31 Jul 2013 15:23:09 +0200
Message-ID: <lsq.1375276989.777367411@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [21/84] atl1e: unmap partially mapped skb on dma error and  free skb
In-Reply-To: <lsq.1375276989.251749228@decadent.org.uk>
X-SA-Exim-Connect-IP: 151.216.67.181
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.50-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Neil Horman <nhorman@tuxdriver.com>

[ Upstream commit 584ec4355355ffac43571b02a314d43eb2f7fcbf ]

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
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/net/ethernet/atheros/atl1e/atl1e_main.c | 24 +++++++++++++++++++++++-
 1 file changed, 23 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/atheros/atl1e/atl1e_main.c b/drivers/net/ethernet/atheros/atl1e/atl1e_main.c
index ec08ccd..87851f0 100644
--- a/drivers/net/ethernet/atheros/atl1e/atl1e_main.c
+++ b/drivers/net/ethernet/atheros/atl1e/atl1e_main.c
@@ -1698,6 +1698,7 @@ static int atl1e_tx_map(struct atl1e_adapter *adapter,
 	u16 f;
 	int segment;
 	int ring_start = adapter->tx_ring.next_to_use;
+	int ring_end;
 
 	nr_frags = skb_shinfo(skb)->nr_frags;
 	segment = (tpd->word3 >> TPD_SEGMENT_EN_SHIFT) & TPD_SEGMENT_EN_MASK;
@@ -1741,6 +1742,15 @@ static int atl1e_tx_map(struct atl1e_adapter *adapter,
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
@@ -1783,6 +1793,16 @@ static int atl1e_tx_map(struct atl1e_adapter *adapter,
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
@@ -1873,8 +1893,10 @@ static netdev_tx_t atl1e_xmit_frame(struct sk_buff *skb,
 		return NETDEV_TX_OK;
 	}
 
-	if (atl1e_tx_map(adapter, skb, tpd))
+	if (atl1e_tx_map(adapter, skb, tpd)) {
+		dev_kfree_skb_any(skb);
 		goto out;
+	}
 
 	atl1e_tx_queue(adapter, tpd_req, tpd);
 

