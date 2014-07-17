Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933791AbaGQOr6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2014 10:47:58 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.228]:10874 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S933319AbaGQOry (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2014 10:47:54 -0400
Message-Id: <20140717144752.400652069@goodmis.org>
User-Agent: quilt/0.63-1
Date: Thu, 17 Jul 2014 10:47:09 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
        Oleg Nesterov <oleg@redhat.com>
Subject: [for-next][PATCH 2/7] tracing: Kill destroy_call_preds()
References: <20140717144707.625978566@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Disposition: inline; filename=0002-tracing-Kill-destroy_call_preds.patch
X-RR-Connecting-IP: 107.14.168.118:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Oleg Nesterov <oleg@redhat.com>

Remove destroy_call_preds(). Its only caller, __trace_remove_event_call(),
can use free_event_filter() and nullify ->filter by hand.

Perhaps we could keep this trivial helper although imo it is pointless, but
then it should be static in trace_events.c.

Link: http://lkml.kernel.org/p/20140715184816.GA20495@redhat.com

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 include/linux/ftrace_event.h       | 1 -
 kernel/trace/trace_events.c        | 3 ++-
 kernel/trace/trace_events_filter.c | 6 ------
 3 files changed, 2 insertions(+), 8 deletions(-)

diff --git a/include/linux/ftrace_event.h b/include/linux/ftrace_event.h
index 738d46539269..f434d75e083b 100644
--- a/include/linux/ftrace_event.h
+++ b/include/linux/ftrace_event.h
@@ -404,7 +404,6 @@ enum event_trigger_type {
 	ETT_EVENT_ENABLE	= (1 << 3),
 };
 
-extern void destroy_call_preds(struct ftrace_event_call *call);
 extern int filter_match_preds(struct event_filter *filter, void *rec);
 
 extern int filter_check_discard(struct ftrace_event_file *file, void *rec,
diff --git a/kernel/trace/trace_events.c b/kernel/trace/trace_events.c
index 85914edf5059..0d8ee29f6b9a 100644
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
index 30fc66f5cdca..1edec329be29 100644
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
2.0.1


