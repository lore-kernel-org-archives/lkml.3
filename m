Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751954Ab3KTHyy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Nov 2013 02:54:54 -0500
Received: from mail-pa0-f43.google.com ([209.85.220.43]:49542 "EHLO
	mail-pa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751182Ab3KTHyv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Nov 2013 02:54:51 -0500
Date: Wed, 20 Nov 2013 15:54:29 +0800
From: ZHAO Gang <gamerh2o@gmail.com>
To: Mark Einon <mark.einon@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH v3 1/5] staging: et131x: clean up code
Message-ID: <62a00a45d2fc38d1881f153f35ba282e85d78a3e.1384933520.git.gamerh2o@gmail.com>
Mail-Followup-To: ZHAO Gang <gamerh2o@gmail.com>,
	Mark Einon <mark.einon@gmail.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	linux-kernel@vger.kernel.org
References: <cover.1384933520.git.gamerh2o@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1384933520.git.gamerh2o@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

1. change function name: et1310_phy_power_down -> et1310_phy_power_switch
	change function name to better describe its functionality.

2. as TODO file suggested, do this sort of things to reduce split lines
	struct fbr_lookup *fbr;
	fbr = rx_local->fbr[id];
	Then replace all the instances of "rx_local->fbr[id]" with fbr.

3. delete unnecessary variable in function et131x_init
	variable u32 numrfd is not necessary in this function.

4. some code style change

Signed-off-by: ZHAO Gang <gamerh2o@gmail.com>
---
 drivers/staging/et131x/et131x.c | 209 ++++++++++++++++++++--------------------
 1 file changed, 103 insertions(+), 106 deletions(-)

diff --git a/drivers/staging/et131x/et131x.c b/drivers/staging/et131x/et131x.c
index d9446c4..836a4db 100644
--- a/drivers/staging/et131x/et131x.c
+++ b/drivers/staging/et131x/et131x.c
@@ -1679,7 +1679,7 @@ static int et131x_mdio_reset(struct mii_bus *bus)
 	return 0;
 }
 
-/*	et1310_phy_power_down	-	PHY power control
+/*	et1310_phy_power_switch	-	PHY power control
  *	@adapter: device to control
  *	@down: true for off/false for back on
  *
@@ -1688,7 +1688,7 @@ static int et131x_mdio_reset(struct mii_bus *bus)
  *	Can't you see that this code processed
  *	Phy power, phy power..
  */
