Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751763AbaBWUWZ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Feb 2014 15:22:25 -0500
Received: from mail.ispras.ru ([83.149.199.45]:49747 "EHLO mail.ispras.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751300AbaBWUWX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Feb 2014 15:22:23 -0500
From: Alexey Khoroshilov <khoroshilov@ispras.ru>
To: Todza Louina <lidza.louina@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Alexey Khoroshilov <khoroshilov@ispras.ru>,
        driverdev-devel@linuxdriverproject.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, ldv-project@linuxtesting.org
Subject: [PATCH 2/3] staging: dgap: implement proper error handling in dgap_start()
Date: Mon, 24 Feb 2014 00:21:52 +0400
Message-Id: <1393186913-4687-2-git-send-email-khoroshilov@ispras.ru>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1393186913-4687-1-git-send-email-khoroshilov@ispras.ru>
References: <1393186913-4687-1-git-send-email-khoroshilov@ispras.ru>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

dgap_start() ignored errors in class_create() and device_create().
The patch implements proper error handling.

Found by Linux Driver Verification project (linuxtesting.org).

Signed-off-by: Alexey Khoroshilov <khoroshilov@ispras.ru>
---
 drivers/staging/dgap/dgap_driver.c | 42 +++++++++++++++++++++++++++++++-------
 1 file changed, 35 insertions(+), 7 deletions(-)

diff --git a/drivers/staging/dgap/dgap_driver.c b/drivers/staging/dgap/dgap_driver.c
index d7f1e999aaa4..136c879b560c 100644
--- a/drivers/staging/dgap/dgap_driver.c
+++ b/drivers/staging/dgap/dgap_driver.c
@@ -279,6 +279,7 @@ static int dgap_start(void)
 {
 	int rc = 0;
 	unsigned long flags;
+	struct device *device;
 
         /* make sure that the globals are init'd before we do anything else */
         dgap_init_globals();
@@ -303,12 +304,29 @@ static int dgap_start(void)
 	}
 
 	dgap_class = class_create(THIS_MODULE, "dgap_mgmt");
-	device_create(dgap_class, NULL,
-		MKDEV(DIGI_DGAP_MAJOR, 0),
-		NULL, "dgap_mgmt");
-	device_create(dgap_class, NULL,
-		MKDEV(DIGI_DGAP_MAJOR, 1),
-		NULL, "dgap_downld");
+	if (IS_ERR(dgap_class)) {
+		rc = PTR_ERR(dgap_class);
+		APR(("Can't create dgap_mgmt class (%d)\n", rc));
+		goto failed_class;
+	}
+
+	device = device_create(dgap_class, NULL,
+			MKDEV(DIGI_DGAP_MAJOR, 0),
+			NULL, "dgap_mgmt");
+	if (IS_ERR(device)) {
+		rc = PTR_ERR(device);
+		APR(("Can't create device (%d)\n", rc));
+		goto failed_device0;
+	}
+
+	device = device_create(dgap_class, NULL,
+			MKDEV(DIGI_DGAP_MAJOR, 1),
+			NULL, "dgap_downld");
+	if (IS_ERR(device)) {
+		rc = PTR_ERR(device);
+		APR(("Can't create device (%d)\n", rc));
+		goto failed_device1;
+	}
 
 	/*
 	 * Init any global tty stuff.
@@ -316,7 +334,7 @@ static int dgap_start(void)
 	rc = dgap_tty_preinit();
 	if (rc < 0) {
 		APR(("tty preinit - not enough memory (%d)\n", rc));
-		return(rc); 
+		goto failed_tty;
 	}
 
 	/* Start the poller */
@@ -333,6 +351,16 @@ static int dgap_start(void)
 	dgap_driver_state = DRIVER_NEED_CONFIG_LOAD;
 
 	return (rc);
+
+failed_tty:
+	device_destroy(dgap_class, MKDEV(DIGI_DGAP_MAJOR, 1));
+failed_device1:
+	device_destroy(dgap_class, MKDEV(DIGI_DGAP_MAJOR, 0));
+failed_device0:
+	class_destroy(dgap_class);
+failed_class:
+	unregister_chrdev(DIGI_DGAP_MAJOR, "dgap");
+	return (rc);
 }
 
 
-- 
1.8.3.2

