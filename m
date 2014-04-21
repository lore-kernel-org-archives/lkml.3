Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751431AbaDUJYE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Apr 2014 05:24:04 -0400
Received: from e06smtp17.uk.ibm.com ([195.75.94.113]:56441 "EHLO
	e06smtp17.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751363AbaDUJYA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Apr 2014 05:24:00 -0400
Message-ID: <1398072230.2755.43.camel@ThinkPad-T5421.cn.ibm.com>
Subject: [RFC PATCH v5 2/2] Use kernfs_break_active_protection() for device
 online store callbacks
From: Li Zhong <zhong@linux.vnet.ibm.com>
To: Tejun Heo <tj@kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>, gregkh@linuxfoundation.org,
        rafael.j.wysocki@intel.com, toshi.kani@hp.com
Date: Mon, 21 Apr 2014 17:23:50 +0800
In-Reply-To: <1398072059.2755.41.camel@ThinkPad-T5421.cn.ibm.com>
References: <20140410133116.GB25308@htj.dyndns.org>
	 <1397189445.3649.14.camel@ThinkPad-T5421>
	 <20140411102649.GB26252@mtj.dyndns.org>
	 <1397461649.12943.1.camel@ThinkPad-T5421.cn.ibm.com>
	 <20140414201315.GD16835@htj.dyndns.org>
	 <1397529877.13188.68.camel@ThinkPad-T5421.cn.ibm.com>
	 <20140415145017.GK1863@htj.dyndns.org>
	 <1397612500.13188.83.camel@ThinkPad-T5421.cn.ibm.com>
	 <20140416151749.GE1257@htj.dyndns.org>
	 <1397717444.4034.15.camel@ThinkPad-T5421>
	 <20140417151728.GK15326@htj.dyndns.org>
	 <1398072059.2755.41.camel@ThinkPad-T5421.cn.ibm.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14042109-0542-0000-0000-000008B991C2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch tries to solve the device hot remove locking issues in a
different way from commit 5e33bc41, as kernfs already has a mechanism 
to break active protection. 

The active protection is there to keep the file alive by blocking
deletion while operations are on-going in the file.  This blocking
creates a dependency loop when an operation running off a sysfs knob
ends up grabbing a lock which may be held while removing the said sysfs
knob.

So the problem here is the order of s_active, and the series of hotplug
related locks. 

commit 5e33bc41 solves it by taking out the first of the series of
hoplug related locks, device_hotplug_lock, with a try lock. And if that
try lock fails, it returns a restart syscall error, and drops s_active
temporarily to allow the other process to remove the sysfs knob.

This doesn't help with lockdep warnings reported against s_active and
other hotplug related locks in the series.

This patch instead tries to take s_active out of the lock dependency
graph using the active protection breaking mechanism. 

lock_device_hotplug_sysfs() function name is kept here, two more
arguments are added, dev, attr, to help find the kernfs_node
corresponding to the sysfs knob (which should always be able to be
found, WARN if not). The found kernfs_node is recorded as the return
value, to be released in unlock_device_hotplug_sysfs().

As we break the active protection here, the device removing process
might remove the sysfs entries after that point. So after we grab the
device_hotplug_lock, we need check whether that really happens. If so,
we should abort and not invoke the online/offline callbacks anymore. In
this case, NULL is returned to the caller, so it could return with
ENODEV.

Signed-off-by: Li Zhong <zhong@linux.vnet.ibm.com>
---
 drivers/base/core.c    | 63 ++++++++++++++++++++++++++++++++++++++++++--------
 drivers/base/memory.c  |  9 ++++----
 include/linux/device.h |  5 +++-
 3 files changed, 62 insertions(+), 15 deletions(-)

diff --git a/drivers/base/core.c b/drivers/base/core.c
index 0dd6528..4d37a2b 100644
--- a/drivers/base/core.c
+++ b/drivers/base/core.c
@@ -61,14 +61,55 @@ void unlock_device_hotplug(void)
 	mutex_unlock(&device_hotplug_lock);
 }
 
