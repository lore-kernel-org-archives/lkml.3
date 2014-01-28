Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755945AbaA1XWO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jan 2014 18:22:14 -0500
Received: from mail-qc0-f182.google.com ([209.85.216.182]:64506 "EHLO
	mail-qc0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755888AbaA1XWM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jan 2014 18:22:12 -0500
From: Tejun Heo <tj@kernel.org>
To: gregkh@linuxfoundation.org
Cc: linux-kernel@vger.kernel.org, schwidefsky@de.ibm.com,
        heiko.carstens@de.ibm.com, stern@rowland.harvard.edu,
        JBottomley@parallels.com, bhelgaas@google.com,
        Tejun Heo <tj@kernel.org>
Subject: [PATCH 11/11] sysfs, driver-core: remove unused {sysfs|device}_schedule_callback_owner()
Date: Tue, 28 Jan 2014 18:21:51 -0500
Message-Id: <1390951311-15325-12-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.8.5.3
In-Reply-To: <1390951311-15325-1-git-send-email-tj@kernel.org>
References: <1390951311-15325-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

All device_schedule_callback_owner() users are converted to use
device_remove_file_self().  Remove now unused
{sysfs|device}_schedule_callback_owner().

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 drivers/base/core.c    | 33 ------------------
 fs/sysfs/file.c        | 92 --------------------------------------------------
 include/linux/device.h | 11 +-----
 include/linux/sysfs.h  |  9 -----
 4 files changed, 1 insertion(+), 144 deletions(-)

diff --git a/drivers/base/core.c b/drivers/base/core.c
index 9db57af..4195364 100644
--- a/drivers/base/core.c
+++ b/drivers/base/core.c
@@ -615,39 +615,6 @@ void device_remove_bin_file(struct device *dev,
 }
 EXPORT_SYMBOL_GPL(device_remove_bin_file);
 
-/**
- * device_schedule_callback_owner - helper to schedule a callback for a device
- * @dev: device.
- * @func: callback function to invoke later.
- * @owner: module owning the callback routine
- *
- * Attribute methods must not unregister themselves or their parent device
- * (which would amount to the same thing).  Attempts to do so will deadlock,
- * since unregistration is mutually exclusive with driver callbacks.
- *
- * Instead methods can call this routine, which will attempt to allocate
- * and schedule a workqueue request to call back @func with @dev as its
- * argument in the workqueue's process context.  @dev will be pinned until
- * @func returns.
- *
- * This routine is usually called via the inline device_schedule_callback(),
- * which automatically sets @owner to THIS_MODULE.
- *
- * Returns 0 if the request was submitted, -ENOMEM if storage could not
- * be allocated, -ENODEV if a reference to @owner isn't available.
- *
- * NOTE: This routine won't work if CONFIG_SYSFS isn't set!  It uses an
- * underlying sysfs routine (since it is intended for use by attribute
- * methods), and if sysfs isn't available you'll get nothing but -ENOSYS.
- */
-int device_schedule_callback_owner(struct device *dev,
-		void (*func)(struct device *), struct module *owner)
-{
-	return sysfs_schedule_callback(&dev->kobj,
-			(void (*)(void *)) func, dev, owner);
-}
-EXPORT_SYMBOL_GPL(device_schedule_callback_owner);
-
 static void klist_children_get(struct klist_node *n)
 {
 	struct device_private *p = to_device_private_parent(n);
diff --git a/fs/sysfs/file.c b/fs/sysfs/file.c
index 1b8b91b..28cc1acd 100644
--- a/fs/sysfs/file.c
+++ b/fs/sysfs/file.c
@@ -453,95 +453,3 @@ void sysfs_remove_bin_file(struct kobject *kobj,
 	kernfs_remove_by_name(kobj->sd, attr->attr.name);
 }
 EXPORT_SYMBOL_GPL(sysfs_remove_bin_file);
-
-struct sysfs_schedule_callback_struct {
-	struct list_head	workq_list;
-	struct kobject		*kobj;
-	void			(*func)(void *);
-	void			*data;
-	struct module		*owner;
-	struct work_struct	work;
-};
-
-static struct workqueue_struct *sysfs_workqueue;
-static DEFINE_MUTEX(sysfs_workq_mutex);
-static LIST_HEAD(sysfs_workq);
-static void sysfs_schedule_callback_work(struct work_struct *work)
-{
-	struct sysfs_schedule_callback_struct *ss = container_of(work,
-			struct sysfs_schedule_callback_struct, work);
-
-	(ss->func)(ss->data);
-	kobject_put(ss->kobj);
-	module_put(ss->owner);
-	mutex_lock(&sysfs_workq_mutex);
-	list_del(&ss->workq_list);
-	mutex_unlock(&sysfs_workq_mutex);
-	kfree(ss);
-}
-
-/**
- * sysfs_schedule_callback - helper to schedule a callback for a kobject
- * @kobj: object we're acting for.
- * @func: callback function to invoke later.
- * @data: argument to pass to @func.
- * @owner: module owning the callback code
- *
- * sysfs attribute methods must not unregister themselves or their parent
- * kobject (which would amount to the same thing).  Attempts to do so will
- * deadlock, since unregistration is mutually exclusive with driver
- * callbacks.
- *
- * Instead methods can call this routine, which will attempt to allocate
- * and schedule a workqueue request to call back @func with @data as its
- * argument in the workqueue's process context.  @kobj will be pinned
- * until @func returns.
- *
- * Returns 0 if the request was submitted, -ENOMEM if storage could not
- * be allocated, -ENODEV if a reference to @owner isn't available,
- * -EAGAIN if a callback has already been scheduled for @kobj.
- */
-int sysfs_schedule_callback(struct kobject *kobj, void (*func)(void *),
-		void *data, struct module *owner)
-{
-	struct sysfs_schedule_callback_struct *ss, *tmp;
-
-	if (!try_module_get(owner))
-		return -ENODEV;
-
-	mutex_lock(&sysfs_workq_mutex);
-	list_for_each_entry_safe(ss, tmp, &sysfs_workq, workq_list)
-		if (ss->kobj == kobj) {
-			module_put(owner);
-			mutex_unlock(&sysfs_workq_mutex);
-			return -EAGAIN;
-		}
-	mutex_unlock(&sysfs_workq_mutex);
-
-	if (sysfs_workqueue == NULL) {
-		sysfs_workqueue = create_singlethread_workqueue("sysfsd");
-		if (sysfs_workqueue == NULL) {
-			module_put(owner);
-			return -ENOMEM;
-		}
-	}
-
-	ss = kmalloc(sizeof(*ss), GFP_KERNEL);
-	if (!ss) {
-		module_put(owner);
-		return -ENOMEM;
-	}
-	kobject_get(kobj);
-	ss->kobj = kobj;
-	ss->func = func;
-	ss->data = data;
-	ss->owner = owner;
-	INIT_WORK(&ss->work, sysfs_schedule_callback_work);
-	INIT_LIST_HEAD(&ss->workq_list);
-	mutex_lock(&sysfs_workq_mutex);
-	list_add_tail(&ss->workq_list, &sysfs_workq);
-	mutex_unlock(&sysfs_workq_mutex);
-	queue_work(sysfs_workqueue, &ss->work);
-	return 0;
-}
-EXPORT_SYMBOL_GPL(sysfs_schedule_callback);
diff --git a/include/linux/device.h b/include/linux/device.h
index 1ff3f16..fb1ba13 100644
--- a/include/linux/device.h
+++ b/include/linux/device.h
@@ -566,12 +566,6 @@ extern int __must_check device_create_bin_file(struct device *dev,
 					const struct bin_attribute *attr);
 extern void device_remove_bin_file(struct device *dev,
 				   const struct bin_attribute *attr);
-extern int device_schedule_callback_owner(struct device *dev,
-		void (*func)(struct device *dev), struct module *owner);
-
-/* This is a macro to avoid include problems with THIS_MODULE */
-#define device_schedule_callback(dev, func)			\
-	device_schedule_callback_owner(dev, func, THIS_MODULE)
 
 /* device resource management */
 typedef void (*dr_release_t)(struct device *dev, void *res);
@@ -931,10 +925,7 @@ extern int device_online(struct device *dev);
 extern struct device *__root_device_register(const char *name,
 					     struct module *owner);
 
-/*
- * This is a macro to avoid include problems with THIS_MODULE,
- * just as per what is done for device_schedule_callback() above.
- */
+/* This is a macro to avoid include problems with THIS_MODULE */
 #define root_device_register(name) \
 	__root_device_register(name, THIS_MODULE)
 
diff --git a/include/linux/sysfs.h b/include/linux/sysfs.h
index bd96c60..14df054 100644
--- a/include/linux/sysfs.h
+++ b/include/linux/sysfs.h
@@ -178,9 +178,6 @@ struct sysfs_ops {
 
 #ifdef CONFIG_SYSFS
 
-int sysfs_schedule_callback(struct kobject *kobj, void (*func)(void *),
-			    void *data, struct module *owner);
-
 int __must_check sysfs_create_dir_ns(struct kobject *kobj, const void *ns);
 void sysfs_remove_dir(struct kobject *kobj);
 int __must_check sysfs_rename_dir_ns(struct kobject *kobj, const char *new_name,
@@ -249,12 +246,6 @@ int __must_check sysfs_init(void);
 
 #else /* CONFIG_SYSFS */
 
-static inline int sysfs_schedule_callback(struct kobject *kobj,
-		void (*func)(void *), void *data, struct module *owner)
-{
-	return -ENOSYS;
-}
-
 static inline int sysfs_create_dir_ns(struct kobject *kobj, const void *ns)
 {
 	return 0;
-- 
1.8.5.3

