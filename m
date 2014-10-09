Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750998AbaJIEmQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Oct 2014 00:42:16 -0400
Received: from mail-ig0-f178.google.com ([209.85.213.178]:64873 "EHLO
	mail-ig0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750705AbaJIEmO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Oct 2014 00:42:14 -0400
Date: Thu, 9 Oct 2014 13:40:11 +0900
From: Daeseok Youn <daeseok.youn@gmail.com>
To: lidza.louina@gmail.com, markh@compro.net
Cc: markh@compro.net, daeseok.youn@gmail.com, gregkh@linuxfoundation.org,
        driverdev-devel@linuxdriverproject.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, dan.carpenter@oracle.com
Subject: [PATCH V2] staging: dgap: introduce dgap_stop()
Message-ID: <20141009044011.GA999@devel>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The dgap_init_module() need to unwind for cleanup variables properly.
Because dgap_init_module() calls dgap_cleanup_module() for freeing
variables but this function is possible to free variables
which are not allocated.

Signed-off-by: Daeseok Youn <daeseok.youn@gmail.com>
---
V2: change ulong which is non-standard to "unsigned long".

 drivers/staging/dgap/dgap.c |   27 ++++++++++++++++++++++-----
 1 files changed, 22 insertions(+), 5 deletions(-)

diff --git a/drivers/staging/dgap/dgap.c b/drivers/staging/dgap/dgap.c
index 7c79fe6..290ca3b 100644
--- a/drivers/staging/dgap/dgap.c
+++ b/drivers/staging/dgap/dgap.c
@@ -71,6 +71,7 @@ MODULE_DESCRIPTION("Driver for the Digi International EPCA PCI based product lin
 MODULE_SUPPORTED_DEVICE("dgap");
 
 static int dgap_start(void);
+static void dgap_stop(void);
 static void dgap_init_globals(void);
 static struct board_t *dgap_found_board(struct pci_dev *pdev, int id,
 					int boardnum);
@@ -479,19 +480,20 @@ static int dgap_init_module(void)
 
 	rc = pci_register_driver(&dgap_driver);
 	if (rc)
-		goto err_cleanup;
+		goto err_stop;
 
 	rc = dgap_create_driver_sysfiles(&dgap_driver);
 	if (rc)
-		goto err_cleanup;
+		goto err_unregister;
 
 	dgap_driver_state = DRIVER_READY;
 
 	return 0;
 
-err_cleanup:
-
-	dgap_cleanup_module();
+err_unregister:
+	pci_unregister_driver(&dgap_driver);
+err_stop:
+	dgap_stop();
 
 	return rc;
 }
@@ -561,6 +563,21 @@ failed_class:
 	return rc;
 }
 
+static void dgap_stop(void)
+{
+	unsigned long lock_flags;
+
+	spin_lock_irqsave(&dgap_poll_lock, lock_flags);
+	dgap_poll_stop = 1;
+	spin_unlock_irqrestore(&dgap_poll_lock, lock_flags);
+
+	del_timer_sync(&dgap_poll_timer);
+
+	device_destroy(dgap_class, MKDEV(DIGI_DGAP_MAJOR, 0));
+	class_destroy(dgap_class);
+	unregister_chrdev(DIGI_DGAP_MAJOR, "dgap");
+}
+
 static int dgap_init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
 {
 	int rc;
-- 
1.7.1

