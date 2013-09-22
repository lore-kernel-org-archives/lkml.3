Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753333Ab3IVBXN (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Sep 2013 21:23:13 -0400
Received: from mail-pa0-f51.google.com ([209.85.220.51]:59135 "EHLO
	mail-pa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753304Ab3IVBXH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Sep 2013 21:23:07 -0400
From: Viresh Kumar <viresh.kumar@linaro.org>
To: rjw@sisk.pl, daniel.lezcano@linaro.org
Cc: linaro-kernel@lists.linaro.org, patches@linaro.org,
        linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Viresh Kumar <viresh.kumar@linaro.org>
Subject: [PATCH 16/21] cpuidle: avoid unnecessary kzalloc/free of struct cpuidle_device_kobj
Date: Sun, 22 Sep 2013 06:51:08 +0530
Message-Id: <fb67ff6fa01bde06aeab43c4a02da2923615e6ef.1379779777.git.viresh.kumar@linaro.org>
X-Mailer: git-send-email 1.7.12.rc2.18.g61b472e
In-Reply-To: <cover.1379779777.git.viresh.kumar@linaro.org>
References: <cover.1379779777.git.viresh.kumar@linaro.org>
In-Reply-To: <cover.1379779777.git.viresh.kumar@linaro.org>
References: <cover.1379779777.git.viresh.kumar@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We always need to allocate struct cpuidle_device_kobj for all CPUs and so there
is no real need to have a pointer to it inside struct cpuidle_device.

This patch makes a object instance of struct cpuidle_device_kobj inside struct
cpuidle_device instead of a pointer.

Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
---
 drivers/cpuidle/sysfs.c | 24 +++++-------------------
 include/linux/cpuidle.h | 11 +++++++++--
 2 files changed, 14 insertions(+), 21 deletions(-)

diff --git a/drivers/cpuidle/sysfs.c b/drivers/cpuidle/sysfs.c
index ade31a9..db0aac3 100644
--- a/drivers/cpuidle/sysfs.c
+++ b/drivers/cpuidle/sysfs.c
@@ -172,12 +172,6 @@ struct cpuidle_attr {
 
 #define attr_to_cpuidleattr(a) container_of(a, struct cpuidle_attr, attr)
 
-struct cpuidle_device_kobj {
-	struct cpuidle_device *dev;
-	struct completion kobj_unregister;
-	struct kobject kobj;
-};
-
 static inline struct cpuidle_device *to_cpuidle_device(struct kobject *kobj)
 {
 	struct cpuidle_device_kobj *kdev =
@@ -399,7 +393,7 @@ static int cpuidle_add_state_sysfs(struct cpuidle_device *device)
 {
 	int i, ret = -ENOMEM;
 	struct cpuidle_state_kobj *kobj;
-	struct cpuidle_device_kobj *kdev = device->kobj_dev;
+	struct cpuidle_device_kobj *kdev = &device->kobj_dev;
 	struct cpuidle_driver *drv = cpuidle_get_cpu_driver(device);
 
 	/* state statistics */
@@ -525,7 +519,7 @@ static struct kobj_type ktype_driver_cpuidle = {
 static int cpuidle_add_driver_sysfs(struct cpuidle_device *dev)
 {
 	struct cpuidle_driver_kobj *kdrv;
-	struct cpuidle_device_kobj *kdev = dev->kobj_dev;
+	struct cpuidle_device_kobj *kdev = &dev->kobj_dev;
 	struct cpuidle_driver *drv = cpuidle_get_cpu_driver(dev);
 	int ret;
 
@@ -606,24 +600,17 @@ void cpuidle_remove_device_sysfs(struct cpuidle_device *device)
  */
 int cpuidle_add_sysfs(struct cpuidle_device *dev)
 {
-	struct cpuidle_device_kobj *kdev;
+	struct cpuidle_device_kobj *kdev = &dev->kobj_dev;
 	struct device *cpu_dev = get_cpu_device((unsigned long)dev->cpu);
 	int error;
 
-	kdev = kzalloc(sizeof(*kdev), GFP_KERNEL);
-	if (!kdev)
-		return -ENOMEM;
 	kdev->dev = dev;
-	dev->kobj_dev = kdev;
-
 	init_completion(&kdev->kobj_unregister);
 
 	error = kobject_init_and_add(&kdev->kobj, &ktype_cpuidle, &cpu_dev->kobj,
 				   "cpuidle");
-	if (error) {
-		kfree(kdev);
+	if (error)
 		return error;
-	}
 
 	kobject_uevent(&kdev->kobj, KOBJ_ADD);
 
@@ -636,9 +623,8 @@ int cpuidle_add_sysfs(struct cpuidle_device *dev)
  */
 void cpuidle_remove_sysfs(struct cpuidle_device *dev)
 {
-	struct cpuidle_device_kobj *kdev = dev->kobj_dev;
+	struct cpuidle_device_kobj *kdev = &dev->kobj_dev;
 
 	kobject_put(&kdev->kobj);
 	wait_for_completion(&kdev->kobj_unregister);
-	kfree(kdev);
 }
diff --git a/include/linux/cpuidle.h b/include/linux/cpuidle.h
index c082425..1fc5cb5 100644
--- a/include/linux/cpuidle.h
+++ b/include/linux/cpuidle.h
@@ -11,6 +11,8 @@
 #ifndef _LINUX_CPUIDLE_H
 #define _LINUX_CPUIDLE_H
 
+#include <linux/completion.h>
+#include <linux/kobject.h>
 #include <linux/percpu.h>
 #include <linux/list.h>
 #include <linux/hrtimer.h>
@@ -59,10 +61,15 @@ struct cpuidle_state {
 
 #define CPUIDLE_DRIVER_FLAGS_MASK (0xFFFF0000)
 
-struct cpuidle_device_kobj;
 struct cpuidle_state_kobj;
 struct cpuidle_driver_kobj;
 
+struct cpuidle_device_kobj {
+	struct cpuidle_device *dev;
+	struct completion kobj_unregister;
+	struct kobject kobj;
+};
+
 struct cpuidle_device {
 	unsigned int		registered:1;
 	unsigned int		enabled:1;
@@ -73,7 +80,7 @@ struct cpuidle_device {
 	struct cpuidle_state_usage	states_usage[CPUIDLE_STATE_MAX];
 	struct cpuidle_state_kobj *kobjs[CPUIDLE_STATE_MAX];
 	struct cpuidle_driver_kobj *kobj_driver;
-	struct cpuidle_device_kobj *kobj_dev;
+	struct cpuidle_device_kobj kobj_dev;
 	struct list_head 	device_list;
 
 #ifdef CONFIG_ARCH_NEEDS_CPU_IDLE_COUPLED
-- 
1.7.12.rc2.18.g61b472e

