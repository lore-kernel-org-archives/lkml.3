Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751439Ab3LIXwE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Dec 2013 18:52:04 -0500
Received: from mga02.intel.com ([134.134.136.20]:45387 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751252Ab3LIXvN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Dec 2013 18:51:13 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,861,1378882800"; 
   d="scan'208";a="421949714"
From: David Cohen <david.a.cohen@linux.intel.com>
To: balbi@ti.com, gregkh@linuxfoundation.org
Cc: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org, mina86@mina86.com,
        stern@rowland.harvard.edu, David Cohen <david.a.cohen@linux.intel.com>
Subject: [PATCH v7 3/5] usb: gadget: f_fs: remove loop from I/O function
Date: Mon,  9 Dec 2013 15:55:36 -0800
Message-Id: <1386633338-10919-4-git-send-email-david.a.cohen@linux.intel.com>
X-Mailer: git-send-email 1.8.4.2
In-Reply-To: <1386633338-10919-1-git-send-email-david.a.cohen@linux.intel.com>
References: <1386633338-10919-1-git-send-email-david.a.cohen@linux.intel.com>
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
 drivers/usb/gadget/f_fs.c | 94 ++++++++++++++++++++---------------------------
 1 file changed, 40 insertions(+), 54 deletions(-)

diff --git a/drivers/usb/gadget/f_fs.c b/drivers/usb/gadget/f_fs.c
index 75e4b7846a8d..efa1152a4c15 100644
--- a/drivers/usb/gadget/f_fs.c
+++ b/drivers/usb/gadget/f_fs.c
@@ -760,73 +760,59 @@ static ssize_t ffs_epfile_io(struct file *file,
 	ssize_t ret;
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
+		ret = wait_event_interruptible(epfile->wait, (ep = epfile->ep));
+		if (ret) {
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
 
-		/*
-		 * While we were acquiring mutex endpoint got disabled
-		 * or changed?
-		 */
-	} while (unlikely(epfile->ep != ep));
+	spin_lock_irq(&epfile->ffs->eps_lock);
 
-	/* Halt */
-	if (unlikely(halt)) {
+	if (epfile->ep != ep) {
+		/* In the meantime, endpoint got disabled or changed. */
+		ret = -ESHUTDOWN;
+		spin_unlock_irq(&epfile->ffs->eps_lock);
+	} else if (halt) {
+		/* Halt */
 		if (likely(epfile->ep == ep) && !WARN_ON(!ep->ep))
 			usb_ep_set_halt(ep->ep);
 		spin_unlock_irq(&epfile->ffs->eps_lock);
-- 
1.8.4.2

