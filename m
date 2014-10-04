Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752853AbaJDJ6p (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Oct 2014 05:58:45 -0400
Received: from mailrelay006.isp.belgacom.be ([195.238.6.172]:34196 "EHLO
	mailrelay006.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751676AbaJDJ6n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Oct 2014 05:58:43 -0400
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Ao8OAADEL1RXQCPs/2dsb2JhbABggw6BK7cNAQEBAQEBBQFzmmeBBhcBe4QxLyOBGjeIQgGvRo9hhiCKJR2ENQWdPoxSiS6DZTsvgkoBAQE
From: Fabian Frederick <fabf@skynet.be>
To: linux-kernel@vger.kernel.org
Cc: Josh Triplett <josh@joshtriplett.org>, Fabian Frederick <fabf@skynet.be>,
        Remi Denis-Courmont <courmisch@gmail.com>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Subject: [RFC 1/1] net: fix rcu access on phonet_routes
Date: Sat,  4 Oct 2014 11:57:56 +0200
Message-Id: <1412416676-21698-1-git-send-email-fabf@skynet.be>
X-Mailer: git-send-email 1.9.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-Add __rcu annotation on table to fix sparse warnings:
net/phonet/pn_dev.c:279:25: warning: incorrect type in assignment (different address spaces)
net/phonet/pn_dev.c:279:25:    expected struct net_device *<noident>
net/phonet/pn_dev.c:279:25:    got void [noderef] <asn:4>*<noident>
net/phonet/pn_dev.c:376:17: warning: incorrect type in assignment (different address spaces)
net/phonet/pn_dev.c:376:17:    expected struct net_device *volatile <noident>
net/phonet/pn_dev.c:376:17:    got struct net_device [noderef] <asn:4>*<noident>
net/phonet/pn_dev.c:392:17: warning: incorrect type in assignment (different address spaces)
net/phonet/pn_dev.c:392:17:    expected struct net_device *<noident>
net/phonet/pn_dev.c:392:17:    got void [noderef] <asn:4>*<noident>

-Access table with rcu_dereference (fixes the following sparse errors):
net/phonet/pn_dev.c:278:25: error: incompatible types in comparison expression (different address spaces)
net/phonet/pn_dev.c:391:17: error: incompatible types in comparison expression (different address spaces)

Signed-off-by: Fabian Frederick <fabf@skynet.be>
---
 net/phonet/pn_dev.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/net/phonet/pn_dev.c b/net/phonet/pn_dev.c
index 56a6146..5c9c0b2f1 100644
--- a/net/phonet/pn_dev.c
+++ b/net/phonet/pn_dev.c
@@ -36,7 +36,7 @@
 
 struct phonet_routes {
 	struct mutex		lock;
-	struct net_device	*table[64];
+	struct net_device __rcu	*table[64];
 };
 
 struct phonet_net {
@@ -275,7 +275,7 @@ static void phonet_route_autodel(struct net_device *dev)
 	bitmap_zero(deleted, 64);
 	mutex_lock(&pnn->routes.lock);
 	for (i = 0; i < 64; i++)
-		if (dev == pnn->routes.table[i]) {
+		if (rcu_dereference(pnn->routes.table[i]) == dev) {
 			RCU_INIT_POINTER(pnn->routes.table[i], NULL);
 			set_bit(i, deleted);
 		}
@@ -388,7 +388,7 @@ int phonet_route_del(struct net_device *dev, u8 daddr)
 
 	daddr = daddr >> 2;
 	mutex_lock(&routes->lock);
-	if (dev == routes->table[daddr])
+	if (rcu_dereference(routes->table[daddr]) == dev)
 		RCU_INIT_POINTER(routes->table[daddr], NULL);
 	else
 		dev = NULL;
-- 
1.9.3

