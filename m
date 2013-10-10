Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756112Ab3JJPnh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Oct 2013 11:43:37 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:52630 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755260Ab3JJPne (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Oct 2013 11:43:34 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: YOSHIFUJI Hideaki <yoshfuji@linux-ipv6.org>,
        David Lamparter <equinox@diac24.net>,
        <boutier@pps.univ-paris-diderot.fr>,
        Hannes Frederic Sowa <hannes@stressinduktion.org>,
        "David S. Miller" <davem@davemloft.net>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 011/104] ipv6: don't stop backtracking in fib6_lookup_1 if subtree does not match
Date: Thu, 10 Oct 2013 08:40:59 -0700
Message-Id: <1381419752-29733-12-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1381419752-29733-1-git-send-email-kamal@canonical.com>
References: <1381419752-29733-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.11 -stable review patch.  If anyone has any objections, please let me know.

------------------

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
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 net/ipv6/ip6_fib.c | 16 ++++++++++++----
 1 file changed, 12 insertions(+), 4 deletions(-)

diff --git a/net/ipv6/ip6_fib.c b/net/ipv6/ip6_fib.c
index e67039f..7c39aa6 100644
--- a/net/ipv6/ip6_fib.c
+++ b/net/ipv6/ip6_fib.c
@@ -995,14 +995,22 @@ static struct fib6_node * fib6_lookup_1(struct fib6_node *root,
 
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
1.8.1.2

