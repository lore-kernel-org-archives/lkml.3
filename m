Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752423AbaDAQJp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Apr 2014 12:09:45 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:44428 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751840AbaDAQJm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Apr 2014 12:09:42 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Anton Blanchard <anton@samba.org>, "David S. Miller" <davem@davemloft.net>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.8 61/86] ibmveth: Fix endian issues with MAC addresses
Date: Tue,  1 Apr 2014 09:08:14 -0700
Message-Id: <1396368519-12728-62-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1396368519-12728-1-git-send-email-kamal@canonical.com>
References: <1396368519-12728-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.21 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Anton Blanchard <anton@samba.org>

commit d746ca9561440685edb62614d1bcbbc27ff50e66 upstream.

The code to load a MAC address into a u64 for passing to the
hypervisor via a register is broken on little endian.

Create a helper function called ibmveth_encode_mac_addr
which does the right thing in both big and little endian.

We were storing the MAC address in a long in struct ibmveth_adapter.
It's never used so remove it - we don't need another place in the
driver where we create endian issues with MAC addresses.

Signed-off-by: Anton Blanchard <anton@samba.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/net/ethernet/ibm/ibmveth.c | 25 ++++++++++++++++---------
 drivers/net/ethernet/ibm/ibmveth.h |  1 -
 2 files changed, 16 insertions(+), 10 deletions(-)

diff --git a/drivers/net/ethernet/ibm/ibmveth.c b/drivers/net/ethernet/ibm/ibmveth.c
index 82c63ac..4ca2ba4 100644
--- a/drivers/net/ethernet/ibm/ibmveth.c
+++ b/drivers/net/ethernet/ibm/ibmveth.c
@@ -523,10 +523,21 @@ retry:
 	return rc;
 }
 
+static u64 ibmveth_encode_mac_addr(u8 *mac)
+{
+	int i;
+	u64 encoded = 0;
+
+	for (i = 0; i < ETH_ALEN; i++)
+		encoded = (encoded << 8) | mac[i];
+
+	return encoded;
+}
+
 static int ibmveth_open(struct net_device *netdev)
 {
 	struct ibmveth_adapter *adapter = netdev_priv(netdev);
-	u64 mac_address = 0;
+	u64 mac_address;
 	int rxq_entries = 1;
 	unsigned long lpar_rc;
 	int rc;
@@ -582,8 +593,7 @@ static int ibmveth_open(struct net_device *netdev)
 	adapter->rx_queue.num_slots = rxq_entries;
 	adapter->rx_queue.toggle = 1;
 
-	memcpy(&mac_address, netdev->dev_addr, netdev->addr_len);
-	mac_address = mac_address >> 16;
+	mac_address = ibmveth_encode_mac_addr(netdev->dev_addr);
 
 	rxq_desc.fields.flags_len = IBMVETH_BUF_VALID |
 					adapter->rx_queue.queue_len;
@@ -1188,8 +1198,8 @@ static void ibmveth_set_multicast_list(struct net_device *netdev)
 		/* add the addresses to the filter table */
 		netdev_for_each_mc_addr(ha, netdev) {
 			/* add the multicast address to the filter table */
-			unsigned long mcast_addr = 0;
-			memcpy(((char *)&mcast_addr)+2, ha->addr, 6);
+			u64 mcast_addr;
+			mcast_addr = ibmveth_encode_mac_addr(ha->addr);
 			lpar_rc = h_multicast_ctrl(adapter->vdev->unit_address,
 						   IbmVethMcastAddFilter,
 						   mcast_addr);
@@ -1373,9 +1383,6 @@ static int ibmveth_probe(struct vio_dev *dev, const struct vio_device_id *id)
 
 	netif_napi_add(netdev, &adapter->napi, ibmveth_poll, 16);
 
-	adapter->mac_addr = 0;
-	memcpy(&adapter->mac_addr, mac_addr_p, 6);
-
 	netdev->irq = dev->irq;
 	netdev->netdev_ops = &ibmveth_netdev_ops;
 	netdev->ethtool_ops = &netdev_ethtool_ops;
@@ -1384,7 +1391,7 @@ static int ibmveth_probe(struct vio_dev *dev, const struct vio_device_id *id)
 		NETIF_F_IP_CSUM | NETIF_F_IPV6_CSUM;
 	netdev->features |= netdev->hw_features;
 
-	memcpy(netdev->dev_addr, &adapter->mac_addr, netdev->addr_len);
+	memcpy(netdev->dev_addr, mac_addr_p, ETH_ALEN);
 
 	for (i = 0; i < IBMVETH_NUM_BUFF_POOLS; i++) {
 		struct kobject *kobj = &adapter->rx_buff_pool[i].kobj;
diff --git a/drivers/net/ethernet/ibm/ibmveth.h b/drivers/net/ethernet/ibm/ibmveth.h
index 43a794f..48639ba 100644
--- a/drivers/net/ethernet/ibm/ibmveth.h
+++ b/drivers/net/ethernet/ibm/ibmveth.h
@@ -139,7 +139,6 @@ struct ibmveth_adapter {
     struct napi_struct napi;
     struct net_device_stats stats;
     unsigned int mcastFilterSize;
-    unsigned long mac_addr;
     void * buffer_list_addr;
     void * filter_list_addr;
     dma_addr_t buffer_list_dma;
-- 
1.8.3.2

