Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753426AbaCXO7n (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Mar 2014 10:59:43 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.227]:58506 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753220AbaCXO7m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Mar 2014 10:59:42 -0400
Date: Mon, 24 Mar 2014 10:59:39 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: Takao Indoh <indou.takao@jp.fujitsu.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Anil S Keshavamurthy <anil.s.keshavamurthy@intel.com>,
        "David S. Miller" <davem@davemloft.net>, linux-kernel@vger.kernel.org,
        Rusty Russell <rusty@rustcorp.com.au>
Subject: Re: ftrace/kprobes: Warning when insmod two modules
Message-ID: <20140324105939.7f823b81@gandalf.local.home>
In-Reply-To: <5330164D.6030507@hitachi.com>
References: <1395637826-3312-1-git-send-email-indou.takao@jp.fujitsu.com>
	<5330164D.6030507@hitachi.com>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.22; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.118:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 24 Mar 2014 20:26:05 +0900
Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com> wrote:


> Thank you for reporting with this pretty backtrace :)
> Steven, I think this is not the kprobe bug but ftrace (and perhaps, module).

Looks to be more of a module issue than a ftrace issue.

> 
> If the ftrace can set loading module text read only before the module subsystem
> expected, I think it should be protected by the module subsystem itself
> (e.g. set_all_modules_text_ro(rw) skips the modules which is MODULE_STATE_COMING)
> 

Does this patch fix it?

In-review-off-by: Steven Rostedt <rostedt@goodmis.org>

diff --git a/include/linux/module.h b/include/linux/module.h
index 5a50539..a1acabf 100644
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
index d24fcf2..0905bed 100644
--- a/kernel/module.c
+++ b/kernel/module.c
@@ -1805,7 +1805,8 @@ void set_all_modules_text_ro(void)
 
 	mutex_lock(&module_mutex);
 	list_for_each_entry_rcu(mod, &modules, list) {
-		if (mod->state == MODULE_STATE_UNFORMED)
+		if (mod->state == MODULE_STATE_UNFORMED ||
+		    mod->state == MODULE_STATE_COMING)
 			continue;
 		if ((mod->module_core) && (mod->core_text_size)) {
 			set_page_attributes(mod->module_core,
@@ -3020,6 +3021,13 @@ static int do_init_module(struct module *mod)
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

