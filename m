Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030397Ab3E3Jx4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 May 2013 05:53:56 -0400
Received: from mx1.redhat.com ([209.132.183.28]:8968 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030327Ab3E3Jxj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 May 2013 05:53:39 -0400
From: Jiri Olsa <jolsa@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Jiri Olsa <jolsa@redhat.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>,
        Paul Mackerras <paulus@samba.org>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Namhyung Kim <namhyung@kernel.org>,
        Stephane Eranian <eranian@google.com>
Subject: [PATCH 1/2] perf: Enable wakeup_events logic for all events
Date: Thu, 30 May 2013 11:53:06 +0200
Message-Id: <1369907587-8963-2-git-send-email-jolsa@redhat.com>
In-Reply-To: <1369907587-8963-1-git-send-email-jolsa@redhat.com>
References: <1369907587-8963-1-git-send-email-jolsa@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently the perf_events_attr::wakeup_events logic is
checked only for regular samples.

If we have an event that produce only auxiliary events
(MMAP|COMM|EXIT|FORK), the poll call does not follow
the perf_events_attr wakeup_events setup and reports
no data.

Fixing this by moving the perf_events_attr::wakeup_events
checking logic into the function and calling it from
perf_output_end. This way any output event is checked
properly.

Signed-off-by: Jiri Olsa <jolsa@redhat.com>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Stephane Eranian <eranian@google.com>
---
 kernel/events/core.c        | 14 --------------
 kernel/events/ring_buffer.c | 20 ++++++++++++++++++++
 2 files changed, 20 insertions(+), 14 deletions(-)

diff --git a/kernel/events/core.c b/kernel/events/core.c
index a0780b3..516eb25 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -4281,20 +4281,6 @@ void perf_output_sample(struct perf_output_handle *handle,
 		}
 	}
 
-	if (!event->attr.watermark) {
-		int wakeup_events = event->attr.wakeup_events;
-
-		if (wakeup_events) {
-			struct ring_buffer *rb = handle->rb;
-			int events = local_inc_return(&rb->events);
-
-			if (events >= wakeup_events) {
-				local_sub(wakeup_events, &rb->events);
-				local_inc(&rb->wakeup);
-			}
-		}
-	}
-
 	if (sample_type & PERF_SAMPLE_BRANCH_STACK) {
 		if (data->br_stack) {
 			size_t size;
diff --git a/kernel/events/ring_buffer.c b/kernel/events/ring_buffer.c
index cd55144..1385fb1 100644
--- a/kernel/events/ring_buffer.c
+++ b/kernel/events/ring_buffer.c
@@ -54,6 +54,25 @@ static void perf_output_wakeup(struct perf_output_handle *handle)
 	irq_work_queue(&handle->event->pending);
 }
 
+static void perf_output_check_wakeup(struct perf_output_handle *handle)
+{
+	struct perf_event *event = handle->event;
+
+	if (!event->attr.watermark) {
+		int wakeup_events = event->attr.wakeup_events;
+
+		if (wakeup_events) {
+			struct ring_buffer *rb = handle->rb;
+			int events = local_inc_return(&rb->events);
+
+			if (events >= wakeup_events) {
+				local_sub(wakeup_events, &rb->events);
+				local_inc(&rb->wakeup);
+			}
+		}
+	}
+}
+
 /*
  * We need to ensure a later event_id doesn't publish a head when a former
  * event isn't done writing. However since we need to deal with NMIs we
@@ -208,6 +227,7 @@ unsigned int perf_output_skip(struct perf_output_handle *handle,
 
 void perf_output_end(struct perf_output_handle *handle)
 {
+	perf_output_check_wakeup(handle);
 	perf_output_put_handle(handle);
 	rcu_read_unlock();
 }
-- 
1.7.11.7

