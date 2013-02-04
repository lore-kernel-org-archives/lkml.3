Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754871Ab3BDMND (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Feb 2013 07:13:03 -0500
Received: from mail-la0-f41.google.com ([209.85.215.41]:35921 "EHLO
	mail-la0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754734Ab3BDL4U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Feb 2013 06:56:20 -0500
Subject: [PATCH v2 7/7] e1000e: fix accessing to suspended device
To: e1000-devel@lists.sourceforge.net, linux-pci@vger.kernel.org,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        linux-kernel@vger.kernel.org
From: Konstantin Khlebnikov <khlebnikov@openvz.org>
Cc: Bruce Allan <bruce.w.allan@intel.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Date: Mon, 04 Feb 2013 15:56:15 +0400
Message-ID: <20130204115615.5569.77011.stgit@zurg>
In-Reply-To: <20130204115246.5569.85829.stgit@zurg>
References: <20130204115246.5569.85829.stgit@zurg>
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
Cc: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Cc: e1000-devel@lists.sourceforge.net
Cc: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Cc: Bruce Allan <bruce.w.allan@intel.com>
---
 drivers/net/ethernet/intel/e1000e/ethtool.c |   13 +++++++++++++
 drivers/net/ethernet/intel/e1000e/netdev.c  |    2 ++
 2 files changed, 15 insertions(+)

diff --git a/drivers/net/ethernet/intel/e1000e/ethtool.c b/drivers/net/ethernet/intel/e1000e/ethtool.c
index f95bc6e..90afe58 100644
--- a/drivers/net/ethernet/intel/e1000e/ethtool.c
+++ b/drivers/net/ethernet/intel/e1000e/ethtool.c
@@ -35,6 +35,7 @@
 #include <linux/slab.h>
 #include <linux/delay.h>
 #include <linux/vmalloc.h>
+#include <linux/pm_runtime.h>
 
 #include "e1000.h"
 
@@ -2051,7 +2052,19 @@ static int e1000_get_rxnfc(struct net_device *netdev,
 	}
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
index 708d609..e501298 100644
--- a/drivers/net/ethernet/intel/e1000e/netdev.c
+++ b/drivers/net/ethernet/intel/e1000e/netdev.c
@@ -4267,6 +4267,7 @@ static void e1000_phy_read_status(struct e1000_adapter *adapter)
 	    (adapter->hw.phy.media_type == e1000_media_type_copper)) {
 		int ret_val;
 
+		pm_runtime_get_sync(&adapter->pdev->dev);
 		ret_val  = e1e_rphy(hw, PHY_CONTROL, &phy->bmcr);
 		ret_val |= e1e_rphy(hw, PHY_STATUS, &phy->bmsr);
 		ret_val |= e1e_rphy(hw, PHY_AUTONEG_ADV, &phy->advertise);
@@ -4277,6 +4278,7 @@ static void e1000_phy_read_status(struct e1000_adapter *adapter)
 		ret_val |= e1e_rphy(hw, PHY_EXT_STATUS, &phy->estatus);
 		if (ret_val)
 			e_warn("Error reading PHY register\n");
+		pm_runtime_put_sync(&adapter->pdev->dev);
 	} else {
 		/* Do not read PHY registers if link is not up
 		 * Set values to typical power-on defaults

