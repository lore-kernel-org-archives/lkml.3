Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754045Ab3KQNiX (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Nov 2013 08:38:23 -0500
Received: from dotsec.net ([62.75.224.215]:52076 "EHLO styx.dotsec.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753969Ab3KQNiJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Nov 2013 08:38:09 -0500
X-Greylist: delayed 1958 seconds by postgrey-1.27 at vger.kernel.org; Sun, 17 Nov 2013 08:38:09 EST
From: Alban Bedel <albeu@free.fr>
To: linux-kernel@vger.kernel.org
Cc: netdev@vger.kernel.org, jgarzik@pobox.com, davem@davemloft.net
Subject: [PATCH 1/2] 8139too: Allow setting MTU larger than 1500
Date: Sun, 17 Nov 2013 14:05:23 +0100
Message-Id: <1384693524-20599-1-git-send-email-albeu@free.fr>
X-Mailer: git-send-email 1.8.4.2
X-SA-Score: -1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Replace the default ndo_change_mtu callback with one that allow
setting MTU that the driver can handle.

Signed-off-by: Alban Bedel <albeu@free.fr>
---
 drivers/net/ethernet/realtek/8139too.c | 13 ++++++++++++-
 1 file changed, 12 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/realtek/8139too.c b/drivers/net/ethernet/realtek/8139too.c
index da5972e..9d5d6d1 100644
--- a/drivers/net/ethernet/realtek/8139too.c
+++ b/drivers/net/ethernet/realtek/8139too.c
@@ -185,6 +185,9 @@ static int debug = -1;
 /* max supported ethernet frame size -- must be at least (dev->mtu+14+4).*/
 #define MAX_ETH_FRAME_SIZE	1536
 
+/* max supported payload size */
+#define MAX_ETH_DATA_SIZE	(MAX_ETH_FRAME_SIZE - ETH_HLEN - ETH_FCS_LEN)
+
 /* Size of the Tx bounce buffers -- must be at least (dev->mtu+14+4). */
 #define TX_BUF_SIZE	MAX_ETH_FRAME_SIZE
 #define TX_BUF_TOT_LEN	(TX_BUF_SIZE * NUM_TX_DESC)
@@ -920,11 +923,19 @@ static int rtl8139_set_features(struct net_device *dev, netdev_features_t featur
 	return 0;
 }
 
+static int rtl8139_change_mtu(struct net_device *dev, int new_mtu)
+{
+	if (new_mtu < 68 || new_mtu > MAX_ETH_DATA_SIZE)
+		return -EINVAL;
+	dev->mtu = new_mtu;
+	return 0;
+}
+
 static const struct net_device_ops rtl8139_netdev_ops = {
 	.ndo_open		= rtl8139_open,
 	.ndo_stop		= rtl8139_close,
 	.ndo_get_stats64	= rtl8139_get_stats64,
-	.ndo_change_mtu		= eth_change_mtu,
+	.ndo_change_mtu		= rtl8139_change_mtu,
 	.ndo_validate_addr	= eth_validate_addr,
 	.ndo_set_mac_address 	= rtl8139_set_mac_address,
 	.ndo_start_xmit		= rtl8139_start_xmit,
-- 
1.8.4.2

