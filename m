Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756633Ab3I3K1t (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Sep 2013 06:27:49 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:43614 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755519Ab3I3KMo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Sep 2013 06:12:44 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Daniel Borkmann <dborkman@redhat.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 054/104] net: ipv6: tcp: fix potential use after free in tcp_v6_do_rcv
Date: Mon, 30 Sep 2013 11:10:31 +0100
Message-Id: <1380535881-9239-55-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1380535881-9239-1-git-send-email-luis.henriques@canonical.com>
References: <1380535881-9239-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.22 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Daniel Borkmann <dborkman@redhat.com>

commit 3a1c756590633c0e86df606e5c618c190926a0df upstream.

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
[ luis: backported to 3.5: adjusted context ]
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 net/ipv6/tcp_ipv6.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/ipv6/tcp_ipv6.c b/net/ipv6/tcp_ipv6.c
index 989c024..1467fc7 100644
--- a/net/ipv6/tcp_ipv6.c
+++ b/net/ipv6/tcp_ipv6.c
@@ -1573,7 +1573,7 @@ ipv6_pktoptions:
 		if (np->rxopt.bits.rxhlim || np->rxopt.bits.rxohlim)
 			np->mcast_hops = ipv6_hdr(opt_skb)->hop_limit;
 		if (np->rxopt.bits.rxtclass)
-			np->rcv_tclass = ipv6_tclass(ipv6_hdr(skb));
+			np->rcv_tclass = ipv6_tclass(ipv6_hdr(opt_skb));
 		if (ipv6_opt_accepted(sk, opt_skb)) {
 			skb_set_owner_r(opt_skb, sk);
 			opt_skb = xchg(&np->pktoptions, opt_skb);
-- 
1.8.3.2

