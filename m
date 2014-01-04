Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754886AbaADSHS (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Jan 2014 13:07:18 -0500
Received: from mx1.redhat.com ([209.132.183.28]:44272 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752977AbaADSHQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Jan 2014 13:07:16 -0500
Date: Sat, 4 Jan 2014 13:06:01 -0500 (EST)
From: Mikulas Patocka <mpatocka@redhat.com>
X-X-Sender: mpatocka@file01.intranet.prod.int.rdu2.redhat.com
To: Jeff Mahoney <jeffm@suse.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org
cc: linux-kernel@vger.kernel.org, dm-devel@redhat.com, tglx@linutronix.de,
        paulmck@linux.vnet.ibm.com, mingo@kernel.org
Subject: [PATCH] kobject: provide kobject_put_wait to fix module unload
 race
Message-ID: <alpine.LRH.2.02.1401021733250.27775@file01.intranet.prod.int.rdu2.redhat.com>
User-Agent: Alpine 2.02 (LRH 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

I noticed that Jeff Mahoney added a new structure kobj_completion, defined 
in include/linux/kobj_completion.h to the kernel 3.13-rc1 in the patch 
eee031649707db3c9920d9498f8d03819b74fc23. In the current upstream kernel, 
this interface is still unused.

However, converting the drivers to use kobj_completion is not trivial 
(note that all users of the original kobject interface are buggy - so all 
of them need to be converted).

I came up with a simpler patch to achieve the same purpose - this patch 
makes fixing the drivers easy - the driver is fixed just by replacing 
"kobject_put" with "kobject_put_wait" in the unload routine.

I'd like to ask if you could revert 
eee031649707db3c9920d9498f8d03819b74fc23 (no code uses it) and replace it 
with this patch.

See http://www.redhat.com/archives/dm-devel/2013-October/msg00141.html for 
the bug that this patch fixes.

Mikulas



From: Mikulas Patocka <mpatocka@redhat.com>

This patch introduces a new function kobject_put_wait. It decrements the
kobject reference count, waits until the count reaches zero. When this
function returns, it is guaranteed that the kobject was freed.

A rationale for this function:

The kobject is keeps a reference count. The driver unload routine
decrements the reference count, however, references to the kobject may
still be held by other kernel subsystems. The driver must not free the
memory that contains the kobject. Instead, the driver provides a "release"
method. The "release" method is called by the kernel when the last kobject
refernce is dropped. The "release" method should free the memory that
contains the kobject.

However, this pattern is buggy with respect to modules. The release method
is placed in the driver's module. When the driver exits, the module
reference count is zero, thus the module may be freed. However, there may
still be references to the kobject. If the module is unloaded and then the
release method is called, a crash happens.

Recently, CONFIG_DEBUG_KOBJECT_RELEASE was added. This option deliberately
provokes this race condition.

This patch fixes the bug by providing new function kobject_put_wait.
kobject_put_wait works like kobject_put, but it also waits until all other
references were dropped and until the kobject was freed. When
kobject_put_wait returns, it is guaranteed that the kobject was released
with the release method.

Thus, we can change kobject_put to kobject_put_wait in the unload routine 
of various drivers to fix the above race condition.

This patch fixes it for device mapper. Note that all kobject users in 
modules should be fixed to use this function.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Cc: stable@kernel.org

---
 drivers/md/dm-sysfs.c   |    2 +-
 include/linux/kobject.h |    3 +++
 lib/kobject.c           |   34 +++++++++++++++++++++++++++++-----
 3 files changed, 33 insertions(+), 6 deletions(-)

Index: linux-3.13-rc6/include/linux/kobject.h
===================================================================
--- linux-3.13-rc6.orig/include/linux/kobject.h	2014-01-02 23:13:24.000000000 +0100
+++ linux-3.13-rc6/include/linux/kobject.h	2014-01-02 23:14:02.000000000 +0100
@@ -27,6 +27,7 @@
 #include <linux/wait.h>
 #include <linux/atomic.h>
 #include <linux/workqueue.h>
+#include <linux/completion.h>
 
 #define UEVENT_HELPER_PATH_LEN		256
 #define UEVENT_NUM_ENVP			32	/* number of env pointers */
@@ -66,6 +67,7 @@ struct kobject {
 	struct kobj_type	*ktype;
 	struct sysfs_dirent	*sd;
 	struct kref		kref;
+	struct completion	*free_completion;
 #ifdef CONFIG_DEBUG_KOBJECT_RELEASE
 	struct delayed_work	release;
 #endif
@@ -106,6 +108,7 @@ extern int __must_check kobject_move(str
 
 extern struct kobject *kobject_get(struct kobject *kobj);
 extern void kobject_put(struct kobject *kobj);
+extern void kobject_put_wait(struct kobject *kobj);
 
 extern const void *kobject_namespace(struct kobject *kobj);
 extern char *kobject_get_path(struct kobject *kobj, gfp_t flag);
Index: linux-3.13-rc6/lib/kobject.c
===================================================================
--- linux-3.13-rc6.orig/lib/kobject.c	2014-01-02 23:13:23.000000000 +0100
+++ linux-3.13-rc6/lib/kobject.c	2014-01-02 23:17:01.000000000 +0100
@@ -172,6 +172,7 @@ static void kobject_init_internal(struct
 	if (!kobj)
 		return;
 	kref_init(&kobj->kref);
+	kobj->free_completion = NULL;
 	INIT_LIST_HEAD(&kobj->entry);
 	kobj->state_in_sysfs = 0;
 	kobj->state_add_uevent_sent = 0;
@@ -577,15 +578,11 @@ static void kobject_cleanup(struct kobje
 {
 	struct kobj_type *t = get_ktype(kobj);
 	const char *name = kobj->name;
+	struct completion *free_completion = kobj->free_completion;
 
 	pr_debug("kobject: '%s' (%p): %s, parent %p\n",
 		 kobject_name(kobj), kobj, __func__, kobj->parent);
 
-	if (t && !t->release)
-		pr_debug("kobject: '%s' (%p): does not have a release() "
-			 "function, it is broken and must be fixed.\n",
-			 kobject_name(kobj), kobj);
-
 	/* send "remove" if the caller did not do it but sent "add" */
 	if (kobj->state_add_uevent_sent && !kobj->state_remove_uevent_sent) {
 		pr_debug("kobject: '%s' (%p): auto cleanup 'remove' event\n",
@@ -611,6 +608,10 @@ static void kobject_cleanup(struct kobje
 		pr_debug("kobject: '%s': free name\n", name);
 		kfree(name);
 	}
+
+	/* if someone is waiting for the kobject to be freed, wake him up */
+	if (free_completion)
+		complete(free_completion);
 }
 
 #ifdef CONFIG_DEBUG_KOBJECT_RELEASE
@@ -651,6 +652,28 @@ void kobject_put(struct kobject *kobj)
 	}
 }
 
+/**
+ * kobject_put - decrement refcount for object and wait until it reaches zero.
+ * @kobj: object.
+ *
+ * Decrement the refcount, and wait until the refcount reaches zero and the
+ * kobject is freed.
+ *
+ * This function should be called from the driver unload routine. It must not
+ * be called concurrently on the same kobject. When this function returns, it
+ * is guaranteed that the kobject was freed.
+ */
+void kobject_put_wait(struct kobject *kobj)
+{
+	if (kobj) {
+		DECLARE_COMPLETION_ONSTACK(completion);
+		BUG_ON(kobj->free_completion);
+		kobj->free_completion = &completion;
+		kobject_put(kobj);
+		wait_for_completion(&completion);
+	}
+}
+
 static void dynamic_kobj_release(struct kobject *kobj)
 {
 	pr_debug("kobject: (%p): %s\n", kobj, __func__);
@@ -1076,6 +1099,7 @@ void kobj_ns_drop(enum kobj_ns_type type
 
 EXPORT_SYMBOL(kobject_get);
 EXPORT_SYMBOL(kobject_put);
+EXPORT_SYMBOL(kobject_put_wait);
 EXPORT_SYMBOL(kobject_del);
 
 EXPORT_SYMBOL(kset_register);
Index: linux-3.13-rc6/drivers/md/dm-sysfs.c
===================================================================
--- linux-3.13-rc6.orig/drivers/md/dm-sysfs.c	2014-01-02 23:13:24.000000000 +0100
+++ linux-3.13-rc6/drivers/md/dm-sysfs.c	2014-01-02 23:14:02.000000000 +0100
@@ -104,5 +104,5 @@ int dm_sysfs_init(struct mapped_device *
  */
 void dm_sysfs_exit(struct mapped_device *md)
 {
-	kobject_put(dm_kobject(md));
+	kobject_put_wait(dm_kobject(md));
 }
