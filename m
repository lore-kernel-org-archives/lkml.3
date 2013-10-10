Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757751Ab3JJQCF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Oct 2013 12:02:05 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:52867 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756094Ab3JJPso (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Oct 2013 11:48:44 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Daniel Borkmann <dborkman@redhat.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 027/104] net: ipv6: tcp: fix potential use after free in tcp_v6_do_rcv
Date: Thu, 10 Oct 2013 08:41:15 -0700
Message-Id: <1381419752-29733-28-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1381419752-29733-1-git-send-email-kamal@canonical.com>
References: <1381419752-29733-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.11 -stable review patch.  If anyone has any objections, please let me know.

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
[ kamal: backport to 3.8 ]
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 net/ipv6/tcp_ipv6.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/ipv6/tcp_ipv6.c b/net/ipv6/tcp_ipv6.c
index 4cc834a..2eb71b4 100644
--- a/net/ipv6/tcp_ipv6.c
+++ b/net/ipv6/tcp_ipv6.c
@@ -1468,7 +1468,7 @@ ipv6_pktoptions:
 		if (np->rxopt.bits.rxhlim || np->rxopt.bits.rxohlim)
 			np->mcast_hops = ipv6_hdr(opt_skb)->hop_limit;
 		if (np->rxopt.bits.rxtclass)
-			np->rcv_tclass = ipv6_tclass(ipv6_hdr(skb));
+			np->rcv_tclass = ipv6_tclass(ipv6_hdr(opt_skb));
 		if (ipv6_opt_accepted(sk, opt_skb)) {
 			skb_set_owner_r(opt_skb, sk);
 			opt_skb = xchg(&np->pktoptions, opt_skb);
-- 
1.8.1.2

