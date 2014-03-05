Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932174AbaCEGxS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Mar 2014 01:53:18 -0500
Received: from rtits2.realtek.com ([60.250.210.242]:58010 "EHLO
	rtits2.realtek.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755286AbaCEGuJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Mar 2014 01:50:09 -0500
X-SpamFilter-By: BOX Solutions SpamTrap 5.39 with qID s256o6w3009522, This message is accepted by code: ctloc85258
From: Hayes Wang <hayeswang@realtek.com>
To: <netdev@vger.kernel.org>
CC: <nic_swsd@realtek.com>, <linux-kernel@vger.kernel.org>,
        <linux-usb@vger.kernel.org>, Hayes Wang <hayeswang@realtek.com>
Subject: [PATCH net-next v2 07/13] r8152: calculate the dropped packets for rx
Date: Wed, 5 Mar 2014 14:49:22 +0800
Message-ID: <1394002168-3193-8-git-send-email-hayeswang@realtek.com>
X-Mailer: git-send-email 1.8.4.2
In-Reply-To: <1394002168-3193-1-git-send-email-hayeswang@realtek.com>
References: <1393934464-23675-1-git-send-email-hayeswang@realtek.com>
 <1394002168-3193-1-git-send-email-hayeswang@realtek.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [172.21.71.44]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Continue dealing with the remain rx packets, even though the allocation
of the skb fail. This could calculate the correct dropped packets.

Signed-off-by: Hayes Wang <hayeswang@realtek.com>
---
 drivers/net/usb/r8152.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/usb/r8152.c b/drivers/net/usb/r8152.c
index f1eaa18..08f4e870 100644
--- a/drivers/net/usb/r8152.c
+++ b/drivers/net/usb/r8152.c
@@ -1456,7 +1456,7 @@ static void rx_bottom(struct r8152 *tp)
 			skb = netdev_alloc_skb_ip_align(netdev, pkt_len);
 			if (!skb) {
 				stats->rx_dropped++;
-				break;
+				goto find_next_rx;
 			}
 			memcpy(skb->data, rx_data, pkt_len);
 			skb_put(skb, pkt_len);
@@ -1465,6 +1465,7 @@ static void rx_bottom(struct r8152 *tp)
 			stats->rx_packets++;
 			stats->rx_bytes += pkt_len;
 
+find_next_rx:
 			rx_data = rx_agg_align(rx_data + pkt_len + CRC_SIZE);
 			rx_desc = (struct rx_desc *)rx_data;
 			len_used = (int)(rx_data - (u8 *)agg->head);
-- 
1.8.4.2

