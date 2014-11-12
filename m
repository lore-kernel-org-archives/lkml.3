Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934098AbaKLESt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2014 23:18:49 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:58444 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753102AbaKLBU5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2014 20:20:57 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Jiri Pirko <jiri@resnulli.us>, Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 3.17 004/319] ipv4: fix nexthop attlen check in fib_nh_match
Date: Wed, 12 Nov 2014 10:12:22 +0900
Message-Id: <20141112010953.350160194@linuxfoundation.org>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <20141112010952.553519040@linuxfoundation.org>
References: <20141112010952.553519040@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jiri Pirko <jiri@resnulli.us>

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ipv4/fib_semantics.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/net/ipv4/fib_semantics.c
+++ b/net/ipv4/fib_semantics.c
@@ -535,7 +535,7 @@ int fib_nh_match(struct fib_config *cfg,
 			return 1;
 
 		attrlen = rtnh_attrlen(rtnh);
-		if (attrlen < 0) {
+		if (attrlen > 0) {
 			struct nlattr *nla, *attrs = rtnh_attrs(rtnh);
 
 			nla = nla_find(attrs, attrlen, RTA_GATEWAY);


