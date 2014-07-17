Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934314AbaGQOvt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2014 10:51:49 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.230]:63074 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S932401AbaGQOry (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2014 10:47:54 -0400
Message-Id: <20140717144752.257303506@goodmis.org>
User-Agent: quilt/0.63-1
Date: Thu, 17 Jul 2014 10:47:08 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
        Oleg Nesterov <oleg@redhat.com>
Subject: [for-next][PATCH 1/7] tracing: Kill destroy_preds() and destroy_file_preds()
References: <20140717144707.625978566@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Disposition: inline; filename=0001-tracing-Kill-destroy_preds-and-destroy_file_preds.patch
X-RR-Connecting-IP: 107.14.168.118:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Oleg Nesterov <oleg@redhat.com>

destroy_preds() makes no sense.

The only caller, event_remove(), actually wants destroy_file_preds().
__trace_remove_event_call() does destroy_call_preds() which takes care
of call->filter.

And after the previous change we can simply remove destroy_preds() from
event_remove(), we are going to call remove_event_from_tracers() which
in turn calls remove_event_file_dir()->free_event_filter().

Link: http://lkml.kernel.org/p/20140715184813.GA20488@redhat.com

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 include/linux/ftrace_event.h       |  1 -
 kernel/trace/trace_events.c        |  1 -
 kernel/trace/trace_events_filter.c | 20 --------------------
 3 files changed, 22 deletions(-)

diff --git a/include/linux/ftrace_event.h b/include/linux/ftrace_event.h
index cff3106ffe2c..738d46539269 100644
--- a/include/linux/ftrace_event.h
+++ b/include/linux/ftrace_event.h
@@ -404,7 +404,6 @@ enum event_trigger_type {
 	ETT_EVENT_ENABLE	= (1 << 3),
 };
 
-extern void destroy_preds(struct ftrace_event_file *file);
 extern void destroy_call_preds(struct ftrace_event_call *call);
 extern int filter_match_preds(struct event_filter *filter, void *rec);
 
diff --git a/kernel/trace/trace_events.c b/kernel/trace/trace_events.c
index 2de53628689f..85914edf5059 100644
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
index 8a8631926a07..30fc66f5cdca 100644
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
2.0.1


