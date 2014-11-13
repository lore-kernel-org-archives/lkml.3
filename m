Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932311AbaKMKQI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Nov 2014 05:16:08 -0500
Received: from cantor2.suse.de ([195.135.220.15]:58659 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932164AbaKMKQB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Nov 2014 05:16:01 -0500
Date: Thu, 13 Nov 2014 11:16:00 +0100 (CET)
From: Miroslav Benes <mbenes@suse.cz>
To: Seth Jennings <sjenning@redhat.com>
cc: Josh Poimboeuf <jpoimboe@redhat.com>, Jiri Kosina <jkosina@suse.cz>,
        Vojtech Pavlik <vojtech@suse.cz>, Steven Rostedt <rostedt@goodmis.org>,
        jslaby@suse.cz, pmladek@suse.cz, live-patching@vger.kernel.org,
        kpatch@redhat.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] kernel: add support for live patching
In-Reply-To: <1415284748-14648-3-git-send-email-sjenning@redhat.com>
Message-ID: <alpine.LNX.2.00.1411131105290.10080@pobox.suse.cz>
References: <1415284748-14648-1-git-send-email-sjenning@redhat.com> <1415284748-14648-3-git-send-email-sjenning@redhat.com>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi,

thank you for the first version of the united live patching core.

The patch below implements some of our review objections. Changes are 
described in the commit log. It simplifies the hierarchy of data 
structures, removes data duplication (lp_ and lpc_ structures) and 
simplifies sysfs directory.

I did not try to repair other stuff (races, function names, function 
prefix, api symmetry etc.). It should serve as a demonstration of our 
point of view.

There are some problems with this. try_module_get and module_put may be 
called several times for each kernel module where some function is 
patched in. This should be fixed with module going notifier as suggested 
by Petr. 

The modified core was tested with modified testing live patch originally 
from Seth's github. It worked as expected.

Please take a look at these changes, so we can discuss them in more 
detail.

Best regards,
--
Miroslav Benes
SUSE Labs


----
>From f659a18a630de27b47d375119d793e28ee50da04 Mon Sep 17 00:00:00 2001
From: Miroslav Benes <mbenes@suse.cz>
Date: Thu, 13 Nov 2014 10:25:48 +0100
Subject: [PATCH] lpc: simplification of structure and sysfs hierarchy

Original code has several issues this patch tries to remove.

First, there is only lpc_func structure for patched function and lpc_patch for
the patch as a whole. Therefore lpc_object structure as middle step of hierarchy
is removed. Patched function is still associated with some object (vmlinux or
module) through obj_name. Dynrelas are now in lpc_patch structure and object
identifier (obj_name) is in the lpc_dynrela to preserve the connection.

Second, sysfs structure is simplified. We do not need to propagate old_addr and
new_addr. So, there is subdirectory for each patch (patching module) which
includes original enabled attribute and new one funcs attribute which lists the
patched functions.

Third, data duplication (lp_ and lpc_ structures) is removed. lpc_ structures
are now in the header file and made available for the user. This allows us to
remove almost all the functions for structure allocation in the original code.

Signed-off-by: Miroslav Benes <mbenes@suse.cz>
---
 include/linux/livepatch.h |  46 ++--
 kernel/livepatch/core.c   | 575 +++++++++++++---------------------------------
 2 files changed, 191 insertions(+), 430 deletions(-)

diff --git a/include/linux/livepatch.h b/include/linux/livepatch.h
index c7a415b..db5ba00 100644
--- a/include/linux/livepatch.h
+++ b/include/linux/livepatch.h
@@ -2,10 +2,23 @@
 #define _LIVEPATCH_H_
 
 #include <linux/module.h>
+#include <linux/ftrace.h>
 
