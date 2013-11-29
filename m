Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754217Ab3K2HIk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Nov 2013 02:08:40 -0500
Received: from co1ehsobe001.messaging.microsoft.com ([216.32.180.184]:37709
	"EHLO co1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753902Ab3K2HIg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Nov 2013 02:08:36 -0500
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: 1
X-BigFish: VS1(zzzz1f42h1ee6h1ce5h1fdah201ch2073h2146h1202h1fd0h1e76h1d1ah1cabh1d2ah1fc6hzz1de098h8275bh1de097hz31h87h2a8h839hd24he5bhf0ah1288h12a5h12a9h12bdh12e5h137ah139eh13b6h1441h1504h1537h15a8h162dh1631h1758h17eeh1898h18e1h1946h19b5h1ad9h1b0ah1b2fh224fh1fb3h1d0ch1d2eh1d3fh1dc1h1dfeh1dffh1e23h1fe8h1ff5h2218h2216h226dh22d0h2327h2336h129fi1151h1155h)
X-FB-DOMAIN-IP-MATCH: fail
From: <shh.xie@gmail.com>
To: <davem@davemloft.net>, <jg1.han@samsung.com>, <mugunthanvnm@ti.com>,
        <f.fainelli@gmail.com>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
CC: <Shaohui.Xie@freescale.com>
Subject: [PATCH 6/6][v3] phylib: Add of_phy_attach
Date: Fri, 29 Nov 2013 13:48:16 +0800
Message-ID: <1385704096-12991-1-git-send-email-shh.xie@gmail.com>
X-Mailer: git-send-email 1.8.4.1
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: sigmatel.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andy Fleming <afleming@freescale.com>

10G PHYs don't currently support running the state machine, which
is implicitly setup via of_phy_connect(). Therefore, it is necessary
to implement an OF version of phy_attach(), which does everything
except start the state machine.

Signed-off-by: Andy Fleming <afleming@freescale.com>
Signed-off-by: Shaohui Xie <Shaohui.Xie@freescale.com>
Acked-by: Florian Fainelli <f.fainelli@gmail.com>
---
v3: no changes.

 drivers/of/of_mdio.c    | 19 +++++++++++++++++++
 include/linux/of_mdio.h |  9 +++++++++
 2 files changed, 28 insertions(+)

diff --git a/drivers/of/of_mdio.c b/drivers/of/of_mdio.c
index d5a57a9..21076ac 100644
--- a/drivers/of/of_mdio.c
+++ b/drivers/of/of_mdio.c
@@ -247,3 +247,22 @@ struct phy_device *of_phy_connect_fixed_link(struct net_device *dev,
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
index 8163107..108583a 100644
--- a/include/linux/of_mdio.h
+++ b/include/linux/of_mdio.h
@@ -19,6 +19,9 @@ extern struct phy_device *of_phy_connect(struct net_device *dev,
 					 struct device_node *phy_np,
 					 void (*hndlr)(struct net_device *),
 					 u32 flags, phy_interface_t iface);
+struct phy_device *of_phy_attach(struct net_device *dev,
+				 struct device_node *phy_np, u32 flags,
+				 phy_interface_t iface);
 extern struct phy_device *of_phy_connect_fixed_link(struct net_device *dev,
 					 void (*hndlr)(struct net_device *),
 					 phy_interface_t iface);
@@ -44,6 +47,12 @@ static inline struct phy_device *of_phy_connect(struct net_device *dev,
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


