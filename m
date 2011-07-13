Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753650Ab3CVNji (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Mar 2013 09:39:38 -0400
Received: from swissweb.swissdisk.com ([174.129.12.238]:52786 "EHLO
	swissweb.swissdisk.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753680Ab3CVNje (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Mar 2013 09:39:34 -0400
X-Greylist: delayed 1382 seconds by postgrey-1.27 at vger.kernel.org; Fri, 22 Mar 2013 09:39:34 EDT
From: Andy Fleming <afleming@freescale.com>
Date: Wed, 13 Jul 2011 08:52:04 -0500
Subject: [PATCH] net: Add support for handling queueing in hardware
To: linux-kernel@vger.kernel.org
Cc: netdev@vger.kernel.org
Message-Id: <E1UJ1fR-0004hs-4l@swissweb.swissdisk.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The QDisc code does a bunch of locking which is unnecessary if
you have hardware which handles all of the queueing. Add
support for this, and skip over all of the queueing code if
the feature is enabled on a given device, which breaks QDisc
support on dpaa_eth, and also coopts the FCOE feature bit.

Signed-off-by: Andy Fleming <afleming@freescale.com>
Signed-off-by: Ben Collins <ben.c@servergy.com>
Cc: netdev@vger.kernel.org
---
 include/linux/netdev_features.h | 2 ++
 net/core/dev.c                  | 6 ++++++
 2 files changed, 8 insertions(+)

diff --git a/include/linux/netdev_features.h b/include/linux/netdev_features.h
index 3dd3934..ffb4587 100644
--- a/include/linux/netdev_features.h
+++ b/include/linux/netdev_features.h
@@ -56,6 +56,7 @@ enum {
 	NETIF_F_LOOPBACK_BIT,		/* Enable loopback */
 	NETIF_F_RXFCS_BIT,		/* Append FCS to skb pkt data */
 	NETIF_F_RXALL_BIT,		/* Receive errored frames too */
+	NETIF_F_HW_QDISC_BIT,		/* Supports hardware Qdisc */
 
 	/*
 	 * Add your fresh new feature above and remember to update
@@ -80,6 +81,7 @@ enum {
 #define NETIF_F_GSO_ROBUST	__NETIF_F(GSO_ROBUST)
 #define NETIF_F_HIGHDMA		__NETIF_F(HIGHDMA)
 #define NETIF_F_HW_CSUM		__NETIF_F(HW_CSUM)
+#define NETIF_F_HW_QDISC	__NETIF_F(HW_QDISC)
 #define NETIF_F_HW_VLAN_FILTER	__NETIF_F(HW_VLAN_FILTER)
 #define NETIF_F_HW_VLAN_RX	__NETIF_F(HW_VLAN_RX)
 #define NETIF_F_HW_VLAN_TX	__NETIF_F(HW_VLAN_TX)
diff --git a/net/core/dev.c b/net/core/dev.c
index dffbef7..6818b18 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -2743,6 +2743,12 @@ int dev_queue_xmit(struct sk_buff *skb)
 
 	skb_update_prio(skb);
 
+	if (dev->features & NETIF_F_HW_QDISC) {
+		txq = netdev_pick_tx(dev, skb);
+		rc = dev_hard_start_xmit(skb, dev, txq);
+		goto out;
+	}
+
 	txq = netdev_pick_tx(dev, skb);
 	q = rcu_dereference_bh(txq->qdisc);
 
-- 
1.8.1.2

