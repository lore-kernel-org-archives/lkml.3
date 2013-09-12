Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756199Ab3ILSBr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Sep 2013 14:01:47 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:57160 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755911Ab3ILR72 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Sep 2013 13:59:28 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Daniel Borkmann <dborkman@redhat.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Eric Dumazet <edumazet@google.com>, Jiri Benc <jbenc@redhat.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [ 41/46] net: ipv6: tcp: fix potential use after free in tcp_v6_do_rcv
Date: Thu, 12 Sep 2013 10:58:52 -0700
Message-Id: <20130912175725.418006506@linuxfoundation.org>
X-Mailer: git-send-email 1.8.4.3.gca3854a
In-Reply-To: <20130912175721.001906199@linuxfoundation.org>
References: <20130912175721.001906199@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Daniel Borkmann <dborkman@redhat.com>

[ Upstream commit 3a1c756590633c0e86df606e5c618c190926a0df ]

In tcp_v6_do_rcv() code, when processing pkt options, we soley work
on our skb clone opt_skb that we've created earlier before entering
tcp_rcv_established() on our way. However, only in condition ...

  if (np->rxopt.bits.rxtclass)
    np->rcv_tclass = ipv6_get_dsfield(ipv6_hdr(skb));

... we work on skb itself. As we extract every other information out
of opt_skb in ipv6_pktoptions path, this seems wrong, since skb can
already be released by tcp_rcv_established() earlier on. When we try
to access it in ipv6_hdr(), we will dereference freed skb.

[ Bug added by commit 4c507d2897bd9b ("net: implement IP_RECVTOS for
  IP_PKTOPTIONS") ]

Signed-off-by: Daniel Borkmann <dborkman@redhat.com>
Cc: Eric Dumazet <eric.dumazet@gmail.com>
Acked-by: Eric Dumazet <edumazet@google.com>
Acked-by: Jiri Benc <jbenc@redhat.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ipv6/tcp_ipv6.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/net/ipv6/tcp_ipv6.c
+++ b/net/ipv6/tcp_ipv6.c
@@ -1426,7 +1426,7 @@ ipv6_pktoptions:
 		if (np->rxopt.bits.rxhlim || np->rxopt.bits.rxohlim)
 			np->mcast_hops = ipv6_hdr(opt_skb)->hop_limit;
 		if (np->rxopt.bits.rxtclass)
-			np->rcv_tclass = ipv6_get_dsfield(ipv6_hdr(skb));
+			np->rcv_tclass = ipv6_get_dsfield(ipv6_hdr(opt_skb));
 		if (ipv6_opt_accepted(sk, opt_skb)) {
 			skb_set_owner_r(opt_skb, sk);
 			opt_skb = xchg(&np->pktoptions, opt_skb);


