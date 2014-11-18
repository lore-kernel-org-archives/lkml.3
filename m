Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757258AbaKRP1e (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Nov 2014 10:27:34 -0500
Received: from cantor2.suse.de ([195.135.220.15]:57040 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754739AbaKROJZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Nov 2014 09:09:25 -0500
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Jiri Pirko <jiri@resnulli.us>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 3.12 007/206] ipv4: fix nexthop attlen check in fib_nh_match
Date: Tue, 18 Nov 2014 15:06:02 +0100
Message-Id: <bc9b1233fe48f27c2325de5ccc584c4b2a0ce12c.1416319692.git.jslaby@suse.cz>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <28f04bcc068a44c5641c727883947960fb8dcbd5.1416319692.git.jslaby@suse.cz>
References: <28f04bcc068a44c5641c727883947960fb8dcbd5.1416319692.git.jslaby@suse.cz>
In-Reply-To: <cover.1416319692.git.jslaby@suse.cz>
References: <cover.1416319692.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jiri Pirko <jiri@resnulli.us>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

[ Upstream commit f76936d07c4eeb36d8dbb64ebd30ab46ff85d9f7 ]

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
---
 net/ipv4/fib_semantics.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/ipv4/fib_semantics.c b/net/ipv4/fib_semantics.c
index 9f1014ab86c6..ec12b169931b 100644
--- a/net/ipv4/fib_semantics.c
+++ b/net/ipv4/fib_semantics.c
@@ -534,7 +534,7 @@ int fib_nh_match(struct fib_config *cfg, struct fib_info *fi)
 			return 1;
 
 		attrlen = rtnh_attrlen(rtnh);
-		if (attrlen < 0) {
+		if (attrlen > 0) {
 			struct nlattr *nla, *attrs = rtnh_attrs(rtnh);
 
 			nla = nla_find(attrs, attrlen, RTA_GATEWAY);
-- 
2.1.3