-static void et1310_phy_power_down(struct et131x_adapter *adapter, bool down)
+static void et1310_phy_power_switch(struct et131x_adapter *adapter, bool down)
 {
 	u16 data;
 
@@ -1822,6 +1822,9 @@ static void et131x_config_rx_dma_regs(struct et131x_adapter *adapter)
 		u32 __iomem *base_hi;
 		u32 __iomem *base_lo;
 
+		struct fbr_lookup *fbr;
+		fbr = rx_local->fbr[id];
+
 		if (id == 0) {
 			num_des = &rx_dma->fbr0_num_des;
 			full_offset = &rx_dma->fbr0_full_offset;
@@ -1837,12 +1840,10 @@ static void et131x_config_rx_dma_regs(struct et131x_adapter *adapter)
 		}
 
 		/* Now's the best time to initialize FBR contents */
-		fbr_entry =
-		    (struct fbr_desc *) rx_local->fbr[id]->ring_virtaddr;
-		for (entry = 0;
-		     entry < rx_local->fbr[id]->num_entries; entry++) {
-			fbr_entry->addr_hi = rx_local->fbr[id]->bus_high[entry];
-			fbr_entry->addr_lo = rx_local->fbr[id]->bus_low[entry];
+		fbr_entry = (struct fbr_desc *)fbr->ring_virtaddr;
+		for (entry = 0; entry < fbr->num_entries; entry++) {
+			fbr_entry->addr_hi = fbr->bus_high[entry];
+			fbr_entry->addr_lo = fbr->bus_low[entry];
 			fbr_entry->word2 = entry;
 			fbr_entry++;
 		}
@@ -1850,19 +1851,16 @@ static void et131x_config_rx_dma_regs(struct et131x_adapter *adapter)
 		/* Set the address and parameters of Free buffer ring 1 and 0
 		 * into the 1310's registers
 		 */
-		writel(upper_32_bits(rx_local->fbr[id]->ring_physaddr),
-		       base_hi);
-		writel(lower_32_bits(rx_local->fbr[id]->ring_physaddr),
-		       base_lo);
-		writel(rx_local->fbr[id]->num_entries - 1, num_des);
+		writel(upper_32_bits(fbr->ring_physaddr), base_hi);
+		writel(lower_32_bits(fbr->ring_physaddr), base_lo);
+		writel(fbr->num_entries - 1, num_des);
 		writel(ET_DMA10_WRAP, full_offset);
 
 		/* This variable tracks the free buffer ring 1 full position,
 		 * so it has to match the above.
 		 */
-		rx_local->fbr[id]->local_full = ET_DMA10_WRAP;
-		writel(((rx_local->fbr[id]->num_entries *
-					LO_MARK_PERCENT_FOR_RX) / 100) - 1,
+		fbr->local_full = ET_DMA10_WRAP;
+		writel((fbr->num_entries * LO_MARK_PERCENT_FOR_RX / 100) - 1,
 		       min_des);
 	}
 
@@ -1938,7 +1936,7 @@ static void et131x_adapter_setup(struct et131x_adapter *adapter)
 
 	et1310_config_macstat_regs(adapter);
 
-	et1310_phy_power_down(adapter, 0);
+	et1310_phy_power_switch(adapter, 0);
 	et131x_xcvr_init(adapter);
 }
 
@@ -2204,6 +2202,7 @@ static int et131x_rx_dma_memory_alloc(struct et131x_adapter *adapter)
 	u32 pktstat_ringsize;
 	u32 fbr_chunksize;
 	struct rx_ring *rx_ring;
+	struct fbr_lookup *fbr;
 
 	/* Setup some convenience pointers */
 	rx_ring = &adapter->rx_ring;
@@ -2252,15 +2251,15 @@ static int et131x_rx_dma_memory_alloc(struct et131x_adapter *adapter)
 				adapter->rx_ring.fbr[1]->num_entries;
 
 	for (id = 0; id < NUM_FBRS; id++) {
+		fbr = rx_ring->fbr[id];
+
 		/* Allocate an area of memory for Free Buffer Ring */
-		bufsize =
-		    (sizeof(struct fbr_desc) * rx_ring->fbr[id]->num_entries);
-		rx_ring->fbr[id]->ring_virtaddr =
-				dma_alloc_coherent(&adapter->pdev->dev,
-					bufsize,
-					&rx_ring->fbr[id]->ring_physaddr,
-					GFP_KERNEL);
-		if (!rx_ring->fbr[id]->ring_virtaddr) {
+		bufsize = sizeof(struct fbr_desc) * fbr->num_entries;
+		fbr->ring_virtaddr = dma_alloc_coherent(&adapter->pdev->dev,
+							bufsize,
+							&fbr->ring_physaddr,
+							GFP_KERNEL);
+		if (!fbr->ring_virtaddr) {
 			dev_err(&adapter->pdev->dev,
 			   "Cannot alloc memory for Free Buffer Ring %d\n", id);
 			return -ENOMEM;
@@ -2268,25 +2267,26 @@ static int et131x_rx_dma_memory_alloc(struct et131x_adapter *adapter)
 	}
 
 	for (id = 0; id < NUM_FBRS; id++) {
-		fbr_chunksize = (FBR_CHUNKS * rx_ring->fbr[id]->buffsize);
+		fbr = rx_ring->fbr[id];
+		fbr_chunksize = (FBR_CHUNKS * fbr->buffsize);
 
-		for (i = 0;
-		     i < (rx_ring->fbr[id]->num_entries / FBR_CHUNKS); i++) {
+		for (i = 0; i < (fbr->num_entries / FBR_CHUNKS); i++) {
 			dma_addr_t fbr_tmp_physaddr;
 
-			rx_ring->fbr[id]->mem_virtaddrs[i] = dma_alloc_coherent(
-					&adapter->pdev->dev, fbr_chunksize,
-					&rx_ring->fbr[id]->mem_physaddrs[i],
-					GFP_KERNEL);
+			fbr->mem_virtaddrs[i] =
+				dma_alloc_coherent(&adapter->pdev->dev,
+						   fbr_chunksize,
+						   &fbr->mem_physaddrs[i],
+						   GFP_KERNEL);
 
-			if (!rx_ring->fbr[id]->mem_virtaddrs[i]) {
+			if (!fbr->mem_virtaddrs[i]) {
 				dev_err(&adapter->pdev->dev,
 					"Could not alloc memory\n");
 				return -ENOMEM;
 			}
 
 			/* See NOTE in "Save Physical Address" comment above */
-			fbr_tmp_physaddr = rx_ring->fbr[id]->mem_physaddrs[i];
+			fbr_tmp_physaddr = fbr->mem_physaddrs[i];
 
 			for (j = 0; j < FBR_CHUNKS; j++) {
 				u32 index = (i * FBR_CHUNKS) + j;
@@ -2294,19 +2294,18 @@ static int et131x_rx_dma_memory_alloc(struct et131x_adapter *adapter)
 				/* Save the Virtual address of this index for
 				 * quick access later
 				 */
-				rx_ring->fbr[id]->virt[index] =
-				  (u8 *) rx_ring->fbr[id]->mem_virtaddrs[i] +
-				  (j * rx_ring->fbr[id]->buffsize);
+				fbr->virt[index] = (u8 *)fbr->mem_virtaddrs[i] +
+						   (j * fbr->buffsize);
 
 				/* now store the physical address in the
 				 * descriptor so the device can access it
 				 */
-				rx_ring->fbr[id]->bus_high[index] =
+				fbr->bus_high[index] =
 						upper_32_bits(fbr_tmp_physaddr);
-				rx_ring->fbr[id]->bus_low[index] =
+				fbr->bus_low[index] =
 						lower_32_bits(fbr_tmp_physaddr);
 
-				fbr_tmp_physaddr += rx_ring->fbr[id]->buffsize;
+				fbr_tmp_physaddr += fbr->buffsize;
 			}
 		}
 	}
@@ -2322,7 +2321,7 @@ static int et131x_rx_dma_memory_alloc(struct et131x_adapter *adapter)
 
 	if (!rx_ring->ps_ring_virtaddr) {
 		dev_err(&adapter->pdev->dev,
-			  "Cannot alloc memory for Packet Status Ring\n");
+			"Cannot alloc memory for Packet Status Ring\n");
 		return -ENOMEM;
 	}
 	pr_info("Packet Status Ring %llx\n",
@@ -2341,7 +2340,7 @@ static int et131x_rx_dma_memory_alloc(struct et131x_adapter *adapter)
 					    GFP_KERNEL);
 	if (!rx_ring->rx_status_block) {
 		dev_err(&adapter->pdev->dev,
-			  "Cannot alloc memory for Status Block\n");
+			"Cannot alloc memory for Status Block\n");
 		return -ENOMEM;
 	}
 	rx_ring->num_rfd = NIC_DEFAULT_NUM_RFD;
@@ -2365,6 +2364,7 @@ static void et131x_rx_dma_memory_free(struct et131x_adapter *adapter)
 	u32 pktstat_ringsize;
 	struct rfd *rfd;
 	struct rx_ring *rx_ring;
+	struct fbr_lookup *fbr;
 
 	/* Setup some convenience pointers */
 	rx_ring = &adapter->rx_ring;
@@ -2383,34 +2383,33 @@ static void et131x_rx_dma_memory_free(struct et131x_adapter *adapter)
 
 	/* Free Free Buffer Rings */
 	for (id = 0; id < NUM_FBRS; id++) {
-		if (!rx_ring->fbr[id]->ring_virtaddr)
+		fbr = rx_ring->fbr[id];
+
+		if (!fbr->ring_virtaddr)
 			continue;
 
 		/* First the packet memory */
-		for (index = 0;
-		     index < (rx_ring->fbr[id]->num_entries / FBR_CHUNKS);
+		for (index = 0; index < (fbr->num_entries / FBR_CHUNKS);
 		     index++) {
-			if (rx_ring->fbr[id]->mem_virtaddrs[index]) {
-				bufsize =
-				    rx_ring->fbr[id]->buffsize * FBR_CHUNKS;
+			if (fbr->mem_virtaddrs[index]) {
+				bufsize = fbr->buffsize * FBR_CHUNKS;
 
 				dma_free_coherent(&adapter->pdev->dev,
-					bufsize,
-					rx_ring->fbr[id]->mem_virtaddrs[index],
-					rx_ring->fbr[id]->mem_physaddrs[index]);
+						  bufsize,
+						  fbr->mem_virtaddrs[index],
+						  fbr->mem_physaddrs[index]);
 
-				rx_ring->fbr[id]->mem_virtaddrs[index] = NULL;
+				fbr->mem_virtaddrs[index] = NULL;
 			}
 		}
 
-		bufsize =
-		    sizeof(struct fbr_desc) * rx_ring->fbr[id]->num_entries;
+		bufsize = sizeof(struct fbr_desc) * fbr->num_entries;
 
 		dma_free_coherent(&adapter->pdev->dev, bufsize,
-				    rx_ring->fbr[id]->ring_virtaddr,
-				    rx_ring->fbr[id]->ring_physaddr);
+				  fbr->ring_virtaddr,
+				  fbr->ring_physaddr);
 
-		rx_ring->fbr[id]->ring_virtaddr = NULL;
+		fbr->ring_virtaddr = NULL;
 	}
 
 	/* Free Packet Status Ring */
@@ -2419,8 +2418,8 @@ static void et131x_rx_dma_memory_free(struct et131x_adapter *adapter)
 					adapter->rx_ring.psr_num_entries;
 
 		dma_free_coherent(&adapter->pdev->dev, pktstat_ringsize,
-				    rx_ring->ps_ring_virtaddr,
-				    rx_ring->ps_ring_physaddr);
+				  rx_ring->ps_ring_virtaddr,
+				  rx_ring->ps_ring_physaddr);
 
 		rx_ring->ps_ring_virtaddr = NULL;
 	}
@@ -2428,8 +2427,10 @@ static void et131x_rx_dma_memory_free(struct et131x_adapter *adapter)
 	/* Free area of memory for the writeback of status information */
 	if (rx_ring->rx_status_block) {
 		dma_free_coherent(&adapter->pdev->dev,
-			sizeof(struct rx_status_block),
-			rx_ring->rx_status_block, rx_ring->rx_status_bus);
+				  sizeof(struct rx_status_block),
+				  rx_ring->rx_status_block,
+				  rx_ring->rx_status_bus);
+
 		rx_ring->rx_status_block = NULL;
 	}
 
