Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754788AbaFIJPG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jun 2014 05:15:06 -0400
Received: from ip4-83-240-18-248.cust.nbox.cz ([83.240.18.248]:58391 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754819AbaFIIvY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jun 2014 04:51:24 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
        "Steven Rostedt (Red Hat)" <rostedt@goodmis.org>,
        Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 014/146] ftrace/module: Hardcode ftrace_module_init() call into load_module()
Date: Mon,  9 Jun 2014 10:49:09 +0200
Message-Id: <e412bbae04b318bfea7c623ad261c84681c021fe.1402303820.git.jslaby@suse.cz>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <ebe219e45dcf94c1a34281167427cff4d742faef.1402303820.git.jslaby@suse.cz>
References: <ebe219e45dcf94c1a34281167427cff4d742faef.1402303820.git.jslaby@suse.cz>
In-Reply-To: <cover.1402303820.git.jslaby@suse.cz>
References: <cover.1402303820.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Steven Rostedt (Red Hat)" <rostedt@goodmis.org>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

commit a949ae560a511fe4e3adf48fa44fefded93e5c2b upstream.

A race exists between module loading and enabling of function tracer.

	CPU 1				CPU 2
	-----				-----
  load_module()
   module->state = MODULE_STATE_COMING

				register_ftrace_function()
				 mutex_lock(&ftrace_lock);
				 ftrace_startup()
				  update_ftrace_function();
				   ftrace_arch_code_modify_prepare()
				    set_all_module_text_rw();
				   <enables-ftrace>
				    ftrace_arch_code_modify_post_process()
				     set_all_module_text_ro();

				[ here all module text is set to RO,
				  including the module that is
				  loading!! ]

   blocking_notifier_call_chain(MODULE_STATE_COMING);
    ftrace_init_module()

     [ tries to modify code, but it's RO, and fails!
       ftrace_bug() is called]

When this race happens, ftrace_bug() will produces a nasty warning and
all of the function tracing features will be disabled until reboot.

The simple solution is to treate module load the same way the core
kernel is treated at boot. To hardcode the ftrace function modification
of converting calls to mcount into nops. This is done in init/main.c
there's no reason it could not be done in load_module(). This gives
a better control of the changes and doesn't tie the state of the
module to its notifiers as much. Ftrace is special, it needs to be
treated as such.

The reason this would work, is that the ftrace_module_init() would be
called while the module is in MODULE_STATE_UNFORMED, which is ignored
by the set_all_module_text_ro() call.

Link: http://lkml.kernel.org/r/1395637826-3312-1-git-send-email-indou.takao@jp.fujitsu.com

Reported-by: Takao Indoh <indou.takao@jp.fujitsu.com>
Acked-by: Rusty Russell <rusty@rustcorp.com.au>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 include/linux/ftrace.h |  2 ++
 kernel/module.c        |  3 +++
 kernel/trace/ftrace.c  | 27 ++++-----------------------
 3 files changed, 9 insertions(+), 23 deletions(-)

diff --git a/include/linux/ftrace.h b/include/linux/ftrace.h
index 9f15c0064c50..e68db4d534cb 100644
--- a/include/linux/ftrace.h
+++ b/include/linux/ftrace.h
@@ -524,6 +524,7 @@ static inline int ftrace_modify_call(struct dyn_ftrace *rec, unsigned long old_a
 extern int ftrace_arch_read_dyn_info(char *buf, int size);
 
 extern int skip_trace(unsigned long ip);
+extern void ftrace_module_init(struct module *mod);
 
 extern void ftrace_disable_daemon(void);
 extern void ftrace_enable_daemon(void);
@@ -533,6 +534,7 @@ static inline int ftrace_force_update(void) { return 0; }
 static inline void ftrace_disable_daemon(void) { }
 static inline void ftrace_enable_daemon(void) { }
 static inline void ftrace_release_mod(struct module *mod) {}
+static inline void ftrace_module_init(struct module *mod) {}
 static inline int register_ftrace_command(struct ftrace_func_command *cmd)
 {
 	return -EINVAL;
diff --git a/kernel/module.c b/kernel/module.c
index dc582749fa13..7b15ff67c5aa 100644
--- a/kernel/module.c
+++ b/kernel/module.c
@@ -3296,6 +3296,9 @@ static int load_module(struct load_info *info, const char __user *uargs,
 
 	dynamic_debug_setup(info->debug, info->num_debug);
 
+	/* Ftrace init must be called in the MODULE_STATE_UNFORMED state */
+	ftrace_module_init(mod);
+
 	/* Finally it's fully formed, ready to start executing. */
 	err = complete_formation(mod, info);
 	if (err)
diff --git a/kernel/trace/ftrace.c b/kernel/trace/ftrace.c
index e66411fb55b3..a8642bac843e 100644
--- a/kernel/trace/ftrace.c
+++ b/kernel/trace/ftrace.c
@@ -4252,16 +4252,11 @@ static void ftrace_init_module(struct module *mod,
 	ftrace_process_locs(mod, start, end);
 }
 
-static int ftrace_module_notify_enter(struct notifier_block *self,
-				      unsigned long val, void *data)
+void ftrace_module_init(struct module *mod)
 {
-	struct module *mod = data;
-
-	if (val == MODULE_STATE_COMING)
-		ftrace_init_module(mod, mod->ftrace_callsites,
-				   mod->ftrace_callsites +
-				   mod->num_ftrace_callsites);
-	return 0;
+	ftrace_init_module(mod, mod->ftrace_callsites,
+			   mod->ftrace_callsites +
+			   mod->num_ftrace_callsites);
 }
 
 static int ftrace_module_notify_exit(struct notifier_block *self,
@@ -4275,11 +4270,6 @@ static int ftrace_module_notify_exit(struct notifier_block *self,
 	return 0;
 }
 #else
-static int ftrace_module_notify_enter(struct notifier_block *self,
-				      unsigned long val, void *data)
-{
-	return 0;
-}
 static int ftrace_module_notify_exit(struct notifier_block *self,
 				     unsigned long val, void *data)
 {
@@ -4287,11 +4277,6 @@ static int ftrace_module_notify_exit(struct notifier_block *self,
 }
 #endif /* CONFIG_MODULES */
 
-struct notifier_block ftrace_module_enter_nb = {
-	.notifier_call = ftrace_module_notify_enter,
-	.priority = INT_MAX,	/* Run before anything that can use kprobes */
-};
-
 struct notifier_block ftrace_module_exit_nb = {
 	.notifier_call = ftrace_module_notify_exit,
 	.priority = INT_MIN,	/* Run after anything that can remove kprobes */
@@ -4328,10 +4313,6 @@ void __init ftrace_init(void)
 				  __start_mcount_loc,
 				  __stop_mcount_loc);
 
-	ret = register_module_notifier(&ftrace_module_enter_nb);
-	if (ret)
-		pr_warning("Failed to register trace ftrace module enter notifier\n");
-
 	ret = register_module_notifier(&ftrace_module_exit_nb);
 	if (ret)
 		pr_warning("Failed to register trace ftrace module exit notifier\n");
-- 
1.9.3

