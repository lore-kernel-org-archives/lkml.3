Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753990AbaHDRMa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2014 13:12:30 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:56492 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751841AbaHDQty (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2014 12:49:54 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org,
        "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>,
        "Alan Stern" <stern@rowland.harvard.edu>,
        "Wang, Yu" <yu.y.wang@intel.com>,
        "Mathias Nyman" <mathias.nyman@linux.intel.com>
Date: Mon, 04 Aug 2014 17:48:31 +0100
Message-ID: <lsq.1407170911.922083401@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [PATCH 3.2 11/94] xhci: Fix runtime suspended xhci from blocking
 system suspend.
In-Reply-To: <lsq.1407170911.107020799@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.249
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.62-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: "Wang, Yu" <yu.y.wang@intel.com>

commit d6236f6d1d885aa19d1cd7317346fe795227a3cc upstream.

The system suspend flow as following:
1, Freeze all user processes and kenrel threads.

2, Try to suspend all devices.

2.1, If pci device is in RPM suspended state, then pci driver will try
to resume it to RPM active state in the prepare stage.

2.2, xhci_resume function calls usb_hcd_resume_root_hub to queue two
workqueue items to resume usb2&usb3 roothub devices.

2.3, Call suspend callbacks of devices.

2.3.1, All suspend callbacks of all hcd's children, including
roothub devices are called.

2.3.2, Finally, hcd_pci_suspend callback is called.

Due to workqueue threads were already frozen in step 1, the workqueue
items can't be scheduled, and the roothub devices can't be resumed in
this flow. The HCD_FLAG_WAKEUP_PENDING flag which is set in
usb_hcd_resume_root_hub won't be cleared. Finally,
hcd_pci_suspend will return -EBUSY, and system suspend fails.

The reason why this issue doesn't show up very often is due to that
choose_wakeup will be called in step 2.3.1. In step 2.3.1, if
udev->do_remote_wakeup is not equal to device_may_wakeup(&udev->dev), then
udev will resume to RPM active for changing the wakeup settings. This
has been a lucky hit which hides this issue.

For some special xHCI controllers which have no USB2 port, then roothub
will not match hub driver due to probe failed. Then its
do_remote_wakeup will be set to zero, and we won't be as lucky.

xhci driver doesn't need to resume roothub devices everytime like in
the above case. It's only needed when there are pending event TRBs.

This patch should be back-ported to kernels as old as 3.2, that
contains the commit f69e3120df82391a0ee8118e0a156239a06b2afb
"USB: XHCI: resume root hubs when the controller resumes"

Signed-off-by: Wang, Yu <yu.y.wang@intel.com>
Acked-by: Alan Stern <stern@rowland.harvard.edu>
[use readl() instead of removed xhci_readl(), reword commit message -Mathias]
Signed-off-by: Mathias Nyman <mathias.nyman@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/usb/host/xhci.c | 10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

--- a/drivers/usb/host/xhci.c
+++ b/drivers/usb/host/xhci.c
@@ -946,7 +946,7 @@ int xhci_suspend(struct xhci_hcd *xhci)
  */
 int xhci_resume(struct xhci_hcd *xhci, bool hibernated)
 {
-	u32			command, temp = 0;
+	u32			command, temp = 0, status;
 	struct usb_hcd		*hcd = xhci_to_hcd(xhci);
 	struct usb_hcd		*secondary_hcd;
 	int			retval = 0;
@@ -1070,8 +1070,12 @@ int xhci_resume(struct xhci_hcd *xhci, b
 
  done:
 	if (retval == 0) {
-		usb_hcd_resume_root_hub(hcd);
-		usb_hcd_resume_root_hub(xhci->shared_hcd);
+		/* Resume root hubs only when have pending events. */
+		status = readl(&xhci->op_regs->status);
+		if (status & STS_EINT) {
+			usb_hcd_resume_root_hub(hcd);
+			usb_hcd_resume_root_hub(xhci->shared_hcd);
+		}
 	}
 
 	/*

