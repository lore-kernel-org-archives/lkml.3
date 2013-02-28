Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754116Ab3B1OuE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Feb 2013 09:50:04 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:42393 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932676Ab3B1Ot5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Feb 2013 09:49:57 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Alan Cox <alan@linux.intel.com>,
        Florian Tobias Schandinat <FlorianSchandinat@gmx.de>,
        Stephen Rothwell <sfr@canb.auug.org.au>, Jiri Kosina <jkosina@suse.cz>,
        Andrew Morton <akpm@linux-foundation.org>,
        Dave Airlie <airlied@redhat.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 096/139] fb: rework locking to fix lock ordering on takeover
Date: Thu, 28 Feb 2013 14:44:06 +0000
Message-Id: <1362062689-2567-97-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1362062689-2567-1-git-send-email-luis.henriques@canonical.com>
References: <1362062689-2567-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.7 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alan Cox <alan@linux.intel.com>

commit 50e244cc793d511b86adea24972f3a7264cae114 upstream.

Adjust the console layer to allow a take over call where the caller
already holds the locks.  Make the fb layer lock in order.

This is partly a band aid, the fb layer is terminally confused about the
locking rules it uses for its notifiers it seems.

[akpm@linux-foundation.org: remove stray non-ascii char, tidy comment]
[akpm@linux-foundation.org: export do_take_over_console()]
[airlied: cleanup another non-ascii char]
Signed-off-by: Alan Cox <alan@linux.intel.com>
Cc: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Jiri Kosina <jkosina@suse.cz>
Tested-by: Sedat Dilek <sedat.dilek@gmail.com>
Reviewed-by: Daniel Vetter <daniel.vetter@ffwll.ch>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Dave Airlie <airlied@redhat.com>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/tty/vt/vt.c           | 93 ++++++++++++++++++++++++++++++++-----------
 drivers/video/console/fbcon.c | 29 +++++++++++++-
 drivers/video/fbmem.c         |  5 +--
 drivers/video/fbsysfs.c       |  3 ++
 include/linux/console.h       |  1 +
 5 files changed, 104 insertions(+), 27 deletions(-)

diff --git a/drivers/tty/vt/vt.c b/drivers/tty/vt/vt.c
index 3b4f5b6..f7ffae5 100644
--- a/drivers/tty/vt/vt.c
+++ b/drivers/tty/vt/vt.c
@@ -3017,7 +3017,7 @@ int __init vty_init(const struct file_operations *console_fops)
 
 static struct class *vtconsole_class;
 
