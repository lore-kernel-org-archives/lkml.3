Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756756Ab3KLVAp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Nov 2013 16:00:45 -0500
Received: from mga02.intel.com ([134.134.136.20]:10535 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753730Ab3KLVA0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Nov 2013 16:00:26 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,535,1378882800"; 
   d="scan'208";a="407682049"
From: David Cohen <david.a.cohen@linux.intel.com>
To: balbi@ti.com, gregkh@linuxfoundation.org
Cc: stern@rowland.harvard.edu, mina86@mina86.com, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        David Cohen <david.a.cohen@linux.intel.com>
Subject: [PATCH v6 2/5] usb: gadget: add quirk_ep_out_aligned_size field to struct usb_gadget
Date: Tue, 12 Nov 2013 13:04:43 -0800
Message-Id: <1384290286-21432-3-git-send-email-david.a.cohen@linux.intel.com>
X-Mailer: git-send-email 1.8.4.2
In-Reply-To: <1384290286-21432-1-git-send-email-david.a.cohen@linux.intel.com>
References: <1384290286-21432-1-git-send-email-david.a.cohen@linux.intel.com>
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
Acked-by: Alan Stern <stern@rowland.harvard.edu>
Acked-by: Michal Nazarewicz <mina86@mina86.com>
---
 include/linux/usb/gadget.h | 16 ++++++++++++++++
 1 file changed, 16 insertions(+)

diff --git a/include/linux/usb/gadget.h b/include/linux/usb/gadget.h
index 23b3bfd0a842..41e8834af57d 100644
--- a/include/linux/usb/gadget.h
+++ b/include/linux/usb/gadget.h
@@ -441,6 +441,19 @@ static inline void usb_ep_fifo_flush(struct usb_ep *ep)
 		ep->ops->fifo_flush(ep);
 }
 
+/**
+ * usb_ep_align_maxpacketsize - returns @len aligned to ep's maxpacketsize
+ * @ep: the endpoint whose maxpacketsize is used to align @len
+ * @len: buffer size's length to align to @ep's maxpacketsize
+ *
+ * This helper is used in case it's required for any reason to align buffer's
+ * size to an ep's maxpacketsize.
+ */
+static inline size_t usb_ep_align_maxpacketsize(struct usb_ep *ep, size_t len)
+{
+	return round_up(len, (size_t)ep->desc->wMaxPacketSize);
+}
+
 
 /*-------------------------------------------------------------------------*/
 
@@ -502,6 +515,8 @@ struct usb_gadget_ops {
  *	only supports HNP on a different root port.
  * @b_hnp_enable: OTG device feature flag, indicating that the A-Host
  *	enabled HNP support.
+ * @quirk_ep_out_aligned_size: epout requires buffer size to be aligned to
+ *	MaxPacketSize.
  *
  * Gadgets have a mostly-portable "gadget driver" implementing device
  * functions, handling all usb configurations and interfaces.  Gadget
@@ -541,6 +556,7 @@ struct usb_gadget {
 	unsigned			b_hnp_enable:1;
 	unsigned			a_hnp_support:1;
 	unsigned			a_alt_hnp_support:1;
+	unsigned			quirk_ep_out_aligned_size:1;
 };
 #define work_to_gadget(w)	(container_of((w), struct usb_gadget, work))
 
-- 
1.8.4.2

