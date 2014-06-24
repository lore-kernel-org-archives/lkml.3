Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755419AbaFXP4N (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jun 2014 11:56:13 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:33301 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965000AbaFXP4J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jun 2014 11:56:09 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        stephen hemminger <stephen@networkplumber.org>,
        Pravin B Shelar <pshelar@nicira.com>,
        Cong Wang <cwang@twopensource.com>,
        Cong Wang <xiyou.wangcong@gmail.com>
Subject: [PATCH 3.15 20/61] vxlan: use dev->needed_headroom instead of dev->hard_header_len
Date: Tue, 24 Jun 2014 11:51:03 -0400
Message-Id: <20140624154953.683689178@linuxfoundation.org>
X-Mailer: git-send-email 2.0.0
In-Reply-To: <20140624154952.751713761@linuxfoundation.org>
References: <20140624154952.751713761@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Cong Wang <cwang@twopensource.com>

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/vxlan.c |    7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

--- a/drivers/net/vxlan.c
+++ b/drivers/net/vxlan.c
@@ -2275,9 +2275,9 @@ static void vxlan_setup(struct net_devic
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
@@ -2660,8 +2660,7 @@ static int vxlan_newlink(struct net *net
 		if (!tb[IFLA_MTU])
 			dev->mtu = lowerdev->mtu - (use_ipv6 ? VXLAN6_HEADROOM : VXLAN_HEADROOM);
 
-		/* update header length based on lower device */
-		dev->hard_header_len = lowerdev->hard_header_len +
+		dev->needed_headroom = lowerdev->hard_header_len +
 				       (use_ipv6 ? VXLAN6_HEADROOM : VXLAN_HEADROOM);
 	} else if (use_ipv6)
 		vxlan->flags |= VXLAN_F_IPV6;


