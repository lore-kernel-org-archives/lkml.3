Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756586Ab3JJRvB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Oct 2013 13:51:01 -0400
Received: from mail-wi0-f194.google.com ([209.85.212.194]:57512 "EHLO
	mail-wi0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756287Ab3JJRu6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Oct 2013 13:50:58 -0400
From: Oussama Ghorbel <ou.ghorbel@gmail.com>
To: "David S. Miller" <davem@davemloft.net>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        James Morris <jmorris@namei.org>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Patrick McHardy <kaber@trash.net>
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Hannes Frederic Sowa <hannes@stressinduktion.org>,
        Oussama Ghorbel <ou.ghorbel@gmail.com>
Subject: [PATCH] ipv6: Initialize ip6_tnl.hlen in gre tunnel even if no route is found
Date: Thu, 10 Oct 2013 18:50:27 +0100
Message-Id: <1381427427-14880-1-git-send-email-ou.ghorbel@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The ip6_tnl.hlen (gre and ipv6 headers length) is independent from the
outgoing interface, so it would be better to initialize it even when no
route is found, otherwise its value will be zero.
While I'm not sure if this could happen in real life, but doing that
will avoid to call the skb_push function with a zero in ip6gre_header
function.

Suggested-by: Hannes Frederic Sowa <hannes@stressinduktion.org>
Signed-off-by: Oussama Ghorbel <ou.ghorbel@gmail.com>
---
 net/ipv6/ip6_gre.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/net/ipv6/ip6_gre.c b/net/ipv6/ip6_gre.c
index 90747f1..8e4d42e 100644
--- a/net/ipv6/ip6_gre.c
+++ b/net/ipv6/ip6_gre.c
@@ -978,6 +978,7 @@ static void ip6gre_tnl_link_config(struct ip6_tnl *t, int set_mtu)
 		if (t->parms.o_flags&GRE_SEQ)
 			addend += 4;
 	}
+	t->hlen = addend;
 
 	if (p->flags & IP6_TNL_F_CAP_XMIT) {
 		int strict = (ipv6_addr_type(&p->raddr) &
@@ -1004,8 +1005,6 @@ static void ip6gre_tnl_link_config(struct ip6_tnl *t, int set_mtu)
 		}
 		ip6_rt_put(rt);
 	}
-
-	t->hlen = addend;
 }
 
 static int ip6gre_tnl_change(struct ip6_tnl *t,
-- 
1.7.9.5

