Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756899AbaKTNKb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Nov 2014 08:10:31 -0500
Received: from cantor2.suse.de ([195.135.220.15]:55726 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751103AbaKTNK2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Nov 2014 08:10:28 -0500
Date: Thu, 20 Nov 2014 14:10:33 +0100 (CET)
From: Miroslav Benes <mbenes@suse.cz>
To: Seth Jennings <sjenning@redhat.com>
cc: Josh Poimboeuf <jpoimboe@redhat.com>, Jiri Kosina <jkosina@suse.cz>,
        Vojtech Pavlik <vojtech@suse.cz>, Steven Rostedt <rostedt@goodmis.org>,
        Petr Mladek <pmladek@suse.cz>, Christoph Hellwig <hch@infradead.org>,
        Greg KH <gregkh@linuxfoundation.org>,
        Andy Lutomirski <luto@amacapital.net>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        live-patching@vger.kernel.org, x86@kernel.org, kpatch@redhat.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCHv2 2/3] kernel: add support for live patching
In-Reply-To: <1416187764-3341-3-git-send-email-sjenning@redhat.com>
Message-ID: <alpine.LNX.2.00.1411201359440.21690@pobox.suse.cz>
References: <1416187764-3341-1-git-send-email-sjenning@redhat.com> <1416187764-3341-3-git-send-email-sjenning@redhat.com>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Sun, 16 Nov 2014, Seth Jennings wrote:

> This commit introduces code for the live patching core.  It implements
> an ftrace-based mechanism and kernel interface for doing live patching
> of kernel and kernel module functions.
> 
> It represents the greatest common functionality set between kpatch and
> kgraft and can accept patches built using either method.
> 
> This first version does not implement any consistency mechanism that
> ensures that old and new code do not run together.  In practice, ~90% of
> CVEs are safe to apply in this way, since they simply add a conditional
> check.  However, any function change that can not execute safely with
> the old version of the function can _not_ be safely applied in this
> version.
> 
> Signed-off-by: Seth Jennings <sjenning@redhat.com>

Hi,

below is the patch which merges the internal and external data structures 
(so it is only one part of our original patch for version 1). Apart from 
that I tried to make minimal changes to the code. Only unnecessary 
kobjects were removed and I renamed lpc_create_* functions to lpc_init_* 
as it made more sense in this approach, I think.

I hope this clearly shows our point of view stated previously. What do 
you say?

Next, I'll look at the three level hierarchy and sysfs directory and see 
if we can make it simpler yet keep its advantages.

Regards,

Miroslav Benes
SUSE Labs

-- >8 --
>From aba839eb6b3292b193843715bfce7834969c0c17 Mon Sep 17 00:00:00 2001
From: Miroslav Benes <mbenes@suse.cz>
Date: Wed, 19 Nov 2014 16:06:35 +0100
Subject: [PATCH] Remove the data duplication in internal and public structures

The split of internal and external structures is cleaner and makes the API more
stable. But it makes the code more complicated. It requires more space and data
copying. Also the one letter difference of the names (lp_ vs. lpc_ prefix)
causes confusion.

The API is not a real issue for live patching. We take care neither of backward
nor forward compatibility. The dependency between a patch and kernel is even
more strict than by version. They have to use the same configuration and the
same build environment.

This patch merge the external and internal structures into one.  The structures
are initialized using ".item = value" syntax. Therefore the API is basically as
stable as it was before. We could later even hide it under some helper macros
if requested.

For the purpose if this patch, we used the prefix "lpc". It allows to make as
less changes as possible and show the real effect. If the patch is accepted, it
would make sense to merge it into the original patch and even use another
common prefix, for example the proposed "klp".

Signed-off-by: Miroslav Benes <mbenes@suse.cz>
---
 include/linux/livepatch.h |  47 +++++--
 kernel/livepatch/core.c   | 338 ++++++++++++----------------------------------
 2 files changed, 121 insertions(+), 264 deletions(-)

diff --git a/include/linux/livepatch.h b/include/linux/livepatch.h
index 8b68fef..f16de32 100644
--- a/include/linux/livepatch.h
+++ b/include/linux/livepatch.h
@@ -21,10 +21,23 @@
 #define _LINUX_LIVEPATCH_H_
 
 #include <linux/module.h>
