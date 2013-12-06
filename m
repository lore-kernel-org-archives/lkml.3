Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1162988Ab3LFXz2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Dec 2013 18:55:28 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:48343 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759026Ab3LFXMd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Dec 2013 18:12:33 -0500
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: YOSHIFUJI Hideaki <yoshfuji@linux-ipv6.org>,
        Hannes Frederic Sowa <hannes@stressinduktion.org>,
        "David S. Miller" <davem@davemloft.net>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.8 001/152] ipv6: ip6_dst_check needs to check for expired dst_entries
Date: Fri,  6 Dec 2013 15:08:45 -0800
Message-Id: <1386371476-2477-2-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1386371476-2477-1-git-send-email-kamal@canonical.com>
References: <1386371476-2477-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.14 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hannes Frederic Sowa <hannes@stressinduktion.org>

[ Upstream commit e3bc10bd95d7fcc3f2ac690c6ff22833ea6781d6 ]

On receiving a packet too big icmp error we check if our current cached
dst_entry in the socket is still valid. This validation check did not
care about the expiration of the (cached) route.

The error path I traced down:
The socket receives a packet too big mtu notification. It still has a
valid dst_entry and thus issues the ip6_rt_pmtu_update on this dst_entry,
setting RTF_EXPIRE and updates the dst.expiration value (which could
fail because of not up-to-date expiration values, see previous patch).

In some seldom cases we race with a) the ip6_fib gc or b) another routing
lookup which would result in a recreation of the cached rt6_info from its
parent non-cached rt6_info. While copying the rt6_info we reinitialize the
metrics store by copying it over from the parent thus invalidating the
just installed pmtu update (both dsts use the same key to the inetpeer
storage). The dst_entry with the just invalidated metrics data would
just get its RTF_EXPIRES flag cleared and would continue to stay valid
for the socket.

We should have not issued the pmtu update on the already expired dst_entry
in the first placed. By checking the expiration on the dst entry and
doing a relookup in case it is out of date we close the race because
we would install a new rt6_info into the fib before we issue the pmtu
update, thus closing this race.

Not reliably updating the dst.expire value was fixed by the patch "ipv6:
reset dst.expires value when clearing expire flag".

Reported-by: Steinar H. Gunderson <sgunderson@bigfoot.com>
Reported-by: Valentijn Sessink <valentyn@blub.net>
Cc: YOSHIFUJI Hideaki <yoshfuji@linux-ipv6.org>
Signed-off-by: Hannes Frederic Sowa <hannes@stressinduktion.org>
Reviewed-by: Eric Dumazet <edumazet@google.com>
Tested-by: Valentijn Sessink <valentyn@blub.net>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 net/ipv6/route.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/net/ipv6/route.c b/net/ipv6/route.c
index 2f01ab3..c9eb8eb 100644
--- a/net/ipv6/route.c
+++ b/net/ipv6/route.c
@@ -1086,10 +1086,13 @@ static struct dst_entry *ip6_dst_check(struct dst_entry *dst, u32 cookie)
 	if (rt->rt6i_genid != rt_genid(dev_net(rt->dst.dev)))
 		return NULL;
 
-	if (rt->rt6i_node && (rt->rt6i_node->fn_sernum == cookie))
-		return dst;
+	if (!rt->rt6i_node || (rt->rt6i_node->fn_sernum != cookie))
+		return NULL;
 
-	return NULL;
+	if (rt6_check_expired(rt))
+		return NULL;
+
+	return dst;
 }
 
 static struct dst_entry *ip6_negative_advice(struct dst_entry *dst)
-- 
1.8.3.2

