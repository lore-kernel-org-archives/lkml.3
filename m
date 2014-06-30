Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755874AbaF3QjF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2014 12:39:05 -0400
Received: from ns.gsystem.sk ([62.176.172.50]:44073 "EHLO ns.gsystem.sk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754201AbaF3Qiz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2014 12:38:55 -0400
From: Ondrej Zary <linux@rainbow-software.org>
To: Samuel Chessman <chessman@tux.org>
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 09/11] tlan: Don't disable internal PHY on cards that use it in 10 Mbps mode
Date: Mon, 30 Jun 2014 18:38:35 +0200
Message-Id: <1404146317-3094-10-git-send-email-linux@rainbow-software.org>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1404146317-3094-1-git-send-email-linux@rainbow-software.org>
References: <1404146317-3094-1-git-send-email-linux@rainbow-software.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In tlan_reset_adapter, we disable internal PHY when an external one is used.
On cards which use internal PHY in 10 Mbps mode, we enable it later when
setting 10 Mbps mode but it does not really work (PHY fails to reset).
Leave it enabled instead.

Signed-off-by: Ondrej Zary <linux@rainbow-software.org>
---
 drivers/net/ethernet/ti/tlan.c |    8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/ti/tlan.c b/drivers/net/ethernet/ti/tlan.c
index 1f878b9..bb805c2 100644
--- a/drivers/net/ethernet/ti/tlan.c
+++ b/drivers/net/ethernet/ti/tlan.c
@@ -2238,7 +2238,9 @@ tlan_reset_adapter(struct net_device *dev)
 		}
 	}
 
-	if (priv->phy_num == 0)
+	/* don't power down internal PHY if we're going to use it */
+	if (priv->phy_num == 0 ||
+	   (priv->adapter->flags & TLAN_ADAPTER_USE_INTERN_10))
 		data |= TLAN_NET_CFG_PHY_EN;
 	tlan_dio_write16(dev->base_addr, TLAN_NET_CONFIG, (u16) data);
 
@@ -2689,7 +2691,6 @@ static void tlan_phy_finish_auto_neg(struct net_device *dev)
 	struct tlan_priv	*priv = netdev_priv(dev);
 	u16		an_adv;
 	u16		an_lpa;
-	u16		data;
 	u16		mode;
 	u16		phy;
 	u16		status;
@@ -2722,9 +2723,6 @@ static void tlan_phy_finish_auto_neg(struct net_device *dev)
 	    (priv->adapter->flags & TLAN_ADAPTER_USE_INTERN_10) &&
 	    (priv->phy_num != 0)) {
 		priv->phy_num = 0;
-		data = TLAN_NET_CFG_1FRAG | TLAN_NET_CFG_1CHAN
-			| TLAN_NET_CFG_PHY_EN;
-		tlan_dio_write16(dev->base_addr, TLAN_NET_CONFIG, data);
 		tlan_set_timer(dev, (400*HZ/1000), TLAN_TIMER_PHY_PDOWN);
 		return;
 	}
-- 
Ondrej Zary

