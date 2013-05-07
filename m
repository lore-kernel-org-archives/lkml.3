Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756356Ab3EGKM7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 May 2013 06:12:59 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:39935 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754865Ab3EGKM6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 May 2013 06:12:58 -0400
From: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
To: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
Cc: Grant Likely <grant.likely@linaro.org>,
        Rob Herring <rob.herring@calxeda.com>,
        David Miller <davem@davemloft.net>,
        devicetree-discuss@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
Subject: [PATCH] net: of_mdio: fix behavior on missing phy device
Date: Tue,  7 May 2013 11:49:31 +0200
Message-Id: <1367920171-20264-1-git-send-email-sebastian.hesselbarth@gmail.com>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

of_mdiobus_register creates a phy_device even if get_phy_device failed
to create it previously. This causes indefinite polling on non-existent
PHYs. This fix makes of_mdio_register rely on get_phy_device to
properly create the device or fail otherwise.

Signed-off-by: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
---
Cc: Grant Likely <grant.likely@linaro.org>
Cc: Rob Herring <rob.herring@calxeda.com>
Cc: David Miller <davem@davemloft.net>
Cc: devicetree-discuss@lists.ozlabs.org
Cc: linux-kernel@vger.kernel.org
Cc: netdev@vger.kernel.org
---
 drivers/of/of_mdio.c |   11 ++++-------
 1 file changed, 4 insertions(+), 7 deletions(-)

diff --git a/drivers/of/of_mdio.c b/drivers/of/of_mdio.c
index 23049ae..d5a57a9 100644
--- a/drivers/of/of_mdio.c
+++ b/drivers/of/of_mdio.c
@@ -84,13 +84,10 @@ int of_mdiobus_register(struct mii_bus *mdio, struct device_node *np)
 		phy = get_phy_device(mdio, addr, is_c45);
 
 		if (!phy || IS_ERR(phy)) {
-			phy = phy_device_create(mdio, addr, 0, false, NULL);
-			if (!phy || IS_ERR(phy)) {
-				dev_err(&mdio->dev,
-					"error creating PHY at address %i\n",
-					addr);
-				continue;
-			}
+			dev_err(&mdio->dev,
+				"cannot get PHY at address %i\n",
+				addr);
+			continue;
 		}
 
 		/* Associate the OF node with the device structure so it
-- 
1.7.10.4

