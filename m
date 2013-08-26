Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756721Ab3HZMnJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Aug 2013 08:43:09 -0400
Received: from 5.mo3.mail-out.ovh.net ([87.98.178.36]:47054 "EHLO
	mo3.mail-out.ovh.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751657Ab3HZMnI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Aug 2013 08:43:08 -0400
From: Boris BREZILLON <b.brezillon@overkiz.com>
To: Rob Herring <rob.herring@calxeda.com>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Ian Campbell <ian.campbell@citrix.com>,
        Russell King <linux@arm.linux.org.uk>,
        Nicolas Ferre <nicolas.ferre@atmel.com>
Cc: devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        Boris BREZILLON <b.brezillon@overkiz.com>
X-Ovh-Mailout: 178.32.228.3 (mo3.mail-out.ovh.net)
Subject: [PATCH v2 1/2] net/cadence/macb: add support for dt phy definition
Date: Mon, 26 Aug 2013 14:34:54 +0200
Message-Id: <1377520494-21848-1-git-send-email-b.brezillon@overkiz.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1377520431-21807-1-git-send-email-b.brezillon@overkiz.com>
References: <1377520431-21807-1-git-send-email-b.brezillon@overkiz.com>
X-Ovh-Tracer-Id: 5449918499279239392
X-Ovh-Remote: 80.245.18.66 ()
X-Ovh-Local: 213.186.33.20 (ns0.ovh.net)
X-OVH-SPAMSTATE: OK
X-OVH-SPAMSCORE: -100
X-OVH-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeeikedrhedvucetufdoteggodetrfcurfhrohhfihhlvgemucfqggfjnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
X-Spam-Check: DONE|U 0.5/N
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: -100
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeeikedrhedvucetufdoteggodetrfcurfhrohhfihhlvgemucfqggfjnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The macb driver only handle PHY description through platform_data
(macb_platform_data).
Thus, when using dt you cannot define phy properties like phy address or
phy irq pin.

This patch makes use of the of_mdiobus_register to add support for
phy device definition using dt.
A fallback to the autoscan procedure is added in case there is no phy
devices defined in dt.

Signed-off-by: Boris BREZILLON <b.brezillon@overkiz.com>
---
 drivers/net/ethernet/cadence/macb.c |   47 +++++++++++++++++++++++++++--------
 1 file changed, 37 insertions(+), 10 deletions(-)

diff --git a/drivers/net/ethernet/cadence/macb.c b/drivers/net/ethernet/cadence/macb.c
index e866608..7660c45 100644
--- a/drivers/net/ethernet/cadence/macb.c
+++ b/drivers/net/ethernet/cadence/macb.c
@@ -27,6 +27,7 @@
 #include <linux/phy.h>
 #include <linux/of.h>
 #include <linux/of_device.h>
+#include <linux/of_mdio.h>
 #include <linux/of_net.h>
 #include <linux/pinctrl/consumer.h>
 
@@ -275,7 +276,7 @@ static int macb_mii_probe(struct net_device *dev)
 	phydev = phy_find_first(bp->mii_bus);
 	if (!phydev) {
 		netdev_err(dev, "no PHY found\n");
-		return -1;
+		return -ENXIO;
 	}
 
 	pdata = dev_get_platdata(&bp->pdev->dev);
@@ -314,6 +315,7 @@ static int macb_mii_probe(struct net_device *dev)
 int macb_mii_init(struct macb *bp)
 {
 	struct macb_platform_data *pdata;
+	struct device_node *np;
 	int err = -ENXIO, i;
 
 	/* Enable management port */
@@ -335,26 +337,51 @@ int macb_mii_init(struct macb *bp)
 	bp->mii_bus->parent = &bp->dev->dev;
 	pdata = bp->pdev->dev.platform_data;
 
-	if (pdata)
-		bp->mii_bus->phy_mask = pdata->phy_mask;
-
 	bp->mii_bus->irq = kmalloc(sizeof(int)*PHY_MAX_ADDR, GFP_KERNEL);
 	if (!bp->mii_bus->irq) {
 		err = -ENOMEM;
 		goto err_out_free_mdiobus;
 	}
 
-	for (i = 0; i < PHY_MAX_ADDR; i++)
-		bp->mii_bus->irq[i] = PHY_POLL;
-
 	dev_set_drvdata(&bp->dev->dev, bp->mii_bus);
 
-	if (mdiobus_register(bp->mii_bus))
+	np = bp->pdev->dev.of_node;
+	if (np) {
+		/* try dt phy registration */
+		err = of_mdiobus_register(bp->mii_bus, np);
+
+		/* fallback to standard phy registration if no phy were
+		   found during dt phy registration */
+		if (!err && !phy_find_first(bp->mii_bus)) {
+			for (i = 0; i < PHY_MAX_ADDR; i++) {
+				struct phy_device *phydev;
+
+				phydev = mdiobus_scan(bp->mii_bus, i);
+				if (IS_ERR(phydev)) {
+					err = PTR_ERR(phydev);
+					break;
+				}
+			}
+
+			if (err)
+				goto err_out_unregister_bus;
+		}
+	} else {
+		for (i = 0; i < PHY_MAX_ADDR; i++)
+			bp->mii_bus->irq[i] = PHY_POLL;
+
+		if (pdata)
+			bp->mii_bus->phy_mask = pdata->phy_mask;
+
+		err = mdiobus_register(bp->mii_bus);
+	}
+
+	if (err)
 		goto err_out_free_mdio_irq;
 
-	if (macb_mii_probe(bp->dev) != 0) {
+	err = macb_mii_probe(bp->dev);
+	if (err)
 		goto err_out_unregister_bus;
-	}
 
 	return 0;
 
-- 
1.7.9.5

