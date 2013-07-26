Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760745Ab3GZVoq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jul 2013 17:44:46 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:50727 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759826Ab3GZUsQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jul 2013 16:48:16 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Pierre Emeriaud <petrus.lt@gmail.com>,
        YOSHIFUJI Hideaki <yoshfuji@linux-ipv6.org>,
        Hannes Frederic Sowa <hannes@stressinduktion.org>,
        "David S. Miller" <davem@davemloft.net>
Subject: [ 15/79] ipv6: rt6_check_neigh should successfully verify neigh if no NUD information are available
Date: Fri, 26 Jul 2013 13:47:05 -0700
Message-Id: <20130726204723.522556889@linuxfoundation.org>
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

[ Upstream commit 3630d40067a21d4dfbadc6002bb469ce26ac5d52 ]

After the removal of rt->n we do not create a neighbour entry at route
insertion time (rt6_bind_neighbour is gone). As long as no neighbour is
created because of "useful traffic" we skip this routing entry because
rt6_check_neigh cannot pick up a valid neighbour (neigh == NULL) and
thus returns false.

This change was introduced by commit
887c95cc1da53f66a5890fdeab13414613010097 ("ipv6: Complete neighbour
entry removal from dst_entry.")

To quote RFC4191:
"If the host has no information about the router's reachability, then
the host assumes the router is reachable."

and also:
"A host MUST NOT probe a router's reachability in the absence of useful
traffic that the host would have sent to the router if it were reachable."

So, just assume the router is reachable and let's rt6_probe do the
rest. We don't need to create a neighbour on route insertion time.

If we don't compile with CONFIG_IPV6_ROUTER_PREF (RFC4191 support)
a neighbour is only valid if its nud_state is NUD_VALID. I did not find
any references that we should probe the router on route insertion time
via the other RFCs. So skip this route in that case.

v2:
a) use IS_ENABLED instead of #ifdefs (thanks to Sergei Shtylyov)

Reported-by: Pierre Emeriaud <petrus.lt@gmail.com>
Cc: YOSHIFUJI Hideaki <yoshfuji@linux-ipv6.org>
Signed-off-by: Hannes Frederic Sowa <hannes@stressinduktion.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ipv6/route.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/net/ipv6/route.c
+++ b/net/ipv6/route.c
@@ -547,6 +547,8 @@ static inline bool rt6_check_neigh(struc
 			ret = true;
 #endif
 		read_unlock(&neigh->lock);
+	} else if (IS_ENABLED(CONFIG_IPV6_ROUTER_PREF)) {
+		ret = true;
 	}
 	rcu_read_unlock_bh();
 


