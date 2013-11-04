Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753996Ab3KDWIq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Nov 2013 17:08:46 -0500
Received: from mga02.intel.com ([134.134.136.20]:44899 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753301Ab3KDWIf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Nov 2013 17:08:35 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,535,1378882800"; 
   d="scan'208";a="429741875"
From: David Cohen <david.a.cohen@linux.intel.com>
To: balbi@ti.com, gregkh@linuxfoundation.org
Cc: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        David Cohen <david.a.cohen@linux.intel.com>
Subject: [PATCH v4 2/4] usb: gadget: add quirk_ep_out_aligned_size field to struct usb_gadget
Date: Mon,  4 Nov 2013 14:12:55 -0800
Message-Id: <1383603177-4624-3-git-send-email-david.a.cohen@linux.intel.com>
X-Mailer: git-send-email 1.8.4.rc3
In-Reply-To: <1383603177-4624-1-git-send-email-david.a.cohen@linux.intel.com>
References: <1383603177-4624-1-git-send-email-david.a.cohen@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Due to USB controllers may have different restrictions, usb gadget layer
needs to provide a generic way to inform gadget functions to complain
with non-standard requirements.

This patch adds 'quirk_ep_out_aligned_size' field to struct usb_gadget
to inform when controller's epout requires buffer size to be aligned to
MaxPacketSize. A helper is also provided to align buffer size when
necessary.

Signed-off-by: David Cohen <david.a.cohen@linux.intel.com>
---
 include/linux/usb/gadget.h | 19 +++++++++++++++++++
 1 file changed, 19 insertions(+)

diff --git a/include/linux/usb/gadget.h b/include/linux/usb/gadget.h
index 23b3bfd0a842..260d972489bd 100644
--- a/include/linux/usb/gadget.h
+++ b/include/linux/usb/gadget.h
@@ -442,6 +442,22 @@ static inline void usb_ep_fifo_flush(struct usb_ep *ep)
 }
 
 
+static inline size_t usb_ep_align_maxpacketsize(struct usb_ep *ep, size_t len)
+{
+	int aligned;
+
+	if (ep->desc->bmAttributes & USB_ENDPOINT_XFER_INT)
+		/*
+		 * Interrupt eps don't need max packet size to be power of 2,
+		 * so can't use cheap IS_ALIGNED() macro.
+		 */
+		aligned = !(len % ep->desc->wMaxPacketSize);
+	else
+		aligned = IS_ALIGNED(len, ep->desc->wMaxPacketSize);
+
+	return aligned ? len : round_up(len, (size_t)ep->desc->wMaxPacketSize);
+}
+
 /*-------------------------------------------------------------------------*/
 
 struct usb_dcd_config_params {
@@ -502,6 +518,8 @@ struct usb_gadget_ops {
  *	only supports HNP on a different root port.
  * @b_hnp_enable: OTG device feature flag, indicating that the A-Host
  *	enabled HNP support.
+ * @quirk_ep_out_aligned_size: epout requires buffer size to be aligned to
+ *	MaxPacketSize.
  *
  * Gadgets have a mostly-portable "gadget driver" implementing device
  * functions, handling all usb configurations and interfaces.  Gadget
@@ -541,6 +559,7 @@ struct usb_gadget {
 	unsigned			b_hnp_enable:1;
 	unsigned			a_hnp_support:1;
 	unsigned			a_alt_hnp_support:1;
+	unsigned			quirk_ep_out_aligned_size:1;
 };
 #define work_to_gadget(w)	(container_of((w), struct usb_gadget, work))
 
-- 
1.8.4.rc3

