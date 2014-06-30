Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756465AbaF3Qmk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2014 12:42:40 -0400
Received: from ns.gsystem.sk ([62.176.172.50]:44065 "EHLO ns.gsystem.sk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754168AbaF3Qiz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2014 12:38:55 -0400
From: Ondrej Zary <linux@rainbow-software.org>
To: Samuel Chessman <chessman@tux.org>
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 05/11] tlan: Restart autonegotiation on link loss
Date: Mon, 30 Jun 2014 18:38:31 +0200
Message-Id: <1404146317-3094-6-git-send-email-linux@rainbow-software.org>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1404146317-3094-1-git-send-email-linux@rainbow-software.org>
References: <1404146317-3094-1-git-send-email-linux@rainbow-software.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When link is lost on a card which uses internal PHY for 10 Mbit speeds,
restart autonegotiation to allow switching between 10 and 100 Mbps speeds.

Signed-off-by: Ondrej Zary <linux@rainbow-software.org>
---
 drivers/net/ethernet/ti/tlan.c |   16 ++++++++++++++++
 1 file changed, 16 insertions(+)

diff --git a/drivers/net/ethernet/ti/tlan.c b/drivers/net/ethernet/ti/tlan.c
index 31d4a96..1b64ddc 100644
--- a/drivers/net/ethernet/ti/tlan.c
+++ b/drivers/net/ethernet/ti/tlan.c
@@ -2721,6 +2721,7 @@ static void tlan_phy_finish_auto_neg(struct net_device *dev)
 	else if (!(mode & 0x0080) && (mode & 0x0040))
 		priv->tlan_full_duplex = true;
 
+	/* switch to internal PHY for 10 Mbps */
 	if ((!(mode & 0x0180)) &&
 	    (priv->adapter->flags & TLAN_ADAPTER_USE_INTERN_10) &&
 	    (priv->phy_num != 0)) {
@@ -2788,6 +2789,21 @@ static void tlan_phy_monitor(unsigned long data)
 			       dev->name);
 			tlan_dio_write8(dev->base_addr, TLAN_LED_REG, 0);
 			netif_carrier_off(dev);
+			if (priv->adapter->flags & TLAN_ADAPTER_USE_INTERN_10) {
+				/* power down internal PHY */
+				u16 data = MII_GC_PDOWN | MII_GC_LOOPBK |
+					   MII_GC_ISOLATE;
+
+				tlan_mii_sync(dev->base_addr);
+				tlan_mii_write_reg(dev, priv->phy[0],
+						   MII_GEN_CTL, data);
+				/* set to external PHY */
+				priv->phy_num = 1;
+				/* restart autonegotiation */
+				tlan_set_timer(dev, 4 * HZ / 10,
+					       TLAN_TIMER_PHY_PDOWN);
+				return;
+			}
 		}
 	}
 
-- 
Ondrej Zary

