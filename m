Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754665Ab3H0VfH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Aug 2013 17:35:07 -0400
Received: from hydra.sisk.pl ([212.160.235.94]:37764 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753878Ab3H0VfF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Aug 2013 17:35:05 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Tejun Heo <tj@kernel.org>
Cc: Gu Zheng <guz.fnst@cn.fujitsu.com>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Toshi Kani <toshi.kani@hp.com>, LKML <linux-kernel@vger.kernel.org>,
        Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
Subject: Re: [PATCH] driver core / ACPI: Avoid device removal locking problems
Date: Tue, 27 Aug 2013 23:45:46 +0200
Message-ID: <2885746.SMJa75jgiX@vostro.rjw.lan>
User-Agent: KMail/4.10.5 (Linux/3.11.0-rc6+; KDE/4.10.5; x86_64; ; )
In-Reply-To: <20130827183644.GC12212@mtj.dyndns.org>
References: <1543475.L7gSB7lLAu@vostro.rjw.lan> <521C6FA8.4070804@cn.fujitsu.com> <20130827183644.GC12212@mtj.dyndns.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, August 27, 2013 02:36:44 PM Tejun Heo wrote:
> Hello,
> 
> On Tue, Aug 27, 2013 at 05:21:44PM +0800, Gu Zheng wrote:
> > >> OK, so the patch below is quick and dirty and overkill, but it should make the
> > >> splat go away at least.
> > > 
> > > And if this patch does make the splat go away for you, please also test the
> > > appended one (Tejun, thanks for the hint!).
> > > 
> > > I'll address the ACPI part differently later.
> > 
> > What about changing device_hotplug_lock and acpi_scan_lock to rwsem? like the
> > attached one(With a preliminary test, it also can make the splat go away).:)
> 
> Hmmm.. I don't get it.  How is introducing another rwlock whic may
> cause the operation, even reading the status, to fail randomly a
> better option?

That's more about replacing an existing mutex with an rwsem, but I don't think
it helps anyway.  And as I said before, the acpi_eject_store() case is entirely
separate in my opinion.

> It's harier and more brittle.  We probably want to
> implement better solution in sysfs for files which interact with
> device addition / removal paths but for now I think Rafael's patch is
> the right direction.

I've thought about that a bit over the last several hours and I'm still
thinking that that patch is a bit overkill, because it will trigger the
restart_syscall() for all cases when device_hotplug_lock is locked, even
if they can't lead to any deadlocks.  The only deadlockish situation is
when device *removal* is in progress when store_online(), for example,
is called.

So to address that particular situation without adding too much overhead for
other cases, I've come up with the appended patch (untested for now).

This is how it is supposed to work.

There are three "lock levels" for device hotplug, "normal", "remove"
and "weak".  The difference is related to how __lock_device_hotplug()
works.  Namely, if device hotplug is currently locked, that function
will either block or return false, depending on the "current lock
level" and its argument (the "new lock level").  The rules here are
that false is returned immediately if the "current lock level" is
"remove" and the "new lock level" is "weak".  The function blocks
for all other combinations of the two.

There are two functions supposed to use device hotplug "lock levels"
other than "normal": store_online() and acpi_scan_hot_remove().
Everybody else is supposed to use "normal" (well, there are more
potential users of "weak" in drivers/base/memory.c).

acpi_scan_hot_remove() uses the "remove" lock level to indicate
that it is going to remove devices while holding device hotplug
locked.  In turn, store_online() uses the "weak" lock level so
that it doesn't block when devices are being removed with device
hotplug locked, because that may lead to a deadlock.

show_online() actually doesn't need to lock device hotplug, but
it is useful to serialize it with respect to device_offline()
and device_online() (in case user space attempts to run them
concurrently).

---
 drivers/acpi/scan.c    |    4 +-
 drivers/base/core.c    |   72 ++++++++++++++++++++++++++++++++++++++-----------
 include/linux/device.h |   25 ++++++++++++++++-
 3 files changed, 83 insertions(+), 18 deletions(-)

Index: linux-pm/drivers/base/core.c
===================================================================
--- linux-pm.orig/drivers/base/core.c
+++ linux-pm/drivers/base/core.c
@@ -49,6 +49,55 @@ static struct kobject *dev_kobj;
 struct kobject *sysfs_dev_char_kobj;
 struct kobject *sysfs_dev_block_kobj;
 
