Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756442AbaFQWxY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jun 2014 18:53:24 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:53642 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965489AbaFQVp2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jun 2014 17:45:28 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Eric Dumazet <eric.dumazet@gmail.com>, Florian Westphal <fw@strlen.de>,
        "David S. Miller" <davem@davemloft.net>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13 006/212] net: core: don't account for udp header size when computing seglen
Date: Tue, 17 Jun 2014 14:41:40 -0700
Message-Id: <1403041506-13646-7-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1403041506-13646-1-git-send-email-kamal@canonical.com>
References: <1403041506-13646-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11.4 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Florian Westphal <fw@strlen.de>

[ Upstream commit 6d39d589bb76ee8a1c6cde6822006ae0053decff ]

In case of tcp, gso_size contains the tcpmss.

For UFO (udp fragmentation offloading) skbs, gso_size is the fragment
payload size, i.e. we must not account for udp header size.

Otherwise, when using virtio drivers, a to-be-forwarded UFO GSO packet
will be needlessly fragmented in the forward path, because we think its
individual segments are too large for the outgoing link.

Fixes: fe6cc55f3a9a053 ("net: ip, ipv6: handle gso skbs in forwarding path")
Cc: Eric Dumazet <eric.dumazet@gmail.com>
Reported-by: Tobias Brunner <tobias@strongswan.org>
Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 net/core/skbuff.c | 12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

diff --git a/net/core/skbuff.c b/net/core/skbuff.c
index 9a9898e..bdd6955 100644
--- a/net/core/skbuff.c
+++ b/net/core/skbuff.c
@@ -3583,12 +3583,14 @@ EXPORT_SYMBOL_GPL(skb_scrub_packet);
 unsigned int skb_gso_transport_seglen(const struct sk_buff *skb)
 {
 	const struct skb_shared_info *shinfo = skb_shinfo(skb);
-	unsigned int hdr_len;
 
 	if (likely(shinfo->gso_type & (SKB_GSO_TCPV4 | SKB_GSO_TCPV6)))
-		hdr_len = tcp_hdrlen(skb);
-	else
-		hdr_len = sizeof(struct udphdr);
-	return hdr_len + shinfo->gso_size;
+		return tcp_hdrlen(skb) + shinfo->gso_size;
+
+	/* UFO sets gso_size to the size of the fragmentation
+	 * payload, i.e. the size of the L4 (UDP) header is already
+	 * accounted for.
+	 */
+	return shinfo->gso_size;
 }
 EXPORT_SYMBOL_GPL(skb_gso_transport_seglen);
-- 
1.9.1

