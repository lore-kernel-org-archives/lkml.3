Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757475AbaLKM0X (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Dec 2014 07:26:23 -0500
Received: from terminus.zytor.com ([198.137.202.10]:56110 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750986AbaLKM0U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Dec 2014 07:26:20 -0500
Date: Thu, 11 Dec 2014 04:25:23 -0800
From: tip-bot for Jiri Olsa <tipbot@zytor.com>
Message-ID: <tip-af91568e762d04931dcbdd6bef4655433d8b9418@git.kernel.org>
Cc: acme@redhat.com, mingo@kernel.org, peterz@infradead.org, hpa@zytor.com,
        tglx@linutronix.de, linux-kernel@vger.kernel.org,
        zheng.z.yan@intel.com, jolsa@redhat.com, torvalds@linux-foundation.org,
        eranian@google.com, stable@vger.kernel.org, jolsa@kernel.org,
        fweisbec@gmail.com, vince@deater.net
Reply-To: linux-kernel@vger.kernel.org, hpa@zytor.com, tglx@linutronix.de,
        peterz@infradead.org, mingo@kernel.org, acme@redhat.com,
        jolsa@redhat.com, zheng.z.yan@intel.com, torvalds@linux-foundation.org,
        fweisbec@gmail.com, vince@deater.net, jolsa@kernel.org,
        stable@vger.kernel.org, eranian@google.com
In-Reply-To: <1418243031-20367-2-git-send-email-jolsa@kernel.org>
References: <1418243031-20367-2-git-send-email-jolsa@kernel.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/urgent] perf/x86/intel/uncore:
  Make sure only uncore events are collected
Git-Commit-ID: af91568e762d04931dcbdd6bef4655433d8b9418
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  af91568e762d04931dcbdd6bef4655433d8b9418
Gitweb:     http://git.kernel.org/tip/af91568e762d04931dcbdd6bef4655433d8b9418
Author:     Jiri Olsa <jolsa@kernel.org>
AuthorDate: Wed, 10 Dec 2014 21:23:50 +0100
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Thu, 11 Dec 2014 11:24:14 +0100

perf/x86/intel/uncore: Make sure only uncore events are collected

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
Cc: <stable@vger.kernel.org>
Link: http://lkml.kernel.org/r/1418243031-20367-2-git-send-email-jolsa@kernel.org
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 arch/x86/kernel/cpu/perf_event_intel_uncore.c | 22 +++++++++++++++++++---
 1 file changed, 19 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kernel/cpu/perf_event_intel_uncore.c b/arch/x86/kernel/cpu/perf_event_intel_uncore.c
index 9762dbd..e98f68c 100644
--- a/arch/x86/kernel/cpu/perf_event_intel_uncore.c
+++ b/arch/x86/kernel/cpu/perf_event_intel_uncore.c
@@ -276,6 +276,17 @@ static struct intel_uncore_box *uncore_alloc_box(struct intel_uncore_type *type,
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
@@ -290,13 +301,18 @@ uncore_collect_events(struct intel_uncore_box *box, struct perf_event *leader, b
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
