Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753686AbaFWIzV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jun 2014 04:55:21 -0400
Received: from ip4-83-240-18-248.cust.nbox.cz ([83.240.18.248]:55503 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752510AbaFWIc3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jun 2014 04:32:29 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, "Michael S. Tsirkin" <mst@redhat.com>,
        "David S. Miller" <davem@davemloft.net>, Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 080/111] skbuff: skb_segment: s/skb/head_skb/
Date: Mon, 23 Jun 2014 10:31:55 +0200
Message-Id: <14568bf24e155542476e3cc14cd28bbda61d6f1f.1403512281.git.jslaby@suse.cz>
X-Mailer: git-send-email 2.0.0
In-Reply-To: <55d5f044a1fc96a74e4470e318c0a24f27a9ab7e.1403512280.git.jslaby@suse.cz>
References: <55d5f044a1fc96a74e4470e318c0a24f27a9ab7e.1403512280.git.jslaby@suse.cz>
In-Reply-To: <cover.1403512280.git.jslaby@suse.cz>
References: <cover.1403512280.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Michael S. Tsirkin" <mst@redhat.com>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

[ Upstream commit df5771ffefb13f8af5392bd54fd7e2b596a3a357 ]

rename local variable to make it easier to tell at a glance that we are
dealing with a head skb.

Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 net/core/skbuff.c | 55 +++++++++++++++++++++++++++----------------------------
 1 file changed, 27 insertions(+), 28 deletions(-)

diff --git a/net/core/skbuff.c b/net/core/skbuff.c
index 08381710ad82..2ab26d5668df 100644
--- a/net/core/skbuff.c
+++ b/net/core/skbuff.c
@@ -2715,41 +2715,42 @@ EXPORT_SYMBOL_GPL(skb_pull_rcsum);
 
 /**
  *	skb_segment - Perform protocol segmentation on skb.
- *	@skb: buffer to segment
+ *	@head_skb: buffer to segment
  *	@features: features for the output path (see dev->features)
  *
  *	This function performs segmentation on the given skb.  It returns
  *	a pointer to the first in a list of new skbs for the segments.
  *	In case of error it returns ERR_PTR(err).
  */
