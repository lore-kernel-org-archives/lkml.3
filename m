Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966470AbaFQWtZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jun 2014 18:49:25 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:53692 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965537AbaFQVpb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jun 2014 17:45:31 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Cong Wang <amwang@redhat.com>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        Nicolas Dichtel <nicolas.dichtel@6wind.com>,
        "David S. Miller" <davem@davemloft.net>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13 011/212] vti: don't allow to add the same tunnel twice
Date: Tue, 17 Jun 2014 14:41:45 -0700
Message-Id: <1403041506-13646-12-git-send-email-kamal@canonical.com>
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
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 net/ipv4/ip_vti.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/ipv4/ip_vti.c b/net/ipv4/ip_vti.c
index 52b802a..2a89e3f 100644
--- a/net/ipv4/ip_vti.c
+++ b/net/ipv4/ip_vti.c
@@ -207,6 +207,7 @@ static const struct net_device_ops vti_netdev_ops = {
 static void vti_tunnel_setup(struct net_device *dev)
 {
 	dev->netdev_ops		= &vti_netdev_ops;
+	dev->type		= ARPHRD_TUNNEL;
 	ip_tunnel_setup(dev, vti_net_id);
 }
 
@@ -218,7 +219,6 @@ static int vti_tunnel_init(struct net_device *dev)
 	memcpy(dev->dev_addr, &iph->saddr, 4);
 	memcpy(dev->broadcast, &iph->daddr, 4);
 
-	dev->type		= ARPHRD_TUNNEL;
 	dev->hard_header_len	= LL_MAX_HEADER + sizeof(struct iphdr);
 	dev->mtu		= ETH_DATA_LEN;
 	dev->flags		= IFF_NOARP;
-- 
1.9.1

