Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755734Ab3FRMNx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Jun 2013 08:13:53 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:55893 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755402Ab3FRLny (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Jun 2013 07:43:54 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Sergio Aguirre <sergio.a.aguirre.rodriguez@intel.com>,
        Sarah Sharp <sarah.a.sharp@linux.intel.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 04/93] xhci-mem: init list heads at the beginning of init
Date: Tue, 18 Jun 2013 12:42:12 +0100
Message-Id: <1371555821-12820-5-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1371555821-12820-1-git-send-email-luis.henriques@canonical.com>
References: <1371555821-12820-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.15 -stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/usb/host/xhci-mem.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/usb/host/xhci-mem.c b/drivers/usb/host/xhci-mem.c
index 90ce33b..59c08b2 100644
--- a/drivers/usb/host/xhci-mem.c
+++ b/drivers/usb/host/xhci-mem.c
@@ -2276,6 +2276,9 @@ int xhci_mem_init(struct xhci_hcd *xhci, gfp_t flags)
 	u32 page_size, temp;
 	int i;
 
+	INIT_LIST_HEAD(&xhci->lpm_failed_devs);
+	INIT_LIST_HEAD(&xhci->cancel_cmd_list);
+
 	page_size = xhci_readl(xhci, &xhci->op_regs->page_size);
 	xhci_dbg(xhci, "Supported page size register = 0x%x\n", page_size);
 	for (i = 0; i < 16; i++) {
@@ -2354,7 +2357,6 @@ int xhci_mem_init(struct xhci_hcd *xhci, gfp_t flags)
 	xhci->cmd_ring = xhci_ring_alloc(xhci, 1, 1, TYPE_COMMAND, flags);
 	if (!xhci->cmd_ring)
 		goto fail;
-	INIT_LIST_HEAD(&xhci->cancel_cmd_list);
 	xhci_dbg(xhci, "Allocated command ring at %p\n", xhci->cmd_ring);
 	xhci_dbg(xhci, "First segment DMA is 0x%llx\n",
 			(unsigned long long)xhci->cmd_ring->first_seg->dma);
@@ -2465,8 +2467,6 @@ int xhci_mem_init(struct xhci_hcd *xhci, gfp_t flags)
 	if (xhci_setup_port_arrays(xhci, flags))
 		goto fail;
 
-	INIT_LIST_HEAD(&xhci->lpm_failed_devs);
-
 	/* Enable USB 3.0 device notifications for function remote wake, which
 	 * is necessary for allowing USB 3.0 devices to do remote wakeup from
 	 * U3 (device suspend).
-- 
1.8.1.2

