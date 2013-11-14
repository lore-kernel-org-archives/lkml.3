Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752161Ab3KNIHu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Nov 2013 03:07:50 -0500
Received: from mailout1.zih.tu-dresden.de ([141.30.67.72]:39076 "EHLO
	mailout1.zih.tu-dresden.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751181Ab3KNIHq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Nov 2013 03:07:46 -0500
Message-ID: <528484CB.7@tu-dresden.de>
Date: Thu, 14 Nov 2013 09:07:39 +0100
From: Joseph Schuchart <joseph.schuchart@tu-dresden.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
CC: thomas.ilsche@tu-dresden.de,
        Joseph Schuchart <joseph.schuchart@tu-dresden.de>,
        linux-kernel@vger.kernel.org
Subject: [PATCH] Perf: Correct Assumptions about Sample Timestamps in Passes
Content-Type: multipart/mixed;
 boundary="------------060000010808030402030804"
X-TUD-Virus-Scanned: mailout1.zih.tu-dresden.de
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------060000010808030402030804
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit

Good morning,

We came across a problem in perf script which causes it to abort reading
a file produced with perf record, complaining about timestamps being
earlier than the last flushed timeslice. ("Warning: Timestamp below last
timeslice flush")

While investigating the issue, we found that the assumptions about the
relation of timestamps between different CPUs and the passes in which
the data is read from the kernel might not be entirely valid. The
current model (as is described in util/session.c lines 552 to 590)
states that it is safe to store the maximum timestamp seen in pass n
(T_n) and use it to flush the samples after pass n+1, assuming that
there will be samples with timestamps >=T_n for all CPUs in pass n+1.

However, based on the description given in the source file, we can come
up with an example that breaks this assumption:

 *    ============ PASS n =================
 *       CPU 0         |   CPU 1
 *                     |
 *    cnt1 timestamps  |   cnt2 timestamps
 *          1          |         2
 *          -          |         3
 *          -          |         4  <--- max recorded
 *
 *    ============ PASS n + 1 ==============
 *       CPU 0         |   CPU 1
 *                     |
 *    cnt1 timestamps  |   cnt2 timestamps
 *          2          |         5
 *          -          |         6
 *          -          |         7 <---- max recorded
 *
 *      Flush every events below timestamp 4
 *
 *    ============ PASS n + 2 ==============
 *       CPU 0         |   CPU 1
 *                     |
 *    cnt1 timestamps  |   cnt2 timestamps
 *          3          |         8
 *    --> This event will break the assumption and lead to the error
described above.
 *          4          |         9
 *          -          |         10
 *

Note that the trace depicted above is perfectly legal (to our
understanding) and we have seen such a trace coming out of perf record.
Unfortunately, we can only reproduce it when running a large proprietary
application for which we cannot provide the trace data. Any attempt to
come up with a small reproducer failed so far. I hope the above
description of the problem is sufficient, though.

The attached patch modifies the session to keep a record of the maximum
timestamp seen per CPU and the samples are flushed after reading pass n
up to the minimum of the maximum timestamps of each CPU in this pass.
The change should be small and do not interfere with any other
functionality of perf. The patch is based on the current Linux version
in git.

Please let me know if you need any further information.

Signed-off-by: Joseph Schuchart <joseph.schuchart@tu-dresden.de>

Thanks,
Joseph
-- 
Dipl. Inf. Joseph Schuchart
Computer Scientist

Technische Universität Dresden
Center for Information Services and High Performance Computing (ZIH)
01062 Dresden, Germany

Phone: +49 351 463-36494
Fax: +49 351 463-3773
E-Mail: joseph.schuchart@tu-dresden.de

--------------060000010808030402030804
Content-Type: text/x-patch;
 name="perf_timestamp_pass.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="perf_timestamp_pass.diff"

diff --git a/tools/perf/util/session.c b/tools/perf/util/session.c
index f36d24a..1d9c81e 100644
--- a/tools/perf/util/session.c
+++ b/tools/perf/util/session.c
@@ -70,6 +70,7 @@ static void perf_session__destroy_kernel_maps(struct perf_session *session)
 struct perf_session *perf_session__new(struct perf_data_file *file,
 				       bool repipe, struct perf_tool *tool)
 {
+	int i;
 	struct perf_session *session = zalloc(sizeof(*session));
 
 	if (!session)
@@ -79,6 +80,8 @@ struct perf_session *perf_session__new(struct perf_data_file *file,
 	INIT_LIST_HEAD(&session->ordered_samples.samples);
 	INIT_LIST_HEAD(&session->ordered_samples.sample_cache);
 	INIT_LIST_HEAD(&session->ordered_samples.to_free);
+	for (i = 0; i < MAX_NR_CPUS; i++)
+		session->ordered_samples.max_timestamps[i] = ULLONG_MAX;
 	machines__init(&session->machines);
 
 	if (file) {
@@ -549,15 +552,24 @@ static int flush_sample_queue(struct perf_session *s,
 	return 0;
 }
 
+static inline void set_next_flush(struct perf_session *session)
+{
+	int i;
+	u64 min_max_timestamp = session->ordered_samples.max_timestamps[0];
+	for (i = 1; i < MAX_NR_CPUS; i++) {
+		if (min_max_timestamp > session->ordered_samples.max_timestamps[i])
+			min_max_timestamp = session->ordered_samples.max_timestamps[i];
+	}
+	session->ordered_samples.next_flush = min_max_timestamp;
+}
+
 /*
  * When perf record finishes a pass on every buffers, it records this pseudo
  * event.
- * We record the max timestamp t found in the pass n.
- * Assuming these timestamps are monotonic across cpus, we know that if
- * a buffer still has events with timestamps below t, they will be all
- * available and then read in the pass n + 1.
- * Hence when we start to read the pass n + 2, we can safely flush every
- * events with timestamps below t.
+ * We record the max timestamp t_i for every cpu found in the pass n and
+ * flush up to min(t_i) after reading the samples of this pass.
+ * All other samples need to be stored until min(t_i) changes
+ * during an upcoming pass.
  *
  *    ============ PASS n =================
  *       CPU 0         |   CPU 1
@@ -565,7 +577,8 @@ static int flush_sample_queue(struct perf_session *s,
  *    cnt1 timestamps  |   cnt2 timestamps
  *          1          |         2
  *          2          |         3
- *          -          |         4  <--- max recorded
+ *          -          |         4
+ *     Flush all events up to timestamp 2
  *
  *    ============ PASS n + 1 ==============
  *       CPU 0         |   CPU 1
@@ -573,29 +586,28 @@ static int flush_sample_queue(struct perf_session *s,
  *    cnt1 timestamps  |   cnt2 timestamps
  *          3          |         5
  *          4          |         6
- *          5          |         7 <---- max recorded
+ *          5          |         7
  *
- *      Flush every events below timestamp 4
+ *      Flush all events up to timestamp 5
  *
  *    ============ PASS n + 2 ==============
  *       CPU 0         |   CPU 1
  *                     |
  *    cnt1 timestamps  |   cnt2 timestamps
  *          6          |         8
- *          7          |         9
+ *          -          |         9
  *          -          |         10
  *
- *      Flush every events below timestamp 7
+ *      Flush all events up to timestamp 6
  *      etc...
  */
 static int process_finished_round(struct perf_tool *tool,
 				  union perf_event *event __maybe_unused,
 				  struct perf_session *session)
 {
-	int ret = flush_sample_queue(session, tool);
-	if (!ret)
-		session->ordered_samples.next_flush = session->ordered_samples.max_timestamp;
-
+	int ret;
+	set_next_flush(session);
+	ret = flush_sample_queue(session, tool);
 	return ret;
 }
 
@@ -612,7 +624,6 @@ static void __queue_event(struct sample_queue *new, struct perf_session *s)
 
 	if (!sample) {
 		list_add(&new->list, &os->samples);
-		os->max_timestamp = timestamp;
 		return;
 	}
 
@@ -626,7 +637,6 @@ static void __queue_event(struct sample_queue *new, struct perf_session *s)
 			p = sample->list.next;
 			if (p == &os->samples) {
 				list_add_tail(&new->list, &os->samples);
-				os->max_timestamp = timestamp;
 				return;
 			}
 			sample = list_entry(p, struct sample_queue, list);
@@ -685,6 +695,8 @@ int perf_session_queue_event(struct perf_session *s, union perf_event *event,
 
 	__queue_event(new, s);
 
+	os->max_timestamps[sample->cpu] = timestamp;
+
 	return 0;
 }
 
diff --git a/tools/perf/util/session.h b/tools/perf/util/session.h
index 50f6409..6e3bc16 100644
--- a/tools/perf/util/session.h
+++ b/tools/perf/util/session.h
@@ -18,7 +18,7 @@ struct thread;
 struct ordered_samples {
 	u64			last_flush;
 	u64			next_flush;
-	u64			max_timestamp;
+	u64			max_timestamps[MAX_NR_CPUS];
 	struct list_head	samples;
 	struct list_head	sample_cache;
 	struct list_head	to_free;

--------------060000010808030402030804--
