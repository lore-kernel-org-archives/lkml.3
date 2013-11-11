Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753371Ab3KKUNY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Nov 2013 15:13:24 -0500
Received: from mga09.intel.com ([134.134.136.24]:8575 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752876Ab3KKUMb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Nov 2013 15:12:31 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,535,1378882800"; 
   d="scan'208";a="433422451"
From: David Cohen <david.a.cohen@linux.intel.com>
To: balbi@ti.com, gregkh@linuxfoundation.org
Cc: stern@rowland.harvard.edu, mina86@mina86.com, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v5 4/5] usb: f_fs: check quirk to pad epout buf size when not aligned to maxpacketsize
Date: Mon, 11 Nov 2013 12:16:50 -0800
Message-Id: <1384201011-11114-5-git-send-email-david.a.cohen@linux.intel.com>
X-Mailer: git-send-email 1.8.4.rc3
In-Reply-To: <1384201011-11114-1-git-send-email-david.a.cohen@linux.intel.com>
References: <1384201011-11114-1-git-send-email-david.a.cohen@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Michal Nazarewicz <mina86@mina86.com>

Check gadget.quirk_ep_out_aligned_size to decide if buffer size requires
to be aligned to maxpacketsize of an out endpoint.  ffs_epfile_io() needs
to pad epout buffer to match above condition if quirk is found.

Signed-off-by: Michal Nazarewicz <mina86@mina86.com>
Acked-by: David Cohen <david.a.cohen@linux.intel.com>
---
 drivers/usb/gadget/f_fs.c | 23 +++++++++++++++++++----
 1 file changed, 19 insertions(+), 4 deletions(-)

diff --git a/drivers/usb/gadget/f_fs.c b/drivers/usb/gadget/f_fs.c
index f1563c47e0c2..c49288778fe0 100644
--- a/drivers/usb/gadget/f_fs.c
+++ b/drivers/usb/gadget/f_fs.c
@@ -755,8 +755,9 @@ static ssize_t ffs_epfile_io(struct file *file,
 			     char __user *buf, size_t len, int read)
 {
 	struct ffs_epfile *epfile = file->private_data;
+	struct usb_gadget *gadget = epfile->ffs->gadget;
 	struct ffs_ep *ep;
-	ssize_t ret;
+	ssize_t ret, data_len;
 	char *data;
 	int halt;
 
@@ -789,7 +790,14 @@ static ssize_t ffs_epfile_io(struct file *file,
 
 	/* Allocate & copy */
 	if (!halt) {
-		data = kmalloc(len, GFP_KERNEL);
+		/*
+		 * Controller requires buffer size to be aligned to
+		 * maxpacketsize of an out endpoint.
+		 */
+		data_len = read && gadget->quirk_ep_out_aligned_size ?
+			usb_ep_align_maxpacketsize(ep->ep, len) : len;
+
+		data = kmalloc(data_len, GFP_KERNEL);
 		if (unlikely(!data))
 			return -ENOMEM;
 
@@ -826,7 +834,7 @@ static ssize_t ffs_epfile_io(struct file *file,
 		req->context  = &done;
 		req->complete = ffs_epfile_io_complete;
 		req->buf      = data;
-		req->length   = len;
+		req->length   = data_len;
 
 		ret = usb_ep_queue(ep->ep, req, GFP_ATOMIC);
 
@@ -838,9 +846,16 @@ static ssize_t ffs_epfile_io(struct file *file,
 			ret = -EINTR;
 			usb_ep_dequeue(ep->ep, req);
 		} else {
+			/*
+			 * XXX We may end up silently droping data here.
+			 * Since data_len (i.e. req->length) may be bigger
+			 * than len (after being rounded up to maxpacketsize),
+			 * we may end up with more data then user space has
+			 * space for.
+			 */
 			ret = ep->status;
 			if (read && ret > 0 &&
-			    unlikely(copy_to_user(buf, data, ret)))
+			    unlikely(copy_to_user(buf, data, min(ret, len))))
 				ret = -EFAULT;
 		}
 	}
-- 
1.8.4.rc3

