Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934378Ab3BSTCO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Feb 2013 14:02:14 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:54433 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934344Ab3BSSxe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Feb 2013 13:53:34 -0500
From: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Jiri Pirko <jiri@resnulli.us>,
        Marcelo Ricardo Leitner <mleitner@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
Subject: [PATCH 56/81] ipv6: do not create neighbor entries for local delivery
Date: Tue, 19 Feb 2013 15:49:19 -0300
Message-Id: <1361299784-8830-57-git-send-email-herton.krzesinski@canonical.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1361299784-8830-1-git-send-email-herton.krzesinski@canonical.com>
References: <1361299784-8830-1-git-send-email-herton.krzesinski@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.6 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Marcelo Ricardo Leitner <mleitner@redhat.com>

commit bd30e947207e2ea0ff2c08f5b4a03025ddce48d3 upstream.

They will be created at output, if ever needed. This avoids creating
empty neighbor entries when TPROXYing/Forwarding packets for addresses
that are not even directly reachable.

Note that IPv4 already handles it this way. No neighbor entries are
created for local input.

Tested by myself and customer.

Signed-off-by: Jiri Pirko <jiri@resnulli.us>
Signed-off-by: Marcelo Ricardo Leitner <mleitner@redhat.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
[ herton: adjust if condition, add additional RTF_LOCAL flag for the
  check ]
Signed-off-by: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
---
 net/ipv6/route.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/ipv6/route.c b/net/ipv6/route.c
index fd44184..08c149c 100644
--- a/net/ipv6/route.c
+++ b/net/ipv6/route.c
@@ -846,7 +846,8 @@ restart:
 	dst_hold(&rt->dst);
 	read_unlock_bh(&table->tb6_lock);
 
-	if (!dst_get_neighbour_noref_raw(&rt->dst) && !(rt->rt6i_flags & RTF_NONEXTHOP))
+	if (!dst_get_neighbour_noref_raw(&rt->dst) &&
+	    !(rt->rt6i_flags & (RTF_NONEXTHOP | RTF_LOCAL)))
 		nrt = rt6_alloc_cow(rt, &fl6->daddr, &fl6->saddr);
 	else if (!(rt->dst.flags & DST_HOST))
 		nrt = rt6_alloc_clone(rt, &fl6->daddr);
-- 
1.7.9.5

