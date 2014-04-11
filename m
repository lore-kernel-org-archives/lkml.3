Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759856AbaDKQvs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Apr 2014 12:51:48 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:56499 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1422782AbaDKQI5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Apr 2014 12:08:57 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        "Michael S. Tsirkin" <mst@redhat.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 3.13 21/65] skbuff: skb_segment: s/fskb/list_skb/
Date: Fri, 11 Apr 2014 09:10:53 -0700
Message-Id: <20140411161000.622323555@linuxfoundation.org>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <20140411160957.714773410@linuxfoundation.org>
References: <20140411160957.714773410@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: "Michael S. Tsirkin" <mst@redhat.com>

[ Upstream commit 1a4cedaf65491e66e1e55b8428c89209da729209 ]

fskb is unrelated to frag: it's coming from
frag_list. Rename it list_skb to avoid confusion.

Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/core/skbuff.c |   26 +++++++++++++-------------
 1 file changed, 13 insertions(+), 13 deletions(-)

--- a/net/core/skbuff.c
+++ b/net/core/skbuff.c
@@ -2768,7 +2768,7 @@ struct sk_buff *skb_segment(struct sk_bu
 {
 	struct sk_buff *segs = NULL;
 	struct sk_buff *tail = NULL;
-	struct sk_buff *fskb = skb_shinfo(head_skb)->frag_list;
+	struct sk_buff *list_skb = skb_shinfo(head_skb)->frag_list;
 	skb_frag_t *frag = skb_shinfo(head_skb)->frags;
 	unsigned int mss = skb_shinfo(head_skb)->gso_size;
 	unsigned int doffset = head_skb->data - skb_mac_header(head_skb);
@@ -2809,14 +2809,14 @@ struct sk_buff *skb_segment(struct sk_bu
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
@@ -2830,8 +2830,8 @@ struct sk_buff *skb_segment(struct sk_bu
 				frag++;
 			}
 
-			nskb = skb_clone(fskb, GFP_ATOMIC);
-			fskb = fskb->next;
+			nskb = skb_clone(list_skb, GFP_ATOMIC);
+			list_skb = list_skb->next;
 
 			if (unlikely(!nskb))
 				goto err;
@@ -2898,15 +2898,15 @@ struct sk_buff *skb_segment(struct sk_bu
 
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


