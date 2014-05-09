Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756406AbaEIImQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 May 2014 04:42:16 -0400
Received: from e28smtp08.in.ibm.com ([122.248.162.8]:58012 "EHLO
	e28smtp08.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752724AbaEIIkk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 May 2014 04:40:40 -0400
From: Li Zhong <zhong@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: Tejun Heo <tj@kernel.org>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Toshi Kani <toshi.kani@hp.com>, Li Zhong <zhong@linux.vnet.ibm.com>
Subject: [RFC PATCH v6 2/2] Implement lock_device_hotplug_sysfs() by breaking active protection
Date: Fri,  9 May 2014 16:40:16 +0800
Message-Id: <1399624816-11127-2-git-send-email-zhong@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1399624816-11127-1-git-send-email-zhong@linux.vnet.ibm.com>
References: <1399624508.2630.11.camel@ThinkPad-T5421.cn.ibm.com>
 <1399624816-11127-1-git-send-email-zhong@linux.vnet.ibm.com>
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14050908-2000-0000-0000-00001131B447
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

lock_device_hotplug_sysfs() function name is kept here, three more
arguments are added, dev, attr, to help find the kernfs_node
corresponding to the sysfs knob (which should always be able to be
found, WARN if not); kn_out is used to record the found kernfs_node for
use in unlock. unlock_device_hotplug_sysfs() is created to help
cleanup the operations(get reference, break active, etc) done in
lock_device_hotplug_sysfs(), as well as unlock the lock.

As we break the active protection here, the device removing process
might remove the sysfs entries after that point. So after we grab the
device_hotplug_lock, we can check whether that really happens. If so,
we should abort and not invoke the online/offline callbacks anymore.
lockdep assertion is added in try_offline_node() to make sure
device_hotplug_lock is grabbed while removing cpu or memory.

As devcie_hotplug_lock is used to protect hotplug operations with multiple
subsystems. So there might be devices that won't be removed together with
devices of other subsystems, and thus device_hotplug_lock is not needed.
In this case, their specific online/offline callbacks needs to check whether
the device has been removed.

Cc: Tejun Heo <tj@kernel.org>
Cc: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Toshi Kani <toshi.kani@hp.com>
Signed-off-by: Li Zhong <zhong@linux.vnet.ibm.com>
---
 drivers/base/core.c    | 93 +++++++++++++++++++++++++++++++++++++++++++++-----
 drivers/base/memory.c  |  5 +--
 include/linux/device.h |  7 +++-
 mm/memory_hotplug.c    |  2 ++
 4 files changed, 95 insertions(+), 12 deletions(-)

diff --git a/drivers/base/core.c b/drivers/base/core.c
index 20da3ad..329f3b4 100644
--- a/drivers/base/core.c
+++ b/drivers/base/core.c
@@ -61,14 +61,87 @@ void unlock_device_hotplug(void)
 	mutex_unlock(&device_hotplug_lock);
 }
 
-int lock_device_hotplug_sysfs(void)
+void device_hotplug_assert_held(void)
 {
-	if (mutex_trylock(&device_hotplug_lock))
-		return 0;
+	lockdep_assert_held(&device_hotplug_lock);
+}
+
+/*
+ * device_hotplug_lock is used to protect hotplugs which may involve multiple
+ * subsystems. This _sysfs() version is created to solve the deadlock with
+ * s_active of the device attribute file, which could be used to online/offline
+ * the device.
+ *
+ * Returns 0 on success. -ENODEV if the @dev is removed after we break the
+ * active protection. (We should always be able to find the kernfs_node
+ * related to the attribute, WARN if not, and also return -ENODEV).
+ *
+ * When success(return 0), the found kernfs_node is passed out in @kn_out,
+ * else pass NULL to @kn_out.
+ */
+int lock_device_hotplug_sysfs(struct device *dev,
+			      struct device_attribute *attr,
+			      struct kernfs_node **kn_out)
+{
+	struct kernfs_node *kn;
+
+	*kn_out = kn = kernfs_find_and_get(dev->kobj.sd, attr->attr.name);
+
+	if (WARN_ON_ONCE(!kn))
+		return -ENODEV;
+
+	/*
+	 * Break active protection here to avoid deadlocks with device
+	 * removing process, which tries to remove sysfs entries including this
+	 * "online" attribute while holding some hotplug related locks.
+	 *
+	 * @dev needs to be protected here, or it could go away any time after
+	 * dropping active protection.
+	 */
+	get_device(dev);
+	kernfs_break_active_protection(kn);
+
+	lock_device_hotplug();
+
+	/*
+	 * For devices which need device_hoplug_lock to protect the
+	 * online/offline operation, i.e. it might be removed together with
+	 * devices in some other subsystems, we can check here whether the
+	 * device has been removed, so we don't call device_{on|off}line
+	 * against removed device. lockdep assertion is added in
+	 * try_offline_node() to make sure the lock is held to remove cpu
+	 * or memory.
+	 *
+	 * If some devices won't be removed together with devices in other
+	 * subsystems, thus device_hotplug_lock is not needed. Then they need
+	 * check whether device has been removed in their devices' specific
+	 * online/offline callbacks.
+	 */
+	if (!dev->kobj.sd) {
+		/* device_del() already called on @dev, we should also abort */
+		unlock_device_hotplug();
+		kernfs_unbreak_active_protection(kn);
+		put_device(dev);
+		kernfs_put(kn);
+		*kn_out = NULL;
+		return -ENODEV;
+	}
 
-	/* Avoid busy looping (5 ms of sleep should do). */
-	msleep(5);
-	return restart_syscall();
+	return 0;
+}
+
+/*
+ * This _sysfs version of unlock_device_hotplug help to undo the
+ * operations (get reference, break active protection, etc) done in
+ * lock_device_hotplug_sysfs(), as well as unlock the device_hotplug_lock.
+ */
+void unlock_device_hotplug_sysfs(struct device *dev,
+				 struct kernfs_node *kn)
+{
+	unlock_device_hotplug();
+	kernfs_unbreak_active_protection(kn);
+	put_device(dev);
+	kernfs_put(kn);
 }
 
 #ifdef CONFIG_BLOCK
