Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754432Ab3KCTdM (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Nov 2013 14:33:12 -0500
Received: from www.linutronix.de ([62.245.132.108]:51214 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754095Ab3KCTdL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Nov 2013 14:33:11 -0500
Date: Sun, 3 Nov 2013 20:33:08 +0100
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: linux-kernel@vger.kernel.org, jic23@kernel.org, lars@metafoo.de,
        gregkh@linuxfoundation.org
Subject: [PATCH v2] debugobject: add support for kref
Message-ID: <20131103193308.GA20998@linutronix.de>
References: <1382609345-29370-1-git-send-email-bigeasy@linutronix.de>
 <alpine.DEB.2.02.1310241615280.14242@ionos.tec.linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
In-Reply-To: <alpine.DEB.2.02.1310241615280.14242@ionos.tec.linutronix.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I run a couple times into the case where "put" was called on an already
cleanup object. The results was either nothing because "0" went back to
0xff…ff and release was not called a second time or some thing like this
with SLAB once that memory region was used again:

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
The reason for this was resource counting that went wrong followed by a "put"
called from two places.
After the second time running into the same problem using the same driver,
I was looking for something to help me to find atleast one caller (and the
kind of object) a little quicker. Here is a debugobject extension to kref which
seems to do the job.
At kref_init() the debugobject is initialized and activated.
At kref_get() / kref_sub() time it is checked if the kref is active. If
it is, the request is completed otherwise the "usual" debugobject is
printed. Here an example of kref_put() on an already gone object:

|edma-dma-engine edma-dma-engine.0: freeing channel for 57
|------------[ cut here ]------------
|WARNING: CPU: 0 PID: 2053 at lib/debugobjects.c:260 debug_print_object+0x94/0xc4()
|ODEBUG: active_state not available (active state 0) object type: kref hint:   (null)
|Modules linked in: ti_am335x_adc(-)
|[<c0014d38>] (unwind_backtrace+0x0/0xf4) from [<c001249c>] (show_stack+0x14/0x1c)
|[<c001249c>] (show_stack+0x14/0x1c) from [<c0037264>] (warn_slowpath_common+0x64/0x84)
|[<c0037264>] (warn_slowpath_common+0x64/0x84) from [<c0037318>] (warn_slowpath_fmt+0x30/0x40)
|[<c0037318>] (warn_slowpath_fmt+0x30/0x40) from [<c022e8d0>] (debug_print_object+0x94/0xc4)
|[<c022e8d0>] (debug_print_object+0x94/0xc4) from [<c022e9e4>] (debug_object_active_state+0xe4/0x148)
|[<c022e9e4>] (debug_object_active_state+0xe4/0x148) from [<bf0a3474>] (iio_buffer_put+0x24/0x70 [industrialio])
|[<bf0a3474>] (iio_buffer_put+0x24/0x70 [industrialio]) from [<bf0a0340>] (iio_dev_release+0x44/0x64 [industrialio])
|[<bf0a0340>] (iio_dev_release+0x44/0x64 [industrialio]) from [<c0290308>] (device_release+0x2c/0x94)
|[<c0290308>] (device_release+0x2c/0x94) from [<c021f040>] (kobject_release+0x44/0x78)
|[<c021f040>] (kobject_release+0x44/0x78) from [<c029600c>] (release_nodes+0x1a0/0x248)
|[<c029600c>] (release_nodes+0x1a0/0x248) from [<c029355c>] (__device_release_driver+0x98/0xf0)
|[<c029355c>] (__device_release_driver+0x98/0xf0) from [<c0293668>] (driver_detach+0xb4/0xb8)
|[<c0293668>] (driver_detach+0xb4/0xb8) from [<c0292538>] (bus_remove_driver+0x98/0xec)
|[<c0292538>] (bus_remove_driver+0x98/0xec) from [<c008fe2c>] (SyS_delete_module+0x1e0/0x24c)
|[<c008fe2c>] (SyS_delete_module+0x1e0/0x24c) from [<c000e680>] (ret_fast_syscall+0x0/0x48)
|---[ end trace bc5e9551626b178a ]---

This should help to notice that there is a second "put" and the
call chain should point to the object. The "hint" callback is empty because
in the "double free" case we don't have any information and the release
function is passed as an argument to kref_put(). I think the information
is quite good and it is not worth extending debugobject to somehow add
this information.
The "get/put unless" macros aren't traced completely because it is hard
to get it correct without a false positive and without touching each
user. The object might be added to a list which is browsed by someone.
That someone holds the same lock that is required for in the cleanup path
and so the cleanup is blocked. That means that the kref object is
gone from debugobject point of view but the release function has not yet
complete so it is valid to check the current counter.

v1…v2:
- not an RFC anymore
- addressed tglx review:
  - use debug_obj_descr with state active
  - use debug_object_active_state() to check for active object instead the
    other hack I had.
  - added debug_object_free() in a way that does not interfere with the
    NSA sniffer API so it does not get removed from the patch by accident.

Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
---

 include/linux/debugobjects.h |  2 +-
 include/linux/kref.h         | 60 ++++++++++++++++++++++++++++++++++++++++++++
 lib/Kconfig.debug            |  7 ++++++
 lib/debugobjects.c           | 27 +++++++++++++++++---
 4 files changed, 91 insertions(+), 5 deletions(-)

diff --git a/include/linux/debugobjects.h b/include/linux/debugobjects.h
index 98ffcbd..483f487 100644
--- a/include/linux/debugobjects.h
+++ b/include/linux/debugobjects.h
@@ -74,7 +74,7 @@ extern void debug_object_assert_init(void *addr, struct debug_obj_descr *descr);
  * - Set at 0 upon initialization.
  * - Must return to 0 before deactivation.
  */
-extern void
+extern int
 debug_object_active_state(void *addr, struct debug_obj_descr *descr,
 			  unsigned int expect, unsigned int next);
 
diff --git a/include/linux/kref.h b/include/linux/kref.h
index 484604d..f019873 100644
--- a/include/linux/kref.h
+++ b/include/linux/kref.h
@@ -20,11 +20,40 @@
 #include <linux/kernel.h>
 #include <linux/mutex.h>
 #include <linux/spinlock.h>
+#include <linux/debugobjects.h>
 
 struct kref {
 	atomic_t refcount;
 };
 
+#ifdef CONFIG_DEBUG_OBJECTS_KREF
+extern struct debug_obj_descr kref_descr;
+
+static inline int kref_check_active(struct kref *kref)
+{
+	return debug_object_active_state(kref, &kref_descr, 0, 0);
+}
+
+static inline void kref_init_activate(struct kref *kref)
+{
+	debug_object_init(kref, &kref_descr);
+	debug_object_activate(kref, &kref_descr);
+}
+
+static inline void kref_deactivate_free(struct kref *kref)
+{
+	debug_object_deactivate(kref, &kref_descr);
+	debug_object_free(kref, &kref_descr);
+}
+
+#else
+
+static inline int kref_check_active(struct kref *kref) { return 0; }
+static inline void kref_init_activate(struct kref *kref) { }
+static inline void kref_deactivate_free(struct kref *kref) { }
+
+#endif
+
 /**
  * kref_init - initialize object.
  * @kref: object in question.
@@ -32,6 +61,7 @@ struct kref {
 static inline void kref_init(struct kref *kref)
 {
 	atomic_set(&kref->refcount, 1);
+	kref_init_activate(kref);
 }
 
 /**
@@ -40,6 +70,12 @@ static inline void kref_init(struct kref *kref)
  */
 static inline void kref_get(struct kref *kref)
 {
+	int ret;
+
+	ret = kref_check_active(kref);
+	if (ret < 0)
+		return;
+
 	/* If refcount was 0 before incrementing then we have a race
 	 * condition when this kref is freeing by some other thread right now.
 	 * In this case one should use kref_get_unless_zero()
@@ -68,9 +104,16 @@ static inline void kref_get(struct kref *kref)
 static inline int kref_sub(struct kref *kref, unsigned int count,
 	     void (*release)(struct kref *kref))
 {
+	int ret;
+
+	ret = kref_check_active(kref);
+	if (ret < 0)
+		return 0;
+
 	WARN_ON(release == NULL);
 
 	if (atomic_sub_and_test((int) count, &kref->refcount)) {
+		kref_deactivate_free(kref);
 		release(kref);
 		return 1;
 	}
@@ -117,16 +160,23 @@ static inline int kref_put_spinlock_irqsave(struct kref *kref,
 		spinlock_t *lock)
 {
 	unsigned long flags;
+	int ret;
 
 	WARN_ON(release == NULL);
+
 	if (atomic_add_unless(&kref->refcount, -1, 1))
 		return 0;
 	spin_lock_irqsave(lock, flags);
+	ret = kref_check_active(kref);
+	if (ret < 0)
+		goto out;
 	if (atomic_dec_and_test(&kref->refcount)) {
+		kref_deactivate_free(kref);
 		release(kref);
 		local_irq_restore(flags);
 		return 1;
 	}
+out:
 	spin_unlock_irqrestore(lock, flags);
 	return 0;
 }
@@ -135,13 +185,23 @@ static inline int kref_put_mutex(struct kref *kref,
 				 void (*release)(struct kref *kref),
 				 struct mutex *lock)
 {
+	int ret;
+
 	WARN_ON(release == NULL);
 	if (unlikely(!atomic_add_unless(&kref->refcount, -1, 1))) {
 		mutex_lock(lock);
+
+		ret = kref_check_active(kref);
+		if (ret < 0) {
+			mutex_unlock(lock);
+			return 0;
+		}
+
 		if (unlikely(!atomic_dec_and_test(&kref->refcount))) {
 			mutex_unlock(lock);
 			return 0;
 		}
+		kref_deactivate_free(kref);
 		release(kref);
 		return 1;
 	}
diff --git a/lib/Kconfig.debug b/lib/Kconfig.debug
index 06344d9..ed706b8 100644
--- a/lib/Kconfig.debug
+++ b/lib/Kconfig.debug
@@ -375,6 +375,13 @@ config DEBUG_OBJECTS_PERCPU_COUNTER
 	  percpu counter routines to track the life time of percpu counter
 	  objects and validate the percpu counter operations.
 
+config DEBUG_OBJECTS_KREF
+	bool "Debug kref objects"
+	depends on DEBUG_OBJECTS
+	help
+	  If you say Y here, additional code will be insterted into the kref
+	  routines to track the life time of a kref object.
+
 config DEBUG_OBJECTS_ENABLE_DEFAULT
 	int "debug_objects bootup default value (0-1)"
         range 0 1
diff --git a/lib/debugobjects.c b/lib/debugobjects.c
index bf2c8b1..b735c29 100644
--- a/lib/debugobjects.c
+++ b/lib/debugobjects.c
@@ -362,6 +362,7 @@ void debug_object_init(void *addr, struct debug_obj_descr *descr)
 
 	__debug_object_init(addr, descr, 0);
 }
+EXPORT_SYMBOL_GPL(debug_object_init);
 
 /**
  * debug_object_init_on_stack - debug checks when an object on stack is
@@ -442,6 +443,7 @@ int debug_object_activate(void *addr, struct debug_obj_descr *descr)
 	}
 	return 0;
 }
+EXPORT_SYMBOL_GPL(debug_object_activate);
 
 /**
  * debug_object_deactivate - debug checks when an object is deactivated
@@ -489,6 +491,7 @@ void debug_object_deactivate(void *addr, struct debug_obj_descr *descr)
 
 	raw_spin_unlock_irqrestore(&db->lock, flags);
 }
+EXPORT_SYMBOL_GPL(debug_object_deactivate);
 
 /**
  * debug_object_destroy - debug checks when an object is destroyed
@@ -575,6 +578,7 @@ void debug_object_free(void *addr, struct debug_obj_descr *descr)
 out_unlock:
 	raw_spin_unlock_irqrestore(&db->lock, flags);
 }
+EXPORT_SYMBOL_GPL(debug_object_free);
 
 /**
  * debug_object_assert_init - debug checks when object should be init-ed
@@ -621,16 +625,17 @@ void debug_object_assert_init(void *addr, struct debug_obj_descr *descr)
  * @expect:	expected state
  * @next:	state to move to if expected state is found
  */
-void
+int
 debug_object_active_state(void *addr, struct debug_obj_descr *descr,
 			  unsigned int expect, unsigned int next)
 {
 	struct debug_bucket *db;
 	struct debug_obj *obj;
 	unsigned long flags;
+	int ret;
 
 	if (!debug_objects_enabled)
-		return;
+		return 0;
 
 	db = get_bucket((unsigned long) addr);
 
@@ -640,14 +645,18 @@ debug_object_active_state(void *addr, struct debug_obj_descr *descr,
 	if (obj) {
 		switch (obj->state) {
 		case ODEBUG_STATE_ACTIVE:
-			if (obj->astate == expect)
+			if (obj->astate == expect) {
 				obj->astate = next;
-			else
+				ret = 0;
+			} else {
 				debug_print_object(obj, "active_state");
+				ret = -EINVAL;
+			}
 			break;
 
 		default:
 			debug_print_object(obj, "active_state");
+			ret = -EINVAL;
 			break;
 		}
 	} else {
@@ -656,10 +665,13 @@ debug_object_active_state(void *addr, struct debug_obj_descr *descr,
 				       .descr = descr };
 
 		debug_print_object(&o, "active_state");
+		ret = -EINVAL;
 	}
 
 	raw_spin_unlock_irqrestore(&db->lock, flags);
+	return ret;
 }
+EXPORT_SYMBOL_GPL(debug_object_active_state);
 
 #ifdef CONFIG_DEBUG_OBJECTS_FREE
 static void __debug_check_no_obj_freed(const void *address, unsigned long size)
@@ -1094,3 +1106,10 @@ void __init debug_objects_mem_init(void)
 	} else
 		debug_objects_selftest();
 }
+
+#ifdef CONFIG_DEBUG_OBJECTS_KREF
+struct debug_obj_descr kref_descr = {
+	.name = "kref",
+};
+EXPORT_SYMBOL_GPL(kref_descr);
+#endif
-- 
1.8.1.4

