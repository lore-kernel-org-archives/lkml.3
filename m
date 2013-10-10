Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755990Ab3JJPmx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Oct 2013 11:42:53 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:52551 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755759Ab3JJPmt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Oct 2013 11:42:49 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Eric Dumazet <edumazet@google.com>, Dmitry Vyukov <dvyukov@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 007/104] fib_trie: remove potential out of bound access
Date: Thu, 10 Oct 2013 08:40:55 -0700
Message-Id: <1381419752-29733-8-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1381419752-29733-1-git-send-email-kamal@canonical.com>
References: <1381419752-29733-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.11 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Eric Dumazet <edumazet@google.com>

[ Upstream commit aab515d7c32a34300312416c50314e755ea6f765 ]

AddressSanitizer [1] dynamic checker pointed a potential
out of bound access in leaf_walk_rcu()

We could allocate one more slot in tnode_new() to leave the prefetch()
in-place but it looks not worth the pain.

Bug added in commit 82cfbb008572b ("[IPV4] fib_trie: iterator recode")

[1] :
https://code.google.com/p/address-sanitizer/wiki/AddressSanitizerForKernel

Reported-by: Andrey Konovalov <andreyknvl@google.com>
Signed-off-by: Eric Dumazet <edumazet@google.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 net/ipv4/fib_trie.c | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/net/ipv4/fib_trie.c b/net/ipv4/fib_trie.c
index 31d771c..c005f03 100644
--- a/net/ipv4/fib_trie.c
+++ b/net/ipv4/fib_trie.c
@@ -71,7 +71,6 @@
 #include <linux/init.h>
 #include <linux/list.h>
 #include <linux/slab.h>
-#include <linux/prefetch.h>
 #include <linux/export.h>
 #include <net/net_namespace.h>
 #include <net/ip.h>
@@ -1773,10 +1772,8 @@ static struct leaf *leaf_walk_rcu(struct tnode *p, struct rt_trie_node *c)
 			if (!c)
 				continue;
 
-			if (IS_LEAF(c)) {
-				prefetch(rcu_dereference_rtnl(p->child[idx]));
+			if (IS_LEAF(c))
 				return (struct leaf *) c;
-			}
 
 			/* Rescan start scanning in new node */
 			p = (struct tnode *) c;
-- 
1.8.1.2

