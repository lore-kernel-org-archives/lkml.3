Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755877AbaCKXDO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Mar 2014 19:03:14 -0400
Received: from mail-ea0-f180.google.com ([209.85.215.180]:35565 "EHLO
	mail-ea0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754819AbaCKXDM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Mar 2014 19:03:12 -0400
From: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
To: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
Cc: David Miller <davem@davemloft.net>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Ben Hutchings <ben@decadent.org.uk>, netdev@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH v3] net: phy: fix uninitalized WOL parameters in phy_ethtool_get_wol
Date: Wed, 12 Mar 2014 00:02:55 +0100
Message-Id: <1394578975-12588-1-git-send-email-sebastian.hesselbarth@gmail.com>
In-Reply-To: <1394484661-4554-2-git-send-email-sebastian.hesselbarth@gmail.com>
References: <1394484661-4554-2-git-send-email-sebastian.hesselbarth@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

phy_ethtool_get_wol is a helper to get current WOL settings from
a phy device. When using this helper on a PHY without .get_wol
callback, struct ethtool_wolinfo is never set-up correctly and
may contain misleading information about WOL status.

To fix this, always zero relevant fields of struct ethtool_wolinfo
regardless of .get_wol callback availability.

Signed-off-by: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
---
Changelog:
v1->v2:
- clear whole struct ethtool_wolinfo
- check for non-NULL phy_device
v2->v3:
- only clear ->supported and ->wolopts (Suggested by Ben Hutchings)

Cc: David Miller <davem@davemloft.net>
Cc: Florian Fainelli <f.fainelli@gmail.com>
Cc: Ben Hutchings <ben@decadent.org.uk>
Cc: netdev@vger.kernel.org
Cc: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org
---
 drivers/net/phy/phy.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/net/phy/phy.c b/drivers/net/phy/phy.c
index 19c9eca0ef26..94234a91a50f 100644
--- a/drivers/net/phy/phy.c
+++ b/drivers/net/phy/phy.c
@@ -1092,7 +1092,9 @@ EXPORT_SYMBOL(phy_ethtool_set_wol);
 
 void phy_ethtool_get_wol(struct phy_device *phydev, struct ethtool_wolinfo *wol)
 {
-	if (phydev->drv->get_wol)
+	wol->supported = wol->wolopts = 0;
+
+	if (phydev && phydev->drv->get_wol)
 		phydev->drv->get_wol(phydev, wol);
 }
 EXPORT_SYMBOL(phy_ethtool_get_wol);
-- 
1.8.5.3

