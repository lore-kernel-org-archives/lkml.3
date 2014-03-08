Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752331AbaCHVCX (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Mar 2014 16:02:23 -0500
Received: from mail.ispras.ru ([83.149.199.45]:35353 "EHLO mail.ispras.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751721AbaCHVCU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Mar 2014 16:02:20 -0500
From: Alexey Khoroshilov <khoroshilov@ispras.ru>
To: Todza Louina <lidza.louina@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Alexey Khoroshilov <khoroshilov@ispras.ru>,
        driverdev-devel@linuxdriverproject.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, ldv-project@linuxtesting.org
Subject: [PATCH 2/2] staging: dgap: implement proper error handling in dgap_start()
Date: Sun,  9 Mar 2014 01:01:34 +0400
Message-Id: <1394312494-17083-2-git-send-email-khoroshilov@ispras.ru>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1394312494-17083-1-git-send-email-khoroshilov@ispras.ru>
References: <20140306221806.GA30494@kroah.com>
 <1394312494-17083-1-git-send-email-khoroshilov@ispras.ru>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

dgap_start() ignored errors in class_create() and device_create().
The patch implements proper error handling.

Found by Linux Driver Verification project (linuxtesting.org).

Signed-off-by: Alexey Khoroshilov <khoroshilov@ispras.ru>
---
 drivers/staging/dgap/dgap.c | 18 +++++++++++++++++-
 1 file changed, 17 insertions(+), 1 deletion(-)

diff --git a/drivers/staging/dgap/dgap.c b/drivers/staging/dgap/dgap.c
index ad5afbc..bfafe7e 100644
--- a/drivers/staging/dgap/dgap.c
+++ b/drivers/staging/dgap/dgap.c
@@ -547,6 +547,7 @@ static int dgap_start(void)
 {
 	int rc = 0;
 	unsigned long flags;
+	struct device *device;
 
 	/*
 	 * make sure that the globals are
@@ -570,9 +571,18 @@ static int dgap_start(void)
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
 
 	/* Start the poller */
 	DGAP_LOCK(dgap_poll_lock, flags);
@@ -588,6 +598,12 @@ static int dgap_start(void)
 	dgap_driver_state = DRIVER_NEED_CONFIG_LOAD;
 
 	return rc;
+
+failed_device:
+	class_destroy(dgap_class);
+failed_class:
+	unregister_chrdev(DIGI_DGAP_MAJOR, "dgap");
+	return rc;
 }
 
 /*
-- 
1.8.3.2

