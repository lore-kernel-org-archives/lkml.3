Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755553AbaJHARp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Oct 2014 20:17:45 -0400
Received: from mga02.intel.com ([134.134.136.20]:27049 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755362AbaJHARo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Oct 2014 20:17:44 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,674,1406617200"; 
   d="scan'208";a="585072353"
From: David Cohen <david.a.cohen@linux.intel.com>
To: balbi@ti.com, gregkh@linuxfoundation.org
Cc: mina86@mina86.com, r.baldyga@samsung.com, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        David Cohen <david.a.cohen@linux.intel.com>,
        Qiuxu Zhuo <qiuxu.zhuo@intel.com>
Subject: [PATCH] usb: ffs: fix regression when quirk_ep_out_aligned_size flag is set
Date: Tue,  7 Oct 2014 17:18:06 -0700
Message-Id: <1412727486-479-1-git-send-email-david.a.cohen@linux.intel.com>
X-Mailer: git-send-email 2.1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The commit '2e4c7553cd usb: gadget: f_fs: add aio support' broke the
quirk implemented to align buffer size to maxpacketsize on out endpoint.
As result, functionfs does not work on Intel platforms using dwc3 driver
(i.e. Bay Trail and Merrifield). This patch fixes the issue.

This code is based on a previous Qiuxu's patch.

Signed-off-by: David Cohen <david.a.cohen@linux.intel.com>
Signed-off-by: Qiuxu Zhuo <qiuxu.zhuo@intel.com>
---

Hi,

Since this is a feature that worked in past, this patch is meant for 3.17
kernel. If/when we pass review and accept it on 3.17, I'll send a version for
stable 3.16 kernel too. It is not required for 3.14, since the regression came
later.

Br, David Cohen

---
 drivers/usb/gadget/function/f_fs.c | 21 ++++++++++++++++-----
 1 file changed, 16 insertions(+), 5 deletions(-)

diff --git a/drivers/usb/gadget/function/f_fs.c b/drivers/usb/gadget/function/f_fs.c
index 0dc3552d1360..6e2b8063b170 100644
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
@@ -794,7 +805,7 @@ static ssize_t ffs_epfile_io(struct file *file, struct ffs_io_data *io_data)
 				goto error_lock;
 
 			req->buf      = data;
-			req->length   = io_data->len;
+			req->length   = data_len;
 
 			io_data->buf = data;
 			io_data->ep = ep->ep;
@@ -816,7 +827,7 @@ static ssize_t ffs_epfile_io(struct file *file, struct ffs_io_data *io_data)
 
 			req = ep->req;
 			req->buf      = data;
-			req->length   = io_data->len;
+			req->length   = data_len;
 
 			req->context  = &done;
 			req->complete = ffs_epfile_io_complete;
-- 
2.1.0

