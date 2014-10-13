Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754356AbaJMC6M (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Oct 2014 22:58:12 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:45646 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753275AbaJMC0M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Oct 2014 22:26:12 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Gerhard Stenzel <gerhard.stenzel@de.ibm.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 3.14 12/37] vxlan: fix incorrect initializer in union vxlan_addr
Date: Mon, 13 Oct 2014 04:24:09 +0200
Message-Id: <20141013022400.814990201@linuxfoundation.org>
X-Mailer: git-send-email 2.1.2
In-Reply-To: <20141013022400.286360067@linuxfoundation.org>
References: <20141013022400.286360067@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.14-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/vxlan.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/drivers/net/vxlan.c
+++ b/drivers/net/vxlan.c
@@ -1334,7 +1334,7 @@ static int arp_reduce(struct net_device
 	} else if (vxlan->flags & VXLAN_F_L3MISS) {
 		union vxlan_addr ipa = {
 			.sin.sin_addr.s_addr = tip,
-			.sa.sa_family = AF_INET,
+			.sin.sin_family = AF_INET,
 		};
 
 		vxlan_ip_miss(dev, &ipa);
@@ -1495,7 +1495,7 @@ static int neigh_reduce(struct net_devic
 	} else if (vxlan->flags & VXLAN_F_L3MISS) {
 		union vxlan_addr ipa = {
 			.sin6.sin6_addr = msg->target,
-			.sa.sa_family = AF_INET6,
+			.sin6.sin6_family = AF_INET6,
 		};
 
 		vxlan_ip_miss(dev, &ipa);
@@ -1528,7 +1528,7 @@ static bool route_shortcircuit(struct ne
 		if (!n && (vxlan->flags & VXLAN_F_L3MISS)) {
 			union vxlan_addr ipa = {
 				.sin.sin_addr.s_addr = pip->daddr,
-				.sa.sa_family = AF_INET,
+				.sin.sin_family = AF_INET,
 			};
 
 			vxlan_ip_miss(dev, &ipa);
@@ -1549,7 +1549,7 @@ static bool route_shortcircuit(struct ne
 		if (!n && (vxlan->flags & VXLAN_F_L3MISS)) {
 			union vxlan_addr ipa = {
 				.sin6.sin6_addr = pip6->daddr,
-				.sa.sa_family = AF_INET6,
+				.sin6.sin6_family = AF_INET6,
 			};
 
 			vxlan_ip_miss(dev, &ipa);


