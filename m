Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758425Ab3K0XjE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Nov 2013 18:39:04 -0500
Received: from postman.amit.cz ([188.95.124.147]:42238 "EHLO postman.amit.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757549Ab3K0Xiy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Nov 2013 18:38:54 -0500
From: Ondrej Puzman <puzman@gmail.com>
To: davem@davemloft.net
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Ondrej Puzman <puzman@gmail.com>
Subject: [PATCH] pch_gbe: Fix transmit queue management
Date: Thu, 28 Nov 2013 00:29:07 +0100
Message-Id: <1385594950-2662-1-git-send-email-puzman@gmail.com>
X-Mailer: git-send-email 1.5.6.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

According to Documentation/networking/driver.txt the ndo_start_xmit method should not return NETDEV_TX_BUSY under normal circumstances.
Stop the transmit queue when tx_ring is full.

Signed-off-by: Ondrej Puzman <puzman@gmail.com>
---
 .../net/ethernet/oki-semi/pch_gbe/pch_gbe_main.c   |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/drivers/net/ethernet/oki-semi/pch_gbe/pch_gbe_main.c b/drivers/net/ethernet/oki-semi/pch_gbe/pch_gbe_main.c
index 27ffe0e..6764e59 100644
--- a/drivers/net/ethernet/oki-semi/pch_gbe/pch_gbe_main.c
+++ b/drivers/net/ethernet/oki-semi/pch_gbe/pch_gbe_main.c
@@ -2157,6 +2157,10 @@ static int pch_gbe_xmit_frame(struct sk_buff *skb, struct net_device *netdev)
 
 	/* CRC,ITAG no support */
 	pch_gbe_tx_queue(adapter, tx_ring, skb);
+
+	if (unlikely(!PCH_GBE_DESC_UNUSED(tx_ring)))
+		netif_stop_queue(netdev);
+
 	spin_unlock_irqrestore(&tx_ring->tx_lock, flags);
 	return NETDEV_TX_OK;
 }
-- 
1.5.6.5

