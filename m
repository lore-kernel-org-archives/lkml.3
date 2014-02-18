Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755217AbaBRMRJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Feb 2014 07:17:09 -0500
Received: from 82-68-191-81.dsl.posilan.com ([82.68.191.81]:43417 "EHLO
	rainbowdash.ducie.codethink.co.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754298AbaBRMRH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Feb 2014 07:17:07 -0500
From: Ben Dooks <ben.dooks@codethink.co.uk>
To: grant.likely@linaro.org
Cc: linux-kernel@lists.codethink.co.uk, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        linux-sh@vger.kernel.org, sergei.shtylyov@cogentembedded.com,
        Ben Dooks <ben.dooks@codethink.co.uk>
Subject: [PATCH v2] of_mdio: fix phy interrupt passing
Date: Tue, 18 Feb 2014 12:16:58 +0000
Message-Id: <1392725818-558-1-git-send-email-ben.dooks@codethink.co.uk>
X-Mailer: git-send-email 1.8.5.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The of_mdiobus_register_phy() is not setting phy->irq thus causing
some drivers to incorrectly assume that the PHY does not have an
IRQ associated with it. Not only do some drivers report no IRQ
they do not install an interrupt handler for the PHY.

Simplify the code setting irq and set the phy->irq at the same
time so that we cover the following issues, which should cover
all the cases the code will find:

- Set phy->irq if node has irq property and mdio->irq is NULL
- Set phy->irq if node has no irq and mdio->irq is not NULL
- Leave phy->irq as PHY_POLL default if none of the above

This fixes the issue:
 net eth0: attached PHY 1 (IRQ -1) to driver Micrel KSZ8041RNLI

to the correct:
 net eth0: attached PHY 1 (IRQ 416) to driver Micrel KSZ8041RNLI

Signed-off-by: Ben Dooks <ben.dooks@codethink.co.uk>

---
Since v1:
	- Updated phy->irq setting code
	- Deal with issue if mdio->irq array NULL

Notes:

It was discussed if this should be two patches, but we end up
making enough changes in #2 the same area as #1 means that we
basically rewrite #1 in #2. So keep it as 1 patch.
---
 drivers/of/of_mdio.c | 16 +++++++++-------
 1 file changed, 9 insertions(+), 7 deletions(-)

diff --git a/drivers/of/of_mdio.c b/drivers/of/of_mdio.c
index 875b7b6..46d95fc 100644
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
@@ -54,12 +54,14 @@ static int of_mdiobus_register_phy(struct mii_bus *mdio, struct device_node *chi
 	if (!phy || IS_ERR(phy))
 		return 1;
 
-	if (mdio->irq) {
-		prev_irq = mdio->irq[addr];
-		mdio->irq[addr] =
-			irq_of_parse_and_map(child, 0);
-		if (!mdio->irq[addr])
-			mdio->irq[addr] = prev_irq;
+	rc = irq_of_parse_and_map(child, 0);
+	if (rc > 0) {
+		phy->irq = rc;
+		if (mdio->irq)
+			mdio->irq[addr] = rc;
+	} else {
+		if (mdio->irq)
+			phy->irq = mdio->irq[addr];
 	}
 
 	/* Associate the OF node with the device structure so it
-- 
1.8.5.3

