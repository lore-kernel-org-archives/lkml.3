Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755545AbaBEUfK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Feb 2014 15:35:10 -0500
Received: from mail.windriver.com ([147.11.1.11]:55201 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755013AbaBEUGv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Feb 2014 15:06:51 -0500
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: <stable@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC: Sarah Sharp <sarah.a.sharp@linux.intel.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [v2.6.34-stable 140/213] xhci: Don't write zeroed pointers to xHC registers.
Date: Wed, 5 Feb 2014 15:01:35 -0500
Message-ID: <1391630568-49251-141-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.8.5.2
In-Reply-To: <1391630568-49251-1-git-send-email-paul.gortmaker@windriver.com>
References: <1391630568-49251-1-git-send-email-paul.gortmaker@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Sarah Sharp <sarah.a.sharp@linux.intel.com>

                   -------------------
    This is a commit scheduled for the next v2.6.34 longterm release.
    http://git.kernel.org/?p=linux/kernel/git/paulg/longterm-queue-2.6.34.git
    If you see a problem with using this for longterm, please comment.
                   -------------------

commit 159e1fcc9a60fc7daba23ee8fcdb99799de3fe84 upstream.

When xhci_mem_cleanup() is called, we can't be sure if the xHC is
actually halted.  We can ask the xHC to halt by writing to the RUN bit
in the command register, but that might timeout due to a HW hang.

If the host controller is still running, we should not write zeroed
values to the event ring dequeue pointers or base tables, the DCBAA
pointers, or the command ring pointers.  Eric Fu reports his VIA VL800
host accesses the event ring pointers after a failed register restore on
resume from suspend.  The hypothesis is that the host never actually
halted before the register write to change the event ring pointer to
zero.

Remove all writes of zeroed values to pointer registers in
xhci_mem_cleanup().  Instead, make all callers of the function reset the
host controller first, which will reset those registers to zero.
xhci_mem_init() is the only caller that doesn't first halt and reset the
host controller before calling xhci_mem_cleanup().

This should be backported to kernels as old as 2.6.32.

Signed-off-by: Sarah Sharp <sarah.a.sharp@linux.intel.com>
Tested-by: Elric Fu <elricfu1@gmail.com>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 drivers/usb/host/xhci-mem.c | 9 ++-------
 1 file changed, 2 insertions(+), 7 deletions(-)

diff --git a/drivers/usb/host/xhci-mem.c b/drivers/usb/host/xhci-mem.c
index cb743a6bcfe4..e244e8cc5c1d 100644
--- a/drivers/usb/host/xhci-mem.c
+++ b/drivers/usb/host/xhci-mem.c
@@ -1031,11 +1031,6 @@ void xhci_mem_cleanup(struct xhci_hcd *xhci)
 	int i;
 
 	/* Free the Event Ring Segment Table and the actual Event Ring */
-	if (xhci->ir_set) {
-		xhci_writel(xhci, 0, &xhci->ir_set->erst_size);
-		xhci_write_64(xhci, 0, &xhci->ir_set->erst_base);
-		xhci_write_64(xhci, 0, &xhci->ir_set->erst_dequeue);
-	}
 	size = sizeof(struct xhci_erst_entry)*(xhci->erst.num_entries);
 	if (xhci->erst.entries)
 		pci_free_consistent(pdev, size,
@@ -1047,7 +1042,6 @@ void xhci_mem_cleanup(struct xhci_hcd *xhci)
 	xhci->event_ring = NULL;
 	xhci_dbg(xhci, "Freed event ring\n");
 
-	xhci_write_64(xhci, 0, &xhci->op_regs->cmd_ring);
 	xhci->cmd_ring_reserved_trbs = 0;
 	if (xhci->cmd_ring)
 		xhci_ring_free(xhci, xhci->cmd_ring);
@@ -1067,7 +1061,6 @@ void xhci_mem_cleanup(struct xhci_hcd *xhci)
 	xhci->device_pool = NULL;
 	xhci_dbg(xhci, "Freed device context pool\n");
 
-	xhci_write_64(xhci, 0, &xhci->op_regs->dcbaa_ptr);
 	if (xhci->dcbaa)
 		pci_free_consistent(pdev, sizeof(*xhci->dcbaa),
 				xhci->dcbaa, xhci->dcbaa->dma);
@@ -1403,6 +1396,8 @@ int xhci_mem_init(struct xhci_hcd *xhci, gfp_t flags)
 
 fail:
 	xhci_warn(xhci, "Couldn't initialize memory\n");
+	xhci_halt(xhci);
+	xhci_reset(xhci);
 	xhci_mem_cleanup(xhci);
 	return -ENOMEM;
 }
-- 
1.8.5.2

