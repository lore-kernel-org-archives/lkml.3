Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752974AbaFWIc5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jun 2014 04:32:57 -0400
Received: from ip4-83-240-18-248.cust.nbox.cz ([83.240.18.248]:55550 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752444AbaFWIck (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jun 2014 04:32:40 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Cong Wang <cwang@twopensource.com>,
        "David S. Miller" <davem@davemloft.net>,
        stephen hemminger <stephen@networkplumber.org>,
        Pravin B Shelar <pshelar@nicira.com>,
        Cong Wang <xiyou.wangcong@gmail.com>, Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 110/111] vxlan: use dev->needed_headroom instead of dev->hard_header_len
Date: Mon, 23 Jun 2014 10:32:25 +0200
Message-Id: <0067390aaa904826fbc3fa4b0ee2bcd01ac3b7e9.1403512281.git.jslaby@suse.cz>
X-Mailer: git-send-email 2.0.0
In-Reply-To: <55d5f044a1fc96a74e4470e318c0a24f27a9ab7e.1403512280.git.jslaby@suse.cz>
References: <55d5f044a1fc96a74e4470e318c0a24f27a9ab7e.1403512280.git.jslaby@suse.cz>
In-Reply-To: <cover.1403512280.git.jslaby@suse.cz>
References: <cover.1403512280.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Cong Wang <cwang@twopensource.com>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

[ Upstream commit 2853af6a2ea1a8ed09b09dd4fb578e7f435e8d34 ]

When we mirror packets from a vxlan tunnel to other device,
the mirror device should see the same packets (that is, without
outer header). Because vxlan tunnel sets dev->hard_header_len,
tcf_mirred() resets mac header back to outer mac, the mirror device
actually sees packets with outer headers

Vxlan tunnel should set dev->needed_headroom instead of
dev->hard_header_len, like what other ip tunnels do. This fixes
the above problem.

Cc: "David S. Miller" <davem@davemloft.net>
Cc: stephen hemminger <stephen@networkplumber.org>
Cc: Pravin B Shelar <pshelar@nicira.com>
Signed-off-by: Cong Wang <cwang@twopensource.com>
Signed-off-by: Cong Wang <xiyou.wangcong@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 drivers/net/vxlan.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/drivers/net/vxlan.c b/drivers/net/vxlan.c
index 4ecdf3c22bc6..aa2590a33754 100644
--- a/drivers/net/vxlan.c
+++ b/drivers/net/vxlan.c
@@ -2157,9 +2157,9 @@ static void vxlan_setup(struct net_device *dev)
 	eth_hw_addr_random(dev);
 	ether_setup(dev);
 	if (vxlan->default_dst.remote_ip.sa.sa_family == AF_INET6)
-		dev->hard_header_len = ETH_HLEN + VXLAN6_HEADROOM;
+		dev->needed_headroom = ETH_HLEN + VXLAN6_HEADROOM;
 	else
-		dev->hard_header_len = ETH_HLEN + VXLAN_HEADROOM;
+		dev->needed_headroom = ETH_HLEN + VXLAN_HEADROOM;
 
 	dev->netdev_ops = &vxlan_netdev_ops;
 	dev->destructor = free_netdev;
@@ -2540,8 +2540,7 @@ static int vxlan_newlink(struct net *net, struct net_device *dev,
 		if (!tb[IFLA_MTU])
 			dev->mtu = lowerdev->mtu - (use_ipv6 ? VXLAN6_HEADROOM : VXLAN_HEADROOM);
 
-		/* update header length based on lower device */
-		dev->hard_header_len = lowerdev->hard_header_len +
+		dev->needed_headroom = lowerdev->hard_header_len +
 				       (use_ipv6 ? VXLAN6_HEADROOM : VXLAN_HEADROOM);
 	}
 
-- 
2.0.0

