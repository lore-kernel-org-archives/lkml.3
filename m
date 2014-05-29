Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934318AbaE2FXD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2014 01:23:03 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:57896 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932466AbaE2EfW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2014 00:35:22 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Cong Wang <amwang@redhat.com>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        Nicolas Dichtel <nicolas.dichtel@6wind.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 3.14 073/140] vti: dont allow to add the same tunnel twice
Date: Wed, 28 May 2014 21:33:32 -0700
Message-Id: <20140529043058.922173218@linuxfoundation.org>
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

[ Upstream commit 8d89dcdf80d88007647945a753821a06eb6cc5a5 ]

Before the patch, it was possible to add two times the same tunnel:
ip l a vti1 type vti remote 10.16.0.121 local 10.16.0.249 key 41
ip l a vti2 type vti remote 10.16.0.121 local 10.16.0.249 key 41

It was possible, because ip_tunnel_newlink() calls ip_tunnel_find() with the
argument dev->type, which was set only later (when calling ndo_init handler
in register_netdevice()). Let's set this type in the setup handler, which is
called before newlink handler.

Introduced by commit b9959fd3b0fa ("vti: switch to new ip tunnel code").

CC: Cong Wang <amwang@redhat.com>
CC: Steffen Klassert <steffen.klassert@secunet.com>
Signed-off-by: Nicolas Dichtel <nicolas.dichtel@6wind.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ipv4/ip_vti.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/net/ipv4/ip_vti.c
+++ b/net/ipv4/ip_vti.c
@@ -207,6 +207,7 @@ static const struct net_device_ops vti_n
 static void vti_tunnel_setup(struct net_device *dev)
 {
 	dev->netdev_ops		= &vti_netdev_ops;
+	dev->type		= ARPHRD_TUNNEL;
 	ip_tunnel_setup(dev, vti_net_id);
 }
 
@@ -218,7 +219,6 @@ static int vti_tunnel_init(struct net_de
 	memcpy(dev->dev_addr, &iph->saddr, 4);
 	memcpy(dev->broadcast, &iph->daddr, 4);
 
-	dev->type		= ARPHRD_TUNNEL;
 	dev->hard_header_len	= LL_MAX_HEADER + sizeof(struct iphdr);
 	dev->mtu		= ETH_DATA_LEN;
 	dev->flags		= IFF_NOARP;


