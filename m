Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759287Ab3LFVx2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Dec 2013 16:53:28 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:60784 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759140Ab3LFVxU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Dec 2013 16:53:20 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Saran Neti <Saran.Neti@telus.com>,
        Pravin B Shelar <pshelar@nicira.com>,
        Hannes Frederic Sowa <hannes@stressinduktion.org>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 3.10 01/58] ipv6: fix headroom calculation in udp6_ufo_fragment
Date: Fri,  6 Dec 2013 13:51:32 -0800
Message-Id: <20131206214845.052072777@linuxfoundation.org>
X-Mailer: git-send-email 1.8.5.1.67.gb00d244
In-Reply-To: <20131206214844.906193530@linuxfoundation.org>
References: <20131206214844.906193530@linuxfoundation.org>
User-Agent: quilt/0.60-8.1.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hannes Frederic Sowa <hannes@stressinduktion.org>

[ Upstream commit 0e033e04c2678dbbe74a46b23fffb7bb918c288e ]

Commit 1e2bd517c108816220f262d7954b697af03b5f9c ("udp6: Fix udp
fragmentation for tunnel traffic.") changed the calculation if
there is enough space to include a fragment header in the skb from a
skb->mac_header dervived one to skb_headroom. Because we already peeled
off the skb to transport_header this is wrong. Change this back to check
if we have enough room before the mac_header.

This fixes a panic Saran Neti reported. He used the tbf scheduler which
skb_gso_segments the skb. The offsets get negative and we panic in memcpy
because the skb was erroneously not expanded at the head.

Reported-by: Saran Neti <Saran.Neti@telus.com>
Cc: Pravin B Shelar <pshelar@nicira.com>
Signed-off-by: Hannes Frederic Sowa <hannes@stressinduktion.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ipv6/udp_offload.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/net/ipv6/udp_offload.c
+++ b/net/ipv6/udp_offload.c
@@ -85,7 +85,7 @@ static struct sk_buff *udp6_ufo_fragment
 
 	/* Check if there is enough headroom to insert fragment header. */
 	tnl_hlen = skb_tnl_header_len(skb);
-	if (skb_headroom(skb) < (tnl_hlen + frag_hdr_sz)) {
+	if (skb->mac_header < (tnl_hlen + frag_hdr_sz)) {
 		if (gso_pskb_expand_head(skb, tnl_hlen + frag_hdr_sz))
 			goto out;
 	}


