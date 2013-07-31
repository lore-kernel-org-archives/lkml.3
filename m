Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759323Ab3GaI4j (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Jul 2013 04:56:39 -0400
Received: from terminus.zytor.com ([198.137.202.10]:41726 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759185Ab3GaI4f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Jul 2013 04:56:35 -0400
Date: Wed, 31 Jul 2013 01:55:58 -0700
From: tip-bot for Frederic Weisbecker <tipbot@zytor.com>
Message-ID: <tip-6050cb0b0b366092d1383bc23d7b16cd26db00f0@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, eranian@google.com, acme@redhat.com,
        hpa@zytor.com, mingo@kernel.org, peterz@infradead.org,
        namhyung@kernel.org, jolsa@redhat.com, fweisbec@gmail.com,
        tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, acme@redhat.com, eranian@google.com,
        linux-kernel@vger.kernel.org, peterz@infradead.org,
        namhyung@kernel.org, jolsa@redhat.com, fweisbec@gmail.com,
        tglx@linutronix.de
In-Reply-To: <1374539466-4799-2-git-send-email-fweisbec@gmail.com>
References: <1374539466-4799-2-git-send-email-fweisbec@gmail.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf:
  Fix branch stack refcount leak on callchain init failure
Git-Commit-ID: 6050cb0b0b366092d1383bc23d7b16cd26db00f0
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Wed, 31 Jul 2013 01:56:05 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  6050cb0b0b366092d1383bc23d7b16cd26db00f0
Gitweb:     http://git.kernel.org/tip/6050cb0b0b366092d1383bc23d7b16cd26db00f0
Author:     Frederic Weisbecker <fweisbec@gmail.com>
AuthorDate: Tue, 23 Jul 2013 02:30:59 +0200
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Tue, 30 Jul 2013 22:22:58 +0200

perf: Fix branch stack refcount leak on callchain init failure

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
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Stephane Eranian <eranian@google.com>
Signed-off-by: Peter Zijlstra <peterz@infradead.org>
Link: http://lkml.kernel.org/r/1374539466-4799-2-git-send-email-fweisbec@gmail.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 kernel/events/core.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/kernel/events/core.c b/kernel/events/core.c
index 1274114..f35aa7e 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -6567,6 +6567,12 @@ done:
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
@@ -6574,12 +6580,6 @@ done:
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
