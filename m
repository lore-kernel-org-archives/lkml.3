Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754118AbaFXOES (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jun 2014 10:04:18 -0400
Received: from mga11.intel.com ([192.55.52.93]:25083 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753886AbaFXOEO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jun 2014 10:04:14 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,538,1400050800"; 
   d="scan'208";a="560222845"
From: Mathias Nyman <mathias.nyman@linux.intel.com>
To: <gregkh@linuxfoundation.org>
Cc: <linux-usb@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <dan.j.williams@intel.com>, Lu Baolu <baolu.lu@linux.intel.com>,
        stable@vger.kernel.org, Mathias Nyman <mathias.nyman@linux.intel.com>
Subject: [PATCH 4/5] xhci: clear root port wake on bits if controller isn't wake-up capable
Date: Tue, 24 Jun 2014 17:14:43 +0300
Message-Id: <1403619322-24704-4-git-send-email-mathias.nyman@linux.intel.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1403619322-24704-1-git-send-email-mathias.nyman@linux.intel.com>
References: <1403618059-24533-1-git-send-email-mathias.nyman@linux.intel.com>
 <1403619322-24704-1-git-send-email-mathias.nyman@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Lu Baolu <baolu.lu@linux.intel.com>

When xHCI PCI host is suspended, if do_wakeup is false in xhci_pci_suspend,
xhci_bus_suspend needs to clear all root port wake on bits. Otherwise some Intel
platforms may get a spurious wakeup, even if PCI PME# is disabled.

This patch should be back-ported to kernels as old as 2.6.37, that
contains the commit 9777e3ce907d4cb5a513902a87ecd03b52499569
"USB: xHCI: bus power management implementation".

Cc: stable@vger.kernel.org # 2.6.37
Signed-off-by: Lu Baolu <baolu.lu@linux.intel.com>
Signed-off-by: Mathias Nyman <mathias.nyman@linux.intel.com>
---
 drivers/usb/host/xhci-hub.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/usb/host/xhci-hub.c b/drivers/usb/host/xhci-hub.c
index 2b998c6..aa79e87 100644
--- a/drivers/usb/host/xhci-hub.c
+++ b/drivers/usb/host/xhci-hub.c
@@ -22,6 +22,7 @@
 
 
 #include <linux/slab.h>
+#include <linux/device.h>
 #include <asm/unaligned.h>
 
 #include "xhci.h"
@@ -1139,7 +1140,9 @@ int xhci_bus_suspend(struct usb_hcd *hcd)
 		 * including the USB 3.0 roothub, but only if CONFIG_PM_RUNTIME
 		 * is enabled, so also enable remote wake here.
 		 */
-		if (hcd->self.root_hub->do_remote_wakeup) {
+		if (hcd->self.root_hub->do_remote_wakeup
+				&& device_may_wakeup(hcd->self.controller)) {
+
 			if (t1 & PORT_CONNECT) {
 				t2 |= PORT_WKOC_E | PORT_WKDISC_E;
 				t2 &= ~PORT_WKCONN_E;
-- 
1.8.3.2

