Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755141Ab3JUJec (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Oct 2013 05:34:32 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:39274 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753054Ab3JUIuR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Oct 2013 04:50:17 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "Andrey Konovalov" <andreyknvl@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        "Eric Dumazet" <edumazet@google.com>,
        "Dmitry Vyukov" <dvyukov@google.com>
Date: Mon, 21 Oct 2013 09:46:28 +0100
Message-ID: <lsq.1382345188.241074300@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [PATCH 3.2 003/149] fib_trie: remove potential out of bound access
In-Reply-To: <lsq.1382345187.199780875@decadent.org.uk>
X-SA-Exim-Connect-IP: 212.20.242.100
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.52-rc1 review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 net/ipv4/fib_trie.c | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/net/ipv4/fib_trie.c b/net/ipv4/fib_trie.c
index cd2d639..c7c6724 100644
--- a/net/ipv4/fib_trie.c
+++ b/net/ipv4/fib_trie.c
@@ -72,7 +72,6 @@
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

