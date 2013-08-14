Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759911Ab3HNO07 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Aug 2013 10:26:59 -0400
Received: from mail3-relais-sop.national.inria.fr ([192.134.164.104]:34655
	"EHLO mail3-relais-sop.national.inria.fr" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756525Ab3HNO05 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Aug 2013 10:26:57 -0400
X-IronPort-AV: E=Sophos;i="4.89,877,1367964000"; 
   d="scan'208";a="23936229"
From: Julia Lawall <Julia.Lawall@lip6.fr>
To: Francois Romieu <romieu@fr.zoreil.com>, roszenrami@gmail.com,
        dshwatrz@gmail.com
Cc: kernel-janitors@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, grant.likely@linaro.org,
        rob.herring@calxeda.com
Subject: [PATCH] drivers/net/ethernet/via/via-velocity.c: update napi implementation
Date: Wed, 14 Aug 2013 16:26:53 +0200
Message-Id: <1376490413-12067-1-git-send-email-Julia.Lawall@lip6.fr>
X-Mailer: git-send-email 1.7.8.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <Julia.Lawall@lip6.fr>

Drivers supporting NAPI should use a NAPI-specific function for receiving
packets.  Hence netif_rx is changed to netif_receive_skb.

Furthermore netif_napi_del should be used in the probe and remove function
to clean up the NAPI resource information.

Thanks to Francois Romieu, David Shwatrz and Rami Rosen for their help on
this patch.

Signed-off-by: Julia Lawall <Julia.Lawall@lip6.fr>

---
I still don't understand the reason for choosing netif_receive_skb,
specifically.  This patch is not tested.

 drivers/net/ethernet/via/via-velocity.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/via/via-velocity.c b/drivers/net/ethernet/via/via-velocity.c
index ef77631..d022bf9 100644
--- a/drivers/net/ethernet/via/via-velocity.c
+++ b/drivers/net/ethernet/via/via-velocity.c
@@ -2100,7 +2100,7 @@ static int velocity_receive_frame(struct velocity_info *vptr, int idx)
 
 		__vlan_hwaccel_put_tag(skb, htons(ETH_P_8021Q), vid);
 	}
-	netif_rx(skb);
+	netif_receive_skb(skb);
 
 	stats->rx_bytes += pkt_len;
 	stats->rx_packets++;
@@ -2904,6 +2904,7 @@ out:
 	return ret;
 
 err_iounmap:
+	netif_napi_del(&vptr->napi);
 	iounmap(regs);
 err_free_dev:
 	free_netdev(netdev);
@@ -2924,6 +2925,7 @@ static int velocity_remove(struct device *dev)
 	struct velocity_info *vptr = netdev_priv(netdev);
 
 	unregister_netdev(netdev);
+	netif_napi_del(&vptr->napi);
 	iounmap(vptr->mac_regs);
 	free_netdev(netdev);
 	velocity_nics--;

