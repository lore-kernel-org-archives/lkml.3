Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751951Ab3KJQuu (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Nov 2013 11:50:50 -0500
Received: from mail-ee0-f51.google.com ([74.125.83.51]:61030 "EHLO
	mail-ee0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751718Ab3KJQus (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Nov 2013 11:50:48 -0500
From: Michal Nazarewicz <mpn@google.com>
To: David Cohen <david.a.cohen@linux.intel.com>,
        Alan Stern <stern@rowland.harvard.edu>
Cc: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        Michal Nazarewicz <mina86@mina86.com>
Subject: [PATCH 1/2] usb: gadget: f_fs: remove loop from I/O function
Date: Sun, 10 Nov 2013 17:50:36 +0100
Message-Id: <1384102237-19784-1-git-send-email-mpn@google.com>
X-Mailer: git-send-email 1.8.4.1
In-Reply-To: <1383603177-4624-4-git-send-email-david.a.cohen@linux.intel.com>
References: <1383603177-4624-4-git-send-email-david.a.cohen@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Michal Nazarewicz <mina86@mina86.com>

When endpoint changes (due to it being disabled or alt setting changed),
mimic the action as if the change happened after the request has been
queued, instead of retrying with the new endpoint.

Signed-off-by: Michal Nazarewicz <mina86@mina86.com>
---
 drivers/usb/gadget/f_fs.c | 94 +++++++++++++++++++++--------------------------
 1 file changed, 41 insertions(+), 53 deletions(-)

diff --git a/drivers/usb/gadget/f_fs.c b/drivers/usb/gadget/f_fs.c
index 44cf775..f875f26 100644
--- a/drivers/usb/gadget/f_fs.c
+++ b/drivers/usb/gadget/f_fs.c
@@ -754,74 +754,61 @@ static ssize_t ffs_epfile_io(struct file *file,
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
@@ -856,6 +843,7 @@ first_try:
 		}
 	}

+error_unlock:
 	mutex_unlock(&epfile->mutex);
 error:
 	kfree(data);
--
1.8.3.2
