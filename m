Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755470AbaIZOeM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Sep 2014 10:34:12 -0400
Received: from top.free-electrons.com ([176.31.233.9]:35015 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755120AbaIZOeD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Sep 2014 10:34:03 -0400
From: Antoine Tenart <antoine.tenart@free-electrons.com>
To: sebastian.hesselbarth@gmail.com
Cc: Antoine Tenart <antoine.tenart@free-electrons.com>,
        alexandre.belloni@free-electrons.com,
        thomas.petazzoni@free-electrons.com, zmxu@marvell.com,
        jszhang@marvell.com, netdev@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v5 05/10] net: pxa168_eth: set the mac address on the Ethernet controller
Date: Fri, 26 Sep 2014 16:33:51 +0200
Message-Id: <1411742036-23520-6-git-send-email-antoine.tenart@free-electrons.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1411742036-23520-1-git-send-email-antoine.tenart@free-electrons.com>
References: <1411742036-23520-1-git-send-email-antoine.tenart@free-electrons.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When changing the MAC address, in addition to updating the dev_addr in
the net_device structure, this patch also update the MAC address
registers (high and low) of the Ethernet controller with the new MAC.
The address stored in these registers is used for IEEE 802.3x Ethernet
flow control, which is already enabled.

Signed-off-by: Antoine Tenart <antoine.tenart@free-electrons.com>
Acked-by: Arnd Bergmann <arnd@arndb.de>
---
 drivers/net/ethernet/marvell/pxa168_eth.c | 13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/drivers/net/ethernet/marvell/pxa168_eth.c b/drivers/net/ethernet/marvell/pxa168_eth.c
index b9073e2f3623..34f17dde1cb0 100644
--- a/drivers/net/ethernet/marvell/pxa168_eth.c
+++ b/drivers/net/ethernet/marvell/pxa168_eth.c
@@ -60,6 +60,8 @@
 #define PORT_COMMAND		0x0410
 #define PORT_STATUS		0x0418
 #define HTPR			0x0428
+#define MAC_ADDR_LOW		0x0430
+#define MAC_ADDR_HIGH		0x0438
 #define SDMA_CONFIG		0x0440
 #define SDMA_CMD		0x0448
 #define INT_CAUSE		0x0450
@@ -609,11 +611,22 @@ static int pxa168_eth_set_mac_address(struct net_device *dev, void *addr)
 	struct sockaddr *sa = addr;
 	struct pxa168_eth_private *pep = netdev_priv(dev);
 	unsigned char oldMac[ETH_ALEN];
+	u32 mac_h, mac_l;
 
 	if (!is_valid_ether_addr(sa->sa_data))
 		return -EADDRNOTAVAIL;
 	memcpy(oldMac, dev->dev_addr, ETH_ALEN);
 	memcpy(dev->dev_addr, sa->sa_data, ETH_ALEN);
+
+	mac_h = sa->sa_data[0] << 24;
+	mac_h |= sa->sa_data[1] << 16;
+	mac_h |= sa->sa_data[2] << 8;
+	mac_h |= sa->sa_data[3];
+	mac_l = sa->sa_data[4] << 8;
+	mac_l |= sa->sa_data[5];
+	wrl(pep, MAC_ADDR_HIGH, mac_h);
+	wrl(pep, MAC_ADDR_LOW, mac_l);
+
 	netif_addr_lock_bh(dev);
 	update_hash_table_mac_address(pep, oldMac, dev->dev_addr);
 	netif_addr_unlock_bh(dev);
-- 
1.9.1

