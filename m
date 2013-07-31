Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759338Ab3GaI4r (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Jul 2013 04:56:47 -0400
Received: from terminus.zytor.com ([198.137.202.10]:41739 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759185Ab3GaI4m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Jul 2013 04:56:42 -0400
Date: Wed, 31 Jul 2013 01:56:08 -0700
From: tip-bot for Frederic Weisbecker <tipbot@zytor.com>
Message-ID: <tip-90983b16078ab0fdc58f0dab3e8e3da79c9579a2@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, eranian@google.com, acme@redhat.com,
        hpa@zytor.com, mingo@kernel.org, peterz@infradead.org,
        namhyung@kernel.org, jolsa@redhat.com, fweisbec@gmail.com,
        tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, acme@redhat.com, eranian@google.com,
        linux-kernel@vger.kernel.org, peterz@infradead.org,
        namhyung@kernel.org, jolsa@redhat.com, fweisbec@gmail.com,
        tglx@linutronix.de
In-Reply-To: <1374539466-4799-3-git-send-email-fweisbec@gmail.com>
References: <1374539466-4799-3-git-send-email-fweisbec@gmail.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf: Sanitize get_callchain_buffer()
Git-Commit-ID: 90983b16078ab0fdc58f0dab3e8e3da79c9579a2
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Wed, 31 Jul 2013 01:56:15 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  90983b16078ab0fdc58f0dab3e8e3da79c9579a2
Gitweb:     http://git.kernel.org/tip/90983b16078ab0fdc58f0dab3e8e3da79c9579a2
Author:     Frederic Weisbecker <fweisbec@gmail.com>
AuthorDate: Tue, 23 Jul 2013 02:31:00 +0200
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Tue, 30 Jul 2013 22:29:12 +0200

perf: Sanitize get_callchain_buffer()

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
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Stephane Eranian <eranian@google.com>
Signed-off-by: Peter Zijlstra <peterz@infradead.org>
Link: http://lkml.kernel.org/r/1374539466-4799-3-git-send-email-fweisbec@gmail.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 kernel/events/callchain.c |  2 ++
 kernel/events/core.c      | 41 +++++++++++++++++++++--------------------
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
index f35aa7e..3b99862 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -6457,7 +6457,7 @@ perf_event_alloc(struct perf_event_attr *attr, int cpu,
 	struct pmu *pmu;
 	struct perf_event *event;
 	struct hw_perf_event *hwc;
-	long err;
+	long err = -EINVAL;
 
 	if ((unsigned)cpu >= nr_cpu_ids) {
 		if (!task || cpu != -1)
@@ -6540,25 +6540,23 @@ perf_event_alloc(struct perf_event_attr *attr, int cpu,
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
@@ -6573,16 +6571,19 @@ done:
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
