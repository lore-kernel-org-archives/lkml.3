Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755264AbaGKTH4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jul 2014 15:07:56 -0400
Received: from mx1.redhat.com ([209.132.183.28]:20495 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751979AbaGKTHz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jul 2014 15:07:55 -0400
Date: Fri, 11 Jul 2014 21:06:22 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Namhyung Kim <namhyung@kernel.org>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Tom Zanussi <tom.zanussi@linux.intel.com>,
        "zhangwei(Jovi)" <jovi.zhangwei@huawei.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 0/7] tracing: instance_rmdir() leaks
	ftrace_event_file->filter
Message-ID: <20140711190622.GA19499@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

Sorry for delay, I was distracted by other problems.

To remind, we discussed the potential uprobes "mix perf/ftrace" changes and
found some off-topic problems. Lets start with ->filter fixes/cleanups.

So far I didn't even try to test this series, although it looks simple except
perhaps the last patch. I'll try to somehow test this tomorrow, but I do not
really now how.

So please review, these patches need acks anyway.

As for 1/7, I added BUG_ON(file->filter) into remove_event_file_dir() before
kmem_cache_free() to verify that yes, the leak does exist. Perhaps this patch
should go to stable, or at least to v3.16.

--------------------------------------------------------------------------------
And could someone explain me why apply_subsystem_event_filter("0") clears
->filter_string first, then the whole ->filter? It seems that the only
thing filter_free_subsystem_preds() should do is filter_disable(), no?
IOW, why the patch below (on top of this series) is wrong?

Oleg.

--- x/kernel/trace/trace_events_filter.c
+++ x/kernel/trace/trace_events_filter.c
@@ -831,17 +831,6 @@ static int __alloc_preds(struct event_filter *filter, int n_preds)
 	return 0;
 }
 
-static inline void __remove_filter(struct ftrace_event_file *file)
-{
-	struct ftrace_event_call *call = file->event_call;
-
-	filter_disable(file);
-	if (call->flags & TRACE_EVENT_FL_USE_CALL_FILTER)
-		remove_filter_string(call->filter);
-	else
-		remove_filter_string(file->filter);
-}
-
 static void filter_free_subsystem_preds(struct event_subsystem *system,
 					struct trace_array *tr)
 {
@@ -850,7 +839,7 @@ static void filter_free_subsystem_preds(struct event_subsystem *system,
 	list_for_each_entry(file, &tr->events, list) {
 		if (file->system->subsystem != system)
 			continue;
-		__remove_filter(file);
+		filter_disable(file);
 	}
 }
 

