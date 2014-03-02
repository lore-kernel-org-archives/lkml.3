Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752821AbaCBVIa (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Mar 2014 16:08:30 -0500
Received: from mail.ispras.ru ([83.149.199.45]:35296 "EHLO mail.ispras.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751732AbaCBVI3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Mar 2014 16:08:29 -0500
From: Alexey Khoroshilov <khoroshilov@ispras.ru>
To: Todza Louina <lidza.louina@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Alexey Khoroshilov <khoroshilov@ispras.ru>,
        driverdev-devel@linuxdriverproject.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, ldv-project@linuxtesting.org
Subject: [PATCH 1/3] staging: dgap: remove unneeded status variables
Date: Mon,  3 Mar 2014 01:08:06 +0400
Message-Id: <1393794488-12909-1-git-send-email-khoroshilov@ispras.ru>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <20140225005154.GA22937@kroah.com>
References: <20140225005154.GA22937@kroah.com>
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
 drivers/staging/dgap/dgap.c | 97 ++++++++++++++++++++-------------------------
 1 file changed, 42 insertions(+), 55 deletions(-)

diff --git a/drivers/staging/dgap/dgap.c b/drivers/staging/dgap/dgap.c
index cbce457..5271856 100644
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
@@ -561,61 +558,54 @@ static int dgap_start(void)
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
+	 * This allows the download daemon to connect to the downld device
+	 * before any of the boards are init'ed.
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
-		 * This allows the download daemon to connect to the downld device
-		 * before any of the boards are init'ed.
-		 */
-		if (!dgap_Major_Control_Registered) {
-			/*
-			 * Register management/dpa devices
-			 */
-			rc = register_chrdev(DIGI_DGAP_MAJOR, "dgap", &DgapBoardFops);
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
 
-		/*
-		 * Init any global tty stuff.
-		 */
-		rc = dgap_tty_preinit();
+	/*
+	 * Init any global tty stuff.
+	 */
+	rc = dgap_tty_preinit();
 
-		if (rc < 0)
-			return rc;
+	if (rc < 0)
+		return rc;
 
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
@@ -677,13 +667,10 @@ void dgap_cleanup_module(void)
 
 	dgap_remove_driver_sysfiles(&dgap_driver);
 
-
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

