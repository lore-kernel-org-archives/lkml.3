Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932915Ab3LDPrP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Dec 2013 10:47:15 -0500
Received: from mail-ea0-f182.google.com ([209.85.215.182]:61377 "EHLO
	mail-ea0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932609Ab3LDPo7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Dec 2013 10:44:59 -0500
From: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
To: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
Cc: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        David Miller <davem@davemloft.net>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Mugunthan V N <mugunthanvnm@ti.com>, netdev@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH RFCv2 3/6] net: phy: provide phy_resume/phy_suspend helpers
Date: Wed,  4 Dec 2013 16:44:45 +0100
Message-Id: <1386171888-28190-4-git-send-email-sebastian.hesselbarth@gmail.com>
In-Reply-To: <1384978913-8052-1-git-send-email-sebastian.hesselbarth@gmail.com>
References: <1384978913-8052-1-git-send-email-sebastian.hesselbarth@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This adds helper functions to resume and suspend a given phy_device
by calling the corresponding driver callbacks if available.

Signed-off-by: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
---
Changelog:
RFCv1->RFCv2:
- only suspend if WOL is not enabled
- remove EXPORT_SYMBOL for phy_suspend/resume

Cc: David Miller <davem@davemloft.net>
Cc: Florian Fainelli <f.fainelli@gmail.com>
Cc: Mugunthan V N <mugunthanvnm@ti.com>
Cc: netdev@vger.kernel.org
Cc: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org
---
 drivers/net/phy/phy_device.c |   24 ++++++++++++++++++++++++
 include/linux/phy.h          |    2 ++
 2 files changed, 26 insertions(+), 0 deletions(-)

diff --git a/drivers/net/phy/phy_device.c b/drivers/net/phy/phy_device.c
index d6447b3..6f0e9e4 100644
--- a/drivers/net/phy/phy_device.c
+++ b/drivers/net/phy/phy_device.c
@@ -625,6 +625,30 @@ void phy_detach(struct phy_device *phydev)
 }
 EXPORT_SYMBOL(phy_detach);
 
+int phy_suspend(struct phy_device *phydev)
+{
+	struct phy_driver *phydrv = to_phy_driver(phydev->dev.driver);
+	struct ethtool_wolinfo wol;
+
+	/* If the device has WOL enabled, we cannot suspend the PHY */
+	wol.cmd = ETHTOOL_GWOL;
+	phy_ethtool_get_wol(phydev, &wol);
+	if (wol.wolopts)
+		return -EBUSY;
+
+	if (phydrv->suspend)
+		return phydrv->suspend(phydev);
+	return 0;
+}
+
+int phy_resume(struct phy_device *phydev)
+{
+	struct phy_driver *phydrv = to_phy_driver(phydev->dev.driver);
+
+	if (phydrv->resume)
+		return phydrv->resume(phydev);
+	return 0;
+}
 
 /* Generic PHY support and helper functions */
 
diff --git a/include/linux/phy.h b/include/linux/phy.h
index 48a4dc3..1070ee3 100644
--- a/include/linux/phy.h
+++ b/include/linux/phy.h
@@ -538,6 +538,8 @@ struct phy_device *phy_device_create(struct mii_bus *bus, int addr, int phy_id,
 struct phy_device *get_phy_device(struct mii_bus *bus, int addr, bool is_c45);
 int phy_device_register(struct phy_device *phy);
 int phy_init_hw(struct phy_device *phydev);
+int phy_suspend(struct phy_device *phydev);
+int phy_resume(struct phy_device *phydev);
 struct phy_device * phy_attach(struct net_device *dev,
 		const char *bus_id, phy_interface_t interface);
 struct phy_device *phy_find_first(struct mii_bus *bus);
-- 
1.7.2.5

