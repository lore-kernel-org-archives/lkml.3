Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752939AbaFWIiN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jun 2014 04:38:13 -0400
Received: from ip4-83-240-18-248.cust.nbox.cz ([83.240.18.248]:55625 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752683AbaFWIca (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jun 2014 04:32:30 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Dmitry Popov <ixaphire@qrator.net>,
        "David S. Miller" <davem@davemloft.net>, Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 106/111] ipip, sit: fix ipv4_{update_pmtu,redirect} calls
Date: Mon, 23 Jun 2014 10:32:21 +0200
Message-Id: <4b5b1dd6dc1b26c9996375c783f34e428a2307d8.1403512281.git.jslaby@suse.cz>
X-Mailer: git-send-email 2.0.0
In-Reply-To: <55d5f044a1fc96a74e4470e318c0a24f27a9ab7e.1403512280.git.jslaby@suse.cz>
References: <55d5f044a1fc96a74e4470e318c0a24f27a9ab7e.1403512280.git.jslaby@suse.cz>
In-Reply-To: <cover.1403512280.git.jslaby@suse.cz>
References: <cover.1403512280.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Dmitry Popov <ixaphire@qrator.net>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

[ Upstream commit 2346829e641b804ece9ac9298136b56d9567c278 ]

ipv4_{update_pmtu,redirect} were called with tunnel's ifindex (t->dev is a
tunnel netdevice). It caused wrong route lookup and failure of pmtu update or
redirect. We should use the same ifindex that we use in ip_route_output_* in
*tunnel_xmit code. It is t->parms.link .

Signed-off-by: Dmitry Popov <ixaphire@qrator.net>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 net/ipv4/ipip.c | 4 ++--
 net/ipv6/sit.c  | 4 ++--
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/net/ipv4/ipip.c b/net/ipv4/ipip.c
index a72a97f52954..077f9004376f 100644
--- a/net/ipv4/ipip.c
+++ b/net/ipv4/ipip.c
@@ -149,13 +149,13 @@ static int ipip_err(struct sk_buff *skb, u32 info)
 
 	if (type == ICMP_DEST_UNREACH && code == ICMP_FRAG_NEEDED) {
 		ipv4_update_pmtu(skb, dev_net(skb->dev), info,
-				 t->dev->ifindex, 0, IPPROTO_IPIP, 0);
+				 t->parms.link, 0, IPPROTO_IPIP, 0);
 		err = 0;
 		goto out;
 	}
 
 	if (type == ICMP_REDIRECT) {
-		ipv4_redirect(skb, dev_net(skb->dev), t->dev->ifindex, 0,
+		ipv4_redirect(skb, dev_net(skb->dev), t->parms.link, 0,
 			      IPPROTO_IPIP, 0);
 		err = 0;
 		goto out;
diff --git a/net/ipv6/sit.c b/net/ipv6/sit.c
index 20a446ffa44b..e46fcde5a79b 100644
--- a/net/ipv6/sit.c
+++ b/net/ipv6/sit.c
@@ -530,12 +530,12 @@ static int ipip6_err(struct sk_buff *skb, u32 info)
 
 	if (type == ICMP_DEST_UNREACH && code == ICMP_FRAG_NEEDED) {
 		ipv4_update_pmtu(skb, dev_net(skb->dev), info,
-				 t->dev->ifindex, 0, IPPROTO_IPV6, 0);
+				 t->parms.link, 0, IPPROTO_IPV6, 0);
 		err = 0;
 		goto out;
 	}
 	if (type == ICMP_REDIRECT) {
-		ipv4_redirect(skb, dev_net(skb->dev), t->dev->ifindex, 0,
+		ipv4_redirect(skb, dev_net(skb->dev), t->parms.link, 0,
 			      IPPROTO_IPV6, 0);
 		err = 0;
 		goto out;
-- 
2.0.0

