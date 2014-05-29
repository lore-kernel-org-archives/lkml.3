Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934635AbaE2OBM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2014 10:01:12 -0400
Received: from ip4-83-240-18-248.cust.nbox.cz ([83.240.18.248]:59444 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933383AbaE2Ntc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2014 09:49:32 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Nicolas Dichtel <nicolas.dichtel@6wind.com>,
        Pravin B Shelar <pshelar@nicira.com>,
        "David S. Miller" <davem@davemloft.net>, Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 065/103] gre: don't allow to add the same tunnel twice
Date: Thu, 29 May 2014 15:48:50 +0200
Message-Id: <d6f8502e676b405e195eee423ae5d70096b1c282.1401371259.git.jslaby@suse.cz>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <bcbac220dab16a4038ac1a7c5cfe3e7f034b3836.1401371258.git.jslaby@suse.cz>
References: <bcbac220dab16a4038ac1a7c5cfe3e7f034b3836.1401371258.git.jslaby@suse.cz>
In-Reply-To: <cover.1401371258.git.jslaby@suse.cz>
References: <cover.1401371258.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Nicolas Dichtel <nicolas.dichtel@6wind.com>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

[ Upstream commit 5a4552752d8f7f4cef1d98775ece7adb7616fde2 ]

Before the patch, it was possible to add two times the same tunnel:
ip l a gre1 type gre remote 10.16.0.121 local 10.16.0.249
ip l a gre2 type gre remote 10.16.0.121 local 10.16.0.249

It was possible, because ip_tunnel_newlink() calls ip_tunnel_find() with the
argument dev->type, which was set only later (when calling ndo_init handler
in register_netdevice()). Let's set this type in the setup handler, which is
called before newlink handler.

Introduced by commit c54419321455 ("GRE: Refactor GRE tunneling code.").

CC: Pravin B Shelar <pshelar@nicira.com>
Signed-off-by: Nicolas Dichtel <nicolas.dichtel@6wind.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 net/ipv4/ip_gre.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/ipv4/ip_gre.c b/net/ipv4/ip_gre.c
index d30636080a11..b3becd0727db 100644
--- a/net/ipv4/ip_gre.c
+++ b/net/ipv4/ip_gre.c
@@ -463,6 +463,7 @@ static const struct net_device_ops ipgre_netdev_ops = {
 static void ipgre_tunnel_setup(struct net_device *dev)
 {
 	dev->netdev_ops		= &ipgre_netdev_ops;
+	dev->type		= ARPHRD_IPGRE;
 	ip_tunnel_setup(dev, ipgre_net_id);
 }
 
@@ -501,7 +502,6 @@ static int ipgre_tunnel_init(struct net_device *dev)
 	memcpy(dev->dev_addr, &iph->saddr, 4);
 	memcpy(dev->broadcast, &iph->daddr, 4);
 
-	dev->type		= ARPHRD_IPGRE;
 	dev->flags		= IFF_NOARP;
 	dev->priv_flags		&= ~IFF_XMIT_DST_RELEASE;
 	dev->addr_len		= 4;
-- 
1.9.3

