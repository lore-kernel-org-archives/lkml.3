Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932270AbaFWN3p (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jun 2014 09:29:45 -0400
Received: from ip4-83-240-18-248.cust.nbox.cz ([83.240.18.248]:60779 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754500AbaFWN3i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jun 2014 09:29:38 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: linux-kernel@vger.kernel.org
Cc: jirislaby@gmail.com, Vojtech Pavlik <vojtech@suse.cz>,
        Jiri Kosina <jkosina@suse.cz>, Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 16/21] kgr: add support for missing functions
Date: Mon, 23 Jun 2014 15:29:30 +0200
Message-Id: <1403530175-29217-16-git-send-email-jslaby@suse.cz>
X-Mailer: git-send-email 2.0.0
In-Reply-To: <1403530175-29217-1-git-send-email-jslaby@suse.cz>
References: <1403530175-29217-1-git-send-email-jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sometimes we want to patch a function which is in a module that is not
currently loaded. In that case, patching would fail completely. So let
the user decide whether it is fatal when the function to be patched is
not found. If it is not, it is just skipped.  Other functions in the
patch (if any) are still patched in that case.

Note that this approach expects newly loaded modules to be fixed
already. No "deferred" patching happens on the module load.

Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 include/linux/kgraft.h          | 10 +++++++---
 kernel/kgraft.c                 | 26 ++++++++++++++++++--------
 samples/kgraft/kgraft_patcher.c |  4 ++--
 3 files changed, 27 insertions(+), 13 deletions(-)

diff --git a/include/linux/kgraft.h b/include/linux/kgraft.h
index 92b642408b6f..4d8665f60cbc 100644
--- a/include/linux/kgraft.h
+++ b/include/linux/kgraft.h
@@ -30,10 +30,13 @@
 
 struct kgr_patch {
 	bool __percpu *irq_use_new;
-	const struct kgr_patch_fun {
+	struct kgr_patch_fun {
 		const char *name;
 		const char *new_name;
 
+		bool abort_if_missing;
+		bool applied;
+
 		void *new_function;
 
 		struct ftrace_ops *ftrace_ops_slow;
@@ -51,16 +54,17 @@ struct kgr_loc_caches {
 	bool __percpu *irq_use_new;
 };
 
-#define KGR_PATCHED_FUNCTION(_name, _new_function)				\
+#define KGR_PATCHED_FUNCTION(_name, _new_function, abort)			\
 	static struct ftrace_ops __kgr_patch_ftrace_ops_slow_ ## _name = {	\
 		.flags = FTRACE_OPS_FL_SAVE_REGS,				\
 	};									\
 	static struct ftrace_ops __kgr_patch_ftrace_ops_fast_ ## _name = {	\
 		.flags = FTRACE_OPS_FL_SAVE_REGS,				\
 	};									\
-	static const struct kgr_patch_fun __kgr_patch_ ## _name = {		\
+	static struct kgr_patch_fun __kgr_patch_ ## _name = {			\
 		.name = #_name,							\
 		.new_name = #_new_function,					\
+		.abort_if_missing = abort,					\
 		.new_function = _new_function,					\
 		.ftrace_ops_slow = &__kgr_patch_ftrace_ops_slow_ ## _name,	\
 		.ftrace_ops_fast = &__kgr_patch_ftrace_ops_fast_ ## _name,	\
diff --git a/kernel/kgraft.c b/kernel/kgraft.c
index 0d04f1cbcd4a..6816da29a6a3 100644
--- a/kernel/kgraft.c
+++ b/kernel/kgraft.c
@@ -28,7 +28,7 @@
 #include <linux/workqueue.h>
 
 static int kgr_patch_code(const struct kgr_patch *patch,
-		const struct kgr_patch_fun *patch_fun, bool final);
+		struct kgr_patch_fun *patch_fun, bool final);
 static void kgr_work_fn(struct work_struct *work);
 
 static struct workqueue_struct *kgr_wq;
@@ -87,7 +87,7 @@ static bool kgr_still_patching(void)
 
 static void kgr_finalize(void)
 {
-	const struct kgr_patch_fun *const *patch_fun;
+	struct kgr_patch_fun *const *patch_fun;
 
 	for (patch_fun = kgr_patch->patches; *patch_fun; patch_fun++) {
 		int ret = kgr_patch_code(kgr_patch, *patch_fun, true);
@@ -240,7 +240,7 @@ free_caches:
 }
 
 static int kgr_patch_code(const struct kgr_patch *patch,
-		const struct kgr_patch_fun *patch_fun, bool final)
+		struct kgr_patch_fun *patch_fun, bool final)
 {
 	struct ftrace_ops *new_ops;
 	struct kgr_loc_caches *caches;
@@ -250,11 +250,16 @@ static int kgr_patch_code(const struct kgr_patch *patch,
 	/* Choose between slow and fast stub */
 	if (!final) {
 		err = kgr_init_ftrace_ops(patch_fun);
-		if (err)
+		if (err) {
+			if (err == -ENOENT && !patch_fun->abort_if_missing)
+				return 0;
 			return err;
+		}
 		pr_debug("kgr: patching %s to slow stub\n", patch_fun->name);
 		new_ops = patch_fun->ftrace_ops_slow;
 	} else {
+		if (!patch_fun->applied)
+			return 0;
 		pr_debug("kgr: patching %s to fast stub\n", patch_fun->name);
 		new_ops = patch_fun->ftrace_ops_fast;
 	}
@@ -290,7 +295,9 @@ static int kgr_patch_code(const struct kgr_patch *patch,
 			/* don't fail: we are only slower */
 			return 0;
 		}
-	}
+	} else
+		patch_fun->applied = true;
+
 	pr_debug("kgr: redirection for %lx (%s) done\n", fentry_loc,
 			patch_fun->name);
 
@@ -305,7 +312,7 @@ static int kgr_patch_code(const struct kgr_patch *patch,
  */
 int kgr_start_patching(struct kgr_patch *patch)
 {
-	const struct kgr_patch_fun *const *patch_fun;
+	struct kgr_patch_fun *const *patch_fun;
 	int ret;
 
 	if (!kgr_initialized) {
@@ -335,8 +342,11 @@ int kgr_start_patching(struct kgr_patch *patch)
 		 */
 		if (ret < 0) {
 			for (patch_fun--; patch_fun >= patch->patches;
-					patch_fun--)
-				unregister_ftrace_function((*patch_fun)->ftrace_ops_slow);
+					patch_fun--) {
+				if ((*patch_fun)->applied)
+					unregister_ftrace_function(
+						(*patch_fun)->ftrace_ops_slow);
+			}
 			goto unlock_free;
 		}
 	}
diff --git a/samples/kgraft/kgraft_patcher.c b/samples/kgraft/kgraft_patcher.c
index 7cb94f728128..5d02a908bc26 100644
--- a/samples/kgraft/kgraft_patcher.c
+++ b/samples/kgraft/kgraft_patcher.c
@@ -53,7 +53,7 @@ asmlinkage long kgr_new_sys_iopl(unsigned int level)
 
 	return 0;
 }
-KGR_PATCHED_FUNCTION(SyS_iopl, kgr_new_sys_iopl);
+KGR_PATCHED_FUNCTION(SyS_iopl, kgr_new_sys_iopl, true);
 
 static bool new_capable(int cap)
 {
@@ -61,7 +61,7 @@ static bool new_capable(int cap)
 
 	return ns_capable(&init_user_ns, cap);
 }
-KGR_PATCHED_FUNCTION(capable, new_capable);
+KGR_PATCHED_FUNCTION(capable, new_capable, true);
 
 static struct kgr_patch patch = {
 	.patches = {
-- 
2.0.0

