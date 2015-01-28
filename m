Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755976AbbA2JAa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jan 2015 04:00:30 -0500
Received: from ip4-83-240-67-251.cust.nbox.cz ([83.240.67.251]:44737 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755867AbbA2JA0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jan 2015 04:00:26 -0500
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
        Toshiaki Makita <makita.toshiaki@lab.ntt.co.jp>,
        "David S. Miller" <davem@davemloft.net>, Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 061/176] net: Fix stacked vlan offload features computation
Date: Wed, 28 Jan 2015 15:28:11 +0100
Message-Id: <6e1a8eb4ed3f954059ffae5563710275bc63d4fa.1422455352.git.jslaby@suse.cz>
X-Mailer: git-send-email 2.2.2
In-Reply-To: <ce4a451f616a1e7ab58cfeceea5e49c8b1c68c81.1422455352.git.jslaby@suse.cz>
References: <ce4a451f616a1e7ab58cfeceea5e49c8b1c68c81.1422455352.git.jslaby@suse.cz>
In-Reply-To: <cover.1422455352.git.jslaby@suse.cz>
References: <cover.1422455352.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Toshiaki Makita <makita.toshiaki@lab.ntt.co.jp>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

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
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 net/core/dev.c | 13 ++++++++-----
 1 file changed, 8 insertions(+), 5 deletions(-)

diff --git a/net/core/dev.c b/net/core/dev.c
index 70876db1ade2..5f26b64da9ac 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -2504,11 +2504,14 @@ netdev_features_t netif_skb_dev_features(struct sk_buff *skb,
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
 
 	features = netdev_intersect_features(features,
-- 
2.2.2

