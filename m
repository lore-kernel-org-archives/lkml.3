Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752931AbaBQQgP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Feb 2014 11:36:15 -0500
Received: from 82-68-191-81.dsl.posilan.com ([82.68.191.81]:60517 "EHLO
	rainbowdash.ducie.codethink.co.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751445AbaBQQgN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Feb 2014 11:36:13 -0500
From: Ben Dooks <ben.dooks@codethink.co.uk>
To: grant.likely@linaro.org
Cc: linux-kernel@lists.codethink.co.uk, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        linux-sh@vger.kernel.org, sergei.shtylyov@cogentembedded.com,
        Ben Dooks <ben.dooks@codethink.co.uk>
Subject: [PATCH] of_mdio: fix phy interrupt passing
Date: Mon, 17 Feb 2014 16:29:40 +0000
Message-Id: <1392654580-3706-1-git-send-email-ben.dooks@codethink.co.uk>
X-Mailer: git-send-email 1.8.5.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The of_mdiobus_register_phy() is not setting phy->irq this causing
some drivers to incorrectly assume that the PHY does not have an
IRQ associated with it or install an interrupt handler for the
PHY.

Simplify the code setting irq and set the phy->irq at the same
time so that the case if mdio->irq is not NULL is easier to read.

This fixes the issue:
 net eth0: attached PHY 1 (IRQ -1) to driver Micrel KSZ8041RNLI

to the correct:
 net eth0: attached PHY 1 (IRQ 416) to driver Micrel KSZ8041RNLI

Signed-off-by: Ben Dooks <ben.dooks@codethink.co.uk>
---
 drivers/of/of_mdio.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/of/of_mdio.c b/drivers/of/of_mdio.c
index 875b7b6..7b3e7b0 100644
--- a/drivers/of/of_mdio.c
+++ b/drivers/of/of_mdio.c
@@ -44,7 +44,7 @@ static int of_mdiobus_register_phy(struct mii_bus *mdio, struct device_node *chi
 {
 	struct phy_device *phy;
 	bool is_c45;
-	int rc, prev_irq;
+	int rc;
 	u32 max_speed = 0;
 
 	is_c45 = of_device_is_compatible(child,
@@ -55,11 +55,11 @@ static int of_mdiobus_register_phy(struct mii_bus *mdio, struct device_node *chi
 		return 1;
 
 	if (mdio->irq) {
-		prev_irq = mdio->irq[addr];
-		mdio->irq[addr] =
-			irq_of_parse_and_map(child, 0);
-		if (!mdio->irq[addr])
-			mdio->irq[addr] = prev_irq;
+		rc = irq_of_parse_and_map(child, 0);
+		if (rc > 0) {
+			mdio->irq[addr] = rc;
+			phy->irq = rc;
+		}
 	}
 
 	/* Associate the OF node with the device structure so it
-- 
1.8.5.3

