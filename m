Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754761AbaDVD7x (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Apr 2014 23:59:53 -0400
Received: from ozlabs.org ([103.22.144.67]:60975 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753424AbaDVD7I (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Apr 2014 23:59:08 -0400
X-Greylist: delayed 550 seconds by postgrey-1.27 at vger.kernel.org; Mon, 21 Apr 2014 23:59:08 EDT
From: Rusty Russell <rusty@rustcorp.com.au>
To: Steven Rostedt <rostedt@goodmis.org>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: Takao Indoh <indou.takao@jp.fujitsu.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Anil S Keshavamurthy <anil.s.keshavamurthy@intel.com>,
        "David S. Miller" <davem@davemloft.net>, linux-kernel@vger.kernel.org
Subject: Re: ftrace/kprobes: Warning when insmod two modules
In-Reply-To: <20140324105939.7f823b81@gandalf.local.home>
References: <1395637826-3312-1-git-send-email-indou.takao@jp.fujitsu.com> <5330164D.6030507@hitachi.com> <20140324105939.7f823b81@gandalf.local.home>
User-Agent: Notmuch/0.15.2 (http://notmuchmail.org) Emacs/23.4.1 (x86_64-pc-linux-gnu)
Date: Tue, 22 Apr 2014 13:21:18 +0930
Message-ID: <87bnvunhs9.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Steven Rostedt <rostedt@goodmis.org> writes:
> On Mon, 24 Mar 2014 20:26:05 +0900
> Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com> wrote:
>
>
>> Thank you for reporting with this pretty backtrace :)
>> Steven, I think this is not the kprobe bug but ftrace (and perhaps, module).
>
> Looks to be more of a module issue than a ftrace issue.
>
>> 
>> If the ftrace can set loading module text read only before the module subsystem
>> expected, I think it should be protected by the module subsystem itself
>> (e.g. set_all_modules_text_ro(rw) skips the modules which is MODULE_STATE_COMING)
>> 
>
> Does this patch fix it?
>
> In-review-off-by: Steven Rostedt <rostedt@goodmis.org>

Sorry, was on paternity leave.

I'm always nervous about adding more states, since every place which
examines the state has to be audited.

We set the mod->state to MOD_STATE_COMING in complete_formation;
why don't we set NX there instead?  It also makes more sense to
set NX before we hit parse_args() which can execute code in the module.

In fact, we should probably call the notifier there too, so people
can breakpoint/tracepoint/etc parameter calls.

Of course, this means that we set NX before the notifier; does anything
break?

Subject: module: set nx before marking module MODULE_STATE_COMING.

This prevents a WARN_ON() where ftrace calls set_all_modules_text_ro()
which races with the module setting its own set_section_ro_nx().

It also means we're NX protected before we call parse_args(), which
can execute module code.

This means that the notifiers will be called on a module which
is already NX, so that may cause problems.

Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>

diff --git a/kernel/module.c b/kernel/module.c
index 11869408f79b..83a437e5d429 100644
--- a/kernel/module.c
+++ b/kernel/module.c
@@ -3023,21 +3023,6 @@ static int do_init_module(struct module *mod)
 	 */
 	current->flags &= ~PF_USED_ASYNC;
 
-	blocking_notifier_call_chain(&module_notify_list,
-			MODULE_STATE_COMING, mod);
-
-	/* Set RO and NX regions for core */
-	set_section_ro_nx(mod->module_core,
-				mod->core_text_size,
-				mod->core_ro_size,
-				mod->core_size);
-
-	/* Set RO and NX regions for init */
-	set_section_ro_nx(mod->module_init,
-				mod->init_text_size,
-				mod->init_ro_size,
-				mod->init_size);
-
 	do_mod_ctors(mod);
 	/* Start the module */
 	if (mod->init != NULL)
@@ -3168,9 +3153,26 @@ static int complete_formation(struct module *mod, struct load_info *info)
 	/* This relies on module_mutex for list integrity. */
 	module_bug_finalize(info->hdr, info->sechdrs, mod);
 
+	/* Set RO and NX regions for core */
+	set_section_ro_nx(mod->module_core,
+				mod->core_text_size,
+				mod->core_ro_size,
+				mod->core_size);
+
+	/* Set RO and NX regions for init */
+	set_section_ro_nx(mod->module_init,
+				mod->init_text_size,
+				mod->init_ro_size,
+				mod->init_size);
+
 	/* Mark state as coming so strong_try_module_get() ignores us,
 	 * but kallsyms etc. can see us. */
 	mod->state = MODULE_STATE_COMING;
+	mutex_unlock(&module_mutex);
+
+	blocking_notifier_call_chain(&module_notify_list,
+				     MODULE_STATE_COMING, mod);
+	return 0;
 
 out:
 	mutex_unlock(&module_mutex);
