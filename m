Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753101Ab3DLWc3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Apr 2013 18:32:29 -0400
Received: from mail-yh0-f74.google.com ([209.85.213.74]:50175 "EHLO
	mail-yh0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750875Ab3DLWc2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Apr 2013 18:32:28 -0400
From: Anatol Pomozov <anatol.pomozov@gmail.com>
To: linux-kernel@vger.kernel.org, gregkh@linuxfoundation.org
Cc: torvalds@linux-foundation.org, sqazi@google.com, rusty@rustcorp.com.au,
        Anatol Pomozov <anatol.pomozov@gmail.com>
Subject: [PATCH] module: Fix race condition between load and unload module
Date: Fri, 12 Apr 2013 15:32:18 -0700
Message-Id: <1365805938-22826-1-git-send-email-anatol.pomozov@gmail.com>
X-Mailer: git-send-email 1.8.1.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Here is a test case

  while true; do losetup /dev/loop0 ./loop.file; losetup -d /dev/loop0; done &
  while true; do rmmod loop; done &

that produces following oops:

[  181.486775] loop: module is already loaded
[  181.490901] BUG: unable to handle kernel paging request at ffffffffa18a600c
[  181.497891] IP: [<ffffffff81310351>] kobject_put+0x11/0x60
[  181.503391] PGD 1a0c067 PUD 1a0d063 PMD 2693af067 PTE 0
[  181.508673] Oops: 0000 [#1] SMP DEBUG_PAGEALLOC
[  181.513245] Modules linked in: loop(+) sata_mv acpi_cpufreq mperf freq_table processor msr cpuid genrtc bnx2x libcrc32c mdio ipv6 [last unloaded: loop]
[  181.527016] CPU 19
[  181.528945] Pid: 19213, comm: modprobe Tainted: G        W    3.9.0-dbg-DEV #8
[  181.538432] RIP: 0010:[<ffffffff81310351>]  [<ffffffff81310351>] kobject_put+0x11/0x60
[  181.546359] RSP: 0018:ffff88065c2e1de8  EFLAGS: 00010282
[  181.551667] RAX: 000000000000001e RBX: ffffffffa18a5fd0 RCX: ffff88087bc4ecc8
[  181.558811] RDX: 0000000000000000 RSI: ffff88087bc4d078 RDI: ffffffffa18a5fd0
[  181.565935] RBP: ffff88065c2e1df8 R08: 0000000000000002 R09: 0000000000000000
[  181.573064] R10: 0000000000000766 R11: 0000000000000000 R12: ffffffffa18aef80
[  181.580193] R13: ffff88065c2e1ee8 R14: ffffffffffffffea R15: ffffffffa18a5fd0
[  181.587327] FS:  00007f871df56700(0000) GS:ffff88087bc40000(0063) knlGS:00000000f76816b0
[  181.595407] CS:  0010 DS: 002b ES: 002b CR0: 000000008005003b
[  181.601156] CR2: ffffffffa18a600c CR3: 0000000867923000 CR4: 00000000000007e0
[  181.608288] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[  181.615416] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[  181.622545] Process modprobe (pid: 19213, threadinfo ffff88065c2e0000, task ffff88065c20e180)
[  181.631065] Stack:
[  181.633075]  0000000000000002 ffffffffa18aef98 ffff88065c2e1ed8 ffffffff810e691c
[  181.640517]  ffffffff8132ba60 ffffffff8131b42e 0000000000000000 57ff842b5f752e80
[  181.647958]  a80065d4ba000000 7400000000000000 ffffffffa18aef98 ffffffffa18af1e0
[  181.655411] Call Trace:
[  181.657859]  [<ffffffff810e691c>] load_module+0xf4c/0x15b0
[  181.663338]  [<ffffffff8132ba60>] ? ddebug_proc_write+0x110/0x110
[  181.669428]  [<ffffffff8131b42e>] ? trace_hardirqs_on_thunk+0x3a/0x3f
[  181.675864]  [<ffffffff810e7077>] sys_init_module+0xf7/0x140
[  181.681520]  [<ffffffff815e6515>] cstar_dispatch+0x7/0x1f
[  181.686912] Code: c7 c7 a0 8d ac 81 31 c0 e8 ed

This is a race codition that exists between kset_find_obj() and kobject_put().
kset_find_obj() might return kobject that has refcount equal
to 0 if this kobject is freing by kobject_put() in other thread.

Here is timeline for the crash in case if kset_find_obj() searches for
an object tht nobody holds and other thread is doing kobject_put()
on the same kobject:

THREAD A (calls kset_find_obj())     THREAD B (calls kobject_put())
splin_lock()
                                     atomic_dec_return(kobj->kref), counter gets zero here
                                     ... starts kobject cleanup ....
                                     spin_lock() // WAIT thread A in kobj_kset_leave()
iterate over kset->list
atomic_inc(kobj->kref) (counter becomes 1)
spin_unlock()
                                     spin_lock() // taken
                                     // it does not know that thread A increased counter so it
                                     remove obj from list
                                     spin_unlock()
                                     vfree(module) // frees module object with containing kobj

// kobj points to freed memory area!!
koubject_put(kobj) // OOPS!!!!

Crash above happens because module.c tries to use kset_find_obj() when somebody
unloads module. The module.c code was introduced in 6494a93d55fad5862. In fact
we do not need kobj in module.c, all we need is to check whether name exists in
kset. For this introduce function that is thread-safe with kobject_put() path.

Add documentation that kset_find_obj() is not thread-safe with kobject_put() if
no external refcounts are held.

Other kset_find_obj() callers should be checked and made sure they do not race
with kobject_put().

Signed-off-by: Anatol Pomozov <anatol.pomozov@gmail.com>
---
 include/linux/kobject.h |  1 +
 include/linux/kref.h    |  8 +++++---
 kernel/module.c         |  5 +----
 lib/kobject.c           | 48 +++++++++++++++++++++++++++++++++++++++++++++++-
 4 files changed, 54 insertions(+), 8 deletions(-)

diff --git a/include/linux/kobject.h b/include/linux/kobject.h
index 939b112..ac6afe6 100644
--- a/include/linux/kobject.h
+++ b/include/linux/kobject.h
@@ -191,6 +191,7 @@ static inline struct kobj_type *get_ktype(struct kobject *kobj)
 }
 
 extern struct kobject *kset_find_obj(struct kset *, const char *);
+extern bool kset_check_name_exists(struct kset *kset, const char *name);
 
 /* The global /sys/kernel/ kobject for people to chain off of */
 extern struct kobject *kernel_kobj;
diff --git a/include/linux/kref.h b/include/linux/kref.h
index 4972e6e..dbb6e01 100644
--- a/include/linux/kref.h
+++ b/include/linux/kref.h
@@ -39,8 +39,10 @@ static inline void kref_init(struct kref *kref)
  */
 static inline void kref_get(struct kref *kref)
 {
-	WARN_ON(!atomic_read(&kref->refcount));
-	atomic_inc(&kref->refcount);
+	/* If refcount was 0 before incrementing then we have a race
+	 * condition when this kref is freing by some other thread right now.
+	 */
+	WARN_ON(atomic_inc_return(&kref->refcount) < 2);
 }
 
 /**
@@ -100,7 +102,7 @@ static inline int kref_put_mutex(struct kref *kref,
 				 struct mutex *lock)
 {
 	WARN_ON(release == NULL);
-        if (unlikely(!atomic_add_unless(&kref->refcount, -1, 1))) {
+	if (unlikely(!atomic_add_unless(&kref->refcount, -1, 1))) {
 		mutex_lock(lock);
 		if (unlikely(!atomic_dec_and_test(&kref->refcount))) {
 			mutex_unlock(lock);
diff --git a/kernel/module.c b/kernel/module.c
index 0925c9a..84bcd6f 100644
--- a/kernel/module.c
+++ b/kernel/module.c
@@ -1606,7 +1606,6 @@ static void module_remove_modinfo_attrs(struct module *mod)
 static int mod_sysfs_init(struct module *mod)
 {
 	int err;
-	struct kobject *kobj;
 
 	if (!module_sysfs_initialized) {
 		printk(KERN_ERR "%s: module sysfs not initialized\n",
@@ -1615,10 +1614,8 @@ static int mod_sysfs_init(struct module *mod)
 		goto out;
 	}
 
-	kobj = kset_find_obj(module_kset, mod->name);
-	if (kobj) {
+	if (kset_check_name_exists(module_kset, mod->name)) {
 		printk(KERN_ERR "%s: module is already loaded\n", mod->name);
-		kobject_put(kobj);
 		err = -EINVAL;
 		goto out;
 	}
diff --git a/lib/kobject.c b/lib/kobject.c
index e07ee1f..ae47cd1 100644
--- a/lib/kobject.c
+++ b/lib/kobject.c
@@ -734,6 +734,14 @@ void kset_unregister(struct kset *k)
 }
 
 /**
+ * kobj_compare_name - returns true if given kobj name equals to name parameter
+ */
+static bool kobj_compare_name(struct kobject *kobj, const char *name)
+{
+	return kobject_name(kobj) && !strcmp(kobject_name(kobj), name);
+}
+
+/**
  * kset_find_obj - search for object in kset.
  * @kset: kset we're looking in.
  * @name: object's name.
@@ -741,6 +749,13 @@ void kset_unregister(struct kset *k)
  * Lock kset via @kset->subsys, and iterate over @kset->list,
  * looking for a matching kobject. If matching object is found
  * take a reference and return the object.
+ *
+ * This function is racy with kobject_put function. kset_find_obj() can
+ * be called only if found object already has refcount equal or greater than 1.
+ * If found kobject is not held and has refcounter 0 it means it is in
+ * kobject_put path and returned kobject will be invalid soon.
+ * Use this function only when you sure returned kobject refcounter is held
+ * by someone during whole function execution.
  */
 struct kobject *kset_find_obj(struct kset *kset, const char *name)
 {
@@ -750,8 +765,39 @@ struct kobject *kset_find_obj(struct kset *kset, const char *name)
 	spin_lock(&kset->list_lock);
 
 	list_for_each_entry(k, &kset->list, entry) {
-		if (kobject_name(k) && !strcmp(kobject_name(k), name)) {
+		if (kobj_compare_name(k, name)) {
 			ret = kobject_get(k);
+			WARN_ON(atomic_read(&k->kref.refcount) < 2);
+			break;
+		}
+	}
+
+	spin_unlock(&kset->list_lock);
+	return ret;
+}
+
+/**
+ * kset_check_name_exists - returns true iff the object name exists in kset.
+ * @kset: kset we're looking in.
+ * @name: object's name.
+ *
+ * Unlike kset_find_obj() function kset_check_name_exists() can be called even
+ * if searching kobject is not held externally. It is thread-safe even if
+ * somebody calls kobject_put() for the kobject.
+ *
+ * Note that the result is valid only at the very moment of running this
+ * function. kset might be modified right after returning from the function.
+ */
+bool kset_check_name_exists(struct kset *kset, const char *name)
+{
+	struct kobject *k;
+	bool ret = false;
+
+	spin_lock(&kset->list_lock);
+
+	list_for_each_entry(k, &kset->list, entry) {
+		if (kobj_compare_name(k, name)) {
+			ret = true;
 			break;
 		}
 	}
-- 
1.8.1.3

