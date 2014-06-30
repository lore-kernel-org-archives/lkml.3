Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755176AbaF3Qi6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2014 12:38:58 -0400
Received: from ns.gsystem.sk ([62.176.172.50]:44071 "EHLO ns.gsystem.sk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753948AbaF3Qiz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2014 12:38:55 -0400
From: Ondrej Zary <linux@rainbow-software.org>
To: Samuel Chessman <chessman@tux.org>
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 08/11] tlan: Add PHY reset timeout
Date: Mon, 30 Jun 2014 18:38:34 +0200
Message-Id: <1404146317-3094-9-git-send-email-linux@rainbow-software.org>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1404146317-3094-1-git-send-email-linux@rainbow-software.org>
References: <1404146317-3094-1-git-send-email-linux@rainbow-software.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add a timeout to prevent infinite loop waiting for PHY to reset.

Signed-off-by: Ondrej Zary <linux@rainbow-software.org>
---
 drivers/net/ethernet/ti/tlan.c |    9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/ti/tlan.c b/drivers/net/ethernet/ti/tlan.c
index 3e6a80b..1f878b9 100644
--- a/drivers/net/ethernet/ti/tlan.c
+++ b/drivers/net/ethernet/ti/tlan.c
@@ -2569,6 +2569,7 @@ static void tlan_phy_reset(struct net_device *dev)
 	struct tlan_priv	*priv = netdev_priv(dev);
 	u16		phy;
 	u16		value;
+	unsigned long timeout = jiffies + HZ;
 
 	phy = priv->phy[priv->phy_num];
 
@@ -2576,9 +2577,13 @@ static void tlan_phy_reset(struct net_device *dev)
 	tlan_mii_sync(dev->base_addr);
 	value = MII_GC_LOOPBK | MII_GC_RESET;
 	tlan_mii_write_reg(dev, phy, MII_GEN_CTL, value);
-	tlan_mii_read_reg(dev, phy, MII_GEN_CTL, &value);
-	while (value & MII_GC_RESET)
+	do {
 		tlan_mii_read_reg(dev, phy, MII_GEN_CTL, &value);
+		if (time_after(jiffies, timeout)) {
+			netdev_err(dev, "PHY reset timeout\n");
+			return;
+		}
+	} while (value & MII_GC_RESET);
 
 	/* Wait for 500 ms and initialize.
 	 * I don't remember why I wait this long.
-- 
Ondrej Zary