-struct sk_buff *skb_segment(struct sk_buff *skb, netdev_features_t features)
+struct sk_buff *skb_segment(struct sk_buff *head_skb,
+			    netdev_features_t features)
 {
 	struct sk_buff *segs = NULL;
 	struct sk_buff *tail = NULL;
-	struct sk_buff *fskb = skb_shinfo(skb)->frag_list;
-	skb_frag_t *frag = skb_shinfo(skb)->frags;
-	unsigned int mss = skb_shinfo(skb)->gso_size;
-	unsigned int doffset = skb->data - skb_mac_header(skb);
+	struct sk_buff *fskb = skb_shinfo(head_skb)->frag_list;
+	skb_frag_t *frag = skb_shinfo(head_skb)->frags;
+	unsigned int mss = skb_shinfo(head_skb)->gso_size;
+	unsigned int doffset = head_skb->data - skb_mac_header(head_skb);
 	unsigned int offset = doffset;
-	unsigned int tnl_hlen = skb_tnl_header_len(skb);
+	unsigned int tnl_hlen = skb_tnl_header_len(head_skb);
 	unsigned int headroom;
 	unsigned int len;
 	__be16 proto;
 	bool csum;
 	int sg = !!(features & NETIF_F_SG);
-	int nfrags = skb_shinfo(skb)->nr_frags;
+	int nfrags = skb_shinfo(head_skb)->nr_frags;
 	int err = -ENOMEM;
 	int i = 0;
 	int pos;
 
-	proto = skb_network_protocol(skb);
+	proto = skb_network_protocol(head_skb);
 	if (unlikely(!proto))
 		return ERR_PTR(-EINVAL);
 
 	csum = !!can_checksum_protocol(features, proto);
-	__skb_push(skb, doffset);
-	headroom = skb_headroom(skb);
-	pos = skb_headlen(skb);
+	__skb_push(head_skb, doffset);
+	headroom = skb_headroom(head_skb);
+	pos = skb_headlen(head_skb);
 
 	do {
 		struct sk_buff *nskb;
@@ -2757,11 +2758,11 @@ struct sk_buff *skb_segment(struct sk_buff *skb, netdev_features_t features)
 		int hsize;
 		int size;
 
-		len = skb->len - offset;
+		len = head_skb->len - offset;
 		if (len > mss)
 			len = mss;
 
-		hsize = skb_headlen(skb) - offset;
+		hsize = skb_headlen(head_skb) - offset;
 		if (hsize < 0)
 			hsize = 0;
 		if (hsize > len || !sg)
@@ -2810,7 +2811,7 @@ struct sk_buff *skb_segment(struct sk_buff *skb, netdev_features_t features)
 			__skb_push(nskb, doffset);
 		} else {
 			nskb = __alloc_skb(hsize + doffset + headroom,
-					   GFP_ATOMIC, skb_alloc_rx_flag(skb),
+					   GFP_ATOMIC, skb_alloc_rx_flag(head_skb),
 					   NUMA_NO_NODE);
 
 			if (unlikely(!nskb))
@@ -2826,19 +2827,19 @@ struct sk_buff *skb_segment(struct sk_buff *skb, netdev_features_t features)
 			segs = nskb;
 		tail = nskb;
 
-		__copy_skb_header(nskb, skb);
-		nskb->mac_len = skb->mac_len;
+		__copy_skb_header(nskb, head_skb);
+		nskb->mac_len = head_skb->mac_len;
 
 		/* nskb and skb might have different headroom */
 		if (nskb->ip_summed == CHECKSUM_PARTIAL)
 			nskb->csum_start += skb_headroom(nskb) - headroom;
 
 		skb_reset_mac_header(nskb);
-		skb_set_network_header(nskb, skb->mac_len);
+		skb_set_network_header(nskb, head_skb->mac_len);
 		nskb->transport_header = (nskb->network_header +
-					  skb_network_header_len(skb));
+					  skb_network_header_len(head_skb));
 
-		skb_copy_from_linear_data_offset(skb, -tnl_hlen,
+		skb_copy_from_linear_data_offset(head_skb, -tnl_hlen,
 						 nskb->data - tnl_hlen,
 						 doffset + tnl_hlen);
 
@@ -2847,7 +2848,7 @@ struct sk_buff *skb_segment(struct sk_buff *skb, netdev_features_t features)
 
 		if (!sg) {
 			nskb->ip_summed = CHECKSUM_NONE;
-			nskb->csum = skb_copy_and_csum_bits(skb, offset,
+			nskb->csum = skb_copy_and_csum_bits(head_skb, offset,
 							    skb_put(nskb, len),
 							    len, 0);
 			continue;
@@ -2855,10 +2856,11 @@ struct sk_buff *skb_segment(struct sk_buff *skb, netdev_features_t features)
 
 		nskb_frag = skb_shinfo(nskb)->frags;
 
-		skb_copy_from_linear_data_offset(skb, offset,
+		skb_copy_from_linear_data_offset(head_skb, offset,
 						 skb_put(nskb, hsize), hsize);
 
-		skb_shinfo(nskb)->tx_flags = skb_shinfo(skb)->tx_flags & SKBTX_SHARED_FRAG;
+		skb_shinfo(nskb)->tx_flags = skb_shinfo(head_skb)->tx_flags &
+			SKBTX_SHARED_FRAG;
 
 		while (pos < offset + len) {
 			if (i >= nfrags) {
@@ -2915,15 +2917,12 @@ perform_csum_check:
 						  nskb->len - doffset, 0);
 			nskb->ip_summed = CHECKSUM_NONE;
 		}
-	} while ((offset += len) < skb->len);
+	} while ((offset += len) < head_skb->len);
 
 	return segs;
 
 err:
-	while ((skb = segs)) {
-		segs = skb->next;
-		kfree_skb(skb);
-	}
+	kfree_skb_list(segs);
 	return ERR_PTR(err);
 }
 EXPORT_SYMBOL_GPL(skb_segment);
-- 
2.0.0

