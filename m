Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751591AbaAPFHh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jan 2014 00:07:37 -0500
Received: from mail-pb0-f44.google.com ([209.85.160.44]:45263 "EHLO
	mail-pb0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750960AbaAPFHf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jan 2014 00:07:35 -0500
From: Tushar Behera <tushar.behera@linaro.org>
To: linux-kernel@vger.kernel.org, linux-samsung-soc@vger.kernel.org
Cc: jslaby@suse.cz, gregkh@linuxfoundation.org, broonie@kernel.org
Subject: [PATCH] tty: Fallback to use dynamic major number
Date: Thu, 16 Jan 2014 10:33:22 +0530
Message-Id: <1389848602-30985-1-git-send-email-tushar.behera@linaro.org>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In a multi-platform scenario, the hard-coded major/minor numbers in
serial drivers may conflict with each other. A typical scenario is
observed with amba-pl011 and samsung-uart drivers, both of these
drivers use same set of major/minor numbers. If both of these drivers
are enabled, probe of samsung-uart driver fails because the desired
node is busy.

The issue is fixed by adding a fallback in driver core, so that we can
use dynamic major number in case device node allocation fails for
hard-coded major/minor number.

Signed-off-by: Tushar Behera <tushar.behera@linaro.org>
---
Hi Greg,

This is my second attempt at getting this fixed. Let me know if you are
okay with this.

Initial approach to fix this problem was by forcing samsung-uart driver
to use dynamic major number, but it was rejected [1] because of possible
user-space breakage. Current approach falls back to dynamic major
number as a fallback in case of failure.
[1] https://lkml.org/lkml/2013/12/27/2

 drivers/tty/tty_io.c |   19 ++++++++++++++++---
 1 file changed, 16 insertions(+), 3 deletions(-)

diff --git a/drivers/tty/tty_io.c b/drivers/tty/tty_io.c
index c74a00a..0c692be 100644
--- a/drivers/tty/tty_io.c
+++ b/drivers/tty/tty_io.c
@@ -3341,6 +3341,22 @@ int tty_register_driver(struct tty_driver *driver)
 	dev_t dev;
 	struct device *d;
 
+	if (driver->major) {
+		dev = MKDEV(driver->major, driver->minor_start);
+		error = register_chrdev_region(dev, driver->num, driver->name);
+		/* In case of error, fall back to dynamic allocation */
+		if (error < 0) {
+			pr_warn("Default device node (%d:%d) for %s is busy, using dynamic node\n",
+				driver->major, driver->minor_start,
+				driver->name);
+			driver->major = 0;
+		}
+	}
+
+	/*
+	 * Don't replace the following check with an else to above if statement,
+	 * as it may also be called as a fallback.
+	 */
 	if (!driver->major) {
 		error = alloc_chrdev_region(&dev, driver->minor_start,
 						driver->num, driver->name);
@@ -3348,9 +3364,6 @@ int tty_register_driver(struct tty_driver *driver)
 			driver->major = MAJOR(dev);
 			driver->minor_start = MINOR(dev);
 		}
-	} else {
-		dev = MKDEV(driver->major, driver->minor_start);
-		error = register_chrdev_region(dev, driver->num, driver->name);
 	}
 	if (error < 0)
 		goto err;
-- 
1.7.9.5

