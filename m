Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760008Ab3B1PCL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Feb 2013 10:02:11 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:42389 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932665Ab3B1Ot4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Feb 2013 09:49:56 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Takashi Iwai <tiwai@suse.de>, Alan Cox <alan@linux.intel.com>,
        Florian Tobias Schandinat <FlorianSchandinat@gmx.de>,
        Jiri Kosina <jkosina@suse.cz>,
        Andrew Morton <akpm@linux-foundation.org>,
        Dave Airlie <airlied@redhat.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 097/139] fb: Yet another band-aid for fixing lockdep mess
Date: Thu, 28 Feb 2013 14:44:07 +0000
Message-Id: <1362062689-2567-98-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1362062689-2567-1-git-send-email-luis.henriques@canonical.com>
References: <1362062689-2567-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.7 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Takashi Iwai <tiwai@suse.de>

commit e93a9a868792ad71cdd09d75e5a02d8067473c4e upstream.

I've still got lockdep warnings even after Alan's patch, and it seems that
yet more band aids are required to paper over similar paths for
unbind_con_driver() and unregister_con_driver().  After this hack, lockdep
warnings are finally gone.

Signed-off-by: Takashi Iwai <tiwai@suse.de>
Cc: Alan Cox <alan@linux.intel.com>
Cc: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
Cc: Jiri Kosina <jkosina@suse.cz>
Tested-by: Sedat Dilek <sedat.dilek@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Dave Airlie <airlied@redhat.com>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/tty/vt/vt.c           | 43 ++++++++++++++++++++++++++++---------------
 drivers/video/console/fbcon.c |  4 ++--
 drivers/video/fbmem.c         |  4 ++++
 include/linux/console.h       |  1 +
 include/linux/vt_kern.h       |  2 ++
 5 files changed, 37 insertions(+), 17 deletions(-)

diff --git a/drivers/tty/vt/vt.c b/drivers/tty/vt/vt.c
index f7ffae5..d2f0b26 100644
--- a/drivers/tty/vt/vt.c
+++ b/drivers/tty/vt/vt.c
@@ -3165,6 +3165,18 @@ static int con_is_graphics(const struct consw *csw, int first, int last)
  */
 int unbind_con_driver(const struct consw *csw, int first, int last, int deflt)
 {
+	int retval;
+
+	console_lock();
+	retval = do_unbind_con_driver(csw, first, last, deflt);
+	console_unlock();
+	return retval;
+}
+EXPORT_SYMBOL(unbind_con_driver);
+
+/* unlocked version of unbind_con_driver() */
+int do_unbind_con_driver(const struct consw *csw, int first, int last, int deflt)
+{
 	struct module *owner = csw->owner;
 	const struct consw *defcsw = NULL;
 	struct con_driver *con_driver = NULL, *con_back = NULL;
@@ -3173,7 +3185,7 @@ int unbind_con_driver(const struct consw *csw, int first, int last, int deflt)
 	if (!try_module_get(owner))
 		return -ENODEV;
 
-	console_lock();
+	WARN_CONSOLE_UNLOCKED();
 
 	/* check if driver is registered and if it is unbindable */
 	for (i = 0; i < MAX_NR_CON_DRIVER; i++) {
@@ -3186,10 +3198,8 @@ int unbind_con_driver(const struct consw *csw, int first, int last, int deflt)
 		}
 	}
 
-	if (retval) {
-		console_unlock();
+	if (retval)
 		goto err;
-	}
 
 	retval = -ENODEV;
 
@@ -3205,15 +3215,11 @@ int unbind_con_driver(const struct consw *csw, int first, int last, int deflt)
 		}
 	}
 
-	if (retval) {
-		console_unlock();
+	if (retval)
 		goto err;
-	}
 
-	if (!con_is_bound(csw)) {
-		console_unlock();
+	if (!con_is_bound(csw))
 		goto err;
-	}
 
 	first = max(first, con_driver->first);
 	last = min(last, con_driver->last);
@@ -3242,13 +3248,12 @@ int unbind_con_driver(const struct consw *csw, int first, int last, int deflt)
 
 	/* ignore return value, binding should not fail */
 	do_bind_con_driver(defcsw, first, last, deflt);
-	console_unlock();
 err:
 	module_put(owner);
 	return retval;
 
 }
