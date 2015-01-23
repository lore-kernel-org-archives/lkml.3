Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754486AbbAWJ2f (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jan 2015 04:28:35 -0500
Received: from mailout4.samsung.com ([203.254.224.34]:15636 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752514AbbAWJ2d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jan 2015 04:28:33 -0500
X-AuditID: cbfee61a-f79c06d000004e71-22-54c2143e3fcd
From: Robert Baldyga <r.baldyga@samsung.com>
To: balbi@ti.com
Cc: gregkh@linuxfoundation.org, mina86@mina86.com, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, k.opasiak@samsung.com,
        Robert Baldyga <r.baldyga@samsung.com>
Subject: [PATCH] usb: gadget: ffs: add eventfd notification about ffs events
Date: Fri, 23 Jan 2015 10:28:18 +0100
Message-id: <1422005298-31321-1-git-send-email-r.baldyga@samsung.com>
X-Mailer: git-send-email 1.9.1
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrNJMWRmVeSWpSXmKPExsVy+t9jAV17kUMhBhPaGC0O3q+3aF68ns3i
	9sRpbBaXd81hs1i0rJXZYsHxFlaLB4d3sjuwe+yfu4bdY92fV0wefVtWMXocv7GdyePzJrkA
	1igum5TUnMyy1CJ9uwSujF9/rzAXfFSoePL8GXsD402pLkZODgkBE4ljz1uYIWwxiQv31rOB
	2EICixglTs7T6GLkArLbmSQez9sBlmAT0JHY8n0CI4gtIiAgsf7FJXaQImaBtYwSVw9OBJsk
	LOAjMfHZcxYQm0VAVWLtrxlMIDavgKvEiTOrGSG2yUmcPDaZdQIj9wJGhlWMoqkFyQXFSem5
	hnrFibnFpXnpesn5uZsYwUHyTGoH48oGi0OMAhyMSjy8DVsOhgixJpYVV+YeYpTgYFYS4Y37
	AhTiTUmsrEotyo8vKs1JLT7EKM3BoiTOq2TfFiIkkJ5YkpqdmlqQWgSTZeLglGpg1PCdkDHv
	e/Iqsy1+IrZdwT4HyrhWRl90K/TiMf9t1ayZ+fCdVnJyxT+mN/z3dIyXzl3wOWjNsy3h0QzP
	bh1abm74Ydk6A4aMqL2u9s7eUxW+LpYrYF959tK81eqep5d8/v3nafTNX0uLy8w/fTyfdIeP
	6VCnbzpbUL6Q5MGs5IkeNy5tVX5UqsRSnJFoqMVcVJwIAHst8KQOAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add eventfd which notifies userspace about ep0 events and AIO completion
events. It simplifies using of FunctionFS with event loop, because now
we need to poll on single file (instead of polling on ep0 and eventfd's
supplied to AIO layer).

FunctionFS eventfd is not triggered if another eventfd is supplied to
AIO layer (in AIO request). It can be useful, for example, when we want
to handle AIO transations for chosen endpoint in separate thread.

Signed-off-by: Robert Baldyga <r.baldyga@samsung.com>
---
 drivers/usb/gadget/function/f_fs.c  | 29 ++++++++++++++++++++++++++++-
 drivers/usb/gadget/function/u_fs.h  |  1 +
 include/uapi/linux/usb/functionfs.h |  1 +
 3 files changed, 30 insertions(+), 1 deletion(-)

diff --git a/drivers/usb/gadget/function/f_fs.c b/drivers/usb/gadget/function/f_fs.c
index e78a2c6..dc7f816 100644
--- a/drivers/usb/gadget/function/f_fs.c
+++ b/drivers/usb/gadget/function/f_fs.c
@@ -31,6 +31,7 @@
 #include <linux/aio.h>
 #include <linux/mmu_context.h>
 #include <linux/poll.h>
+#include <linux/eventfd.h>
 
 #include "u_fs.h"
 #include "u_f.h"
@@ -153,6 +154,8 @@ struct ffs_io_data {
 
 	struct usb_ep *ep;
 	struct usb_request *req;
+
+	struct ffs_data *ffs;
 };
 
 struct ffs_desc_helper {
@@ -674,6 +677,9 @@ static void ffs_user_copy_worker(struct work_struct *work)
 
 	aio_complete(io_data->kiocb, ret, ret);
 
+	if (io_data->ffs->ffs_eventfd && !io_data->kiocb->ki_eventfd)
+		eventfd_signal(io_data->ffs->ffs_eventfd, 1);
+
 	usb_ep_free_request(io_data->ep, io_data->req);
 
 	io_data->kiocb->private = NULL;
@@ -827,6 +833,7 @@ static ssize_t ffs_epfile_io(struct file *file, struct ffs_io_data *io_data)
 			io_data->buf = data;
 			io_data->ep = ep->ep;
 			io_data->req = req;
+			io_data->ffs = epfile->ffs;
 
 			req->context  = io_data;
 			req->complete = ffs_epfile_async_io_complete;
@@ -1510,6 +1517,9 @@ static void ffs_data_clear(struct ffs_data *ffs)
 	if (ffs->epfiles)
 		ffs_epfiles_destroy(ffs->epfiles, ffs->eps_count);
 
+	if (ffs->ffs_eventfd)
+		eventfd_ctx_put(ffs->ffs_eventfd);
+
 	kfree(ffs->raw_descs_data);
 	kfree(ffs->raw_strings);
 	kfree(ffs->stringtabs);
@@ -2169,7 +2179,8 @@ static int __ffs_data_got_descs(struct ffs_data *ffs,
 			      FUNCTIONFS_HAS_HS_DESC |
 			      FUNCTIONFS_HAS_SS_DESC |
 			      FUNCTIONFS_HAS_MS_OS_DESC |
-			      FUNCTIONFS_VIRTUAL_ADDR)) {
+			      FUNCTIONFS_VIRTUAL_ADDR |
+			      FUNCTIONFS_EVENTFD)) {
 			ret = -ENOSYS;
 			goto error;
 		}
@@ -2180,6 +2191,20 @@ static int __ffs_data_got_descs(struct ffs_data *ffs,
 		goto error;
 	}
 
+	if (flags & FUNCTIONFS_EVENTFD) {
+		if (len < 4)
+			goto error;
+		ffs->ffs_eventfd =
+			eventfd_ctx_fdget((int)get_unaligned_le32(data));
+		if (IS_ERR(ffs->ffs_eventfd)) {
+			ffs->ffs_eventfd = NULL;
+			ret = PTR_ERR(ffs->ffs_eventfd);
+			goto error;
+		}
+		data += 4;
+		len  -= 4;
+	}
+
 	/* Read fs_count, hs_count and ss_count (if present) */
 	for (i = 0; i < 3; ++i) {
 		if (!(flags & (1 << i))) {
@@ -2454,6 +2479,8 @@ static void __ffs_event_add(struct ffs_data *ffs,
 	pr_vdebug("adding event %d\n", type);
 	ffs->ev.types[ffs->ev.count++] = type;
 	wake_up_locked(&ffs->ev.waitq);
+	if (ffs->ffs_eventfd)
+		eventfd_signal(ffs->ffs_eventfd, 1);
 }
 
 static void ffs_event_add(struct ffs_data *ffs,
diff --git a/drivers/usb/gadget/function/u_fs.h b/drivers/usb/gadget/function/u_fs.h
index 284a1f0..6013985 100644
--- a/drivers/usb/gadget/function/u_fs.h
+++ b/drivers/usb/gadget/function/u_fs.h
@@ -272,6 +272,7 @@ struct ffs_data {
 		kgid_t				gid;
 	}				file_perms;
 
+	struct eventfd_ctx *ffs_eventfd;
 	bool no_disconnect;
 	struct work_struct reset_work;
 
diff --git a/include/uapi/linux/usb/functionfs.h b/include/uapi/linux/usb/functionfs.h
index 295ba29..108dd79 100644
--- a/include/uapi/linux/usb/functionfs.h
+++ b/include/uapi/linux/usb/functionfs.h
@@ -20,6 +20,7 @@ enum functionfs_flags {
 	FUNCTIONFS_HAS_SS_DESC = 4,
 	FUNCTIONFS_HAS_MS_OS_DESC = 8,
 	FUNCTIONFS_VIRTUAL_ADDR = 16,
+	FUNCTIONFS_EVENTFD = 32,
 };
 
 /* Descriptor of an non-audio endpoint */
-- 
1.9.1

