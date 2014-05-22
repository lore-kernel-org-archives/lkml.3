Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753358AbaEVQye (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 May 2014 12:54:34 -0400
Received: from mail-ig0-f179.google.com ([209.85.213.179]:54128 "EHLO
	mail-ig0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752314AbaEVQsS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 May 2014 12:48:18 -0400
From: Florian Fainelli <f.fainelli@gmail.com>
To: netdev@vger.kernel.org
Cc: davem@davemloft.net, Florian Fainelli <f.fainelli@gmail.com>,
        Pantelis Antoniou <pantelis.antoniou@gmail.com>,
        Vitaly Bordug <vbordug@ru.mvista.com>, Li Yang <leoli@freescale.com>,
        Grant Likely <grant.likely@linaro.org>,
        Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Aida Mynzhasova <aida.mynzhasova@skitlab.ru>,
        Richard Cochran <richardcochran@gmail.com>,
        Claudiu Manoil <claudiu.manoil@freescale.com>,
        devicetree@vger.kernel.org (open list:OPEN FIRMWARE AND...),
        linux-kernel@vger.kernel.org (open list),
        linuxppc-dev@lists.ozlabs.org (open list:LINUX FOR POWERPC...)
Subject: [PATCH net-next v2 3/9] net: bcmgenet: use the new fixed PHY helpers
Date: Thu, 22 May 2014 09:47:45 -0700
Message-Id: <1400777271-32199-4-git-send-email-f.fainelli@gmail.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1400777271-32199-1-git-send-email-f.fainelli@gmail.com>
References: <1400777271-32199-1-git-send-email-f.fainelli@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

of_phy_connect_fixed_link() is becoming obsolete, and also required
platform code to register the fixed PHYs at the specified addresses for
those to be usable. Get rid of it and use the new of_phy_is_fixed_link()
plus of_phy_register_fixed_link() helpers to transition over the new
scheme.

Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
---
No changes in v2

 drivers/net/ethernet/broadcom/genet/bcmmii.c | 21 +++++++++++++--------
 1 file changed, 13 insertions(+), 8 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/genet/bcmmii.c b/drivers/net/ethernet/broadcom/genet/bcmmii.c
index 4608673beaff..add8d8596084 100644
--- a/drivers/net/ethernet/broadcom/genet/bcmmii.c
+++ b/drivers/net/ethernet/broadcom/genet/bcmmii.c
@@ -298,6 +298,7 @@ int bcmgenet_mii_config(struct net_device *dev)
 static int bcmgenet_mii_probe(struct net_device *dev)
 {
 	struct bcmgenet_priv *priv = netdev_priv(dev);
+	struct device_node *dn = priv->pdev->dev.of_node;
 	struct phy_device *phydev;
 	unsigned int phy_flags;
 	int ret;
@@ -307,15 +308,19 @@ static int bcmgenet_mii_probe(struct net_device *dev)
 		return 0;
 	}
 
-	if (priv->phy_dn)
-		phydev = of_phy_connect(dev, priv->phy_dn,
-					bcmgenet_mii_setup, 0,
-					priv->phy_interface);
-	else
-		phydev = of_phy_connect_fixed_link(dev,
-					bcmgenet_mii_setup,
-					priv->phy_interface);
+	/* In the case of a fixed PHY, the DT node associated
+	 * to the PHY is the Ethernet MAC DT node.
+	 */
+	if (of_phy_is_fixed_link(dn)) {
+		ret = of_phy_register_fixed_link(dn);
+		if (ret)
+			return ret;
+
+		priv->phy_dn = dn;
+	}
 
+	phydev = of_phy_connect(dev, priv->phy_dn, bcmgenet_mii_setup, 0,
+				priv->phy_interface);
 	if (!phydev) {
 		pr_err("could not attach to PHY\n");
 		return -ENODEV;
-- 
1.9.1

