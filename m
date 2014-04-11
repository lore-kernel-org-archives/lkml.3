Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759633AbaDKQvP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Apr 2014 12:51:15 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:56557 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1422790AbaDKQI6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Apr 2014 12:08:58 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 3.13 22/65] skbuff: skb_segment: orphan frags before copying
Date: Fri, 11 Apr 2014 09:10:54 -0700
Message-Id: <20140411161000.758455769@linuxfoundation.org>
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

[ Upstream commit 1fd819ecb90cc9b822cd84d3056ddba315d3340f ]

skb_segment copies frags around, so we need
to copy them carefully to avoid accessing
user memory after reporting completion to userspace
through a callback.

skb_segment doesn't normally happen on datapath:
TSO needs to be disabled - so disabling zero copy
in this case does not look like a big deal.

Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
Acked-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/core/skbuff.c |    6 ++++++
 1 file changed, 6 insertions(+)

--- a/net/core/skbuff.c
+++ b/net/core/skbuff.c
@@ -2772,6 +2772,7 @@ struct sk_buff *skb_segment(struct sk_bu
 	skb_frag_t *frag = skb_shinfo(head_skb)->frags;
 	unsigned int mss = skb_shinfo(head_skb)->gso_size;
 	unsigned int doffset = head_skb->data - skb_mac_header(head_skb);
+	struct sk_buff *frag_skb = head_skb;
 	unsigned int offset = doffset;
 	unsigned int tnl_hlen = skb_tnl_header_len(head_skb);
 	unsigned int headroom;
@@ -2816,6 +2817,7 @@ struct sk_buff *skb_segment(struct sk_bu
 			i = 0;
 			nfrags = skb_shinfo(list_skb)->nr_frags;
 			frag = skb_shinfo(list_skb)->frags;
+			frag_skb = list_skb;
 			pos += skb_headlen(list_skb);
 
 			while (pos < offset + len) {
@@ -2903,6 +2905,7 @@ struct sk_buff *skb_segment(struct sk_bu
 				i = 0;
 				nfrags = skb_shinfo(list_skb)->nr_frags;
 				frag = skb_shinfo(list_skb)->frags;
+				frag_skb = list_skb;
 
 				BUG_ON(!nfrags);
 
@@ -2917,6 +2920,9 @@ struct sk_buff *skb_segment(struct sk_bu
 				goto err;
 			}
 
+			if (unlikely(skb_orphan_frags(frag_skb, GFP_ATOMIC)))
+				goto err;
+
 			*nskb_frag = *frag;
 			__skb_frag_ref(nskb_frag);
 			size = skb_frag_size(nskb_frag);


