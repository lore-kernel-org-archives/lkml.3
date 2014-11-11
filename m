Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932120AbaKKLwc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2014 06:52:32 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:57436 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753907AbaKKLKG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2014 06:10:06 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Jiri Pirko <jiri@resnulli.us>, "David S. Miller" <davem@davemloft.net>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.16.y-ckt 069/170] ipv4: fix nexthop attlen check in fib_nh_match
Date: Tue, 11 Nov 2014 11:07:08 +0000
Message-Id: <1415704129-12709-70-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1415704129-12709-1-git-send-email-luis.henriques@canonical.com>
References: <1415704129-12709-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.16
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.16.7-ckt1 -stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 net/ipv4/fib_semantics.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/ipv4/fib_semantics.c b/net/ipv4/fib_semantics.c
index b10cd43a4722..4a74ea85518f 100644
--- a/net/ipv4/fib_semantics.c
+++ b/net/ipv4/fib_semantics.c
@@ -535,7 +535,7 @@ int fib_nh_match(struct fib_config *cfg, struct fib_info *fi)
 			return 1;
 
 		attrlen = rtnh_attrlen(rtnh);
-		if (attrlen < 0) {
+		if (attrlen > 0) {
 			struct nlattr *nla, *attrs = rtnh_attrs(rtnh);
 
 			nla = nla_find(attrs, attrlen, RTA_GATEWAY);
-- 
2.1.0

