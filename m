Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754145Ab3BCOz6 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Feb 2013 09:55:58 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:34254 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754118Ab3BCOzy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Feb 2013 09:55:54 -0500
Message-Id: <20130203144648.078523335@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Sun, 03 Feb 2013 15:47:29 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: akpm@linux-foundation.org,
        Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>,
        Jesse Barnes <jbarnes@virtuousgeek.org>
Subject: [ 045/128] PCI: pciehp: Fix wrong workqueue cleanup
In-Reply-To: <20130203144644.035172954@decadent.org.uk>
X-SA-Exim-Connect-IP: 151.216.67.5
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>

commit 027e8d52abdd44bc00e405af83cd2fbfb96c0824 upstream.

Fix improper workqueue cleanup.

In the current pciehp, pcied_cleanup() calls destroy_workqueue()
before calling pcie_port_service_unregister(). This causes kernel oops
because flush_workqueue() is called in the pcie_port_service_unregister()
code path after the workqueue was destroyed. So pcied_cleanup() must call
pcie_port_service_unregister() first before calling destroy_workqueue().

Signed-off-by: Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>
Signed-off-by: Jesse Barnes <jbarnes@virtuousgeek.org>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/pci/hotplug/pciehp_core.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/pci/hotplug/pciehp_core.c b/drivers/pci/hotplug/pciehp_core.c
index 7ac8358..a13ad13 100644
--- a/drivers/pci/hotplug/pciehp_core.c
+++ b/drivers/pci/hotplug/pciehp_core.c
@@ -366,9 +366,9 @@ static int __init pcied_init(void)
 static void __exit pcied_cleanup(void)
 {
 	dbg("unload_pciehpd()\n");
+	pcie_port_service_unregister(&hpdriver_portdrv);
 	destroy_workqueue(pciehp_ordered_wq);
 	destroy_workqueue(pciehp_wq);
-	pcie_port_service_unregister(&hpdriver_portdrv);
 	info(DRIVER_DESC " version: " DRIVER_VERSION " unloaded\n");
 }
 


