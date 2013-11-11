Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753571Ab3KKMYd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Nov 2013 07:24:33 -0500
Received: from co9ehsobe004.messaging.microsoft.com ([207.46.163.27]:21640
	"EHLO co9outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752967Ab3KKMY0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Nov 2013 07:24:26 -0500
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: 7
X-BigFish: VS7(z1039mzzz1f42h1ee6h1ce5h1fdah201ch2073h2146h1202h1fd0h1e76h1d1ah1cabh1d2ah1fc6hzd2iz1de098h8275bh1de097hz31h87h2a8h839hd24he5bhf0ah1288h12a5h12a9h12bdh12e5h137ah139eh13b6h1441h1504h1537h15a8h162dh1631h1758h17eeh1898h18e1h1946h19b5h1ad9h1b0ah1b2fh224fh1fb3h1d0ch1d2eh1d3fh1dc1h1dfeh1dffh1e23h1fe8h1ff5h2218h2216h129fi1151h1155h)
X-FB-DOMAIN-IP-MATCH: fail
From: <shh.xie@gmail.com>
To: <linuxppc-dev@lists.ozlabs.org>, <linux-kernel@vger.kernel.org>
CC: <madalin.bucur@freescale.com>, <Shruti@freescale.com>,
        Shaohui Xie <Shaohui.Xie@freescale.com>
Subject: [PATCH 2/4] phylib: Add generic 10G driver
Date: Mon, 11 Nov 2013 19:07:16 +0800
Message-ID: <1384168049-2899-1-git-send-email-shh.xie@gmail.com>
X-Mailer: git-send-email 1.8.4.1
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: sigmatel.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andy Fleming

Very incomplete, but will allow for binding an ethernet controller
to it.

Also, Add XGMII interface type

Signed-off-by: Andy Fleming
Signed-off-by: Shaohui Xie <Shaohui.Xie@freescale.com>
---
 drivers/net/phy/phy_device.c | 101 ++++++++++++++++++++++++++++++++++++++++++-
 include/linux/phy.h          |   1 +
 2 files changed, 101 insertions(+), 1 deletion(-)

diff --git a/drivers/net/phy/phy_device.c b/drivers/net/phy/phy_device.c
index 74630e9..30bf2d5 100644
--- a/drivers/net/phy/phy_device.c
+++ b/drivers/net/phy/phy_device.c
@@ -32,6 +32,7 @@
 #include <linux/module.h>
 #include <linux/mii.h>
 #include <linux/ethtool.h>
+#include <linux/mdio.h>
 #include <linux/phy.h>
 
 #include <asm/io.h>
@@ -689,6 +690,13 @@ static int genphy_config_advert(struct phy_device *phydev)
 	return changed;
 }
 
+int gen10g_config_advert(struct phy_device *dev)
+{
+	return 0;
+}
+EXPORT_SYMBOL(gen10g_config_advert);
+
+
 /**
  * genphy_setup_forced - configures/forces speed/duplex from @phydev
  * @phydev: target phy_device struct
@@ -742,6 +750,12 @@ int genphy_restart_aneg(struct phy_device *phydev)
 }
 EXPORT_SYMBOL(genphy_restart_aneg);
 
+int gen10g_restart_aneg(struct phy_device *phydev)
+{
+	return 0;
+}
+EXPORT_SYMBOL(gen10g_restart_aneg);
+
 
 /**
  * genphy_config_aneg - restart auto-negotiation or write BMCR
@@ -784,6 +798,13 @@ int genphy_config_aneg(struct phy_device *phydev)
 }
 EXPORT_SYMBOL(genphy_config_aneg);
 
+int gen10g_config_aneg(struct phy_device *phydev)
+{
+	return 0;
+}
+EXPORT_SYMBOL(gen10g_config_aneg);
+
+
 /**
  * genphy_update_link - update link status in @phydev
  * @phydev: target phy_device struct
@@ -913,6 +934,35 @@ int genphy_read_status(struct phy_device *phydev)
 }
 EXPORT_SYMBOL(genphy_read_status);
 
+int gen10g_read_status(struct phy_device *phydev)
+{
+	int devad, reg;
+	u32 mmd_mask = phydev->c45_ids.devices_in_package;
+
+	phydev->link = 1;
+
+	/* For now just lie and say it's 10G all the time */
+	phydev->speed = 10000;
+	phydev->duplex = DUPLEX_FULL;
+
+	for (devad = 0; mmd_mask; devad++, mmd_mask = mmd_mask >> 1) {
+		if (!(mmd_mask & 1))
+			continue;
+
+		/* Read twice because link state is latched and a
+		 * read moves the current state into the register
+		 */
+		phy_read_mmd(phydev, devad, MDIO_STAT1);
+		reg = phy_read_mmd(phydev, devad, MDIO_STAT1);
+		if (reg < 0 || !(reg & MDIO_STAT1_LSTATUS))
+			phydev->link = 0;
+	}
+
+	return 0;
+}
+EXPORT_SYMBOL(gen10g_read_status);
+
+
 static int genphy_config_init(struct phy_device *phydev)
 {
 	int val;
@@ -959,6 +1009,15 @@ static int genphy_config_init(struct phy_device *phydev)
 
 	return 0;
 }
