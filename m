Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758503Ab3EIXA1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 May 2013 19:00:27 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:45984 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757491Ab3EIWcq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 May 2013 18:32:46 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        =?UTF-8?q?T=F3th=20Attila?= <atoth@atoth.sote.hu>,
        Konstantin Khlebnikov <khlebnikov@openvz.org>,
        Bruce Allan <bruce.w.allan@intel.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Borislav Petkov <bp@suse.de>, Aaron Brown <aaron.f.brown@intel.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Subject: [ 15/73] e1000e: fix accessing to suspended device
Date: Thu,  9 May 2013 15:31:38 -0700
Message-Id: <20130509222759.611227001@linuxfoundation.org>
X-Mailer: git-send-email 1.8.3.rc0.20.gb99dd2e
In-Reply-To: <20130509222757.917088509@linuxfoundation.org>
References: <20130509222757.917088509@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Konstantin Khlebnikov <khlebnikov@openvz.org>

commit e60b22c5b7e59db09a7c9490b1e132c7e49ae904 upstream.

This patch fixes some annoying messages like 'Error reading PHY register' and
'Hardware Erorr' and saves several seconds on reboot.

Signed-off-by: Konstantin Khlebnikov <khlebnikov@openvz.org>
Cc: Bruce Allan <bruce.w.allan@intel.com>
Acked-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Tested-by: Borislav Petkov <bp@suse.de>
Tested-by: Aaron Brown <aaron.f.brown@intel.com>
Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Tested-by: Tóth Attila <atoth@atoth.sote.hu>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/net/ethernet/intel/e1000e/ethtool.c |   13 +++++++++++++
 drivers/net/ethernet/intel/e1000e/netdev.c  |    2 ++
 2 files changed, 15 insertions(+)

--- a/drivers/net/ethernet/intel/e1000e/ethtool.c
+++ b/drivers/net/ethernet/intel/e1000e/ethtool.c
@@ -35,6 +35,7 @@
 #include <linux/slab.h>
 #include <linux/delay.h>
 #include <linux/vmalloc.h>
+#include <linux/pm_runtime.h>
 
 #include "e1000.h"
 
@@ -2053,7 +2054,19 @@ static int e1000_get_rxnfc(struct net_de
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
--- a/drivers/net/ethernet/intel/e1000e/netdev.c
+++ b/drivers/net/ethernet/intel/e1000e/netdev.c
@@ -4313,6 +4313,7 @@ static void e1000_phy_read_status(struct
 	    (adapter->hw.phy.media_type == e1000_media_type_copper)) {
 		int ret_val;
 
+		pm_runtime_get_sync(&adapter->pdev->dev);
 		ret_val  = e1e_rphy(hw, PHY_CONTROL, &phy->bmcr);
 		ret_val |= e1e_rphy(hw, PHY_STATUS, &phy->bmsr);
 		ret_val |= e1e_rphy(hw, PHY_AUTONEG_ADV, &phy->advertise);
@@ -4323,6 +4324,7 @@ static void e1000_phy_read_status(struct
 		ret_val |= e1e_rphy(hw, PHY_EXT_STATUS, &phy->estatus);
 		if (ret_val)
 			e_warn("Error reading PHY register\n");
+		pm_runtime_put_sync(&adapter->pdev->dev);
 	} else {
 		/* Do not read PHY registers if link is not up
 		 * Set values to typical power-on defaults


