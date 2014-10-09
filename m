Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932432AbaJIVXS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Oct 2014 17:23:18 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:59517 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757744AbaJIVKj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Oct 2014 17:10:39 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Al Cooper <alcooperx@gmail.com>,
        Mathias Nyman <mathias.nyman@linux.intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13 057/163] usb: xhci: Fix OOPS in xhci error handling code
Date: Thu,  9 Oct 2014 14:01:22 -0700
Message-Id: <1412888588-26755-58-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1412888588-26755-1-git-send-email-kamal@canonical.com>
References: <1412888588-26755-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11.9 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Al Cooper <alcooperx@gmail.com>

commit 0eda06c7c17ae48d7db69beef57f6e2b20bc3c72 upstream.

The xhci driver will OOPS on resume from S2/S3 if dma_alloc_coherent()
is out of memory. This is a result of two things:
1. xhci_mem_cleanup() in xhci-mem.c free's xhci->lpm_command if
it's not NULL, but doesn't set it to NULL after the free.
2. xhci_mem_cleanup() is called twice on resume, once for normal
restart and once from xhci_mem_init() if dma_alloc_coherent() fails,
resulting in a free of xhci->lpm_command that has already been freed.
The fix is to set xhci->lpm_command to NULL after freeing it.

Signed-off-by: Al Cooper <alcooperx@gmail.com>
Signed-off-by: Mathias Nyman <mathias.nyman@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/usb/host/xhci-mem.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/usb/host/xhci-mem.c b/drivers/usb/host/xhci-mem.c
index 837c333..06d0d1e 100644
--- a/drivers/usb/host/xhci-mem.c
+++ b/drivers/usb/host/xhci-mem.c
@@ -1711,6 +1711,7 @@ void xhci_mem_cleanup(struct xhci_hcd *xhci)
 
 	if (xhci->lpm_command)
 		xhci_free_command(xhci, xhci->lpm_command);
+	xhci->lpm_command = NULL;
 	xhci->cmd_ring_reserved_trbs = 0;
 	if (xhci->cmd_ring)
 		xhci_ring_free(xhci, xhci->cmd_ring);
-- 
1.9.1

