Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752572AbaE0OGh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 May 2014 10:06:37 -0400
Received: from mail.mev.co.uk ([62.49.15.74]:50809 "EHLO mail.mev.co.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751713AbaE0OGf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 May 2014 10:06:35 -0400
From: Ian Abbott <abbotti@mev.co.uk>
To: driverdev-devel@linuxdriverproject.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Ian Abbott <abbotti@mev.co.uk>,
        H Hartley Sweeten <hartleys@visionengravers.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH] staging: comedi: remove in_request_module
Date: Tue, 27 May 2014 15:06:17 +0100
Message-Id: <1401199577-3882-1-git-send-email-abbotti@mev.co.uk>
X-Mailer: git-send-email 1.9.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The `in_request_module` member of `struct comedi_device` is only ever
set to `false`, so remove the code that checks for it being `true` and
remove the member.

Signed-off-by: Ian Abbott <abbotti@mev.co.uk>
---
For "staging-next".
---
 drivers/staging/comedi/comedi_fops.c | 26 --------------------------
 drivers/staging/comedi/comedidev.h   |  1 -
 2 files changed, 27 deletions(-)

diff --git a/drivers/staging/comedi/comedi_fops.c b/drivers/staging/comedi/comedi_fops.c
index 70ad00c..9d99fb3 100644
--- a/drivers/staging/comedi/comedi_fops.c
+++ b/drivers/staging/comedi/comedi_fops.c
@@ -2327,38 +2327,12 @@ static int comedi_open(struct inode *inode, struct file *file)
 		return -ENODEV;
 	}
 
-	/* This is slightly hacky, but we want module autoloading
-	 * to work for root.
-	 * case: user opens device, attached -> ok
-	 * case: user opens device, unattached, !in_request_module -> autoload
-	 * case: user opens device, unattached, in_request_module -> fail
-	 * case: root opens device, attached -> ok
-	 * case: root opens device, unattached, in_request_module -> ok
-	 *   (typically called from modprobe)
-	 * case: root opens device, unattached, !in_request_module -> autoload
-	 *
-	 * The last could be changed to "-> ok", which would deny root
-	 * autoloading.
-	 */
 	mutex_lock(&dev->mutex);
-	if (dev->attached)
-		goto ok;
-	if (!capable(CAP_NET_ADMIN) && dev->in_request_module) {
-		dev_dbg(dev->class_dev, "in request module\n");
-		rc = -ENODEV;
-		goto out;
-	}
-	if (capable(CAP_NET_ADMIN) && dev->in_request_module)
-		goto ok;
-
-	dev->in_request_module = false;
-
 	if (!dev->attached && !capable(CAP_NET_ADMIN)) {
 		dev_dbg(dev->class_dev, "not attached and not CAP_NET_ADMIN\n");
 		rc = -ENODEV;
 		goto out;
 	}
-ok:
 	if (dev->attached && dev->use_count == 0) {
 		if (!try_module_get(dev->driver->module)) {
 			rc = -ENOSYS;
diff --git a/drivers/staging/comedi/comedidev.h b/drivers/staging/comedi/comedidev.h
index d07d47f..8f4e44b 100644
--- a/drivers/staging/comedi/comedidev.h
+++ b/drivers/staging/comedi/comedidev.h
@@ -180,7 +180,6 @@ struct comedi_device {
 	const char *board_name;
 	const void *board_ptr;
 	bool attached:1;
-	bool in_request_module:1;
 	bool ioenabled:1;
 	spinlock_t spinlock;
 	struct mutex mutex;
-- 
1.9.2

