Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754730AbaD1XVs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2014 19:21:48 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.227]:29999 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752461AbaD1XVq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2014 19:21:46 -0400
Date: Mon, 28 Apr 2014 19:21:43 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@kernel.org>,
        Rusty Russell <rusty@rustcorp.com.au>, stable@vger.kernel.org,
        Takao Indoh <indou.takao@jp.fujitsu.com>
Subject: [GIT PULL] ftrace/module: Hardcode ftrace_module_init() call into
 load_module()
Message-ID: <20140428192143.56118284@gandalf.local.home>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.22; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.118:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Linus,

Takao Indoh reported that he was able to cause a ftrace bug while
loading a module and enabling function tracing at the same time.

He uncovered a race where the module when loaded will convert the
calls to mcount into nops, and expects the module's text to be RW.
But when function tracing is enabled, it will convert all kernel
text (core and module) from RO to RW to convert the nops to calls
to ftrace to record the function. After the convertion, it will
convert all the text back from RW to RO.

The issue is, it will also convert the module's text that is loading.
If it converts it to RO before ftrace does its conversion, it will
cause ftrace to fail and require a reboot to fix it again.

This patch moves the ftrace module update that converts calls to mcount
into nops to be done when the module state is still MODULE_STATE_UNFORMED.
This will ignore the module when the text is being converted from
RW back to RO.

Please pull the latest trace-fixes-v3.15-rc2 tree, which can be found at:


  git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-trace.git
trace-fixes-v3.15-rc2

Tag SHA1: a5adbbe7195dd767544eccb25a35795cd89682e8
Head SHA1: a949ae560a511fe4e3adf48fa44fefded93e5c2b


Steven Rostedt (Red Hat) (1):
      ftrace/module: Hardcode ftrace_module_init() call into load_module()

----
 include/linux/ftrace.h |  2 ++
 kernel/module.c        |  3 +++
 kernel/trace/ftrace.c  | 27 ++++-----------------------
 3 files changed, 9 insertions(+), 23 deletions(-)
---------------------------
commit a949ae560a511fe4e3adf48fa44fefded93e5c2b
Author: Steven Rostedt (Red Hat) <rostedt@goodmis.org>
Date:   Thu Apr 24 10:40:12 2014 -0400

    ftrace/module: Hardcode ftrace_module_init() call into load_module()
    
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
    Cc: stable@vger.kernel.org # 2.6.38+
    Signed-off-by: Steven Rostedt <rostedt@goodmis.org>

diff --git a/include/linux/ftrace.h b/include/linux/ftrace.h
index 9212b01..ae9504b 100644
--- a/include/linux/ftrace.h
+++ b/include/linux/ftrace.h
@@ -535,6 +535,7 @@ static inline int ftrace_modify_call(struct dyn_ftrace *rec, unsigned long old_a
 extern int ftrace_arch_read_dyn_info(char *buf, int size);
 
 extern int skip_trace(unsigned long ip);
+extern void ftrace_module_init(struct module *mod);
 
 extern void ftrace_disable_daemon(void);
 extern void ftrace_enable_daemon(void);
@@ -544,6 +545,7 @@ static inline int ftrace_force_update(void) { return 0; }
 static inline void ftrace_disable_daemon(void) { }
 static inline void ftrace_enable_daemon(void) { }
 static inline void ftrace_release_mod(struct module *mod) {}
+static inline void ftrace_module_init(struct module *mod) {}
 static inline __init int register_ftrace_command(struct ftrace_func_command *cmd)
 {
 	return -EINVAL;
diff --git a/kernel/module.c b/kernel/module.c
index 1186940..5f14fec 100644
--- a/kernel/module.c
+++ b/kernel/module.c
@@ -3271,6 +3271,9 @@ static int load_module(struct load_info *info, const char __user *uargs,
 
 	dynamic_debug_setup(info->debug, info->num_debug);
 
+	/* Ftrace init must be called in the MODULE_STATE_UNFORMED state */
+	ftrace_module_init(mod);
+
 	/* Finally it's fully formed, ready to start executing. */
 	err = complete_formation(mod, info);
 	if (err)
diff --git a/kernel/trace/ftrace.c b/kernel/trace/ftrace.c
index 1fd4b94..4a54a25 100644
--- a/kernel/trace/ftrace.c
+++ b/kernel/trace/ftrace.c
@@ -4330,16 +4330,11 @@ static void ftrace_init_module(struct module *mod,
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
@@ -4353,11 +4348,6 @@ static int ftrace_module_notify_exit(struct notifier_block *self,
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
@@ -4365,11 +4355,6 @@ static int ftrace_module_notify_exit(struct notifier_block *self,
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
@@ -4403,10 +4388,6 @@ void __init ftrace_init(void)
 				  __start_mcount_loc,
 				  __stop_mcount_loc);
 
-	ret = register_module_notifier(&ftrace_module_enter_nb);
-	if (ret)
-		pr_warning("Failed to register trace ftrace module enter notifier\n");
-
 	ret = register_module_notifier(&ftrace_module_exit_nb);
 	if (ret)
 		pr_warning("Failed to register trace ftrace module exit notifier\n");
