Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753315AbaFGBcd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jun 2014 21:32:33 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:36107 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752660AbaFGBXj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jun 2014 21:23:39 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "Rusty Russell" <rusty@rustcorp.com.au>,
        "Steven Rostedt (Red Hat)" <rostedt@goodmis.org>,
        "Takao Indoh" <indou.takao@jp.fujitsu.com>
Date: Sat, 07 Jun 2014 02:26:29 +0100
Message-ID: <lsq.1402104389.642381197@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [PATCH 3.2 37/92] ftrace/module: Hardcode ftrace_module_init()
 call into load_module()
In-Reply-To: <lsq.1402104388.385007124@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.249
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.60-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: "Steven Rostedt (Red Hat)" <rostedt@goodmis.org>

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
[bwh: Backported to 3.2: adjust context]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 include/linux/ftrace.h |  2 ++
 kernel/module.c        |  3 +++
 kernel/trace/ftrace.c  | 27 ++++-----------------------
 3 files changed, 9 insertions(+), 23 deletions(-)

--- a/include/linux/ftrace.h
+++ b/include/linux/ftrace.h
@@ -260,6 +260,7 @@ extern int ftrace_make_call(struct dyn_f
 extern int ftrace_arch_read_dyn_info(char *buf, int size);
 
 extern int skip_trace(unsigned long ip);
+extern void ftrace_module_init(struct module *mod);
 
 extern void ftrace_disable_daemon(void);
 extern void ftrace_enable_daemon(void);
@@ -272,6 +273,7 @@ static inline void ftrace_set_filter(uns
 static inline void ftrace_disable_daemon(void) { }
 static inline void ftrace_enable_daemon(void) { }
 static inline void ftrace_release_mod(struct module *mod) {}
+static inline void ftrace_module_init(struct module *mod) {}
 static inline int register_ftrace_command(struct ftrace_func_command *cmd)
 {
 	return -EINVAL;
--- a/kernel/module.c
+++ b/kernel/module.c
@@ -2888,6 +2888,9 @@ static struct module *load_module(void _
 	/* This has to be done once we're sure module name is unique. */
 	dynamic_debug_setup(info.debug, info.num_debug);
 
+	/* Ftrace init must be called in the MODULE_STATE_UNFORMED state */
+	ftrace_module_init(mod);
+
 	/* Find duplicate symbols */
 	err = verify_export_symbols(mod);
 	if (err < 0)
--- a/kernel/trace/ftrace.c
+++ b/kernel/trace/ftrace.c
@@ -3542,16 +3542,11 @@ static void ftrace_init_module(struct mo
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
@@ -3565,11 +3560,6 @@ static int ftrace_module_notify_exit(str
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
@@ -3577,11 +3567,6 @@ static int ftrace_module_notify_exit(str
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
@@ -3618,10 +3603,6 @@ void __init ftrace_init(void)
 				  __start_mcount_loc,
 				  __stop_mcount_loc);
 
-	ret = register_module_notifier(&ftrace_module_enter_nb);
-	if (ret)
-		pr_warning("Failed to register trace ftrace module enter notifier\n");
-
 	ret = register_module_notifier(&ftrace_module_exit_nb);
 	if (ret)
 		pr_warning("Failed to register trace ftrace module exit notifier\n");

