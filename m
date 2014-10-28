Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753776AbaJ1N0y (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2014 09:26:54 -0400
Received: from mail.karo-electronics.de ([81.173.242.67]:64823 "EHLO
	mail.karo-electronics.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752103AbaJ1NXN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Oct 2014 09:23:13 -0400
From: =?UTF-8?q?Lothar=20Wa=C3=9Fmann?= <LW@KARO-electronics.de>
To: netdev@vger.kernel.org
Cc: "David S. Miller" <davem@davemloft.net>,
        Russell King <rmk+kernel@arm.linux.org.uk>,
        Frank Li <Frank.Li@freescale.com>,
        Fabio Estevam <fabio.estevam@freescale.com>,
        linux-kernel@vger.kernel.org,
        =?UTF-8?q?Lothar=20Wa=C3=9Fmann?= <LW@KARO-electronics.de>,
        <linux-arm-kernel@lists.infradead.org>
Subject: [PATCHv3 5/9] net: fec: improve access to quirk flags by copying them into fec_enet_private struct
Date: Tue, 28 Oct 2014 14:23:00 +0100
Message-Id: <1414502584-10583-6-git-send-email-LW@KARO-electronics.de>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1414502584-10583-1-git-send-email-LW@KARO-electronics.de>
References: <1414494104-27943-1-git-send-email-LW@KARO-electronics.de>
 <1414502584-10583-1-git-send-email-LW@KARO-electronics.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Lothar Waßmann <LW@KARO-electronics.de>
---
 drivers/net/ethernet/freescale/fec.h      |    1 +
 drivers/net/ethernet/freescale/fec_main.c |  106 +++++++++++------------------
 2 files changed, 39 insertions(+), 68 deletions(-)

diff --git a/drivers/net/ethernet/freescale/fec.h b/drivers/net/ethernet/freescale/fec.h
index 1418813..7aa9388 100644
--- a/drivers/net/ethernet/freescale/fec.h
+++ b/drivers/net/ethernet/freescale/fec.h
@@ -504,6 +504,7 @@ struct fec_enet_private {
 	int	irq[FEC_IRQ_NUM];
 	bool	bufdesc_ex;
 	int	pause_flag;
+	u32	quirks;
 
 	struct	napi_struct napi;
 	int	csum_flags;
diff --git a/drivers/net/ethernet/freescale/fec_main.c b/drivers/net/ethernet/freescale/fec_main.c
index bb006e1..5c1d517 100644
--- a/drivers/net/ethernet/freescale/fec_main.c
+++ b/drivers/net/ethernet/freescale/fec_main.c
@@ -351,8 +351,6 @@ fec_enet_txq_submit_frag_skb(struct fec_enet_priv_tx_q *txq,
 			     struct net_device *ndev)
 {
 	struct fec_enet_private *fep = netdev_priv(ndev);
-	const struct platform_device_id *id_entry =
-				platform_get_device_id(fep->pdev);
 	struct bufdesc *bdp = txq->cur_tx;
 	struct bufdesc_ex *ebdp;
 	int nr_frags = skb_shinfo(skb)->nr_frags;
@@ -388,7 +386,7 @@ fec_enet_txq_submit_frag_skb(struct fec_enet_priv_tx_q *txq,
 		}
 
 		if (fep->bufdesc_ex) {
-			if (id_entry->driver_data & FEC_QUIRK_HAS_AVB)
+			if (fep->quirks & FEC_QUIRK_HAS_AVB)
 				estatus |= FEC_TX_BD_FTYPE(queue);
 			if (skb->ip_summed == CHECKSUM_PARTIAL)
 				estatus |= BD_ENET_TX_PINS | BD_ENET_TX_IINS;
@@ -400,11 +398,11 @@ fec_enet_txq_submit_frag_skb(struct fec_enet_priv_tx_q *txq,
 
 		index = fec_enet_get_bd_index(txq->tx_bd_base, bdp, fep);
 		if (((unsigned long) bufaddr) & fep->tx_align ||
-			id_entry->driver_data & FEC_QUIRK_SWAP_FRAME) {
+			fep->quirks & FEC_QUIRK_SWAP_FRAME) {
 			memcpy(txq->tx_bounce[index], bufaddr, frag_len);
 			bufaddr = txq->tx_bounce[index];
 
-			if (id_entry->driver_data & FEC_QUIRK_SWAP_FRAME)
+			if (fep->quirks & FEC_QUIRK_SWAP_FRAME)
 				swap_buffer(bufaddr, frag_len);
 		}
 
@@ -440,8 +438,6 @@ static int fec_enet_txq_submit_skb(struct fec_enet_priv_tx_q *txq,
 				   struct sk_buff *skb, struct net_device *ndev)
 {
 	struct fec_enet_private *fep = netdev_priv(ndev);
-	const struct platform_device_id *id_entry =
-				platform_get_device_id(fep->pdev);
 	int nr_frags = skb_shinfo(skb)->nr_frags;
 	struct bufdesc *bdp, *last_bdp;
 	void *bufaddr;
@@ -480,11 +476,11 @@ static int fec_enet_txq_submit_skb(struct fec_enet_priv_tx_q *txq,
 	queue = skb_get_queue_mapping(skb);
 	index = fec_enet_get_bd_index(txq->tx_bd_base, bdp, fep);
 	if (((unsigned long) bufaddr) & fep->tx_align ||
-		id_entry->driver_data & FEC_QUIRK_SWAP_FRAME) {
+		fep->quirks & FEC_QUIRK_SWAP_FRAME) {
 		memcpy(txq->tx_bounce[index], skb->data, buflen);
 		bufaddr = txq->tx_bounce[index];
 
-		if (id_entry->driver_data & FEC_QUIRK_SWAP_FRAME)
+		if (fep->quirks & FEC_QUIRK_SWAP_FRAME)
 			swap_buffer(bufaddr, buflen);
 	}
 
@@ -519,7 +515,7 @@ static int fec_enet_txq_submit_skb(struct fec_enet_priv_tx_q *txq,
 			fep->hwts_tx_en))
 			skb_shinfo(skb)->tx_flags |= SKBTX_IN_PROGRESS;
 
-		if (id_entry->driver_data & FEC_QUIRK_HAS_AVB)
+		if (fep->quirks & FEC_QUIRK_HAS_AVB)
 			estatus |= FEC_TX_BD_FTYPE(queue);
 
 		if (skb->ip_summed == CHECKSUM_PARTIAL)
@@ -563,8 +559,6 @@ fec_enet_txq_put_data_tso(struct fec_enet_priv_tx_q *txq, struct sk_buff *skb,
 			  int size, bool last_tcp, bool is_last)
 {
 	struct fec_enet_private *fep = netdev_priv(ndev);
-	const struct platform_device_id *id_entry =
-				platform_get_device_id(fep->pdev);
 	struct bufdesc_ex *ebdp = container_of(bdp, struct bufdesc_ex, desc);
 	unsigned short queue = skb_get_queue_mapping(skb);
 	unsigned short status;
@@ -577,11 +571,11 @@ fec_enet_txq_put_data_tso(struct fec_enet_priv_tx_q *txq, struct sk_buff *skb,
 	status |= (BD_ENET_TX_TC | BD_ENET_TX_READY);
 
 	if (((unsigned long) data) & fep->tx_align ||
-		id_entry->driver_data & FEC_QUIRK_SWAP_FRAME) {
+		fep->quirks & FEC_QUIRK_SWAP_FRAME) {
 		memcpy(txq->tx_bounce[index], data, size);
 		data = txq->tx_bounce[index];
 
-		if (id_entry->driver_data & FEC_QUIRK_SWAP_FRAME)
+		if (fep->quirks & FEC_QUIRK_SWAP_FRAME)
 			swap_buffer(data, size);
 	}
 
@@ -597,7 +591,7 @@ fec_enet_txq_put_data_tso(struct fec_enet_priv_tx_q *txq, struct sk_buff *skb,
 	bdp->cbd_bufaddr = addr;
 
 	if (fep->bufdesc_ex) {
-		if (id_entry->driver_data & FEC_QUIRK_HAS_AVB)
+		if (fep->quirks & FEC_QUIRK_HAS_AVB)
 			estatus |= FEC_TX_BD_FTYPE(queue);
 		if (skb->ip_summed == CHECKSUM_PARTIAL)
 			estatus |= BD_ENET_TX_PINS | BD_ENET_TX_IINS;
@@ -625,8 +619,6 @@ fec_enet_txq_put_hdr_tso(struct fec_enet_priv_tx_q *txq,
 			 struct bufdesc *bdp, int index)
 {
 	struct fec_enet_private *fep = netdev_priv(ndev);
-	const struct platform_device_id *id_entry =
-				platform_get_device_id(fep->pdev);
 	int hdr_len = skb_transport_offset(skb) + tcp_hdrlen(skb);
 	struct bufdesc_ex *ebdp = container_of(bdp, struct bufdesc_ex, desc);
 	unsigned short queue = skb_get_queue_mapping(skb);
@@ -642,11 +634,11 @@ fec_enet_txq_put_hdr_tso(struct fec_enet_priv_tx_q *txq,
 	bufaddr = txq->tso_hdrs + index * TSO_HEADER_SIZE;
 	dmabuf = txq->tso_hdrs_dma + index * TSO_HEADER_SIZE;
 	if (((unsigned long)bufaddr) & fep->tx_align ||
-		id_entry->driver_data & FEC_QUIRK_SWAP_FRAME) {
+		fep->quirks & FEC_QUIRK_SWAP_FRAME) {
 		memcpy(txq->tx_bounce[index], skb->data, hdr_len);
 		bufaddr = txq->tx_bounce[index];
 
-		if (id_entry->driver_data & FEC_QUIRK_SWAP_FRAME)
+		if (fep->quirks & FEC_QUIRK_SWAP_FRAME)
 			swap_buffer(bufaddr, hdr_len);
 
 		dmabuf = dma_map_single(&fep->pdev->dev, bufaddr,
@@ -663,7 +655,7 @@ fec_enet_txq_put_hdr_tso(struct fec_enet_priv_tx_q *txq,
 	bdp->cbd_datlen = hdr_len;
 
 	if (fep->bufdesc_ex) {
-		if (id_entry->driver_data & FEC_QUIRK_HAS_AVB)
+		if (fep->quirks & FEC_QUIRK_HAS_AVB)
 			estatus |= FEC_TX_BD_FTYPE(queue);
 		if (skb->ip_summed == CHECKSUM_PARTIAL)
 			estatus |= BD_ENET_TX_PINS | BD_ENET_TX_IINS;
@@ -688,8 +680,6 @@ static int fec_enet_txq_submit_tso(struct fec_enet_priv_tx_q *txq,
 	struct tso_t tso;
 	unsigned int index = 0;
 	int ret;
-	const struct platform_device_id *id_entry =
-				platform_get_device_id(fep->pdev);
 
 	if (tso_count_descs(skb) >= fec_enet_get_free_txdesc_num(fep, txq)) {
 		dev_kfree_skb_any(skb);
@@ -751,7 +741,7 @@ static int fec_enet_txq_submit_tso(struct fec_enet_priv_tx_q *txq,
 	txq->cur_tx = bdp;
 
 	/* Trigger transmission start */
-	if (!(id_entry->driver_data & FEC_QUIRK_ERR007885) ||
+	if (!(fep->quirks & FEC_QUIRK_ERR007885) ||
 	    !readl(fep->hwp + FEC_X_DES_ACTIVE(queue)) ||
 	    !readl(fep->hwp + FEC_X_DES_ACTIVE(queue)) ||
 	    !readl(fep->hwp + FEC_X_DES_ACTIVE(queue)) ||
@@ -914,8 +904,6 @@ static void
 fec_restart(struct net_device *ndev)
 {
 	struct fec_enet_private *fep = netdev_priv(ndev);
-	const struct platform_device_id *id_entry =
-				platform_get_device_id(fep->pdev);
 	u32 val;
 	u32 temp_mac[2];
 	u32 rcntl = OPT_FRAME_SIZE | 0x04;
@@ -925,7 +913,7 @@ fec_restart(struct net_device *ndev)
 	 * For i.MX6SX SOC, enet use AXI bus, we use disable MAC
 	 * instead of reset MAC itself.
 	 */
-	if (id_entry && id_entry->driver_data & FEC_QUIRK_HAS_AVB) {
+	if (fep->quirks & FEC_QUIRK_HAS_AVB) {
 		writel(0, fep->hwp + FEC_ECNTRL);
 	} else {
 		writel(1, fep->hwp + FEC_ECNTRL);
@@ -936,7 +924,7 @@ fec_restart(struct net_device *ndev)
 	 * enet-mac reset will reset mac address registers too,
 	 * so need to reconfigure it.
 	 */
-	if (id_entry->driver_data & FEC_QUIRK_ENET_MAC) {
+	if (fep->quirks & FEC_QUIRK_ENET_MAC) {
 		memcpy(&temp_mac, ndev->dev_addr, ETH_ALEN);
 		writel(cpu_to_be32(temp_mac[0]), fep->hwp + FEC_ADDR_LOW);
 		writel(cpu_to_be32(temp_mac[1]), fep->hwp + FEC_ADDR_HIGH);
@@ -982,7 +970,7 @@ fec_restart(struct net_device *ndev)
 	 * The phy interface and speed need to get configured
 	 * differently on enet-mac.
 	 */
-	if (id_entry->driver_data & FEC_QUIRK_ENET_MAC) {
+	if (fep->quirks & FEC_QUIRK_ENET_MAC) {
 		/* Enable flow control and length check */
 		rcntl |= 0x40000000 | 0x00000020;
 
@@ -1005,7 +993,7 @@ fec_restart(struct net_device *ndev)
 		}
 	} else {
 #ifdef FEC_MIIGSK_ENR
-		if (id_entry->driver_data & FEC_QUIRK_USE_GASKET) {
+		if (fep->quirks & FEC_QUIRK_USE_GASKET) {
 			u32 cfgr;
 			/* disable the gasket and wait */
 			writel(0, fep->hwp + FEC_MIIGSK_ENR);
@@ -1058,7 +1046,7 @@ fec_restart(struct net_device *ndev)
 	writel(0, fep->hwp + FEC_HASH_TABLE_LOW);
 #endif
 
-	if (id_entry->driver_data & FEC_QUIRK_ENET_MAC) {
+	if (fep->quirks & FEC_QUIRK_ENET_MAC) {
 		/* enable ENET endian swap */
 		ecntl |= (1 << 8);
 		/* enable ENET store and forward mode */
@@ -1092,8 +1080,6 @@ static void
 fec_stop(struct net_device *ndev)
 {
 	struct fec_enet_private *fep = netdev_priv(ndev);
-	const struct platform_device_id *id_entry =
-				platform_get_device_id(fep->pdev);
 	u32 rmii_mode = readl(fep->hwp + FEC_R_CNTRL) & (1 << 8);
 
 	/* We cannot expect a graceful transmit stop without link !!! */
@@ -1108,7 +1094,7 @@ fec_stop(struct net_device *ndev)
 	 * For i.MX6SX SOC, enet use AXI bus, we use disable MAC
 	 * instead of reset MAC itself.
 	 */
-	if (id_entry && id_entry->driver_data & FEC_QUIRK_HAS_AVB) {
+	if (fep->quirks & FEC_QUIRK_HAS_AVB) {
 		writel(0, fep->hwp + FEC_ECNTRL);
 	} else {
 		writel(1, fep->hwp + FEC_ECNTRL);
@@ -1118,7 +1104,7 @@ fec_stop(struct net_device *ndev)
 	writel(FEC_DEFAULT_IMASK, fep->hwp + FEC_IMASK);
 
 	/* We have to keep ENET enabled to have MII interrupt stay working */
-	if (id_entry->driver_data & FEC_QUIRK_ENET_MAC) {
+	if (fep->quirks & FEC_QUIRK_ENET_MAC) {
 		writel(2, fep->hwp + FEC_ECNTRL);
 		writel(rmii_mode, fep->hwp + FEC_R_CNTRL);
 	}
@@ -1337,8 +1323,6 @@ static int
 fec_enet_rx_queue(struct net_device *ndev, int budget, u16 queue_id)
 {
 	struct fec_enet_private *fep = netdev_priv(ndev);
-	const struct platform_device_id *id_entry =
-				platform_get_device_id(fep->pdev);
 	struct fec_enet_priv_rx_q *rxq;
 	struct bufdesc *bdp;
 	unsigned short status;
@@ -1430,7 +1414,7 @@ fec_enet_rx_queue(struct net_device *ndev, int budget, u16 queue_id)
 		prefetch(skb->data - NET_IP_ALIGN);
 		skb_put(skb, pkt_len - 4);
 		data = skb->data;
-		if (id_entry->driver_data & FEC_QUIRK_SWAP_FRAME)
+		if (fep->quirks & FEC_QUIRK_SWAP_FRAME)
 			swap_buffer(data, pkt_len);
 
 		/* Extract the enhanced buffer descriptor */
@@ -1865,8 +1849,6 @@ failed_clk_ipg:
 static int fec_enet_mii_probe(struct net_device *ndev)
 {
 	struct fec_enet_private *fep = netdev_priv(ndev);
-	const struct platform_device_id *id_entry =
-				platform_get_device_id(fep->pdev);
 	struct phy_device *phy_dev = NULL;
 	char mdio_bus_id[MII_BUS_ID_SIZE];
 	char phy_name[MII_BUS_ID_SIZE + 3];
@@ -1912,7 +1894,7 @@ static int fec_enet_mii_probe(struct net_device *ndev)
 	}
 
 	/* mask with MAC supported features */
-	if (id_entry->driver_data & FEC_QUIRK_HAS_GBIT) {
+	if (fep->quirks & FEC_QUIRK_HAS_GBIT) {
 		phy_dev->supported &= PHY_GBIT_FEATURES;
 		phy_dev->supported &= ~SUPPORTED_1000baseT_Half;
 #if !defined(CONFIG_M5272)
@@ -1940,8 +1922,6 @@ static int fec_enet_mii_init(struct platform_device *pdev)
 	static struct mii_bus *fec0_mii_bus;
 	struct net_device *ndev = platform_get_drvdata(pdev);
 	struct fec_enet_private *fep = netdev_priv(ndev);
-	const struct platform_device_id *id_entry =
-				platform_get_device_id(fep->pdev);
 	struct device_node *node;
 	int err = -ENXIO, i;
 
@@ -1961,7 +1941,7 @@ static int fec_enet_mii_init(struct platform_device *pdev)
 	 * mdio interface in board design, and need to be configured by
 	 * fec0 mii_bus.
 	 */
-	if ((id_entry->driver_data & FEC_QUIRK_ENET_MAC) && fep->dev_id > 0) {
+	if ((fep->quirks & FEC_QUIRK_ENET_MAC) && fep->dev_id > 0) {
 		/* fec1 uses fec0 mii_bus */
 		if (mii_cnt && fec0_mii_bus) {
 			fep->mii_bus = fec0_mii_bus;
@@ -1982,7 +1962,7 @@ static int fec_enet_mii_init(struct platform_device *pdev)
 	 * document.
 	 */
 	fep->phy_speed = DIV_ROUND_UP(clk_get_rate(fep->clk_ipg), 5000000);
-	if (id_entry->driver_data & FEC_QUIRK_ENET_MAC)
+	if (fep->quirks & FEC_QUIRK_ENET_MAC)
 		fep->phy_speed--;
 	fep->phy_speed <<= 1;
 	writel(fep->phy_speed, fep->hwp + FEC_MII_SPEED);
@@ -2024,7 +2004,7 @@ static int fec_enet_mii_init(struct platform_device *pdev)
 	mii_cnt++;
 
 	/* save fec0 mii_bus */
-	if (id_entry->driver_data & FEC_QUIRK_ENET_MAC)
+	if (fep->quirks & FEC_QUIRK_ENET_MAC)
 		fec0_mii_bus = fep->mii_bus;
 
 	return 0;
@@ -2293,11 +2273,9 @@ static int fec_enet_us_to_itr_clock(struct net_device *ndev, int us)
 static void fec_enet_itr_coal_set(struct net_device *ndev)
 {
 	struct fec_enet_private *fep = netdev_priv(ndev);
-	const struct platform_device_id *id_entry =
-				platform_get_device_id(fep->pdev);
 	int rx_itr, tx_itr;
 
-	if (!(id_entry->driver_data & FEC_QUIRK_HAS_AVB))
+	if (!(fep->quirks & FEC_QUIRK_HAS_AVB))
 		return;
 
 	/* Must be greater than zero to avoid unpredictable behavior */
@@ -2332,10 +2310,8 @@ static int
 fec_enet_get_coalesce(struct net_device *ndev, struct ethtool_coalesce *ec)
 {
 	struct fec_enet_private *fep = netdev_priv(ndev);
-	const struct platform_device_id *id_entry =
-				platform_get_device_id(fep->pdev);
 
-	if (!(id_entry->driver_data & FEC_QUIRK_HAS_AVB))
+	if (!(fep->quirks & FEC_QUIRK_HAS_AVB))
 		return -EOPNOTSUPP;
 
 	ec->rx_coalesce_usecs = fep->rx_time_itr;
@@ -2351,12 +2327,9 @@ static int
 fec_enet_set_coalesce(struct net_device *ndev, struct ethtool_coalesce *ec)
 {
 	struct fec_enet_private *fep = netdev_priv(ndev);
-	const struct platform_device_id *id_entry =
-				platform_get_device_id(fep->pdev);
-
 	unsigned int cycle;
 
-	if (!(id_entry->driver_data & FEC_QUIRK_HAS_AVB))
+	if (!(fep->quirks & FEC_QUIRK_HAS_AVB))
 		return -EOPNOTSUPP;
 
 	if (ec->rx_max_coalesced_frames > 255) {
@@ -2936,8 +2909,6 @@ static const struct net_device_ops fec_netdev_ops = {
 static int fec_enet_init(struct net_device *ndev)
 {
 	struct fec_enet_private *fep = netdev_priv(ndev);
-	const struct platform_device_id *id_entry =
-				platform_get_device_id(fep->pdev);
 	struct fec_enet_priv_tx_q *txq;
 	struct fec_enet_priv_rx_q *rxq;
 	struct bufdesc *cbd_base;
@@ -3016,11 +2987,11 @@ static int fec_enet_init(struct net_device *ndev)
 	writel(FEC_RX_DISABLED_IMASK, fep->hwp + FEC_IMASK);
 	netif_napi_add(ndev, &fep->napi, fec_enet_rx_napi, NAPI_POLL_WEIGHT);
 
-	if (id_entry->driver_data & FEC_QUIRK_HAS_VLAN)
+	if (fep->quirks & FEC_QUIRK_HAS_VLAN)
 		/* enable hw VLAN support */
 		ndev->features |= NETIF_F_HW_VLAN_CTAG_RX;
 
-	if (id_entry->driver_data & FEC_QUIRK_HAS_CSUM) {
+	if (fep->quirks & FEC_QUIRK_HAS_CSUM) {
 		ndev->gso_max_segs = FEC_MAX_TSO_SEGS;
 
 		/* enable hw accelerator */
@@ -3029,7 +3000,7 @@ static int fec_enet_init(struct net_device *ndev)
 		fep->csum_flags |= FLAG_RX_CSUM_ENABLED;
 	}
 
-	if (id_entry->driver_data & FEC_QUIRK_HAS_AVB) {
+	if (fep->quirks & FEC_QUIRK_HAS_AVB) {
 		fep->tx_align = 0;
 		fep->rx_align = 0x3f;
 	}
@@ -3129,10 +3100,6 @@ fec_probe(struct platform_device *pdev)
 	int num_tx_qs;
 	int num_rx_qs;
 
-	of_id = of_match_device(fec_dt_ids, &pdev->dev);
-	if (of_id)
-		pdev->id_entry = of_id->data;
-
 	fec_enet_get_queue_num(pdev, &num_tx_qs, &num_rx_qs);
 
 	/* Init network device */
@@ -3146,13 +3113,17 @@ fec_probe(struct platform_device *pdev)
 	/* setup board info structure */
 	fep = netdev_priv(ndev);
 
+	of_id = of_match_device(fec_dt_ids, &pdev->dev);
+	if (of_id)
+		pdev->id_entry = of_id->data;
+	fep->quirks = pdev->id_entry->driver_data;
+
 	fep->num_rx_queues = num_rx_qs;
 	fep->num_tx_queues = num_tx_qs;
 
 #if !defined(CONFIG_M5272)
 	/* default enable pause frame auto negotiation */
-	if (pdev->id_entry &&
-	    (pdev->id_entry->driver_data & FEC_QUIRK_HAS_GBIT))
+	if (fep->quirks & FEC_QUIRK_HAS_GBIT)
 		fep->pause_flag |= FEC_PAUSE_FLAG_AUTONEG;
 #endif
 
@@ -3221,9 +3192,8 @@ fec_probe(struct platform_device *pdev)
 	if (IS_ERR(fep->clk_ref))
 		fep->clk_ref = NULL;
 
+	fep->bufdesc_ex = fep->quirks & FEC_QUIRK_HAS_BUFDESC_EX;
 	fep->clk_ptp = devm_clk_get(&pdev->dev, "ptp");
-	fep->bufdesc_ex =
-		pdev->id_entry->driver_data & FEC_QUIRK_HAS_BUFDESC_EX;
 	if (IS_ERR(fep->clk_ptp)) {
 		fep->clk_ptp = NULL;
 		fep->bufdesc_ex = false;
-- 
1.7.10.4

