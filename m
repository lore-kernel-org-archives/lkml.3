Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422700AbaD3OcI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2014 10:32:08 -0400
Received: from ip4-83-240-18-248.cust.nbox.cz ([83.240.18.248]:52340 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759218AbaD3Oav (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2014 10:30:51 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: linux-kernel@vger.kernel.org
Cc: jirislaby@gmail.com, Vojtech Pavlik <vojtech@suse.cz>,
        Michael Matz <matz@suse.de>, Jiri Kosina <jkosina@suse.cz>,
        Jiri Slaby <jslaby@suse.cz>, Steven Rostedt <rostedt@goodmis.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>, Thomas Gleixner <tglx@linutronix.de>
Subject: [RFC 11/16] kgr: handle irqs
Date: Wed, 30 Apr 2014 16:30:44 +0200
Message-Id: <1398868249-26169-12-git-send-email-jslaby@suse.cz>
X-Mailer: git-send-email 1.9.2
In-Reply-To: <1398868249-26169-1-git-send-email-jslaby@suse.cz>
References: <1398868249-26169-1-git-send-email-jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Introduce a per-cpu flag to check whether we should use the old or new
function in the slow stub. The new functoins is being used on a
processor after a scheduled function sets the flag via
schedule_on_each_cpu. Presumably this happens in the process context,
no irq is running. And protect the flag setting by disable interrupts
so that we 1) have a barrier and 2) no interrupt triggers while
setting the flag (but the set should be atomic anyway as it is bool).

Signed-off-by: Jiri Slaby <jslaby@suse.cz>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
---
 arch/x86/include/asm/kgr.h |  4 +++-
 include/linux/kgr.h        |  5 +++--
 kernel/kgr.c               | 38 ++++++++++++++++++++++++++++++++------
 samples/kgr/kgr_patcher.c  |  2 +-
 4 files changed, 39 insertions(+), 10 deletions(-)

