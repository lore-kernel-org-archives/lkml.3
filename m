Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754171AbaFXOEX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jun 2014 10:04:23 -0400
Received: from mga11.intel.com ([192.55.52.93]:25111 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754125AbaFXOEU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jun 2014 10:04:20 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,538,1400050800"; 
   d="scan'208";a="560222894"
From: Mathias Nyman <mathias.nyman@linux.intel.com>
To: <gregkh@linuxfoundation.org>
Cc: <linux-usb@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <dan.j.williams@intel.com>, "Wang, Yu" <yu.y.wang@intel.com>,
        stable@vger.kernel.org, Mathias Nyman <mathias.nyman@linux.intel.com>
Subject: [PATCH 5/5] xhci: Fix runtime suspended xhci from blocking system suspend.
Date: Tue, 24 Jun 2014 17:14:44 +0300
Message-Id: <1403619322-24704-5-git-send-email-mathias.nyman@linux.intel.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1403619322-24704-1-git-send-email-mathias.nyman@linux.intel.com>
References: <1403618059-24533-1-git-send-email-mathias.nyman@linux.intel.com>
 <1403619322-24704-1-git-send-email-mathias.nyman@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Wang, Yu" <yu.y.wang@intel.com>

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

Cc: stable@vger.kernel.org # 3.2
Signed-off-by: Wang, Yu <yu.y.wang@intel.com>
Acked-by: Alan Stern <stern@rowland.harvard.edu>
[use readl() instead of removed xhci_readl(), reword commit message -Mathias]
Signed-off-by: Mathias Nyman <mathias.nyman@linux.intel.com>
---
 drivers/usb/host/xhci.c | 10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

diff --git a/drivers/usb/host/xhci.c b/drivers/usb/host/xhci.c
index 013aabb..f07be65 100644
--- a/drivers/usb/host/xhci.c
+++ b/drivers/usb/host/xhci.c
@@ -936,7 +936,7 @@ int xhci_suspend(struct xhci_hcd *xhci)
  */
 int xhci_resume(struct xhci_hcd *xhci, bool hibernated)
 {
-	u32			command, temp = 0;
+	u32			command, temp = 0, status;
 	struct usb_hcd		*hcd = xhci_to_hcd(xhci);
 	struct usb_hcd		*secondary_hcd;
 	int			retval = 0;
@@ -1054,8 +1054,12 @@ int xhci_resume(struct xhci_hcd *xhci, bool hibernated)
 
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
-- 
1.8.3.2

