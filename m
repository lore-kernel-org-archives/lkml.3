Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753719Ab3GWAbY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jul 2013 20:31:24 -0400
Received: from mail-wg0-f48.google.com ([74.125.82.48]:50801 "EHLO
	mail-wg0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753555Ab3GWAbU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jul 2013 20:31:20 -0400
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Namhyung Kim <namhyung@kernel.org>, Ingo Molnar <mingo@kernel.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Stephane Eranian <eranian@google.com>
Subject: [PATCH 6/8] perf: Account freq events per cpu
Date: Tue, 23 Jul 2013 02:31:04 +0200
Message-Id: <1374539466-4799-7-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1374539466-4799-1-git-send-email-fweisbec@gmail.com>
References: <1374539466-4799-1-git-send-email-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is going to be used by the full dynticks subsystem
as a finer-grained information to know when to keep and
when to stop the tick.

Original-patch-by: Peter Zijlstra <peterz@infradead.org>
Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Stephane Eranian <eranian@google.com>
---
 kernel/events/core.c |    7 +++++++
 1 files changed, 7 insertions(+), 0 deletions(-)

diff --git a/kernel/events/core.c b/kernel/events/core.c
index b40c3db..f9bd39b 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -141,6 +141,7 @@ enum event_type_t {
 struct static_key_deferred perf_sched_events __read_mostly;
 static DEFINE_PER_CPU(atomic_t, perf_cgroup_events);
 static DEFINE_PER_CPU(atomic_t, perf_branch_stack_events);
+static DEFINE_PER_CPU(atomic_t, perf_freq_events);
 
 static atomic_t nr_mmap_events __read_mostly;
 static atomic_t nr_comm_events __read_mostly;
@@ -3139,6 +3140,9 @@ static void unaccount_event_cpu(struct perf_event *event, int cpu)
 	}
 	if (is_cgroup_event(event))
 		atomic_dec(&per_cpu(perf_cgroup_events, cpu));
+
+	if (event->attr.freq)
+		atomic_dec(&per_cpu(perf_freq_events, cpu));
 }
 
 static void unaccount_event(struct perf_event *event)
@@ -6473,6 +6477,9 @@ static void account_event_cpu(struct perf_event *event, int cpu)
 	}
 	if (is_cgroup_event(event))
 		atomic_inc(&per_cpu(perf_cgroup_events, cpu));
+
+	if (event->attr.freq)
+		atomic_inc(&per_cpu(perf_freq_events, cpu));
 }
 
 static void account_event(struct perf_event *event)
-- 
1.7.5.4

