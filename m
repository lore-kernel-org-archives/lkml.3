Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933835Ab3GZVkk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jul 2013 17:40:40 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:50772 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759796Ab3GZUs1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jul 2013 16:48:27 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Nicolas Dichtel <nicolas.dichtel@6wind.com>,
        Hannes Frederic Sowa <hannes@stressinduktion.org>,
        "David S. Miller" <davem@davemloft.net>
Subject: [ 32/79] ipv6: only static routes qualify for equal cost multipathing
Date: Fri, 26 Jul 2013 13:47:22 -0700
Message-Id: <20130726204725.295010679@linuxfoundation.org>
X-Mailer: git-send-email 1.8.3.rc0.20.gb99dd2e
In-Reply-To: <20130726204721.849052763@linuxfoundation.org>
References: <20130726204721.849052763@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ipv6/ip6_fib.c |   15 +++++++++++----
 1 file changed, 11 insertions(+), 4 deletions(-)

--- a/net/ipv6/ip6_fib.c
+++ b/net/ipv6/ip6_fib.c
@@ -632,6 +632,12 @@ insert_above:
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
@@ -646,6 +652,7 @@ static int fib6_add_rt2node(struct fib6_
 	int add = (!info->nlh ||
 		   (info->nlh->nlmsg_flags & NLM_F_CREATE));
 	int found = 0;
+	bool rt_can_ecmp = rt6_qualify_for_ecmp(rt);
 
 	ins = &fn->leaf;
 
@@ -691,9 +698,8 @@ static int fib6_add_rt2node(struct fib6_
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
 
@@ -715,7 +721,8 @@ static int fib6_add_rt2node(struct fib6_
 		/* Find the first route that have the same metric */
 		sibling = fn->leaf;
 		while (sibling) {
-			if (sibling->rt6i_metric == rt->rt6i_metric) {
+			if (sibling->rt6i_metric == rt->rt6i_metric &&
+			    rt6_qualify_for_ecmp(sibling)) {
 				list_add_tail(&rt->rt6i_siblings,
 					      &sibling->rt6i_siblings);
 				break;


