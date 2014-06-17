Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965558AbaFQVpc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jun 2014 17:45:32 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:53637 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965487AbaFQVp2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jun 2014 17:45:28 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Pravin B Shelar <pshelar@nicira.com>,
        Nicolas Dichtel <nicolas.dichtel@6wind.com>,
        "David S. Miller" <davem@davemloft.net>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13 010/212] gre: don't allow to add the same tunnel twice
Date: Tue, 17 Jun 2014 14:41:44 -0700
Message-Id: <1403041506-13646-11-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1403041506-13646-1-git-send-email-kamal@canonical.com>
References: <1403041506-13646-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11.4 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nicolas Dichtel <nicolas.dichtel@6wind.com>

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
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 net/ipv4/ip_gre.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/ipv4/ip_gre.c b/net/ipv4/ip_gre.c
index d306360..b3becd0 100644
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
1.9.1

