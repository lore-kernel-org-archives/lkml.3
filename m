Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932258AbaGKTJW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jul 2014 15:09:22 -0400
Received: from mx1.redhat.com ([209.132.183.28]:21988 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932078AbaGKTI0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jul 2014 15:08:26 -0400
Date: Fri, 11 Jul 2014 21:06:55 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Namhyung Kim <namhyung@kernel.org>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Tom Zanussi <tom.zanussi@linux.intel.com>,
        "zhangwei(Jovi)" <jovi.zhangwei@huawei.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 7/7] tracing: change filter_free_subsystem_*() to check
	->subsystem rather then ->name
Message-ID: <20140711190655.GA19549@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140711190622.GA19499@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

filter_free_subsystem_preds() and filter_free_subsystem_filters()
can rely on file->system->subsystem and avoid strcmp().

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
---
 kernel/trace/trace_events_filter.c |    9 ++-------
 1 files changed, 2 insertions(+), 7 deletions(-)

diff --git a/kernel/trace/trace_events_filter.c b/kernel/trace/trace_events_filter.c
index 54a125c..59655bc 100644
--- a/kernel/trace/trace_events_filter.c
+++ b/kernel/trace/trace_events_filter.c
@@ -846,13 +846,10 @@ static void filter_free_subsystem_preds(struct event_subsystem *system,
 					struct trace_array *tr)
 {
 	struct ftrace_event_file *file;
-	struct ftrace_event_call *call;
 
 	list_for_each_entry(file, &tr->events, list) {
-		call = file->event_call;
-		if (strcmp(call->class->system, system->name) != 0)
+		if (file->system->subsystem != system)
 			continue;
-
 		__remove_filter(file);
 	}
 }
@@ -874,11 +871,9 @@ static void filter_free_subsystem_filters(struct event_subsystem *system,
 					  struct trace_array *tr)
 {
 	struct ftrace_event_file *file;
-	struct ftrace_event_call *call;
 
 	list_for_each_entry(file, &tr->events, list) {
-		call = file->event_call;
-		if (strcmp(call->class->system, system->name) != 0)
+		if (file->system->subsystem != system)
 			continue;
 		__free_subsystem_filter(file);
 	}
-- 
1.5.5.1