+#include <linux/ftrace.h>
 
 /* TODO: add kernel-doc for structures once agreed upon */
 
-struct lp_func {
+enum lpc_state {
+	LPC_DISABLED,
+	LPC_ENABLED
+};
+
+struct lpc_func {
+	/* internal */
+	struct kobject *kobj;
+	struct ftrace_ops fops;
+	enum lpc_state state;
+	unsigned long new_addr;
+
+	/* external */
 	const char *old_name; /* function to be patched */
 	void *new_func; /* replacement function in patch module */
 	/*
@@ -38,7 +51,7 @@ struct lp_func {
 	unsigned long old_addr;
 };
 
-struct lp_reloc {
+struct lpc_reloc {
 	unsigned long dest;
 	unsigned long src;
 	unsigned long type;
@@ -47,21 +60,33 @@ struct lp_reloc {
 	int external;
 };
 
-struct lp_object {
+struct lpc_object {
+	/* internal */
+	struct kobject *kobj;
+	struct module *mod; /* module associated with object */
+	enum lpc_state state;
+
+	/* external */
 	const char *name; /* "vmlinux" or module name */
-	struct lp_func *funcs;
-	struct lp_reloc *relocs;
+	struct lpc_reloc *relocs;
+	struct lpc_func *funcs;
 };
 
-struct lp_patch {
+struct lpc_patch {
+	/* internal */
+	struct list_head list;
+	struct kobject kobj;
+	enum lpc_state state;
+
+	/* external */
 	struct module *mod; /* module containing the patch */
-	struct lp_object *objs;
+	struct lpc_object *objs;
 };
 
-int lp_register_patch(struct lp_patch *);
-int lp_unregister_patch(struct lp_patch *);
-int lp_enable_patch(struct lp_patch *);
-int lp_disable_patch(struct lp_patch *);
+extern int lpc_register_patch(struct lpc_patch *);
+extern int lpc_unregister_patch(struct lpc_patch *);
+extern int lpc_enable_patch(struct lpc_patch *);
+extern int lpc_disable_patch(struct lpc_patch *);
 
 #include <asm/livepatch.h>
 
diff --git a/kernel/livepatch/core.c b/kernel/livepatch/core.c
index e67c176..6586959 100644
--- a/kernel/livepatch/core.c
+++ b/kernel/livepatch/core.c
@@ -32,58 +32,9 @@
  * Core structures
  ************************************/
 
-/*
- * lp_ structs vs lpc_ structs
- *
- * For each element (patch, object, func) in the live-patching code,
- * there are two types with two different prefixes: lp_ and lpc_.
- *
- * Structures used by the live-patch modules to register with this core module
- * are prefixed with lp_ (live patching).  These structures are part of the
- * registration API and are defined in livepatch.h.  The structures used
- * internally by this core module are prefixed with lpc_ (live patching core).
- */
-
 static DEFINE_MUTEX(lpc_mutex);
 static LIST_HEAD(lpc_patches);
 
-enum lpc_state {
-	LPC_DISABLED,
-	LPC_ENABLED
-};
-
-struct lpc_func {
-	struct list_head list;
-	struct kobject kobj;
-	struct ftrace_ops fops;
-	enum lpc_state state;
-
-	const char *old_name;
-	unsigned long new_addr;
-	unsigned long old_addr;
-};
-
-struct lpc_object {
-	struct list_head list;
-	struct kobject kobj;
-	struct module *mod; /* module associated with object */
-	enum lpc_state state;
-
-	const char *name;
-	struct list_head funcs;
-	struct lp_reloc *relocs;
-};
-
-struct lpc_patch {
-	struct list_head list;
-	struct kobject kobj;
-	struct lp_patch *userpatch; /* for correlation during unregister */
-	enum lpc_state state;
-
-	struct module *mod;
-	struct list_head objs;
-};
-
 /*******************************************
  * Helpers
  *******************************************/
@@ -262,7 +213,7 @@ static int lpc_write_object_relocations(struct module *pmod,
 					struct lpc_object *obj)
 {
 	int ret;
-	struct lp_reloc *reloc;
+	struct lpc_reloc *reloc;
 
 	for (reloc = obj->relocs; reloc->name; reloc++) {
 		if (!strcmp(obj->name, "vmlinux")) {
@@ -360,7 +311,7 @@ static int lpc_disable_object(struct lpc_object *obj)
 	struct lpc_func *func;
 	int ret;
 
-	list_for_each_entry(func, &obj->funcs, list) {
+	for (func = obj->funcs; func->old_name; func++) {
 		if (func->state != LPC_ENABLED)
 			continue;
 		ret = lpc_disable_func(func);
@@ -387,7 +338,8 @@ static int lpc_enable_object(struct module *pmod, struct lpc_object *obj)
 		if (ret)
 			goto unregister;
 	}
-	list_for_each_entry(func, &obj->funcs, list) {
+
+	for (func = obj->funcs; func->old_name; func++) {
 		ret = lpc_find_verify_func_addr(func, obj->name);
 		if (ret)
 			goto unregister;
@@ -408,25 +360,14 @@ unregister:
  * enable/disable
  ******************************/
 
-static struct lpc_patch *lpc_find_patch(struct lp_patch *userpatch)
-{
-	struct lpc_patch *patch;
-
-	list_for_each_entry(patch, &lpc_patches, list)
-		if (patch->userpatch == userpatch)
-			return patch;
-
-	return NULL;
-}
-
-static int lpc_disable_patch(struct lpc_patch *patch)
+static int __lpc_disable_patch(struct lpc_patch *patch)
 {
 	struct lpc_object *obj;
 	int ret;
 
 	pr_notice("disabling patch '%s'\n", patch->mod->name);
 
-	list_for_each_entry(obj, &patch->objs, list) {
+	for (obj = patch->objs; obj->name; obj++) {
 		if (obj->state != LPC_ENABLED)
 			continue;
 		ret = lpc_disable_object(obj);
@@ -439,32 +380,26 @@ static int lpc_disable_patch(struct lpc_patch *patch)
 }
 
 /**
- * lp_disable_patch() - disables a registered patch
+ * lpc_disable_patch() - disables a registered patch
  * @userpatch:	The registered, enabled patch to be disabled
  *
  * Unregisters the patched functions from ftrace.
  *
  * Return: 0 on success, otherwise error
  */
-int lp_disable_patch(struct lp_patch *userpatch)
+int lpc_disable_patch(struct lpc_patch *patch)
 {
-	struct lpc_patch *patch;
 	int ret;
 
 	mutex_lock(&lpc_mutex);
-	patch = lpc_find_patch(userpatch);
-	if (!patch) {
-		ret = -ENODEV;
-		goto out;
-	}
-	ret = lpc_disable_patch(patch);
-out:
+	ret = __lpc_disable_patch(patch);
 	mutex_unlock(&lpc_mutex);
+
 	return ret;
 }
-EXPORT_SYMBOL_GPL(lp_disable_patch);
+EXPORT_SYMBOL_GPL(lpc_disable_patch);
 
-static int lpc_enable_patch(struct lpc_patch *patch)
+static int __lpc_enable_patch(struct lpc_patch *patch)
 {
 	struct lpc_object *obj;
 	int ret;
@@ -477,7 +412,7 @@ static int lpc_enable_patch(struct lpc_patch *patch)
 
 	pr_notice("enabling patch '%s'\n", patch->mod->name);
 
-	list_for_each_entry(obj, &patch->objs, list) {
+	for (obj = patch->objs; obj->name; obj++) {
 		if (!lpc_find_object_module(obj))
 			continue;
 		ret = lpc_enable_object(patch->mod, obj);
@@ -493,7 +428,7 @@ unregister:
 }
 
 /**
- * lp_enable_patch() - enables a registered patch
+ * lpc_enable_patch() - enables a registered patch
  * @userpatch:	The registered, disabled patch to be enabled
  *
  * Performs the needed symbol lookups and code relocations,
@@ -501,23 +436,17 @@ unregister:
  *
  * Return: 0 on success, otherwise error
  */
-int lp_enable_patch(struct lp_patch *userpatch)
+int lpc_enable_patch(struct lpc_patch *patch)
 {
-	struct lpc_patch *patch;
 	int ret;
 
 	mutex_lock(&lpc_mutex);
-	patch = lpc_find_patch(userpatch);
-	if (!patch) {
-		ret = -ENODEV;
-		goto out;
-	}
-	ret = lpc_enable_patch(patch);
-out:
+	ret = __lpc_enable_patch(patch);
 	mutex_unlock(&lpc_mutex);
+
 	return ret;
 }
-EXPORT_SYMBOL_GPL(lp_enable_patch);
+EXPORT_SYMBOL_GPL(lpc_enable_patch);
 
 /******************************
  * module notifier
@@ -568,7 +497,7 @@ static int lpc_module_notify(struct notifier_block *nb, unsigned long action,
 	list_for_each_entry(patch, &lpc_patches, list) {
 		if (patch->state == LPC_DISABLED)
 			continue;
-		list_for_each_entry(obj, &patch->objs, list) {
+		for (obj = patch->objs; obj->name; obj++) {
 			if (strcmp(obj->name, mod->name))
 				continue;
 			if (action == MODULE_STATE_COMING) {
@@ -624,11 +553,11 @@ static ssize_t enabled_store(struct kobject *kobj, struct kobj_attribute *attr,
 	}
 
 	if (val == LPC_ENABLED) {
-		ret = lpc_enable_patch(patch);
+		ret = __lpc_enable_patch(patch);
 		if (ret)
 			goto err;
 	} else {
-		ret = lpc_disable_patch(patch);
+		ret = __lpc_disable_patch(patch);
 		if (ret)
 			goto err;
 	}
@@ -677,7 +606,6 @@ static void lpc_kobj_release_patch(struct kobject *kobj)
 	patch = container_of(kobj, struct lpc_patch, kobj);
 	if (!list_empty(&patch->list))
 		list_del(&patch->list);
-	kfree(patch);
 }
 
 static struct kobj_type lpc_ktype_patch = {
@@ -686,212 +614,122 @@ static struct kobj_type lpc_ktype_patch = {
 	.default_attrs = lpc_patch_attrs
 };
 
-static void lpc_kobj_release_object(struct kobject *kobj)
-{
-	struct lpc_object *obj;
-
-	obj = container_of(kobj, struct lpc_object, kobj);
-	if (!list_empty(&obj->list))
-		list_del(&obj->list);
-	kfree(obj);
-}
-
-static struct kobj_type lpc_ktype_object = {
-	.release	= lpc_kobj_release_object,
-	.sysfs_ops	= &kobj_sysfs_ops,
-};
-
-static void lpc_kobj_release_func(struct kobject *kobj)
-{
-	struct lpc_func *func;
-
-	func = container_of(kobj, struct lpc_func, kobj);
-	if (!list_empty(&func->list))
-		list_del(&func->list);
-	kfree(func);
-}
-
-static struct kobj_type lpc_ktype_func = {
-	.release	= lpc_kobj_release_func,
-	.sysfs_ops	= &kobj_sysfs_ops,
-};
-
 /*********************************
  * structure allocation
  ********************************/
 
-static void lpc_free_funcs(struct lpc_object *obj)
+/*
+ * Free all functions' kobjects in the array up to some limit. When limit is
+ * NULL, all kobjects are freed.
+ */
+static void lpc_free_funcs_limited(struct lpc_object *obj,
+		struct lpc_func *limit)
 {
-	struct lpc_func *func, *funcsafe;
+	struct lpc_func *func;
 
-	list_for_each_entry_safe(func, funcsafe, &obj->funcs, list)
-		kobject_put(&func->kobj);
+	for (func = obj->funcs; func->old_name && func != limit; func++)
+		kobject_put(func->kobj);
 }
 
-static void lpc_free_objects(struct lpc_patch *patch)
+/*
+ * Free all objects' kobjects in the array up to some limit. When limit is
+ * NULL, all kobjects are freed.
+ */
+static void lpc_free_objects_limited(struct lpc_patch *patch,
+		struct lpc_object *limit)
 {
-	struct lpc_object *obj, *objsafe;
+	struct lpc_object *obj;
 
-	list_for_each_entry_safe(obj, objsafe, &patch->objs, list) {
-		lpc_free_funcs(obj);
-		kobject_put(&obj->kobj);
+	for (obj = patch->objs; obj->name && obj != limit; obj++) {
+		lpc_free_funcs_limited(obj, NULL);
+		kobject_put(obj->kobj);
 	}
 }
 
 static void lpc_free_patch(struct lpc_patch *patch)
 {
-	lpc_free_objects(patch);
+	lpc_free_objects_limited(patch, NULL);
 	kobject_put(&patch->kobj);
 }
 
-static struct lpc_func *lpc_create_func(struct kobject *root,
-					struct lp_func *userfunc)
+static int lpc_init_funcs(struct lpc_object *obj)
 {
 	struct lpc_func *func;
 	struct ftrace_ops *ops;
-	int ret;
-
-	/* alloc */
-	func = kzalloc(sizeof(*func), GFP_KERNEL);
-	if (!func)
-		return NULL;
-
-	/* init */
-	INIT_LIST_HEAD(&func->list);
-	func->old_name = userfunc->old_name;
-	func->new_addr = (unsigned long)userfunc->new_func;
-	func->old_addr = userfunc->old_addr;
-	func->state = LPC_DISABLED;
-	ops = &func->fops;
-	ops->private = func;
-	ops->func = lpc_ftrace_handler;
-	ops->flags = FTRACE_OPS_FL_SAVE_REGS | FTRACE_OPS_FL_DYNAMIC;
-
-	/* sysfs */
-	ret = kobject_init_and_add(&func->kobj, &lpc_ktype_func,
-				   root, func->old_name);
-	if (ret) {
-		kfree(func);
-		return NULL;
-	}
-
-	return func;
-}
-
-static int lpc_create_funcs(struct lpc_object *obj,
-			    struct lp_func *userfuncs)
-{
-	struct lp_func *userfunc;
-	struct lpc_func *func;
 
-	if (!userfuncs)
-		return -EINVAL;
-
-	for (userfunc = userfuncs; userfunc->old_name; userfunc++) {
-		func = lpc_create_func(&obj->kobj, userfunc);
-		if (!func)
+	for (func = obj->funcs; func->old_name; func++) {
+		func->new_addr = (unsigned long)func->new_func;
+		func->state = LPC_DISABLED;
+		ops = &func->fops;
+		ops->private = func;
+		ops->func = lpc_ftrace_handler;
+		ops->flags = FTRACE_OPS_FL_SAVE_REGS | FTRACE_OPS_FL_DYNAMIC;
+
+		/* sysfs */
+		func->kobj = kobject_create_and_add(func->old_name, obj->kobj);
+		if (!func->kobj)
 			goto free;
-		list_add(&func->list, &obj->funcs);
 	}
+
 	return 0;
 free:
-	lpc_free_funcs(obj);
+	lpc_free_funcs_limited(obj, func);
 	return -ENOMEM;
 }
 
-static struct lpc_object *lpc_create_object(struct kobject *root,
-					    struct lp_object *userobj)
+static int lpc_init_objects(struct lpc_patch *patch)
 {
 	struct lpc_object *obj;
 	int ret;
 
-	/* alloc */
-	obj = kzalloc(sizeof(*obj), GFP_KERNEL);
-	if (!obj)
-		return NULL;
+	for (obj = patch->objs; obj->name; obj++) {
+		/* obj->mod set by lpc_object_module_get() */
+		obj->state = LPC_DISABLED;
 
-	/* init */
-	INIT_LIST_HEAD(&obj->list);
-	obj->name = userobj->name;
-	obj->relocs = userobj->relocs;
-	obj->state = LPC_DISABLED;
-	/* obj->mod set by lpc_object_module_get() */
-	INIT_LIST_HEAD(&obj->funcs);
-
-	/* sysfs */
-	ret = kobject_init_and_add(&obj->kobj, &lpc_ktype_object,
-				   root, obj->name);
-	if (ret) {
-		kfree(obj);
-		return NULL;
-	}
-
-	/* create functions */
-	ret = lpc_create_funcs(obj, userobj->funcs);
-	if (ret) {
-		kobject_put(&obj->kobj);
-		return NULL;
-	}
-
-	return obj;
-}
-
-static int lpc_create_objects(struct lpc_patch *patch,
-			      struct lp_object *userobjs)
-{
-	struct lp_object *userobj;
-	struct lpc_object *obj;
-
-	if (!userobjs)
-		return -EINVAL;
+		/* sysfs */
+		obj->kobj = kobject_create_and_add(obj->name, &patch->kobj);
+		if (!obj->kobj)
+			goto free;
 
-	for (userobj = userobjs; userobj->name; userobj++) {
-		obj = lpc_create_object(&patch->kobj, userobj);
-		if (!obj)
+		/* init functions */
+		ret = lpc_init_funcs(obj);
+		if (ret) {
+			kobject_put(obj->kobj);
 			goto free;
-		list_add(&obj->list, &patch->objs);
+		}
 	}
+
 	return 0;
 free:
-	lpc_free_objects(patch);
+	lpc_free_objects_limited(patch, obj);
 	return -ENOMEM;
 }
 
-static int lpc_create_patch(struct lp_patch *userpatch)
+static int lpc_init_patch(struct lpc_patch *patch)
 {
-	struct lpc_patch *patch;
 	int ret;
 
-	/* alloc */
-	patch = kzalloc(sizeof(*patch), GFP_KERNEL);
-	if (!patch)
-		return -ENOMEM;
+	mutex_lock(&lpc_mutex);
 
 	/* init */
-	INIT_LIST_HEAD(&patch->list);
-	patch->userpatch = userpatch;
-	patch->mod = userpatch->mod;
 	patch->state = LPC_DISABLED;
-	INIT_LIST_HEAD(&patch->objs);
 
 	/* sysfs */
 	ret = kobject_init_and_add(&patch->kobj, &lpc_ktype_patch,
 				   lpc_root_kobj, patch->mod->name);
-	if (ret) {
-		kfree(patch);
+	if (ret)
 		return ret;
-	}
 
 	/* create objects */
-	ret = lpc_create_objects(patch, userpatch->objs);
+	ret = lpc_init_objects(patch);
 	if (ret) {
 		kobject_put(&patch->kobj);
 		return ret;
 	}
 
 	/* add to global list of patches */
-	mutex_lock(&lpc_mutex);
 	list_add(&patch->list, &lpc_patches);
+
 	mutex_unlock(&lpc_mutex);
 
 	return 0;
@@ -902,7 +740,7 @@ static int lpc_create_patch(struct lp_patch *userpatch)
  ***********************************/
 
 /**
- * lp_register_patch() - registers a patch
+ * lpc_register_patch() - registers a patch
  * @userpatch:	Patch to be registered
  *
  * Allocates the data structure associated with the patch and
@@ -910,11 +748,11 @@ static int lpc_create_patch(struct lp_patch *userpatch)
  *
  * Return: 0 on success, otherwise error
  */
-int lp_register_patch(struct lp_patch *userpatch)
+int lpc_register_patch(struct lpc_patch *userpatch)
 {
 	int ret;
 
-	if (!userpatch || !userpatch->mod || !userpatch->objs)
+	if (!userpatch || !userpatch->mod)
 		return -EINVAL;
 
 	/*
@@ -927,43 +765,37 @@ int lp_register_patch(struct lp_patch *userpatch)
 	if (!try_module_get(userpatch->mod))
 		return -ENODEV;
 
-	ret = lpc_create_patch(userpatch);
+	ret = lpc_init_patch(userpatch);
 	if (ret)
 		module_put(userpatch->mod);
 
 	return ret;
 }
-EXPORT_SYMBOL_GPL(lp_register_patch);
+EXPORT_SYMBOL_GPL(lpc_register_patch);
 
 /**
- * lp_unregister_patch() - unregisters a patch
+ * lpc_unregister_patch() - unregisters a patch
  * @userpatch:	Disabled patch to be unregistered
  *
  * Frees the data structures and removes the sysfs interface.
  *
  * Return: 0 on success, otherwise error
  */
-int lp_unregister_patch(struct lp_patch *userpatch)
+int lpc_unregister_patch(struct lpc_patch *userpatch)
 {
-	struct lpc_patch *patch;
 	int ret = 0;
 
 	mutex_lock(&lpc_mutex);
-	patch = lpc_find_patch(userpatch);
-	if (!patch) {
-		ret = -ENODEV;
-		goto out;
-	}
-	if (patch->state == LPC_ENABLED) {
+	if (userpatch->state == LPC_ENABLED) {
 		ret = -EINVAL;
 		goto out;
 	}
-	lpc_free_patch(patch);
+	lpc_free_patch(userpatch);
 out:
 	mutex_unlock(&lpc_mutex);
 	return ret;
 }
-EXPORT_SYMBOL_GPL(lp_unregister_patch);
+EXPORT_SYMBOL_GPL(lpc_unregister_patch);
 
 /************************************
  * entry/exit
-- 
2.1.2

