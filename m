Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756074Ab3IYM42 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Sep 2013 08:56:28 -0400
Received: from mx1.redhat.com ([209.132.183.28]:42415 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755516Ab3IYMvQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Sep 2013 08:51:16 -0400
From: Jiri Olsa <jolsa@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Jiri Olsa <jolsa@redhat.com>, Arnaldo Carvalho de Melo <acme@redhat.com>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [PATCH 04/21] perf: Move event state initialization before/behind the pmu add/del calls
Date: Wed, 25 Sep 2013 14:50:30 +0200
Message-Id: <1380113447-17144-5-git-send-email-jolsa@redhat.com>
In-Reply-To: <1380113447-17144-1-git-send-email-jolsa@redhat.com>
References: <1380113447-17144-1-git-send-email-jolsa@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Moving event state initialization before the pmu->del
and behind the pmu->add call.

This way the toggler can refer to event->state and
make sure the event is really scheduled before
calling pmu->stop/start in case we get interrupted
inside event_sched_in/event_sched_out functions.

Original-patch-by: Frederic Weisbecker <fweisbec@gmail.com>
Signed-off-by: Jiri Olsa <jolsa@redhat.com>
Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 kernel/events/core.c | 14 ++++++++------
 1 file changed, 8 insertions(+), 6 deletions(-)

diff --git a/kernel/events/core.c b/kernel/events/core.c
index dd236b6..e8674e4 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -1388,14 +1388,16 @@ event_sched_out(struct perf_event *event,
 	if (event->state != PERF_EVENT_STATE_ACTIVE)
 		return;
 
+	event->tstamp_stopped = tstamp;
+	event->oncpu = -1;
 	event->state = PERF_EVENT_STATE_INACTIVE;
+
+	event->pmu->del(event, 0);
+
 	if (event->pending_disable) {
 		event->pending_disable = 0;
 		event->state = PERF_EVENT_STATE_OFF;
 	}
-	event->tstamp_stopped = tstamp;
-	event->pmu->del(event, 0);
-	event->oncpu = -1;
 
 	if (!is_software_event(event))
 		cpuctx->active_oncpu--;
@@ -1648,9 +1650,6 @@ event_sched_in(struct perf_event *event,
 	if (event->state <= PERF_EVENT_STATE_OFF)
 		return 0;
 
-	event->state = PERF_EVENT_STATE_ACTIVE;
-	event->oncpu = smp_processor_id();
-
 	/*
 	 * Unthrottle events, since we scheduled we might have missed several
 	 * ticks already, also for a heavily scheduling task there is little
@@ -1672,6 +1671,9 @@ event_sched_in(struct perf_event *event,
 		return -EAGAIN;
 	}
 
+	event->state = PERF_EVENT_STATE_ACTIVE;
+	event->oncpu = smp_processor_id();
+
 	event->tstamp_running += tstamp - event->tstamp_stopped;
 
 	perf_set_shadow_time(event, ctx, tstamp);
-- 
1.7.11.7

