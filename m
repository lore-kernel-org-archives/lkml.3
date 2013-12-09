Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751515Ab3LIXwJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Dec 2013 18:52:09 -0500
Received: from mga02.intel.com ([134.134.136.20]:45387 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751183Ab3LIXvM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Dec 2013 18:51:12 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,861,1378882800"; 
   d="scan'208";a="421949713"
From: David Cohen <david.a.cohen@linux.intel.com>
To: balbi@ti.com, gregkh@linuxfoundation.org
Cc: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org, mina86@mina86.com,
        stern@rowland.harvard.edu, David Cohen <david.a.cohen@linux.intel.com>
Subject: [PATCH v7 2/5] usb: gadget: add quirk_ep_out_aligned_size field to struct usb_gadget
Date: Mon,  9 Dec 2013 15:55:35 -0800
Message-Id: <1386633338-10919-3-git-send-email-david.a.cohen@linux.intel.com>
X-Mailer: git-send-email 1.8.4.2
In-Reply-To: <1386633338-10919-1-git-send-email-david.a.cohen@linux.intel.com>
References: <1386633338-10919-1-git-send-email-david.a.cohen@linux.intel.com>
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
Cc: Alan Stern <stern@rowland.harvard.edu>
Cc: Michal Nazarewicz <mina86@mina86.com>
---
 include/linux/usb/gadget.h | 20 ++++++++++++++++++++
 1 file changed, 20 insertions(+)

diff --git a/include/linux/usb/gadget.h b/include/linux/usb/gadget.h
index 23b3bfd0a842..cae8a6216551 100644
--- a/include/linux/usb/gadget.h
+++ b/include/linux/usb/gadget.h
@@ -502,6 +502,8 @@ struct usb_gadget_ops {
  *	only supports HNP on a different root port.
  * @b_hnp_enable: OTG device feature flag, indicating that the A-Host
  *	enabled HNP support.
+ * @quirk_ep_out_aligned_size: epout requires buffer size to be aligned to
+ *	MaxPacketSize.
  *
  * Gadgets have a mostly-portable "gadget driver" implementing device
  * functions, handling all usb configurations and interfaces.  Gadget
@@ -541,6 +543,7 @@ struct usb_gadget {
 	unsigned			b_hnp_enable:1;
 	unsigned			a_hnp_support:1;
 	unsigned			a_alt_hnp_support:1;
+	unsigned			quirk_ep_out_aligned_size:1;
 };
 #define work_to_gadget(w)	(container_of((w), struct usb_gadget, work))
 
@@ -559,6 +562,23 @@ static inline struct usb_gadget *dev_to_usb_gadget(struct device *dev)
 
 
 /**
+ * usb_ep_align_maybe - returns @len aligned to ep's maxpacketsize if gadget
+ *	requires quirk_ep_out_aligned_size, otherwise reguens len.
+ * @g: controller to check for quirk
+ * @ep: the endpoint whose maxpacketsize is used to align @len
+ * @len: buffer size's length to align to @ep's maxpacketsize
+ *
+ * This helper is used in case it's required for any reason to check and maybe
+ * align buffer's size to an ep's maxpacketsize.
+ */
+static inline size_t
+usb_ep_align_maybe(struct usb_gadget *g, struct usb_ep *ep, size_t len)
+{
+	return !g->quirk_ep_out_aligned_size ? len :
+			round_up(len, (size_t)ep->desc->wMaxPacketSize);
+}
+
+/**
  * gadget_is_dualspeed - return true iff the hardware handles high speed
  * @g: controller that might support both high and full speeds
  */
-- 
1.8.4.2

