Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756588AbaFYLH7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jun 2014 07:07:59 -0400
Received: from ip4-83-240-18-248.cust.nbox.cz ([83.240.18.248]:41125 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756269AbaFYLHR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jun 2014 07:07:17 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: linux-kernel@vger.kernel.org
Cc: tj@kernel.org, rostedt@goodmis.org, mingo@redhat.com,
        akpm@linux-foundation.org, andi@firstfloor.org,
        paulmck@linux.vnet.ibm.com, pavel@ucw.cz, jirislaby@gmail.com,
        Vojtech Pavlik <vojtech@suse.cz>, Michael Matz <matz@suse.de>,
        Jiri Kosina <jkosina@suse.cz>, Jiri Slaby <jslaby@suse.cz>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH -repost 11/21] kgr: handle irqs
Date: Wed, 25 Jun 2014 13:07:05 +0200
Message-Id: <1403694435-3180-11-git-send-email-jslaby@suse.cz>
X-Mailer: git-send-email 2.0.0
In-Reply-To: <1403694435-3180-1-git-send-email-jslaby@suse.cz>
References: <1403694435-3180-1-git-send-email-jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Introduce a per-cpu flag to check whether we should use the old or new
function in the slow stub. The new function starts being used on a
processor only after a scheduled function sets the flag via
schedule_on_each_cpu. Presumably this happens in the process context,
no irq is running. And protect the flag setting by disabling
interrupts so that we 1) have a barrier and 2) no interrupt triggers
while setting the flag (but the set should be atomic anyway as it is
bool).

js: fix fail paths

Signed-off-by: Jiri Slaby <jslaby@suse.cz>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
---
 include/linux/kgraft.h          |  6 +++--
 kernel/kgraft.c                 | 59 ++++++++++++++++++++++++++++++++---------
 samples/kgraft/kgraft_patcher.c |  2 +-
 3 files changed, 51 insertions(+), 16 deletions(-)

diff --git a/include/linux/kgraft.h b/include/linux/kgraft.h
index e87623fe74ad..93bb1c50e079 100644
--- a/include/linux/kgraft.h
+++ b/include/linux/kgraft.h
@@ -18,6 +18,7 @@
 #define LINUX_KGR_H
 
 #include <linux/bitops.h>
+#include <linux/compiler.h>
 #include <linux/ftrace.h>
 #include <linux/sched.h>
 
