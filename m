Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755962AbbALSrw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2015 13:47:52 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:58283 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755159AbbALSac (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2015 13:30:32 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Jiri Olsa <jolsa@redhat.com>, Arnaldo Carvalho de Melo <acme@redhat.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>,
        "Yan, Zheng" <zheng.z.yan@intel.com>, Ingo Molnar <mingo@kernel.org>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.16.y-ckt 162/216] perf/x86/intel/uncore: Make sure only uncore events are collected
Date: Mon, 12 Jan 2015 18:29:00 +0000
Message-Id: <1421087394-2712-50-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 2.1.4
In-Reply-To: <1421085933-32536-1-git-send-email-luis.henriques@canonical.com>
References: <1421085933-32536-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.16
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.16.7-ckt4 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jiri Olsa <jolsa@kernel.org>

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
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 arch/x86/kernel/cpu/perf_event_intel_uncore.c | 22 +++++++++++++++++++---
 1 file changed, 19 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kernel/cpu/perf_event_intel_uncore.c b/arch/x86/kernel/cpu/perf_event_intel_uncore.c
index ae6552a0701f..a4c37cb40519 100644
--- a/arch/x86/kernel/cpu/perf_event_intel_uncore.c
+++ b/arch/x86/kernel/cpu/perf_event_intel_uncore.c
@@ -3249,6 +3249,17 @@ static struct intel_uncore_box *uncore_alloc_box(struct intel_uncore_type *type,
 	return box;
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
@@ -3263,13 +3274,18 @@ uncore_collect_events(struct intel_uncore_box *box, struct perf_event *leader, b
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
2.1.4

