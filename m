Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752336Ab3HPX5t (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Aug 2013 19:57:49 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:51846 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757119Ab3HPWky (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Aug 2013 18:40:54 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Sarah Sharp <sarah.a.sharp@linux.intel.com>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 034/133] xhci: Avoid NULL pointer deref when host dies.
Date: Fri, 16 Aug 2013 15:32:56 -0700
Message-Id: <1376692475-28413-35-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1376692475-28413-1-git-send-email-kamal@canonical.com>
References: <1376692475-28413-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.7 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sarah Sharp <sarah.a.sharp@linux.intel.com>

commit 203a86613fb3bf2767335659513fa98563a3eb71 upstream.

When the host controller fails to respond to an Enable Slot command, and
the host fails to respond to the register write to abort the command
ring, the xHCI driver will assume the host is dead, and call
usb_hc_died().

The USB device's slot_id is still set to zero, and the pointer stored at
xhci->devs[0] will always be NULL.  The call to xhci_check_args in
xhci_free_dev should have caught the NULL virt_dev pointer.

However, xhci_free_dev is designed to free the xhci_virt_device
structures, even if the host is dead, so that we don't leak kernel
memory.  xhci_free_dev checks the return value from the generic
xhci_check_args function.  If the return value is -ENODEV, it carries on
trying to free the virtual device.

The issue is that xhci_check_args looks at the host controller state
before it looks at the xhci_virt_device pointer.  It will return -ENIVAL
because the host is dead, and xhci_free_dev will ignore the return
value, and happily dereference the NULL xhci_virt_device pointer.

The fix is to make sure that xhci_check_args checks the xhci_virt_device
pointer before it checks the host state.

See https://bugs.launchpad.net/ubuntu/+source/linux/+bug/1203453 for
further details.  This patch doesn't solve the underlying issue, but
will ensure we don't see any more NULL pointer dereferences because of
the issue.

This patch should be backported to kernels as old as 3.1, that
contain the commit 7bd89b4017f46a9b92853940fd9771319acb578a "xhci: Don't
submit commands or URBs to halted hosts."

Signed-off-by: Sarah Sharp <sarah.a.sharp@linux.intel.com>
Reported-by: Vincent Thiele <vincentthiele@gmail.com>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/usb/host/xhci.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/usb/host/xhci.c b/drivers/usb/host/xhci.c
index 7f6de85..6cffc0e 100644
--- a/drivers/usb/host/xhci.c
+++ b/drivers/usb/host/xhci.c
@@ -1167,9 +1167,6 @@ static int xhci_check_args(struct usb_hcd *hcd, struct usb_device *udev,
 	}
 
 	xhci = hcd_to_xhci(hcd);
-	if (xhci->xhc_state & XHCI_STATE_HALTED)
-		return -ENODEV;
-
 	if (check_virt_dev) {
 		if (!udev->slot_id || !xhci->devs[udev->slot_id]) {
 			printk(KERN_DEBUG "xHCI %s called with unaddressed "
@@ -1185,6 +1182,9 @@ static int xhci_check_args(struct usb_hcd *hcd, struct usb_device *udev,
 		}
 	}
 
+	if (xhci->xhc_state & XHCI_STATE_HALTED)
+		return -ENODEV;
+
 	return 1;
 }
 
-- 
1.8.1.2

