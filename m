Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753395Ab3GWAbQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jul 2013 20:31:16 -0400
Received: from mail-wg0-f47.google.com ([74.125.82.47]:62667 "EHLO
	mail-wg0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752737Ab3GWAbO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jul 2013 20:31:14 -0400
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Namhyung Kim <namhyung@kernel.org>, Ingo Molnar <mingo@kernel.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Stephane Eranian <eranian@google.com>
Subject: [PATCH 1/8] perf: Fix branch stack refcount leak on callchain init failure
Date: Tue, 23 Jul 2013 02:30:59 +0200
Message-Id: <1374539466-4799-2-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1374539466-4799-1-git-send-email-fweisbec@gmail.com>
References: <1374539466-4799-1-git-send-email-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On callchain buffers allocation failure, free_event() is
called and all the accounting performed in perf_event_alloc()
for that event is cancelled.

But if the event has branch stack sampling, it is unaccounted
as well from the branch stack sampling events refcounts.

This is a bug because this accounting is performed after the
callchain buffer allocation. As a result, the branch stack sampling
events refcount can become negative.

To fix this, move the branch stack event accounting before the
callchain buffer allocation.

Reported-by: Peter Zijlstra <peterz@infradead.org>
Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Stephane Eranian <eranian@google.com>
---
 kernel/events/core.c |   12 ++++++------
 1 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/kernel/events/core.c b/kernel/events/core.c
index 5e2bce9..7ffb81e 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -6566,6 +6566,12 @@ done:
 			atomic_inc(&nr_comm_events);
 		if (event->attr.task)
 			atomic_inc(&nr_task_events);
+		if (has_branch_stack(event)) {
+			static_key_slow_inc(&perf_sched_events.key);
+			if (!(event->attach_state & PERF_ATTACH_TASK))
+				atomic_inc(&per_cpu(perf_branch_stack_events,
+						    event->cpu));
+		}
 		if (event->attr.sample_type & PERF_SAMPLE_CALLCHAIN) {
 			err = get_callchain_buffers();
 			if (err) {
@@ -6573,12 +6579,6 @@ done:
 				return ERR_PTR(err);
 			}
 		}
-		if (has_branch_stack(event)) {
-			static_key_slow_inc(&perf_sched_events.key);
-			if (!(event->attach_state & PERF_ATTACH_TASK))
-				atomic_inc(&per_cpu(perf_branch_stack_events,
-						    event->cpu));
-		}
 	}
 
 	return event;
-- 
1.7.5.4

