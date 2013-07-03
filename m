Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964953Ab3GCSmw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Jul 2013 14:42:52 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:28092 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933314Ab3GCSlM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Jul 2013 14:41:12 -0400
X-Authority-Analysis: v=2.0 cv=Du3UCRD+ c=1 sm=0 a=Sro2XwOs0tJUSHxCKfOySw==:17 a=Drc5e87SC40A:10 a=Ciwy3NGCPMMA:10 a=0z9ih4_w9wEA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=KGjhK52YXX0A:10 a=sbKqkV-DZv4A:10 a=QyXUC8HyAAAA:8 a=VwQbUJbxAAAA:8 a=Jj8_vlwduAJDXrguktAA:9 a=dGJ0OcVc7YAA:10 a=jeBq3FmKZ4MA:10 a=Sro2XwOs0tJUSHxCKfOySw==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 67.255.60.225
Message-Id: <20130703184056.076913609@goodmis.org>
User-Agent: quilt/0.60-1
Date: Wed, 03 Jul 2013 14:40:06 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Sergio Aguirre <sergio.a.aguirre.rodriguez@intel.com>,
        David Cohen <david.a.cohen@intel.com>,
        Sarah Sharp <sarah.a.sharp@linux.intel.com>
Subject: [069/141] xhci-mem: init list heads at the beginning of init
References: <20130703183857.307196999@goodmis.org>
Content-Disposition: inline; filename=0069-xhci-mem-init-list-heads-at-the-beginning-of-init.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6.11.6 stable review patch.
If anyone has any objections, please let me know.

------------------

From: Sergio Aguirre <sergio.a.aguirre.rodriguez@intel.com>

[ Upstream commit 331de00a64e5027365145bdf51da27b9ce15dfd5 ]

It is possible that we fail on xhci_mem_init, just before doing
the INIT_LIST_HEAD, and calling xhci_mem_cleanup.

Problem is that, the list_for_each_entry_safe macro, assumes
list heads are initialized (not NULL), and dereferences their 'next'
pointer, causing a kernel panic if this is not yet initialized.

Let's protect from that by moving inits to the beginning.

This patch should be backported to kernels as old as 3.2, that
contain the commit 9574323c39d1f8359a04843075d89c9f32d8b7e6 "xHCI: test
USB2 software LPM".

Signed-off-by: Sergio Aguirre <sergio.a.aguirre.rodriguez@intel.com>
Acked-by: David Cohen <david.a.cohen@intel.com>
Signed-off-by: Sarah Sharp <sarah.a.sharp@linux.intel.com>
Cc: stable@vger.kernel.org
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 drivers/usb/host/xhci-mem.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/usb/host/xhci-mem.c b/drivers/usb/host/xhci-mem.c
index 70db718..0550d53 100644
--- a/drivers/usb/host/xhci-mem.c
+++ b/drivers/usb/host/xhci-mem.c
@@ -2269,6 +2269,9 @@ int xhci_mem_init(struct xhci_hcd *xhci, gfp_t flags)
 	u32 page_size, temp;
 	int i;
 
+	INIT_LIST_HEAD(&xhci->lpm_failed_devs);
+	INIT_LIST_HEAD(&xhci->cancel_cmd_list);
+
 	page_size = xhci_readl(xhci, &xhci->op_regs->page_size);
 	xhci_dbg(xhci, "Supported page size register = 0x%x\n", page_size);
 	for (i = 0; i < 16; i++) {
@@ -2347,7 +2350,6 @@ int xhci_mem_init(struct xhci_hcd *xhci, gfp_t flags)
 	xhci->cmd_ring = xhci_ring_alloc(xhci, 1, 1, TYPE_COMMAND, flags);
 	if (!xhci->cmd_ring)
 		goto fail;
-	INIT_LIST_HEAD(&xhci->cancel_cmd_list);
 	xhci_dbg(xhci, "Allocated command ring at %p\n", xhci->cmd_ring);
 	xhci_dbg(xhci, "First segment DMA is 0x%llx\n",
 			(unsigned long long)xhci->cmd_ring->first_seg->dma);
@@ -2458,8 +2460,6 @@ int xhci_mem_init(struct xhci_hcd *xhci, gfp_t flags)
 	if (xhci_setup_port_arrays(xhci, flags))
 		goto fail;
 
-	INIT_LIST_HEAD(&xhci->lpm_failed_devs);
-
 	/* Enable USB 3.0 device notifications for function remote wake, which
 	 * is necessary for allowing USB 3.0 devices to do remote wakeup from
 	 * U3 (device suspend).
-- 
1.7.10.4


