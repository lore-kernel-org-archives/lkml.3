Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756740AbaDXLzn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2014 07:55:43 -0400
Received: from mx1.redhat.com ([209.132.183.28]:7357 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753427AbaDXLzj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2014 07:55:39 -0400
Date: Thu, 24 Apr 2014 13:55:19 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Ingo Molnar <mingo@elte.hu>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Anton Arapov <aarapov@redhat.com>, David Long <dave.long@linaro.org>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2 1/2] uprobes/tracing: Make uprobe_perf_close() visible
	to uprobe_perf_open()
Message-ID: <20140424115519.GB8882@redhat.com>
References: <20140423165808.GA29485@redhat.com> <20140423165830.GA29493@redhat.com> <20140423231728.1b95e37c@gandalf.local.home> <20140424115458.GA8882@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140424115458.GA8882@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Preparation. Move uprobe_perf_close() up before uprobe_perf_open() to
avoid the forward declaration in the next patch and make it readable.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Acked-by: Steven Rostedt <rostedt@goodmis.org>
Acked-by: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
---
 kernel/trace/trace_uprobe.c |   36 ++++++++++++++++++------------------
 1 files changed, 18 insertions(+), 18 deletions(-)

diff --git a/kernel/trace/trace_uprobe.c b/kernel/trace/trace_uprobe.c
index 930e514..1ed0030 100644
--- a/kernel/trace/trace_uprobe.c
+++ b/kernel/trace/trace_uprobe.c
@@ -1003,54 +1003,54 @@ uprobe_filter_event(struct trace_uprobe *tu, struct perf_event *event)
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
+		uprobe_apply(tu->inode, tu->offset, &tu->consumer, false);
 
 	return 0;
 }
 
-static int uprobe_perf_close(struct trace_uprobe *tu, struct perf_event *event)
+static int uprobe_perf_open(struct trace_uprobe *tu, struct perf_event *event)
 {
 	bool done;
 
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
 
 	if (!done)
-		uprobe_apply(tu->inode, tu->offset, &tu->consumer, false);
+		uprobe_apply(tu->inode, tu->offset, &tu->consumer, true);
 
 	return 0;
 }
-- 
1.5.5.1


