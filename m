Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753289AbbATP0q (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jan 2015 10:26:46 -0500
Received: from mx1.redhat.com ([209.132.183.28]:58410 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753186AbbATP0b (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jan 2015 10:26:31 -0500
From: Josh Poimboeuf <jpoimboe@redhat.com>
To: Seth Jennings <sjenning@redhat.com>, Jiri Kosina <jkosina@suse.cz>,
        Vojtech Pavlik <vojtech@suse.cz>
Cc: live-patching@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v2 2/2] livepatch: support for repatching a function
Date: Tue, 20 Jan 2015 09:26:19 -0600
Message-Id: <da0d4d3c34441efcd8e830c4c978016581d7f055.1421767360.git.jpoimboe@redhat.com>
In-Reply-To: <cover.1421767360.git.jpoimboe@redhat.com>
References: <cover.1421767360.git.jpoimboe@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add support for patching a function multiple times.  If multiple patches
affect a function, the function in the most recently enabled patch
"wins".  This enables a cumulative patch upgrade path, where each patch
is a superset of previous patches.

This requires restructuring the data a little bit.  With the current
design, where each klp_func struct has its own ftrace_ops, we'd have to
unregister the old ops and then register the new ops, because
FTRACE_OPS_FL_IPMODIFY prevents us from having two ops registered for
the same function at the same time.  That would leave a regression
window where the function isn't patched at all (not good for a patch
upgrade path).

This patch replaces the per-klp_func ftrace_ops with a global klp_ops
list, with one ftrace_ops per original function.  A single ftrace_ops is
shared between all klp_funcs which have the same old_addr.  This allows
the switch between function versions to happen instantaneously by
updating the klp_ops struct's func_stack list.  The winner is the
klp_func at the top of the func_stack (front of the list).

Signed-off-by: Josh Poimboeuf <jpoimboe@redhat.com>
---
 include/linux/livepatch.h |   4 +-
 kernel/livepatch/core.c   | 170 ++++++++++++++++++++++++++++++++--------------
 2 files changed, 121 insertions(+), 53 deletions(-)

diff --git a/include/linux/livepatch.h b/include/linux/livepatch.h
index 950bc61..f14c6fb 100644
--- a/include/linux/livepatch.h
+++ b/include/linux/livepatch.h
@@ -40,8 +40,8 @@ enum klp_state {
  * @old_addr:	a hint conveying at what address the old function
  *		can be found (optional, vmlinux patches only)
  * @kobj:	kobject for sysfs resources
- * @fops:	ftrace operations structure
  * @state:	tracks function-level patch application state
+ * @stack_node:	list node for klp_ops func_stack list
  */
 struct klp_func {
 	/* external */
@@ -59,8 +59,8 @@ struct klp_func {
 
 	/* internal */
 	struct kobject kobj;
-	struct ftrace_ops *fops;
 	enum klp_state state;
+	struct list_head stack_node;
 };
 
 /**
diff --git a/kernel/livepatch/core.c b/kernel/livepatch/core.c
index 2401e7f..2c137e8 100644
--- a/kernel/livepatch/core.c
+++ b/kernel/livepatch/core.c
@@ -29,17 +29,53 @@
 #include <linux/kallsyms.h>
 #include <linux/livepatch.h>
 
-/*
- * The klp_mutex protects the klp_patches list and state transitions of any
- * structure reachable from the patches list.  References to any structure must
- * be obtained under mutex protection.
+/**
+ * struct klp_ops - structure for tracking registered ftrace ops structs
+ *
+ * A single ftrace_ops is shared between all enabled replacement functions
+ * (klp_func structs) which have the same old_addr.  This allows the switch
+ * between function versions to happen instantaneously by updating the klp_ops
+ * struct's func_stack list.  The winner is the klp_func at the top of the
+ * func_stack (front of the list).
+ *
+ * @node:	node for the global klp_ops list
+ * @func_stack:	list head for the stack of klp_func's (active func is on top)
+ * @fops:	registered ftrace ops struct
  */
+struct klp_ops {
+	struct list_head node;
+	struct list_head func_stack;
+	struct ftrace_ops fops;
+};
 
+/*
+ * The klp_mutex protects the global lists and state transitions of any
+ * structure reachable from them.  References to any structure must be obtained
+ * under mutex protection (except in klp_ftrace_handler(), which uses RCU to
+ * ensure it gets consistent data).
+ */
 static DEFINE_MUTEX(klp_mutex);
+
 static LIST_HEAD(klp_patches);
+static LIST_HEAD(klp_ops);
 
 static struct kobject *klp_root_kobj;
 
+static struct klp_ops *klp_find_ops(unsigned long old_addr)
+{
+	struct klp_ops *ops;
+	struct klp_func *func;
+
+	list_for_each_entry(ops, &klp_ops, node) {
+		func = list_first_entry(&ops->func_stack, struct klp_func,
+					stack_node);
+		if (func->old_addr == old_addr)
+			return ops;
+	}
+
+	return NULL;
+}
+
 static bool klp_is_module(struct klp_object *obj)
 {
 	return obj->name;
@@ -267,16 +303,28 @@ static int klp_write_object_relocations(struct module *pmod,
 
 static void notrace klp_ftrace_handler(unsigned long ip,
 				       unsigned long parent_ip,
-				       struct ftrace_ops *ops,
+				       struct ftrace_ops *fops,
 				       struct pt_regs *regs)
 {
-	struct klp_func *func = ops->private;
+	struct klp_ops *ops;
+	struct klp_func *func;
+
+	ops = container_of(fops, struct klp_ops, fops);
+
+	rcu_read_lock();
+	func = list_first_or_null_rcu(&ops->func_stack, struct klp_func,
+				      stack_node);
+	rcu_read_unlock();
+
+	if (WARN_ON(!func))
+		return;
 
 	klp_arch_set_pc(regs, (unsigned long)func->new_func);
 }
 
 static int klp_disable_func(struct klp_func *func)
 {
+	struct klp_ops *ops;
 	int ret;
 
 	if (WARN_ON(func->state != KLP_ENABLED))
@@ -285,16 +333,28 @@ static int klp_disable_func(struct klp_func *func)
 	if (WARN_ON(!func->old_addr))
 		return -EINVAL;
 
-	ret = unregister_ftrace_function(func->fops);
-	if (ret) {
-		pr_err("failed to unregister ftrace handler for function '%s' (%d)\n",
-		       func->old_name, ret);
-		return ret;
-	}
+	ops = klp_find_ops(func->old_addr);
+	if (WARN_ON(!ops))
+		return -EINVAL;
 
-	ret = ftrace_set_filter_ip(func->fops, func->old_addr, 1, 0);
-	if (ret)
-		pr_warn("function unregister succeeded but failed to clear the filter\n");
+	if (list_is_singular(&ops->func_stack)) {
+		ret = unregister_ftrace_function(&ops->fops);
+		if (ret) {
+			pr_err("failed to unregister ftrace handler for function '%s' (%d)\n",
+			       func->old_name, ret);
+			return ret;
+		}
+
+		ret = ftrace_set_filter_ip(&ops->fops, func->old_addr, 1, 0);
+		if (ret)
+			pr_warn("function unregister succeeded but failed to clear the filter\n");
+
+		list_del_rcu(&func->stack_node);
+		list_del(&ops->node);
+		kfree(ops);
+	} else {
+		list_del_rcu(&func->stack_node);
+	}
 
 	func->state = KLP_DISABLED;
 
@@ -303,6 +363,7 @@ static int klp_disable_func(struct klp_func *func)
 
 static int klp_enable_func(struct klp_func *func)
 {
+	struct klp_ops *ops;
 	int ret;
 
 	if (WARN_ON(!func->old_addr))
@@ -311,22 +372,50 @@ static int klp_enable_func(struct klp_func *func)
 	if (WARN_ON(func->state != KLP_DISABLED))
 		return -EINVAL;
 
-	ret = ftrace_set_filter_ip(func->fops, func->old_addr, 0, 0);
-	if (ret) {
-		pr_err("failed to set ftrace filter for function '%s' (%d)\n",
-		       func->old_name, ret);
-		return ret;
-	}
+	ops = klp_find_ops(func->old_addr);
+	if (!ops) {
+		ops = kzalloc(sizeof(*ops), GFP_KERNEL);
+		if (!ops)
+			return -ENOMEM;
+
+		ops->fops.func = klp_ftrace_handler;
+		ops->fops.flags = FTRACE_OPS_FL_SAVE_REGS |
+				  FTRACE_OPS_FL_DYNAMIC |
+				  FTRACE_OPS_FL_IPMODIFY;
+
+		list_add(&ops->node, &klp_ops);
+
+		INIT_LIST_HEAD(&ops->func_stack);
+		list_add_rcu(&func->stack_node, &ops->func_stack);
+
+		ret = ftrace_set_filter_ip(&ops->fops, func->old_addr, 0, 0);
+		if (ret) {
+			pr_err("failed to set ftrace filter for function '%s' (%d)\n",
+			       func->old_name, ret);
+			goto err;
+		}
+
+		ret = register_ftrace_function(&ops->fops);
+		if (ret) {
+			pr_err("failed to register ftrace handler for function '%s' (%d)\n",
+			       func->old_name, ret);
+			ftrace_set_filter_ip(&ops->fops, func->old_addr, 1, 0);
+			goto err;
+		}
+
 
-	ret = register_ftrace_function(func->fops);
-	if (ret) {
-		pr_err("failed to register ftrace handler for function '%s' (%d)\n",
-		       func->old_name, ret);
-		ftrace_set_filter_ip(func->fops, func->old_addr, 1, 0);
 	} else {
-		func->state = KLP_ENABLED;
+		list_add_rcu(&func->stack_node, &ops->func_stack);
 	}
 
+	func->state = KLP_ENABLED;
+
+	return ret;
+
+err:
+	list_del_rcu(&func->stack_node);
+	list_del(&ops->node);
+	kfree(ops);
 	return ret;
 }
 
@@ -582,10 +671,6 @@ static struct kobj_type klp_ktype_patch = {
 
 static void klp_kobj_release_func(struct kobject *kobj)
 {
-	struct klp_func *func;
-
-	func = container_of(kobj, struct klp_func, kobj);
-	kfree(func->fops);
 }
 
 static struct kobj_type klp_ktype_func = {
@@ -642,28 +727,11 @@ static void klp_free_patch(struct klp_patch *patch)
 
 static int klp_init_func(struct klp_object *obj, struct klp_func *func)
 {
-	struct ftrace_ops *ops;
-	int ret;
-
-	ops = kzalloc(sizeof(*ops), GFP_KERNEL);
-	if (!ops)
-		return -ENOMEM;
-
-	ops->private = func;
-	ops->func = klp_ftrace_handler;
-	ops->flags = FTRACE_OPS_FL_SAVE_REGS | FTRACE_OPS_FL_DYNAMIC |
-		     FTRACE_OPS_FL_IPMODIFY;
-	func->fops = ops;
+	INIT_LIST_HEAD(&func->stack_node);
 	func->state = KLP_DISABLED;
 
-	ret = kobject_init_and_add(&func->kobj, &klp_ktype_func,
-				   obj->kobj, func->old_name);
-	if (ret) {
-		kfree(func->fops);
-		return ret;
-	}
-
-	return 0;
+	return kobject_init_and_add(&func->kobj, &klp_ktype_func,
+				    obj->kobj, func->old_name);
 }
 
 /* parts of the initialization that is done only when the object is loaded */
-- 
2.1.0

