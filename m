Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757287Ab3KAWkS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Nov 2013 18:40:18 -0400
Received: from e38.co.us.ibm.com ([32.97.110.159]:50138 "EHLO
	e38.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754145Ab3KAWkJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Nov 2013 18:40:09 -0400
From: Cody P Schafer <cody@linux.vnet.ibm.com>
To: "David S. Miller" <davem@davemloft.net>, Florian Westphal <fw@strlen.de>,
        Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        YOSHIFUJI Hideaki <yoshfuji@linux-ipv6.org>
Cc: Cody P Schafer <cody@linux.vnet.ibm.com>, coreteam@netfilter.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        netfilter-devel@vger.kernel.org, netfilter@vger.kernel.org,
        Patrick McHardy <kaber@trash.net>
Subject: [PATCH 1/8] net ipset: use rbtree postorder iteration instead of opencoding
Date: Fri,  1 Nov 2013 15:38:45 -0700
Message-Id: <1383345566-25087-1-git-send-email-cody@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.8.4.2
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13110122-1344-0000-0000-000002F05469
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use rbtree_postorder_for_each_entry_safe() to destroy the rbtree instead
of opencoding an alternate postorder iteration that modifies the tree

Signed-off-by: Cody P Schafer <cody@linux.vnet.ibm.com>
---
 net/netfilter/ipset/ip_set_hash_netiface.c | 27 ++++-----------------------
 1 file changed, 4 insertions(+), 23 deletions(-)

diff --git a/net/netfilter/ipset/ip_set_hash_netiface.c b/net/netfilter/ipset/ip_set_hash_netiface.c
index 7d798d5..99dba4c 100644
--- a/net/netfilter/ipset/ip_set_hash_netiface.c
+++ b/net/netfilter/ipset/ip_set_hash_netiface.c
@@ -45,31 +45,12 @@ struct iface_node {
 static void
 rbtree_destroy(struct rb_root *root)
 {
-	struct rb_node *p, *n = root->rb_node;
-	struct iface_node *node;
-
-	/* Non-recursive destroy, like in ext3 */
-	while (n) {
-		if (n->rb_left) {
-			n = n->rb_left;
-			continue;
-		}
-		if (n->rb_right) {
-			n = n->rb_right;
-			continue;
-		}
-		p = rb_parent(n);
-		node = rb_entry(n, struct iface_node, node);
-		if (!p)
-			*root = RB_ROOT;
-		else if (p->rb_left == n)
-			p->rb_left = NULL;
-		else if (p->rb_right == n)
-			p->rb_right = NULL;
+	struct iface_node *node, *next;
 
+	rbtree_postorder_for_each_entry_safe(node, next, root, node)
 		kfree(node);
-		n = p;
-	}
+
+	*root = RB_ROOT;
 }
 
 static int
-- 
1.8.4.2

