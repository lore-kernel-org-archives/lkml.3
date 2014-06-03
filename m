Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755090AbaFCLyT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jun 2014 07:54:19 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:43745 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932884AbaFCLmZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jun 2014 07:42:25 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Pravin B Shelar <pshelar@nicira.com>,
        Nicolas Dichtel <nicolas.dichtel@6wind.com>,
        "David S. Miller" <davem@davemloft.net>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 102/138] gre: don't allow to add the same tunnel twice
Date: Tue,  3 Jun 2014 12:39:08 +0100
Message-Id: <1401795584-22664-103-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1401795584-22664-1-git-send-email-luis.henriques@canonical.com>
References: <1401795584-22664-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.11 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nicolas Dichtel <nicolas.dichtel@6wind.com>

commit 5a4552752d8f7f4cef1d98775ece7adb7616fde2 upstream.

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
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 net/ipv4/ip_gre.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/ipv4/ip_gre.c b/net/ipv4/ip_gre.c
index 297740070250..06ae1eb02f56 100644
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

