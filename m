Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932084AbaFWNFX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jun 2014 09:05:23 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:37222 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754877AbaFWNFV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jun 2014 09:05:21 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: "Michael S. Tsirkin" <mst@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Ben Hutchings <ben@decadent.org.uk>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 81/93] skbuff: skb_segment: orphan frags before copying
Date: Mon, 23 Jun 2014 14:03:00 +0100
Message-Id: <1403528592-2163-82-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1403528592-2163-1-git-send-email-luis.henriques@canonical.com>
References: <1403528592-2163-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.12 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: "Michael S. Tsirkin" <mst@redhat.com>

commit 1fd819ecb90cc9b822cd84d3056ddba315d3340f upstream.

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
[bwh: Backported to 3.2.  As skb_segment() only supports page-frags *or* a
 frag list, there is no need for the additional frag_skb pointer or the
 preparatory renaming.]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 net/core/skbuff.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/net/core/skbuff.c b/net/core/skbuff.c
index abcad83cece3..39766e4077d6 100644
--- a/net/core/skbuff.c
+++ b/net/core/skbuff.c
@@ -2838,6 +2838,9 @@ struct sk_buff *skb_segment(struct sk_buff *skb, netdev_features_t features)
 		skb_shinfo(nskb)->tx_flags = skb_shinfo(skb)->tx_flags & SKBTX_SHARED_FRAG;
 
 		while (pos < offset + len && i < nfrags) {
+			if (unlikely(skb_orphan_frags(skb, GFP_ATOMIC)))
+				goto err;
+
 			*frag = skb_shinfo(skb)->frags[i];
 			__skb_frag_ref(frag);
 			size = skb_frag_size(frag);
-- 
1.9.1