@@ -439,17 +512,19 @@ static ssize_t online_store(struct device *dev, struct device_attribute *attr,
 {
 	bool val;
 	int ret;
+	struct kernfs_node *kn = NULL;
 
 	ret = strtobool(buf, &val);
 	if (ret < 0)
 		return ret;
 
-	ret = lock_device_hotplug_sysfs();
-	if (ret)
+	ret = lock_device_hotplug_sysfs(dev, attr, &kn);
+	if (ret < 0)
 		return ret;
 
 	ret = val ? device_online(dev) : device_offline(dev);
-	unlock_device_hotplug();
+	unlock_device_hotplug_sysfs(dev, kn);
+
 	return ret < 0 ? ret : count;
 }
 static DEVICE_ATTR_RW(online);
diff --git a/drivers/base/memory.c b/drivers/base/memory.c
index bece691..f82dea4 100644
--- a/drivers/base/memory.c
+++ b/drivers/base/memory.c
@@ -320,8 +320,9 @@ store_mem_state(struct device *dev,
 {
 	struct memory_block *mem = to_memory_block(dev);
 	int ret, online_type;
+	struct kernfs_node *kn = NULL;
 
-	ret = lock_device_hotplug_sysfs();
+	ret = lock_device_hotplug_sysfs(dev, attr, &kn);
 	if (ret)
 		return ret;
 
@@ -360,7 +361,7 @@ store_mem_state(struct device *dev,
 	}
 
 err:
-	unlock_device_hotplug();
+	unlock_device_hotplug_sysfs(dev, kn);
 
 	if (ret)
 		return ret;
diff --git a/include/linux/device.h b/include/linux/device.h
index d1d1c05..19a24f4 100644
--- a/include/linux/device.h
+++ b/include/linux/device.h
@@ -917,7 +917,12 @@ static inline bool device_supports_offline(struct device *dev)
 
 extern void lock_device_hotplug(void);
 extern void unlock_device_hotplug(void);
-extern int lock_device_hotplug_sysfs(void);
+extern void device_hotplug_assert_held(void);
+extern int lock_device_hotplug_sysfs(struct device *dev,
+				     struct device_attribute *attr,
+				     struct kernfs_node **kn);
+extern void unlock_device_hotplug_sysfs(struct device *dev,
+					struct kernfs_node *parent);
 extern int device_offline(struct device *dev);
 extern int device_online(struct device *dev);
 /*
diff --git a/mm/memory_hotplug.c b/mm/memory_hotplug.c
index a650db2..bdec24d 100644
--- a/mm/memory_hotplug.c
+++ b/mm/memory_hotplug.c
@@ -1822,6 +1822,8 @@ void try_offline_node(int nid)
 	struct page *pgdat_page = virt_to_page(pgdat);
 	int i;
 
+	device_hotplug_assert_held();
+
 	for (pfn = start_pfn; pfn < end_pfn; pfn += PAGES_PER_SECTION) {
 		unsigned long section_nr = pfn_to_section_nr(pfn);
 
-- 
1.8.1.4

