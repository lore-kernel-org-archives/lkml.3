Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754616AbaKLBc6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2014 20:32:58 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:59440 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753915AbaKLBcz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2014 20:32:55 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        David Cohen <david.a.cohen@linux.intel.com>,
        Qiuxu Zhuo <qiuxu.zhuo@intel.com>,
        Michal Nazarewicz <mina86@mina86.com>, Felipe Balbi <balbi@ti.com>
Subject: [PATCH 3.17 220/319] usb: ffs: fix regression when quirk_ep_out_aligned_size flag is set
Date: Wed, 12 Nov 2014 10:15:58 +0900
Message-Id: <20141112011029.163445535@linuxfoundation.org>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <20141112010952.553519040@linuxfoundation.org>
References: <20141112010952.553519040@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: David Cohen <david.a.cohen@linux.intel.com>

commit c0d31b3c3d9a025b8d5a57c35671e60c5f388bf7 upstream.

The commit '2e4c7553cd usb: gadget: f_fs: add aio support' broke the
quirk implemented to align buffer size to maxpacketsize on out endpoint.
As result, functionfs does not work on Intel platforms using dwc3 driver
(i.e. Bay Trail and Merrifield). This patch fixes the issue.

This code is based on a previous Qiuxu's patch.

Fixes: 2e4c7553cd (usb: gadget: f_fs: add aio support)
Signed-off-by: David Cohen <david.a.cohen@linux.intel.com>
Signed-off-by: Qiuxu Zhuo <qiuxu.zhuo@intel.com>
Acked-by: Michal Nazarewicz <mina86@mina86.com>
Signed-off-by: Felipe Balbi <balbi@ti.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/usb/gadget/function/f_fs.c |   40 +++++++++++++++++++++++++++++++------
 1 file changed, 34 insertions(+), 6 deletions(-)

--- a/drivers/usb/gadget/function/f_fs.c
+++ b/drivers/usb/gadget/function/f_fs.c
@@ -648,15 +648,26 @@ static void ffs_user_copy_worker(struct
 	if (io_data->read && ret > 0) {
 		int i;
 		size_t pos = 0;
+
+		/*
+		 * Since req->length may be bigger than io_data->len (after
+		 * being rounded up to maxpacketsize), we may end up with more
+		 * data then user space has space for.
+		 */
+		ret = min_t(int, ret, io_data->len);
+
 		use_mm(io_data->mm);
 		for (i = 0; i < io_data->nr_segs; i++) {
+			size_t len = min_t(size_t, ret - pos,
+					io_data->iovec[i].iov_len);
+			if (!len)
+				break;
 			if (unlikely(copy_to_user(io_data->iovec[i].iov_base,
-						 &io_data->buf[pos],
-						 io_data->iovec[i].iov_len))) {
+						 &io_data->buf[pos], len))) {
 				ret = -EFAULT;
 				break;
 			}
-			pos += io_data->iovec[i].iov_len;
+			pos += len;
 		}
 		unuse_mm(io_data->mm);
 	}
@@ -688,7 +699,7 @@ static ssize_t ffs_epfile_io(struct file
 	struct ffs_epfile *epfile = file->private_data;
 	struct ffs_ep *ep;
 	char *data = NULL;
-	ssize_t ret, data_len;
+	ssize_t ret, data_len = -EINVAL;
 	int halt;
 
 	/* Are we still active? */
@@ -788,13 +799,30 @@ static ssize_t ffs_epfile_io(struct file
 		/* Fire the request */
 		struct usb_request *req;
 
+		/*
+		 * Sanity Check: even though data_len can't be used
+		 * uninitialized at the time I write this comment, some
+		 * compilers complain about this situation.
+		 * In order to keep the code clean from warnings, data_len is
+		 * being initialized to -EINVAL during its declaration, which
+		 * means we can't rely on compiler anymore to warn no future
+		 * changes won't result in data_len being used uninitialized.
+		 * For such reason, we're adding this redundant sanity check
+		 * here.
+		 */
+		if (unlikely(data_len == -EINVAL)) {
+			WARN(1, "%s: data_len == -EINVAL\n", __func__);
+			ret = -EINVAL;
+			goto error_lock;
+		}
+
 		if (io_data->aio) {
 			req = usb_ep_alloc_request(ep->ep, GFP_KERNEL);
 			if (unlikely(!req))
 				goto error_lock;
 
 			req->buf      = data;
-			req->length   = io_data->len;
+			req->length   = data_len;
 
 			io_data->buf = data;
 			io_data->ep = ep->ep;
@@ -816,7 +844,7 @@ static ssize_t ffs_epfile_io(struct file
 
 			req = ep->req;
 			req->buf      = data;
-			req->length   = io_data->len;
+			req->length   = data_len;
 
 			req->context  = &done;
 			req->complete = ffs_epfile_io_complete;


