Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763675AbbA2DHn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2015 22:07:43 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:46990 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965174AbbA2ChQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2015 21:37:16 -0500
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Toshiaki Makita <makita.toshiaki@lab.ntt.co.jp>,
        "David S. Miller" <davem@davemloft.net>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13.y-ckt 008/139] net: Fix stacked vlan offload features computation
Date: Wed, 28 Jan 2015 14:19:11 -0800
Message-Id: <1422483682-15393-9-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1422483682-15393-1-git-send-email-kamal@canonical.com>
References: <1422483682-15393-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11-ckt15 -stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 net/core/dev.c | 13 ++++++++-----
 1 file changed, 8 insertions(+), 5 deletions(-)

diff --git a/net/core/dev.c b/net/core/dev.c
index 65c5438..93335b6 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -2508,11 +2508,14 @@ netdev_features_t netif_skb_dev_features(struct sk_buff *skb,
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
-- 
1.9.1

