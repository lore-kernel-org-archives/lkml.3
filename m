Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932359Ab3GaP0Y (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Jul 2013 11:26:24 -0400
Received: from usmamail.tilera.com ([12.216.194.151]:31239 "EHLO
	USMAMAIL.TILERA.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753117Ab3GaPVm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Jul 2013 11:21:42 -0400
Message-ID: <689af33d3dd10d94ab71d177182055680a5a48a0.1375283105.git.cmetcalf@tilera.com>
In-Reply-To: <cover.1375283104.git.cmetcalf@tilera.com>
References: <cover.1374609948.git.cmetcalf@tilera.com>
	<cover.1375283104.git.cmetcalf@tilera.com>
From: Chris Metcalf <cmetcalf@tilera.com>
Date: Wed, 31 Jul 2013 11:05:04 -0400
Subject: [PATCH 02/12] tile: avoid bug in tilepro net driver built with old hypervisor
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
index 63fd9cc..cb67df7 100644
--- a/drivers/net/ethernet/tile/tilepro.c
+++ b/drivers/net/ethernet/tile/tilepro.c
@@ -1933,7 +1933,7 @@ static int tile_net_tx(struct sk_buff *skb, struct net_device *dev)
 
 	unsigned int csum_start = skb_checksum_start_offset(skb);
 
-	lepp_frag_t frags[LEPP_MAX_FRAGS];
+	lepp_frag_t frags[1 + MAX_SKB_FRAGS];
 
 	unsigned int num_frags;
 
@@ -1948,7 +1948,7 @@ static int tile_net_tx(struct sk_buff *skb, struct net_device *dev)
 	unsigned int cmd_head, cmd_tail, cmd_next;
 	unsigned int comp_tail;
 
-	lepp_cmd_t cmds[LEPP_MAX_FRAGS];
+	lepp_cmd_t cmds[1 + MAX_SKB_FRAGS];
 
 
 	/*
@@ -2342,8 +2342,9 @@ static void tile_net_setup(struct net_device *dev)
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

