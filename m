Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756539Ab3IKQ4r (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Sep 2013 12:56:47 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:10471 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755840Ab3IKQ4p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Sep 2013 12:56:45 -0400
X-Authority-Analysis: v=2.0 cv=fJG7LOme c=1 sm=0 a=Sro2XwOs0tJUSHxCKfOySw==:17 a=Drc5e87SC40A:10 a=Ciwy3NGCPMMA:10 a=t92CcgBTxfYA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=KGjhK52YXX0A:10 a=Q_JOoKIhBj4A:10 a=QyXUC8HyAAAA:8 a=danhDmx_AAAA:8 a=pGLkceISAAAA:8 a=VwQbUJbxAAAA:8 a=YvvtDKI0yuXd4OQGLbAA:9 a=MSl-tDqOz04A:10 a=jeBq3FmKZ4MA:10 a=Sro2XwOs0tJUSHxCKfOySw==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 67.255.60.225
Message-Id: <20130911042906.604565744@goodmis.org>
User-Agent: quilt/0.60-1
Date: Wed, 11 Sep 2013 00:28:33 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Sarah Sharp <sarah.a.sharp@linux.intel.com>,
        Vincent Thiele <vincentthiele@gmail.com>
Subject: [086/251] xhci: Avoid NULL pointer deref when host dies.
References: <20130911042707.738353451@goodmis.org>
Content-Disposition: inline; filename=0086-xhci-Avoid-NULL-pointer-deref-when-host-dies.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6.11.9-rc1 stable review patch.
If anyone has any objections, please let me know.

------------------

From: Sarah Sharp <sarah.a.sharp@linux.intel.com>

[ Upstream commit 203a86613fb3bf2767335659513fa98563a3eb71 ]

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
Cc: stable@vger.kernel.org
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 drivers/usb/host/xhci.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/usb/host/xhci.c b/drivers/usb/host/xhci.c
index bb8b3a5..a37f20d 100644
--- a/drivers/usb/host/xhci.c
+++ b/drivers/usb/host/xhci.c
@@ -1152,9 +1152,6 @@ static int xhci_check_args(struct usb_hcd *hcd, struct usb_device *udev,
 	}
 
 	xhci = hcd_to_xhci(hcd);
-	if (xhci->xhc_state & XHCI_STATE_HALTED)
-		return -ENODEV;
-
 	if (check_virt_dev) {
 		if (!udev->slot_id || !xhci->devs[udev->slot_id]) {
 			printk(KERN_DEBUG "xHCI %s called with unaddressed "
@@ -1170,6 +1167,9 @@ static int xhci_check_args(struct usb_hcd *hcd, struct usb_device *udev,
 		}
 	}
 
+	if (xhci->xhc_state & XHCI_STATE_HALTED)
+		return -ENODEV;
+
 	return 1;
 }
 
-- 
1.7.10.4


