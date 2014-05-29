Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933103AbaE2OK7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2014 10:10:59 -0400
Received: from ip4-83-240-18-248.cust.nbox.cz ([83.240.18.248]:59396 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933274AbaE2Ntc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2014 09:49:32 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Florian Westphal <fw@strlen.de>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        "David S. Miller" <davem@davemloft.net>, Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 061/103] net: core: don't account for udp header size when computing seglen
Date: Thu, 29 May 2014 15:48:46 +0200
Message-Id: <6a80e19b4cc257a0291920157a6c1749e138e268.1401371259.git.jslaby@suse.cz>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <bcbac220dab16a4038ac1a7c5cfe3e7f034b3836.1401371258.git.jslaby@suse.cz>
References: <bcbac220dab16a4038ac1a7c5cfe3e7f034b3836.1401371258.git.jslaby@suse.cz>
In-Reply-To: <cover.1401371258.git.jslaby@suse.cz>
References: <cover.1401371258.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Florian Westphal <fw@strlen.de>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

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
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 net/core/skbuff.c | 12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

diff --git a/net/core/skbuff.c b/net/core/skbuff.c
index 21571dc4f2df..f69f2ed1dbc3 100644
--- a/net/core/skbuff.c
+++ b/net/core/skbuff.c
@@ -3535,12 +3535,14 @@ EXPORT_SYMBOL_GPL(skb_scrub_packet);
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
1.9.3

