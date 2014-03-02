Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753294AbaCBVIj (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Mar 2014 16:08:39 -0500
Received: from mail.ispras.ru ([83.149.199.45]:35308 "EHLO mail.ispras.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752619AbaCBVIi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Mar 2014 16:08:38 -0500
From: Alexey Khoroshilov <khoroshilov@ispras.ru>
To: Todza Louina <lidza.louina@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Alexey Khoroshilov <khoroshilov@ispras.ru>,
        driverdev-devel@linuxdriverproject.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, ldv-project@linuxtesting.org
Subject: [PATCH 2/3] staging: dgap: implement proper error handling in dgap_start()
Date: Mon,  3 Mar 2014 01:08:07 +0400
Message-Id: <1393794488-12909-2-git-send-email-khoroshilov@ispras.ru>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1393794488-12909-1-git-send-email-khoroshilov@ispras.ru>
References: <20140225005154.GA22937@kroah.com>
 <1393794488-12909-1-git-send-email-khoroshilov@ispras.ru>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

dgap_start() ignored errors in class_create() and device_create().
The patch implements proper error handling.

Found by Linux Driver Verification project (linuxtesting.org).

Signed-off-by: Alexey Khoroshilov <khoroshilov@ispras.ru>
---
 drivers/staging/dgap/dgap.c | 22 ++++++++++++++++++++--
 1 file changed, 20 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/dgap/dgap.c b/drivers/staging/dgap/dgap.c
index 5271856..b4157d7 100644
--- a/drivers/staging/dgap/dgap.c
+++ b/drivers/staging/dgap/dgap.c
@@ -557,6 +557,7 @@ static int dgap_start(void)
 {
 	int rc = 0;
 	unsigned long flags;
+	struct device *device;
 
 	/*
 	 * make sure that the globals are
@@ -582,9 +583,18 @@ static int dgap_start(void)
 		return rc;
 
 	dgap_class = class_create(THIS_MODULE, "dgap_mgmt");
-	device_create(dgap_class, NULL,
+	if (IS_ERR(dgap_class)) {
+		rc = PTR_ERR(dgap_class);
+		goto failed_class;
+	}
+
+	device = device_create(dgap_class, NULL,
 		MKDEV(DIGI_DGAP_MAJOR, 0),
 		NULL, "dgap_mgmt");
+	if (IS_ERR(device)) {
+		rc = PTR_ERR(device);
+		goto failed_device;
+	}
 
 	/*
 	 * Init any global tty stuff.
@@ -592,7 +602,7 @@ static int dgap_start(void)
 	rc = dgap_tty_preinit();
 
 	if (rc < 0)
-		return rc;
+		goto failed_tty;
 
 	/* Start the poller */
 	DGAP_LOCK(dgap_poll_lock, flags);
@@ -608,6 +618,14 @@ static int dgap_start(void)
 	dgap_driver_state = DRIVER_NEED_CONFIG_LOAD;
 
 	return rc;
+
+failed_tty:
+	device_destroy(dgap_class, MKDEV(DIGI_DGAP_MAJOR, 0));
+failed_device:
+	class_destroy(dgap_class);
+failed_class:
+	unregister_chrdev(DIGI_DGAP_MAJOR, "dgap");
+	return rc;
 }
 
 /*
-- 
1.8.3.2

