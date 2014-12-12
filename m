Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030761AbaLLQma (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Dec 2014 11:42:30 -0500
Received: from mga11.intel.com ([192.55.52.93]:34340 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933666AbaLLQm3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Dec 2014 11:42:29 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.07,565,1413270000"; 
   d="scan'208";a="646724120"
From: Imre Deak <imre.deak@intel.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jslaby@suse.cz>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 3/3] vt: fix console lock vs. kernfs s_active lock order
Date: Fri, 12 Dec 2014 18:38:05 +0200
Message-Id: <1418402285-9578-3-git-send-email-imre.deak@intel.com>
X-Mailer: git-send-email 1.8.4
In-Reply-To: <1418402285-9578-1-git-send-email-imre.deak@intel.com>
References: <1418402285-9578-1-git-send-email-imre.deak@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently there is a lock order problem between the console lock and the
kernfs s_active lock of the console driver's bind sysfs entry. When
writing to the sysfs entry the lock order is first s_active then console
lock, when unregistering the console driver via
do_unregister_con_driver() the order is the opposite. See the below
bugzilla reference for one instance of a lockdep backtrace.

Fix this by unregistering the console driver from a deferred work, where
we can safely drop the console lock while unregistering the device and
corresponding sysfs entries (which in turn acquire s_active). Note that
we have to keep the console driver slot in the registered_con_driver
array reserved for the driver that's being unregistered until it's fully
removed. Otherwise a concurrent call to do_register_con_driver could
try to reuse the same slot and fail when registering the corresponding
device with a minor index that's still in use.

Reference: https://bugs.freedesktop.org/show_bug.cgi?id=70523
Signed-off-by: Imre Deak <imre.deak@intel.com>
---
 drivers/tty/vt/vt.c | 51 +++++++++++++++++++++++++++++++++++++++++----------
 1 file changed, 41 insertions(+), 10 deletions(-)

diff --git a/drivers/tty/vt/vt.c b/drivers/tty/vt/vt.c
index 5dd1880..b9edc77 100644
--- a/drivers/tty/vt/vt.c
+++ b/drivers/tty/vt/vt.c
@@ -108,6 +108,7 @@
 #define CON_DRIVER_FLAG_MODULE 1
 #define CON_DRIVER_FLAG_INIT   2
 #define CON_DRIVER_FLAG_ATTR   4
+#define CON_DRIVER_FLAG_ZOMBIE 8
 
 struct con_driver {
 	const struct consw *con;
@@ -153,6 +154,7 @@ static int set_vesa_blanking(char __user *p);
 static void set_cursor(struct vc_data *vc);
 static void hide_cursor(struct vc_data *vc);
 static void console_callback(struct work_struct *ignored);
+static void con_driver_unregister_callback(struct work_struct *ignored);
 static void blank_screen_t(unsigned long dummy);
 static void set_palette(struct vc_data *vc);
 
@@ -180,6 +182,7 @@ static int blankinterval = 10*60;
 core_param(consoleblank, blankinterval, int, 0444);
 
 static DECLARE_WORK(console_work, console_callback);
+static DECLARE_WORK(con_driver_unregister_work, con_driver_unregister_callback);
 
 /*
  * fg_console is the current virtual console,
@@ -3597,7 +3600,8 @@ static int do_register_con_driver(const struct consw *csw, int first, int last)
 	for (i = 0; i < MAX_NR_CON_DRIVER; i++) {
 		con_driver = &registered_con_driver[i];
 
-		if (con_driver->con == NULL) {
+		if (con_driver->con == NULL &&
+		    !(con_driver->flag & CON_DRIVER_FLAG_ZOMBIE)) {
 			con_driver->con = csw;
 			con_driver->desc = desc;
 			con_driver->node = i;
@@ -3660,16 +3664,10 @@ int do_unregister_con_driver(const struct consw *csw)
 
 		if (con_driver->con == csw &&
 		    con_driver->flag & CON_DRIVER_FLAG_MODULE) {
-			vtconsole_deinit_device(con_driver);
-			device_destroy(vtconsole_class,
-				       MKDEV(0, con_driver->node));
 			con_driver->con = NULL;
-			con_driver->desc = NULL;
-			con_driver->dev = NULL;
-			con_driver->node = 0;
-			con_driver->flag = 0;
-			con_driver->first = 0;
-			con_driver->last = 0;
+			con_driver->flag = CON_DRIVER_FLAG_ZOMBIE;
+			schedule_work(&con_driver_unregister_work);
+
 			return 0;
 		}
 	}
@@ -3678,6 +3676,39 @@ int do_unregister_con_driver(const struct consw *csw)
 }
 EXPORT_SYMBOL_GPL(do_unregister_con_driver);
 
+static void con_driver_unregister_callback(struct work_struct *ignored)
+{
+	int i;
+
+	console_lock();
+
+	for (i = 0; i < MAX_NR_CON_DRIVER; i++) {
+		struct con_driver *con_driver = &registered_con_driver[i];
+
+		if (!(con_driver->flag & CON_DRIVER_FLAG_ZOMBIE))
+			continue;
+
+		console_unlock();
+
+		vtconsole_deinit_device(con_driver);
+		device_destroy(vtconsole_class, MKDEV(0, con_driver->node));
+
+		if (WARN_ON_ONCE(con_driver->con))
+			con_driver->con = NULL;
+		con_driver->desc = NULL;
+		con_driver->dev = NULL;
+		con_driver->node = 0;
+		WARN_ON_ONCE(con_driver->flag != CON_DRIVER_FLAG_ZOMBIE);
+		con_driver->flag = 0;
+		con_driver->first = 0;
+		con_driver->last = 0;
+
+		console_lock();
+	}
+
+	console_unlock();
+}
+
 /*
  *	If we support more console drivers, this function is used
  *	when a driver wants to take over some existing consoles
-- 
1.8.4

