Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755391AbaFKGZ6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jun 2014 02:25:58 -0400
Received: from mga01.intel.com ([192.55.52.88]:42517 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750825AbaFKGZ5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jun 2014 02:25:57 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,456,1400050800"; 
   d="scan'208";a="546119530"
From: Lu Baolu <baolu.lu@linux.intel.com>
To: Mathias Nyman <mathias.nyman@intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        Lu Baolu <baolu.lu@linux.intel.com>
Subject: [PATCH 1/1] xhci: clear root port wake on bits if controller isn't wake-up capable
Date: Wed, 11 Jun 2014 06:25:20 +0800
Message-Id: <1402439120-78151-1-git-send-email-baolu.lu@linux.intel.com>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When the xHCI PCI host is suspended, if do_wakeup is false in xhci_pci_suspend,
xhci_bus_suspend needs to clear all root port wake on bits. Otherwise some Intel
platform may get a spurious wakeup, even if PCI PME# is disabled.

http://marc.info/?l=linux-usb&m=138194006009255&w=2

Signed-off-by: Lu Baolu <baolu.lu@linux.intel.com>
---
 drivers/usb/host/xhci-hub.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/usb/host/xhci-hub.c b/drivers/usb/host/xhci-hub.c
index 6231ce6..fb771bd 100644
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
1.9.1

