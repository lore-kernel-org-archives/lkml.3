Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753410AbaBTKd7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Feb 2014 05:33:59 -0500
Received: from ip4-83-240-18-248.cust.nbox.cz ([83.240.18.248]:49169 "EHLO
	anemoi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752240AbaBTKdL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Feb 2014 05:33:11 -0500
From: Jiri Slaby <jslaby@suse.cz>
To: rostedt@goodmis.org
Cc: jirislaby@gmail.com, linux-kernel@vger.kernel.org,
        Jiri Slaby <jslaby@suse.cz>, Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>
Subject: [PATCH 1/6] ftrace: cleanup of global variables
Date: Thu, 20 Feb 2014 11:33:02 +0100
Message-Id: <1392892387-26826-1-git-send-email-jslaby@suse.cz>
X-Mailer: git-send-email 1.8.5.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some of them can be local to functions, so make them local and pass
them as parameters where needed:
* __start_mcount_loc+__stop_mcount_loc are local to ftrace_init
* ftrace_new_pgs -> new_pgs/start_pg
* ftrace_update_cnt -> local update_cnt in ftrace_update_code

Some's values are unused, so remove them completely:
* ftrace_update_time along with start+stop in ftrace_update_code

Signed-off-by: Jiri Slaby <jslaby@suse.cz>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@redhat.com>
---
 kernel/trace/ftrace.c | 31 ++++++++-----------------------
 1 file changed, 8 insertions(+), 23 deletions(-)

diff --git a/kernel/trace/ftrace.c b/kernel/trace/ftrace.c
index cd7f76d1eb86..c321fed01e91 100644
--- a/kernel/trace/ftrace.c
+++ b/kernel/trace/ftrace.c
@@ -1172,8 +1172,6 @@ struct ftrace_page {
 	int			size;
 };
 
-static struct ftrace_page *ftrace_new_pgs;
-
 #define ENTRY_SIZE sizeof(struct dyn_ftrace)
 #define ENTRIES_PER_PAGE (PAGE_SIZE / ENTRY_SIZE)
 
@@ -2243,8 +2241,6 @@ static void ftrace_shutdown_sysctl(void)
 		ftrace_run_update_code(FTRACE_DISABLE_CALLS);
 }
 
-static cycle_t		ftrace_update_time;
-static unsigned long	ftrace_update_cnt;
 unsigned long		ftrace_update_tot_cnt;
 
 static inline int ops_traces_mod(struct ftrace_ops *ops)
@@ -2300,11 +2296,11 @@ static int referenced_filters(struct dyn_ftrace *rec)
 	return cnt;
 }
 
-static int ftrace_update_code(struct module *mod)
+static int ftrace_update_code(struct module *mod, struct ftrace_page *new_pgs)
 {
 	struct ftrace_page *pg;
 	struct dyn_ftrace *p;
-	cycle_t start, stop;
+	unsigned long update_cnt = 0;
 	unsigned long ref = 0;
 	bool test = false;
 	int i;
@@ -2329,10 +2325,7 @@ static int ftrace_update_code(struct module *mod)
 		}
 	}
 
-	start = ftrace_now(raw_smp_processor_id());
-	ftrace_update_cnt = 0;
-
-	for (pg = ftrace_new_pgs; pg; pg = pg->next) {
+	for (pg = new_pgs; pg; pg = pg->next) {
 
 		for (i = 0; i < pg->index; i++) {
 			int cnt = ref;
@@ -2353,7 +2346,7 @@ static int ftrace_update_code(struct module *mod)
 			if (!ftrace_code_disable(mod, p))
 				break;
 
-			ftrace_update_cnt++;
+			update_cnt++;
 
 			/*
 			 * If the tracing is enabled, go ahead and enable the record.
@@ -2372,11 +2365,7 @@ static int ftrace_update_code(struct module *mod)
 		}
 	}
 
-	ftrace_new_pgs = NULL;
-
-	stop = ftrace_now(raw_smp_processor_id());
-	ftrace_update_time = stop - start;
-	ftrace_update_tot_cnt += ftrace_update_cnt;
+	ftrace_update_tot_cnt += update_cnt;
 
 	return 0;
 }
@@ -4238,9 +4227,6 @@ static int ftrace_process_locs(struct module *mod,
 	/* Assign the last page to ftrace_pages */
 	ftrace_pages = pg;
 
-	/* These new locations need to be initialized */
-	ftrace_new_pgs = start_pg;
-
 	/*
 	 * We only need to disable interrupts on start up
 	 * because we are modifying code that an interrupt
@@ -4251,7 +4237,7 @@ static int ftrace_process_locs(struct module *mod,
 	 */
 	if (!mod)
 		local_irq_save(flags);
-	ftrace_update_code(mod);
+	ftrace_update_code(mod, start_pg);
 	if (!mod)
 		local_irq_restore(flags);
 	ret = 0;
@@ -4360,11 +4346,10 @@ struct notifier_block ftrace_module_exit_nb = {
 	.priority = INT_MIN,	/* Run after anything that can remove kprobes */
 };
 
-extern unsigned long __start_mcount_loc[];
-extern unsigned long __stop_mcount_loc[];
-
 void __init ftrace_init(void)
 {
+	extern unsigned long __start_mcount_loc[];
+	extern unsigned long __stop_mcount_loc[];
 	unsigned long count, addr, flags;
 	int ret;
 
-- 
1.8.5.2

