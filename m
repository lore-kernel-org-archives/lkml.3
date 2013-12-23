Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932395Ab3LWFMv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Dec 2013 00:12:51 -0500
Received: from szxga01-in.huawei.com ([119.145.14.64]:60026 "EHLO
	szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932310Ab3LWFME (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Dec 2013 00:12:04 -0500
Message-ID: <52B7C5CB.5000709@huawei.com>
Date: Mon, 23 Dec 2013 13:10:35 +0800
From: Ding Tianhong <dingtianhong@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:24.0) Gecko/20100101 Thunderbird/24.0.1
MIME-Version: 1.0
To: Mauro Carvalho Chehab <m.chehab@samsung.com>,
        <linux-media@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH 10/21] media: dvb_core: slight optimization of addr compare
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.135.72.199]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use the recently added and possibly more efficient
ether_addr_equal_unaligned to instead of memcmp.

Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>
Cc: linux-media@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
Signed-off-by: Ding Tianhong <dingtianhong@huawei.com>
---
 drivers/media/dvb-core/dvb_net.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/media/dvb-core/dvb_net.c b/drivers/media/dvb-core/dvb_net.c
index f91c80c..ff00f97 100644
--- a/drivers/media/dvb-core/dvb_net.c
+++ b/drivers/media/dvb-core/dvb_net.c
@@ -179,7 +179,7 @@ static __be16 dvb_net_eth_type_trans(struct sk_buff *skb,
 	eth = eth_hdr(skb);
 
 	if (*eth->h_dest & 1) {
-		if(memcmp(eth->h_dest,dev->broadcast, ETH_ALEN)==0)
+		if(ether_addr_equal_unaligned(eth->h_dest, dev->broadcast))
 			skb->pkt_type=PACKET_BROADCAST;
 		else
 			skb->pkt_type=PACKET_MULTICAST;
@@ -674,11 +674,11 @@ static void dvb_net_ule( struct net_device *dev, const u8 *buf, size_t buf_len )
 					if (priv->rx_mode != RX_MODE_PROMISC) {
 						if (priv->ule_skb->data[0] & 0x01) {
 							/* multicast or broadcast */
-							if (memcmp(priv->ule_skb->data, bc_addr, ETH_ALEN)) {
+							if (!ether_addr_equal_unaligned(priv->ule_skb->data, bc_addr)) {
 								/* multicast */
 								if (priv->rx_mode == RX_MODE_MULTI) {
 									int i;
-									for(i = 0; i < priv->multi_num && memcmp(priv->ule_skb->data, priv->multi_macs[i], ETH_ALEN); i++)
+									for(i = 0; i < priv->multi_num && !ether_addr_equal_unaligned(priv->ule_skb->data, priv->multi_macs[i]); i++)
 										;
 									if (i == priv->multi_num)
 										drop = 1;
@@ -688,7 +688,7 @@ static void dvb_net_ule( struct net_device *dev, const u8 *buf, size_t buf_len )
 							}
 							/* else: broadcast */
 						}
-						else if (memcmp(priv->ule_skb->data, dev->dev_addr, ETH_ALEN))
+						else if (!ether_addr_equal_unaligned(priv->ule_skb->data, dev->dev_addr))
 							drop = 1;
 						/* else: destination address matches the MAC address of our receiver device */
 					}
@@ -837,7 +837,7 @@ static void dvb_net_sec(struct net_device *dev,
 	}
 	if (pkt[5] & 0x02) {
 		/* handle LLC/SNAP, see rfc-1042 */
-		if (pkt_len < 24 || memcmp(&pkt[12], "\xaa\xaa\x03\0\0\0", 6)) {
+		if (pkt_len < 24 || !ether_addr_equal_unaligned(&pkt[12], "\xaa\xaa\x03\0\0\0")) {
 			stats->rx_dropped++;
 			return;
 		}
-- 
1.8.0


