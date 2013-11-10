Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752056Ab3KJQu6 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Nov 2013 11:50:58 -0500
Received: from mail-ea0-f169.google.com ([209.85.215.169]:61439 "EHLO
	mail-ea0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751851Ab3KJQuu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Nov 2013 11:50:50 -0500
From: Michal Nazarewicz <mpn@google.com>
To: David Cohen <david.a.cohen@linux.intel.com>,
        Alan Stern <stern@rowland.harvard.edu>
Cc: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        Michal Nazarewicz <mina86@mina86.com>
Subject: [PATCH 2/2] check quirk to pad epout buf size when not aligned to maxpacketsize
Date: Sun, 10 Nov 2013 17:50:37 +0100
Message-Id: <1384102237-19784-2-git-send-email-mpn@google.com>
X-Mailer: git-send-email 1.8.4.1
In-Reply-To: <1384102237-19784-1-git-send-email-mpn@google.com>
References: <1384102237-19784-1-git-send-email-mpn@google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Michal Nazarewicz <mina86@mina86.com>

Check gadget.quirk_ep_out_aligned_size to decide if buffer size requires
to be aligned to maxpacketsize of an out endpoint.  ffs_epfile_io() needs
to pad epout buffer to match above condition if quirk is found.

Signed-off-by: Michal Nazarewicz <mina86@mina86.com>
---
 I'm wondering whether the len should be aligned down rather then up.
 This would have it's own problems, but maybe better then
 a possibility of silently dropping data.

 drivers/usb/gadget/f_fs.c | 21 ++++++++++++++++++---
 1 file changed, 18 insertions(+), 3 deletions(-)

diff --git a/drivers/usb/gadget/f_fs.c b/drivers/usb/gadget/f_fs.c
index f875f26..ea0b8ba 100644
--- a/drivers/usb/gadget/f_fs.c
+++ b/drivers/usb/gadget/f_fs.c
@@ -753,8 +753,9 @@ static ssize_t ffs_epfile_io(struct file *file,
 			     char __user *buf, size_t len, int read)
 {
 	struct ffs_epfile *epfile = file->private_data;
+	struct usb_gadget *gadget = epfile->ffs->gadget;
 	struct ffs_ep *ep;
-	ssize_t ret;
+	ssize_t ret, data_len;
 	char *data;
 	int halt;
 
@@ -787,6 +788,13 @@ static ssize_t ffs_epfile_io(struct file *file,
 
 	/* Allocate & copy */
 	if (!halt) {
+		/*
+		 * Controller requires buffer size to be aligned to
+		 * maxpacketsize of an out endpoint.
+		 */
+		data_len = read && gadget->quirk_ep_out_aligned_size ?
+			usb_ep_align_maxpacketsize(ep->ep, len) : len;
+
 		data = kmalloc(len, GFP_KERNEL);
 		if (unlikely(!data))
 			return -ENOMEM;
@@ -824,7 +832,7 @@ static ssize_t ffs_epfile_io(struct file *file,
 		req->context  = &done;
 		req->complete = ffs_epfile_io_complete;
 		req->buf      = data;
-		req->length   = len;
+		req->length   = data_len;
 
 		ret = usb_ep_queue(ep->ep, req, GFP_ATOMIC);
 
@@ -836,9 +844,16 @@ static ssize_t ffs_epfile_io(struct file *file,
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
1.8.3.2

