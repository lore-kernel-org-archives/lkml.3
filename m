Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755290AbaELCDt (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 May 2014 22:03:49 -0400
Received: from 1wt.eu ([62.212.114.60]:34580 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753076AbaELBmf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 May 2014 21:42:35 -0400
Message-Id: <20140512003201.217755511@1wt.eu>
User-Agent: quilt/0.48-1
Date: Mon, 12 May 2014 02:32:14 +0200
From: Willy Tarreau <w@1wt.eu>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Eric Dumazet <edumazet@google.com>,
        Hannes Frederic Sowa <hannes@stressinduktion.org>,
        "David S. Miller" <davem@davemloft.net>, Willy Tarreau <w@1wt.eu>
Subject: [ 014/143] ipv6: ip6_sk_dst_check() must not assume ipv6 dst
In-Reply-To: <f07e5fe6d87f172fc73580b9c86ba9a2@local>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-longterm review patch.  If anyone has any objections, please let me know.

------------------

From: Eric Dumazet <edumazet@google.com>

commit a963a37d384d71ad43b3e9e79d68d42fbe0901f3 upstream

It's possible to use AF_INET6 sockets and to connect to an IPv4
destination. After this, socket dst cache is a pointer to a rtable,
not rt6_info.

ip6_sk_dst_check() should check the socket dst cache is IPv6, or else
various corruptions/crashes can happen.

Dave Jones can reproduce immediate crash with
trinity -q -l off -n -c sendmsg -c connect

With help from Hannes Frederic Sowa

Reported-by: Dave Jones <davej@redhat.com>
Reported-by: Hannes Frederic Sowa <hannes@stressinduktion.org>
Signed-off-by: Eric Dumazet <edumazet@google.com>
Acked-by: Hannes Frederic Sowa <hannes@stressinduktion.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Willy Tarreau <w@1wt.eu>
---
 net/ipv6/ip6_output.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/net/ipv6/ip6_output.c b/net/ipv6/ip6_output.c
index 6ba0fe2..bba91a1 100644
--- a/net/ipv6/ip6_output.c
+++ b/net/ipv6/ip6_output.c
@@ -920,11 +920,17 @@ static struct dst_entry *ip6_sk_dst_check(struct sock *sk,
 					  struct flowi *fl)
 {
 	struct ipv6_pinfo *np = inet6_sk(sk);
-	struct rt6_info *rt = (struct rt6_info *)dst;
+	struct rt6_info *rt;
 
 	if (!dst)
 		goto out;
 
+	if (dst->ops->family != AF_INET6) {
+		dst_release(dst);
+		return NULL;
+	}
+
+	rt = (struct rt6_info *)dst;
 	/* Yes, checking route validity in not connected
 	 * case is not very simple. Take into account,
 	 * that we do not support routing by source, TOS,
-- 
1.7.12.2.21.g234cd45.dirty