-EXPORT_SYMBOL(unbind_con_driver);
+EXPORT_SYMBOL_GPL(do_unbind_con_driver);
 
 static int vt_bind(struct con_driver *con)
 {
@@ -3635,9 +3640,18 @@ EXPORT_SYMBOL(register_con_driver);
  */
 int unregister_con_driver(const struct consw *csw)
 {
-	int i, retval = -ENODEV;
+	int retval;
 
 	console_lock();
+	retval = do_unregister_con_driver(csw);
+	console_unlock();
+	return retval;
+}
+EXPORT_SYMBOL(unregister_con_driver);
+
+int do_unregister_con_driver(const struct consw *csw)
+{
+	int i, retval = -ENODEV;
 
 	/* cannot unregister a bound driver */
 	if (con_is_bound(csw))
@@ -3663,10 +3677,9 @@ int unregister_con_driver(const struct consw *csw)
 		}
 	}
 err:
-	console_unlock();
 	return retval;
 }
-EXPORT_SYMBOL(unregister_con_driver);
+EXPORT_SYMBOL_GPL(do_unregister_con_driver);
 
 /*
  *	If we support more console drivers, this function is used
diff --git a/drivers/video/console/fbcon.c b/drivers/video/console/fbcon.c
index 7ccec55..5bf163e 100644
--- a/drivers/video/console/fbcon.c
+++ b/drivers/video/console/fbcon.c
@@ -3010,7 +3010,7 @@ static int fbcon_unbind(void)
 {
 	int ret;
 
-	ret = unbind_con_driver(&fb_con, first_fb_vc, last_fb_vc,
+	ret = do_unbind_con_driver(&fb_con, first_fb_vc, last_fb_vc,
 				fbcon_is_default);
 
 	if (!ret)
@@ -3083,7 +3083,7 @@ static int fbcon_fb_unregistered(struct fb_info *info)
 		primary_device = -1;
 
 	if (!num_registered_fb)
-		unregister_con_driver(&fb_con);
+		do_unregister_con_driver(&fb_con);
 
 	return 0;
 }
diff --git a/drivers/video/fbmem.c b/drivers/video/fbmem.c
index 616278a..afa804f 100644
--- a/drivers/video/fbmem.c
+++ b/drivers/video/fbmem.c
@@ -1669,8 +1669,10 @@ static int do_unregister_framebuffer(struct fb_info *fb_info)
 
 	if (!lock_fb_info(fb_info))
 		return -ENODEV;
+	console_lock();
 	event.info = fb_info;
 	ret = fb_notifier_call_chain(FB_EVENT_FB_UNBIND, &event);
+	console_unlock();
 	unlock_fb_info(fb_info);
 
 	if (ret)
@@ -1685,7 +1687,9 @@ static int do_unregister_framebuffer(struct fb_info *fb_info)
 	num_registered_fb--;
 	fb_cleanup_device(fb_info);
 	event.info = fb_info;
+	console_lock();
 	fb_notifier_call_chain(FB_EVENT_FB_UNREGISTERED, &event);
+	console_unlock();
 
 	/* this may free fb info */
 	put_fb_info(fb_info);
diff --git a/include/linux/console.h b/include/linux/console.h
index e8ea7d7..f59e942 100644
--- a/include/linux/console.h
+++ b/include/linux/console.h
@@ -77,6 +77,7 @@ extern const struct consw prom_con;	/* SPARC PROM console */
 int con_is_bound(const struct consw *csw);
 int register_con_driver(const struct consw *csw, int first, int last);
 int unregister_con_driver(const struct consw *csw);
+int do_unregister_con_driver(const struct consw *csw);
 int take_over_console(const struct consw *sw, int first, int last, int deflt);
 int do_take_over_console(const struct consw *sw, int first, int last, int deflt);
 void give_up_console(const struct consw *sw);
diff --git a/include/linux/vt_kern.h b/include/linux/vt_kern.h
index 1f55665..e8d6571 100644
--- a/include/linux/vt_kern.h
+++ b/include/linux/vt_kern.h
@@ -131,6 +131,8 @@ void vt_event_post(unsigned int event, unsigned int old, unsigned int new);
 int vt_waitactive(int n);
 void change_console(struct vc_data *new_vc);
 void reset_vc(struct vc_data *vc);
+extern int do_unbind_con_driver(const struct consw *csw, int first, int last,
+			     int deflt);
 extern int unbind_con_driver(const struct consw *csw, int first, int last,
 			     int deflt);
 int vty_init(const struct file_operations *console_fops);
-- 
1.8.1.2

