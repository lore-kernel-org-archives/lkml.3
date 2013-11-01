Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755692Ab3KAWFH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Nov 2013 18:05:07 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:55066 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755498Ab3KAWE7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Nov 2013 18:04:59 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Phil Oester <kernel@linuxace.com>, Mark Brooks <mark@loadbalancer.org>,
        Julian Anastasov <ja@ssi.bg>,
        Hannes Frederic Sowa <hannes@stressinduktion.org>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 3.10 36/54] ipv6: always prefer rt6i_gateway if present
Date: Fri,  1 Nov 2013 15:04:04 -0700
Message-Id: <20131101220215.384880114@linuxfoundation.org>
X-Mailer: git-send-email 1.8.4.3.gca3854a
In-Reply-To: <20131101220211.311926234@linuxfoundation.org>
References: <20131101220211.311926234@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Julian Anastasov <ja@ssi.bg>

[ Upstream commit 96dc809514fb2328605198a0602b67554d8cce7b ]

In v3.9 6fd6ce2056de2709 ("ipv6: Do not depend on rt->n in
ip6_finish_output2()." changed the behaviour of ip6_finish_output2()
such that the recently introduced rt6_nexthop() is used
instead of an assigned neighbor.

As rt6_nexthop() prefers rt6i_gateway only for gatewayed
routes this causes a problem for users like IPVS, xt_TEE and
RAW(hdrincl) if they want to use different address for routing
compared to the destination address.

Another case is when redirect can create RTF_DYNAMIC
route without RTF_GATEWAY flag, we ignore the rt6i_gateway
in rt6_nexthop().

Fix the above problems by considering the rt6i_gateway if
present, so that traffic routed to address on local subnet is
not wrongly diverted to the destination address.

Thanks to Simon Horman and Phil Oester for spotting the
problematic commit.

Thanks to Hannes Frederic Sowa for his review and help in testing.

Reported-by: Phil Oester <kernel@linuxace.com>
Reported-by: Mark Brooks <mark@loadbalancer.org>
Signed-off-by: Julian Anastasov <ja@ssi.bg>
Acked-by: Hannes Frederic Sowa <hannes@stressinduktion.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/net/ip6_route.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/include/net/ip6_route.h
+++ b/include/net/ip6_route.h
@@ -196,7 +196,7 @@ static inline int ip6_skb_dst_mtu(struct
 
 static inline struct in6_addr *rt6_nexthop(struct rt6_info *rt, struct in6_addr *dest)
 {
-	if (rt->rt6i_flags & RTF_GATEWAY)
+	if (rt->rt6i_flags & RTF_GATEWAY || !ipv6_addr_any(&rt->rt6i_gateway))
 		return &rt->rt6i_gateway;
 	return dest;
 }


