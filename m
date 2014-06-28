Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757546AbaF1TEG (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Jun 2014 15:04:06 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:53099 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754687AbaF1Rsf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Jun 2014 13:48:35 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Ben Hutchings <ben@decadent.org.uk>, Eddie Chapman <eddie@ehuk.net>
Subject: [PATCH 3.10 62/77] skbuff: skb_segment: orphan frags before copying
Date: Sat, 28 Jun 2014 10:46:55 -0700
Message-Id: <20140628174524.837794161@linuxfoundation.org>
X-Mailer: git-send-email 2.0.1
In-Reply-To: <20140628174521.691276402@linuxfoundation.org>
References: <20140628174521.691276402@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

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
Cc: Eddie Chapman <eddie@ehuk.net> # backported to 3.10
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 net/core/skbuff.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/net/core/skbuff.c
+++ b/net/core/skbuff.c
@@ -2844,6 +2844,8 @@ struct sk_buff *skb_segment(struct sk_bu
 		skb_shinfo(nskb)->tx_flags = skb_shinfo(skb)->tx_flags & SKBTX_SHARED_FRAG;
 
 		while (pos < offset + len && i < nfrags) {
+			if (unlikely(skb_orphan_frags(skb, GFP_ATOMIC)))
+				goto err;
 			*frag = skb_shinfo(skb)->frags[i];
 			__skb_frag_ref(frag);
 			size = skb_frag_size(frag);


