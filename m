Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751556AbaDOBNn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2014 21:13:43 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:60043 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750932AbaDOBND (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2014 21:13:03 -0400
X-SecurityPolicyCheck: OK by SHieldMailChecker v2.2.3
X-SHieldMailCheckerPolicyVersion: FJ-ISEC-20140219-2
From: Takao Indoh <indou.takao@jp.fujitsu.com>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: Steven Rostedt <rostedt@goodmis.org>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        linux-kernel@vger.kernel.org
Subject: [RESEND PATCH] module: Introduce MODULE_STATE_COMING_FINAL to avoid ftrace warning
Date: Tue, 15 Apr 2014 10:12:51 +0900
Message-Id: <1397524371-5784-1-git-send-email-indou.takao@jp.fujitsu.com>
X-Mailer: git-send-email 1.7.9
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I resend this patch with Steven's signed-off-by and Hiramatsu-san's
reviewed-by.

This patch adds new module state MODULE_STATE_COMING_FINAL to avoid
ftrace waring message when loading two modules simultaneously.

The original patch was written by Steven Rostedt, see below.
https://lkml.org/lkml/2014/3/24/242

Ftrace waring message below is got when insmod two modules almost at the
same time and at least one of them uses register_kprobe() in its
module_init.

[  409.337936] ------------[ cut here ]------------
[  409.337945] WARNING: CPU: 12 PID: 10028 at /mnt/repos/linux/kernel/trace/ftrace.c:1716 ftrace_bug+0x206/0x270()
(snip)
[  409.337983] Call Trace:
[  409.337990]  [<ffffffff81547bfe>] dump_stack+0x45/0x56
[  409.337993]  [<ffffffff81049a0d>] warn_slowpath_common+0x7d/0xa0
[  409.337997]  [<ffffffffa0364000>] ? 0xffffffffa0363fff
[  409.337999]  [<ffffffff81049aea>] warn_slowpath_null+0x1a/0x20
[  409.338001]  [<ffffffff810e79f6>] ftrace_bug+0x206/0x270
[  409.338004]  [<ffffffffa0364000>] ? 0xffffffffa0363fff
[  409.338006]  [<ffffffff810e7d8e>] ftrace_process_locs+0x32e/0x710
[  409.338008]  [<ffffffff810e8206>] ftrace_module_notify_enter+0x96/0xf0
[  409.338012]  [<ffffffff81551dec>] notifier_call_chain+0x4c/0x70
[  409.338018]  [<ffffffff8106fbfd>] __blocking_notifier_call_chain+0x4d/0x70
[  409.338020]  [<ffffffff8106fc36>] blocking_notifier_call_chain+0x16/0x20
[  409.338026]  [<ffffffff810bf3f4>] load_module+0x1f54/0x25d0
[  409.338028]  [<ffffffff810baab0>] ? store_uevent+0x40/0x40
[  409.338031]  [<ffffffff810bfbe6>] SyS_finit_module+0x86/0xb0
[  409.338036]  [<ffffffff81556752>] system_call_fastpath+0x16/0x1b
[  409.338037] ---[ end trace e7e27c36e7a65831 ]---
[  409.338040] ftrace faulted on writing [<ffffffffa0364000>] handler_pre+0x0/0x10 [test2]

This is the sequence when this problem occurs.

<insmod module A>
init_module
  load_module
    do_init_module
      do_one_initcall
        (module_init)
          register_kprobe
            arm_kprobe
              arm_kprobe_ftrace
                register_ftrace_function
                  mutex_lock(&ftrace_lock) ------------------- (1)
                  ftrace_startup
                    ftrace_startup_enable
                      ftrace_run_update_code
                        ftrace_arch_code_modify_post_process
                          set_all_modules_text_ro ------------ (2)
                  mutex_unlock(&ftrace_lock) ----------------- (3)

<insmod module B>
init_module
  load_module
    do_init_module
      blocking_notifier_call_chain
        ftrace_module_notify_enter
          ftrace_init_module
            ftrace_process_locs
             mutex_lock(&ftrace_lock) ------------------------ (4)
             ftrace_update_code
               __ftrace_replace_code
                 ftrace_make_nop
                   ftrace_modify_code_direct
                     do_ftrace_mod_code
                       probe_kernel_write -------------------- (5)

o Module A gets ftrace_lock at (1)
o Module B also tries to get ftrace_lock at (4) somewhat late, and waits
  here because module A got it.
o Module A sets all modules text to ReadOnly at (2), and then release
  ftrace_lock at (3)
o Module B wakes up and tries to rewrite its text at (5), but it fails
  because it is already changed to RO at (2) by modules A. The ftrace
  waring message is outputted.

This patch introduces MODULE_STATE_COMING_FINAL which means that the
module is ready to be changed to ReadOnly. By this, the modules B is not
change to RO at (2) because its state is still MODULE_STATE_COMING, so
this warning message is avoided. Module B is changed to RO in the
do_init_module() after comes back from notifier.

Signed-off-by: Takao Indoh <indou.takao@jp.fujitsu.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
Reviewed-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
---
 include/linux/module.h |  9 +++++----
 kernel/module.c        | 13 ++++++++++++-
 2 files changed, 17 insertions(+), 5 deletions(-)

diff --git a/include/linux/module.h b/include/linux/module.h
index eaf60ff..32f4481 100644
--- a/include/linux/module.h
+++ b/include/linux/module.h
@@ -207,10 +207,11 @@ struct module_use {
 };
 
 enum module_state {
-	MODULE_STATE_LIVE,	/* Normal state. */
-	MODULE_STATE_COMING,	/* Full formed, running module_init. */
-	MODULE_STATE_GOING,	/* Going away. */
-	MODULE_STATE_UNFORMED,	/* Still setting it up. */
+	MODULE_STATE_LIVE,		/* Normal state. */
+	MODULE_STATE_COMING,		/* Full formed, running module_init. */
+	MODULE_STATE_COMING_FINAL,	/* Ready to be changed to read only. */
+	MODULE_STATE_GOING,		/* Going away. */
+	MODULE_STATE_UNFORMED,		/* Still setting it up. */
 };
 
 /**
diff --git a/kernel/module.c b/kernel/module.c
index 8dc7f5e..94b9f91 100644
--- a/kernel/module.c
+++ b/kernel/module.c
@@ -1033,6 +1033,9 @@ static ssize_t show_initstate(struct module_attribute *mattr,
 	case MODULE_STATE_COMING:
 		state = "coming";
 		break;
+	case MODULE_STATE_COMING_FINAL:
+		state = "coming_final";
+		break;
 	case MODULE_STATE_GOING:
 		state = "going";
 		break;
@@ -1805,7 +1808,8 @@ void set_all_modules_text_ro(void)
 
 	mutex_lock(&module_mutex);
 	list_for_each_entry_rcu(mod, &modules, list) {
-		if (mod->state == MODULE_STATE_UNFORMED)
+		if (mod->state == MODULE_STATE_UNFORMED ||
+		    mod->state == MODULE_STATE_COMING)
 			continue;
 		if ((mod->module_core) && (mod->core_text_size)) {
 			set_page_attributes(mod->module_core,
@@ -3024,6 +3028,13 @@ static int do_init_module(struct module *mod)
 	blocking_notifier_call_chain(&module_notify_list,
 			MODULE_STATE_COMING, mod);
 
+	/*
+	 * This module must not be changed by set_all_modules_text_ro()
+	 * until we get here. Otherwise notifiers that change text
+	 * (like ftrace does) will break.
+	 */
+	mod->state = MODULE_STATE_COMING_FINAL;
+
 	/* Set RO and NX regions for core */
 	set_section_ro_nx(mod->module_core,
 				mod->core_text_size,
-- 
1.8.3.1


