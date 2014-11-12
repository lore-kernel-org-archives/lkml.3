Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752898AbaKLO6Z (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Nov 2014 09:58:25 -0500
Received: from devils.ext.ti.com ([198.47.26.153]:49615 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752409AbaKLO6W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Nov 2014 09:58:22 -0500
From: Roger Quadros <rogerq@ti.com>
To: <balbi@ti.com>
CC: <linux-usb@vger.kernel.org>, <linux-omap@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, Roger Quadros <rogerq@ti.com>
Subject: [PATCH] usb: dwc3: gadget: Fix broken gadget on system suspend/resume
Date: Wed, 12 Nov 2014 16:58:16 +0200
Message-ID: <1415804296-28980-1-git-send-email-rogerq@ti.com>
X-Mailer: git-send-email 1.8.3.2
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On TI SoCs (e.g. DRA7) we don't support the DWC3 hibernation feature.
We need to stop the gadget controller while system suspend
else it results in L3 Bus errors on resume with broken
USB gadget on J6-evm.

[   55.718226] WARNING: CPU: 0 PID: 0 at drivers/bus/omap_l3_noc.c:147 l3_interrupt_handler+0x224/0x31c()
[   55.718232] 44000000.ocp:L3 Custom Error: MASTER USB3 TARGET GPMC (Idle): Data Access in User mode during Functional access
[   55.718263] Modules linked in: usb_f_ss_lb g_zero libcomposite configfs xhci_hcd btwilink bluetooth dwc3 6lowpan_iphc m25p80 dwc3_omap omap_remoteproc
[   55.718271] CPU: 0 PID: 0 Comm: swapper/0 Not tainted 3.14.19-02011-g3ece3ca-dirty #658
[   55.718290] [<c0016090>] (unwind_backtrace) from [<c0012060>] (show_stack+0x10/0x14)
[   55.718302] [<c0012060>] (show_stack) from [<c062a2e4>] (dump_stack+0x78/0x94)
[   55.718315] [<c062a2e4>] (dump_stack) from [<c0043bc4>] (warn_slowpath_common+0x6c/0x90)
[   55.718325] [<c0043bc4>] (warn_slowpath_common) from [<c0043c7c>] (warn_slowpath_fmt+0x30/0x40)
[   55.718336] [<c0043c7c>] (warn_slowpath_fmt) from [<c030fb24>] (l3_interrupt_handler+0x224/0x31c)
[   55.718348] [<c030fb24>] (l3_interrupt_handler) from [<c0093010>] (handle_irq_event_percpu+0x5c/0x23c)
[   55.718358] [<c0093010>] (handle_irq_event_percpu) from [<c009322c>] (handle_irq_event+0x3c/0x5c)
[   55.718367] [<c009322c>] (handle_irq_event) from [<c0096160>] (handle_fasteoi_irq+0x98/0x158)
[   55.718377] [<c0096160>] (handle_fasteoi_irq) from [<c00929dc>] (generic_handle_irq+0x20/0x30)
[   55.718385] [<c00929dc>] (generic_handle_irq) from [<c000eea8>] (handle_IRQ+0x4c/0xb0)
[   55.718393] [<c000eea8>] (handle_IRQ) from [<c0008638>] (gic_handle_irq+0x28/0x5c)
[   55.718402] [<c0008638>] (gic_handle_irq) from [<c0630964>] (__irq_svc+0x44/0x5c)
[   55.718406] Exception stack(0xc09c1f68 to 0xc09c1fb0)
[   55.718412] 1f60:                   00000001 00000001 00000000 00000000 c09c0000 00000000
[   55.718418] 1f80: c09c0000 c09c0000 c0a7a1e4 c09c8938 c09c89b4 00000000 60000093 c09c1fb0
[   55.718423] 1fa0: c008a2e4 c00926cc 60000013 ffffffff
[   55.718433] [<c0630964>] (__irq_svc) from [<c00926cc>] (cpu_startup_entry+0x100/0x1f4)
[   55.718444] [<c00926cc>] (cpu_startup_entry) from [<c0901ac4>] (start_kernel+0x324/0x388)

Signed-off-by: Roger Quadros <rogerq@ti.com>
---
 drivers/usb/dwc3/gadget.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/drivers/usb/dwc3/gadget.c b/drivers/usb/dwc3/gadget.c
index 3818b26..bc15b54 100644
--- a/drivers/usb/dwc3/gadget.c
+++ b/drivers/usb/dwc3/gadget.c
@@ -2741,7 +2741,13 @@ int dwc3_gadget_prepare(struct dwc3 *dwc)
 {
 	if (dwc->pullups_connected) {
 		dwc3_gadget_disable_irq(dwc);
-		dwc3_gadget_run_stop(dwc, true, true);
+		if (dwc->has_hibernation) {
+			dwc3_gadget_run_stop(dwc, true, true);
+		} else {
+			dwc3_gadget_run_stop(dwc, false, true);
+			/* remember to connect back on resume */
+			dwc->pullups_connected = true;
+		}
 	}
 
 	return 0;
-- 
1.8.3.2

