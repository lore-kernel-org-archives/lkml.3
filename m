Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751626AbaLISGI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Dec 2014 13:06:08 -0500
Received: from cantor2.suse.de ([195.135.220.15]:53876 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751389AbaLISGF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Dec 2014 13:06:05 -0500
From: Petr Mladek <pmladek@suse.cz>
To: Seth Jennings <sjenning@redhat.com>, Josh Poimboeuf <jpoimboe@redhat.com>,
        Jiri Kosina <jkosina@suse.cz>, Vojtech Pavlik <vojtech@suse.cz>,
        Steven Rostedt <rostedt@goodmis.org>, Miroslav Benes <mbenes@suse.cz>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: Christoph Hellwig <hch@infradead.org>,
        Greg KH <gregkh@linuxfoundation.org>,
        Andy Lutomirski <luto@amacapital.net>, live-patching@vger.kernel.org,
        x86@kernel.org, kpatch@redhat.com, linux-kernel@vger.kernel.org,
        Petr Mladek <pmladek@suse.cz>
Subject: [PATCH 4/6] livepatch v5: clean up ordering of functions
Date: Tue,  9 Dec 2014 19:05:05 +0100
Message-Id: <1418148307-21434-5-git-send-email-pmladek@suse.cz>
X-Mailer: git-send-email 1.8.5.2
In-Reply-To: <1418148307-21434-1-git-send-email-pmladek@suse.cz>
References: <1418148307-21434-1-git-send-email-pmladek@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patches switch the order of functions:

  + lp_enable_func() <-> lp_disable_func()
  + klp_register_patch() <-> klp_unregister_patch()

It makes it consistent with the rest of the functions. The functions are defined
in the order:

  + klp_disable_*()
  + klp_enable_*()

  + klp_free_*()
  + klp_init_*()

  + klp_unregister_*()
  + klp_register_*()

The patch also moves the module notification handling after the klp_init*()
functions. It will allow to split the common code into __klp_init*() functions
and reduce copy&paste stuff.

Signed-off-by: Petr Mladek <pmladek@suse.cz>
---
 kernel/livepatch/core.c | 282 ++++++++++++++++++++++++------------------------
 1 file changed, 141 insertions(+), 141 deletions(-)

diff --git a/kernel/livepatch/core.c b/kernel/livepatch/core.c
index 54bb39d3abb5..97a8d4a3d6d8 100644
--- a/kernel/livepatch/core.c
+++ b/kernel/livepatch/core.c
@@ -280,59 +280,59 @@ static void notrace klp_ftrace_handler(unsigned long ip,
 	regs->ip = (unsigned long)func->new_func;
 }
 
-static int klp_enable_func(struct klp_func *func)
+static int klp_disable_func(struct klp_func *func)
 {
 	int ret;
 
-	if (WARN_ON(!func->old_addr))
+	if (WARN_ON(func->state != KLP_ENABLED))
 		return -EINVAL;
 
-	if (WARN_ON(func->state != KLP_DISABLED))
+	if (WARN_ON(!func->old_addr))
 		return -EINVAL;
 
-	ret = ftrace_set_filter_ip(func->fops, func->old_addr, 0, 0);
+	ret = unregister_ftrace_function(func->fops);
 	if (ret) {
-		pr_err("failed to set ftrace filter for function '%s' (%d)\n",
+		pr_err("failed to unregister ftrace handler for function '%s' (%d)\n",
 		       func->old_name, ret);
 		return ret;
 	}
 
-	ret = register_ftrace_function(func->fops);
-	if (ret) {
-		pr_err("failed to register ftrace handler for function '%s' (%d)\n",
-		       func->old_name, ret);
-		ftrace_set_filter_ip(func->fops, func->old_addr, 1, 0);
-	} else {
-		func->state = KLP_ENABLED;
-	}
+	ret = ftrace_set_filter_ip(func->fops, func->old_addr, 1, 0);
+	if (ret)
+		pr_warn("function unregister succeeded but failed to clear the filter\n");
 
-	return ret;
+	func->state = KLP_DISABLED;
+
+	return 0;
 }
 
-static int klp_disable_func(struct klp_func *func)
+static int klp_enable_func(struct klp_func *func)
 {
 	int ret;
 
-	if (WARN_ON(func->state != KLP_ENABLED))
+	if (WARN_ON(!func->old_addr))
 		return -EINVAL;
 
-	if (WARN_ON(!func->old_addr))
+	if (WARN_ON(func->state != KLP_DISABLED))
 		return -EINVAL;
 
-	ret = unregister_ftrace_function(func->fops);
+	ret = ftrace_set_filter_ip(func->fops, func->old_addr, 0, 0);
 	if (ret) {
-		pr_err("failed to unregister ftrace handler for function '%s' (%d)\n",
+		pr_err("failed to set ftrace filter for function '%s' (%d)\n",
 		       func->old_name, ret);
 		return ret;
 	}
 
-	ret = ftrace_set_filter_ip(func->fops, func->old_addr, 1, 0);
-	if (ret)
-		pr_warn("function unregister succeeded but failed to clear the filter\n");
-
-	func->state = KLP_DISABLED;
+	ret = register_ftrace_function(func->fops);
+	if (ret) {
+		pr_err("failed to register ftrace handler for function '%s' (%d)\n",
+		       func->old_name, ret);
+		ftrace_set_filter_ip(func->fops, func->old_addr, 1, 0);
+	} else {
+		func->state = KLP_ENABLED;
+	}
 
-	return 0;
+	return ret;
 }
 
 static int klp_disable_object(struct klp_object *obj)
@@ -504,98 +504,6 @@ err:
 }
 EXPORT_SYMBOL_GPL(klp_enable_patch);
 
-static void klp_module_notify_coming(struct module *pmod,
-				     struct klp_object *obj)
-{
-	struct klp_func *func;
-	struct module *mod = obj->mod;
-	int ret;
-
-	pr_notice("applying patch '%s' to loading module '%s'\n",
-		  pmod->name, mod->name);
-
-	if (obj->relocs) {
-		ret = klp_write_object_relocations(pmod, obj);
-		if (ret)
-			goto err;
-	}
-
-	for (func = obj->funcs; func->old_name; func++) {
-		ret = klp_find_verify_func_addr(obj, func);
-		if (ret)
-			goto err;
-	}
-
-	ret = klp_enable_object(obj);
-	if (!ret)
-		return;
-
-err:
-	pr_warn("failed to apply patch '%s' to module '%s' (%d)\n",
-		pmod->name, mod->name, ret);
-}
-
-static void klp_module_notify_going(struct module *pmod,
-				    struct klp_object *obj)
-{
-	struct klp_func *func;
-	struct module *mod = obj->mod;
-	int ret;
-
-	pr_notice("reverting patch '%s' on unloading module '%s'\n",
-		  pmod->name, mod->name);
-
-	ret = klp_disable_object(obj);
-	if (ret)
-		pr_warn("failed to revert patch '%s' on module '%s' (%d)\n",
-			pmod->name, mod->name, ret);
-
-	for (func = obj->funcs; func->old_name; func++)
-		func->old_addr = 0;
-
-	obj->mod = NULL;
-}
-
-static int klp_module_notify(struct notifier_block *nb, unsigned long action,
-			     void *data)
-{
-	struct module *mod = data;
-	struct klp_patch *patch;
-	struct klp_object *obj;
-
-	if (action != MODULE_STATE_COMING && action != MODULE_STATE_GOING)
-		return 0;
-
-	mutex_lock(&klp_mutex);
-
-	list_for_each_entry(patch, &klp_patches, list) {
-		if (patch->state == KLP_DISABLED)
-			continue;
-
-		for (obj = patch->objs; obj->funcs; obj++) {
-			if (!klp_is_module(obj) || strcmp(obj->name, mod->name))
-				continue;
-
-			if (action == MODULE_STATE_COMING) {
-				obj->mod = mod;
-				klp_module_notify_coming(patch->mod, obj);
-			} else /* MODULE_STATE_GOING */
-				klp_module_notify_going(patch->mod, obj);
-
-			break;
-		}
-	}
-
-	mutex_unlock(&klp_mutex);
-
-	return 0;
-}
-
-static struct notifier_block klp_module_nb = {
-	.notifier_call = klp_module_notify,
-	.priority = INT_MIN+1, /* called late but before ftrace notifier */
-};
-
 /*
  * Sysfs Interface
  *
@@ -823,6 +731,41 @@ unlock:
 }
 
 /**
+ * klp_unregister_patch() - unregisters a patch
+ * @patch:	Disabled patch to be unregistered
+ *
+ * Frees the data structures and removes the sysfs interface.
+ *
+ * Return: 0 on success, otherwise error
+ */
+int klp_unregister_patch(struct klp_patch *patch)
+{
+	int ret = 0;
+
+	if (!klp_is_enabled())
+		return -ENODEV;
+
+	mutex_lock(&klp_mutex);
+
+	if (!klp_patch_is_registered(patch)) {
+		ret = -EINVAL;
+		goto out;
+	}
+
+	if (patch->state == KLP_ENABLED) {
+		ret = -EBUSY;
+		goto out;
+	}
+
+	klp_free_patch(patch);
+
+out:
+	mutex_unlock(&klp_mutex);
+	return ret;
+}
+EXPORT_SYMBOL_GPL(klp_unregister_patch);
+
+/**
  * klp_register_patch() - registers a patch
  * @patch:	Patch to be registered
  *
@@ -859,40 +802,97 @@ int klp_register_patch(struct klp_patch *patch)
 }
 EXPORT_SYMBOL_GPL(klp_register_patch);
 
-/**
- * klp_unregister_patch() - unregisters a patch
- * @patch:	Disabled patch to be unregistered
- *
- * Frees the data structures and removes the sysfs interface.
- *
- * Return: 0 on success, otherwise error
- */
-int klp_unregister_patch(struct klp_patch *patch)
+static void klp_module_notify_coming(struct module *pmod,
+				     struct klp_object *obj)
 {
-	int ret = 0;
-
-	if (!klp_is_enabled())
-		return -ENODEV;
+	struct klp_func *func;
+	struct module *mod = obj->mod;
+	int ret;
 
-	mutex_lock(&klp_mutex);
+	pr_notice("applying patch '%s' to loading module '%s'\n",
+		  pmod->name, mod->name);
 
-	if (!klp_patch_is_registered(patch)) {
-		ret = -EINVAL;
-		goto out;
+	if (obj->relocs) {
+		ret = klp_write_object_relocations(pmod, obj);
+		if (ret)
+			goto err;
 	}
 
-	if (patch->state == KLP_ENABLED) {
-		ret = -EBUSY;
-		goto out;
+	for (func = obj->funcs; func->old_name; func++) {
+		ret = klp_find_verify_func_addr(obj, func);
+		if (ret)
+			goto err;
 	}
 
-	klp_free_patch(patch);
+	ret = klp_enable_object(obj);
+	if (!ret)
+		return;
+
+err:
+	pr_warn("failed to apply patch '%s' to module '%s' (%d)\n",
+		pmod->name, mod->name, ret);
+}
+
+static void klp_module_notify_going(struct module *pmod,
+				    struct klp_object *obj)
+{
+	struct klp_func *func;
+	struct module *mod = obj->mod;
+	int ret;
+
+	pr_notice("reverting patch '%s' on unloading module '%s'\n",
+		  pmod->name, mod->name);
+
+	ret = klp_disable_object(obj);
+	if (ret)
+		pr_warn("failed to revert patch '%s' on module '%s' (%d)\n",
+			pmod->name, mod->name, ret);
+
+	for (func = obj->funcs; func->old_name; func++)
+		func->old_addr = 0;
+
+	obj->mod = NULL;
+}
+
+static int klp_module_notify(struct notifier_block *nb, unsigned long action,
+			     void *data)
+{
+	struct module *mod = data;
+	struct klp_patch *patch;
+	struct klp_object *obj;
+
+	if (action != MODULE_STATE_COMING && action != MODULE_STATE_GOING)
+		return 0;
+
+	mutex_lock(&klp_mutex);
+
+	list_for_each_entry(patch, &klp_patches, list) {
+		if (patch->state == KLP_DISABLED)
+			continue;
+
+		for (obj = patch->objs; obj->funcs; obj++) {
+			if (!klp_is_module(obj) || strcmp(obj->name, mod->name))
+				continue;
+
+			if (action == MODULE_STATE_COMING) {
+				obj->mod = mod;
+				klp_module_notify_coming(patch->mod, obj);
+			} else /* MODULE_STATE_GOING */
+				klp_module_notify_going(patch->mod, obj);
+
+			break;
+		}
+	}
 
-out:
 	mutex_unlock(&klp_mutex);
-	return ret;
+
+	return 0;
 }
-EXPORT_SYMBOL_GPL(klp_unregister_patch);
+
+static struct notifier_block klp_module_nb = {
+	.notifier_call = klp_module_notify,
+	.priority = INT_MIN+1, /* called late but before ftrace notifier */
+};
 
 static int klp_init(void)
 {
-- 
1.8.5.2

