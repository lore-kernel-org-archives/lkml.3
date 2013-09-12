Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757440Ab3ILSZ1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Sep 2013 14:25:27 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:57020 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755358Ab3ILR7J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Sep 2013 13:59:09 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Andrey Konovalov <andreyknvl@google.com>,
        Eric Dumazet <edumazet@google.com>, Dmitry Vyukov <dvyukov@google.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [ 07/46] fib_trie: remove potential out of bound access
Date: Thu, 12 Sep 2013 10:58:18 -0700
Message-Id: <20130912175721.859539102@linuxfoundation.org>
X-Mailer: git-send-email 1.8.4.3.gca3854a
In-Reply-To: <20130912175721.001906199@linuxfoundation.org>
References: <20130912175721.001906199@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ipv4/fib_trie.c |    5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

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
@@ -1761,10 +1760,8 @@ static struct leaf *leaf_walk_rcu(struct
 			if (!c)
 				continue;
 
-			if (IS_LEAF(c)) {
-				prefetch(rcu_dereference_rtnl(p->child[idx]));
+			if (IS_LEAF(c))
 				return (struct leaf *) c;
-			}
 
 			/* Rescan start scanning in new node */
 			p = (struct tnode *) c;


