Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755424AbaJWLa7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Oct 2014 07:30:59 -0400
Received: from mail9.hitachi.co.jp ([133.145.228.44]:56243 "EHLO
	mail9.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755235AbaJWLa4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Oct 2014 07:30:56 -0400
Subject: [PATCH v2 5/5] module: Remove stop_machine from module unloading
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: Lucas De Marchi <lucas.demarchi@intel.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Josh Poimboeuf <jpoimboe@redhat.com>
Date: Thu, 23 Oct 2014 15:27:11 -0400
Message-ID: <20141023192711.10463.53532.stgit@localhost.localdomain>
In-Reply-To: <20141023192636.10463.45031.stgit@localhost.localdomain>
References: <20141023192636.10463.45031.stgit@localhost.localdomain>
User-Agent: StGit/0.17-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove stop_machine from module unloading by adding new reference
counting algorithm.

This atomic refcounter works like a semaphore, it can get (be
incremented) only when the counter is not 0. When loading a module,
kmodule subsystem sets the counter MODULE_REF_BASE (= 1). And when
unloading the module, it subtracts MODULE_REF_BASE from the counter.
If no one refers the module, the refcounter becomes 0 and we can
remove the module safely. If someone referes it, we try to recover
the counter by adding MODULE_REF_BASE unless the counter becomes 0,
because the referrer can put the module right before recovering.
If the recovering is failed, we can get the 0 refcount and it
never be incremented again, it can be removed safely too.

Note that __module_get() forcibly gets the module refcounter,
users should use try_module_get() instead of that.

Signed-off-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
---
 kernel/module.c |   67 ++++++++++++++++++++++++++++++++-----------------------
 1 file changed, 39 insertions(+), 28 deletions(-)

diff --git a/kernel/module.c b/kernel/module.c
index b1d485d..e772595 100644
--- a/kernel/module.c
+++ b/kernel/module.c
@@ -42,7 +42,6 @@
 #include <linux/vermagic.h>
 #include <linux/notifier.h>
 #include <linux/sched.h>
-#include <linux/stop_machine.h>
 #include <linux/device.h>
 #include <linux/string.h>
 #include <linux/mutex.h>
@@ -98,7 +97,7 @@
  * 1) List of modules (also safely readable with preempt_disable),
  * 2) module_use links,
  * 3) module_addr_min/module_addr_max.
- * (delete uses stop_machine/add uses RCU list operations). */
+ * (delete and add uses RCU list operations). */
 DEFINE_MUTEX(module_mutex);
 EXPORT_SYMBOL_GPL(module_mutex);
 static LIST_HEAD(modules);
@@ -628,14 +627,23 @@ static char last_unloaded_module[MODULE_NAME_LEN+1];
 
 EXPORT_TRACEPOINT_SYMBOL(module_get);
 
+/* MODULE_REF_BASE is the base reference count by kmodule loader. */
+#define MODULE_REF_BASE	1
+
 /* Init the unload section of the module. */
 static int module_unload_init(struct module *mod)
 {
+	/*
+	 * Initialize reference counter to MODULE_REF_BASE.
+	 * refcnt == 0 means module is going.
+	 */
+	atomic_set(&mod->refcnt, MODULE_REF_BASE);
+
 	INIT_LIST_HEAD(&mod->source_list);
 	INIT_LIST_HEAD(&mod->target_list);
 
 	/* Hold reference count during initialization. */
-	atomic_set(&mod->refcnt, 1);
+	atomic_inc(&mod->refcnt);
 
 	return 0;
 }
@@ -734,39 +742,39 @@ static inline int try_force_unload(unsigned int flags)
 }
 #endif /* CONFIG_MODULE_FORCE_UNLOAD */
 
-struct stopref
+/* Try to release refcount of module, 0 means success. */
+static int try_release_module_ref(struct module *mod)
 {
-	struct module *mod;
-	int flags;
-	int *forced;
-};
+	int ret;
 
-/* Whole machine is stopped with interrupts off when this runs. */
-static int __try_stop_module(void *_sref)
-{
-	struct stopref *sref = _sref;
+	/* Try to decrement refcnt which we set at loading */
+	ret = atomic_sub_return(MODULE_REF_BASE, &mod->refcnt);
+	BUG_ON(ret < 0);
+	if (ret)
+		/* Someone can put this right now, recover with checking */
+		ret = atomic_add_unless(&mod->refcnt, MODULE_REF_BASE, 0);
+
+	return ret;
+}
 
+static int try_stop_module(struct module *mod, int flags, int *forced)
+{
 	/* If it's not unused, quit unless we're forcing. */
-	if (module_refcount(sref->mod) != 0) {
-		if (!(*sref->forced = try_force_unload(sref->flags)))
+	if (try_release_module_ref(mod) != 0) {
+		*forced = try_force_unload(flags);
+		if (!(*forced))
 			return -EWOULDBLOCK;
 	}
 
 	/* Mark it as dying. */
-	sref->mod->state = MODULE_STATE_GOING;
-	return 0;
-}
-
-static int try_stop_module(struct module *mod, int flags, int *forced)
-{
-	struct stopref sref = { mod, flags, forced };
+	mod->state = MODULE_STATE_GOING;
 
-	return stop_machine(__try_stop_module, &sref, NULL);
+	return 0;
 }
 
 unsigned long module_refcount(struct module *mod)
 {
-	return (unsigned long)atomic_read(&mod->refcnt);
+	return (unsigned long)atomic_read(&mod->refcnt) - MODULE_REF_BASE;
 }
 EXPORT_SYMBOL(module_refcount);
 
@@ -921,11 +929,11 @@ bool try_module_get(struct module *module)
 
 	if (module) {
 		preempt_disable();
-
-		if (likely(module_is_live(module))) {
-			atomic_inc(&module->refcnt);
+		/* Note: here, we can fail to get a reference */
+		if (likely(module_is_live(module) &&
+			   atomic_inc_not_zero(&module->refcnt) != 0))
 			trace_module_get(module, _RET_IP_);
-		} else
+		else
 			ret = false;
 
 		preempt_enable();
@@ -936,9 +944,12 @@ EXPORT_SYMBOL(try_module_get);
 
 void module_put(struct module *module)
 {
+	int ret;
+
 	if (module) {
 		preempt_disable();
-		atomic_dec(&module->refcnt);
+		ret = atomic_dec_if_positive(&module->refcnt);
+		WARN_ON(ret < 0);	/* Failed to put refcount */
 		trace_module_put(module, _RET_IP_);
 		preempt_enable();
 	}


