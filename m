Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752125AbaL2BOc (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Dec 2014 20:14:32 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:33191 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751901AbaL2BMR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Dec 2014 20:12:17 -0500
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "Eric Dumazet" <edumazet@google.com>,
        "Jiri Pirko" <jiri@resnulli.us>,
        "David S. Miller" <davem@davemloft.net>
Date: Mon, 29 Dec 2014 02:11:31 +0100
Message-ID: <lsq.1419815491.262167303@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [PATCH 3.2 21/27] ipv4: fix nexthop attlen check in fib_nh_match
In-Reply-To: <lsq.1419815490.288081487@decadent.org.uk>
X-SA-Exim-Connect-IP: 46.189.28.191
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.66-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Jiri Pirko <jiri@resnulli.us>

commit f76936d07c4eeb36d8dbb64ebd30ab46ff85d9f7 upstream.

fib_nh_match does not match nexthops correctly. Example:

ip route add 172.16.10/24 nexthop via 192.168.122.12 dev eth0 \
                          nexthop via 192.168.122.13 dev eth0
ip route del 172.16.10/24 nexthop via 192.168.122.14 dev eth0 \
                          nexthop via 192.168.122.15 dev eth0

Del command is successful and route is removed. After this patch
applied, the route is correctly matched and result is:
RTNETLINK answers: No such process

Please consider this for stable trees as well.

Fixes: 4e902c57417c4 ("[IPv4]: FIB configuration using struct fib_config")
Signed-off-by: Jiri Pirko <jiri@resnulli.us>
Acked-by: Eric Dumazet <edumazet@google.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 net/ipv4/fib_semantics.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/net/ipv4/fib_semantics.c
+++ b/net/ipv4/fib_semantics.c
@@ -467,7 +467,7 @@ int fib_nh_match(struct fib_config *cfg,
 			return 1;
 
 		attrlen = rtnh_attrlen(rtnh);
-		if (attrlen < 0) {
+		if (attrlen > 0) {
 			struct nlattr *nla, *attrs = rtnh_attrs(rtnh);
 
 			nla = nla_find(attrs, attrlen, RTA_GATEWAY);

