Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933378Ab3CVNjs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Mar 2013 09:39:48 -0400
Received: from swissweb.swissdisk.com ([174.129.12.238]:52792 "EHLO
	swissweb.swissdisk.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933342Ab3CVNjn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Mar 2013 09:39:43 -0400
X-Greylist: delayed 1391 seconds by postgrey-1.27 at vger.kernel.org; Fri, 22 Mar 2013 09:39:43 EDT
From: Andy Fleming <afleming@freescale.com>
Date: Fri, 5 Mar 2010 13:48:19 -0600
Subject: [PATCH] of_mdio: Add of_phy_attach function
To: linux-kernel@vger.kernel.org
Cc: Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>,
        devicetree-discuss@lists.ozlabs.org
Message-Id: <E1UJ1fR-0004i1-Fc@swissweb.swissdisk.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

of_phy_connect is useful for most systems, but some drivers will want
finer-grained control over their PHYs, and won't want to use the
PHY Lib state machine or interrupt handlers.

This mirrors phy_attach() in libphy, which is already exported.

Signed-off-by: Andy Fleming <afleming@freescale.com>
Signed-off-by: Ben Collins <ben.c@servergy.com>
Cc: Grant Likely <grant.likely@secretlab.ca>
Cc: Rob Herring <rob.herring@calxeda.com>
Cc: devicetree-discuss@lists.ozlabs.org
---
 drivers/net/phy/phy_device.c |  8 +++-----
 drivers/of/of_mdio.c         | 14 ++++++++++++++
 include/linux/of_mdio.h      |  3 +++
 include/linux/phy.h          |  2 ++
 4 files changed, 22 insertions(+), 5 deletions(-)

diff --git a/drivers/net/phy/phy_device.c b/drivers/net/phy/phy_device.c
index 3657b4a..54ba552 100644
--- a/drivers/net/phy/phy_device.c
+++ b/drivers/net/phy/phy_device.c
@@ -60,9 +60,6 @@ extern void mdio_bus_exit(void);
 static LIST_HEAD(phy_fixup_list);
 static DEFINE_MUTEX(phy_fixup_lock);
 
-static int phy_attach_direct(struct net_device *dev, struct phy_device *phydev,
-			     u32 flags, phy_interface_t interface);
-
 /*
  * Creates a new phy_fixup and adds it to the list
  * @bus_id: A string which matches phydev->dev.bus_id (or PHY_ANY_ID)
@@ -524,8 +521,8 @@ int phy_init_hw(struct phy_device *phydev)
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
@@ -571,6 +568,7 @@ static int phy_attach_direct(struct net_device *dev, struct phy_device *phydev,
 
 	return err;
 }
+EXPORT_SYMBOL(phy_attach_direct);
 
 /**
  * phy_attach - attach a network device to a particular PHY device
diff --git a/drivers/of/of_mdio.c b/drivers/of/of_mdio.c
index 199b7f2..2b2c64c 100644
--- a/drivers/of/of_mdio.c
+++ b/drivers/of/of_mdio.c
@@ -198,3 +198,17 @@ struct phy_device *of_phy_connect_fixed_link(struct net_device *dev,
 	return IS_ERR(phy) ? NULL : phy;
 }
 EXPORT_SYMBOL(of_phy_connect_fixed_link);
+
+/* Attach a network device to a particular OF PHY device */
+struct phy_device *of_phy_attach(struct net_device *dev,
+				struct device_node *phy_np, u32 flags,
+				phy_interface_t iface)
+{
+	struct phy_device *phy = of_phy_find_device(phy_np);
+
+	if (!phy)
+		return NULL;
+
+	return phy_attach_direct(dev, phy, flags, iface) ? NULL : phy;
+}
+EXPORT_SYMBOL(of_phy_attach);
diff --git a/include/linux/of_mdio.h b/include/linux/of_mdio.h
index cdc62c9..88319da 100644
--- a/include/linux/of_mdio.h
+++ b/include/linux/of_mdio.h
@@ -22,6 +22,9 @@ extern struct phy_device *of_phy_connect(struct net_device *dev,
 extern struct phy_device *of_phy_connect_fixed_link(struct net_device *dev,
 					 void (*hndlr)(struct net_device *),
 					 phy_interface_t iface);
+extern struct phy_device *of_phy_attach(struct net_device *dev,
+				struct device_node *phy_np, u32 flags,
+				phy_interface_t iface);
 
 extern struct mii_bus *of_mdio_find_bus(struct device_node *mdio_np);
 
diff --git a/include/linux/phy.h b/include/linux/phy.h
index 5a94ec7..0521e72 100644
--- a/include/linux/phy.h
+++ b/include/linux/phy.h
@@ -508,6 +508,8 @@ int phy_device_register(struct phy_device *phy);
 int phy_init_hw(struct phy_device *phydev);
 struct phy_device * phy_attach(struct net_device *dev,
 		const char *bus_id, phy_interface_t interface);
+int phy_attach_direct(struct net_device *dev, struct phy_device *phydev,
+		      u32 flags, phy_interface_t interface);
 struct phy_device *phy_find_first(struct mii_bus *bus);
 int phy_connect_direct(struct net_device *dev, struct phy_device *phydev,
 		void (*handler)(struct net_device *),
-- 
1.8.1.2

