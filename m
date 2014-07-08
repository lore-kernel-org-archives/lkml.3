Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756261AbaGHTY3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2014 15:24:29 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:54191 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755706AbaGHTIl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2014 15:08:41 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "Michael S. Tsirkin" <mst@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        "Herbert Xu" <herbert@gondor.apana.org.au>
Date: Tue, 08 Jul 2014 20:01:50 +0100
Message-ID: <lsq.1404846110.441052658@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [PATCH 3.2 125/125] skbuff: skb_segment: orphan frags before copying
In-Reply-To: <lsq.1404846109.699842714@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.249
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.61-rc1 review patch.  If anyone has any objections, please let me know.

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
---
--- a/net/core/skbuff.c
+++ b/net/core/skbuff.c
@@ -2698,6 +2698,9 @@ struct sk_buff *skb_segment(struct sk_bu
 						 skb_put(nskb, hsize), hsize);
 
 		while (pos < offset + len && i < nfrags) {
+			if (unlikely(skb_orphan_frags(skb, GFP_ATOMIC)))
+				goto err;
+
 			*frag = skb_shinfo(skb)->frags[i];
 			__skb_frag_ref(frag);
 			size = skb_frag_size(frag);

