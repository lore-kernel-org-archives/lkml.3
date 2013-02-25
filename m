Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754600Ab3BYFTU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Feb 2013 00:19:20 -0500
Received: from mail-lb0-f170.google.com ([209.85.217.170]:54149 "EHLO
	mail-lb0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753891Ab3BYFTQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Feb 2013 00:19:16 -0500
Subject: [PATCH  RESEND 3/3] e1000e: fix accessing to suspended device
To: linux-kernel@vger.kernel.org
From: Konstantin Khlebnikov <khlebnikov@openvz.org>
Cc: e1000-devel@lists.sourceforge.net,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Bruce Allan <bruce.w.allan@intel.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Date: Mon, 25 Feb 2013 09:19:11 +0400
Message-ID: <20130225051911.12689.11167.stgit@zurg>
In-Reply-To: <20130225051010.12689.28611.stgit@zurg>
References: <20130225051010.12689.28611.stgit@zurg>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fixes some annoying messages like 'Error reading PHY register' and
'Hardware Erorr' and saves several seconds on reboot.

Signed-off-by: Konstantin Khlebnikov <khlebnikov@openvz.org>
Acked-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Cc: e1000-devel@lists.sourceforge.net
Cc: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Cc: Bruce Allan <bruce.w.allan@intel.com>
---
 drivers/net/ethernet/intel/e1000e/ethtool.c |   13 +++++++++++++
 drivers/net/ethernet/intel/e1000e/netdev.c  |    2 ++
 2 files changed, 15 insertions(+)

diff --git a/drivers/net/ethernet/intel/e1000e/ethtool.c b/drivers/net/ethernet/intel/e1000e/ethtool.c
index 2c18137..f91a8f3 100644
--- a/drivers/net/ethernet/intel/e1000e/ethtool.c
+++ b/drivers/net/ethernet/intel/e1000e/ethtool.c
@@ -36,6 +36,7 @@
 #include <linux/delay.h>
 #include <linux/vmalloc.h>
 #include <linux/mdio.h>
+#include <linux/pm_runtime.h>
 
 #include "e1000.h"
 
@@ -2229,7 +2230,19 @@ static int e1000e_get_ts_info(struct net_device *netdev,
 	return 0;
 }
 
+static int e1000e_ethtool_begin(struct net_device *netdev)
+{
+	return pm_runtime_get_sync(netdev->dev.parent);
+}
+
+static void e1000e_ethtool_complete(struct net_device *netdev)
+{
+	pm_runtime_put_sync(netdev->dev.parent);
+}
+
 static const struct ethtool_ops e1000_ethtool_ops = {
+	.begin			= e1000e_ethtool_begin,
+	.complete		= e1000e_ethtool_complete,
 	.get_settings		= e1000_get_settings,
 	.set_settings		= e1000_set_settings,
 	.get_drvinfo		= e1000_get_drvinfo,
diff --git a/drivers/net/ethernet/intel/e1000e/netdev.c b/drivers/net/ethernet/intel/e1000e/netdev.c
index 2954cc7..948b86ff 100644
--- a/drivers/net/ethernet/intel/e1000e/netdev.c
+++ b/drivers/net/ethernet/intel/e1000e/netdev.c
@@ -4663,6 +4663,7 @@ static void e1000_phy_read_status(struct e1000_adapter *adapter)
 	    (adapter->hw.phy.media_type == e1000_media_type_copper)) {
 		int ret_val;
 
+		pm_runtime_get_sync(&adapter->pdev->dev);
 		ret_val = e1e_rphy(hw, MII_BMCR, &phy->bmcr);
 		ret_val |= e1e_rphy(hw, MII_BMSR, &phy->bmsr);
 		ret_val |= e1e_rphy(hw, MII_ADVERTISE, &phy->advertise);
@@ -4673,6 +4674,7 @@ static void e1000_phy_read_status(struct e1000_adapter *adapter)
 		ret_val |= e1e_rphy(hw, MII_ESTATUS, &phy->estatus);
 		if (ret_val)
 			e_warn("Error reading PHY register\n");
+		pm_runtime_put_sync(&adapter->pdev->dev);
 	} else {
 		/* Do not read PHY registers if link is not up
 		 * Set values to typical power-on defaults

