Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933093AbaFCLnX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jun 2014 07:43:23 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:43968 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933056AbaFCLnS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jun 2014 07:43:18 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Sergey Popovich <popovich_sergei@mail.ru>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 138/138] netfilter: Fix potential use after free in ip6_route_me_harder()
Date: Tue,  3 Jun 2014 12:39:44 +0100
Message-Id: <1401795584-22664-139-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1401795584-22664-1-git-send-email-luis.henriques@canonical.com>
References: <1401795584-22664-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.11 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sergey Popovich <popovich_sergei@mail.ru>

commit a8951d5814e1373807a94f79f7ccec7041325470 upstream.

Dst is released one line before we access it again with dst->error.

Fixes: 58e35d147128 netfilter: ipv6: propagate routing errors from
ip6_route_me_harder()

Signed-off-by: Sergey Popovich <popovich_sergei@mail.ru>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
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
1.9.1

