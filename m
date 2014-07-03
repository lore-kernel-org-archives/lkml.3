Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030251AbaGCJld (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jul 2014 05:41:33 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:52384 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030374AbaGCJY1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jul 2014 05:24:27 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: "David S. Miller" <davem@davemloft.net>,
        stephen hemminger <stephen@networkplumber.org>,
        Pravin B Shelar <pshelar@nicira.com>,
        Cong Wang <cwang@twopensource.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 151/198] vxlan: use dev->needed_headroom instead of dev->hard_header_len
Date: Thu,  3 Jul 2014 10:19:54 +0100
Message-Id: <1404379241-8590-152-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1404379241-8590-1-git-send-email-luis.henriques@canonical.com>
References: <1404379241-8590-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.13 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Cong Wang <cwang@twopensource.com>

commit 2853af6a2ea1a8ed09b09dd4fb578e7f435e8d34 upstream.

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
[ luis: backported to 3.11: used davem's backport for 3.10 ]
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/net/vxlan.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/vxlan.c b/drivers/net/vxlan.c
index 116810f9ca35..80bd392c1d84 100644
--- a/drivers/net/vxlan.c
+++ b/drivers/net/vxlan.c
@@ -1476,7 +1476,7 @@ static void vxlan_setup(struct net_device *dev)
 
 	eth_hw_addr_random(dev);
 	ether_setup(dev);
-	dev->hard_header_len = ETH_HLEN + VXLAN_HEADROOM;
+	dev->needed_headroom = ETH_HLEN + VXLAN_HEADROOM;
 
 	dev->netdev_ops = &vxlan_netdev_ops;
 	dev->destructor = free_netdev;
@@ -1720,7 +1720,7 @@ static int vxlan_newlink(struct net *net, struct net_device *dev,
 			dev->mtu = lowerdev->mtu - VXLAN_HEADROOM;
 
 		/* update header length based on lower device */
-		dev->hard_header_len = lowerdev->hard_header_len +
+		dev->needed_headroom = lowerdev->hard_header_len +
 				       VXLAN_HEADROOM;
 	}
 
-- 
1.9.1

