Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756772AbaDBALa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Apr 2014 20:11:30 -0400
Received: from h1446028.stratoserver.net ([85.214.92.142]:39494 "EHLO
	mail.ahsoftware.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754481AbaDAX5L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Apr 2014 19:57:11 -0400
From: Alexander Holler <holler@ahsoftware.de>
To: linux-kernel@vger.kernel.org
Cc: netdev@vger.kernel.org, Florian Fainelli <f.fainelli@gmail.com>,
        Michal Simek <michal.simek@xilinx.com>,
        Alexander Holler <holler@ahsoftware.de>, <stable@vger.kernel.org>
Subject: [PATCH regression] net: phy: fix initialization (config_init) for Marvel 88E1116R PHYs
Date: Wed,  2 Apr 2014 01:55:59 +0200
Message-Id: <1396396559-6971-1-git-send-email-holler@ahsoftware.de>
X-Mailer: git-send-email 1.8.3.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit 7cd1463664c2a15721ff4ccfb61d4d970815cb3d (introduced with 3.14)
changed the initialization of the mv643xx_eth driver to use phy_init_hw()
to reset the PHY. Unfortunately the initialization for the 88E1116R PHY
was broken such, that it used mdelay() instead of really waiting for a
reset to finish.

The effect was that the ethernet on my Kirkwood 88F6281 based device didn't
come up anymore (no carrier).

Fix this by waiting for a reset to finish before proceeding further.

Signed-off-by: Alexander Holler <holler@ahsoftware.de>

Cc: Michal Simek <michal.simek@xilinx.com>
Cc: Florian Fainelli <f.fainelli@gmail.com>
Cc: <stable@vger.kernel.org>
---
 drivers/net/phy/marvell.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/net/phy/marvell.c b/drivers/net/phy/marvell.c
index bd37e45..5b84808 100644
--- a/drivers/net/phy/marvell.c
+++ b/drivers/net/phy/marvell.c
@@ -396,7 +396,9 @@ static int m88e1116r_config_init(struct phy_device *phydev)
 	if (err < 0)
 		return err;
 
-	mdelay(500);
+	do
+		temp = phy_read(phydev, MII_BMCR);
+	while (temp & BMCR_RESET);
 
 	err = phy_write(phydev, MII_MARVELL_PHY_PAGE, 0);
 	if (err < 0)
@@ -429,7 +431,9 @@ static int m88e1116r_config_init(struct phy_device *phydev)
 	if (err < 0)
 		return err;
 
-	mdelay(500);
+	do
+		temp = phy_read(phydev, MII_BMCR);
+	while (temp & BMCR_RESET);
 
 	return 0;
 }
-- 
1.8.3.1

