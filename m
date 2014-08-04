Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754123AbaHDROb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2014 13:14:31 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:56467 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751742AbaHDQty (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2014 12:49:54 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "Mathias Nyman" <mathias.nyman@linux.intel.com>,
        "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>,
        "Lu Baolu" <baolu.lu@linux.intel.com>
Date: Mon, 04 Aug 2014 17:48:31 +0100
Message-ID: <lsq.1407170911.367600766@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [PATCH 3.2 10/94] xhci: clear root port wake on bits if
 controller isn't wake-up capable
In-Reply-To: <lsq.1407170911.107020799@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.249
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.62-rc1 review patch.  If anyone has any objections, please let me know.

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
[bwh: Backported to 3.2: adjust context]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/usb/host/xhci-hub.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/drivers/usb/host/xhci-hub.c
+++ b/drivers/usb/host/xhci-hub.c
@@ -21,6 +21,7 @@
  */
 
 #include <linux/gfp.h>
+#include <linux/device.h>
 #include <asm/unaligned.h>
 
 #include "xhci.h"
@@ -993,7 +994,9 @@ int xhci_bus_suspend(struct usb_hcd *hcd
 			t2 |= PORT_LINK_STROBE | XDEV_U3;
 			set_bit(port_index, &bus_state->bus_suspended);
 		}
-		if (hcd->self.root_hub->do_remote_wakeup) {
+		if (hcd->self.root_hub->do_remote_wakeup
+				&& device_may_wakeup(hcd->self.controller)) {
+
 			if (t1 & PORT_CONNECT) {
 				t2 |= PORT_WKOC_E | PORT_WKDISC_E;
 				t2 &= ~PORT_WKCONN_E;

