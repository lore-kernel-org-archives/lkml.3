Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754561AbaAHBjc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jan 2014 20:39:32 -0500
Received: from mga09.intel.com ([134.134.136.24]:62954 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753284AbaAHBjZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jan 2014 20:39:25 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.95,621,1384329600"; 
   d="scan'208";a="463225483"
From: David Cohen <david.a.cohen@linux.intel.com>
To: gregkh@linuxfoundation.org, stern@rowland.harvard.edu,
        sarah.a.sharp@linux.intel.com
Cc: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        jianqian <jianqiang.tang@intel.com>,
        David Cohen <david.a.cohen@linux.intel.com>
Subject: [RFC/PATCH] usb/xhci: avoid kernel panic on xhci_suspend()
Date: Tue,  7 Jan 2014 17:44:26 -0800
Message-Id: <1389145466-8302-1-git-send-email-david.a.cohen@linux.intel.com>
X-Mailer: git-send-email 1.8.4.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: jianqian <jianqiang.tang@intel.com>

There is a possible kernel panic faced on xhci_suspend().
Due to kernel modified the hub autosupend_delay to 0s, after usb1 root
hub finishes initialization, it will trigger runtime_suspend and then
it will trigger xhci runtime suspend. But at that time, if
xhci->shared_hcd is still doing initialization, it is possible to face
null pointer kernel panic in xhci_suspend() function.

This patch checks if xhci->shared_hcd is null to avoid panic.

Signed-off-by: jianqian <jianqiang.tang@intel.com>
Signed-off-by: David Cohen <david.a.cohen@linux.intel.com>
---

This is the kernel panic. The bug was discovered on current LTS kernel 3.10, as
showed on logs. But the problem does not seem to be fixed so far.
Maybe we should consider apply it on kernel >= 3.10?

[    5.037841] usb usb1: New USB device found, idVendor=1d6b, idProduct=0002
[    5.037854] usb usb1: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    5.037864] usb usb1: Product: xHCI Host Controller
[    5.037875] usb usb1: Manufacturer: Linux 3.10.16-261428-g07aa93a xhci_hcd
[    5.037885] usb usb1: SerialNumber: 0000:00:14.0
[    5.038358] xHCI xhci_add_endpoint called for root hub
[    5.038365] xHCI xhci_check_bandwidth called for root hub
[    5.038553] hub 1-0:1.0: USB hub found
[    5.038587] hub 1-0:1.0: 6 ports detected
[    5.189460] BUG: unable to handle kernel NULL pointer dereference at 00000198
[    5.189485] IP: [<c17dd9d2>] xhci_suspend+0x22/0x2e0
[    5.189499] *pdpt = 0000000000000000 *pde = f000f3b5f000f3b0-
[    5.189514] Oops: 0000 [#1] PREEMPT SMP-
[    5.189524] Modules linked in:
[    5.189539] CPU: 3 PID: 67 Comm: kworker/3:1 Not tainted 3.10.16-261428-g07aa93a #39
[    5.189558] Workqueue: pm pm_runtime_work
[    5.189565] task: f2be5fa0 ti: f26d0000 task.ti: f26d0000
[    5.189576] EIP: 0060:[<c17dd9d2>] EFLAGS: 00010246 CPU: 3
[    5.189587] EIP is at xhci_suspend+0x22/0x2e0
[    5.189594] EAX: 00000000 EBX: f2738a00 ECX: c17eb820 EDX: 00000001
[    5.189602] ESI: f2721000 EDI: f3054064 EBP: f26d1da4 ESP: f26d1d84
[    5.189611]  DS: 007b ES: 007b FS: 00d8 GS: 0000 SS: 0068
[    5.189619] CR0: 8005003b CR2: 00000198 CR3: 020fa000 CR4: 001007f0
[    5.189626] DR0: 00000000 DR1: 00000000 DR2: 00000000 DR3: 00000000
[    5.189632] DR6: ffff0ff0 DR7: 00000400
[    5.189636] Stack:
[    5.189668]  f26b0b90 f26d1da4 c1af6a35 f2738a00 c1fdcba4 f3054064 f2721000 f3054064
[    5.189697]  f26d1db4 c17eb84d 00000000 f2738a00 f26d1dd0 c17c40d8 00000001 f26d1dd8
[    5.189726]  f3054064 f30540d4 c1b8fbc0 f26d1df4 c17c41b3 f26d1e0c c1255fbc 00000000
[    5.189730] Call Trace:
[    5.189752]  [<c1af6a35>] ? sub_preempt_count+0x55/0xe0
[    5.189773]  [<c17eb84d>] xhci_pci_suspend+0x2d/0x40
[    5.189792]  [<c17c40d8>] suspend_common+0x98/0x150
[    5.189810]  [<c17c41b3>] hcd_pci_runtime_suspend+0x23/0x60
[    5.189827]  [<c1255fbc>] ? __queue_work+0x10c/0x2f0
[    5.189842]  [<c17b9b75>] ? usb_suspend_both+0x135/0x1a0
[    5.189861]  [<c155ea34>] pci_pm_runtime_suspend+0x54/0x110
[    5.189875]  [<c1af6a35>] ? sub_preempt_count+0x55/0xe0
[    5.189894]  [<c155e9e0>] ? pci_pm_runtime_resume+0xb0/0xb0
[    5.189907]  [<c16a84ff>] __rpm_callback+0x2f/0x80
[    5.189922]  [<c16a8578>] rpm_callback+0x28/0x80
[    5.189937]  [<c16a86d0>] rpm_suspend+0x100/0x5f0
[    5.189956]  [<c16a9b51>] __pm_runtime_suspend+0x41/0x80
[    5.189972]  [<c155e8a0>] ? pci_uevent+0x120/0x120
[    5.189988]  [<c155e8d8>] pci_pm_runtime_idle+0x38/0x50
[    5.190002]  [<c16a84ff>] __rpm_callback+0x2f/0x80
[    5.190016]  [<c16a8d41>] rpm_idle+0x101/0x230
[    5.190032]  [<c16a9cd2>] pm_runtime_work+0x92/0xb0
[    5.190048]  [<c125668d>] process_one_work+0x11d/0x3d0
[    5.190062]  [<c1af6b3d>] ? add_preempt_count+0x7d/0xf0
[    5.190076]  [<c1af6a35>] ? sub_preempt_count+0x55/0xe0
[    5.190093]  [<c1256d19>] worker_thread+0xf9/0x320
[    5.190109]  [<c1af3676>] ? _raw_spin_unlock_irqrestore+0x26/0x50
[    5.190126]  [<c1256c20>] ? rescuer_thread+0x2b0/0x2b0
[    5.190140]  [<c125c7f4>] kthread+0x94/0xa0
[    5.190154]  [<c1af6a35>] ? sub_preempt_count+0x55/0xe0
[    5.190177]  [<c1af9f37>] ret_from_kernel_thread+0x1b/0x28
[    5.190190]  [<c125c760>] ? kthread_create_on_node+0xc0/0xc0
[    5.190377] Code: 00 00 8d bc 27 00 00 00 00 55 89 e5 57 56 53 83 ec 14 3e 8d 74 26 00 8b 18 89 c6 83 bb 98 01 00 00 04 0f 85 79 02 00 00 8b 40 04 <83> b8 98 01 00 00 04 0f 85 69 02 00 00 f0 80 a3 58 01 00 00 fb   
[    5.190396] EIP: [<c17dd9d2>] xhci_suspend+0x22/0x2e0 SS:ESP 0068:f26d1d84
[    5.190401] CR2: 0000000000000198
[    5.190440] ---[ end trace b828c61ee573eafd ]---
[    5.196507] Kernel panic - not syncing: Fatal exception
[    5.567347] Rebooting in 40 seconds..
[   45.589915] ACPI MEMORY or I/O RESET_REG.

 drivers/usb/host/xhci.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/drivers/usb/host/xhci.c b/drivers/usb/host/xhci.c
index f052272b25c8..97c1d58f7baf 100644
--- a/drivers/usb/host/xhci.c
+++ b/drivers/usb/host/xhci.c
@@ -853,7 +853,14 @@ int xhci_suspend(struct xhci_hcd *xhci)
 	struct usb_hcd		*hcd = xhci_to_hcd(xhci);
 	u32			command;
 
-	if (hcd->state != HC_STATE_SUSPENDED ||
+	/*
+	 * Need to check if xhci->shared_hcd is null to avoid kernel panic when
+	 * boot up and xhci did not allocate xhci->shared_hcd yet.
+	 * Due to autosuspend_delay set to 0, after usb1 finishes probe, xhci
+	 * runtime suspend will trigger immediately, but xhci->shared_hcd may
+	 * not be initialized yet.
+	 */
+	if (hcd->state != HC_STATE_SUSPENDED || !xhci->shared_hcd ||
 			xhci->shared_hcd->state != HC_STATE_SUSPENDED)
 		return -EINVAL;
 
-- 
1.8.4.2

