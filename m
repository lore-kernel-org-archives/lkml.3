Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751913AbaBWUW0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Feb 2014 15:22:26 -0500
Received: from mail.ispras.ru ([83.149.199.45]:49737 "EHLO mail.ispras.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751237AbaBWUWX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Feb 2014 15:22:23 -0500
From: Alexey Khoroshilov <khoroshilov@ispras.ru>
To: Todza Louina <lidza.louina@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Alexey Khoroshilov <khoroshilov@ispras.ru>,
        driverdev-devel@linuxdriverproject.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, ldv-project@linuxtesting.org
Subject: [PATCH 1/3] staging: dgap: remove unneeded status variables
Date: Mon, 24 Feb 2014 00:21:51 +0400
Message-Id: <1393186913-4687-1-git-send-email-khoroshilov@ispras.ru>
X-Mailer: git-send-email 1.8.3.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

dgap_driver_start and dgap_Major_Control_Registered are used
to keep status of initialization of the driver as a whole and its "Major Control".
But the code that checks them is executed once on module init/unload.
That makes no sense in these variables as far as their values are predictable
at any time.

Signed-off-by: Alexey Khoroshilov <khoroshilov@ispras.ru>
---
 drivers/staging/dgap/dgap_driver.c | 105 ++++++++++++++++---------------------
 1 file changed, 46 insertions(+), 59 deletions(-)

diff --git a/drivers/staging/dgap/dgap_driver.c b/drivers/staging/dgap/dgap_driver.c
index 089d017fc291..d7f1e999aaa4 100644
--- a/drivers/staging/dgap/dgap_driver.c
+++ b/drivers/staging/dgap/dgap_driver.c
@@ -117,9 +117,6 @@ int			dgap_poll_tick = 20;	/* Poll interval - 20 ms */
 /*
  * Static vars.
  */
-static int		dgap_Major_Control_Registered = FALSE;
-static uint		dgap_driver_start = FALSE;
-
 static struct class *	dgap_class;
 
 /*
@@ -283,65 +280,57 @@ static int dgap_start(void)
 	int rc = 0;
 	unsigned long flags;
 
-	if (dgap_driver_start == FALSE) {
-
-		dgap_driver_start = TRUE;
+	/* make sure that the globals are init'd before we do anything else */
+	dgap_init_globals();
 
-	        /* make sure that the globals are init'd before we do anything else */
-	        dgap_init_globals();
+	dgap_NumBoards = 0;
 
-		dgap_NumBoards = 0;
+	APR(("For the tools package or updated drivers please visit http://www.digi.com\n"));
 
-		APR(("For the tools package or updated drivers please visit http://www.digi.com\n"));
-
-		/*
-		 * Register our base character device into the kernel.
-		 * This allows the download daemon to connect to the downld device
-		 * before any of the boards are init'ed.
-		 */
-		if (!dgap_Major_Control_Registered) {
-			/*
-			 * Register management/dpa devices
-			 */
-			rc = register_chrdev(DIGI_DGAP_MAJOR, "dgap", &DgapBoardFops);
-			if (rc < 0) {
-				APR(("Can't register dgap driver device (%d)\n", rc));
-				return (rc);
-			}
+	/*
+	 * Register our base character device into the kernel.
+	 * This allows the download daemon to connect to the downld device
+	 * before any of the boards are init'ed.
+	 */
 
-			dgap_class = class_create(THIS_MODULE, "dgap_mgmt");
-			device_create(dgap_class, NULL,
-				MKDEV(DIGI_DGAP_MAJOR, 0),
-				NULL, "dgap_mgmt");
-			device_create(dgap_class, NULL,
-				MKDEV(DIGI_DGAP_MAJOR, 1),
-				NULL, "dgap_downld");
-			dgap_Major_Control_Registered = TRUE;
-		}
+	/*
+	 * Register management/dpa devices
+	 */
+	rc = register_chrdev(DIGI_DGAP_MAJOR, "dgap", &DgapBoardFops);
+	if (rc < 0) {
+		APR(("Can't register dgap driver device (%d)\n", rc));
+		return (rc);
+	}
 
-		/*
-		 * Init any global tty stuff.
-		 */
-		rc = dgap_tty_preinit();
+	dgap_class = class_create(THIS_MODULE, "dgap_mgmt");
+	device_create(dgap_class, NULL,
+		MKDEV(DIGI_DGAP_MAJOR, 0),
+		NULL, "dgap_mgmt");
+	device_create(dgap_class, NULL,
+		MKDEV(DIGI_DGAP_MAJOR, 1),
+		NULL, "dgap_downld");
 
-		if (rc < 0) {
-			APR(("tty preinit - not enough memory (%d)\n", rc));
-			return(rc); 
-		}
+	/*
+	 * Init any global tty stuff.
+	 */
+	rc = dgap_tty_preinit();
+	if (rc < 0) {
+		APR(("tty preinit - not enough memory (%d)\n", rc));
+		return(rc);
+	}
 
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
 
 	return (rc);
 }
@@ -409,12 +398,10 @@ void dgap_cleanup_module(void)
 	dgap_remove_driver_sysfiles(&dgap_driver);
 
 
-	if (dgap_Major_Control_Registered) {
-		device_destroy(dgap_class, MKDEV(DIGI_DGAP_MAJOR, 0));
-		device_destroy(dgap_class, MKDEV(DIGI_DGAP_MAJOR, 1));
-		class_destroy(dgap_class);
-		unregister_chrdev(DIGI_DGAP_MAJOR, "dgap");
-	}
+	device_destroy(dgap_class, MKDEV(DIGI_DGAP_MAJOR, 0));
+	device_destroy(dgap_class, MKDEV(DIGI_DGAP_MAJOR, 1));
+	class_destroy(dgap_class);
+	unregister_chrdev(DIGI_DGAP_MAJOR, "dgap");
 
 	kfree(dgap_config_buf);
 
-- 
1.8.3.2

