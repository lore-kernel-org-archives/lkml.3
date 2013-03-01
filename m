Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752730Ab3CATp3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Mar 2013 14:45:29 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:51370 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751538Ab3CATpT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Mar 2013 14:45:19 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        "Frank Ch. Eigler" <fche@redhat.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Steven Rostedt <rostedt@goodmis.org>
Subject: [ 21/77] ftrace: Call ftrace cleanup module notifier after all other notifiers
Date: Fri,  1 Mar 2013 11:44:06 -0800
Message-Id: <20130301194354.252919829@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.rc1.5.g7e0651a
In-Reply-To: <20130301194351.913471337@linuxfoundation.org>
References: <20130301194351.913471337@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: "Steven Rostedt (Red Hat)" <rostedt@goodmis.org>

commit 8c189ea64eea01ca20d102ddb74d6936dd16c579 upstream.

Commit: c1bf08ac "ftrace: Be first to run code modification on modules"

changed ftrace module notifier's priority to INT_MAX in order to
process the ftrace nops before anything else could touch them
(namely kprobes). This was the correct thing to do.

Unfortunately, the ftrace module notifier also contains the ftrace
clean up code. As opposed to the set up code, this code should be
run *after* all the module notifiers have run in case a module is doing
correct clean-up and unregisters its ftrace hooks. Basically, ftrace
needs to do clean up on module removal, as it needs to know about code
being removed so that it doesn't try to modify that code. But after it
removes the module from its records, if a ftrace user tries to remove
a probe, that removal will fail due as the record of that code segment
no longer exists.

Nothing really bad happens if the probe removal is called after ftrace
did the clean up, but the ftrace removal function will return an error.
Correct code (such as kprobes) will produce a WARN_ON() if it fails
to remove the probe. As people get annoyed by frivolous warnings, it's
best to do the ftrace clean up after everything else.

By splitting the ftrace_module_notifier into two notifiers, one that
does the module load setup that is run at high priority, and the other
that is called for module clean up that is run at low priority, the
problem is solved.

Reported-by: Frank Ch. Eigler <fche@redhat.com>
Acked-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 kernel/trace/ftrace.c |   46 ++++++++++++++++++++++++++++++++--------------
 1 file changed, 32 insertions(+), 14 deletions(-)

--- a/kernel/trace/ftrace.c
+++ b/kernel/trace/ftrace.c
@@ -3970,37 +3970,51 @@ static void ftrace_init_module(struct mo
 	ftrace_process_locs(mod, start, end);
 }
 
-static int ftrace_module_notify(struct notifier_block *self,
-				unsigned long val, void *data)
+static int ftrace_module_notify_enter(struct notifier_block *self,
+				      unsigned long val, void *data)
 {
 	struct module *mod = data;
 
-	switch (val) {
-	case MODULE_STATE_COMING:
+	if (val == MODULE_STATE_COMING)
 		ftrace_init_module(mod, mod->ftrace_callsites,
 				   mod->ftrace_callsites +
 				   mod->num_ftrace_callsites);
-		break;
-	case MODULE_STATE_GOING:
+	return 0;
+}
+
+static int ftrace_module_notify_exit(struct notifier_block *self,
+				     unsigned long val, void *data)
+{
+	struct module *mod = data;
+
+	if (val == MODULE_STATE_GOING)
 		ftrace_release_mod(mod);
-		break;
-	}
 
 	return 0;
 }
 #else
-static int ftrace_module_notify(struct notifier_block *self,
-				unsigned long val, void *data)
+static int ftrace_module_notify_enter(struct notifier_block *self,
+				      unsigned long val, void *data)
+{
+	return 0;
+}
+static int ftrace_module_notify_exit(struct notifier_block *self,
+				     unsigned long val, void *data)
 {
 	return 0;
 }
 #endif /* CONFIG_MODULES */
 
-struct notifier_block ftrace_module_nb = {
-	.notifier_call = ftrace_module_notify,
+struct notifier_block ftrace_module_enter_nb = {
+	.notifier_call = ftrace_module_notify_enter,
 	.priority = INT_MAX,	/* Run before anything that can use kprobes */
 };
 
+struct notifier_block ftrace_module_exit_nb = {
+	.notifier_call = ftrace_module_notify_exit,
+	.priority = INT_MIN,	/* Run after anything that can remove kprobes */
+};
+
 extern unsigned long __start_mcount_loc[];
 extern unsigned long __stop_mcount_loc[];
 
@@ -4032,9 +4046,13 @@ void __init ftrace_init(void)
 				  __start_mcount_loc,
 				  __stop_mcount_loc);
 
-	ret = register_module_notifier(&ftrace_module_nb);
+	ret = register_module_notifier(&ftrace_module_enter_nb);
+	if (ret)
+		pr_warning("Failed to register trace ftrace module enter notifier\n");
+
+	ret = register_module_notifier(&ftrace_module_exit_nb);
 	if (ret)
-		pr_warning("Failed to register trace ftrace module notifier\n");
+		pr_warning("Failed to register trace ftrace module exit notifier\n");
 
 	set_ftrace_early_filters();
 


