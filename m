Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757567Ab3LSNLv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Dec 2013 08:11:51 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:44378 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753457Ab3LSLzV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Dec 2013 06:55:21 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Pravin B Shelar <pshelar@nicira.com>,
        Hannes Frederic Sowa <hannes@stressinduktion.org>,
        "David S. Miller" <davem@davemloft.net>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 004/208] ipv6: fix headroom calculation in udp6_ufo_fragment
Date: Thu, 19 Dec 2013 11:51:42 +0000
Message-Id: <1387454106-19326-5-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1387454106-19326-1-git-send-email-luis.henriques@canonical.com>
References: <1387454106-19326-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.2 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hannes Frederic Sowa <hannes@stressinduktion.org>

commit 0e033e04c2678dbbe74a46b23fffb7bb918c288e upstream.

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
[ luis: backported to 3.11: adjusted context ]
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 net/ipv6/udp_offload.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/ipv6/udp_offload.c b/net/ipv6/udp_offload.c
index 5d1b8d7..657914b 100644
--- a/net/ipv6/udp_offload.c
+++ b/net/ipv6/udp_offload.c
@@ -86,7 +86,7 @@ static struct sk_buff *udp6_ufo_fragment(struct sk_buff *skb,
 
 	/* Check if there is enough headroom to insert fragment header. */
 	tnl_hlen = skb_tnl_header_len(skb);
-	if (skb_headroom(skb) < (tnl_hlen + frag_hdr_sz)) {
+	if (skb->mac_header < (tnl_hlen + frag_hdr_sz)) {
 		if (gso_pskb_expand_head(skb, tnl_hlen + frag_hdr_sz))
 			goto out;
 	}
-- 
1.8.3.2

