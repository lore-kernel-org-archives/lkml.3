Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758132AbaHHUsE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Aug 2014 16:48:04 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:40635 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758113AbaHHUr7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Aug 2014 16:47:59 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Lu Baolu <baolu.lu@linux.intel.com>,
        Mathias Nyman <mathias.nyman@linux.intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13 031/259] xhci: clear root port wake on bits if controller isn't wake-up capable
Date: Fri,  8 Aug 2014 13:37:34 -0700
Message-Id: <1407530482-4483-32-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1407530482-4483-1-git-send-email-kamal@canonical.com>
References: <1407530482-4483-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11.6 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Lu Baolu <baolu.lu@linux.intel.com>

commit ff8cbf250b448aac35589f6075082c3fcad8a8fe upstream.

When xHCI PCI host is suspended, if do_wakeup is false in xhci_pci_suspend,
xhci_bus_suspend needs to clear all root port wake on bits. Otherwise some Intel
platforms may get a spurious wakeup, even if PCI PME# is disabled.

This patch should be back-ported to kernels as old as 2.6.37, that
contains the commit 9777e3ce907d4cb5a513902a87ecd03b52499569
"USB: xHCI: bus power management implementation".

Signed-off-by: Lu Baolu <baolu.lu@linux.intel.com>
Signed-off-by: Mathias Nyman <mathias.nyman@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/usb/host/xhci-hub.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/usb/host/xhci-hub.c b/drivers/usb/host/xhci-hub.c
index 805f234..d0997e3 100644
--- a/drivers/usb/host/xhci-hub.c
+++ b/drivers/usb/host/xhci-hub.c
@@ -21,6 +21,7 @@
  */
 
 #include <linux/gfp.h>
+#include <linux/device.h>
 #include <asm/unaligned.h>
 
 #include "xhci.h"
@@ -1144,7 +1145,9 @@ int xhci_bus_suspend(struct usb_hcd *hcd)
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

