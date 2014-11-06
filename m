Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932083AbaKFXY4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Nov 2014 18:24:56 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:58443 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751329AbaKFWha (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Nov 2014 17:37:30 -0500
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Gerhard Stenzel <gerhard.stenzel@de.ibm.com>,
        "David S. Miller" <davem@davemloft.net>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13 010/162] vxlan: fix incorrect initializer in union vxlan_addr
Date: Thu,  6 Nov 2014 14:34:34 -0800
Message-Id: <1415313426-9622-11-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1415313426-9622-1-git-send-email-kamal@canonical.com>
References: <1415313426-9622-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11.11 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Gerhard Stenzel <gstenzel@linux.vnet.ibm.com>

[ Upstream commit a45e92a599e77ee6a850eabdd0141633fde03915 ]

The first initializer in the following

        union vxlan_addr ipa = {
            .sin.sin_addr.s_addr = tip,
            .sa.sa_family = AF_INET,
        };

is optimised away by the compiler, due to the second initializer,
therefore initialising .sin.sin_addr.s_addr always to 0.
This results in netlink messages indicating a L3 miss never contain the
missed IP address. This was observed with GCC 4.8 and 4.9. I do not know about previous versions.
The problem affects user space programs relying on an IP address being
sent as part of a netlink message indicating a L3 miss.

Changing
            .sa.sa_family = AF_INET,
to
            .sin.sin_family = AF_INET,
fixes the problem.

Signed-off-by: Gerhard Stenzel <gerhard.stenzel@de.ibm.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/net/vxlan.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/net/vxlan.c b/drivers/net/vxlan.c
index 7e748a1..5543eb1 100644
--- a/drivers/net/vxlan.c
+++ b/drivers/net/vxlan.c
@@ -1224,7 +1224,7 @@ static int arp_reduce(struct net_device *dev, struct sk_buff *skb)
 	} else if (vxlan->flags & VXLAN_F_L3MISS) {
 		union vxlan_addr ipa = {
 			.sin.sin_addr.s_addr = tip,
-			.sa.sa_family = AF_INET,
+			.sin.sin_family = AF_INET,
 		};
 
 		vxlan_ip_miss(dev, &ipa);
@@ -1385,7 +1385,7 @@ static int neigh_reduce(struct net_device *dev, struct sk_buff *skb)
 	} else if (vxlan->flags & VXLAN_F_L3MISS) {
 		union vxlan_addr ipa = {
 			.sin6.sin6_addr = msg->target,
-			.sa.sa_family = AF_INET6,
+			.sin6.sin6_family = AF_INET6,
 		};
 
 		vxlan_ip_miss(dev, &ipa);
@@ -1418,7 +1418,7 @@ static bool route_shortcircuit(struct net_device *dev, struct sk_buff *skb)
 		if (!n && (vxlan->flags & VXLAN_F_L3MISS)) {
 			union vxlan_addr ipa = {
 				.sin.sin_addr.s_addr = pip->daddr,
-				.sa.sa_family = AF_INET,
+				.sin.sin_family = AF_INET,
 			};
 
 			vxlan_ip_miss(dev, &ipa);
@@ -1439,7 +1439,7 @@ static bool route_shortcircuit(struct net_device *dev, struct sk_buff *skb)
 		if (!n && (vxlan->flags & VXLAN_F_L3MISS)) {
 			union vxlan_addr ipa = {
 				.sin6.sin6_addr = pip6->daddr,
-				.sa.sa_family = AF_INET6,
+				.sin6.sin6_family = AF_INET6,
 			};
 
 			vxlan_ip_miss(dev, &ipa);
-- 
1.9.1

