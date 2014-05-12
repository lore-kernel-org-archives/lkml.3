Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756056AbaELB7A (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 May 2014 21:59:00 -0400
Received: from 1wt.eu ([62.212.114.60]:34647 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753519AbaELBmy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 May 2014 21:42:54 -0400
Message-Id: <20140512003203.420948065@1wt.eu>
User-Agent: quilt/0.48-1
Date: Mon, 12 May 2014 02:33:07 +0200
From: Willy Tarreau <w@1wt.eu>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: YOSHIFUJI Hideaki <yoshfuji@linux-ipv6.org>,
        David Lamparter <equinox@diac24.net>,
        <boutier@pps.univ-paris-diderot.fr>,
        Hannes Frederic Sowa <hannes@stressinduktion.org>,
        "David S. Miller" <davem@davemloft.net>, Willy Tarreau <w@1wt.eu>
Subject: [ 067/143] ipv6: dont stop backtracking in fib6_lookup_1 if subtree does not
In-Reply-To: <f07e5fe6d87f172fc73580b9c86ba9a2@local>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-longterm review patch.  If anyone has any objections, please let me know.

------------------
 match

From: Hannes Frederic Sowa <hannes@stressinduktion.org>

[ Upstream commit 3e3be275851bc6fc90bfdcd732cd95563acd982b ]

In case a subtree did not match we currently stop backtracking and return
NULL (root table from fib_lookup). This could yield in invalid routing
table lookups when using subtrees.

Instead continue to backtrack until a valid subtree or node is found
and return this match.

Also remove unneeded NULL check.

Reported-by: Teco Boot <teco@inf-net.nl>
Cc: YOSHIFUJI Hideaki <yoshfuji@linux-ipv6.org>
Cc: David Lamparter <equinox@diac24.net>
Cc: <boutier@pps.univ-paris-diderot.fr>
Signed-off-by: Hannes Frederic Sowa <hannes@stressinduktion.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Willy Tarreau <w@1wt.eu>
---
 net/ipv6/ip6_fib.c | 16 ++++++++++++----
 1 file changed, 12 insertions(+), 4 deletions(-)

diff --git a/net/ipv6/ip6_fib.c b/net/ipv6/ip6_fib.c
index 0e93ca5..0a36d8d 100644
--- a/net/ipv6/ip6_fib.c
+++ b/net/ipv6/ip6_fib.c
@@ -846,14 +846,22 @@ static struct fib6_node * fib6_lookup_1(struct fib6_node *root,
 
 			if (ipv6_prefix_equal(&key->addr, args->addr, key->plen)) {
 #ifdef CONFIG_IPV6_SUBTREES
-				if (fn->subtree)
-					fn = fib6_lookup_1(fn->subtree, args + 1);
+				if (fn->subtree) {
+					struct fib6_node *sfn;
+					sfn = fib6_lookup_1(fn->subtree,
+							    args + 1);
+					if (!sfn)
+						goto backtrack;
+					fn = sfn;
+				}
 #endif
-				if (!fn || fn->fn_flags & RTN_RTINFO)
+				if (fn->fn_flags & RTN_RTINFO)
 					return fn;
 			}
 		}
-
+#ifdef CONFIG_IPV6_SUBTREES
+backtrack:
+#endif
 		if (fn->fn_flags & RTN_ROOT)
 			break;
 
-- 
1.7.12.2.21.g234cd45.dirty



