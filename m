Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755242Ab3ARLmX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jan 2013 06:42:23 -0500
Received: from mail-la0-f41.google.com ([209.85.215.41]:56299 "EHLO
	mail-la0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753846Ab3ARLmT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jan 2013 06:42:19 -0500
Subject: [PATCH 1/5] e1000e: fix resuming from runtime-suspend
To: linux-kernel@vger.kernel.org
From: Konstantin Khlebnikov <khlebnikov@openvz.org>
Cc: e1000-devel@lists.sourceforge.net, linux-pci@vger.kernel.org,
        Bruce Allan <bruce.w.allan@intel.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Date: Fri, 18 Jan 2013 15:42:14 +0400
Message-ID: <20130118114214.6698.24975.stgit@zurg>
In-Reply-To: <20130118113019.6698.25941.stgit@zurg>
References: <20130118113019.6698.25941.stgit@zurg>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Bug was introduced in commit 23606cf5d1192c2b17912cb2ef6e62f9b11de133
("e1000e / PCI / PM: Add basic runtime PM support (rev. 4)") in v2.6.35

Signed-off-by: Konstantin Khlebnikov <khlebnikov@openvz.org>
Cc: e1000-devel@lists.sourceforge.net
Cc: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Cc: Bruce Allan <bruce.w.allan@intel.com>
---
 drivers/net/ethernet/intel/e1000e/netdev.c |   13 ++++++++-----
 1 file changed, 8 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/intel/e1000e/netdev.c b/drivers/net/ethernet/intel/e1000e/netdev.c
index fbf75fd..2853c11 100644
--- a/drivers/net/ethernet/intel/e1000e/netdev.c
+++ b/drivers/net/ethernet/intel/e1000e/netdev.c
@@ -5691,14 +5691,17 @@ static int e1000_runtime_suspend(struct device *dev)
 	struct pci_dev *pdev = to_pci_dev(dev);
 	struct net_device *netdev = pci_get_drvdata(pdev);
 	struct e1000_adapter *adapter = netdev_priv(netdev);
+	int retval;
+	bool wake;
 
-	if (e1000e_pm_ready(adapter)) {
-		bool wake;
+	if (!e1000e_pm_ready(adapter))
+		return 0;
 
-		__e1000_shutdown(pdev, &wake, true);
-	}
+	retval = __e1000_shutdown(pdev, &wake, true);
+	if (!retval)
+		e1000_power_off(pdev, true, wake);
 
-	return 0;
+	return retval;
 }
 
 static int e1000_idle(struct device *dev)

