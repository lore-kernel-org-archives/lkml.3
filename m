Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752042AbaBZOld (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Feb 2014 09:41:33 -0500
Received: from mailout01.c08.mtsvc.net ([205.186.168.189]:50033 "EHLO
	mailout01.c08.mtsvc.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751047AbaBZOlb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Feb 2014 09:41:31 -0500
From: Peter Hurley <peter@hurleysoftware.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Jiri Slaby <jslaby@suse.cz>, linux-kernel@vger.kernel.org,
        Peter Hurley <peter@hurleysoftware.com>,
        Ray Strode <halfline@gmail.com>, Kay Sievers <kay@vrfy.org>,
        David Herrmann <dh.herrmann@gmail.com>,
        Lennart Poettering <lennart@poettering.net>,
        Werner Fink <werner@suse.de>
Subject: [PATCH] tty: Add sysfs symlink for console name->tty device
Date: Wed, 26 Feb 2014 09:40:51 -0500
Message-Id: <1393425651-7374-1-git-send-email-peter@hurleysoftware.com>
X-Mailer: git-send-email 1.8.1.2
X-Authenticated-User: 125194 peter@hurleysoftware.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Enable a user-space process to discover the underlying tty device
for a console, if one exists, and when the tty device is later
created or destroyed.

Add sysfs symlinks for registered consoles to their respective
devices in [sys/class,sys/devices/virtual]/tty/console.
Scan consoles at tty device (un)registration to handle deferred
console<->device (un)binding.

Reported-by: Hannes Reinecke <hare@suse.de>
Cc: Ray Strode <halfline@gmail.com>
Cc: Kay Sievers <kay@vrfy.org>
Cc: David Herrmann <dh.herrmann@gmail.com>
Cc: Lennart Poettering <lennart@poettering.net>
Cc: Werner Fink <werner@suse.de>
Signed-off-by: Peter Hurley <peter@hurleysoftware.com>
---
 drivers/tty/tty_io.c    | 123 +++++++++++++++++++++++++++++++++++++++++++++++-
 include/linux/console.h |   8 +++-
 kernel/printk/printk.c  |   4 +-
 3 files changed, 129 insertions(+), 6 deletions(-)

diff --git a/drivers/tty/tty_io.c b/drivers/tty/tty_io.c
index a7cdbc5..53bb141 100644
--- a/drivers/tty/tty_io.c
+++ b/drivers/tty/tty_io.c
@@ -169,6 +169,12 @@ static void release_tty(struct tty_struct *tty, int idx);
 static void __proc_set_tty(struct task_struct *tsk, struct tty_struct *tty);
 static void proc_set_tty(struct task_struct *tsk, struct tty_struct *tty);
 
+#define TTY_SYSFS_NOTIFY_REGISTER   0
+#define TTY_SYSFS_NOTIFY_UNREGISTER 1
+static void tty_sysfs_notify(struct tty_driver *driver, int index,
+			     struct device *dev, int event);
+
+
 /**
  *	alloc_tty_struct	-	allocate a tty object
  *
@@ -3172,6 +3178,8 @@ struct device *tty_register_device_attr(struct tty_driver *driver,
 	if (retval)
 		goto error;
 
+	tty_sysfs_notify(driver, index, dev, TTY_SYSFS_NOTIFY_REGISTER);
+
 	return dev;
 
 error:
@@ -3195,6 +3203,8 @@ EXPORT_SYMBOL_GPL(tty_register_device_attr);
 
 void tty_unregister_device(struct tty_driver *driver, unsigned index)
 {
+	tty_sysfs_notify(driver, index, NULL, TTY_SYSFS_NOTIFY_UNREGISTER);
+
 	device_destroy(tty_class,
 		MKDEV(driver->major, driver->minor_start) + index);
 	if (!(driver->flags & TTY_DRIVER_DYNAMIC_ALLOC))
@@ -3544,12 +3554,118 @@ static DEVICE_ATTR(active, S_IRUGO, show_cons_active, NULL);
 
 static struct device *consdev;
 
-void console_sysfs_notify(void)
+static void console_name(struct console *c, size_t n, char *name)
 {
-	if (consdev)
+	snprintf(name, n, "%s%d", c->name, c->index);
+}
+
+static struct device *console_to_tty_device(struct console *c)
+{
+	struct tty_driver *driver;
+	dev_t devt;
+	int index;
+
+	if (!c->device)
+		return NULL;
+	driver = c->device(c, &index);
+	if (!driver)
+		return NULL;
+	devt = MKDEV(driver->major, driver->minor_start) + index;
+	return class_find_device(tty_class, NULL, &devt, dev_match_devt);
+}
+
+static void symlink_console_tty_device(struct console *c)
+{
+	struct device *tty_dev;
+	char link[64];
+
+	tty_dev = console_to_tty_device(c);
+	if (tty_dev) {
+		console_name(c, sizeof(link), link);
+		sysfs_create_link_nowarn(&consdev->kobj, &tty_dev->kobj, link);
+		put_device(tty_dev);
+	}
+}
+
+static void unlink_console_tty_device(struct console *c)
+{
+	char link[64];
+
+	console_name(c, sizeof(link), link);
+	sysfs_remove_link(&consdev->kobj, link);
+}
+
+void console_sysfs_notify(struct console *console, int event)
+{
+	if (!consdev)
+		return;
+
+	switch (event) {
+	case CON_SYSFS_NOTIFY_REGISTER:
+		symlink_console_tty_device(console);
+		break;
+	case CON_SYSFS_NOTIFY_UNREGISTER:
+		unlink_console_tty_device(console);
+		break;
+	}
+
+	sysfs_notify(&consdev->kobj, NULL, "active");
+}
+
+static void tty_sysfs_notify(struct tty_driver *driver, int index,
+			     struct device *dev, int event)
+{
+	struct console *c;
+	bool found_one = false;
+
+	if (!consdev)
+		return;
+
+	/* check if this tty device is a console device and if so
+	 * update the sysfs console links
+	 */
+	console_lock();
+	for_each_console(c) {
+		char link[64];
+		struct tty_driver *c_driver;
+		int c_index;
+
+		if (!c->device)
+			continue;
+		c_driver = c->device(c, &c_index);
+
+		if (driver == c_driver && index == c_index) {
+			console_name(c, sizeof(link), link);
+
+			switch (event) {
+			case TTY_SYSFS_NOTIFY_REGISTER:
+				sysfs_create_link_nowarn(&consdev->kobj,
+							 &dev->kobj, link);
+				break;
+			case TTY_SYSFS_NOTIFY_UNREGISTER:
+				sysfs_remove_link(&consdev->kobj, link);
+				break;
+			}
+			found_one = true;
+		}
+	}
+	console_unlock();
+
+	if (found_one)
 		sysfs_notify(&consdev->kobj, NULL, "active");
 }
 
+
+static void symlink_console_tty_devices(void)
+{
+	struct console *c;
+
+	console_lock();
+	for_each_console(c)
+		symlink_console_tty_device(c);
+	console_unlock();
+}
+
 /*
  * Ok, now we can initialize the rest of the tty devices and can count
  * on memory allocations, interrupts etc..
@@ -3573,6 +3689,9 @@ int __init tty_init(void)
 	else
 		WARN_ON(device_create_file(consdev, &dev_attr_active) < 0);
 
+	if (consdev)
+		symlink_console_tty_devices();
+
 #ifdef CONFIG_VT
 	vty_init(&console_fops);
 #endif
diff --git a/include/linux/console.h b/include/linux/console.h
index 7571a16..e8c4c04 100644
--- a/include/linux/console.h
+++ b/include/linux/console.h
@@ -157,10 +157,14 @@ extern int is_console_locked(void);
 extern int braille_register_console(struct console *, int index,
 		char *console_options, char *braille_options);
 extern int braille_unregister_console(struct console *);
+
+/* event values for console_sysfs_notify() */
+#define CON_SYSFS_NOTIFY_REGISTER 0
+#define CON_SYSFS_NOTIFY_UNREGISTER 1
 #ifdef CONFIG_TTY
-extern void console_sysfs_notify(void);
+extern void console_sysfs_notify(struct console *, int event);
 #else
-static inline void console_sysfs_notify(void)
+static inline void console_sysfs_notify(struct console *, int event)
 { }
 #endif
 extern bool console_suspend_enabled;
diff --git a/kernel/printk/printk.c b/kernel/printk/printk.c
index b1d255f..1e8dbe2 100644
--- a/kernel/printk/printk.c
+++ b/kernel/printk/printk.c
@@ -2348,7 +2348,7 @@ void register_console(struct console *newcon)
 		exclusive_console = newcon;
 	}
 	console_unlock();
-	console_sysfs_notify();
+	console_sysfs_notify(newcon, CON_SYSFS_NOTIFY_REGISTER);
 
 	/*
 	 * By unregistering the bootconsoles after we enable the real console
@@ -2410,7 +2410,7 @@ int unregister_console(struct console *console)
 		console_drivers->flags |= CON_CONSDEV;
 
 	console_unlock();
-	console_sysfs_notify();
+	console_sysfs_notify(console, CON_SYSFS_NOTIFY_UNREGISTER);
 	return res;
 }
 EXPORT_SYMBOL(unregister_console);
-- 
1.8.1.2

