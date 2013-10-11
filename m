Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759518Ab3JKUHj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Oct 2013 16:07:39 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:46173 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932498Ab3JKTlW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Oct 2013 15:41:22 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Dmitry Kozlov <xeb@mail.ru>,
        Hannes Frederic Sowa <hannes@stressinduktion.org>,
        Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [ 042/135] ipv6: gre: correct calculation of max_headroom
Date: Fri, 11 Oct 2013 12:38:43 -0700
Message-Id: <20131011193949.824851113@linuxfoundation.org>
X-Mailer: git-send-email 1.8.4.3.gca3854a
In-Reply-To: <20131011193945.181603934@linuxfoundation.org>
References: <20131011193945.181603934@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hannes Frederic Sowa <hannes@stressinduktion.org>

[ Upstream commit 3da812d860755925da890e8c713f2d2e2d7b1bae ]

gre_hlen already accounts for sizeof(struct ipv6_hdr) + gre header,
so initialize max_headroom to zero. Otherwise the

	if (encap_limit >= 0) {
		max_headroom += 8;
		mtu -= 8;
	}

increments an uninitialized variable before max_headroom was reset.

Found with coverity: 728539

Cc: Dmitry Kozlov <xeb@mail.ru>
Signed-off-by: Hannes Frederic Sowa <hannes@stressinduktion.org>
Acked-by: Eric Dumazet <edumazet@google.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ipv6/ip6_gre.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/net/ipv6/ip6_gre.c
+++ b/net/ipv6/ip6_gre.c
@@ -620,7 +620,7 @@ static netdev_tx_t ip6gre_xmit2(struct s
 	struct ip6_tnl *tunnel = netdev_priv(dev);
 	struct net_device *tdev;    /* Device to other host */
 	struct ipv6hdr  *ipv6h;     /* Our new IP header */
-	unsigned int max_headroom;  /* The extra header space needed */
+	unsigned int max_headroom = 0; /* The extra header space needed */
 	int    gre_hlen;
 	struct ipv6_tel_txoption opt;
 	int    mtu;
@@ -693,7 +693,7 @@ static netdev_tx_t ip6gre_xmit2(struct s
 			tunnel->err_count = 0;
 	}
 
-	max_headroom = LL_RESERVED_SPACE(tdev) + gre_hlen + dst->header_len;
+	max_headroom += LL_RESERVED_SPACE(tdev) + gre_hlen + dst->header_len;
 
 	if (skb_headroom(skb) < max_headroom || skb_shared(skb) ||
 	    (skb_cloned(skb) && !skb_clone_writable(skb, 0))) {


