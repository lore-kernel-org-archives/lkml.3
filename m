Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758000AbbAYT0c (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Jan 2015 14:26:32 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:57411 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754766AbbAYSI7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Jan 2015 13:08:59 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Toshiaki Makita <makita.toshiaki@lab.ntt.co.jp>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 3.14 09/98] net: Fix stacked vlan offload features computation
Date: Sun, 25 Jan 2015 10:06:27 -0800
Message-Id: <20150125180713.258968376@linuxfoundation.org>
X-Mailer: git-send-email 2.2.2
In-Reply-To: <20150125180712.859646324@linuxfoundation.org>
References: <20150125180712.859646324@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Toshiaki Makita <makita.toshiaki@lab.ntt.co.jp>

[ Upstream commit 796f2da81bead71ffc91ef70912cd8d1827bf756 ]

When vlan tags are stacked, it is very likely that the outer tag is stored
in skb->vlan_tci and skb->protocol shows the inner tag's vlan_proto.
Currently netif_skb_features() first looks at skb->protocol even if there
is the outer tag in vlan_tci, thus it incorrectly retrieves the protocol
encapsulated by the inner vlan instead of the inner vlan protocol.
This allows GSO packets to be passed to HW and they end up being
corrupted.

Fixes: 58e998c6d239 ("offloading: Force software GSO for multiple vlan tags.")
Signed-off-by: Toshiaki Makita <makita.toshiaki@lab.ntt.co.jp>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/core/dev.c |   13 ++++++++-----
 1 file changed, 8 insertions(+), 5 deletions(-)

--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -2529,11 +2529,14 @@ netdev_features_t netif_skb_dev_features
 	if (skb_shinfo(skb)->gso_segs > dev->gso_max_segs)
 		features &= ~NETIF_F_GSO_MASK;
 
-	if (protocol == htons(ETH_P_8021Q) || protocol == htons(ETH_P_8021AD)) {
-		struct vlan_ethhdr *veh = (struct vlan_ethhdr *)skb->data;
-		protocol = veh->h_vlan_encapsulated_proto;
-	} else if (!vlan_tx_tag_present(skb)) {
-		return harmonize_features(skb, dev, features);
+	if (!vlan_tx_tag_present(skb)) {
+		if (unlikely(protocol == htons(ETH_P_8021Q) ||
+			     protocol == htons(ETH_P_8021AD))) {
+			struct vlan_ethhdr *veh = (struct vlan_ethhdr *)skb->data;
+			protocol = veh->h_vlan_encapsulated_proto;
+		} else {
+			return harmonize_features(skb, dev, features);
+		}
 	}
 
 	features &= (dev->vlan_features | NETIF_F_HW_VLAN_CTAG_TX |


