Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757091AbaDWQ6v (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Apr 2014 12:58:51 -0400
Received: from mx1.redhat.com ([209.132.183.28]:16745 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756456AbaDWQ6t (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Apr 2014 12:58:49 -0400
Date: Wed, 23 Apr 2014 18:58:30 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Ingo Molnar <mingo@elte.hu>, Steven Rostedt <rostedt@goodmis.org>
Cc: Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Anton Arapov <aarapov@redhat.com>, David Long <dave.long@linaro.org>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 1/1] uprobes/tracing: uprobe_perf_open() forgets to handle
	the error from uprobe_apply()
Message-ID: <20140423165830.GA29493@redhat.com>
References: <20140423165808.GA29485@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140423165808.GA29485@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

uprobe_perf_open()->uprobe_apply() can fail, but this error is wrongly
ignored. Change uprobe_perf_open() to do uprobe_perf_close() and return
the error code in this case.

Change uprobe_perf_close() to propogate the error from uprobe_apply()
as well, although it should not fail.

The patch looks more complicated because it moves uprobe_perf_close()
up to make it visible to uprobe_perf_open().

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
---
 kernel/trace/trace_uprobe.c |   46 +++++++++++++++++++++++-------------------
 1 files changed, 25 insertions(+), 21 deletions(-)

diff --git a/kernel/trace/trace_uprobe.c b/kernel/trace/trace_uprobe.c
index 930e514..9aad3e2 100644
--- a/kernel/trace/trace_uprobe.c
+++ b/kernel/trace/trace_uprobe.c
@@ -1003,56 +1003,60 @@ uprobe_filter_event(struct trace_uprobe *tu, struct perf_event *event)
 	return __uprobe_perf_filter(&tu->filter, event->hw.tp_target->mm);
 }
 
-static int uprobe_perf_open(struct trace_uprobe *tu, struct perf_event *event)
+static int uprobe_perf_close(struct trace_uprobe *tu, struct perf_event *event)
 {
 	bool done;
 
 	write_lock(&tu->filter.rwlock);
 	if (event->hw.tp_target) {
-		/*
-		 * event->parent != NULL means copy_process(), we can avoid
-		 * uprobe_apply(). current->mm must be probed and we can rely
-		 * on dup_mmap() which preserves the already installed bp's.
-		 *
-		 * attr.enable_on_exec means that exec/mmap will install the
-		 * breakpoints we need.
-		 */
+		list_del(&event->hw.tp_list);
 		done = tu->filter.nr_systemwide ||
-			event->parent || event->attr.enable_on_exec ||
+			(event->hw.tp_target->flags & PF_EXITING) ||
 			uprobe_filter_event(tu, event);
-		list_add(&event->hw.tp_list, &tu->filter.perf_events);
 	} else {
+		tu->filter.nr_systemwide--;
 		done = tu->filter.nr_systemwide;
-		tu->filter.nr_systemwide++;
 	}
 	write_unlock(&tu->filter.rwlock);
 
 	if (!done)
-		uprobe_apply(tu->inode, tu->offset, &tu->consumer, true);
+		return uprobe_apply(tu->inode, tu->offset, &tu->consumer, false);
 
 	return 0;
 }
 
-static int uprobe_perf_close(struct trace_uprobe *tu, struct perf_event *event)
+static int uprobe_perf_open(struct trace_uprobe *tu, struct perf_event *event)
 {
 	bool done;
+	int err;
 
 	write_lock(&tu->filter.rwlock);
 	if (event->hw.tp_target) {
-		list_del(&event->hw.tp_list);
+		/*
+		 * event->parent != NULL means copy_process(), we can avoid
+		 * uprobe_apply(). current->mm must be probed and we can rely
+		 * on dup_mmap() which preserves the already installed bp's.
+		 *
+		 * attr.enable_on_exec means that exec/mmap will install the
+		 * breakpoints we need.
+		 */
 		done = tu->filter.nr_systemwide ||
-			(event->hw.tp_target->flags & PF_EXITING) ||
+			event->parent || event->attr.enable_on_exec ||
 			uprobe_filter_event(tu, event);
+		list_add(&event->hw.tp_list, &tu->filter.perf_events);
 	} else {
-		tu->filter.nr_systemwide--;
 		done = tu->filter.nr_systemwide;
+		tu->filter.nr_systemwide++;
 	}
 	write_unlock(&tu->filter.rwlock);
 
-	if (!done)
-		uprobe_apply(tu->inode, tu->offset, &tu->consumer, false);
-
-	return 0;
+	err = 0;
+	if (!done) {
+		err = uprobe_apply(tu->inode, tu->offset, &tu->consumer, true);
+		if (err)
+			uprobe_perf_close(tu, event);
+	}
+	return err;
 }
 
 static bool uprobe_perf_filter(struct uprobe_consumer *uc,
-- 
1.5.5.1


