Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754334AbaKKLLG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2014 06:11:06 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:57708 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754286AbaKKLK6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2014 06:10:58 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: David Cohen <david.a.cohen@linux.intel.com>,
        Qiuxu Zhuo <qiuxu.zhuo@intel.com>, Felipe Balbi <balbi@ti.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.16.y-ckt 121/170] usb: ffs: fix regression when quirk_ep_out_aligned_size flag is set
Date: Tue, 11 Nov 2014 11:08:00 +0000
Message-Id: <1415704129-12709-122-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1415704129-12709-1-git-send-email-luis.henriques@canonical.com>
References: <1415704129-12709-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.16
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.16.7-ckt1 -stable review patch.  If anyone has any objections, please let me know.

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
[ luis: backported to 3.16: file rename:
  drivers/usb/gadget/function/f_fs.c -> drivers/usb/gadget/f_fs.c ]
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/usb/gadget/f_fs.c | 40 ++++++++++++++++++++++++++++++++++------
 1 file changed, 34 insertions(+), 6 deletions(-)

diff --git a/drivers/usb/gadget/f_fs.c b/drivers/usb/gadget/f_fs.c
index 538300c05c5a..7a5167088de1 100644
--- a/drivers/usb/gadget/f_fs.c
+++ b/drivers/usb/gadget/f_fs.c
@@ -641,15 +641,26 @@ static void ffs_user_copy_worker(struct work_struct *work)
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
@@ -681,7 +692,7 @@ static ssize_t ffs_epfile_io(struct file *file, struct ffs_io_data *io_data)
 	struct ffs_epfile *epfile = file->private_data;
 	struct ffs_ep *ep;
 	char *data = NULL;
-	ssize_t ret, data_len;
+	ssize_t ret, data_len = -EINVAL;
 	int halt;
 
 	/* Are we still active? */
@@ -781,13 +792,30 @@ static ssize_t ffs_epfile_io(struct file *file, struct ffs_io_data *io_data)
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
@@ -809,7 +837,7 @@ static ssize_t ffs_epfile_io(struct file *file, struct ffs_io_data *io_data)
 
 			req = ep->req;
 			req->buf      = data;
-			req->length   = io_data->len;
+			req->length   = data_len;
 
 			req->context  = &done;
 			req->complete = ffs_epfile_io_complete;
-- 
2.1.0

