Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755646AbaCJUvU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Mar 2014 16:51:20 -0400
Received: from mail-ee0-f48.google.com ([74.125.83.48]:49530 "EHLO
	mail-ee0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755003AbaCJUvL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Mar 2014 16:51:11 -0400
From: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
To: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
Cc: David Miller <davem@davemloft.net>,
        Florian Fainelli <f.fainelli@gmail.com>, netdev@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH v2 1/3] net: phy: fix uninitalized WOL parameters in phy_ethtool_get_wol
Date: Mon, 10 Mar 2014 21:50:59 +0100
Message-Id: <1394484661-4554-2-git-send-email-sebastian.hesselbarth@gmail.com>
In-Reply-To: <1394484661-4554-1-git-send-email-sebastian.hesselbarth@gmail.com>
References: <1394413270-7169-1-git-send-email-sebastian.hesselbarth@gmail.com>
 <1394484661-4554-1-git-send-email-sebastian.hesselbarth@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

phy_ethtool_get_wol is a helper to get current WOL settings from
a phy device. When using this helper on a PHY without .get_wol
callback, struct ethtool_wolinfo is never set-up correctly and
may contain misleading information about WOL status.

To fix this, always zero struct ethtool_wolinfo regardless of
.get_wol callback availability.

Signed-off-by: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
---
Changelog:
v1->v2:
- clear whole struct ethtool_wolinfo
- check for non-NULL phy_device

Cc: David Miller <davem@davemloft.net>
Cc: Florian Fainelli <f.fainelli@gmail.com>
Cc: netdev@vger.kernel.org
Cc: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org
---
 drivers/net/phy/phy.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/net/phy/phy.c b/drivers/net/phy/phy.c
index 19c9eca0ef26..dae1fa8aa23d 100644
--- a/drivers/net/phy/phy.c
+++ b/drivers/net/phy/phy.c
@@ -1092,7 +1092,9 @@ EXPORT_SYMBOL(phy_ethtool_set_wol);
 
 void phy_ethtool_get_wol(struct phy_device *phydev, struct ethtool_wolinfo *wol)
 {
-	if (phydev->drv->get_wol)
+	memset(wol, 0, sizeof(*wol));
+
+	if (phydev && phydev->drv->get_wol)
 		phydev->drv->get_wol(phydev, wol);
 }
 EXPORT_SYMBOL(phy_ethtool_get_wol);
-- 
1.8.5.3

