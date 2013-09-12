Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756211Ab3ILSCM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Sep 2013 14:02:12 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:57107 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755683Ab3ILR71 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Sep 2013 13:59:27 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Michele Baldessari <michele@acksyn.org>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Sasha Levin <sasha.levin@oracle.com>,
        Hannes Frederic Sowa <hannes@stressinduktion.org>,
        "David S. Miller" <davem@davemloft.net>
Subject: [ 40/46] ipv6: fix null pointer dereference in __ip6addrlbl_add
Date: Thu, 12 Sep 2013 10:58:51 -0700
Message-Id: <20130912175725.314423710@linuxfoundation.org>
X-Mailer: git-send-email 1.8.4.3.gca3854a
In-Reply-To: <20130912175721.001906199@linuxfoundation.org>
References: <20130912175721.001906199@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hannes Frederic Sowa <hannes@stressinduktion.org>

[ Upstream commit 639739b5e609a5074839bb22fc061b37baa06269 ]

Commit b67bfe0d42cac56c512dd5da4b1b347a23f4b70a ("hlist: drop
the node parameter from iterators") changed the behavior of
hlist_for_each_entry_safe to leave the p argument NULL.

Fix this up by tracking the last argument.

Reported-by: Michele Baldessari <michele@acksyn.org>
Cc: Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>
Cc: Sasha Levin <sasha.levin@oracle.com>
Signed-off-by: Hannes Frederic Sowa <hannes@stressinduktion.org>
Tested-by: Michele Baldessari <michele@acksyn.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ipv6/addrlabel.c |   48 +++++++++++++++++++++++-------------------------
 1 file changed, 23 insertions(+), 25 deletions(-)

--- a/net/ipv6/addrlabel.c
+++ b/net/ipv6/addrlabel.c
@@ -251,38 +251,36 @@ static struct ip6addrlbl_entry *ip6addrl
 /* add a label */
 static int __ip6addrlbl_add(struct ip6addrlbl_entry *newp, int replace)
 {
+	struct hlist_node *n;
+	struct ip6addrlbl_entry *last = NULL, *p = NULL;
 	int ret = 0;
 
-	ADDRLABEL(KERN_DEBUG "%s(newp=%p, replace=%d)\n",
-			__func__,
-			newp, replace);
+	ADDRLABEL(KERN_DEBUG "%s(newp=%p, replace=%d)\n", __func__, newp,
+		  replace);
 
-	if (hlist_empty(&ip6addrlbl_table.head)) {
-		hlist_add_head_rcu(&newp->list, &ip6addrlbl_table.head);
-	} else {
-		struct hlist_node *n;
-		struct ip6addrlbl_entry *p = NULL;
-		hlist_for_each_entry_safe(p, n,
-					  &ip6addrlbl_table.head, list) {
-			if (p->prefixlen == newp->prefixlen &&
-			    net_eq(ip6addrlbl_net(p), ip6addrlbl_net(newp)) &&
-			    p->ifindex == newp->ifindex &&
-			    ipv6_addr_equal(&p->prefix, &newp->prefix)) {
-				if (!replace) {
-					ret = -EEXIST;
-					goto out;
-				}
-				hlist_replace_rcu(&p->list, &newp->list);
-				ip6addrlbl_put(p);
-				goto out;
-			} else if ((p->prefixlen == newp->prefixlen && !p->ifindex) ||
-				   (p->prefixlen < newp->prefixlen)) {
-				hlist_add_before_rcu(&newp->list, &p->list);
+	hlist_for_each_entry_safe(p, n,	&ip6addrlbl_table.head, list) {
+		if (p->prefixlen == newp->prefixlen &&
+		    net_eq(ip6addrlbl_net(p), ip6addrlbl_net(newp)) &&
+		    p->ifindex == newp->ifindex &&
+		    ipv6_addr_equal(&p->prefix, &newp->prefix)) {
+			if (!replace) {
+				ret = -EEXIST;
 				goto out;
 			}
+			hlist_replace_rcu(&p->list, &newp->list);
+			ip6addrlbl_put(p);
+			goto out;
+		} else if ((p->prefixlen == newp->prefixlen && !p->ifindex) ||
+			   (p->prefixlen < newp->prefixlen)) {
+			hlist_add_before_rcu(&newp->list, &p->list);
+			goto out;
 		}
-		hlist_add_after_rcu(&p->list, &newp->list);
+		last = p;
 	}
+	if (last)
+		hlist_add_after_rcu(&last->list, &newp->list);
+	else
+		hlist_add_head_rcu(&newp->list, &ip6addrlbl_table.head);
 out:
 	if (!ret)
 		ip6addrlbl_table.seq++;