@@ -2450,7 +2451,6 @@ static int et131x_init_recv(struct et131x_adapter *adapter)
 {
 	struct rfd *rfd;
 	u32 rfdct;
-	u32 numrfd = 0;
 	struct rx_ring *rx_ring;
 
 	/* Setup some convenience pointers */
@@ -2467,9 +2467,8 @@ static int et131x_init_recv(struct et131x_adapter *adapter)
 		/* Add this RFD to the recv_list */
 		list_add_tail(&rfd->list_node, &rx_ring->recv_list);
 
-		/* Increment both the available RFD's, and the total RFD's. */
+		/* Increment the available RFD's */
 		rx_ring->num_ready_recv++;
-		numrfd++;
 	}
 
 	return 0;
@@ -2511,7 +2510,10 @@ static void nic_return_rfd(struct et131x_adapter *adapter, struct rfd *rfd)
 	 */
 	if (buff_index < rx_local->fbr[ring_index]->num_entries) {
 		u32 __iomem *offset;
+		u32 free_buff_ring;
 		struct fbr_desc *next;
+		struct fbr_lookup *fbr;
+		fbr = rx_local->fbr[ring_index];
 
 		spin_lock_irqsave(&adapter->fbr_lock, flags);
 
@@ -2520,27 +2522,25 @@ static void nic_return_rfd(struct et131x_adapter *adapter, struct rfd *rfd)
 		else
 			offset = &rx_dma->fbr1_full_offset;
 
-		next = (struct fbr_desc *)
-			   (rx_local->fbr[ring_index]->ring_virtaddr) +
-				INDEX10(rx_local->fbr[ring_index]->local_full);
+		next = (struct fbr_desc *)(fbr->ring_virtaddr) +
+			INDEX10(fbr->local_full);
 
 		/* Handle the Free Buffer Ring advancement here. Write
 		 * the PA / Buffer Index for the returned buffer into
 		 * the oldest (next to be freed)FBR entry
 		 */
-		next->addr_hi = rx_local->fbr[ring_index]->bus_high[buff_index];
-		next->addr_lo = rx_local->fbr[ring_index]->bus_low[buff_index];
+		next->addr_hi = fbr->bus_high[buff_index];
+		next->addr_lo = fbr->bus_low[buff_index];
 		next->word2 = buff_index;
 
-		writel(bump_free_buff_ring(
-				  &rx_local->fbr[ring_index]->local_full,
-				  rx_local->fbr[ring_index]->num_entries - 1),
-		       offset);
+		free_buff_ring = bump_free_buff_ring(&fbr->local_full,
+						     fbr->num_entries - 1);
+		writel(free_buff_ring, offset);
 
 		spin_unlock_irqrestore(&adapter->fbr_lock, flags);
 	} else {
 		dev_err(&adapter->pdev->dev,
-			  "%s illegal Buffer Index returned\n", __func__);
+			"%s illegal Buffer Index returned\n", __func__);
 	}
 
 	/* The processing on this RFD is done, so put it back on the tail of
@@ -2569,17 +2569,18 @@ static struct rfd *nic_rx_pkts(struct et131x_adapter *adapter)
 	struct rx_ring *rx_local = &adapter->rx_ring;
 	struct rx_status_block *status;
 	struct pkt_stat_desc *psr;
+	struct list_head *element;
+	struct fbr_lookup *fbr;
+	struct sk_buff *skb;
 	struct rfd *rfd;
-	u32 i;
-	u8 *buf;
 	unsigned long flags;
-	struct list_head *element;
-	u8 ring_index;
-	u16 buff_index;
 	u32 len;
 	u32 word0;
 	u32 word1;
-	struct sk_buff *skb;
+	u32 i;
+	u16 buff_index;
+	u8 ring_index;
+	u8 *buf;
 
 	/* RX Status block is written by the DMA engine prior to every
 	 * interrupt. It contains the next to be used entry in the Packet
@@ -2601,6 +2602,7 @@ static struct rfd *nic_rx_pkts(struct et131x_adapter *adapter)
 	 */
 	len = psr->word1 & 0xFFFF;
 	ring_index = (psr->word1 >> 26) & 0x03;
