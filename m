Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932706Ab3GKOwR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Jul 2013 10:52:17 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:42863 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932575Ab3GKOZe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Jul 2013 10:25:34 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Mathias Nyman <mathias.nyman@linux.intel.com>,
        Sarah Sharp <sarah.a.sharp@linux.intel.com>,
        John Youn <johnyoun@synopsys.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 10/98] xhci: check for failed dma pool allocation
Date: Thu, 11 Jul 2013 15:23:40 +0100
Message-Id: <1373552708-15235-11-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1373552708-15235-1-git-send-email-luis.henriques@canonical.com>
References: <1373552708-15235-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.17 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mathias Nyman <mathias.nyman@linux.intel.com>

commit 025f880cb2e4d7218d0422d4b07bea1a68959c38 upstream.

Fail and free the container context in case dma_pool_alloc() can't allocate
the raw context data part of it

This patch should be backported to kernels as old as 2.6.31, that
contain the commit d115b04818e57bdbc7ccde4d0660b15e33013dc8 "USB: xhci:
Support for 64-byte contexts".

Signed-off-by: Mathias Nyman <mathias.nyman@linux.intel.com>
Signed-off-by: Sarah Sharp <sarah.a.sharp@linux.intel.com>
Cc: John Youn <johnyoun@synopsys.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/usb/host/xhci-mem.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/usb/host/xhci-mem.c b/drivers/usb/host/xhci-mem.c
index 0618f25..1ffbbfb 100644
--- a/drivers/usb/host/xhci-mem.c
+++ b/drivers/usb/host/xhci-mem.c
@@ -369,6 +369,10 @@ static struct xhci_container_ctx *xhci_alloc_container_ctx(struct xhci_hcd *xhci
 		ctx->size += CTX_SIZE(xhci->hcc_params);
 
 	ctx->bytes = dma_pool_alloc(xhci->device_pool, flags, &ctx->dma);
+	if (!ctx->bytes) {
+		kfree(ctx);
+		return NULL;
+	}
 	memset(ctx->bytes, 0, ctx->size);
 	return ctx;
 }
-- 
1.8.1.2

