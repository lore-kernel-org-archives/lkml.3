Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757651Ab3J2BJu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Oct 2013 21:09:50 -0400
Received: from mga09.intel.com ([134.134.136.24]:61520 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756857Ab3J2BIs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Oct 2013 21:08:48 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,535,1378882800"; 
   d="scan'208";a="400167041"
From: David Cohen <david.a.cohen@linux.intel.com>
To: balbi@ti.com, gregkh@linuxfoundation.org
Cc: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        David Cohen <david.a.cohen@linux.intel.com>
Subject: [RFC/PATCH 2/2] usb: ffs/dwc3: pad epout buffer size when not aligned to maxpacketsize
Date: Mon, 28 Oct 2013 18:13:00 -0700
Message-Id: <1383009180-23236-3-git-send-email-david.a.cohen@linux.intel.com>
X-Mailer: git-send-email 1.8.4.rc3
In-Reply-To: <1383009180-23236-1-git-send-email-david.a.cohen@linux.intel.com>
References: <1383009180-23236-1-git-send-email-david.a.cohen@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

DWC3 requires buffer size to be aligned to maxpacketsize of an out
endpoint. ffs_epfile_io() needs to pad epout buffer to match above
condition if DWC3 controller is used.

This patch solves an specific situation but a more generic solution
should be found.

Signed-off-by: David Cohen <david.a.cohen@linux.intel.com>
---
 drivers/usb/gadget/f_fs.c | 19 +++++++++++++++++++
 1 file changed, 19 insertions(+)

diff --git a/drivers/usb/gadget/f_fs.c b/drivers/usb/gadget/f_fs.c
index 75e4b78..33880e6 100644
--- a/drivers/usb/gadget/f_fs.c
+++ b/drivers/usb/gadget/f_fs.c
@@ -27,6 +27,7 @@
 #include <linux/usb/composite.h>
 #include <linux/usb/functionfs.h>
 
+#include "gadget_chips.h"
 
 #define FUNCTIONFS_MAGIC	0xa647361 /* Chosen by a honest dice roll ;) */
 
@@ -755,10 +756,12 @@ static ssize_t ffs_epfile_io(struct file *file,
 			     char __user *buf, size_t len, int read)
 {
 	struct ffs_epfile *epfile = file->private_data;
+	struct usb_gadget *gadget = epfile->ffs->gadget;
 	struct ffs_ep *ep;
 	char *data = NULL;
 	ssize_t ret;
 	int halt;
+	size_t orig_len = len;
 
 	goto first_try;
 	do {
@@ -794,6 +797,22 @@ first_try:
 			goto error;
 		}
 
+		/*
+		 * DWC3 requires buffer size to be aligned to maxpacketsize
+		 * of an out endpoint.
+		 * FIXME: a more generic solution might be necessary.
+		 */
+		if (gadget_is_dwc3(gadget) && read &&
+		    !IS_ALIGNED(len, ep->ep->desc->wMaxPacketSize)) {
+			size_t old_len = len;
+			len = roundup(orig_len,
+				      (size_t)ep->ep->desc->wMaxPacketSize);
+			if (unlikely(data) && len > old_len) {
+				kfree(data);
+				data = NULL;
+			}
+		}
+
 		/* Allocate & copy */
 		if (!halt && !data) {
 			data = kzalloc(len, GFP_KERNEL);
-- 
1.8.4.rc3

