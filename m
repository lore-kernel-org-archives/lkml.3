Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936654Ab3DIATF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Apr 2013 20:19:05 -0400
Received: from mail-pa0-f44.google.com ([209.85.220.44]:65235 "EHLO
	mail-pa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934100Ab3DIATD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Apr 2013 20:19:03 -0400
From: Julius Werner <jwerner@chromium.org>
To: Sarah Sharp <sarah.a.sharp@linux.intel.com>
Cc: linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Vincent Palatin <vpalatin@chromium.org>,
        Julius Werner <jwerner@chromium.org>
Subject: [PATCH] usb: xhci-dbg: Display endpoint number and direction in context dump
Date: Mon,  8 Apr 2013 17:18:25 -0700
Message-Id: <1365466705-12847-1-git-send-email-jwerner@chromium.org>
X-Mailer: git-send-email 1.8.1.3
In-Reply-To: <20130408154152.GB6117@xanatos>
References: <20130408154152.GB6117@xanatos> <1365109384-5333-1-git-send-email-jwerner@chromium.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When CONFIG_XHCI_HCD_DEBUGGING is activated, the XHCI driver can dump
device and input contexts to the console. The endpoint contexts in that
dump are labeled "Endpoint N Context", where N is the XHCI endpoint
index (DCI - 1). This can be very confusing, especially for people who
are not that familiar with the XHCI specification. This patch introduces
an xhci_get_endpoint_address function (as a counterpart to the reverse
xhci_get_endpoint_index), and uses it to additionally display the
endpoint number and direction when dumping contexts, which are much more
commonly used concepts in USB.

Signed-off-by: Julius Werner <jwerner@chromium.org>
---
 drivers/usb/host/xhci-dbg.c |  5 ++++-
 drivers/usb/host/xhci.c     | 10 ++++++++++
 drivers/usb/host/xhci.h     |  1 +
 3 files changed, 15 insertions(+), 1 deletion(-)

diff --git a/drivers/usb/host/xhci-dbg.c b/drivers/usb/host/xhci-dbg.c
index 5f3a7c7..16a8272 100644
--- a/drivers/usb/host/xhci-dbg.c
+++ b/drivers/usb/host/xhci-dbg.c
@@ -503,11 +503,14 @@ static void xhci_dbg_ep_ctx(struct xhci_hcd *xhci,
 	if (last_ep < 31)
 		last_ep_ctx = last_ep + 1;
 	for (i = 0; i < last_ep_ctx; ++i) {
+		unsigned int epaddr = xhci_get_endpoint_address(i);
 		struct xhci_ep_ctx *ep_ctx = xhci_get_ep_ctx(xhci, ctx, i);
 		dma_addr_t dma = ctx->dma +
 			((unsigned long)ep_ctx - (unsigned long)ctx->bytes);
 
-		xhci_dbg(xhci, "Endpoint %02d Context:\n", i);
+		xhci_dbg(xhci, "Endpoint %02d %s Context (index %02d):\n",
+				epaddr & USB_ENDPOINT_NUMBER_MASK,
+				usb_endpoint_out(epaddr) ? "OUT" : "IN", i);
 		xhci_dbg(xhci, "@%p (virt) @%08llx (dma) %#08x - ep_info\n",
 				&ep_ctx->ep_info,
 				(unsigned long long)dma, ep_ctx->ep_info);
diff --git a/drivers/usb/host/xhci.c b/drivers/usb/host/xhci.c
index 53b8f89..3a3ac92 100644
--- a/drivers/usb/host/xhci.c
+++ b/drivers/usb/host/xhci.c
@@ -1107,6 +1107,16 @@ unsigned int xhci_get_endpoint_index(struct usb_endpoint_descriptor *desc)
 	return index;
 }
 
+/* The reverse operation to xhci_get_endpoint_index. Calculate the USB endpoint
+ * address from the XHCI endpoint index.
+ */
+unsigned int xhci_get_endpoint_address(unsigned int ep_index)
+{
+	unsigned int number = DIV_ROUND_UP(ep_index, 2);
+	unsigned int direction = ep_index % 2 ? USB_DIR_OUT : USB_DIR_IN;
+	return direction | number;
+}
+
 /* Find the flag for this endpoint (for use in the control context).  Use the
  * endpoint index to create a bitmask.  The slot context is bit 0, endpoint 0 is
  * bit 1, etc.
diff --git a/drivers/usb/host/xhci.h b/drivers/usb/host/xhci.h
index 6358271..555e911 100644
--- a/drivers/usb/host/xhci.h
+++ b/drivers/usb/host/xhci.h
@@ -1641,6 +1641,7 @@ int xhci_setup_addressable_virt_dev(struct xhci_hcd *xhci, struct usb_device *ud
 void xhci_copy_ep0_dequeue_into_input_ctx(struct xhci_hcd *xhci,
 		struct usb_device *udev);
 unsigned int xhci_get_endpoint_index(struct usb_endpoint_descriptor *desc);
+unsigned int xhci_get_endpoint_address(unsigned int ep_index);
 unsigned int xhci_get_endpoint_flag(struct usb_endpoint_descriptor *desc);
 unsigned int xhci_get_endpoint_flag_from_index(unsigned int ep_index);
 unsigned int xhci_last_valid_endpoint(u32 added_ctxs);
-- 
1.7.12.4

