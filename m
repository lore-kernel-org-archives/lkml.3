Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753374AbaFWIzS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jun 2014 04:55:18 -0400
Received: from ip4-83-240-18-248.cust.nbox.cz ([83.240.18.248]:55516 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752533AbaFWIc2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jun 2014 04:32:28 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, "Michael S. Tsirkin" <mst@redhat.com>,
        "David S. Miller" <davem@davemloft.net>, Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 081/111] skbuff: skb_segment: s/fskb/list_skb/
Date: Mon, 23 Jun 2014 10:31:56 +0200
Message-Id: <f2a855e3e126a716b71ddf369754f70573b26bce.1403512281.git.jslaby@suse.cz>
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

[ Upstream commit 1a4cedaf65491e66e1e55b8428c89209da729209 ]

fskb is unrelated to frag: it's coming from
frag_list. Rename it list_skb to avoid confusion.

Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 net/core/skbuff.c | 26 +++++++++++++-------------
 1 file changed, 13 insertions(+), 13 deletions(-)

diff --git a/net/core/skbuff.c b/net/core/skbuff.c
index 2ab26d5668df..a12e7da7c7bc 100644
--- a/net/core/skbuff.c
+++ b/net/core/skbuff.c
@@ -2727,7 +2727,7 @@ struct sk_buff *skb_segment(struct sk_buff *head_skb,
 {
 	struct sk_buff *segs = NULL;
 	struct sk_buff *tail = NULL;
-	struct sk_buff *fskb = skb_shinfo(head_skb)->frag_list;
+	struct sk_buff *list_skb = skb_shinfo(head_skb)->frag_list;
 	skb_frag_t *frag = skb_shinfo(head_skb)->frags;
 	unsigned int mss = skb_shinfo(head_skb)->gso_size;
 	unsigned int doffset = head_skb->data - skb_mac_header(head_skb);
@@ -2768,14 +2768,14 @@ struct sk_buff *skb_segment(struct sk_buff *head_skb,
 		if (hsize > len || !sg)
 			hsize = len;
 
-		if (!hsize && i >= nfrags && skb_headlen(fskb) &&
-		    (skb_headlen(fskb) == len || sg)) {
-			BUG_ON(skb_headlen(fskb) > len);
+		if (!hsize && i >= nfrags && skb_headlen(list_skb) &&
+		    (skb_headlen(list_skb) == len || sg)) {
+			BUG_ON(skb_headlen(list_skb) > len);
 
 			i = 0;
-			nfrags = skb_shinfo(fskb)->nr_frags;
-			frag = skb_shinfo(fskb)->frags;
-			pos += skb_headlen(fskb);
+			nfrags = skb_shinfo(list_skb)->nr_frags;
+			frag = skb_shinfo(list_skb)->frags;
+			pos += skb_headlen(list_skb);
 
 			while (pos < offset + len) {
 				BUG_ON(i >= nfrags);
@@ -2789,8 +2789,8 @@ struct sk_buff *skb_segment(struct sk_buff *head_skb,
 				frag++;
 			}
 
-			nskb = skb_clone(fskb, GFP_ATOMIC);
-			fskb = fskb->next;
+			nskb = skb_clone(list_skb, GFP_ATOMIC);
+			list_skb = list_skb->next;
 
 			if (unlikely(!nskb))
 				goto err;
@@ -2864,15 +2864,15 @@ struct sk_buff *skb_segment(struct sk_buff *head_skb,
 
 		while (pos < offset + len) {
 			if (i >= nfrags) {
-				BUG_ON(skb_headlen(fskb));
+				BUG_ON(skb_headlen(list_skb));
 
 				i = 0;
-				nfrags = skb_shinfo(fskb)->nr_frags;
-				frag = skb_shinfo(fskb)->frags;
+				nfrags = skb_shinfo(list_skb)->nr_frags;
+				frag = skb_shinfo(list_skb)->frags;
 
 				BUG_ON(!nfrags);
 
-				fskb = fskb->next;
+				list_skb = list_skb->next;
 			}
 
 			if (unlikely(skb_shinfo(nskb)->nr_frags >=
-- 
2.0.0