diff --git a/arch/x86/include/asm/kgr.h b/arch/x86/include/asm/kgr.h
index 49daa46243fc..f36661681b33 100644
--- a/arch/x86/include/asm/kgr.h
+++ b/arch/x86/include/asm/kgr.h
@@ -12,8 +12,10 @@ static void _new_function ##_stub_slow (unsigned long ip, unsigned long parent_i
 		struct ftrace_ops *ops, struct pt_regs *regs)		\
 {									\
 	struct kgr_loc_caches *c = ops->private;			\
+	bool irq = !!in_interrupt();					\
 									\
-	if (task_thread_info(current)->kgr_in_progress) {		\
+	if ((!irq && task_thread_info(current)->kgr_in_progress) ||	\
+			(irq && !*this_cpu_ptr(c->irq_use_new))) {	\
 		pr_info("kgr: slow stub: calling old code at %lx\n",	\
 				c->old);				\
 		regs->ip = c->old + MCOUNT_INSN_SIZE;			\
diff --git a/include/linux/kgr.h b/include/linux/kgr.h
index d72add7f3d5d..ebc6f5bc1ec1 100644
--- a/include/linux/kgr.h
+++ b/include/linux/kgr.h
@@ -19,7 +19,7 @@
 #endif
 
 struct kgr_patch {
-	char reserved;
+	bool __percpu *irq_use_new;
 	const struct kgr_patch_fun {
 		const char *name;
 		const char *new_name;
@@ -37,6 +37,7 @@ struct kgr_patch {
 struct kgr_loc_caches {
 	unsigned long old;
 	unsigned long new;
+	bool __percpu *irq_use_new;
 };
 
 #define KGR_PATCHED_FUNCTION(patch, _name, _new_function)			\
@@ -65,7 +66,7 @@ struct kgr_loc_caches {
 #define KGR_PATCH(name)		&__kgr_patch_ ## name
 #define KGR_PATCH_END		NULL
 
-extern int kgr_start_patching(const struct kgr_patch *);
+extern int kgr_start_patching(struct kgr_patch *);
 #endif /* CONFIG_KGR */
 
 #endif /* LINUX_KGR_H */
diff --git a/kernel/kgr.c b/kernel/kgr.c
index ea63e857a78a..ff5afaf6f0e7 100644
--- a/kernel/kgr.c
+++ b/kernel/kgr.c
@@ -18,6 +18,7 @@
 #include <linux/kallsyms.h>
 #include <linux/kgr.h>
 #include <linux/module.h>
+#include <linux/percpu.h>
 #include <linux/sched.h>
 #include <linux/slab.h>
 #include <linux/sort.h>
@@ -25,7 +26,8 @@
 #include <linux/types.h>
 #include <linux/workqueue.h>
 
-static int kgr_patch_code(const struct kgr_patch_fun *patch_fun, bool final);
+static int kgr_patch_code(const struct kgr_patch *patch,
+		const struct kgr_patch_fun *patch_fun, bool final);
 static void kgr_work_fn(struct work_struct *work);
 
 static struct workqueue_struct *kgr_wq;
@@ -57,7 +59,7 @@ static void kgr_finalize(void)
 	const struct kgr_patch_fun *const *patch_fun;
 
 	for (patch_fun = kgr_patch->patches; *patch_fun; patch_fun++) {
-		int ret = kgr_patch_code(*patch_fun, true);
+		int ret = kgr_patch_code(kgr_patch, *patch_fun, true);
 		/*
 		 * In case any of the symbol resolutions in the set
 		 * has failed, patch all the previously replaced fentry
@@ -67,6 +69,7 @@ static void kgr_finalize(void)
 			pr_err("kgr: finalize for %s failed, trying to continue\n",
 					(*patch_fun)->name);
 	}
+	free_percpu(kgr_patch->irq_use_new);
 }
 
 static void kgr_work_fn(struct work_struct *work)
@@ -139,6 +142,20 @@ static unsigned long kgr_get_fentry_loc(const char *f_name)
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
@@ -184,7 +201,8 @@ static int kgr_init_ftrace_ops(const struct kgr_patch_fun *patch_fun)
 	return 0;
 }
 
-static int kgr_patch_code(const struct kgr_patch_fun *patch_fun, bool final)
+static int kgr_patch_code(const struct kgr_patch *patch,
+		const struct kgr_patch_fun *patch_fun, bool final)
 {
 	struct ftrace_ops *new_ops;
 	struct kgr_loc_caches *caches;
@@ -205,6 +223,7 @@ static int kgr_patch_code(const struct kgr_patch_fun *patch_fun, bool final)
 
 	/* Flip the switch */
 	caches = new_ops->private;
+	caches->irq_use_new = patch->irq_use_new;
 	fentry_loc = caches->old;
 	err = ftrace_set_filter_ip(new_ops, fentry_loc, 0, 0);
 	if (err) {
@@ -243,9 +262,9 @@ static int kgr_patch_code(const struct kgr_patch_fun *patch_fun, bool final)
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
 
@@ -254,6 +273,12 @@ int kgr_start_patching(const struct kgr_patch *patch)
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
@@ -264,7 +289,7 @@ int kgr_start_patching(const struct kgr_patch *patch)
 	for (patch_fun = patch->patches; *patch_fun; patch_fun++) {
 		int ret;
 
-		ret = kgr_patch_code(*patch_fun, false);
+		ret = kgr_patch_code(patch, *patch_fun, false);
 		/*
 		 * In case any of the symbol resolutions in the set
 		 * has failed, patch all the previously replaced fentry
@@ -281,6 +306,7 @@ int kgr_start_patching(const struct kgr_patch *patch)
 	kgr_patch = patch;
 	mutex_unlock(&kgr_in_progress_lock);
 
+	kgr_handle_irqs();
 	kgr_handle_processes();
 
 	/*
diff --git a/samples/kgr/kgr_patcher.c b/samples/kgr/kgr_patcher.c
index 828543e36f3f..b1465cff8d5b 100644
--- a/samples/kgr/kgr_patcher.c
+++ b/samples/kgr/kgr_patcher.c
@@ -68,7 +68,7 @@ static bool new_capable(int cap)
 }
 KGR_PATCHED_FUNCTION(patch, capable, new_capable);
 
-static const struct kgr_patch patch = {
+static struct kgr_patch patch = {
 	.patches = {
 		KGR_PATCH(SyS_iopl),
 		KGR_PATCH(capable),
-- 
1.9.2

