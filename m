Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753120Ab3KKUMo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Nov 2013 15:12:44 -0500
Received: from mga09.intel.com ([134.134.136.24]:8575 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751427Ab3KKUMb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Nov 2013 15:12:31 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,535,1378882800"; 
   d="scan'208";a="433422450"
From: David Cohen <david.a.cohen@linux.intel.com>
To: balbi@ti.com, gregkh@linuxfoundation.org
Cc: stern@rowland.harvard.edu, mina86@mina86.com, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        David Cohen <david.a.cohen@linux.intel.com>
Subject: [PATCH v5 3/5] usb: gadget: f_fs: remove loop from I/O function
Date: Mon, 11 Nov 2013 12:16:49 -0800
Message-Id: <1384201011-11114-4-git-send-email-david.a.cohen@linux.intel.com>
X-Mailer: git-send-email 1.8.4.rc3
In-Reply-To: <1384201011-11114-1-git-send-email-david.a.cohen@linux.intel.com>
References: <1384201011-11114-1-git-send-email-david.a.cohen@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Michal Nazarewicz <mina86@mina86.com>

When endpoint changes (due to it being disabled or alt setting changed),
mimic the action as if the change happened after the request has been
queued, instead of retrying with the new endpoint.

Signed-off-by: Michal Nazarewicz <mina86@mina86.com>
Cc: David Cohen <david.a.cohen@linux.intel.com>
---
 drivers/usb/gadget/f_fs.c | 94 +++++++++++++++++++++--------------------------
 1 file changed, 41 insertions(+), 53 deletions(-)

diff --git a/drivers/usb/gadget/f_fs.c b/drivers/usb/gadget/f_fs.c
index 75e4b7846a8d..f1563c47e0c2 100644
--- a/drivers/usb/gadget/f_fs.c
+++ b/drivers/usb/gadget/f_fs.c
@@ -756,74 +756,61 @@ static ssize_t ffs_epfile_io(struct file *file,
 {
 	struct ffs_epfile *epfile = file->private_data;
 	struct ffs_ep *ep;
-	char *data = NULL;
 	ssize_t ret;
+	char *data;
 	int halt;
 
-	goto first_try;
-	do {
-		spin_unlock_irq(&epfile->ffs->eps_lock);
-		mutex_unlock(&epfile->mutex);
+	/* Are we still active? */
+	if (WARN_ON(epfile->ffs->state != FFS_ACTIVE)) {
+		ret = -ENODEV;
+		goto error;
+	}
 
-first_try:
-		/* Are we still active? */
-		if (WARN_ON(epfile->ffs->state != FFS_ACTIVE)) {
-			ret = -ENODEV;
+	/* Wait for endpoint to be enabled */
+	ep = epfile->ep;
+	if (!ep) {
+		if (file->f_flags & O_NONBLOCK) {
+			ret = -EAGAIN;
 			goto error;
 		}
 
-		/* Wait for endpoint to be enabled */
-		ep = epfile->ep;
-		if (!ep) {
-			if (file->f_flags & O_NONBLOCK) {
-				ret = -EAGAIN;
-				goto error;
-			}
-
-			if (wait_event_interruptible(epfile->wait,
-						     (ep = epfile->ep))) {
-				ret = -EINTR;
-				goto error;
-			}
-		}
-
-		/* Do we halt? */
-		halt = !read == !epfile->in;
-		if (halt && epfile->isoc) {
-			ret = -EINVAL;
+		if (wait_event_interruptible(epfile->wait, (ep = epfile->ep))) {
+			ret = -EINTR;
 			goto error;
 		}
+	}
 
-		/* Allocate & copy */
-		if (!halt && !data) {
-			data = kzalloc(len, GFP_KERNEL);
-			if (unlikely(!data))
-				return -ENOMEM;
+	/* Do we halt? */
+	halt = !read == !epfile->in;
+	if (halt && epfile->isoc) {
+		ret = -EINVAL;
+		goto error;
+	}
 
-			if (!read &&
-			    unlikely(__copy_from_user(data, buf, len))) {
-				ret = -EFAULT;
-				goto error;
-			}
-		}
+	/* Allocate & copy */
+	if (!halt) {
+		data = kmalloc(len, GFP_KERNEL);
+		if (unlikely(!data))
+			return -ENOMEM;
 
-		/* We will be using request */
-		ret = ffs_mutex_lock(&epfile->mutex,
-				     file->f_flags & O_NONBLOCK);
-		if (unlikely(ret))
+		if (!read && unlikely(copy_from_user(data, buf, len))) {
+			ret = -EFAULT;
 			goto error;
+		}
+	}
 
-		/*
-		 * We're called from user space, we can use _irq rather then
-		 * _irqsave
-		 */
-		spin_lock_irq(&epfile->ffs->eps_lock);
+	/* We will be using request */
+	ret = ffs_mutex_lock(&epfile->mutex, file->f_flags & O_NONBLOCK);
+	if (unlikely(ret))
+		goto error;
+	spin_lock_irq(&epfile->ffs->eps_lock);
 
-		/*
-		 * While we were acquiring mutex endpoint got disabled
-		 * or changed?
-		 */
-	} while (unlikely(epfile->ep != ep));
+	/* While we were acquiring mutex endpoint got disabled or changed. */
+	if (epfile->ep != ep) {
+		ret = -ESHUTDOWN;
+		spin_unlock_irq(&epfile->ffs->eps_lock);
+		goto error_unlock;
+	}
 
 	/* Halt */
 	if (unlikely(halt)) {
@@ -858,6 +845,7 @@ first_try:
 		}
 	}
 
+error_unlock:
 	mutex_unlock(&epfile->mutex);
 error:
 	kfree(data);
-- 
1.8.4.rc3

