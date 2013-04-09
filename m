Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935760Ab3DILWA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Apr 2013 07:22:00 -0400
Received: from mx1.redhat.com ([209.132.183.28]:25608 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933562Ab3DILV6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Apr 2013 07:21:58 -0400
From: Veaceslav Falico <vfalico@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: vfalico@redhat.com, linux-pci@vger.kernel.org, rusty@rustcorp.com.au,
        gregkh@linuxfoundation.org, bhelgaas@google.com
Subject: [PATCH] module: add kset_obj_exists() and use it
Date: Tue,  9 Apr 2013 13:22:09 +0200
Message-Id: <1365506529-8396-1-git-send-email-vfalico@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add a new function, kset_obj_exists(), which is identical to
kset_find_obj() but doesn't take a reference to the kobject
found and only returns bool if found/not found.

The main purpose would be to avoid the possible race scenario,
when we could get the reference in between the kref_put() and
kobject_release() functions (i.e. kref_put() already ran,
refcount became 0, but the kobject_release() function still
didn't run, and we try to get via kobject_get() and thus ending
up with a released kobject). It can be triggered, for example,
by running insmod/rmmod bonding in parallel, which ends up in
a race between kset_obj_find() in mod_sysfs_init() and rmmod's
mod_sysfs_fini()/kobject_put().

It also saves us some CPU time in several places where we don't
need the kobject itself and only need to verify if it actually
exists, by not taking the kref (and thus we don't need to
kobject_put() afterwards).

Signed-off-by: Veaceslav Falico <vfalico@redhat.com>
---
 drivers/pci/slot.c      |    5 +----
 include/linux/kobject.h |    1 +
 kernel/module.c         |    5 +----
 lib/kobject.c           |   28 ++++++++++++++++++++++++++++
 4 files changed, 31 insertions(+), 8 deletions(-)

diff --git a/drivers/pci/slot.c b/drivers/pci/slot.c
index ac6412f..3988d75 100644
--- a/drivers/pci/slot.c
+++ b/drivers/pci/slot.c
@@ -154,11 +154,8 @@ static char *make_slot_name(const char *name)
 	dup = 1;
 
 	for (;;) {
-		struct kobject *dup_slot;
-		dup_slot = kset_find_obj(pci_slots_kset, new_name);
-		if (!dup_slot)
+		if (!kset_obj_exists(pci_slots_kset, new_name))
 			break;
-		kobject_put(dup_slot);
 		if (dup == max) {
 			len++;
 			max *= 10;
diff --git a/include/linux/kobject.h b/include/linux/kobject.h
index 939b112..7cde72c 100644
--- a/include/linux/kobject.h
+++ b/include/linux/kobject.h
@@ -191,6 +191,7 @@ static inline struct kobj_type *get_ktype(struct kobject *kobj)
 }
 
 extern struct kobject *kset_find_obj(struct kset *, const char *);
+extern bool kset_obj_exists(struct kset *, const char *);
 
 /* The global /sys/kernel/ kobject for people to chain off of */
 extern struct kobject *kernel_kobj;
diff --git a/kernel/module.c b/kernel/module.c
index 0925c9a..1df13a3 100644
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
+	if (kset_obj_exists(module_kset, mod->name)) {
 		printk(KERN_ERR "%s: module is already loaded\n", mod->name);
-		kobject_put(kobj);
 		err = -EINVAL;
 		goto out;
 	}
diff --git a/lib/kobject.c b/lib/kobject.c
index e07ee1f..b82633f 100644
--- a/lib/kobject.c
+++ b/lib/kobject.c
@@ -760,6 +760,34 @@ struct kobject *kset_find_obj(struct kset *kset, const char *name)
 	return ret;
 }
 
+/**
+ * kset_obj_exists - verify if an object exists in kset
+ * @kset: kset we're looking in.
+ * @name: object's name.
+ *
+ * Lock kset via @kset->subsys, and iterate over @kset->list,
+ * looking for a matching kobject. Returns bool, found/not found.
+ * This function does not take a reference and thus doesn't
+ * guarantee that the object won't go away any time after.
+ */
+
+bool kset_obj_exists(struct kset *kset, const char *name)
+{
+	struct kobject *k;
+
+	spin_lock(&kset->list_lock);
+
+	list_for_each_entry(k, &kset->list, entry) {
+		if (kobject_name(k) && !strcmp(kobject_name(k), name)) {
+			spin_unlock(&kset->list_lock);
+			return true;
+		}
+	}
+
+	spin_unlock(&kset->list_lock);
+	return false;
+}
+
 static void kset_release(struct kobject *kobj)
 {
 	struct kset *kset = container_of(kobj, struct kset, kobj);
-- 
1.7.1

