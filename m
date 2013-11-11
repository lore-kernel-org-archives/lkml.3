Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753763Ab3KKMZU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Nov 2013 07:25:20 -0500
Received: from tx2ehsobe004.messaging.microsoft.com ([65.55.88.14]:30356 "EHLO
	tx2outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753708Ab3KKMZQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Nov 2013 07:25:16 -0500
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: 2
X-BigFish: VS2(zzzz1f42h1ee6h1ce5h1fdah201ch2073h2146h1202h1fd0h1e76h1d1ah1cabh1d2ah1fc6hzd2iz1de098h8275bh1de097hz31h87h2a8h839hd24he5bhf0ah1288h12a5h12a9h12bdh12e5h137ah139eh13b6h1441h1504h1537h15a8h162dh1631h1758h17eeh1898h18e1h1946h19b5h1ad9h1b0ah1b2fh224fh1fb3h1d0ch1d2eh1d3fh1dc1h1dfeh1dffh1e23h1fe8h1ff5h2218h2216h129fi1151h1155h)
X-FB-DOMAIN-IP-MATCH: fail
From: <shh.xie@gmail.com>
To: <linuxppc-dev@lists.ozlabs.org>, <linux-kernel@vger.kernel.org>
CC: <madalin.bucur@freescale.com>, <Shruti@freescale.com>,
        Shaohui Xie <Shaohui.Xie@freescale.com>
Subject: [PATCH 4/4] phylib: Add of_phy_attach
Date: Mon, 11 Nov 2013 19:08:16 +0800
Message-ID: <1384168100-3046-1-git-send-email-shh.xie@gmail.com>
X-Mailer: git-send-email 1.8.4.1
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: sigmatel.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andy Fleming

10G PHYs don't currently support running the state machine, which
is implicitly setup via of_phy_connect(). Therefore, it is necessary
to implement an OF version of phy_attach(), which does everything
except start the state machine.

Signed-off-by: Andy Fleming
Signed-off-by: Shaohui Xie <Shaohui.Xie@freescale.com>
---
 drivers/of/of_mdio.c    | 22 ++++++++++++++++++++--
 include/linux/of_mdio.h |  8 ++++++++
 2 files changed, 28 insertions(+), 2 deletions(-)

diff --git a/drivers/of/of_mdio.c b/drivers/of/of_mdio.c
index d5a57a9..a748274 100644
--- a/drivers/of/of_mdio.c
+++ b/drivers/of/of_mdio.c
@@ -221,8 +221,7 @@ EXPORT_SYMBOL(of_phy_connect);
  * not call this function from new drivers.
  */
 struct phy_device *of_phy_connect_fixed_link(struct net_device *dev,
-					     void (*hndlr)(struct net_device *),
-					     phy_interface_t iface)
+		void (*hndlr)(struct net_device *), phy_interface_t iface)
 {
 	struct device_node *net_np;
 	char bus_id[MII_BUS_ID_SIZE + 3];
@@ -247,3 +246,22 @@ struct phy_device *of_phy_connect_fixed_link(struct net_device *dev,
 	return IS_ERR(phy) ? NULL : phy;
 }
 EXPORT_SYMBOL(of_phy_connect_fixed_link);
+
+/**
+ * of_phy_attach - Attach to a PHY without starting the state machine
+ * @dev: pointer to net_device claiming the phy
+ * @phy_np: Node pointer for the PHY
+ * @flags: flags to pass to the PHY
+ * @iface: PHY data interface type
+ */
+struct phy_device *of_phy_attach(struct net_device *dev,
+		struct device_node *phy_np, u32 flags, phy_interface_t iface)
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
index 8163107..dcda44d 100644
--- a/include/linux/of_mdio.h
+++ b/include/linux/of_mdio.h
@@ -19,6 +19,8 @@ extern struct phy_device *of_phy_connect(struct net_device *dev,
 					 struct device_node *phy_np,
 					 void (*hndlr)(struct net_device *),
 					 u32 flags, phy_interface_t iface);
+extern struct phy_device *of_phy_attach(struct net_device *dev,
+		struct device_node *phy_np, u32 flags, phy_interface_t iface);
 extern struct phy_device *of_phy_connect_fixed_link(struct net_device *dev,
 					 void (*hndlr)(struct net_device *),
 					 phy_interface_t iface);
@@ -44,6 +46,12 @@ static inline struct phy_device *of_phy_connect(struct net_device *dev,
 	return NULL;
 }
 
+static inline struct phy_device *of_phy_attach(struct net_device *dev,
+		struct device_node *phy_np, u32 flags, phy_interface_t iface)
+{
+	return NULL;
+}
+
 static inline struct phy_device *of_phy_connect_fixed_link(struct net_device *dev,
 							   void (*hndlr)(struct net_device *),
 							   phy_interface_t iface)
-- 
1.8.4.1


