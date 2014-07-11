Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755298AbaGKTIT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jul 2014 15:08:19 -0400
Received: from mx1.redhat.com ([209.132.183.28]:58691 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755283AbaGKTIP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jul 2014 15:08:15 -0400
Date: Fri, 11 Jul 2014 21:06:41 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Namhyung Kim <namhyung@kernel.org>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Tom Zanussi <tom.zanussi@linux.intel.com>,
        "zhangwei(Jovi)" <jovi.zhangwei@huawei.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 2/7] tracing: kill destroy_preds() and destroy_file_preds()
Message-ID: <20140711190641.GA19520@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140711190622.GA19499@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

destroy_preds() makes no any sense.

The only caller, event_remove(), actually wants destroy_file_preds().
__trace_remove_event_call() does destroy_call_preds() which takes care
of call->filter.

And after the previous change we can simply remove destroy_preds() from
event_remove(), we are going to call remove_event_from_tracers() which
in turn calls remove_event_file_dir()->free_event_filter().

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
---
 include/linux/ftrace_event.h       |    1 -
 kernel/trace/trace_events.c        |    1 -
 kernel/trace/trace_events_filter.c |   20 --------------------
 3 files changed, 0 insertions(+), 22 deletions(-)

diff --git a/include/linux/ftrace_event.h b/include/linux/ftrace_event.h
index cff3106..738d465 100644
--- a/include/linux/ftrace_event.h
+++ b/include/linux/ftrace_event.h
@@ -404,7 +404,6 @@ enum event_trigger_type {
 	ETT_EVENT_ENABLE	= (1 << 3),
 };
 
-extern void destroy_preds(struct ftrace_event_file *file);
 extern void destroy_call_preds(struct ftrace_event_call *call);
 extern int filter_match_preds(struct event_filter *filter, void *rec);
 
diff --git a/kernel/trace/trace_events.c b/kernel/trace/trace_events.c
index 735608e..d049a5e 100644
--- a/kernel/trace/trace_events.c
+++ b/kernel/trace/trace_events.c
@@ -1621,7 +1621,6 @@ static void event_remove(struct ftrace_event_call *call)
 		if (file->event_call != call)
 			continue;
 		ftrace_event_enable_disable(file, 0);
-		destroy_preds(file);
 		/*
 		 * The do_for_each_event_file() is
 		 * a double loop. After finding the call for this
diff --git a/kernel/trace/trace_events_filter.c b/kernel/trace/trace_events_filter.c
index 8a86319..30fc66f 100644
--- a/kernel/trace/trace_events_filter.c
+++ b/kernel/trace/trace_events_filter.c
@@ -810,26 +810,6 @@ void destroy_call_preds(struct ftrace_event_call *call)
 	call->filter = NULL;
 }
 
-static void destroy_file_preds(struct ftrace_event_file *file)
-{
-	__free_filter(file->filter);
-	file->filter = NULL;
-}
-
-/*
- * Called when destroying the ftrace_event_file.
- * The file is being freed, so we do not need to worry about
- * the file being currently used. This is for module code removing
- * the tracepoints from within it.
- */
-void destroy_preds(struct ftrace_event_file *file)
-{
-	if (file->event_call->flags & TRACE_EVENT_FL_USE_CALL_FILTER)
-		destroy_call_preds(file->event_call);
-	else
-		destroy_file_preds(file);
-}
-
 static struct event_filter *__alloc_filter(void)
 {
 	struct event_filter *filter;
-- 
1.5.5.1

