Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752421AbaAJH5e (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Jan 2014 02:57:34 -0500
Received: from [216.32.180.189] ([216.32.180.189]:19221 "EHLO
	co1outboundpool.messaging.microsoft.com" rhost-flags-FAIL-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1750793AbaAJH5d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Jan 2014 02:57:33 -0500
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: 3
X-BigFish: VS3(z1039mz13e6Kzz1f42h1ee6h1ce5h1fdah201ch2073h2146h1202h1fd0h1e76h2189h1d1ah1cabh1d2ah21a7h1fc6hzdchz1de098h8275bh1de097hz31h87h2a8h839hd24he5bhf0ah1288h12a5h12a9h12bdh12e5h137ah139eh13b6h1441h1504h1537h15a8h162dh1631h1758h17eeh1898h18e1h1946h19b5h1ad9h1b0ah1b2fh224fh1fb3h1d0ch1d2eh1d3fh1dc1h1dfeh1dffh1e23h1fe8h1ff5h2218h2216h226dh22d0h2327h2336h2438h129fi1151h1155h)
X-FB-DOMAIN-IP-MATCH: fail
From: <shh.xie@gmail.com>
To: <davem@davemloft.net>, <jg1.han@samsung.com>, <mugunthanvnm@ti.com>,
        <f.fainelli@gmail.com>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
CC: <Shaohui.Xie@freescale.com>, Andy Fleming <afleming@gmail.com>
Subject: [PATCH 5/6] [v6] phylib: Support attaching to generic 10g driver
Date: Fri, 10 Jan 2014 14:27:54 +0800
Message-ID: <1389335274-328-1-git-send-email-shh.xie@gmail.com>
X-Mailer: git-send-email 1.8.4.1
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: sigmatel.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
X-FOPE-CONNECTOR: Id%0$Dn%FREESCALE.MAIL.ONMICROSOFT.COM$RO%1$TLS%0$FQDN%$TlsDn%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andy Fleming <afleming@gmail.com>

phy_attach_direct() may now attach to a generic 10G driver. It can
also be used exactly as phy_connect_direct(), which will be useful
when using of_mdio, as phy_connect (and therefore of_phy_connect)
start the PHY state machine, which is currently irrelevant for 10G
PHYs.

Signed-off-by: Andy Fleming <afleming@gmail.com>
Signed-off-by: Shaohui Xie <Shaohui.Xie@freescale.com>
Acked-by: Florian Fainelli <f.fainelli@gmail.com>
---
changes for v6:
rebased on top of 'net-next' tree. commit id 11b57f90257c1.

 drivers/net/phy/phy_device.c | 22 +++++++++-------------
 include/linux/phy.h          |  2 ++
 2 files changed, 11 insertions(+), 13 deletions(-)

diff --git a/drivers/net/phy/phy_device.c b/drivers/net/phy/phy_device.c
index 18714fe..39794c4 100644
--- a/drivers/net/phy/phy_device.c
+++ b/drivers/net/phy/phy_device.c
@@ -62,9 +62,6 @@ static struct phy_driver genphy_driver[GENPHY_DRV_MAX];
 static LIST_HEAD(phy_fixup_list);
 static DEFINE_MUTEX(phy_fixup_lock);
 
-static int phy_attach_direct(struct net_device *dev, struct phy_device *phydev,
-			     u32 flags, phy_interface_t interface);
-
 /**
  * phy_register_fixup - creates a new phy_fixup and adds it to the list
  * @bus_id: A string which matches phydev->dev.bus_id (or PHY_ANY_ID)
@@ -567,13 +564,13 @@ EXPORT_SYMBOL(phy_init_hw);
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
-			     u32 flags, phy_interface_t interface)
+int phy_attach_direct(struct net_device *dev, struct phy_device *phydev,
+		      u32 flags, phy_interface_t interface)
 {
 	struct device *d = &phydev->dev;
 	int err;
@@ -582,12 +579,10 @@ static int phy_attach_direct(struct net_device *dev, struct phy_device *phydev,
 	 * exist, and we should use the genphy driver.
 	 */
 	if (NULL == d->driver) {
-		if (phydev->is_c45) {
-			pr_err("No driver for phy %x\n", phydev->phy_id);
-			return -ENODEV;
-		}
-
-		d->driver = &genphy_driver[GENPHY_DRV_1G].driver;
+		if (phydev->is_c45)
+			d->driver = &genphy_driver[GENPHY_DRV_10G].driver;
+		else
+			d->driver = &genphy_driver[GENPHY_DRV_1G].driver;
 
 		err = d->driver->probe(d);
 		if (err >= 0)
@@ -623,6 +618,7 @@ static int phy_attach_direct(struct net_device *dev, struct phy_device *phydev,
 
 	return err;
 }
+EXPORT_SYMBOL(phy_attach_direct);
 
 /**
  * phy_attach - attach a network device to a particular PHY device
diff --git a/include/linux/phy.h b/include/linux/phy.h
index a9685b1..565188c 100644
--- a/include/linux/phy.h
+++ b/include/linux/phy.h
@@ -588,6 +588,8 @@ int phy_resume(struct phy_device *phydev);
 struct phy_device *phy_attach(struct net_device *dev, const char *bus_id,
 			      phy_interface_t interface);
 struct phy_device *phy_find_first(struct mii_bus *bus);
+int phy_attach_direct(struct net_device *dev, struct phy_device *phydev,
+		      u32 flags, phy_interface_t interface);
 int phy_connect_direct(struct net_device *dev, struct phy_device *phydev,
 		       void (*handler)(struct net_device *),
 		       phy_interface_t interface);
-- 
1.8.4.1