+
+static int gen10g_config_init(struct phy_device *phydev)
+{
+	/* Temporarily just say we support everything */
+	phydev->supported = phydev->advertising = SUPPORTED_10000baseT_Full;
+
+	return 0;
+}
+
 int genphy_suspend(struct phy_device *phydev)
 {
 	int value;
@@ -974,6 +1033,13 @@ int genphy_suspend(struct phy_device *phydev)
 }
 EXPORT_SYMBOL(genphy_suspend);
 
+int gen10g_suspend(struct phy_device *phydev)
+{
+	return 0;
+}
+EXPORT_SYMBOL(gen10g_suspend);
+
+
 int genphy_resume(struct phy_device *phydev)
 {
 	int value;
@@ -989,6 +1055,13 @@ int genphy_resume(struct phy_device *phydev)
 }
 EXPORT_SYMBOL(genphy_resume);
 
+int gen10g_resume(struct phy_device *phydev)
+{
+	return 0;
+}
+EXPORT_SYMBOL(gen10g_resume);
+
+
 /**
  * phy_probe - probe and init a PHY device
  * @dev: device to probe and init
@@ -1129,6 +1202,20 @@ static struct phy_driver genphy_driver = {
 	.driver		= {.owner= THIS_MODULE, },
 };
 
+static struct phy_driver gen10g_driver = {
+	.phy_id         = 0xffffffff,
+	.phy_id_mask    = 0xffffffff,
+	.name           = "Generic 10G PHY",
+	.config_init    = gen10g_config_init,
+	.features       = 0,
+	.config_aneg    = gen10g_config_aneg,
+	.read_status    = gen10g_read_status,
+	.suspend        = gen10g_suspend,
+	.resume         = gen10g_resume,
+	.driver         = {.owner = THIS_MODULE, },
+};
+
+
 static int __init phy_init(void)
 {
 	int rc;
@@ -1139,13 +1226,25 @@ static int __init phy_init(void)
 
 	rc = phy_driver_register(&genphy_driver);
 	if (rc)
-		mdio_bus_exit();
+		goto genphy_register_failed;
+
+	rc = phy_driver_register(&gen10g_driver);
+	if (rc)
+		goto gen10g_register_failed;
+
+	return rc;
+
+gen10g_register_failed:
+	phy_driver_unregister(&genphy_driver);
+genphy_register_failed:
+	mdio_bus_exit();
 
 	return rc;
 }
 
 static void __exit phy_exit(void)
 {
+	phy_driver_unregister(&gen10g_driver);
 	phy_driver_unregister(&genphy_driver);
 	mdio_bus_exit();
 }
diff --git a/include/linux/phy.h b/include/linux/phy.h
index 684925a..f864004 100644
--- a/include/linux/phy.h
+++ b/include/linux/phy.h
@@ -66,6 +66,7 @@ typedef enum {
 	PHY_INTERFACE_MODE_RGMII_TXID,
 	PHY_INTERFACE_MODE_RTBI,
 	PHY_INTERFACE_MODE_SMII,
+	PHY_INTERFACE_MODE_XGMII,
 } phy_interface_t;
 
 
-- 
1.8.4.1