-struct lp_func {
+enum lpc_state {
+	LPC_DISABLED,
+	LPC_ENABLED
+};
+
+struct lpc_func {
+	/* internal */
+	struct ftrace_ops fops;
+	enum lpc_state state;
+	struct module *mod; /* module associated with patched function */
+	unsigned long new_addr; /* replacement function in patch module */
+
+	/* external */
 	const char *old_name; /* function to be patched */
-	void *new_func; /* replacement function in patch module */
+	void *new_func;
 	/*
 	 * The old_addr field is optional and can be used to resolve
 	 * duplicate symbol names in the vmlinux object.  If this
@@ -15,31 +28,36 @@ struct lp_func {
 	 * way to resolve the ambiguity.
 	 */
 	unsigned long old_addr;
+
+	const char *obj_name; /* "vmlinux" or module name */
 };
 
-struct lp_dynrela {
+struct lpc_dynrela {
 	unsigned long dest;
 	unsigned long src;
 	unsigned long type;
 	const char *name;
+	const char *obj_name;
 	int addend;
 	int external;
 };
 
-struct lp_object {
-	const char *name; /* "vmlinux" or module name */
-	struct lp_func *funcs;
-	struct lp_dynrela *dynrelas;
-};
+struct lpc_patch {
+	/* internal */
+	struct list_head list;
+	struct kobject kobj;
+	enum lpc_state state;
 
-struct lp_patch {
+	/* external */
 	struct module *mod; /* module containing the patch */
-	struct lp_object *objs;
+	struct lpc_dynrela *dynrelas;
+	struct lpc_func funcs[];
 };
 
-int lp_register_patch(struct lp_patch *);
-int lp_unregister_patch(struct lp_patch *);
-int lp_enable_patch(struct lp_patch *);
-int lp_disable_patch(struct lp_patch *);
+
+extern int lpc_register_patch(struct lpc_patch *);
+extern int lpc_unregister_patch(struct lpc_patch *);
+extern int lpc_enable_patch(struct lpc_patch *);
+extern int lpc_disable_patch(struct lpc_patch *);
 
 #endif /* _LIVEPATCH_H_ */
diff --git a/kernel/livepatch/core.c b/kernel/livepatch/core.c
index b32dbb5..feecc22 100644
--- a/kernel/livepatch/core.c
+++ b/kernel/livepatch/core.c
@@ -31,78 +31,32 @@
 
 #include <linux/livepatch.h>
 
+#define lpc_for_each_patch_func(p, pf)   \
+        for (pf = p->funcs; pf->old_name; pf++)
+
 /*************************************
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
 static DEFINE_SEMAPHORE(lpc_mutex);
 static LIST_HEAD(lpc_patches);
 
-enum lpc_state {
-	DISABLED,
-	ENABLED
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
-	struct lp_dynrela *dynrelas;
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
 
-/* sets obj->mod if object is not vmlinux and module was found */
-static bool is_object_loaded(struct lpc_object *obj)
+/* sets patch_func->mod if object is not vmlinux and module was found */
+static bool is_object_loaded(struct lpc_func *patch_func)
 {
 	struct module *mod;
 
-	if (!strcmp(obj->name, "vmlinux"))
+	if (!strcmp(patch_func->obj_name, "vmlinux"))
 		return 1;
 
 	mutex_lock(&module_mutex);
-	mod = find_module(obj->name);
+	mod = find_module(patch_func->obj_name);
 	mutex_unlock(&module_mutex);
-	obj->mod = mod;
+	patch_func->mod = mod;
 
 	return !!mod;
 }
@@ -254,18 +208,18 @@ static int lpc_find_external_symbol(struct module *pmod, const char *name,
 	return lpc_find_symbol(pmod->name, name, addr);
 }
 
-static int lpc_write_object_relocations(struct module *pmod,
-					struct lpc_object *obj)
+static int lpc_write_relocations(struct module *pmod,
+		struct lpc_dynrela *patch_dynrelas)
 {
 	int ret, size, readonly = 0, numpages;
-	struct lp_dynrela *dynrela;
+	struct lpc_dynrela *dynrela;
 	u64 loc, val;
 	unsigned long core = (unsigned long)pmod->module_core;
 	unsigned long core_ro_size = pmod->core_ro_size;
 	unsigned long core_size = pmod->core_size;
 
-	for (dynrela = obj->dynrelas; dynrela->name; dynrela++) {
-		if (!strcmp(obj->name, "vmlinux")) {
+	for (dynrela = patch_dynrelas; dynrela->name; dynrela++) {
+		if (!strcmp(dynrela->obj_name, "vmlinux")) {
 			ret = lpc_verify_vmlinux_symbol(dynrela->name,
 							dynrela->src);
 			if (ret)
@@ -277,7 +231,7 @@ static int lpc_write_object_relocations(struct module *pmod,
 							       dynrela->name,
 							       &dynrela->src);
 			else
-				ret = lpc_find_symbol(obj->mod->name,
+				ret = lpc_find_symbol(dynrela->obj_name,
 						      dynrela->name,
 						      &dynrela->src);
 			if (ret)
@@ -357,7 +311,7 @@ static int lpc_enable_func(struct lpc_func *func)
 	int ret;
 
 	BUG_ON(!func->old_addr);
-	BUG_ON(func->state != DISABLED);
+	BUG_ON(func->state != LPC_DISABLED);
 	ret = ftrace_set_filter_ip(&func->fops, func->old_addr, 0, 0);
 	if (ret) {
 		pr_err("failed to set ftrace filter for function '%s' (%d)\n",
@@ -370,16 +324,16 @@ static int lpc_enable_func(struct lpc_func *func)
 		       func->old_name, ret);
 		ftrace_set_filter_ip(&func->fops, func->old_addr, 1, 0);
 	} else
-		func->state = ENABLED;
+		func->state = LPC_ENABLED;
 
 	return ret;
 }
 
-static int lpc_unregister_func(struct lpc_func *func)
+static int lpc_disable_func(struct lpc_func *func)
 {
 	int ret;
 
-	BUG_ON(func->state != ENABLED);
+	BUG_ON(func->state != LPC_ENABLED);
 	if (!func->old_addr)
 		/* parent object is not loaded */
 		return 0;
@@ -392,173 +346,131 @@ static int lpc_unregister_func(struct lpc_func *func)
 	ret = ftrace_set_filter_ip(&func->fops, func->old_addr, 1, 0);
 	if (ret)
 		pr_warn("function unregister succeeded but failed to clear the filter\n");
-	func->state = DISABLED;
+	func->state = LPC_DISABLED;
 
 	return 0;
 }
 
-static int lpc_unregister_object(struct lpc_object *obj)
-{
-	struct lpc_func *func;
-	int ret;
-
-	list_for_each_entry(func, &obj->funcs, list) {
-		if (func->state != ENABLED)
-			continue;
-		ret = lpc_unregister_func(func);
-		if (ret)
-			return ret;
-		if (strcmp(obj->name, "vmlinux"))
-			func->old_addr = 0;
-	}
-	if (obj->mod)
-		module_put(obj->mod);
-	obj->state = DISABLED;
-
-	return 0;
-}
-
-/* caller must ensure that obj->mod is set if object is a module */
-static int lpc_enable_object(struct module *pmod, struct lpc_object *obj)
-{
-	struct lpc_func *func;
-	int ret;
-
-	if (obj->mod && !try_module_get(obj->mod))
-		return -ENODEV;
-
-	if (obj->dynrelas) {
-		ret = lpc_write_object_relocations(pmod, obj);
-		if (ret)
-			goto unregister;
-	}
-	list_for_each_entry(func, &obj->funcs, list) {
-		ret = lpc_find_verify_func_addr(func, obj->name);
-		if (ret)
-			goto unregister;
-
-		ret = lpc_enable_func(func);
-		if (ret)
-			goto unregister;
-	}
-	obj->state = ENABLED;
-
-	return 0;
-unregister:
-	WARN_ON(lpc_unregister_object(obj));
-	return ret;
-}
-
 /******************************
  * enable/disable
  ******************************/
 
 /* must be called with lpc_mutex held */
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
-/* must be called with lpc_mutex held */
-static int lpc_disable_patch(struct lpc_patch *patch)
+static int __lpc_disable_patch(struct lpc_patch *patch)
 {
-	struct lpc_object *obj;
+	struct lpc_func *patch_func;
 	int ret;
 
 	pr_notice("disabling patch '%s'\n", patch->mod->name);
 
-	list_for_each_entry(obj, &patch->objs, list) {
-		if (obj->state != ENABLED)
+	lpc_for_each_patch_func(patch, patch_func) {
+		if (patch_func->state != LPC_ENABLED)
 			continue;
-		ret = lpc_unregister_object(obj);
-		if (ret)
+		ret = lpc_disable_func(patch_func);
+		if (ret) {
+			pr_err("lpc: cannot disable function %s\n",
+				patch_func->old_name);
 			return ret;
+		}
+
+		if (strcmp(patch_func->obj_name, "vmlinux"))
+			patch_func->old_addr = 0;
+		if (patch_func->mod)
+			module_put(patch_func->mod);
 	}
-	patch->state = DISABLED;
+	patch->state = LPC_DISABLED;
 
 	return 0;
 }
 
-int lp_disable_patch(struct lp_patch *userpatch)
+int lpc_disable_patch(struct lpc_patch *patch)
 {
-	struct lpc_patch *patch;
 	int ret;
 
 	down(&lpc_mutex);
-	patch = lpc_find_patch(userpatch);
-	if (!patch) {
-		ret = -ENODEV;
-		goto out;
-	}
-	ret = lpc_disable_patch(patch);
-out:
+	ret = __lpc_disable_patch(patch);
 	up(&lpc_mutex);
+
 	return ret;
 }
-EXPORT_SYMBOL_GPL(lp_disable_patch);
+EXPORT_SYMBOL_GPL(lpc_disable_patch);
+
+static int lpc_verify_enable_func(struct lpc_func *patch_func)
+{
+	int ret;
+
+	if (patch_func->mod && !try_module_get(patch_func->mod))
+		return -ENODEV;
+
+	ret = lpc_find_verify_func_addr(patch_func, patch_func->obj_name);
+	if (ret)
+		return ret;
+
+	ret = lpc_enable_func(patch_func);
+	if (ret)
+		return ret;
+
+	return 0;
+}
 
 /* must be called with lpc_mutex held */
-static int lpc_enable_patch(struct lpc_patch *patch)
+static int __lpc_enable_patch(struct lpc_patch *patch)
 {
-	struct lpc_object *obj;
+	struct lpc_func *patch_func;
 	int ret;
 
-	BUG_ON(patch->state != DISABLED);
+	BUG_ON(patch->state != LPC_DISABLED);
 
 	pr_notice_once("tainting kernel with TAINT_LIVEPATCH\n");
 	add_taint(TAINT_LIVEPATCH, LOCKDEP_STILL_OK);
 
 	pr_notice("enabling patch '%s'\n", patch->mod->name);
 
-	list_for_each_entry(obj, &patch->objs, list) {
-		if (!is_object_loaded(obj))
+	if (patch->dynrelas) {
+		ret = lpc_write_relocations(patch->mod, patch->dynrelas);
+		if (ret)
+			goto err;
+	}
+
+	lpc_for_each_patch_func(patch, patch_func) {
+		if (!is_object_loaded(patch_func))
 			continue;
-		ret = lpc_enable_object(patch->mod, obj);
+
+		ret = lpc_verify_enable_func(patch_func);
 		if (ret)
-			goto unregister;
+			goto err;
 	}
-	patch->state = ENABLED;
+	patch->state = LPC_ENABLED;
+
 	return 0;
 
-unregister:
-	WARN_ON(lpc_disable_patch(patch));
+err:
+	WARN_ON(__lpc_disable_patch(patch));
 	return ret;
 }
 
-int lp_enable_patch(struct lp_patch *userpatch)
+int lpc_enable_patch(struct lpc_patch *patch)
 {
-	struct lpc_patch *patch;
 	int ret;
 
 	down(&lpc_mutex);
-	patch = lpc_find_patch(userpatch);
-	if (!patch) {
-		ret = -ENODEV;
-		goto out;
-	}
-	ret = lpc_enable_patch(patch);
-out:
+	ret = __lpc_enable_patch(patch);
 	up(&lpc_mutex);
+
 	return ret;
 }
-EXPORT_SYMBOL_GPL(lp_enable_patch);
+EXPORT_SYMBOL_GPL(lpc_enable_patch);
 
 /******************************
  * module notifier
  *****************************/
 
-static int lp_module_notify(struct notifier_block *nb, unsigned long action,
+static int lpc_module_notify(struct notifier_block *nb, unsigned long action,
 			    void *data)
 {
 	struct module *mod = data;
 	struct lpc_patch *patch;
-	struct lpc_object *obj;
+	struct lpc_func *patch_func;
 	int ret = 0;
 
 	if (action != MODULE_STATE_COMING)
@@ -567,32 +479,42 @@ static int lp_module_notify(struct notifier_block *nb, unsigned long action,
 	down(&lpc_mutex);
 
 	list_for_each_entry(patch, &lpc_patches, list) {
-		if (patch->state == DISABLED)
+		if (patch->state == LPC_DISABLED)
 			continue;
-		list_for_each_entry(obj, &patch->objs, list) {
-			if (strcmp(obj->name, mod->name))
+
+		if (patch->dynrelas) {
+			ret = lpc_write_relocations(patch->mod,
+				patch->dynrelas);
+			if (ret)
+				goto err;
+		}
+
+		lpc_for_each_patch_func(patch, patch_func) {
+			if (strcmp(patch_func->obj_name, mod->name))
 				continue;
+
 			pr_notice("load of module '%s' detected, applying patch '%s'\n",
 				  mod->name, patch->mod->name);
-			obj->mod = mod;
-			ret = lpc_enable_object(patch->mod, obj);
+			patch_func->mod = mod;
+
+			ret = lpc_verify_enable_func(patch_func);
 			if (ret)
-				goto out;
-			break;
+				goto err;
 		}
 	}
 
 	up(&lpc_mutex);
 	return 0;
-out:
+
+err:
 	up(&lpc_mutex);
 	WARN("failed to apply patch '%s' to module '%s'\n",
 		patch->mod->name, mod->name);
 	return 0;
 }
 
-static struct notifier_block lp_module_nb = {
-	.notifier_call = lp_module_notify,
+static struct notifier_block lpc_module_nb = {
+	.notifier_call = lpc_module_notify,
 	.priority = INT_MIN, /* called last */
 };
 
@@ -603,10 +525,7 @@ static struct notifier_block lp_module_nb = {
  * /sys/kernel/livepatch
  * /sys/kernel/livepatch/<patch>
  * /sys/kernel/livepatch/<patch>/enabled
- * /sys/kernel/livepatch/<patch>/<object>
- * /sys/kernel/livepatch/<patch>/<object>/<func>
- * /sys/kernel/livepatch/<patch>/<object>/<func>/new_addr
- * /sys/kernel/livepatch/<patch>/<object>/<func>/old_addr
+ * /sys/kernel/livepatch/<patch>/funcs
  */
 
 static ssize_t enabled_store(struct kobject *kobj, struct kobj_attribute *attr,
@@ -620,7 +539,7 @@ static ssize_t enabled_store(struct kobject *kobj, struct kobj_attribute *attr,
 	if (ret)
 		return -EINVAL;
 
-	if (val != DISABLED && val != ENABLED)
+	if (val != LPC_DISABLED && val != LPC_ENABLED)
 		return -EINVAL;
 
 	patch = container_of(kobj, struct lpc_patch, kobj);
@@ -632,12 +551,12 @@ static ssize_t enabled_store(struct kobject *kobj, struct kobj_attribute *attr,
 		goto out;
 	}
 
-	if (val == ENABLED) {
-		ret = lpc_enable_patch(patch);
+	if (val == LPC_ENABLED) {
+		ret = __lpc_enable_patch(patch);
 		if (ret)
 			goto out;
 	} else {
-		ret = lpc_disable_patch(patch);
+		ret = __lpc_disable_patch(patch);
 		if (ret)
 			goto out;
 	}
@@ -657,40 +576,35 @@ static ssize_t enabled_show(struct kobject *kobj,
 	return snprintf(buf, PAGE_SIZE-1, "%d\n", patch->state);
 }
 
-static struct kobj_attribute enabled_kobj_attr = __ATTR_RW(enabled);
-static struct attribute *lpc_patch_attrs[] = {
-	&enabled_kobj_attr.attr,
-	NULL
-};
-
-static ssize_t new_addr_show(struct kobject *kobj,
+static ssize_t funcs_show(struct kobject *kobj,
 			     struct kobj_attribute *attr, char *buf)
 {
-	struct lpc_func *func;
-
-	func = container_of(kobj, struct lpc_func, kobj);
-	return snprintf(buf, PAGE_SIZE-1, "0x%016lx\n", func->new_addr);
-}
+	struct lpc_patch *patch;
+	const struct lpc_func *patch_func;
+	ssize_t size;
 
-static struct kobj_attribute new_addr_kobj_attr = __ATTR_RO(new_addr);
+	size = snprintf(buf, PAGE_SIZE, "Functions:\n");
 
-static ssize_t old_addr_show(struct kobject *kobj,
-			     struct kobj_attribute *attr, char *buf)
-{
-	struct lpc_func *func;
+	patch = container_of(kobj, struct lpc_patch, kobj);
+	lpc_for_each_patch_func(patch, patch_func)
+		size += snprintf(buf + size, PAGE_SIZE - size, "%s\n",
+				patch_func->old_name);
 
-	func = container_of(kobj, struct lpc_func, kobj);
-	return snprintf(buf, PAGE_SIZE-1, "0x%016lx\n", func->old_addr);
+        return size;
 }
 
-static struct kobj_attribute old_addr_kobj_attr = __ATTR_RO(old_addr);
-
-static struct attribute *lpc_func_attrs[] = {
-	&new_addr_kobj_attr.attr,
-	&old_addr_kobj_attr.attr,
+static struct kobj_attribute enabled_kobj_attr = __ATTR_RW(enabled);
+static struct kobj_attribute funcs_kobj_attr = __ATTR_RO(funcs);
+static struct attribute *lpc_patch_attrs[] = {
+	&enabled_kobj_attr.attr,
+	&funcs_kobj_attr.attr,
 	NULL
 };
 
+static struct attribute_group lpc_patch_sysfs_group = {
+	.attrs = lpc_patch_attrs,
+};
+
 static struct kobject *lpc_root_kobj;
 
 static int lpc_create_root_kobj(void)
@@ -720,228 +634,67 @@ static void lpc_kobj_release_patch(struct kobject *kobj)
 static struct kobj_type lpc_ktype_patch = {
 	.release = lpc_kobj_release_patch,
 	.sysfs_ops = &kobj_sysfs_ops,
-	.default_attrs = lpc_patch_attrs
-};
-
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
-	.default_attrs = lpc_func_attrs
 };
 
 /*********************************
- * structure allocation
+ * structure init and free
  ********************************/
 
-static void lpc_free_funcs(struct lpc_object *obj)
-{
-	struct lpc_func *func, *funcsafe;
-
-	list_for_each_entry_safe(func, funcsafe, &obj->funcs, list)
-		kobject_put(&func->kobj);
-}
-
-static void lpc_free_objects(struct lpc_patch *patch)
-{
-	struct lpc_object *obj, *objsafe;
-
-	list_for_each_entry_safe(obj, objsafe, &patch->objs, list) {
-		lpc_free_funcs(obj);
-		kobject_put(&obj->kobj);
-	}
-}
-
 static void lpc_free_patch(struct lpc_patch *patch)
 {
-	lpc_free_objects(patch);
+	sysfs_remove_group(&patch->kobj, &lpc_patch_sysfs_group);
 	kobject_put(&patch->kobj);
 }
 
-static struct lpc_func *lpc_create_func(struct kobject *root,
-					struct lp_func *userfunc)
+static int lpc_init_patch(struct lpc_patch *patch)
 {
-	struct lpc_func *func;
 	struct ftrace_ops *ops;
+	struct lpc_func *patch_func;
 	int ret;
 
-	/* alloc */
-	func = kzalloc(sizeof(*func), GFP_KERNEL);
-	if (!func)
-		return NULL;
-
 	/* init */
-	INIT_LIST_HEAD(&func->list);
-	func->old_name = userfunc->old_name;
-	func->new_addr = (unsigned long)userfunc->new_func;
-	func->old_addr = userfunc->old_addr;
-	func->state = DISABLED;
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
-
-	if (!userfuncs)
-		return -EINVAL;
-
-	for (userfunc = userfuncs; userfunc->old_name; userfunc++) {
-		func = lpc_create_func(&obj->kobj, userfunc);
-		if (!func)
-			goto free;
-		list_add(&func->list, &obj->funcs);
-	}
-	return 0;
-free:
-	lpc_free_funcs(obj);
-	return -ENOMEM;
-}
-
-static struct lpc_object *lpc_create_object(struct kobject *root,
-					    struct lp_object *userobj)
-{
-	struct lpc_object *obj;
-	int ret;
-
-	/* alloc */
-	obj = kzalloc(sizeof(*obj), GFP_KERNEL);
-	if (!obj)
-		return NULL;
-
-	/* init */
-	INIT_LIST_HEAD(&obj->list);
-	obj->name = userobj->name;
-	obj->dynrelas = userobj->dynrelas;
-	obj->state = DISABLED;
-	/* obj->mod set by is_object_loaded() */
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
-
-	for (userobj = userobjs; userobj->name; userobj++) {
-		obj = lpc_create_object(&patch->kobj, userobj);
-		if (!obj)
-			goto free;
-		list_add(&obj->list, &patch->objs);
-	}
-	return 0;
-free:
-	lpc_free_objects(patch);
-	return -ENOMEM;
-}
-
-static int lpc_create_patch(struct lp_patch *userpatch)
-{
-	struct lpc_patch *patch;
-	int ret;
-
-	/* alloc */
-	patch = kzalloc(sizeof(*patch), GFP_KERNEL);
-	if (!patch)
-		return -ENOMEM;
-
-	/* init */
-	INIT_LIST_HEAD(&patch->list);
-	patch->userpatch = userpatch;
-	patch->mod = userpatch->mod;
-	patch->state = DISABLED;
-	INIT_LIST_HEAD(&patch->objs);
+	patch->state = LPC_DISABLED;
 
 	/* sysfs */
 	ret = kobject_init_and_add(&patch->kobj, &lpc_ktype_patch,
 				   lpc_root_kobj, patch->mod->name);
-	if (ret) {
-		kfree(patch);
-		return ret;
-	}
+	if (ret)
+		goto err_root;
 
-	/* create objects */
-	ret = lpc_create_objects(patch, userpatch->objs);
-	if (ret) {
-		kobject_put(&patch->kobj);
-		return ret;
+	/* create functions */
+	lpc_for_each_patch_func(patch, patch_func) {
+		patch_func->new_addr = (unsigned long)patch_func->new_func;
+		patch_func->state = LPC_DISABLED;
+		ops = &patch_func->fops;
+		ops->private = patch_func;
+		ops->func = lpc_ftrace_handler;
+		ops->flags = FTRACE_OPS_FL_SAVE_REGS | FTRACE_OPS_FL_DYNAMIC;
 	}
 
+	ret = sysfs_create_group(&patch->kobj, &lpc_patch_sysfs_group);
+	if (ret)
+		goto err_patch;
+
 	/* add to global list of patches */
 	list_add(&patch->list, &lpc_patches);
 
 	return 0;
+
+err_patch:
+	kobject_put(&patch->kobj);
+err_root:
+	return ret;
 }
 
 /************************************
  * register/unregister
  ***********************************/
 
-int lp_register_patch(struct lp_patch *userpatch)
+int lpc_register_patch(struct lpc_patch *userpatch)
 {
 	int ret;
 
-	if (!userpatch || !userpatch->mod || !userpatch->objs)
+	if (!userpatch || !userpatch->mod || !userpatch->funcs)
 		return -EINVAL;
 
 	/*
@@ -955,36 +708,26 @@ int lp_register_patch(struct lp_patch *userpatch)
 		return -ENODEV;
 
 	down(&lpc_mutex);
-	ret = lpc_create_patch(userpatch);
+	ret = lpc_init_patch(userpatch);
 	up(&lpc_mutex);
 	if (ret)
 		module_put(userpatch->mod);
 
 	return ret;
 }
-EXPORT_SYMBOL_GPL(lp_register_patch);
+EXPORT_SYMBOL_GPL(lpc_register_patch);
 
-int lp_unregister_patch(struct lp_patch *userpatch)
+int lpc_unregister_patch(struct lpc_patch *userpatch)
 {
-	struct lpc_patch *patch;
 	int ret = 0;
 
 	down(&lpc_mutex);
-	patch = lpc_find_patch(userpatch);
-	if (!patch) {
-		ret = -ENODEV;
-		goto out;
-	}
-	if (patch->state == ENABLED) {
-		ret = -EINVAL;
-		goto out;
-	}
-	lpc_free_patch(patch);
-out:
+	lpc_free_patch(userpatch);
 	up(&lpc_mutex);
+
 	return ret;
 }
-EXPORT_SYMBOL_GPL(lp_unregister_patch);
+EXPORT_SYMBOL_GPL(lpc_unregister_patch);
 
 /************************************
  * entry/exit
@@ -994,7 +737,7 @@ static int lpc_init(void)
 {
 	int ret;
 
-	ret = register_module_notifier(&lp_module_nb);
+	ret = register_module_notifier(&lpc_module_nb);
 	if (ret)
 		return ret;
 
@@ -1004,14 +747,14 @@ static int lpc_init(void)
 
 	return 0;
 unregister:
-	unregister_module_notifier(&lp_module_nb);
+	unregister_module_notifier(&lpc_module_nb);
 	return ret;
 }
 
 static void lpc_exit(void)
 {
 	lpc_remove_root_kobj();
-	unregister_module_notifier(&lp_module_nb);
+	unregister_module_notifier(&lpc_module_nb);
 }
 
 module_init(lpc_init);
-- 
2.1.2

