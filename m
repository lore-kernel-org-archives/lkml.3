Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752154AbaCHVCA (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Mar 2014 16:02:00 -0500
Received: from mail.ispras.ru ([83.149.199.45]:35337 "EHLO mail.ispras.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751716AbaCHVB7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Mar 2014 16:01:59 -0500
From: Alexey Khoroshilov <khoroshilov@ispras.ru>
To: Todza Louina <lidza.louina@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Alexey Khoroshilov <khoroshilov@ispras.ru>,
        driverdev-devel@linuxdriverproject.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, ldv-project@linuxtesting.org
Subject: [PATCH 1/2] staging: dgap: remove unneeded status variables
Date: Sun,  9 Mar 2014 01:01:33 +0400
Message-Id: <1394312494-17083-1-git-send-email-khoroshilov@ispras.ru>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <20140306221806.GA30494@kroah.com>
References: <20140306221806.GA30494@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

dgap_driver_start and dgap_Major_Control_Registered are used
to keep status of initialization of the driver as a whole and its "Major Control".
But the code that checks them is executed once on module init/unload.
That makes no sense in these variables as far as their values are predictable
at any time.

Also "dgap_downld" device was removed, while
device_destroy(MKDEV(DIGI_DGAP_MAJOR, 1)) is still in dgap_cleanup_module().
The patch removes it by the way.

Signed-off-by: Alexey Khoroshilov <khoroshilov@ispras.ru>
---
 drivers/staging/dgap/dgap.c | 81 ++++++++++++++++++---------------------------
 1 file changed, 33 insertions(+), 48 deletions(-)

diff --git a/drivers/staging/dgap/dgap.c b/drivers/staging/dgap/dgap.c
index d00283a..ad5afbc 100644
--- a/drivers/staging/dgap/dgap.c
+++ b/drivers/staging/dgap/dgap.c
@@ -254,9 +254,6 @@ static int dgap_poll_tick = 20;	/* Poll interval - 20 ms */
 /*
  * Static vars.
  */
-static int dgap_Major_Control_Registered = FALSE;
-static uint dgap_driver_start = FALSE;
-
 static struct class *dgap_class;
 
 static struct board_t *dgap_BoardsByMajor[256];
@@ -551,52 +548,44 @@ static int dgap_start(void)
 	int rc = 0;
 	unsigned long flags;
 
-	if (dgap_driver_start == FALSE) {
+	/*
+	 * make sure that the globals are
+	 * init'd before we do anything else
+	 */
+	dgap_init_globals();
 
-		dgap_driver_start = TRUE;
+	dgap_NumBoards = 0;
 
-		/*
-		 * make sure that the globals are
-		 * init'd before we do anything else
-		 */
-		dgap_init_globals();
+	pr_info("For the tools package please visit http://www.digi.com\n");
 
-		dgap_NumBoards = 0;
+	/*
+	 * Register our base character device into the kernel.
+	 */
 
-		pr_info("For the tools package please visit http://www.digi.com\n");
+	/*
+	 * Register management/dpa devices
+	 */
+	rc = register_chrdev(DIGI_DGAP_MAJOR, "dgap", &DgapBoardFops);
+	if (rc < 0)
+		return rc;
 
-		/*
-		 * Register our base character device into the kernel.
-		 */
-		if (!dgap_Major_Control_Registered) {
-			/*
-			 * Register management/dpa devices
-			 */
-			rc = register_chrdev(DIGI_DGAP_MAJOR, "dgap",
-						 &DgapBoardFops);
-			if (rc < 0)
-				return rc;
-
-			dgap_class = class_create(THIS_MODULE, "dgap_mgmt");
-			device_create(dgap_class, NULL,
-				MKDEV(DIGI_DGAP_MAJOR, 0),
-				NULL, "dgap_mgmt");
-			dgap_Major_Control_Registered = TRUE;
-		}
+	dgap_class = class_create(THIS_MODULE, "dgap_mgmt");
+	device_create(dgap_class, NULL,
+		MKDEV(DIGI_DGAP_MAJOR, 0),
+		NULL, "dgap_mgmt");
 
-		/* Start the poller */
-		DGAP_LOCK(dgap_poll_lock, flags);
-		init_timer(&dgap_poll_timer);
-		dgap_poll_timer.function = dgap_poll_handler;
-		dgap_poll_timer.data = 0;
-		dgap_poll_time = jiffies + dgap_jiffies_from_ms(dgap_poll_tick);
-		dgap_poll_timer.expires = dgap_poll_time;
-		DGAP_UNLOCK(dgap_poll_lock, flags);
+	/* Start the poller */
+	DGAP_LOCK(dgap_poll_lock, flags);
+	init_timer(&dgap_poll_timer);
+	dgap_poll_timer.function = dgap_poll_handler;
+	dgap_poll_timer.data = 0;
+	dgap_poll_time = jiffies + dgap_jiffies_from_ms(dgap_poll_tick);
+	dgap_poll_timer.expires = dgap_poll_time;
+	DGAP_UNLOCK(dgap_poll_lock, flags);
 
-		add_timer(&dgap_poll_timer);
+	add_timer(&dgap_poll_timer);
 
-		dgap_driver_state = DRIVER_NEED_CONFIG_LOAD;
-	}
+	dgap_driver_state = DRIVER_NEED_CONFIG_LOAD;
 
 	return rc;
 }
@@ -658,13 +647,9 @@ static void dgap_cleanup_module(void)
 
 	dgap_remove_driver_sysfiles(&dgap_driver);
 
-
-	if (dgap_Major_Control_Registered) {
-		device_destroy(dgap_class, MKDEV(DIGI_DGAP_MAJOR, 0));
-		device_destroy(dgap_class, MKDEV(DIGI_DGAP_MAJOR, 1));
-		class_destroy(dgap_class);
-		unregister_chrdev(DIGI_DGAP_MAJOR, "dgap");
-	}
+	device_destroy(dgap_class, MKDEV(DIGI_DGAP_MAJOR, 0));
+	class_destroy(dgap_class);
+	unregister_chrdev(DIGI_DGAP_MAJOR, "dgap");
 
 	kfree(dgap_config_buf);
 
-- 
1.8.3.2

