Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966784Ab3DQVYM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Apr 2013 17:24:12 -0400
Received: from mx1.redhat.com ([209.132.183.28]:53467 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965128Ab3DQVYJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Apr 2013 17:24:09 -0400
From: Don Zickus <dzickus@redhat.com>
To: linux-watchdog@vger.kernel.org, kexec@lists.infradead.org
Cc: wim@iguana.be, LKML <linux-kernel@vger.kernel.org>, vgoyal@redhat.com,
        dyoung@redhat.com, ebiederm@xmission.com, linux@roeck-us.net,
        Don Zickus <dzickus@redhat.com>
Subject: [PATCH v3] watchdog: Add hook for kicking in kdump path
Date: Wed, 17 Apr 2013 17:19:56 -0400
Message-Id: <1366233596-34681-1-git-send-email-dzickus@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A common problem with kdump is that during the boot up of the
second kernel, the hardware watchdog times out and reboots the
machine before a vmcore can be captured.

Instead of tellling customers to disable their hardware watchdog
timers, I hacked up a hook to put in the kdump path that provides
one last kick before jumping into the second kernel.

The assumption is the watchdog timeout is at least 10-30 seconds
long, enough to get the second kernel to userspace to kick the watchdog
again, if needed.

Of course kdump is usually executed on a panic path, so grabbing the
watchdog mutexes to communicate with the hardware won't work.  For now,
I use trylock, otherwise fail.

I have tested this with a machine using iTCO_wdt and the 'watchdog' app.
The extra kicked happened as expected.

v2:  based on feedback, implemented a linked list of watchdog references.
     added trylock in watchdog_ping and used that function for kicking.
     renamed export function to be more generic.

v3:  small cleanups, remove mutex_safe variable from EXPORT_SYMBOL

Signed-off-by: Don Zickus <dzickus@redhat.com>
---
 drivers/watchdog/watchdog_dev.c |   74 +++++++++++++++++++++++++++++++++++---
 include/linux/watchdog.h        |    9 +++++
 kernel/kexec.c                  |    6 +++
 3 files changed, 83 insertions(+), 6 deletions(-)

diff --git a/drivers/watchdog/watchdog_dev.c b/drivers/watchdog/watchdog_dev.c
index 08b48bb..52cb465 100644
--- a/drivers/watchdog/watchdog_dev.c
+++ b/drivers/watchdog/watchdog_dev.c
@@ -49,6 +49,16 @@ static dev_t watchdog_devt;
 /* the watchdog device behind /dev/watchdog */
 static struct watchdog_device *old_wdd;
 
+/* link list of all watchdog devices */
+struct watchdog_list {
+	spinlock_t lock;
+	struct list_head head;
+};
+static struct watchdog_list wdlist = {
+	.lock = __SPIN_LOCK_UNLOCKED(wdlist.lock),
+	.head = LIST_HEAD_INIT(wdlist.head),
+};
+
 /*
  *	watchdog_ping: ping the watchdog.
  *	@wddev: the watchdog device to ping
@@ -59,11 +69,18 @@ static struct watchdog_device *old_wdd;
  *	We only ping when the watchdog device is running.
  */
 
-static int watchdog_ping(struct watchdog_device *wddev)
+static int watchdog_ping(struct watchdog_device *wddev, bool mutex_safe)
 {
 	int err = 0;
 
-	mutex_lock(&wddev->lock);
+	if (mutex_safe) {
+		mutex_lock(&wddev->lock);
+	} else {
+		if (!mutex_trylock(&wddev->lock)) {
+			pr_warn("watchdog%d: Unable to lock mutex\n", wddev->id);
+			return -EAGAIN;
+		}
+	}
 
 	if (test_bit(WDOG_UNREGISTERED, &wddev->status)) {
 		err = -ENODEV;
@@ -83,6 +100,38 @@ out_ping:
 	return err;
 }
 
+/**
+ *	watchdog_kick_all: kick all the watchdogs
+ *
+ *	There are times when the kernel needs to kick all the
+ *	watchdogs at once without the use of references.  For
+ *	example in the kdump path, when the kernel is about
+ *	to jump into the second kernel.
+ *
+ *	The 'false' variable is for contextes that can not
+ *	sleep, therefore try to kick the watchdog with trylock
+ *	instead.
+ *
+ *	Walk the link list locklessly using RCU to handle various
+ *	contexts this could be called in.  Should support irq and
+ *	NMI contexts correctly.
+ */
+
+void watchdog_kick_all(void)
+{
+	struct watchdog_device *wddev;
+
+	rcu_read_lock();
+
+	list_for_each_entry_rcu(wddev, &wdlist.head, list)
+		watchdog_ping(wddev, false);
+
+	rcu_read_unlock();
+
+	return;
+}
+EXPORT_SYMBOL_GPL(watchdog_kick_all);
+
 /*
  *	watchdog_start: wrapper to start the watchdog.
  *	@wddev: the watchdog device to start
@@ -314,7 +363,7 @@ static ssize_t watchdog_write(struct file *file, const char __user *data,
 	}
 
 	/* someone wrote to us, so we send the watchdog a keepalive ping */
-	watchdog_ping(wdd);
+	watchdog_ping(wdd, true);
 
 	return len;
 }
@@ -370,7 +419,7 @@ static long watchdog_ioctl(struct file *file, unsigned int cmd,
 	case WDIOC_KEEPALIVE:
 		if (!(wdd->info->options & WDIOF_KEEPALIVEPING))
 			return -EOPNOTSUPP;
-		watchdog_ping(wdd);
+		watchdog_ping(wdd, true);
 		return 0;
 	case WDIOC_SETTIMEOUT:
 		if (get_user(val, p))
@@ -381,7 +430,7 @@ static long watchdog_ioctl(struct file *file, unsigned int cmd,
 		/* If the watchdog is active then we send a keepalive ping
 		 * to make sure that the watchdog keep's running (and if
 		 * possible that it takes the new timeout) */
-		watchdog_ping(wdd);
+		watchdog_ping(wdd, true);
 		/* Fall */
 	case WDIOC_GETTIMEOUT:
 		/* timeout == 0 means that we don't know the timeout */
@@ -479,7 +528,7 @@ static int watchdog_release(struct inode *inode, struct file *file)
 		if (!test_bit(WDOG_UNREGISTERED, &wdd->status))
 			dev_crit(wdd->dev, "watchdog did not stop!\n");
 		mutex_unlock(&wdd->lock);
-		watchdog_ping(wdd);
+		watchdog_ping(wdd, true);
 	}
 
 	/* Allow the owner module to be unloaded again */
@@ -550,7 +599,14 @@ int watchdog_dev_register(struct watchdog_device *watchdog)
 			misc_deregister(&watchdog_miscdev);
 			old_wdd = NULL;
 		}
+		return err;
 	}
