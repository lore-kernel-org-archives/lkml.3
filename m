Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752710AbaLSVvi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Dec 2014 16:51:38 -0500
Received: from mail.ispras.ru ([83.149.199.45]:59412 "EHLO mail.ispras.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751365AbaLSVvh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Dec 2014 16:51:37 -0500
From: Alexey Khoroshilov <khoroshilov@ispras.ru>
To: Lidza Louina <lidza.louina@gmail.com>, Mark Hounschell <markh@compro.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Alexey Khoroshilov <khoroshilov@ispras.ru>,
        driverdev-devel@linuxdriverproject.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, ldv-project@linuxtesting.org
Subject: [PATCH] staging: dgnc: implement proper error handling in dgnc_start()
Date: Sat, 20 Dec 2014 00:51:26 +0300
Message-Id: <1419025886-9895-1-git-send-email-khoroshilov@ispras.ru>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

dgnc_start() ignores errors in class_create() and device_create()
and it does not deallocate resources if dgnc_tty_preinit() fails.

The patch implements proper error handling.

Found by Linux Driver Verification project (linuxtesting.org).

Signed-off-by: Alexey Khoroshilov <khoroshilov@ispras.ru>
---
 drivers/staging/dgnc/dgnc_driver.c | 28 ++++++++++++++++++++++++----
 1 file changed, 24 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/dgnc/dgnc_driver.c b/drivers/staging/dgnc/dgnc_driver.c
index ba98ff348112..f610ae1f3a9f 100644
--- a/drivers/staging/dgnc/dgnc_driver.c
+++ b/drivers/staging/dgnc/dgnc_driver.c
@@ -238,6 +238,7 @@ static int dgnc_start(void)
 {
 	int rc = 0;
 	unsigned long flags;
+	struct device *dev;
 
 	/* make sure that the globals are init'd before we do anything else */
 	dgnc_init_globals();
@@ -257,9 +258,20 @@ static int dgnc_start(void)
 	dgnc_Major = rc;
 
 	dgnc_class = class_create(THIS_MODULE, "dgnc_mgmt");
-	device_create(dgnc_class, NULL,
-		MKDEV(dgnc_Major, 0),
-		NULL, "dgnc_mgmt");
+	if (IS_ERR(dgnc_class)) {
+		rc = PTR_ERR(dgnc_class);
+		pr_err(DRVSTR ": Can't create dgnc_mgmt class (%d)\n", rc);
+		goto failed_class;
+	}
+
+	dev = device_create(dgnc_class, NULL,
+			MKDEV(dgnc_Major, 0),
+			NULL, "dgnc_mgmt");
+	if (IS_ERR(dev)) {
+		rc = PTR_ERR(dev);
+		pr_err(DRVSTR ": Can't create device (%d)\n", rc);
+		goto failed_device;
+	}
 
 	/*
 	 * Init any global tty stuff.
@@ -268,7 +280,7 @@ static int dgnc_start(void)
 
 	if (rc < 0) {
 		pr_err(DRVSTR ": tty preinit - not enough memory (%d)\n", rc);
-		return rc;
+		goto failed_tty;
 	}
 
 	/* Start the poller */
@@ -282,6 +294,14 @@ static int dgnc_start(void)
 
 	add_timer(&dgnc_poll_timer);
 
+	return 0;
+
+failed_tty:
+	device_destroy(dgnc_class, MKDEV(dgnc_Major, 0));
+failed_device:
+	class_destroy(dgnc_class);
+failed_class:
+	unregister_chrdev(dgnc_Major, "dgnc");
 	return rc;
 }
 
-- 
1.9.1
