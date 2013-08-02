Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752783Ab3HBKST (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Aug 2013 06:18:19 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:37617 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751415Ab3HBKSQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Aug 2013 06:18:16 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Sarah Sharp <sarah.a.sharp@linux.intel.com>,
        Vincent Thiele <vincentthiele@gmail.com>
Subject: [ 10/39] xhci: Avoid NULL pointer deref when host dies.
Date: Fri,  2 Aug 2013 18:18:20 +0800
Message-Id: <20130802101458.260672812@linuxfoundation.org>
X-Mailer: git-send-email 1.8.3.4.841.g1a3f60e
In-Reply-To: <20130802101456.800497005@linuxfoundation.org>
References: <20130802101456.800497005@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/usb/host/xhci.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/drivers/usb/host/xhci.c
+++ b/drivers/usb/host/xhci.c
@@ -1162,9 +1162,6 @@ static int xhci_check_args(struct usb_hc
 	}
 
 	xhci = hcd_to_xhci(hcd);
-	if (xhci->xhc_state & XHCI_STATE_HALTED)
-		return -ENODEV;
-
 	if (check_virt_dev) {
 		if (!udev->slot_id || !xhci->devs[udev->slot_id]) {
 			printk(KERN_DEBUG "xHCI %s called with unaddressed "
@@ -1180,6 +1177,9 @@ static int xhci_check_args(struct usb_hc
 		}
 	}
 
+	if (xhci->xhc_state & XHCI_STATE_HALTED)
+		return -ENODEV;
+
 	return 1;
 }
 


