Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934352Ab3GWUVj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jul 2013 16:21:39 -0400
Received: from usmamail.tilera.com ([12.216.194.151]:23550 "EHLO
	USMAMAIL.TILERA.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934311Ab3GWUVg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jul 2013 16:21:36 -0400
Message-ID: <4d602fd8ffd49c45009124507eb08d4169e782cb.1374609948.git.cmetcalf@tilera.com>
In-Reply-To: <cover.1374609948.git.cmetcalf@tilera.com>
References: <cover.1374609948.git.cmetcalf@tilera.com>
From: Chris Metcalf <cmetcalf@tilera.com>
Date: Tue, 23 Jul 2013 16:05:48 -0400
Subject: [PATCH 03/13] tile: avoid bug in tilepro net driver built with old hypervisor
To: <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Building against headers from an older Tilera hypervisor can cause
the frags[] array to be overrun.  Don't enable TSO in that case.

Signed-off-by: Chris Metcalf <cmetcalf@tilera.com>
---
 drivers/net/ethernet/tile/tilepro.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/tile/tilepro.c b/drivers/net/ethernet/tile/tilepro.c
index 84a179e..dd3a39c 100644
--- a/drivers/net/ethernet/tile/tilepro.c
+++ b/drivers/net/ethernet/tile/tilepro.c
@@ -1927,7 +1927,7 @@ static int tile_net_tx(struct sk_buff *skb, struct net_device *dev)
 
 	unsigned int csum_start = skb_checksum_start_offset(skb);
 
-	lepp_frag_t frags[LEPP_MAX_FRAGS];
+	lepp_frag_t frags[1 + MAX_SKB_FRAGS];
 
 	unsigned int num_frags;
 
@@ -1942,7 +1942,7 @@ static int tile_net_tx(struct sk_buff *skb, struct net_device *dev)
 	unsigned int cmd_head, cmd_tail, cmd_next;
 	unsigned int comp_tail;
 
-	lepp_cmd_t cmds[LEPP_MAX_FRAGS];
+	lepp_cmd_t cmds[1 + MAX_SKB_FRAGS];
 
 
 	/*
@@ -2309,8 +2309,9 @@ static void tile_net_setup(struct net_device *dev)
 	/* We support scatter/gather. */
 	dev->features |= NETIF_F_SG;
 
-	/* We support TSO. */
-	dev->features |= NETIF_F_TSO;
+	/* We support TSO iff the HV supports sufficient frags. */
+	if (LEPP_MAX_FRAGS >= 1 + MAX_SKB_FRAGS)
+		dev->features |= NETIF_F_TSO;
 
 #ifdef TILE_NET_GSO
 	/* We support GSO. */
-- 
1.8.3.1

