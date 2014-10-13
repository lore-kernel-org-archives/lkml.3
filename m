Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754612AbaJMSQX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Oct 2014 14:16:23 -0400
Received: from mga02.intel.com ([134.134.136.20]:14826 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752453AbaJMSQW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Oct 2014 14:16:22 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,712,1406617200"; 
   d="scan'208";a="617882890"
From: David Cohen <david.a.cohen@linux.intel.com>
To: balbi@ti.com, gregkh@linuxfoundation.org
Cc: mina86@mina86.com, r.baldyga@samsung.com, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        David Cohen <david.a.cohen@linux.intel.com>,
        Qiuxu Zhuo <qiuxu.zhuo@intel.com>
Subject: [PATCH v3] usb: ffs: fix regression when quirk_ep_out_aligned_size flag is set
Date: Mon, 13 Oct 2014 11:15:54 -0700
Message-Id: <1413224154-20948-1-git-send-email-david.a.cohen@linux.intel.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1412802738-28839-1-git-send-email-david.a.cohen@linux.intel.com>
References: <1412802738-28839-1-git-send-email-david.a.cohen@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The commit '2e4c7553cd usb: gadget: f_fs: add aio support' broke the
quirk implemented to align buffer size to maxpacketsize on out endpoint.
As result, functionfs does not work on Intel platforms using dwc3 driver
(i.e. Bay Trail and Merrifield). This patch fixes the issue.

This code is based on a previous Qiuxu's patch.

Fixes: 2e4c7553cd (usb: gadget: f_fs: add aio support)
Cc: <stable@vger.kernel.org> # v3.16+
Signed-off-by: David Cohen <david.a.cohen@linux.intel.com>
Signed-off-by: Qiuxu Zhuo <qiuxu.zhuo@intel.com>
Acked-by: Michal Nazarewicz <mina86@mina86.com>
---

Hi,

Since this is a feature that worked in past, this is meant for stable
versions >= 3.16 too.

v1 to v2: just added Fixes, Cc and Acked-by lines on patch description.
v2 to v3: fixed compiler warning about data_len being used unitialized

Br, David Cohen

---
 drivers/usb/gadget/function/f_fs.c | 40 ++++++++++++++++++++++++++++++++------
 1 file changed, 34 insertions(+), 6 deletions(-)

diff --git a/drivers/usb/gadget/function/f_fs.c b/drivers/usb/gadget/function/f_fs.c
index 0dc3552d1360..9b6bc4d30352 100644
--- a/drivers/usb/gadget/function/f_fs.c
+++ b/drivers/usb/gadget/function/f_fs.c
@@ -648,15 +648,26 @@ static void ffs_user_copy_worker(struct work_struct *work)
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
@@ -688,7 +699,7 @@ static ssize_t ffs_epfile_io(struct file *file, struct ffs_io_data *io_data)
 	struct ffs_epfile *epfile = file->private_data;
 	struct ffs_ep *ep;
 	char *data = NULL;
-	ssize_t ret, data_len;
+	ssize_t ret, data_len = -EINVAL;
 	int halt;
 
 	/* Are we still active? */
@@ -788,13 +799,30 @@ static ssize_t ffs_epfile_io(struct file *file, struct ffs_io_data *io_data)
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
@@ -816,7 +844,7 @@ static ssize_t ffs_epfile_io(struct file *file, struct ffs_io_data *io_data)
 
 			req = ep->req;
 			req->buf      = data;
-			req->length   = io_data->len;
+			req->length   = data_len;
 
 			req->context  = &done;
 			req->complete = ffs_epfile_io_complete;
-- 
2.1.0

