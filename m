Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964834AbaFIWwt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jun 2014 18:52:49 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:57187 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934298AbaFIWqI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jun 2014 18:46:08 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Sergey Popovich <popovich_sergei@mail.ru>,
        Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 3.14 73/78] netfilter: Fix potential use after free in ip6_route_me_harder()
Date: Mon,  9 Jun 2014 15:48:53 -0700
Message-Id: <20140609224815.664111567@linuxfoundation.org>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <20140609224813.282275135@linuxfoundation.org>
References: <20140609224813.282275135@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sergey Popovich <popovich_sergei@mail.ru>

commit a8951d5814e1373807a94f79f7ccec7041325470 upstream.

Dst is released one line before we access it again with dst->error.

Fixes: 58e35d147128 netfilter: ipv6: propagate routing errors from
ip6_route_me_harder()

Signed-off-by: Sergey Popovich <popovich_sergei@mail.ru>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 net/ipv6/netfilter.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- a/net/ipv6/netfilter.c
+++ b/net/ipv6/netfilter.c
@@ -30,13 +30,15 @@ int ip6_route_me_harder(struct sk_buff *
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


