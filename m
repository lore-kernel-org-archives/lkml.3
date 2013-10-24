Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754561Ab3JXKJR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Oct 2013 06:09:17 -0400
Received: from www.linutronix.de ([62.245.132.108]:35035 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754124Ab3JXKJP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Oct 2013 06:09:15 -0400
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: linux-kernel@vger.kernel.org, jic23@kernel.org, lars@metafoo.de,
        gregkh@linuxfoundation.org,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Subject: [RFC PATCH] debugobject: add support for kref
Date: Thu, 24 Oct 2013 12:09:05 +0200
Message-Id: <1382609345-29370-1-git-send-email-bigeasy@linutronix.de>
X-Mailer: git-send-email 1.8.4.rc3
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001,URIBL_BLOCKED=0.001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I run a couple times into the case where "put" was caled on an already
cleanup object. The results was either nothing because "0" went back to
0xff…ff and release was not called a second time or some thing like this
with SLAB:

|edma-dma-engine edma-dma-engine.0: freeing channel for 57
|Slab corruption (Not tainted): kmalloc-256 start=edc4c8c0, len=256
|070: 6b 6b 6b 6b 6a 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkjkkkkkkkkkkk
|Single bit error detected. Probably bad RAM.
|Run a memory test tool.
|Prev obj: start=edc4c7c0, len=256
|000: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
|010: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
|Next obj: start=edc4c9c0, len=256
|000: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
|010: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk

which got me a little confused about the bit flip at first.
The reason for this was ressource counting that went wrong and a cleanup from
two places.
After the second time running into the same problem using on the same driver,
I was looking for something to help me to find the caller of it a little
quicker. Here is a debugobject extension to kref which seems to do the job.
At kref_init() the debugobject is initialized. There is no active state atm.
At kref_sub() time I check if the kref is still tracked by debugobject and if
it is everything continues as usual. Since we do not have any "static" objects
we do not have any no unknown objects. So each "unknown" object is one that is
accessed after its cleanup and this will trigger now:

|edma-dma-engine edma-dma-engine.0: freeing channel for 57
|------------[ cut here ]------------
|WARNING: CPU: 0 PID: 2095 at include/linux/kref.h:83 iio_buffer_put+0x84/0xa4 [industrialio]()
|kref_put: unknown reference ec925134, cleanup iio_buffer_release+0x0/0x24 [industrialio]
|Modules linked in: ti_am335x_adc(-)
|CPU: 0 PID: 2095 Comm: rmmod Not tainted 3.12.0-rc6+ #414
|[<c0014d38>] (unwind_backtrace+0x0/0xf4) from [<c001249c>] (show_stack+0x14/0x1c)
|[<c001249c>] (show_stack+0x14/0x1c) from [<c0037244>] (warn_slowpath_common+0x64/0x84)
|[<c0037244>] (warn_slowpath_common+0x64/0x84) from [<c00372f8>] (warn_slowpath_fmt+0x30/0x40)
|[<c00372f8>] (warn_slowpath_fmt+0x30/0x40) from [<bf0d74b4>] (iio_buffer_put+0x84/0xa4 [industrialio])
|[<bf0d74b4>] (iio_buffer_put+0x84/0xa4 [industrialio]) from [<bf0d4340>] (iio_dev_release+0x44/0x64 [industrialio])
|[<bf0d4340>] (iio_dev_release+0x44/0x64 [industrialio]) from [<c028ffb0>] (device_release+0x2c/0x94)
|[<c028ffb0>] (device_release+0x2c/0x94) from [<c021ee60>] (kobject_release+0x44/0x78)
|[<c021ee60>] (kobject_release+0x44/0x78) from [<c0295cb4>] (release_nodes+0x1a0/0x248)
|[<c0295cb4>] (release_nodes+0x1a0/0x248) from [<c0293204>] (__device_release_driver+0x98/0xf0)
|[<c0293204>] (__device_release_driver+0x98/0xf0) from [<c0293310>] (driver_detach+0xb4/0xb8)
|[<c0293310>] (driver_detach+0xb4/0xb8) from [<c02921e0>] (bus_remove_driver+0x98/0xec)
|[<c02921e0>] (bus_remove_driver+0x98/0xec) from [<c008fe1c>] (SyS_delete_module+0x1e0/0x24c)
|[<c008fe1c>] (SyS_delete_module+0x1e0/0x24c) from [<c000e680>] (ret_fast_syscall+0x0/0x48)
|---[ end trace 34ae5f26b0a9d556 ]---

which ease the search for double cleanup.

Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
---
 include/linux/debugobjects.h |  4 ++++
 include/linux/kref.h         | 10 ++++++++++
 lib/Kconfig.debug            |  8 ++++++++
 lib/debugobjects.c           | 42 ++++++++++++++++++++++++++++++++++++++++++
 4 files changed, 64 insertions(+)

diff --git a/include/linux/debugobjects.h b/include/linux/debugobjects.h
index 98ffcbd..a71bb24 100644
--- a/include/linux/debugobjects.h
+++ b/include/linux/debugobjects.h
@@ -68,6 +68,8 @@ extern void debug_object_deactivate(void *addr, struct debug_obj_descr *descr);
 extern void debug_object_destroy   (void *addr, struct debug_obj_descr *descr);
 extern void debug_object_free      (void *addr, struct debug_obj_descr *descr);
 extern void debug_object_assert_init(void *addr, struct debug_obj_descr *descr);
+extern bool debug_object_is_tracked(void *addr);
+extern void debugobj_kref_splat(void *addr, void *func);
 
 /*
  * Active state:
@@ -95,6 +97,8 @@ static inline void
 debug_object_free      (void *addr, struct debug_obj_descr *descr) { }
 static inline void
 debug_object_assert_init(void *addr, struct debug_obj_descr *descr) { }
+static inline bool debug_object_is_tracked(void *addr) { return true };
+static inline void debugobj_kref_splat(void *addr, void *func) {};
 
 static inline void debug_objects_early_init(void) { }
 static inline void debug_objects_mem_init(void) { }
diff --git a/include/linux/kref.h b/include/linux/kref.h
index 484604d..3a878a1 100644
--- a/include/linux/kref.h
+++ b/include/linux/kref.h
@@ -20,6 +20,7 @@
 #include <linux/kernel.h>
 #include <linux/mutex.h>
 #include <linux/spinlock.h>
+#include <linux/debugobjects.h>
 
 struct kref {
 	atomic_t refcount;
@@ -32,6 +33,9 @@ struct kref {
 static inline void kref_init(struct kref *kref)
 {
 	atomic_set(&kref->refcount, 1);
+#ifdef CONFIG_DEBUG_OBJECTS_KREF
+	debug_object_init(kref, NULL);
+#endif
 }
 
 /**
@@ -70,6 +74,12 @@ static inline int kref_sub(struct kref *kref, unsigned int count,
 {
 	WARN_ON(release == NULL);
 
+#ifdef CONFIG_DEBUG_OBJECTS_KREF
+	if (!debug_object_is_tracked(kref)) {
+		debugobj_kref_splat(kref, release);
+		return 0;
+	}
+#endif
 	if (atomic_sub_and_test((int) count, &kref->refcount)) {
 		release(kref);
 		return 1;
diff --git a/lib/Kconfig.debug b/lib/Kconfig.debug
index 06344d9..aa59596 100644
--- a/lib/Kconfig.debug
+++ b/lib/Kconfig.debug
@@ -375,6 +375,14 @@ config DEBUG_OBJECTS_PERCPU_COUNTER
 	  percpu counter routines to track the life time of percpu counter
 	  objects and validate the percpu counter operations.
 
+config DEBUG_OBJECTS_KREF
+	bool "Debug kref objects"
+	depends on DEBUG_OBJECTS
+	help
+	  If you say Y here, additional code will be insterted into the
+          kref_init() and kref_put() routines to track the lifetime of a kref
+	  object and ensure that an object is not released twice.
+
 config DEBUG_OBJECTS_ENABLE_DEFAULT
 	int "debug_objects bootup default value (0-1)"
         range 0 1
diff --git a/lib/debugobjects.c b/lib/debugobjects.c
index bf2c8b1..3488972 100644
--- a/lib/debugobjects.c
+++ b/lib/debugobjects.c
@@ -262,6 +262,21 @@ static void debug_print_object(struct debug_obj *obj, char *msg)
 	debug_objects_warnings++;
 }
 
+#ifdef CONFIG_DEBUG_OBJECTS_KREF
+void debugobj_kref_splat(void *addr, void *func)
+{
+	static int limit;
+
+	if (limit < 5) {
+		WARN(1, "kref_put: unknown reference %p, cleanup %pS\n",
+				addr, func);
+		limit++;
+	}
+	debug_objects_warnings++;
+}
+EXPORT_SYMBOL_GPL(debugobj_kref_splat);
+#endif
+
 /*
  * Try to repair the damage, so we have a better chance to get useful
  * debug output.
@@ -362,6 +377,7 @@ void debug_object_init(void *addr, struct debug_obj_descr *descr)
 
 	__debug_object_init(addr, descr, 0);
 }
+EXPORT_SYMBOL_GPL(debug_object_init);
 
 /**
  * debug_object_init_on_stack - debug checks when an object on stack is
@@ -575,6 +591,7 @@ void debug_object_free(void *addr, struct debug_obj_descr *descr)
 out_unlock:
 	raw_spin_unlock_irqrestore(&db->lock, flags);
 }
+EXPORT_SYMBOL_GPL(debug_object_free);
 
 /**
  * debug_object_assert_init - debug checks when object should be init-ed
@@ -614,6 +631,31 @@ void debug_object_assert_init(void *addr, struct debug_obj_descr *descr)
 	raw_spin_unlock_irqrestore(&db->lock, flags);
 }
 
+bool debug_object_is_tracked(void *addr)
+{
+	struct debug_bucket *db;
+	struct debug_obj *obj;
+	unsigned long flags;
+	bool ret;
+
+	if (!debug_objects_enabled)
+		return true;
+
+	db = get_bucket((unsigned long) addr);
+
+	raw_spin_lock_irqsave(&db->lock, flags);
+
+	obj = lookup_object(addr, db);
+	if (obj)
+		ret = true;
+	else
+		ret = false;
+
+	raw_spin_unlock_irqrestore(&db->lock, flags);
+	return ret;
+}
+EXPORT_SYMBOL_GPL(debug_object_is_tracked);
+
 /**
  * debug_object_active_state - debug checks object usage state machine
  * @addr:	address of the object
-- 
1.8.4.rc3

