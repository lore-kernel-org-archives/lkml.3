Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965661Ab3GSFps (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Jul 2013 01:45:48 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:39665 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965565Ab3GSF01 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Jul 2013 01:26:27 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Mathias Nyman <mathias.nyman@linux.intel.com>,
        Sarah Sharp <sarah.a.sharp@linux.intel.com>,
        John Youn <johnyoun@synopsys.com>
Subject: [ 15/72] xhci: check for failed dma pool allocation
Date: Thu, 18 Jul 2013 22:25:32 -0700
Message-Id: <20130719052600.907184895@linuxfoundation.org>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <20130719052559.852627424@linuxfoundation.org>
References: <20130719052559.852627424@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

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

---
 drivers/usb/host/xhci-mem.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/drivers/usb/host/xhci-mem.c
+++ b/drivers/usb/host/xhci-mem.c
@@ -369,6 +369,10 @@ static struct xhci_container_ctx *xhci_a
 		ctx->size += CTX_SIZE(xhci->hcc_params);
 
 	ctx->bytes = dma_pool_alloc(xhci->device_pool, flags, &ctx->dma);
+	if (!ctx->bytes) {
+		kfree(ctx);
+		return NULL;
+	}
 	memset(ctx->bytes, 0, ctx->size);
 	return ctx;
 }