+	fbr = rx_local->fbr[ring_index];
 	buff_index = (psr->word1 >> 16) & 0x3FF;
 	word0 = psr->word0;
 
@@ -2616,11 +2618,11 @@ static struct rfd *nic_rx_pkts(struct et131x_adapter *adapter)
 
 	writel(rx_local->local_psr_full, &adapter->regs->rxdma.psr_full_offset);
 
-	if (ring_index > 1 ||
-		    buff_index > rx_local->fbr[ring_index]->num_entries - 1) {
+	if (ring_index > 1 || buff_index > fbr->num_entries - 1) {
 		/* Illegal buffer or ring index cannot be used by S/W*/
 		dev_err(&adapter->pdev->dev,
-			"NICRxPkts PSR Entry %d indicates length of %d and/or bad bi(%d)\n",
+			"NICRxPkts PSR Entry %d indicates"
+			" length of %d and/or bad bi(%d)\n",
 			rx_local->local_psr_full & 0xFFF, len, buff_index);
 		return NULL;
 	}
@@ -2670,7 +2672,7 @@ static struct rfd *nic_rx_pkts(struct et131x_adapter *adapter)
 		   && !(adapter->packet_filter & ET131X_PACKET_TYPE_PROMISCUOUS)
 		   && !(adapter->packet_filter &
 					ET131X_PACKET_TYPE_ALL_MULTICAST)) {
-			buf = rx_local->fbr[ring_index]->virt[buff_index];
+			buf = fbr->virt[buff_index];
 
 			/* Loop through our list to see if the destination
 			 * address of this packet matches one in our list.
@@ -2723,9 +2725,7 @@ static struct rfd *nic_rx_pkts(struct et131x_adapter *adapter)
 
 	adapter->net_stats.rx_bytes += rfd->len;
 
-	memcpy(skb_put(skb, rfd->len),
-	       rx_local->fbr[ring_index]->virt[buff_index],
-	       rfd->len);
+	memcpy(skb_put(skb, rfd->len), fbr->virt[buff_index], rfd->len);
 
 	skb->protocol = eth_type_trans(skb, adapter->netdev);
 	skb->ip_summed = CHECKSUM_NONE;
@@ -2813,10 +2813,10 @@ static int et131x_tx_dma_memory_alloc(struct et131x_adapter *adapter)
 
 	desc_size = (sizeof(struct tx_desc) * NUM_DESC_PER_RING_TX);
 	tx_ring->tx_desc_ring =
-	    (struct tx_desc *) dma_alloc_coherent(&adapter->pdev->dev,
-						  desc_size,
-						  &tx_ring->tx_desc_ring_pa,
-						  GFP_KERNEL);
+		(struct tx_desc *)dma_alloc_coherent(&adapter->pdev->dev,
+						     desc_size,
+						     &tx_ring->tx_desc_ring_pa,
+						     GFP_KERNEL);
 	if (!adapter->tx_ring.tx_desc_ring) {
 		dev_err(&adapter->pdev->dev,
 			"Cannot alloc memory for Tx Ring\n");
@@ -2832,9 +2832,9 @@ static int et131x_tx_dma_memory_alloc(struct et131x_adapter *adapter)
 	 */
 	/* Allocate memory for the Tx status block */
 	tx_ring->tx_status = dma_alloc_coherent(&adapter->pdev->dev,
-						    sizeof(u32),
-						    &tx_ring->tx_status_pa,
-						    GFP_KERNEL);
+						sizeof(u32),
+						&tx_ring->tx_status_pa,
+						GFP_KERNEL);
 	if (!adapter->tx_ring.tx_status_pa) {
 		dev_err(&adapter->pdev->dev,
 				  "Cannot alloc memory for Tx status block\n");
@@ -2855,19 +2855,17 @@ static void et131x_tx_dma_memory_free(struct et131x_adapter *adapter)
 	if (adapter->tx_ring.tx_desc_ring) {
 		/* Free memory relating to Tx rings here */
 		desc_size = (sizeof(struct tx_desc) * NUM_DESC_PER_RING_TX);
-		dma_free_coherent(&adapter->pdev->dev,
-				    desc_size,
-				    adapter->tx_ring.tx_desc_ring,
-				    adapter->tx_ring.tx_desc_ring_pa);
+		dma_free_coherent(&adapter->pdev->dev, desc_size,
+				  adapter->tx_ring.tx_desc_ring,
+				  adapter->tx_ring.tx_desc_ring_pa);
 		adapter->tx_ring.tx_desc_ring = NULL;
 	}
 
 	/* Free memory for the Tx status block */
 	if (adapter->tx_ring.tx_status) {
-		dma_free_coherent(&adapter->pdev->dev,
-				    sizeof(u32),
-				    adapter->tx_ring.tx_status,
-				    adapter->tx_ring.tx_status_pa);
+		dma_free_coherent(&adapter->pdev->dev, sizeof(u32),
+				  adapter->tx_ring.tx_status,
+				  adapter->tx_ring.tx_status_pa);
 
 		adapter->tx_ring.tx_status = NULL;
 	}
@@ -3204,9 +3202,8 @@ static inline void free_send_packet(struct et131x_adapter *adapter,
 		 * they point to
 		 */
 		do {
-			desc = (struct tx_desc *)
-				    (adapter->tx_ring.tx_desc_ring +
-						INDEX10(tcb->index_start));
+			desc = (adapter->tx_ring.tx_desc_ring +
+				INDEX10(tcb->index_start));
 
 			dma_addr = desc->addr_lo;
 			dma_addr |= (u64)desc->addr_hi << 32;
@@ -3222,7 +3219,7 @@ static inline void free_send_packet(struct et131x_adapter *adapter,
 				tcb->index_start ^= ET_DMA10_WRAP;
 			}
 		} while (desc != (adapter->tx_ring.tx_desc_ring +
-				INDEX10(tcb->index)));
+				  INDEX10(tcb->index)));
 
 		dev_kfree_skb_any(tcb->skb);
 	}
-- 
1.8.3.1