-static int bind_con_driver(const struct consw *csw, int first, int last,
+static int do_bind_con_driver(const struct consw *csw, int first, int last,
 			   int deflt)
 {
 	struct module *owner = csw->owner;
@@ -3028,7 +3028,7 @@ static int bind_con_driver(const struct consw *csw, int first, int last,
 	if (!try_module_get(owner))
 		return -ENODEV;
 
-	console_lock();
+	WARN_CONSOLE_UNLOCKED();
 
 	/* check if driver is registered */
 	for (i = 0; i < MAX_NR_CON_DRIVER; i++) {
@@ -3113,11 +3113,22 @@ static int bind_con_driver(const struct consw *csw, int first, int last,
 
 	retval = 0;
 err:
-	console_unlock();
 	module_put(owner);
 	return retval;
 };
 
+
+static int bind_con_driver(const struct consw *csw, int first, int last,
+			   int deflt)
+{
+	int ret;
+
+	console_lock();
+	ret = do_bind_con_driver(csw, first, last, deflt);
+	console_unlock();
+	return ret;
+}
+
 #ifdef CONFIG_VT_HW_CONSOLE_BINDING
 static int con_is_graphics(const struct consw *csw, int first, int last)
 {
@@ -3229,9 +3240,9 @@ int unbind_con_driver(const struct consw *csw, int first, int last, int deflt)
 	if (!con_is_bound(csw))
 		con_driver->flag &= ~CON_DRIVER_FLAG_INIT;
 
-	console_unlock();
 	/* ignore return value, binding should not fail */
-	bind_con_driver(defcsw, first, last, deflt);
+	do_bind_con_driver(defcsw, first, last, deflt);
+	console_unlock();
 err:
 	module_put(owner);
 	return retval;
@@ -3522,28 +3533,18 @@ int con_debug_leave(void)
 }
 EXPORT_SYMBOL_GPL(con_debug_leave);
 
-/**
- * register_con_driver - register console driver to console layer
- * @csw: console driver
- * @first: the first console to take over, minimum value is 0
- * @last: the last console to take over, maximum value is MAX_NR_CONSOLES -1
- *
- * DESCRIPTION: This function registers a console driver which can later
- * bind to a range of consoles specified by @first and @last. It will
- * also initialize the console driver by calling con_startup().
- */
-int register_con_driver(const struct consw *csw, int first, int last)
+static int do_register_con_driver(const struct consw *csw, int first, int last)
 {
 	struct module *owner = csw->owner;
 	struct con_driver *con_driver;
 	const char *desc;
 	int i, retval = 0;
 
+	WARN_CONSOLE_UNLOCKED();
+
 	if (!try_module_get(owner))
 		return -ENODEV;
 
-	console_lock();
-
 	for (i = 0; i < MAX_NR_CON_DRIVER; i++) {
 		con_driver = &registered_con_driver[i];
 
@@ -3596,10 +3597,29 @@ int register_con_driver(const struct consw *csw, int first, int last)
 	}
 
 err:
-	console_unlock();
 	module_put(owner);
 	return retval;
 }
+
+/**
+ * register_con_driver - register console driver to console layer
+ * @csw: console driver
+ * @first: the first console to take over, minimum value is 0
+ * @last: the last console to take over, maximum value is MAX_NR_CONSOLES -1
+ *
+ * DESCRIPTION: This function registers a console driver which can later
+ * bind to a range of consoles specified by @first and @last. It will
+ * also initialize the console driver by calling con_startup().
+ */
+int register_con_driver(const struct consw *csw, int first, int last)
+{
+	int retval;
+
+	console_lock();
+	retval = do_register_con_driver(csw, first, last);
+	console_unlock();
+	return retval;
+}
 EXPORT_SYMBOL(register_con_driver);
 
 /**
@@ -3653,17 +3673,44 @@ EXPORT_SYMBOL(unregister_con_driver);
  *	when a driver wants to take over some existing consoles
  *	and become default driver for newly opened ones.
  *
- *      take_over_console is basically a register followed by unbind
+ *	take_over_console is basically a register followed by unbind
+ */
+int do_take_over_console(const struct consw *csw, int first, int last, int deflt)
+{
+	int err;
+
+	err = do_register_con_driver(csw, first, last);
+	/*
+	 * If we get an busy error we still want to bind the console driver
+	 * and return success, as we may have unbound the console driver
+	 * but not unregistered it.
+	 */
+	if (err == -EBUSY)
+		err = 0;
+	if (!err)
+		do_bind_con_driver(csw, first, last, deflt);
+
+	return err;
+}
+EXPORT_SYMBOL_GPL(do_take_over_console);
+
+/*
+ *	If we support more console drivers, this function is used
+ *	when a driver wants to take over some existing consoles
+ *	and become default driver for newly opened ones.
+ *
+ *	take_over_console is basically a register followed by unbind
  */
 int take_over_console(const struct consw *csw, int first, int last, int deflt)
 {
 	int err;
 
 	err = register_con_driver(csw, first, last);
-	/* if we get an busy error we still want to bind the console driver
+	/*
+	 * If we get an busy error we still want to bind the console driver
 	 * and return success, as we may have unbound the console driver
-	 * but not unregistered it.
-	*/
+	 * but not unregistered it.
+	 */
 	if (err == -EBUSY)
 		err = 0;
 	if (!err)
diff --git a/drivers/video/console/fbcon.c b/drivers/video/console/fbcon.c
index bdcd34d..7ccec55 100644
--- a/drivers/video/console/fbcon.c
+++ b/drivers/video/console/fbcon.c
@@ -529,6 +529,33 @@ static int search_for_mapped_con(void)
 	return retval;
 }
 
+static int do_fbcon_takeover(int show_logo)
+{
+	int err, i;
+
+	if (!num_registered_fb)
+		return -ENODEV;
+
+	if (!show_logo)
+		logo_shown = FBCON_LOGO_DONTSHOW;
+
+	for (i = first_fb_vc; i <= last_fb_vc; i++)
+		con2fb_map[i] = info_idx;
+
+	err = do_take_over_console(&fb_con, first_fb_vc, last_fb_vc,
+				fbcon_is_default);
+
+	if (err) {
+		for (i = first_fb_vc; i <= last_fb_vc; i++)
+			con2fb_map[i] = -1;
+		info_idx = -1;
+	} else {
+		fbcon_has_console_bind = 1;
+	}
+
+	return err;
+}
+
 static int fbcon_takeover(int show_logo)
 {
 	int err, i;
@@ -3121,7 +3148,7 @@ static int fbcon_fb_registered(struct fb_info *info)
 		}
 
 		if (info_idx != -1)
-			ret = fbcon_takeover(1);
+			ret = do_fbcon_takeover(1);
 	} else {
 		for (i = first_fb_vc; i <= last_fb_vc; i++) {
 			if (con2fb_map_boot[i] == idx)
diff --git a/drivers/video/fbmem.c b/drivers/video/fbmem.c
index 0dff12a..616278a 100644
--- a/drivers/video/fbmem.c
+++ b/drivers/video/fbmem.c
@@ -1651,7 +1651,9 @@ static int do_register_framebuffer(struct fb_info *fb_info)
 	event.info = fb_info;
 	if (!lock_fb_info(fb_info))
 		return -ENODEV;
+	console_lock();
 	fb_notifier_call_chain(FB_EVENT_FB_REGISTERED, &event);
+	console_unlock();
 	unlock_fb_info(fb_info);
 	return 0;
 }
@@ -1854,11 +1856,8 @@ int fb_new_modelist(struct fb_info *info)
 	err = 1;
 
 	if (!list_empty(&info->modelist)) {
-		if (!lock_fb_info(info))
-			return -ENODEV;
 		event.info = info;
 		err = fb_notifier_call_chain(FB_EVENT_NEW_MODELIST, &event);
-		unlock_fb_info(info);
 	}
 
 	return err;
diff --git a/drivers/video/fbsysfs.c b/drivers/video/fbsysfs.c
index a55e366..ef476b0 100644
--- a/drivers/video/fbsysfs.c
+++ b/drivers/video/fbsysfs.c
@@ -177,6 +177,8 @@ static ssize_t store_modes(struct device *device,
 	if (i * sizeof(struct fb_videomode) != count)
 		return -EINVAL;
 
+	if (!lock_fb_info(fb_info))
+		return -ENODEV;
 	console_lock();
 	list_splice(&fb_info->modelist, &old_list);
 	fb_videomode_to_modelist((const struct fb_videomode *)buf, i,
@@ -188,6 +190,7 @@ static ssize_t store_modes(struct device *device,
 		fb_destroy_modelist(&old_list);
 
 	console_unlock();
+	unlock_fb_info(fb_info);
 
 	return 0;
 }
diff --git a/include/linux/console.h b/include/linux/console.h
index 7201ce4..e8ea7d7 100644
--- a/include/linux/console.h
+++ b/include/linux/console.h
@@ -78,6 +78,7 @@ int con_is_bound(const struct consw *csw);
 int register_con_driver(const struct consw *csw, int first, int last);
 int unregister_con_driver(const struct consw *csw);
 int take_over_console(const struct consw *sw, int first, int last, int deflt);
+int do_take_over_console(const struct consw *sw, int first, int last, int deflt);
 void give_up_console(const struct consw *sw);
 #ifdef CONFIG_HW_CONSOLE
 int con_debug_enter(struct vc_data *vc);
-- 
1.8.1.2