-int lock_device_hotplug_sysfs(void)
+struct kernfs_node *lock_device_hotplug_sysfs(struct device *dev,
+					       struct device_attribute *attr)
 {
-	if (mutex_trylock(&device_hotplug_lock))
-		return 0;
+	struct kernfs_node *kn;
+
+	kn = kernfs_find_and_get(dev->kobj.sd, attr->attr.name);
+
+	if (WARN_ON_ONCE(!kn))
+		return NULL;
+
+	/*
+	 * Break active protection here to avoid deadlocks with device
+	 * removing process, which tries to remove sysfs entries including this
+	 * "online" attribute while holding some hotplug related locks.
+	 *
+	 * @dev needs to be protected here, or it could go away any time after
+	 * dropping active protection.
+	 */
+
+	get_device(dev);
+	kernfs_break_active_protection(kn);
+
+	lock_device_hotplug();
+
+	/*
+	 * We assume device_hotplug_lock must be acquired before removing
+	 * device, we can check here whether the device has been removed, so
+	 * we don't call device_{on|off}line against removed device.
+	 */
 
-	/* Avoid busy looping (5 ms of sleep should do). */
-	msleep(5);
-	return restart_syscall();
+	if (!dev->kobj.sd) {
+		/* device_del() already called on @dev, we should also abort */
+		unlock_device_hotplug();
+		kernfs_unbreak_active_protection(kn);
+		put_device(dev);
+		kernfs_put(kn);
+		return NULL;
+	}
+
+	return kn;
+}
+
+void unlock_device_hotplug_sysfs(struct device *dev,
+				 struct kernfs_node *kn)
+{
+	unlock_device_hotplug();
+	kernfs_unbreak_active_protection(kn);
+	put_device(dev);
+	kernfs_put(kn);
 }
 
 #ifdef CONFIG_BLOCK
@@ -439,17 +480,19 @@ static ssize_t online_store(struct device *dev, struct device_attribute *attr,
 {
 	bool val;
 	int ret;
+	struct kernfs_node *kn;
 
 	ret = strtobool(buf, &val);
 	if (ret < 0)
 		return ret;
 
-	ret = lock_device_hotplug_sysfs();
-	if (ret)
-		return ret;
+	kn = lock_device_hotplug_sysfs(dev, attr);
+	if (!kn)
+		return -ENODEV;
 
 	ret = val ? device_online(dev) : device_offline(dev);
-	unlock_device_hotplug();
+	unlock_device_hotplug_sysfs(dev, kn);
+
 	return ret < 0 ? ret : count;
 }
 static DEVICE_ATTR_RW(online);
diff --git a/drivers/base/memory.c b/drivers/base/memory.c
index bece691..c2b66d4 100644
--- a/drivers/base/memory.c
+++ b/drivers/base/memory.c
@@ -320,10 +320,11 @@ store_mem_state(struct device *dev,
 {
 	struct memory_block *mem = to_memory_block(dev);
 	int ret, online_type;
+	struct kernfs_node *kn;
 
-	ret = lock_device_hotplug_sysfs();
-	if (ret)
-		return ret;
+	kn = lock_device_hotplug_sysfs(dev, attr);
+	if (!kn)
+		return -ENODEV;
 
 	if (!strncmp(buf, "online_kernel", min_t(int, count, 13)))
 		online_type = ONLINE_KERNEL;
@@ -360,7 +361,7 @@ store_mem_state(struct device *dev,
 	}
 
 err:
-	unlock_device_hotplug();
+	unlock_device_hotplug_sysfs(dev, kn);
 
 	if (ret)
 		return ret;
diff --git a/include/linux/device.h b/include/linux/device.h
index 233bbbe..1ffd5ea 100644
--- a/include/linux/device.h
+++ b/include/linux/device.h
@@ -923,7 +923,10 @@ static inline bool device_supports_offline(struct device *dev)
 
 extern void lock_device_hotplug(void);
 extern void unlock_device_hotplug(void);
-extern int lock_device_hotplug_sysfs(void);
+extern struct kernfs_node *lock_device_hotplug_sysfs(struct device *dev,
+						struct device_attribute *attr);
+extern void unlock_device_hotplug_sysfs(struct device *dev,
+					struct kernfs_node *kn);
 extern int device_offline(struct device *dev);
 extern int device_online(struct device *dev);
 /*


