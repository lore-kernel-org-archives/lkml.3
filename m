Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753644Ab3KKMZF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Nov 2013 07:25:05 -0500
Received: from co1ehsobe002.messaging.microsoft.com ([216.32.180.185]:3568
	"EHLO co1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753206Ab3KKMY7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Nov 2013 07:24:59 -0500
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: -1
X-BigFish: VS-1(zz13e6Kzz1f42h1ee6h1ce5h1fdah201ch2073h2146h1202h1fd0h1e76h1d1ah1cabh1d2ah1fc6hzd2iz1de098h8275bh1de097hz31h87h2a8h839hd24he5bhf0ah1288h12a5h12a9h12bdh12e5h137ah139eh13b6h1441h1504h1537h15a8h162dh1631h1758h17eeh1898h18e1h1946h19b5h1ad9h1b0ah1b2fh224fh1fb3h1d0ch1d2eh1d3fh1dc1h1dfeh1dffh1e23h1fe8h1ff5h2218h2216h129fi1151h1155h)
X-FB-DOMAIN-IP-MATCH: fail
From: <shh.xie@gmail.com>
To: <linuxppc-dev@lists.ozlabs.org>, <linux-kernel@vger.kernel.org>
CC: <madalin.bucur@freescale.com>, <Shruti@freescale.com>,
        Shaohui Xie <Shaohui.Xie@freescale.com>
Subject: [PATCH 3/4] phylib: Support attaching to gen10g_driver
Date: Mon, 11 Nov 2013 19:07:54 +0800
Message-ID: <1384168079-3002-1-git-send-email-shh.xie@gmail.com>
X-Mailer: git-send-email 1.8.4.1
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: sigmatel.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andy Fleming

phy_attach_direct() may now attach to a generic 10G driver. It can
also be used exactly as phy_connect_direct(), which will be useful
when using of_mdio, as phy_connect (and therefore of_phy_connect)
start the PHY state machine, which is currently irrelevant for 10G
PHYs.

Signed-off-by: Andy Fleming
Signed-off-by: Shaohui Xie <Shaohui.Xie@freescale.com>
---
 drivers/net/phy/phy_device.c | 23 +++++++++++------------
 include/linux/phy.h          |  2 ++
 2 files changed, 13 insertions(+), 12 deletions(-)

diff --git a/drivers/net/phy/phy_device.c b/drivers/net/phy/phy_device.c
index 30bf2d5..f51ea2e 100644
--- a/drivers/net/phy/phy_device.c
+++ b/drivers/net/phy/phy_device.c
@@ -55,15 +55,13 @@ static void phy_device_release(struct device *dev)
 }
 
 static struct phy_driver genphy_driver;
+static struct phy_driver gen10g_driver;
 extern int mdio_bus_init(void);
 extern void mdio_bus_exit(void);
 
 static LIST_HEAD(phy_fixup_list);
 static DEFINE_MUTEX(phy_fixup_lock);
 
-static int phy_attach_direct(struct net_device *dev, struct phy_device *phydev,
-			     u32 flags, phy_interface_t interface);
-
 /*
  * Creates a new phy_fixup and adds it to the list
  * @bus_id: A string which matches phydev->dev.bus_id (or PHY_ANY_ID)
@@ -521,12 +519,12 @@ int phy_init_hw(struct phy_device *phydev)
  *
  * Description: Called by drivers to attach to a particular PHY
  *     device. The phy_device is found, and properly hooked up
- *     to the phy_driver.  If no driver is attached, then the
- *     genphy_driver is used.  The phy_device is given a ptr to
+ *     to the phy_driver.  If no driver is attached, then a
+ *     generic driver is used.  The phy_device is given a ptr to
  *     the attaching device, and given a callback for link status
  *     change.  The phy_device is returned to the attaching driver.
  */
-static int phy_attach_direct(struct net_device *dev, struct phy_device *phydev,
+int phy_attach_direct(struct net_device *dev, struct phy_device *phydev,
 			     u32 flags, phy_interface_t interface)
 {
 	struct device *d = &phydev->dev;
@@ -535,12 +533,10 @@ static int phy_attach_direct(struct net_device *dev, struct phy_device *phydev,
 	/* Assume that if there is no driver, that it doesn't
 	 * exist, and we should use the genphy driver. */
 	if (NULL == d->driver) {
-		if (phydev->is_c45) {
-			pr_err("No driver for phy %x\n", phydev->phy_id);
-			return -ENODEV;
-		}
-
-		d->driver = &genphy_driver.driver;
+		if (phydev->is_c45)
+			d->driver = &gen10g_driver.driver;
+		else
+			d->driver = &genphy_driver.driver;
 
 		err = d->driver->probe(d);
 		if (err >= 0)
@@ -573,6 +569,7 @@ static int phy_attach_direct(struct net_device *dev, struct phy_device *phydev,
 
 	return err;
 }
+EXPORT_SYMBOL(phy_attach_direct);
 
 /**
  * phy_attach - attach a network device to a particular PHY device
@@ -623,6 +620,8 @@ void phy_detach(struct phy_device *phydev)
 	 * real driver could be loaded */
 	if (phydev->dev.driver == &genphy_driver.driver)
 		device_release_driver(&phydev->dev);
+	else if (phydev->dev.driver == &gen10g_driver.driver)
+		device_release_driver(&phydev->dev);
 }
 EXPORT_SYMBOL(phy_detach);
 
diff --git a/include/linux/phy.h b/include/linux/phy.h
index f864004..f36a6f6 100644
--- a/include/linux/phy.h
+++ b/include/linux/phy.h
@@ -575,6 +575,8 @@ int phy_init_hw(struct phy_device *phydev);
 struct phy_device * phy_attach(struct net_device *dev,
 		const char *bus_id, phy_interface_t interface);
 struct phy_device *phy_find_first(struct mii_bus *bus);
+int phy_attach_direct(struct net_device *dev, struct phy_device *phydev,
+			     u32 flags, phy_interface_t interface);
 int phy_connect_direct(struct net_device *dev, struct phy_device *phydev,
 		void (*handler)(struct net_device *),
 		phy_interface_t interface);
-- 
1.8.4.1


