Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753519Ab3J2VtI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Oct 2013 17:49:08 -0400
Received: from mga02.intel.com ([134.134.136.20]:62273 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752797Ab3J2Vsn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Oct 2013 17:48:43 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,535,1378882800"; 
   d="scan'208";a="400647234"
From: David Cohen <david.a.cohen@linux.intel.com>
To: balbi@ti.com, gregkh@linuxfoundation.org
Cc: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        David Cohen <david.a.cohen@linux.intel.com>
Subject: [RFC/PATCH v2 2/3] usb: ffs: check quirk to pad epout buf size when not aligned to maxpacketsize
Date: Tue, 29 Oct 2013 14:52:57 -0700
Message-Id: <1383083578-16447-3-git-send-email-david.a.cohen@linux.intel.com>
X-Mailer: git-send-email 1.8.4.rc3
In-Reply-To: <1383083578-16447-1-git-send-email-david.a.cohen@linux.intel.com>
References: <1383083578-16447-1-git-send-email-david.a.cohen@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use USB_GADGET_QUIRK_EP_OUT_ALIGNED_SIZE quirk to check if buffer size
requires to be aligned to maxpacketsize of an out endpoint.
ffs_epfile_io() needs to pad epout buffer to match above condition if
quirk is found.

Signed-off-by: David Cohen <david.a.cohen@linux.intel.com>
---
 drivers/usb/gadget/f_fs.c | 17 +++++++++++++++++
 1 file changed, 17 insertions(+)

diff --git a/drivers/usb/gadget/f_fs.c b/drivers/usb/gadget/f_fs.c
index 75e4b78..2988eb7 100644
--- a/drivers/usb/gadget/f_fs.c
+++ b/drivers/usb/gadget/f_fs.c
@@ -755,10 +755,12 @@ static ssize_t ffs_epfile_io(struct file *file,
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
@@ -794,6 +796,21 @@ first_try:
 			goto error;
 		}
 
+		/*
+		 * Controller requires buffer size to be aligned to
+		 * maxpacketsize of an out endpoint.
+		 */
+		if (gadget->quirks & USB_GADGET_QUIRK_EP_OUT_ALIGNED_SIZE &&
+		    read && !IS_ALIGNED(len, ep->ep->desc->wMaxPacketSize)) {
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

