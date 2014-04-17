Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753557AbaDQGu6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Apr 2014 02:50:58 -0400
Received: from e06smtp10.uk.ibm.com ([195.75.94.106]:41935 "EHLO
	e06smtp10.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751088AbaDQGu4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Apr 2014 02:50:56 -0400
Message-ID: <1397717444.4034.15.camel@ThinkPad-T5421>
Subject: [RFC PATCH v4] Use kernfs_break_active_protection() for device
 online store callbacks
From: Li Zhong <zhong@linux.vnet.ibm.com>
To: Tejun Heo <tj@kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>, gregkh@linuxfoundation.org,
        rafael.j.wysocki@intel.com, toshi.kani@hp.com
Date: Thu, 17 Apr 2014 14:50:44 +0800
In-Reply-To: <20140416151749.GE1257@htj.dyndns.org>
References: <1397121514.25199.91.camel@ThinkPad-T5421.cn.ibm.com>
	 <20140410133116.GB25308@htj.dyndns.org>
	 <1397189445.3649.14.camel@ThinkPad-T5421>
	 <20140411102649.GB26252@mtj.dyndns.org>
	 <1397461649.12943.1.camel@ThinkPad-T5421.cn.ibm.com>
	 <20140414201315.GD16835@htj.dyndns.org>
	 <1397529877.13188.68.camel@ThinkPad-T5421.cn.ibm.com>
	 <20140415145017.GK1863@htj.dyndns.org>
	 <1397612500.13188.83.camel@ThinkPad-T5421.cn.ibm.com>
	 <20140416151749.GE1257@htj.dyndns.org>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14041706-4966-0000-0000-000009197BA0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch tries to solve the device hot remove locking issues in a
different way from commit 5e33bc41, as kernfs already has a mechanism 
to break active protection. 

The problem here is the order of s_active, and series of hotplug related
lock. 

This patch takes s_active out of the lock dependency graph, so it won't
dead lock with any hotplug realted locks.

Signed-off-by: Li Zhong <zhong@linux.vnet.ibm.com>
---
 drivers/base/core.c   | 37 ++++++++++++++++++++++++++++++++++---
 drivers/base/memory.c | 18 +++++++++++++++---
 2 files changed, 49 insertions(+), 6 deletions(-)

diff --git a/drivers/base/core.c b/drivers/base/core.c
index 0dd6528..1b96cb9 100644
--- a/drivers/base/core.c
+++ b/drivers/base/core.c
@@ -439,17 +439,48 @@ static ssize_t online_store(struct device *dev, struct device_attribute *attr,
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
+	kn = kernfs_find_and_get(dev->kobj.sd, attr->attr.name);
+	if (WARN_ON_ONCE(!kn))
+		return -ENODEV;
+
+	/*
+	 * Break active protection here to avoid deadlocks with device
+	 * removing process, which tries to remove sysfs entries including this
+	 * "online" attribute while holding some hotplug related locks.
+	 *
+	 * @dev needs to be protected here, or it could go away any time after
+	 * dropping active protection. But it is still unreasonable/unsafe to
+	 * online/offline a device after it being removed. Fortunately, there
+	 * are some checks in online/offline knobs. Like cpu, it checks cpu
+	 * present/online mask before doing the real work.
+	 */
+
+	get_device(dev);
+	kernfs_break_active_protection(kn);
+
+	lock_device_hotplug();
+
+	/*
+	 * If we assume device_hotplug_lock must be acquired before removing
+	 * device, we may try to find a way to check whether the device has
+	 * been removed here, so we don't call device_{on|off}line against
+	 * removed device.
+	 */
 
 	ret = val ? device_online(dev) : device_offline(dev);
 	unlock_device_hotplug();
+
+	kernfs_unbreak_active_protection(kn);
+	put_device(dev);
+
+	kernfs_put(kn);
+
 	return ret < 0 ? ret : count;
 }
 static DEVICE_ATTR_RW(online);
diff --git a/drivers/base/memory.c b/drivers/base/memory.c
index bece691..0d2f3a5 100644
--- a/drivers/base/memory.c
+++ b/drivers/base/memory.c
@@ -320,10 +320,17 @@ store_mem_state(struct device *dev,
 {
 	struct memory_block *mem = to_memory_block(dev);
 	int ret, online_type;
+	struct kernfs_node *kn;
 
-	ret = lock_device_hotplug_sysfs();
-	if (ret)
-		return ret;
+	kn = kernfs_find_and_get(dev->kobj.sd, attr->attr.name);
+	if (WARN_ON_ONCE(!kn))
+		return -ENODEV;
+
+	/* refer to comments in online_store() for more information */
+	get_device(dev);
+	kernfs_break_active_protection(kn);
+
+	lock_device_hotplug();
 
 	if (!strncmp(buf, "online_kernel", min_t(int, count, 13)))
 		online_type = ONLINE_KERNEL;
@@ -362,6 +369,11 @@ store_mem_state(struct device *dev,
 err:
 	unlock_device_hotplug();
 
+	kernfs_unbreak_active_protection(kn);
+	put_device(dev);
+
+	kernfs_put(kn);
+
 	if (ret)
 		return ret;
 	return count;


