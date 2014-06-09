Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932431AbaFIIvc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jun 2014 04:51:32 -0400
Received: from ip4-83-240-18-248.cust.nbox.cz ([83.240.18.248]:58380 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754691AbaFIIvX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jun 2014 04:51:23 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Sergey Popovich <popovich_sergei@mail.ru>,
        Pablo Neira Ayuso <pablo@netfilter.org>, Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 007/146] netfilter: Fix potential use after free in ip6_route_me_harder()
Date: Mon,  9 Jun 2014 10:49:02 +0200
Message-Id: <2b713fc5d2da1dc1ec7ce894f2674d65cb47727f.1402303820.git.jslaby@suse.cz>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <ebe219e45dcf94c1a34281167427cff4d742faef.1402303820.git.jslaby@suse.cz>
References: <ebe219e45dcf94c1a34281167427cff4d742faef.1402303820.git.jslaby@suse.cz>
In-Reply-To: <cover.1402303820.git.jslaby@suse.cz>
References: <cover.1402303820.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Sergey Popovich <popovich_sergei@mail.ru>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

commit a8951d5814e1373807a94f79f7ccec7041325470 upstream.

Dst is released one line before we access it again with dst->error.

Fixes: 58e35d147128 netfilter: ipv6: propagate routing errors from
ip6_route_me_harder()

Signed-off-by: Sergey Popovich <popovich_sergei@mail.ru>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 net/ipv6/netfilter.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/net/ipv6/netfilter.c b/net/ipv6/netfilter.c
index 95f3f1da0d7f..d38e6a8d8b9f 100644
--- a/net/ipv6/netfilter.c
+++ b/net/ipv6/netfilter.c
@@ -30,13 +30,15 @@ int ip6_route_me_harder(struct sk_buff *skb)
 		.daddr = iph->daddr,
 		.saddr = iph->saddr,
 	};
+	int err;
 
 	dst = ip6_route_output(net, skb->sk, &fl6);
-	if (dst->error) {
+	err = dst->error;
+	if (err) {
 		IP6_INC_STATS(net, ip6_dst_idev(dst), IPSTATS_MIB_OUTNOROUTES);
 		LIMIT_NETDEBUG(KERN_DEBUG "ip6_route_me_harder: No more route.\n");
 		dst_release(dst);
-		return dst->error;
+		return err;
 	}
 
 	/* Drop old route. */
-- 
1.9.3

