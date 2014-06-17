Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964964AbaFQQW7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jun 2014 12:22:59 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:50702 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964948AbaFQQW5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jun 2014 12:22:57 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: "Michael S. Tsirkin" <mst@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Luis Henriques <luis.henriques@canonical.com>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.8 095/121] skbuff: skb_segment: orphan frags before copying
Date: Tue, 17 Jun 2014 09:17:53 -0700
Message-Id: <1403021899-16708-68-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1403021899-16708-2-git-send-email-kamal@canonical.com>
References: <1403021899-16708-2-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.24 -stable review patch.  If anyone has any objections, please let me know.

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
(back ported from commit 1fd819ecb90cc9b822cd84d3056ddba315d3340f)
CVE-2014-0131
BugLink: http://bugs.launchpad.net/bugs/1298119
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 net/core/skbuff.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/net/core/skbuff.c b/net/core/skbuff.c
index f97fe58..1cee7e3 100644
--- a/net/core/skbuff.c
+++ b/net/core/skbuff.c
@@ -2826,6 +2826,9 @@ struct sk_buff *skb_segment(struct sk_buff *skb, netdev_features_t features)
 						 skb_put(nskb, hsize), hsize);
 
 		while (pos < offset + len && i < nfrags) {
+			if (unlikely(skb_orphan_frags(skb, GFP_ATOMIC)))
+				goto err;
+
 			*frag = skb_shinfo(skb)->frags[i];
 			__skb_frag_ref(frag);
 			size = skb_frag_size(frag);
-- 
1.9.1