@@ -28,7 +29,7 @@
 #define KGR_TIMEOUT 30
 
 struct kgr_patch {
-	char reserved;
+	bool __percpu *irq_use_new;
 	const struct kgr_patch_fun {
 		const char *name;
 		const char *new_name;
@@ -47,6 +48,7 @@ struct kgr_patch {
 struct kgr_loc_caches {
 	unsigned long old;
 	unsigned long new;
+	bool __percpu *irq_use_new;
 };
 
 #define KGR_PATCHED_FUNCTION(_name, _new_function)				\
@@ -67,7 +69,7 @@ struct kgr_loc_caches {
 #define KGR_PATCH(name)		&__kgr_patch_ ## name
 #define KGR_PATCH_END		NULL
 
-extern int kgr_start_patching(const struct kgr_patch *);
+extern int kgr_start_patching(struct kgr_patch *);
 
 static inline void kgr_mark_task_in_progress(struct task_struct *p)
 {
diff --git a/kernel/kgraft.c b/kernel/kgraft.c
index d21eaad8d48d..fd0ded7ce725 100644
--- a/kernel/kgraft.c
+++ b/kernel/kgraft.c
@@ -15,9 +15,11 @@
  */
 
 #include <linux/ftrace.h>
+#include <linux/hardirq.h> /* for in_interrupt() */
 #include <linux/kallsyms.h>
 #include <linux/kgraft.h>
 #include <linux/module.h>
+#include <linux/percpu.h>
 #include <linux/sched.h>
 #include <linux/slab.h>
 #include <linux/sort.h>
@@ -25,7 +27,8 @@
 #include <linux/types.h>
 #include <linux/workqueue.h>
 
-static int kgr_patch_code(const struct kgr_patch_fun *patch_fun, bool final);
+static int kgr_patch_code(const struct kgr_patch *patch,
+		const struct kgr_patch_fun *patch_fun, bool final);
 static void kgr_work_fn(struct work_struct *work);
 
 static struct workqueue_struct *kgr_wq;
@@ -52,8 +55,10 @@ static void kgr_stub_slow(unsigned long ip, unsigned long parent_ip,
 		struct ftrace_ops *ops, struct pt_regs *regs)
 {
 	struct kgr_loc_caches *c = ops->private;
+	bool irq = !!in_interrupt();
 
-	if (kgr_task_in_progress(current)) {
+	if ((!irq && kgr_task_in_progress(current)) ||
+			(irq && !*this_cpu_ptr(c->irq_use_new))) {
 		pr_info("kgr: slow stub: calling old code at %lx\n",
 				c->old);
 		kgr_set_regs_ip(regs, c->old + MCOUNT_INSN_SIZE);
@@ -86,7 +91,7 @@ static void kgr_finalize(void)
 	const struct kgr_patch_fun *const *patch_fun;
 
 	for (patch_fun = kgr_patch->patches; *patch_fun; patch_fun++) {
-		int ret = kgr_patch_code(*patch_fun, true);
+		int ret = kgr_patch_code(kgr_patch, *patch_fun, true);
 		/*
 		 * In case any of the symbol resolutions in the set
 		 * has failed, patch all the previously replaced fentry
@@ -96,6 +101,7 @@ static void kgr_finalize(void)
 			pr_err("kgr: finalize for %s failed, trying to continue\n",
 					(*patch_fun)->name);
 	}
+	free_percpu(kgr_patch->irq_use_new);
 }
 
 static void kgr_work_fn(struct work_struct *work)
@@ -167,6 +173,20 @@ static unsigned long kgr_get_fentry_loc(const char *f_name)
 	return fentry_loc;
 }
 
+static void kgr_handle_irq_cpu(struct work_struct *work)
+{
+	unsigned long flags;
+
+	local_irq_save(flags);
+	*this_cpu_ptr(kgr_patch->irq_use_new) = true;
+	local_irq_restore(flags);
+}
+
+static void kgr_handle_irqs(void)
+{
+	schedule_on_each_cpu(kgr_handle_irq_cpu);
+}
+
 static int kgr_init_ftrace_ops(const struct kgr_patch_fun *patch_fun)
 {
 	struct kgr_loc_caches *caches;
@@ -220,7 +240,8 @@ free_caches:
 	return ret;
 }
 
-static int kgr_patch_code(const struct kgr_patch_fun *patch_fun, bool final)
+static int kgr_patch_code(const struct kgr_patch *patch,
+		const struct kgr_patch_fun *patch_fun, bool final)
 {
 	struct ftrace_ops *new_ops;
 	struct kgr_loc_caches *caches;
@@ -241,6 +262,7 @@ static int kgr_patch_code(const struct kgr_patch_fun *patch_fun, bool final)
 
 	/* Flip the switch */
 	caches = new_ops->private;
+	caches->irq_use_new = patch->irq_use_new;
 	fentry_loc = caches->old;
 	err = ftrace_set_filter_ip(new_ops, fentry_loc, 0, 0);
 	if (err) {
@@ -280,28 +302,33 @@ static int kgr_patch_code(const struct kgr_patch_fun *patch_fun, bool final)
  * kgr_start_patching -- the entry for a kgraft patch
  * @patch: patch to be applied
  *
- * Start patching of code that is not running in IRQ context.
+ * Start patching of code.
  */
-int kgr_start_patching(const struct kgr_patch *patch)
+int kgr_start_patching(struct kgr_patch *patch)
 {
 	const struct kgr_patch_fun *const *patch_fun;
+	int ret;
 
 	if (!kgr_initialized) {
 		pr_err("kgr: can't patch, not initialized\n");
 		return -EINVAL;
 	}
 
+	patch->irq_use_new = alloc_percpu(bool);
+	if (!patch->irq_use_new) {
+		pr_err("kgr: can't patch, cannot allocate percpu data\n");
+		return -ENOMEM;
+	}
+
 	mutex_lock(&kgr_in_progress_lock);
 	if (kgr_in_progress) {
 		pr_err("kgr: can't patch, another patching not yet finalized\n");
-		mutex_unlock(&kgr_in_progress_lock);
-		return -EAGAIN;
+		ret = -EAGAIN;
+		goto unlock_free;
 	}
 
 	for (patch_fun = patch->patches; *patch_fun; patch_fun++) {
-		int ret;
-
-		ret = kgr_patch_code(*patch_fun, false);
+		ret = kgr_patch_code(patch, *patch_fun, false);
 		/*
 		 * In case any of the symbol resolutions in the set
 		 * has failed, patch all the previously replaced fentry
@@ -311,14 +338,14 @@ int kgr_start_patching(const struct kgr_patch *patch)
 			for (patch_fun--; patch_fun >= patch->patches;
 					patch_fun--)
 				unregister_ftrace_function((*patch_fun)->ftrace_ops_slow);
-			mutex_unlock(&kgr_in_progress_lock);
-			return ret;
+			goto unlock_free;
 		}
 	}
 	kgr_in_progress = true;
 	kgr_patch = patch;
 	mutex_unlock(&kgr_in_progress_lock);
 
+	kgr_handle_irqs();
 	kgr_handle_processes();
 
 	/*
@@ -327,6 +354,12 @@ int kgr_start_patching(const struct kgr_patch *patch)
 	queue_delayed_work(kgr_wq, &kgr_work, 5 * HZ);
 
 	return 0;
+unlock_free:
+	mutex_unlock(&kgr_in_progress_lock);
+
+	free_percpu(patch->irq_use_new);
+
+	return ret;
 }
 EXPORT_SYMBOL_GPL(kgr_start_patching);
 
diff --git a/samples/kgraft/kgraft_patcher.c b/samples/kgraft/kgraft_patcher.c
index abb0c05bf739..7cb94f728128 100644
--- a/samples/kgraft/kgraft_patcher.c
+++ b/samples/kgraft/kgraft_patcher.c
@@ -63,7 +63,7 @@ static bool new_capable(int cap)
 }
 KGR_PATCHED_FUNCTION(capable, new_capable);
 
-static const struct kgr_patch patch = {
+static struct kgr_patch patch = {
 	.patches = {
 		KGR_PATCH(SyS_iopl),
 		KGR_PATCH(capable),
-- 
2.0.0