+
+	/* no need for save/restore here, not in an irq context */
+	spin_lock_irq(&wdlist.lock);
+	list_add_tail_rcu(&watchdog->list, &wdlist.head);
+	spin_unlock_irq(&wdlist.lock);
+
 	return err;
 }
 
@@ -572,6 +628,12 @@ int watchdog_dev_unregister(struct watchdog_device *watchdog)
 		misc_deregister(&watchdog_miscdev);
 		old_wdd = NULL;
 	}
+
+	/* no need for save/restore here, not in an irq context */
+	spin_lock_irq(&wdlist.lock);
+	list_del_rcu(&watchdog->list);
+	spin_unlock_irq(&wdlist.lock);
+
 	return 0;
 }
 
diff --git a/include/linux/watchdog.h b/include/linux/watchdog.h
index 2a3038e..d33e209 100644
--- a/include/linux/watchdog.h
+++ b/include/linux/watchdog.h
@@ -65,6 +65,7 @@ struct watchdog_ops {
  * @driver-data:Pointer to the drivers private data.
  * @lock:	Lock for watchdog core internal use only.
  * @status:	Field that contains the devices internal status bits.
+ * @list:	Link list of all watchdog devices
  *
  * The watchdog_device structure contains all information about a
  * watchdog timer device.
@@ -95,6 +96,7 @@ struct watchdog_device {
 #define WDOG_ALLOW_RELEASE	2	/* Did we receive the magic char ? */
 #define WDOG_NO_WAY_OUT		3	/* Is 'nowayout' feature set ? */
 #define WDOG_UNREGISTERED	4	/* Has the device been unregistered */
+	struct list_head list;
 };
 
 #ifdef CONFIG_WATCHDOG_NOWAYOUT
@@ -142,4 +144,11 @@ extern int watchdog_init_timeout(struct watchdog_device *wdd,
 extern int watchdog_register_device(struct watchdog_device *);
 extern void watchdog_unregister_device(struct watchdog_device *);
 
+#ifdef CONFIG_WATCHDOG_CORE
+/* drivers/watchdog/watchdog_dev.c */
+extern void watchdog_kick_all(void);
+#else
+static inline void watchdog_kick_all(void) { };
+#endif
+
 #endif  /* ifndef _LINUX_WATCHDOG_H */
diff --git a/kernel/kexec.c b/kernel/kexec.c
index bddd3d7..24787f1 100644
--- a/kernel/kexec.c
+++ b/kernel/kexec.c
@@ -32,6 +32,7 @@
 #include <linux/vmalloc.h>
 #include <linux/swap.h>
 #include <linux/syscore_ops.h>
+#include <linux/watchdog.h>
 
 #include <asm/page.h>
 #include <asm/uaccess.h>
@@ -1094,6 +1095,11 @@ void crash_kexec(struct pt_regs *regs)
 		if (kexec_crash_image) {
 			struct pt_regs fixed_regs;
 
+			/*
+			 * Give second kernel a chance to boot
+			 */
+			watchdog_kick_all();
+
 			crash_setup_regs(&fixed_regs, regs);
 			crash_save_vmcoreinfo();
 			machine_crash_shutdown(&fixed_regs);
-- 
1.7.1

