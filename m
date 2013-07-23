Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753855Ab3GWAco (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jul 2013 20:32:44 -0400
Received: from mail-wi0-f172.google.com ([209.85.212.172]:56141 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751589Ab3GWAbP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jul 2013 20:31:15 -0400
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Namhyung Kim <namhyung@kernel.org>, Ingo Molnar <mingo@kernel.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Stephane Eranian <eranian@google.com>
Subject: [PATCH 2/8] perf: Sanitize get_callchain_buffer()
Date: Tue, 23 Jul 2013 02:31:00 +0200
Message-Id: <1374539466-4799-3-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1374539466-4799-1-git-send-email-fweisbec@gmail.com>
References: <1374539466-4799-1-git-send-email-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In case of allocation failure, get_callchain_buffer() keeps the
refcount incremented for the current event.

As a result, when get_callchain_buffers() returns an error,
we must cleanup what it did by cancelling its last refcount
with a call to put_callchain_buffers().

This is a hack in order to be able to call free_event()
after that failure.

The original purpose of that was to simplify the failure
path. But this error handling is actually counter intuitive,
ugly and not very easy to follow because one expect to
see the resources used to perform a service to be cleaned
by the callee if case of failure, not by the caller.

So lets clean this up by cancelling the refcount from
get_callchain_buffer() in case of failure. And correctly free
the event accordingly in perf_event_alloc().

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Stephane Eranian <eranian@google.com>
---
 kernel/events/callchain.c |    2 ++
 kernel/events/core.c      |   41 +++++++++++++++++++++--------------------
 2 files changed, 23 insertions(+), 20 deletions(-)

diff --git a/kernel/events/callchain.c b/kernel/events/callchain.c
index c772061..76a8bc5 100644
--- a/kernel/events/callchain.c
+++ b/kernel/events/callchain.c
@@ -117,6 +117,8 @@ int get_callchain_buffers(void)
 	err = alloc_callchain_buffers();
 exit:
 	mutex_unlock(&callchain_mutex);
+	if (err)
+		atomic_dec(&nr_callchain_events);
 
 	return err;
 }
diff --git a/kernel/events/core.c b/kernel/events/core.c
index 7ffb81e..c5f435f 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -6456,7 +6456,7 @@ perf_event_alloc(struct perf_event_attr *attr, int cpu,
 	struct pmu *pmu;
 	struct perf_event *event;
 	struct hw_perf_event *hwc;
-	long err;
+	long err = -EINVAL;
 
 	if ((unsigned)cpu >= nr_cpu_ids) {
 		if (!task || cpu != -1)
@@ -6539,25 +6539,23 @@ perf_event_alloc(struct perf_event_attr *attr, int cpu,
 	 * we currently do not support PERF_FORMAT_GROUP on inherited events
 	 */
 	if (attr->inherit && (attr->read_format & PERF_FORMAT_GROUP))
-		goto done;
+		goto err_ns;
 
 	pmu = perf_init_event(event);
-
-done:
-	err = 0;
 	if (!pmu)
-		err = -EINVAL;
-	else if (IS_ERR(pmu))
+		goto err_ns;
+	else if (IS_ERR(pmu)) {
 		err = PTR_ERR(pmu);
-
-	if (err) {
-		if (event->ns)
-			put_pid_ns(event->ns);
-		kfree(event);
-		return ERR_PTR(err);
+		goto err_ns;
 	}
 
 	if (!event->parent) {
+		if (event->attr.sample_type & PERF_SAMPLE_CALLCHAIN) {
+			err = get_callchain_buffers();
+			if (err)
+				goto err_pmu;
+		}
+
 		if (event->attach_state & PERF_ATTACH_TASK)
 			static_key_slow_inc(&perf_sched_events.key);
 		if (event->attr.mmap || event->attr.mmap_data)
@@ -6572,16 +6570,19 @@ done:
 				atomic_inc(&per_cpu(perf_branch_stack_events,
 						    event->cpu));
 		}
-		if (event->attr.sample_type & PERF_SAMPLE_CALLCHAIN) {
-			err = get_callchain_buffers();
-			if (err) {
-				free_event(event);
-				return ERR_PTR(err);
-			}
-		}
 	}
 
 	return event;
+
+err_pmu:
+	if (event->destroy)
+		event->destroy(event);
+err_ns:
+	if (event->ns)
+		put_pid_ns(event->ns);
+	kfree(event);
+
+	return ERR_PTR(err);
 }
 
 static int perf_copy_attr(struct perf_event_attr __user *uattr,
-- 
1.7.5.4

