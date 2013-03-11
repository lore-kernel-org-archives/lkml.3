Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753491Ab3CKI4w (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Mar 2013 04:56:52 -0400
Received: from mail1.bemta7.messagelabs.com ([216.82.254.102]:50530 "EHLO
	mail1.bemta7.messagelabs.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752679Ab3CKI4t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Mar 2013 04:56:49 -0400
X-Env-Sender: Hector.Palacios@digi.com
X-Msg-Ref: server-5.tower-201.messagelabs.com!1362991819!9298531!2
X-Originating-IP: [66.77.174.13]
X-StarScan-Received: 
X-StarScan-Version: 6.8.6; banners=-,-,-
X-VirusChecked: Checked
From: Hector Palacios <hector.palacios@digi.com>
To: <netdev@vger.kernel.org>
CC: <linux-kernel@vger.kernel.org>, <marex@denx.de>, <davem@davemloft.net>,
        Hector Palacios <hector.palacios@digi.com>
Subject: [PATCH 2/2] phy/micrel: move flag handling to function for common use
Date: Mon, 11 Mar 2013 09:50:03 +0100
Message-ID: <1362991803-4610-2-git-send-email-hector.palacios@digi.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1362991803-4610-1-git-send-email-hector.palacios@digi.com>
References: <1362991803-4610-1-git-send-email-hector.palacios@digi.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The flag MICREL_PHY_50MHZ_CLK is not of exclusive use of KSZ8051
model. At least KSZ8021 and KSZ8031 models also use it.
This patch moves the handling of this and future flags to a
separate function so that the different PHY models can call it on
their init function, if needed.

Signed-off-by: Hector Palacios <hector.palacios@digi.com>
---
 drivers/net/phy/micrel.c |   27 ++++++++++++++++++---------
 1 file changed, 18 insertions(+), 9 deletions(-)

diff --git a/drivers/net/phy/micrel.c b/drivers/net/phy/micrel.c
index 1ab6743..6a0834b 100644
--- a/drivers/net/phy/micrel.c
+++ b/drivers/net/phy/micrel.c
@@ -48,6 +48,18 @@
 #define KS8737_CTRL_INT_ACTIVE_HIGH		(1 << 14)
 #define KSZ8051_RMII_50MHZ_CLK			(1 << 7)
 
+static int ksz_config_flags(struct phy_device *phydev)
+{
+	int regval;
+
+	if (phydev->dev_flags & MICREL_PHY_50MHZ_CLK) {
+		regval = phy_read(phydev, MII_KSZPHY_CTRL);
+		regval |= KSZ8051_RMII_50MHZ_CLK;
+		return phy_write(phydev, MII_KSZPHY_CTRL, regval);
+	}
+	return 0;
+}
+
 static int kszphy_ack_interrupt(struct phy_device *phydev)
 {
 	/* bit[7..0] int status, which is a read and clear register. */
@@ -109,22 +121,19 @@ static int kszphy_config_init(struct phy_device *phydev)
 
 static int ksz8021_config_init(struct phy_device *phydev)
 {
+	int rc;
 	const u16 val = KSZPHY_OMSO_B_CAST_OFF | KSZPHY_OMSO_RMII_OVERRIDE;
 	phy_write(phydev, MII_KSZPHY_OMSO, val);
-	return 0;
+	rc = ksz_config_flags(phydev);
+	return rc < 0 ? rc : 0;
 }
 
 static int ks8051_config_init(struct phy_device *phydev)
 {
-	int regval;
-
-	if (phydev->dev_flags & MICREL_PHY_50MHZ_CLK) {
-		regval = phy_read(phydev, MII_KSZPHY_CTRL);
-		regval |= KSZ8051_RMII_50MHZ_CLK;
-		phy_write(phydev, MII_KSZPHY_CTRL, regval);
-	}
+	int rc;
 
-	return 0;
+	rc = ksz_config_flags(phydev);
+	return rc < 0 ? rc : 0;
 }
 
 #define KSZ8873MLL_GLOBAL_CONTROL_4	0x06
-- 
1.7.9.5

