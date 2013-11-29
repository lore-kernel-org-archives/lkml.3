Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753550Ab3K2HHB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Nov 2013 02:07:01 -0500
Received: from co9ehsobe002.messaging.microsoft.com ([207.46.163.25]:20888
	"EHLO co9outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753296Ab3K2HG6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Nov 2013 02:06:58 -0500
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: 1
X-BigFish: VS1(zzzz1f42h1ee6h1ce5h1fdah201ch2073h2146h1202h1fd0h1e76h1d1ah1cabh1d2ah1fc6hzz1de098h8275bh1de097hz31h87h2a8h839hd24he5bhf0ah1288h12a5h12a9h12bdh12e5h137ah139eh13b6h1441h1504h1537h15a8h162dh1631h1758h17eeh1898h18e1h1946h19b5h1ad9h1b0ah1b2fh224fh1fb3h1d0ch1d2eh1d3fh1dc1h1dfeh1dffh1e23h1fe8h1ff5h2218h2216h226dh22d0h2327h2336h129fi1151h1155h)
X-FB-DOMAIN-IP-MATCH: fail
From: <shh.xie@gmail.com>
To: <davem@davemloft.net>, <jg1.han@samsung.com>, <mugunthanvnm@ti.com>,
        <f.fainelli@gmail.com>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
CC: <Shaohui.Xie@freescale.com>
Subject: [PATCH 3/6] phylib: turn genphy_driver to an array
Date: Fri, 29 Nov 2013 13:46:38 +0800
Message-ID: <1385703998-12876-1-git-send-email-shh.xie@gmail.com>
X-Mailer: git-send-email 1.8.4.1
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: sigmatel.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Shaohui Xie <Shaohui.Xie@freescale.com>

Then other generic phy driver such as generic 10g phy driver can join it.

Signed-off-by: Shaohui Xie <Shaohui.Xie@freescale.com>
---
Splitted from previous v2 patch 3/5.

 drivers/net/phy/phy_device.c | 27 +++++++++++++++++++--------
 1 file changed, 19 insertions(+), 8 deletions(-)

diff --git a/drivers/net/phy/phy_device.c b/drivers/net/phy/phy_device.c
index d6447b3..a5926a6 100644
--- a/drivers/net/phy/phy_device.c
+++ b/drivers/net/phy/phy_device.c
@@ -53,7 +53,12 @@ static void phy_device_release(struct device *dev)
 	kfree(to_phy_device(dev));
 }
 
-static struct phy_driver genphy_driver;
+enum genphy_driver {
+	GENPHY_DRV_1G,
+	GENPHY_DRV_MAX
+};
+
+static struct phy_driver genphy_driver[GENPHY_DRV_MAX];
 extern int mdio_bus_init(void);
 extern void mdio_bus_exit(void);
 
@@ -539,7 +544,7 @@ static int phy_attach_direct(struct net_device *dev, struct phy_device *phydev,
 			return -ENODEV;
 		}
 
-		d->driver = &genphy_driver.driver;
+		d->driver = &genphy_driver[GENPHY_DRV_1G].driver;
 
 		err = d->driver->probe(d);
 		if (err >= 0)
@@ -613,6 +618,7 @@ EXPORT_SYMBOL(phy_attach);
  */
 void phy_detach(struct phy_device *phydev)
 {
+	int i;
 	phydev->attached_dev->phydev = NULL;
 	phydev->attached_dev = NULL;
 
@@ -620,8 +626,10 @@ void phy_detach(struct phy_device *phydev)
 	 * was using the generic driver), we unbind the device
 	 * from the generic driver so that there's a chance a
 	 * real driver could be loaded */
-	if (phydev->dev.driver == &genphy_driver.driver)
-		device_release_driver(&phydev->dev);
+	for (i = 0; i < ARRAY_SIZE(genphy_driver); i++) {
+		if (phydev->dev.driver == &genphy_driver[i].driver)
+			device_release_driver(&phydev->dev);
+	}
 }
 EXPORT_SYMBOL(phy_detach);
 
@@ -1116,7 +1124,8 @@ void phy_drivers_unregister(struct phy_driver *drv, int n)
 }
 EXPORT_SYMBOL(phy_drivers_unregister);
 
-static struct phy_driver genphy_driver = {
+static struct phy_driver genphy_driver[] = {
+{
 	.phy_id		= 0xffffffff,
 	.phy_id_mask	= 0xffffffff,
 	.name		= "Generic PHY",
@@ -1127,7 +1136,7 @@ static struct phy_driver genphy_driver = {
 	.suspend	= genphy_suspend,
 	.resume		= genphy_resume,
 	.driver		= {.owner= THIS_MODULE, },
-};
+} };
 
 static int __init phy_init(void)
 {
@@ -1137,7 +1146,8 @@ static int __init phy_init(void)
 	if (rc)
 		return rc;
 
-	rc = phy_driver_register(&genphy_driver);
+	rc = phy_drivers_register(genphy_driver,
+				  ARRAY_SIZE(genphy_driver));
 	if (rc)
 		mdio_bus_exit();
 
@@ -1146,7 +1156,8 @@ static int __init phy_init(void)
 
 static void __exit phy_exit(void)
 {
-	phy_driver_unregister(&genphy_driver);
+	phy_drivers_unregister(genphy_driver,
+			       ARRAY_SIZE(genphy_driver));
 	mdio_bus_exit();
 }
 
-- 
1.8.4.1


