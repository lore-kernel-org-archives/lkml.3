Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752050AbaFEEUD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jun 2014 00:20:03 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:43621 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750765AbaFEET7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jun 2014 00:19:59 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Tobias Brunner <tobias@strongswan.org>,
        Florian Westphal <fw@strlen.de>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 3.4 018/214] net: core: dont account for udp header size when computing seglen
Date: Wed,  4 Jun 2014 21:16:21 -0700
Message-Id: <20140605041642.214941686@linuxfoundation.org>
X-Mailer: git-send-email 2.0.0
In-Reply-To: <20140605041639.638675216@linuxfoundation.org>
References: <20140605041639.638675216@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/core/skbuff.c |   12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

--- a/net/core/skbuff.c
+++ b/net/core/skbuff.c
@@ -3297,12 +3297,14 @@ EXPORT_SYMBOL(__skb_warn_lro_forwarding)
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


