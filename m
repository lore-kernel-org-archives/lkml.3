Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932974AbaBEUfz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Feb 2014 15:35:55 -0500
Received: from mail.windriver.com ([147.11.1.11]:55191 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752262AbaBEUGt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Feb 2014 15:06:49 -0500
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: <stable@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC: Sarah Sharp <sarah.a.sharp@linux.intel.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [v2.6.34-stable 138/213] xhci: Reset reserved command ring TRBs on cleanup.
Date: Wed, 5 Feb 2014 15:01:33 -0500
Message-ID: <1391630568-49251-139-git-send-email-paul.gortmaker@windriver.com>
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

commit 33b2831ac870d50cc8e01c317b07fb1e69c13fe1 upstream.

When the xHCI driver needs to clean up memory (perhaps due to a failed
register restore on resume from S3 or resume from S4), it needs to reset
the number of reserved TRBs on the command ring to zero.  Otherwise,
several resume cycles (about 30) with a UAS device attached will
continually increment the number of reserved TRBs, until all command
submissions fail because there isn't enough room on the command ring.

This patch should be backported to kernels as old as 2.6.32,
that contain the commit 913a8a344ffcaf0b4a586d6662a2c66a7106557d
"USB: xhci: Change how xHCI commands are handled."

Signed-off-by: Sarah Sharp <sarah.a.sharp@linux.intel.com>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 drivers/usb/host/xhci-mem.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/usb/host/xhci-mem.c b/drivers/usb/host/xhci-mem.c
index 31cf540480fe..cb743a6bcfe4 100644
--- a/drivers/usb/host/xhci-mem.c
+++ b/drivers/usb/host/xhci-mem.c
@@ -1048,6 +1048,7 @@ void xhci_mem_cleanup(struct xhci_hcd *xhci)
 	xhci_dbg(xhci, "Freed event ring\n");
 
 	xhci_write_64(xhci, 0, &xhci->op_regs->cmd_ring);
+	xhci->cmd_ring_reserved_trbs = 0;
 	if (xhci->cmd_ring)
 		xhci_ring_free(xhci, xhci->cmd_ring);
 	xhci->cmd_ring = NULL;
-- 
1.8.5.2