+static struct {
+	struct task_struct *holder;
+	enum dev_hotplug_lock_type type;
+	struct mutex lock; /* Synchronizes accesses to holder and type */
+	wait_queue_head_t wait_queue;
+} device_hotplug = {
+	.holder = NULL,
+	.type = DEV_HOTPLUG_LOCK_NONE,
+	.lock = __MUTEX_INITIALIZER(device_hotplug.lock),
+	.wait_queue = __WAIT_QUEUE_HEAD_INITIALIZER(device_hotplug.wait_queue),
+};
+
+bool __lock_device_hotplug(enum dev_hotplug_lock_type type)
+{
+	DEFINE_WAIT(wait);
+	bool ret = true;
+
+	mutex_lock(&device_hotplug.lock);
+	for (;;) {
+		prepare_to_wait(&device_hotplug.wait_queue, &wait,
+				TASK_UNINTERRUPTIBLE);
+		if (!device_hotplug.holder) {
+			device_hotplug.holder = current;
+			device_hotplug.type = type;
+			break;
+		} else if (type == DEV_HOTPLUG_LOCK_WEAK
+		    && device_hotplug.type == DEV_HOTPLUG_LOCK_REMOVE) {
+			ret = false;
+			break;
+		}
+		mutex_unlock(&device_hotplug.lock);
+		schedule();
+		mutex_lock(&device_hotplug.lock);
+	}
+	finish_wait(&device_hotplug.wait_queue, &wait);
+	mutex_unlock(&device_hotplug.lock);
+	return ret;
+}
+
+void unlock_device_hotplug(void)
+{
+	mutex_lock(&device_hotplug.lock);
+	BUG_ON(device_hotplug.holder != current);
+	device_hotplug.holder = NULL;
+	device_hotplug.type = DEV_HOTPLUG_LOCK_NONE;
+	wake_up(&device_hotplug.wait_queue);
+	mutex_unlock(&device_hotplug.lock);
+}
+
 #ifdef CONFIG_BLOCK
 static inline int device_is_not_partition(struct device *dev)
 {
@@ -408,9 +457,10 @@ static ssize_t show_online(struct device
 {
 	bool val;
 
-	lock_device_hotplug();
+	/* Serialize against device_online() and device_offline(). */
+	device_lock(dev);
 	val = !dev->offline;
-	unlock_device_hotplug();
+	device_unlock(dev);
 	return sprintf(buf, "%u\n", val);
 }
 
@@ -424,7 +474,11 @@ static ssize_t store_online(struct devic
 	if (ret < 0)
 		return ret;
 
-	lock_device_hotplug();
+	if (!__lock_device_hotplug(DEV_HOTPLUG_LOCK_WEAK)) {
+		/* Avoid busy looping (10 ms delay should do). */
+		msleep(10);
+		return restart_syscall();
+	}
 	ret = val ? device_online(dev) : device_offline(dev);
 	unlock_device_hotplug();
 	return ret < 0 ? ret : count;
@@ -1479,18 +1533,6 @@ EXPORT_SYMBOL_GPL(put_device);
 EXPORT_SYMBOL_GPL(device_create_file);
 EXPORT_SYMBOL_GPL(device_remove_file);
 
-static DEFINE_MUTEX(device_hotplug_lock);
-
-void lock_device_hotplug(void)
-{
-	mutex_lock(&device_hotplug_lock);
-}
-
-void unlock_device_hotplug(void)
-{
-	mutex_unlock(&device_hotplug_lock);
-}
-
 static int device_check_offline(struct device *dev, void *not_used)
 {
 	int ret;
Index: linux-pm/include/linux/device.h
===================================================================
--- linux-pm.orig/include/linux/device.h
+++ linux-pm/include/linux/device.h
@@ -893,8 +893,31 @@ static inline bool device_supports_offli
 	return dev->bus && dev->bus->offline && dev->bus->online;
 }
 
-extern void lock_device_hotplug(void);
+enum dev_hotplug_lock_type {
+	DEV_HOTPLUG_LOCK_NONE,
+	DEV_HOTPLUG_LOCK_NORMAL,
+	DEV_HOTPLUG_LOCK_REMOVE,
+	DEV_HOTPLUG_LOCK_WEAK,
+};
+
+extern bool __lock_device_hotplug(enum dev_hotplug_lock_type);
 extern void unlock_device_hotplug(void);
+
+static inline void lock_device_hotplug(void)
+{
+	__lock_device_hotplug(DEV_HOTPLUG_LOCK_NORMAL);
+}
+
+static inline void lock_device_hot_remove(void)
+{
+	__lock_device_hotplug(DEV_HOTPLUG_LOCK_REMOVE);
+}
+
+static inline void unlock_device_hot_remove(void)
+{
+	unlock_device_hotplug();
+}
+
 extern int device_offline(struct device *dev);
 extern int device_online(struct device *dev);
 /*
Index: linux-pm/drivers/acpi/scan.c
===================================================================
--- linux-pm.orig/drivers/acpi/scan.c
+++ linux-pm/drivers/acpi/scan.c
@@ -204,7 +204,7 @@ static int acpi_scan_hot_remove(struct a
 		return -EINVAL;
 	}
 
-	lock_device_hotplug();
+	lock_device_hot_remove();
 
 	/*
 	 * Carry out two passes here and ignore errors in the first pass,
@@ -249,7 +249,7 @@ static int acpi_scan_hot_remove(struct a
 
 	acpi_bus_trim(device);
 
-	unlock_device_hotplug();
+	unlock_device_hot_remove();
 
 	/* Device node has been unregistered. */
 	put_device(&device->dev);

