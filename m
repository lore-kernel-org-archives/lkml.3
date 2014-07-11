Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755312AbaGKTIV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jul 2014 15:08:21 -0400
Received: from mx1.redhat.com ([209.132.183.28]:56492 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755284AbaGKTIR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jul 2014 15:08:17 -0400
Date: Fri, 11 Jul 2014 21:06:44 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Namhyung Kim <namhyung@kernel.org>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Tom Zanussi <tom.zanussi@linux.intel.com>,
        "zhangwei(Jovi)" <jovi.zhangwei@huawei.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 3/7] tracing: kill destroy_call_preds()
Message-ID: <20140711190644.GA19527@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140711190622.GA19499@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove destroy_call_preds(). Its only caller, __trace_remove_event_call(),
can use free_event_filter() and nullify ->filter by hand.

Perhaps we could keep this trivial helper although imo it is pointless, but
then it should be static in trace_events.c.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
---
 include/linux/ftrace_event.h       |    1 -
 kernel/trace/trace_events.c        |    3 ++-
 kernel/trace/trace_events_filter.c |    6 ------
 3 files changed, 2 insertions(+), 8 deletions(-)

diff --git a/include/linux/ftrace_event.h b/include/linux/ftrace_event.h
index 738d465..f434d75 100644
--- a/include/linux/ftrace_event.h
+++ b/include/linux/ftrace_event.h
@@ -404,7 +404,6 @@ enum event_trigger_type {
 	ETT_EVENT_ENABLE	= (1 << 3),
 };
 
-extern void destroy_call_preds(struct ftrace_event_call *call);
 extern int filter_match_preds(struct event_filter *filter, void *rec);
 
 extern int filter_check_discard(struct ftrace_event_file *file, void *rec,
diff --git a/kernel/trace/trace_events.c b/kernel/trace/trace_events.c
index d049a5e..8690a3f 100644
--- a/kernel/trace/trace_events.c
+++ b/kernel/trace/trace_events.c
@@ -1748,7 +1748,8 @@ static void __trace_remove_event_call(struct ftrace_event_call *call)
 {
 	event_remove(call);
 	trace_destroy_fields(call);
-	destroy_call_preds(call);
+	free_event_filter(call->filter);
+	call->filter = NULL;
 }
 
 static int probe_remove_event_call(struct ftrace_event_call *call)
diff --git a/kernel/trace/trace_events_filter.c b/kernel/trace/trace_events_filter.c
index 30fc66f..1edec32 100644
--- a/kernel/trace/trace_events_filter.c
+++ b/kernel/trace/trace_events_filter.c
@@ -804,12 +804,6 @@ void free_event_filter(struct event_filter *filter)
 	__free_filter(filter);
 }
 
-void destroy_call_preds(struct ftrace_event_call *call)
-{
-	__free_filter(call->filter);
-	call->filter = NULL;
-}
-
 static struct event_filter *__alloc_filter(void)
 {
 	struct event_filter *filter;
-- 
1.5.5.1

