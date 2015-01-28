Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762116AbbA2KP6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jan 2015 05:15:58 -0500
Received: from ip4-83-240-67-251.cust.nbox.cz ([83.240.67.251]:44737 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1757043AbbA2JBN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jan 2015 04:01:13 -0500
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Jiri Olsa <jolsa@kernel.org>,
        Jiri Olsa <jolsa@redhat.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>,
        "Yan, Zheng" <zheng.z.yan@intel.com>, Ingo Molnar <mingo@kernel.org>,
        Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 049/176] perf/x86/intel/uncore: Make sure only uncore events are collected
Date: Wed, 28 Jan 2015 15:27:59 +0100
Message-Id: <5f34dcba9ab45437a8de83aab6298dd0183b334c.1422455352.git.jslaby@suse.cz>
X-Mailer: git-send-email 2.2.2
In-Reply-To: <ce4a451f616a1e7ab58cfeceea5e49c8b1c68c81.1422455352.git.jslaby@suse.cz>
References: <ce4a451f616a1e7ab58cfeceea5e49c8b1c68c81.1422455352.git.jslaby@suse.cz>
In-Reply-To: <cover.1422455352.git.jslaby@suse.cz>
References: <cover.1422455352.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jiri Olsa <jolsa@kernel.org>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

commit af91568e762d04931dcbdd6bef4655433d8b9418 upstream.

The uncore_collect_events functions assumes that event group
might contain only uncore events which is wrong, because it
might contain any type of events.

This bug leads to uncore framework touching 'not' uncore events,
which could end up all sorts of bugs.

One was triggered by Vince's perf fuzzer, when the uncore code
touched breakpoint event private event space as if it was uncore
event and caused BUG:

   BUG: unable to handle kernel paging request at ffffffff82822068
   IP: [<ffffffff81020338>] uncore_assign_events+0x188/0x250
   ...

The code in uncore_assign_events() function was looking for
event->hw.idx data while the event was initialized as a
breakpoint with different members in event->hw union.

This patch forces uncore_collect_events() to collect only uncore
events.

Reported-by: Vince Weaver <vince@deater.net>
Signed-off-by: Jiri Olsa <jolsa@redhat.com>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Cc: Yan, Zheng <zheng.z.yan@intel.com>
Link: http://lkml.kernel.org/r/1418243031-20367-2-git-send-email-jolsa@kernel.org
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 arch/x86/kernel/cpu/perf_event_intel_uncore.c | 22 +++++++++++++++++++---
 1 file changed, 19 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kernel/cpu/perf_event_intel_uncore.c b/arch/x86/kernel/cpu/perf_event_intel_uncore.c
index 4118f9f68315..3e1cfbb5a6cf 100644
--- a/arch/x86/kernel/cpu/perf_event_intel_uncore.c
+++ b/arch/x86/kernel/cpu/perf_event_intel_uncore.c
@@ -2764,6 +2764,17 @@ static struct intel_uncore_box *uncore_event_to_box(struct perf_event *event)
 	return uncore_pmu_to_box(uncore_event_to_pmu(event), smp_processor_id());
 }
 
+/*
+ * Using uncore_pmu_event_init pmu event_init callback
+ * as a detection point for uncore events.
+ */
+static int uncore_pmu_event_init(struct perf_event *event);
+
+static bool is_uncore_event(struct perf_event *event)
+{
+	return event->pmu->event_init == uncore_pmu_event_init;
+}
+
 static int
 uncore_collect_events(struct intel_uncore_box *box, struct perf_event *leader, bool dogrp)
 {
@@ -2778,13 +2789,18 @@ uncore_collect_events(struct intel_uncore_box *box, struct perf_event *leader, b
 		return -EINVAL;
 
 	n = box->n_events;
-	box->event_list[n] = leader;
-	n++;
+
+	if (is_uncore_event(leader)) {
+		box->event_list[n] = leader;
+		n++;
+	}
+
 	if (!dogrp)
 		return n;
 
 	list_for_each_entry(event, &leader->sibling_list, group_entry) {
-		if (event->state <= PERF_EVENT_STATE_OFF)
+		if (!is_uncore_event(event) ||
+		    event->state <= PERF_EVENT_STATE_OFF)
 			continue;
 
 		if (n >= max_count)
-- 
2.2.2

