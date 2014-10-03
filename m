Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755899AbaJCVxN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Oct 2014 17:53:13 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:45699 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754797AbaJCVxK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Oct 2014 17:53:10 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Al Cooper <alcooperx@gmail.com>,
        Mathias Nyman <mathias.nyman@linux.intel.com>
Subject: [PATCH 3.16 131/357] usb: xhci: Fix OOPS in xhci error handling code
Date: Fri,  3 Oct 2014 14:28:37 -0700
Message-Id: <20141003212937.408773910@linuxfoundation.org>
X-Mailer: git-send-email 2.1.2
In-Reply-To: <20141003212933.458851516@linuxfoundation.org>
References: <20141003212933.458851516@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.16-stable review patch.  If anyone has any objections, please let me know.

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

---
 drivers/usb/host/xhci-mem.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/usb/host/xhci-mem.c
+++ b/drivers/usb/host/xhci-mem.c
@@ -1812,6 +1812,7 @@ void xhci_mem_cleanup(struct xhci_hcd *x
 
 	if (xhci->lpm_command)
 		xhci_free_command(xhci, xhci->lpm_command);
+	xhci->lpm_command = NULL;
 	if (xhci->cmd_ring)
 		xhci_ring_free(xhci, xhci->cmd_ring);
 	xhci->cmd_ring = NULL;


