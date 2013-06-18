Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933175Ab3FRVJb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Jun 2013 17:09:31 -0400
Received: from smtp-outbound-1.vmware.com ([208.91.2.12]:58957 "EHLO
	smtp-outbound-1.vmware.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756275Ab3FRVJ3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Jun 2013 17:09:29 -0400
From: Reilly Grant <grantr@vmware.com>
To: linux-usb@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Sarah Sharp <sarah.a.sharp@linux.intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Reilly Grant <grantr@vmware.com>
Subject: [PATCH] xhci: Compute last_ctx from complete set of configured endpoints.
Date: Tue, 18 Jun 2013 14:09:13 -0700
Message-Id: <1371589753-23277-1-git-send-email-grantr@vmware.com>
X-Mailer: git-send-email 1.8.1.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The context entries field of the slot context must be set to one more
than the highest endpoint index currently active. The previous logic
only included the set of endpoints currently being added, meaning that
if an endpoint where dropped then the field would be reset to 1,
deactivating all configured endpoints.

The xHCI spec is decidedly unclear on whether this field includes all
configured endpoints or only those being modified by a configure
endpoint command. My interpretation is the former as when the xHC writes
changes into the output device context array it must know how large it
is. It does not make sense for this field to only refer to the input
context.
---
 drivers/usb/host/xhci.c | 52 +++++++++++++++++--------------------------------
 1 file changed, 18 insertions(+), 34 deletions(-)

diff --git a/drivers/usb/host/xhci.c b/drivers/usb/host/xhci.c
index d8f640b..aa117d1 100644
--- a/drivers/usb/host/xhci.c
+++ b/drivers/usb/host/xhci.c
@@ -1571,12 +1571,10 @@ int xhci_drop_endpoint(struct usb_hcd *hcd, struct usb_device *udev,
 	struct xhci_hcd *xhci;
 	struct xhci_container_ctx *in_ctx, *out_ctx;
 	struct xhci_input_control_ctx *ctrl_ctx;
-	struct xhci_slot_ctx *slot_ctx;
-	unsigned int last_ctx;
 	unsigned int ep_index;
 	struct xhci_ep_ctx *ep_ctx;
 	u32 drop_flag;
-	u32 new_add_flags, new_drop_flags, new_slot_info;
+	u32 new_add_flags, new_drop_flags;
 	int ret;
 
 	ret = xhci_check_args(hcd, udev, ep, 1, true, __func__);
@@ -1617,24 +1615,13 @@ int xhci_drop_endpoint(struct usb_hcd *hcd, struct usb_device *udev,
 	ctrl_ctx->add_flags &= cpu_to_le32(~drop_flag);
 	new_add_flags = le32_to_cpu(ctrl_ctx->add_flags);
 
-	last_ctx = xhci_last_valid_endpoint(le32_to_cpu(ctrl_ctx->add_flags));
-	slot_ctx = xhci_get_slot_ctx(xhci, in_ctx);
-	/* Update the last valid endpoint context, if we deleted the last one */
-	if ((le32_to_cpu(slot_ctx->dev_info) & LAST_CTX_MASK) >
-	    LAST_CTX(last_ctx)) {
-		slot_ctx->dev_info &= cpu_to_le32(~LAST_CTX_MASK);
-		slot_ctx->dev_info |= cpu_to_le32(LAST_CTX(last_ctx));
-	}
-	new_slot_info = le32_to_cpu(slot_ctx->dev_info);
-
 	xhci_endpoint_zero(xhci, xhci->devs[udev->slot_id], ep);
 
-	xhci_dbg(xhci, "drop ep 0x%x, slot id %d, new drop flags = %#x, new add flags = %#x, new slot info = %#x\n",
+	xhci_dbg(xhci, "drop ep 0x%x, slot id %d, new drop flags = %#x, new add flags = %#x\n",
 			(unsigned int) ep->desc.bEndpointAddress,
 			udev->slot_id,
 			(unsigned int) new_drop_flags,
-			(unsigned int) new_add_flags,
-			(unsigned int) new_slot_info);
+			(unsigned int) new_add_flags);
 	return 0;
 }
 
@@ -1657,11 +1644,9 @@ int xhci_add_endpoint(struct usb_hcd *hcd, struct usb_device *udev,
 	struct xhci_hcd *xhci;
 	struct xhci_container_ctx *in_ctx, *out_ctx;
 	unsigned int ep_index;
-	struct xhci_slot_ctx *slot_ctx;
 	struct xhci_input_control_ctx *ctrl_ctx;
 	u32 added_ctxs;
-	unsigned int last_ctx;
-	u32 new_add_flags, new_drop_flags, new_slot_info;
+	u32 new_add_flags, new_drop_flags;
 	struct xhci_virt_device *virt_dev;
 	int ret = 0;
 
@@ -1676,7 +1661,6 @@ int xhci_add_endpoint(struct usb_hcd *hcd, struct usb_device *udev,
 		return -ENODEV;
 
 	added_ctxs = xhci_get_endpoint_flag(&ep->desc);
-	last_ctx = xhci_last_valid_endpoint(added_ctxs);
 	if (added_ctxs == SLOT_FLAG || added_ctxs == EP0_FLAG) {
 		/* FIXME when we have to issue an evaluate endpoint command to
 		 * deal with ep0 max packet size changing once we get the
@@ -1737,24 +1721,14 @@ int xhci_add_endpoint(struct usb_hcd *hcd, struct usb_device *udev,
 	 */
 	new_drop_flags = le32_to_cpu(ctrl_ctx->drop_flags);
 
-	slot_ctx = xhci_get_slot_ctx(xhci, in_ctx);
-	/* Update the last valid endpoint context, if we just added one past */
-	if ((le32_to_cpu(slot_ctx->dev_info) & LAST_CTX_MASK) <
-	    LAST_CTX(last_ctx)) {
-		slot_ctx->dev_info &= cpu_to_le32(~LAST_CTX_MASK);
-		slot_ctx->dev_info |= cpu_to_le32(LAST_CTX(last_ctx));
-	}
-	new_slot_info = le32_to_cpu(slot_ctx->dev_info);
-
 	/* Store the usb_device pointer for later use */
 	ep->hcpriv = udev;
 
-	xhci_dbg(xhci, "add ep 0x%x, slot id %d, new drop flags = %#x, new add flags = %#x, new slot info = %#x\n",
+	xhci_dbg(xhci, "add ep 0x%x, slot id %d, new drop flags = %#x, new add flags = %#x\n",
 			(unsigned int) ep->desc.bEndpointAddress,
 			udev->slot_id,
 			(unsigned int) new_drop_flags,
-			(unsigned int) new_add_flags,
-			(unsigned int) new_slot_info);
+			(unsigned int) new_add_flags);
 	return 0;
 }
 
@@ -2698,10 +2672,20 @@ int xhci_check_bandwidth(struct usb_hcd *hcd, struct usb_device *udev)
 			ctrl_ctx->drop_flags == 0)
 		return 0;
 
-	xhci_dbg(xhci, "New Input Control Context:\n");
+	/* Update the last valid endpoint context. */
 	slot_ctx = xhci_get_slot_ctx(xhci, virt_dev->in_ctx);
+	for (i = ARRAY_SIZE(virt_dev->eps) - 1; i >= 0; --i) {
+		if ((virt_dev->eps[i].ring &&
+		     !(le32_to_cpu(ctrl_ctx->drop_flags) & (1 << (i + 1)))) ||
+		    (le32_to_cpu(ctrl_ctx->add_flags) & (1 << (i + 1))))
+			break;
+	}
+	slot_ctx->dev_info &= cpu_to_le32(~LAST_CTX_MASK);
+	slot_ctx->dev_info |= cpu_to_le32(LAST_CTX(i + 1));
+
+	xhci_dbg(xhci, "New Input Control Context:\n");
 	xhci_dbg_ctx(xhci, virt_dev->in_ctx,
-		     LAST_CTX_TO_EP_NUM(le32_to_cpu(slot_ctx->dev_info)));
+		     xhci_last_valid_endpoint(ctrl_ctx->add_flags));
 
 	ret = xhci_configure_endpoint(xhci, udev, NULL,
 			false, false);
-- 
1.8.1.5
