Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934765Ab3DGX3x (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Apr 2013 19:29:53 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:46716 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S934750Ab3DGX3u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Apr 2013 19:29:50 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "Jakub Kicinski" <jakub.kicinski@intel.com>,
        "Jeff Kirsher" <jeffrey.t.kirsher@intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        "Phil Schmitt" <phillip.j.schmitt@intel.com>
Date: Sun, 07 Apr 2013 23:45:42 +0100
Message-ID: <lsq.1365374742.580855097@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [46/74] ixgbe: fix registration order of driver and DCA nofitication
In-Reply-To: <lsq.1365374742.214522651@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:b4b3:7e2a:e2d0:3478
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.43-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Jakub Kicinski <jakub.kicinski@intel.com>

commit f01fc1a82c2ee68726b400fadb156bd623b5f2f1 upstream.

ixgbe_notify_dca cannot be called before driver registration
because it expects driver's klist_devices to be allocated and
initialized. While on it make sure debugfs files are removed
when registration fails.

Signed-off-by: Jakub Kicinski <jakub.kicinski@intel.com>
Tested-by: Phil Schmitt <phillip.j.schmitt@intel.com>
Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
[bwh: Backported to 3.2: no debugfs support]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/net/ethernet/intel/ixgbe/ixgbe_main.c |   11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

--- a/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c
+++ b/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c
@@ -8003,12 +8003,15 @@ static int __init ixgbe_init_module(void
 	pr_info("%s - version %s\n", ixgbe_driver_string, ixgbe_driver_version);
 	pr_info("%s\n", ixgbe_copyright);
 
+	ret = pci_register_driver(&ixgbe_driver);
+	if (ret)
+		return ret;
+
 #ifdef CONFIG_IXGBE_DCA
 	dca_register_notify(&dca_notifier);
 #endif
 
-	ret = pci_register_driver(&ixgbe_driver);
-	return ret;
+	return 0;
 }
 
 module_init(ixgbe_init_module);

