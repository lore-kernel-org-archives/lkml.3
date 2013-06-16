Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756084Ab3FPWQS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Jun 2013 18:16:18 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:46743 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755670Ab3FPWQQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Jun 2013 18:16:16 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org,
        "Sergio Aguirre" <sergio.a.aguirre.rodriguez@intel.com>,
        David Cohen <david.a.cohen@intel.com>,
        Sarah Sharp <sarah.a.sharp@linux.intel.com>
Date: Sun, 16 Jun 2013 23:01:38 +0100
Subject: [34/83] xhci-mem: init list heads at the beginning of init
In-Reply-To: <lsq.1371420097.958132574@decadent.org.uk>
Message-Id: <E1UoLF8-00027h-Tr@deadeye.wl.decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.101
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.47-rc1 review patch.  If anyone has any objections, please let me know.

[Re-sending with the pseudo-headers unmangled.]

------------------

From: Sergio Aguirre <sergio.a.aguirre.rodriguez@intel.com>

commit 331de00a64e5027365145bdf51da27b9ce15dfd5 upstream.

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
[bwh: Backported to 3.2: adjust context]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/usb/host/xhci-mem.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/drivers/usb/host/xhci-mem.c
+++ b/drivers/usb/host/xhci-mem.c
@@ -2184,6 +2184,9 @@ int xhci_mem_init(struct xhci_hcd *xhci,
 	u32 page_size;
 	int i;
 
+	INIT_LIST_HEAD(&xhci->lpm_failed_devs);
+	INIT_LIST_HEAD(&xhci->cancel_cmd_list);
+
 	page_size = xhci_readl(xhci, &xhci->op_regs->page_size);
 	xhci_dbg(xhci, "Supported page size register = 0x%x\n", page_size);
 	for (i = 0; i < 16; i++) {
@@ -2262,7 +2265,6 @@ int xhci_mem_init(struct xhci_hcd *xhci,
 	xhci->cmd_ring = xhci_ring_alloc(xhci, 1, true, false, flags);
 	if (!xhci->cmd_ring)
 		goto fail;
-	INIT_LIST_HEAD(&xhci->cancel_cmd_list);
 	xhci_dbg(xhci, "Allocated command ring at %p\n", xhci->cmd_ring);
 	xhci_dbg(xhci, "First segment DMA is 0x%llx\n",
 			(unsigned long long)xhci->cmd_ring->first_seg->dma);
@@ -2363,8 +2365,6 @@ int xhci_mem_init(struct xhci_hcd *xhci,
 	if (xhci_setup_port_arrays(xhci, flags))
 		goto fail;
 
-	INIT_LIST_HEAD(&xhci->lpm_failed_devs);
-
 	return 0;
 
 fail:

