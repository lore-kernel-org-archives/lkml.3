Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758213Ab3K0Xi6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Nov 2013 18:38:58 -0500
Received: from postman.amit.cz ([188.95.124.147]:42232 "EHLO postman.amit.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754521Ab3K0Xiy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Nov 2013 18:38:54 -0500
X-Greylist: delayed 576 seconds by postgrey-1.27 at vger.kernel.org; Wed, 27 Nov 2013 18:38:53 EST
From: Ondrej Puzman <puzman@gmail.com>
To: davem@davemloft.net
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Ondrej Puzman <puzman@gmail.com>
Subject: [PATCH] pch_gbe: Remove tx_queue_len setting from the driver
Date: Thu, 28 Nov 2013 00:29:08 +0100
Message-Id: <1385594950-2662-2-git-send-email-puzman@gmail.com>
X-Mailer: git-send-email 1.5.6.5
In-Reply-To: <1385594950-2662-1-git-send-email-puzman@gmail.com>
References: <1385594950-2662-1-git-send-email-puzman@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The driver should not touch netdev tx_queue_len when changing link speed.

Signed-off-by: Ondrej Puzman <puzman@gmail.com>
---
 drivers/net/ethernet/oki-semi/pch_gbe/pch_gbe.h    |    2 --
 .../net/ethernet/oki-semi/pch_gbe/pch_gbe_main.c   |    5 -----
 2 files changed, 0 insertions(+), 7 deletions(-)

diff --git a/drivers/net/ethernet/oki-semi/pch_gbe/pch_gbe.h b/drivers/net/ethernet/oki-semi/pch_gbe/pch_gbe.h
index 2a90030..f450d09 100644
--- a/drivers/net/ethernet/oki-semi/pch_gbe/pch_gbe.h
+++ b/drivers/net/ethernet/oki-semi/pch_gbe/pch_gbe.h
@@ -615,7 +615,6 @@ struct pch_gbe_privdata {
  * @tx_ring:		Pointer of Tx descriptor ring structure
  * @rx_ring:		Pointer of Rx descriptor ring structure
  * @rx_buffer_len:	Receive buffer length
- * @tx_queue_len:	Transmit queue length
  * @have_msi:		PCI MSI mode flag
  * @pch_gbe_privdata:	PCI Device ID driver_data
  */
@@ -639,7 +638,6 @@ struct pch_gbe_adapter {
 	struct pch_gbe_tx_ring *tx_ring;
 	struct pch_gbe_rx_ring *rx_ring;
 	unsigned long rx_buffer_len;
-	unsigned long tx_queue_len;
 	bool have_msi;
 	bool rx_stop_flag;
 	int hwts_tx_en;
diff --git a/drivers/net/ethernet/oki-semi/pch_gbe/pch_gbe_main.c b/drivers/net/ethernet/oki-semi/pch_gbe/pch_gbe_main.c
index 6764e59..d967603 100644
--- a/drivers/net/ethernet/oki-semi/pch_gbe/pch_gbe_main.c
+++ b/drivers/net/ethernet/oki-semi/pch_gbe/pch_gbe_main.c
@@ -1076,11 +1076,9 @@ static void pch_gbe_set_mode(struct pch_gbe_adapter *adapter, u16 speed,
 	switch (speed) {
 	case SPEED_10:
 		mode = PCH_GBE_MODE_MII_ETHER;
-		netdev->tx_queue_len = 10;
 		break;
 	case SPEED_100:
 		mode = PCH_GBE_MODE_MII_ETHER;
-		netdev->tx_queue_len = 100;
 		break;
 	case SPEED_1000:
 		mode = PCH_GBE_MODE_GMII_ETHER;
@@ -1108,7 +1106,6 @@ static void pch_gbe_watchdog(unsigned long data)
 	pch_gbe_update_stats(adapter);
 	if ((mii_link_ok(&adapter->mii)) && (!netif_carrier_ok(netdev))) {
 		struct ethtool_cmd cmd = { .cmd = ETHTOOL_GSET };
-		netdev->tx_queue_len = adapter->tx_queue_len;
 		/* mii library handles link maintenance tasks */
 		if (mii_ethtool_gset(&adapter->mii, &cmd)) {
 			netdev_err(netdev, "ethtool get setting Error\n");
@@ -1975,7 +1972,6 @@ int pch_gbe_up(struct pch_gbe_adapter *adapter)
 	}
 	pch_gbe_alloc_tx_buffers(adapter, tx_ring);
 	pch_gbe_alloc_rx_buffers(adapter, rx_ring, rx_ring->count);
-	adapter->tx_queue_len = netdev->tx_queue_len;
 	pch_gbe_enable_dma_rx(&adapter->hw);
 	pch_gbe_enable_mac_rx(&adapter->hw);
 
@@ -2013,7 +2009,6 @@ void pch_gbe_down(struct pch_gbe_adapter *adapter)
 
 	del_timer_sync(&adapter->watchdog_timer);
 
-	netdev->tx_queue_len = adapter->tx_queue_len;
 	netif_carrier_off(netdev);
 	netif_stop_queue(netdev);
 
-- 
1.5.6.5

