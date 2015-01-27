Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758600AbbA0MS4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2015 07:18:56 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:35168 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932359AbbA0MSi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2015 07:18:38 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Toshiaki Makita <makita.toshiaki@lab.ntt.co.jp>,
        "David S. Miller" <davem@davemloft.net>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.16.y-ckt 064/126] net: Fix stacked vlan offload features computation
Date: Tue, 27 Jan 2015 12:16:09 +0000
Message-Id: <1422361031-19364-65-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 2.1.4
In-Reply-To: <1422361031-19364-1-git-send-email-luis.henriques@canonical.com>
References: <1422361031-19364-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.16
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.16.7-ckt5 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Toshiaki Makita <makita.toshiaki@lab.ntt.co.jp>

commit 796f2da81bead71ffc91ef70912cd8d1827bf756 upstream.

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
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 net/core/dev.c | 13 ++++++++-----
 1 file changed, 8 insertions(+), 5 deletions(-)

diff --git a/net/core/dev.c b/net/core/dev.c
index 2647b508eb4d..9785af6c54d4 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -2569,11 +2569,14 @@ netdev_features_t netif_skb_features(struct sk_buff *skb)
 	if (skb_shinfo(skb)->gso_segs > skb->dev->gso_max_segs)
 		features &= ~NETIF_F_GSO_MASK;
 
-	if (protocol == htons(ETH_P_8021Q) || protocol == htons(ETH_P_8021AD)) {
-		struct vlan_ethhdr *veh = (struct vlan_ethhdr *)skb->data;
-		protocol = veh->h_vlan_encapsulated_proto;
-	} else if (!vlan_tx_tag_present(skb)) {
-		return harmonize_features(skb, features);
+	if (!vlan_tx_tag_present(skb)) {
+		if (unlikely(protocol == htons(ETH_P_8021Q) ||
+			     protocol == htons(ETH_P_8021AD))) {
+			struct vlan_ethhdr *veh = (struct vlan_ethhdr *)skb->data;
+			protocol = veh->h_vlan_encapsulated_proto;
+		} else {
+			return harmonize_features(skb, features);
+		}
 	}
 
 	features = netdev_intersect_features(features,
-- 
2.1.4

