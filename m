Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757780Ab3G3Sxr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jul 2013 14:53:47 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:56596 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757492Ab3G3Srp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jul 2013 14:47:45 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Nicolas Dichtel <nicolas.dichtel@6wind.com>,
        Hannes Frederic Sowa <hannes@stressinduktion.org>,
        "David S. Miller" <davem@davemloft.net>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 69/75] ipv6: only static routes qualify for equal cost multipathing
Date: Tue, 30 Jul 2013 11:45:13 -0700
Message-Id: <1375209919-1768-36-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1375197464-27962-1-git-send-email-kamal@canonical.com>
References: <1375197464-27962-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.6 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hannes Frederic Sowa <hannes@stressinduktion.org>

[ Upstream commit 307f2fb95e9b96b3577916e73d92e104f8f26494 ]

Static routes in this case are non-expiring routes which did not get
configured by autoconf or by icmpv6 redirects.

To make sure we actually get an ecmp route while searching for the first
one in this fib6_node's leafs, also make sure it matches the ecmp route
assumptions.

v2:
a) Removed RTF_EXPIRE check in dst.from chain. The check of RTF_ADDRCONF
   already ensures that this route, even if added again without
   RTF_EXPIRES (in case of a RA announcement with infinite timeout),
   does not cause the rt6i_nsiblings logic to go wrong if a later RA
   updates the expiration time later.

v3:
a) Allow RTF_EXPIRES routes to enter the ecmp route set. We have to do so,
   because an pmtu event could update the RTF_EXPIRES flag and we would
   not count this route, if another route joins this set. We now filter
   only for RTF_GATEWAY|RTF_ADDRCONF|RTF_DYNAMIC, which are flags that
   don't get changed after rt6_info construction.

Cc: Nicolas Dichtel <nicolas.dichtel@6wind.com>
Signed-off-by: Hannes Frederic Sowa <hannes@stressinduktion.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 net/ipv6/ip6_fib.c | 15 +++++++++++----
 1 file changed, 11 insertions(+), 4 deletions(-)

diff --git a/net/ipv6/ip6_fib.c b/net/ipv6/ip6_fib.c
index 710cafd..e67039f 100644
--- a/net/ipv6/ip6_fib.c
+++ b/net/ipv6/ip6_fib.c
@@ -634,6 +634,12 @@ insert_above:
 	return ln;
 }
 
+static inline bool rt6_qualify_for_ecmp(struct rt6_info *rt)
+{
+	return (rt->rt6i_flags & (RTF_GATEWAY|RTF_ADDRCONF|RTF_DYNAMIC)) ==
+	       RTF_GATEWAY;
+}
+
 /*
  *	Insert routing information in a node.
  */
@@ -648,6 +654,7 @@ static int fib6_add_rt2node(struct fib6_node *fn, struct rt6_info *rt,
 	int add = (!info->nlh ||
 		   (info->nlh->nlmsg_flags & NLM_F_CREATE));
 	int found = 0;
+	bool rt_can_ecmp = rt6_qualify_for_ecmp(rt);
 
 	ins = &fn->leaf;
 
@@ -693,9 +700,8 @@ static int fib6_add_rt2node(struct fib6_node *fn, struct rt6_info *rt,
 			 * To avoid long list, we only had siblings if the
 			 * route have a gateway.
 			 */
-			if (rt->rt6i_flags & RTF_GATEWAY &&
-			    !(rt->rt6i_flags & RTF_EXPIRES) &&
-			    !(iter->rt6i_flags & RTF_EXPIRES))
+			if (rt_can_ecmp &&
+			    rt6_qualify_for_ecmp(iter))
 				rt->rt6i_nsiblings++;
 		}
 
@@ -717,7 +723,8 @@ static int fib6_add_rt2node(struct fib6_node *fn, struct rt6_info *rt,
 		/* Find the first route that have the same metric */
 		sibling = fn->leaf;
 		while (sibling) {
-			if (sibling->rt6i_metric == rt->rt6i_metric) {
+			if (sibling->rt6i_metric == rt->rt6i_metric &&
+			    rt6_qualify_for_ecmp(sibling)) {
 				list_add_tail(&rt->rt6i_siblings,
 					      &sibling->rt6i_siblings);
 				break;
-- 
1.8.1.2

