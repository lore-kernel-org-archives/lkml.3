Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934337AbaE2FXx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2014 01:23:53 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:57889 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932452AbaE2EfW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2014 00:35:22 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Pravin B Shelar <pshelar@nicira.com>,
        Nicolas Dichtel <nicolas.dichtel@6wind.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 3.14 072/140] gre: dont allow to add the same tunnel twice
Date: Wed, 28 May 2014 21:33:31 -0700
Message-Id: <20140529043058.785901228@linuxfoundation.org>
X-Mailer: git-send-email 2.0.0.rc3.2.g998f840
In-Reply-To: <20140529043049.661315084@linuxfoundation.org>
References: <20140529043049.661315084@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.14-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ipv4/ip_gre.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/net/ipv4/ip_gre.c
+++ b/net/ipv4/ip_gre.c
@@ -463,6 +463,7 @@ static const struct net_device_ops ipgre
 static void ipgre_tunnel_setup(struct net_device *dev)
 {
 	dev->netdev_ops		= &ipgre_netdev_ops;
+	dev->type		= ARPHRD_IPGRE;
 	ip_tunnel_setup(dev, ipgre_net_id);
 }
 
@@ -501,7 +502,6 @@ static int ipgre_tunnel_init(struct net_
 	memcpy(dev->dev_addr, &iph->saddr, 4);
 	memcpy(dev->broadcast, &iph->daddr, 4);
 
-	dev->type		= ARPHRD_IPGRE;
 	dev->flags		= IFF_NOARP;
 	dev->priv_flags		&= ~IFF_XMIT_DST_RELEASE;
 	dev->addr_len		= 4;


