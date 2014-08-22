Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756231AbaHVNFz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Aug 2014 09:05:55 -0400
Received: from mx1.redhat.com ([209.132.183.28]:21520 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756165AbaHVNFx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Aug 2014 09:05:53 -0400
From: Jiri Olsa <jolsa@kernel.org>
To: linux-kernel@vger.kernel.org
Cc: Jiri Olsa <jolsa@kernel.org>, Andi Kleen <andi@firstfloor.org>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@kernel.org>,
        "Jen-Cheng(Tommy) Huang" <tommy24@gatech.edu>,
        Namhyung Kim <namhyung@kernel.org>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Stephane Eranian <eranian@google.com>
Subject: [PATCH 1/5] perf: Deny optimized switch for events read by PERF_SAMPLE_READ
Date: Fri, 22 Aug 2014 15:05:14 +0200
Message-Id: <1408712718-19656-2-git-send-email-jolsa@kernel.org>
In-Reply-To: <1408712718-19656-1-git-send-email-jolsa@kernel.org>
References: <1408712718-19656-1-git-send-email-jolsa@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The optimized task context switch for cloned perf events just
swaps whole perf event contexts (of current and next process)
if it finds them suitable. Events from the 'current' context
will now measure data of the 'next' context and vice versa.

This is ok for cases where we are not directly interested in
the event->count value of separate child events, like:
  - standard sampling, where we take 'period' value for the
    event count
  - counting, where we accumulate all events (children)
    into a single count value

But in case we read event by using the PERF_SAMPLE_READ sample
type, we are interested in direct event->count value meassured
in specific task. Switching events within tasks for this kind
of measurements corrupts data.

Fixing this by setting/unsetting pin_count for perf event
context once event with PERF_SAMPLE_READ read is added/removed.
The pin_count value != 0 makes the context not suitable for
optimized switch.

Cc: Andi Kleen <andi@firstfloor.org>
Cc: Arnaldo Carvalho de Melo <acme@kernel.org>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Jen-Cheng(Tommy) Huang <tommy24@gatech.edu>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Stephane Eranian <eranian@google.com>
Signed-off-by: Jiri Olsa <jolsa@kernel.org>
---
 kernel/events/core.c | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/kernel/events/core.c b/kernel/events/core.c
index 2d7363adf678..a1d220cf739b 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -1117,6 +1117,12 @@ ctx_group_list(struct perf_event *event, struct perf_event_context *ctx)
 		return &ctx->flexible_groups;
 }
 
+static bool has_inherit_read(struct perf_event *event)
+{
+	return event->attr.inherit &&
+	       (event->attr.sample_type & PERF_SAMPLE_READ);
+}
+
 /*
  * Add a event from the lists for its context.
  * Must be called with ctx->mutex and ctx->lock held.
@@ -1148,6 +1154,9 @@ list_add_event(struct perf_event *event, struct perf_event_context *ctx)
 	if (has_branch_stack(event))
 		ctx->nr_branch_stack++;
 
+	if (has_inherit_read(event))
+		ctx->pin_count++;
+
 	list_add_rcu(&event->event_entry, &ctx->event_list);
 	if (!ctx->nr_events)
 		perf_pmu_rotate_start(ctx->pmu);
@@ -1313,6 +1322,9 @@ list_del_event(struct perf_event *event, struct perf_event_context *ctx)
 	if (has_branch_stack(event))
 		ctx->nr_branch_stack--;
 
+	if (has_inherit_read(event))
+		ctx->pin_count--;
+
 	ctx->nr_events--;
 	if (event->attr.inherit_stat)
 		ctx->nr_stat--;
-- 
1.8.3.1

