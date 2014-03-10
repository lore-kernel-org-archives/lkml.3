Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753166AbaCJId6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Mar 2014 04:33:58 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:27056 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753093AbaCJIdz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Mar 2014 04:33:55 -0400
X-AuditID: cbfee61b-b7f456d000006dfd-0b-531d78f26df1
From: Robert Baldyga <r.baldyga@samsung.com>
To: balbi@ti.com
Cc: gregkh@linuxfoundation.org, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, mina86@mina86.com,
        m.szyprowski@samsung.com, andrzej.p@samsung.com,
        Robert Baldyga <r.baldyga@samsung.com>
Subject: [PATCH] usb: gadget: f_fs: add missing spinlock and mutex unlock
Date: Mon, 10 Mar 2014 09:33:37 +0100
Message-id: <1394440417-6100-1-git-send-email-r.baldyga@samsung.com>
X-Mailer: git-send-email 1.7.9.5
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrPJMWRmVeSWpSXmKPExsVy+t9jAd1PFbLBBp+fKVnMetnOYnHwfr1F
	8+L1bBaXd81hs1i0rJXZYu2Ru+wWC463sFo8OLyT3YHDY//cNewe6/68YvLo27KK0eP4je1M
	Hp83yQWwRnHZpKTmZJalFunbJXBlvFywh61gBlfF32Mr2RsYp3F0MXJySAiYSHQcm8gEYYtJ
	XLi3nq2LkYtDSGARo0TXgwtQTjuTxOfXy8Cq2AR0JLZ8n8AIYosICEisf3GJHaSIWeA4o8TM
	T1+Aijg4hAU8JR6+NwSpYRFQlfj74zg7iM0r4CJxt28RC0iJhICCxJxJNhMYuRcwMqxiFE0t
	SC4oTkrPNdIrTswtLs1L10vOz93ECA6WZ9I7GFc1WBxiFOBgVOLhPfBWJliINbGsuDL3EKME
	B7OSCG9GnGywEG9KYmVValF+fFFpTmrxIUZpDhYlcd6DrdaBQgLpiSWp2ampBalFMFkmDk6p
	Bkb9R2riO/98XPotn6H9rhLHyng7vgmqMuLLm/w8KlInG959sHFC00TtO5f3H72yq1LK78H8
	7DzjeenJ26T3vzD4v+jdw60beWeySJuv+VEs8zewdDf/zE2bFdef/WM94UvQn1dhfrMLbv0N
	59vCeOO43oLDS9xu7g76LtfNd1Bg1bFWMZaX/FEPlViKMxINtZiLihMBBh+gbxICAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds missing spin_unlock and mutex_unlock calls in
error handling code.

Signed-off-by: Robert Baldyga <r.baldyga@samsung.com>
---
 drivers/usb/gadget/f_fs.c |    8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/usb/gadget/f_fs.c b/drivers/usb/gadget/f_fs.c
index b7d273a..d6bd0a3 100644
--- a/drivers/usb/gadget/f_fs.c
+++ b/drivers/usb/gadget/f_fs.c
@@ -802,7 +802,7 @@ static ssize_t ffs_epfile_io(struct file *file, struct ffs_io_data *io_data)
 		if (io_data->aio) {
 			req = usb_ep_alloc_request(ep->ep, GFP_KERNEL);
 			if (unlikely(!req))
-				goto error;
+				goto error_lock;
 
 			req->buf      = data;
 			req->length   = io_data->len;
@@ -817,7 +817,7 @@ static ssize_t ffs_epfile_io(struct file *file, struct ffs_io_data *io_data)
 			ret = usb_ep_queue(ep->ep, req, GFP_ATOMIC);
 			if (unlikely(ret)) {
 				usb_ep_free_request(ep->ep, req);
-				goto error;
+				goto error_lock;
 			}
 			ret = -EIOCBQUEUED;
 
@@ -863,6 +863,10 @@ static ssize_t ffs_epfile_io(struct file *file, struct ffs_io_data *io_data)
 
 	mutex_unlock(&epfile->mutex);
 	return ret;
+
+error_lock:
+	spin_unlock_irq(&epfile->ffs->eps_lock);
+	mutex_unlock(&epfile->mutex);
 error:
 	kfree(data);
 	return ret;
-- 
1.7.9.5

