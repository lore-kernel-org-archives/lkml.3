Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753731AbaFWIzY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jun 2014 04:55:24 -0400
Received: from ip4-83-240-18-248.cust.nbox.cz ([83.240.18.248]:55504 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752514AbaFWIc2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jun 2014 04:32:28 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, "Michael S. Tsirkin" <mst@redhat.com>,
        "David S. Miller" <davem@davemloft.net>, Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 079/111] skbuff: skb_segment: s/skb_frag/frag/
Date: Mon, 23 Jun 2014 10:31:54 +0200
Message-Id: <74781837f9e968490b4e2fe900f6c1880583dd3e.1403512281.git.jslaby@suse.cz>
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

[ Upstream commit 4e1beba12d094c6c761ba5c49032b9b9e46380e8 ]

skb_frag can in fact point at either skb
or fskb so rename it generally "frag".

Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 net/core/skbuff.c | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/net/core/skbuff.c b/net/core/skbuff.c
index 9e99761b0211..08381710ad82 100644
--- a/net/core/skbuff.c
+++ b/net/core/skbuff.c
@@ -2727,7 +2727,7 @@ struct sk_buff *skb_segment(struct sk_buff *skb, netdev_features_t features)
 	struct sk_buff *segs = NULL;
 	struct sk_buff *tail = NULL;
 	struct sk_buff *fskb = skb_shinfo(skb)->frag_list;
-	skb_frag_t *skb_frag = skb_shinfo(skb)->frags;
+	skb_frag_t *frag = skb_shinfo(skb)->frags;
 	unsigned int mss = skb_shinfo(skb)->gso_size;
 	unsigned int doffset = skb->data - skb_mac_header(skb);
 	unsigned int offset = doffset;
@@ -2773,19 +2773,19 @@ struct sk_buff *skb_segment(struct sk_buff *skb, netdev_features_t features)
 
 			i = 0;
 			nfrags = skb_shinfo(fskb)->nr_frags;
-			skb_frag = skb_shinfo(fskb)->frags;
+			frag = skb_shinfo(fskb)->frags;
 			pos += skb_headlen(fskb);
 
 			while (pos < offset + len) {
 				BUG_ON(i >= nfrags);
 
-				size = skb_frag_size(skb_frag);
+				size = skb_frag_size(frag);
 				if (pos + size > offset + len)
 					break;
 
 				i++;
 				pos += size;
-				skb_frag++;
+				frag++;
 			}
 
 			nskb = skb_clone(fskb, GFP_ATOMIC);
@@ -2866,7 +2866,7 @@ struct sk_buff *skb_segment(struct sk_buff *skb, netdev_features_t features)
 
 				i = 0;
 				nfrags = skb_shinfo(fskb)->nr_frags;
-				skb_frag = skb_shinfo(fskb)->frags;
+				frag = skb_shinfo(fskb)->frags;
 
 				BUG_ON(!nfrags);
 
@@ -2881,7 +2881,7 @@ struct sk_buff *skb_segment(struct sk_buff *skb, netdev_features_t features)
 				goto err;
 			}
 
-			*nskb_frag = *skb_frag;
+			*nskb_frag = *frag;
 			__skb_frag_ref(nskb_frag);
 			size = skb_frag_size(nskb_frag);
 
@@ -2894,7 +2894,7 @@ struct sk_buff *skb_segment(struct sk_buff *skb, netdev_features_t features)
 
 			if (pos + size <= offset + len) {
 				i++;
-				skb_frag++;
+				frag++;
 				pos += size;
 			} else {
 				skb_frag_size_sub(nskb_frag, pos + size - (offset + len));
-- 
2.0.0

