Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752135AbaKZJ4m (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Nov 2014 04:56:42 -0500
Received: from rtits2.realtek.com ([60.250.210.242]:35833 "EHLO
	rtits2.realtek.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751008AbaKZJ4k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Nov 2014 04:56:40 -0500
Authenticated-By: 
X-SpamFilter-By: BOX Solutions SpamTrap 5.49 with qID sAQ9uZMi002044, This message is accepted by code: ctloc85258
From: Hayes Wang <hayeswang@realtek.com>
To: <netdev@vger.kernel.org>
CC: <nic_swsd@realtek.com>, <linux-kernel@vger.kernel.org>,
        <linux-usb@vger.kernel.org>, Hayes Wang <hayeswang@realtek.com>
Subject: [PATCH net] r8152: drop the tx packet with invalid length
Date: Wed, 26 Nov 2014 17:56:26 +0800
Message-ID: <1394712342-15778-104-Taiwan-albertk@realtek.com>
X-Mailer: Microsoft Office Outlook 11
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [172.21.71.44]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Drop the tx packet which is more than the size of agg_buf_sz. When
creating a bridge with the device, we may get the tx packet with
TSO and the length is more than the gso_max_size which is set by
the driver through netif_set_gso_max_size(). Such packets couldn't
be transmitted and should be dropped directly.

Signed-off-by: Hayes Wang <hayeswang@realtek.com>
---
 drivers/net/usb/r8152.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/drivers/net/usb/r8152.c b/drivers/net/usb/r8152.c
index c6554c7..ebdaff7 100644
--- a/drivers/net/usb/r8152.c
+++ b/drivers/net/usb/r8152.c
@@ -1897,6 +1897,15 @@ static netdev_tx_t rtl8152_start_xmit(struct sk_buff *skb,
 {
 	struct r8152 *tp = netdev_priv(netdev);
 
+	if ((skb->len + sizeof(struct tx_desc)) > agg_buf_sz) {
+		struct net_device_stats *stats = &netdev->stats;
+
+		dev_kfree_skb_any(skb);
+		stats->tx_dropped++;
+		WARN_ON_ONCE(1);
+		return NETDEV_TX_OK;
+	}
+
 	skb_tx_timestamp(skb);
 
 	skb_queue_tail(&tp->tx_queue, skb);
-- 
1.9.3

