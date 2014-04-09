Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932342AbaDIARK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Apr 2014 20:17:10 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.227]:38177 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1757380AbaDIARI convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Apr 2014 20:17:08 -0400
Date: Tue, 8 Apr 2014 20:17:05 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Frank Ch. Eigler" <fche@redhat.com>,
        Johannes Berg <johannes.berg@intel.com>
Subject: Re: [PATCH 1/1 v11] Tracepoint: register/unregister struct
 tracepoint
Message-ID: <20140408201705.4dad2c4a@gandalf.local.home>
In-Reply-To: <1396992381-23785-2-git-send-email-mathieu.desnoyers@efficios.com>
References: <1396992381-23785-1-git-send-email-mathieu.desnoyers@efficios.com>
	<1396992381-23785-2-git-send-email-mathieu.desnoyers@efficios.com>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.22; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
X-RR-Connecting-IP: 107.14.168.118:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

OK, I kicked off my tests to test this patch. If all goes well, I'll
push it to linux-next and then off to Linus.

But I also added a patch on top. This shouldn't cause any issues for
you, does it?

-- Steve

>From a22720af7d7d2e06284fbed68bd93827f75381b1 Mon Sep 17 00:00:00 2001
From: "Steven Rostedt (Red Hat)" <rostedt@goodmis.org>
Date: Tue, 8 Apr 2014 20:09:40 -0400
Subject: [PATCH] tracepoint: Simplify tracepoint module search

Instead of copying the num_tracepoints and tracepoints_ptrs from
the module structure to the tp_mod structure, which only uses it to
find the module associated to tracepoints of modules that are coming
and going, simply copy the pointer to the module struct to the tracepoint
tp_module structure.

Also removed un-needed brackets around an if statement.

Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 include/linux/tracepoint.h | 3 +--
 kernel/tracepoint.c        | 9 ++++-----
 2 files changed, 5 insertions(+), 7 deletions(-)

diff --git a/include/linux/tracepoint.h b/include/linux/tracepoint.h
index 08150e2..69a298b 100644
--- a/include/linux/tracepoint.h
+++ b/include/linux/tracepoint.h
@@ -47,8 +47,7 @@ for_each_kernel_tracepoint(void (*fct)(struct tracepoint *tp, void *priv),
 #ifdef CONFIG_MODULES
 struct tp_module {
 	struct list_head list;
-	unsigned int num_tracepoints;
-	struct tracepoint * const *tracepoints_ptrs;
+	struct module *mod;
 };
 
 bool trace_module_has_bad_taint(struct module *mod);
diff --git a/kernel/tracepoint.c b/kernel/tracepoint.c
index 8c4f2f4..c115ec4 100644
--- a/kernel/tracepoint.c
+++ b/kernel/tracepoint.c
@@ -374,8 +374,7 @@ static int tracepoint_module_coming(struct module *mod)
 		ret = -ENOMEM;
 		goto end;
 	}
-	tp_mod->num_tracepoints = mod->num_tracepoints;
-	tp_mod->tracepoints_ptrs = mod->tracepoints_ptrs;
+	tp_mod->mod = mod;
 	list_add_tail(&tp_mod->list, &tracepoint_module_list);
 	blocking_notifier_call_chain(&tracepoint_notify_list,
 			MODULE_STATE_COMING, tp_mod);
@@ -393,7 +392,7 @@ static void tracepoint_module_going(struct module *mod)
 
 	mutex_lock(&tracepoint_module_list_mutex);
 	list_for_each_entry(tp_mod, &tracepoint_module_list, list) {
-		if (tp_mod->tracepoints_ptrs == mod->tracepoints_ptrs) {
+		if (tp_mod->mod == mod) {
 			blocking_notifier_call_chain(&tracepoint_notify_list,
 					MODULE_STATE_GOING, tp_mod);
 			list_del(&tp_mod->list);
@@ -447,9 +446,9 @@ static __init int init_tracepoints(void)
 	int ret;
 
 	ret = register_module_notifier(&tracepoint_module_nb);
-	if (ret) {
+	if (ret)
 		pr_warning("Failed to register tracepoint module enter notifier\n");
-	}
+
 	return ret;
 }
 __initcall(init_tracepoints);
-- 
1.8.5.3


