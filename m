Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751477AbaKFWhm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Nov 2014 17:37:42 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:58464 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751431AbaKFWhd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Nov 2014 17:37:33 -0500
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Prashant Sreedharan <prashant@broadcom.com>,
        Michael Chan <mchan@broadcom.com>,
        Vladislav Yasevich <vyasevic@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13 016/162] tg3: Work around HW/FW limitations with vlan encapsulated frames
Date: Thu,  6 Nov 2014 14:34:40 -0800
Message-Id: <1415313426-9622-17-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1415313426-9622-1-git-send-email-kamal@canonical.com>
References: <1415313426-9622-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11.11 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Vlad Yasevich <vyasevich@gmail.com>

[ Upstream commit 476c18850c6cbaa3f2bb661ae9710645081563b9 ]

TG3 appears to have an issue performing TSO and checksum offloading
correclty when the frame has been vlan encapsulated (non-accelrated).
In these cases, tcp checksum is not correctly updated.

This patch attempts to work around this issue.  After the patch,
802.1ad vlans start working correctly over tg3 devices.

CC: Prashant Sreedharan <prashant@broadcom.com>
CC: Michael Chan <mchan@broadcom.com>
Signed-off-by: Vladislav Yasevich <vyasevic@redhat.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/net/ethernet/broadcom/tg3.c | 20 ++++++++++++++++++--
 1 file changed, 18 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/tg3.c b/drivers/net/ethernet/broadcom/tg3.c
index e71ee9f..072f401 100644
--- a/drivers/net/ethernet/broadcom/tg3.c
+++ b/drivers/net/ethernet/broadcom/tg3.c
@@ -7899,8 +7899,6 @@ static netdev_tx_t tg3_start_xmit(struct sk_buff *skb, struct net_device *dev)
 
 	entry = tnapi->tx_prod;
 	base_flags = 0;
-	if (skb->ip_summed == CHECKSUM_PARTIAL)
-		base_flags |= TXD_FLAG_TCPUDP_CSUM;
 
 	mss = skb_shinfo(skb)->gso_size;
 	if (mss) {
@@ -7916,6 +7914,13 @@ static netdev_tx_t tg3_start_xmit(struct sk_buff *skb, struct net_device *dev)
 
 		hdr_len = skb_transport_offset(skb) + tcp_hdrlen(skb) - ETH_HLEN;
 
+		/* HW/FW can not correctly segment packets that have been
+		 * vlan encapsulated.
+		 */
+		if (skb->protocol == htons(ETH_P_8021Q) ||
+		    skb->protocol == htons(ETH_P_8021AD))
+			return tg3_tso_bug(tp, skb);
+
 		if (!skb_is_gso_v6(skb)) {
 			iph->check = 0;
 			iph->tot_len = htons(mss + hdr_len);
@@ -7962,6 +7967,17 @@ static netdev_tx_t tg3_start_xmit(struct sk_buff *skb, struct net_device *dev)
 				base_flags |= tsflags << 12;
 			}
 		}
+	} else if (skb->ip_summed == CHECKSUM_PARTIAL) {
+		/* HW/FW can not correctly checksum packets that have been
+		 * vlan encapsulated.
+		 */
+		if (skb->protocol == htons(ETH_P_8021Q) ||
+		    skb->protocol == htons(ETH_P_8021AD)) {
+			if (skb_checksum_help(skb))
+				goto drop;
+		} else  {
+			base_flags |= TXD_FLAG_TCPUDP_CSUM;
+		}
 	}
 
 	if (tg3_flag(tp, USE_JUMBO_BDFLAG) &&
-- 
1.9.1

