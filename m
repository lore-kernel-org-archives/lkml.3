Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752898Ab3LKMnJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Dec 2013 07:43:09 -0500
Received: from mga09.intel.com ([134.134.136.24]:40610 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752339Ab3LKMm6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Dec 2013 07:42:58 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,871,1378882800"; 
   d="scan'208";a="450499081"
From: Alexander Shishkin <alexander.shishkin@linux.intel.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Ingo Molnar <mingo@redhat.com>, linux-kernel@vger.kernel.org,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Mike Galbraith <efault@gmx.de>, Namhyung Kim <namhyung@gmail.com>,
        Paul Mackerras <paulus@samba.org>,
        Stephane Eranian <eranian@google.com>, Andi Kleen <ak@linux.intel.com>,
        Adrian Hunter <adrian.hunter@intel.com>
Subject: [PATCH v0 62/71] perf inject: Cut Instruction Tracing samples
Date: Wed, 11 Dec 2013 14:37:14 +0200
Message-Id: <1386765443-26966-63-git-send-email-alexander.shishkin@linux.intel.com>
X-Mailer: git-send-email 1.8.4.rc2
In-Reply-To: <1386765443-26966-1-git-send-email-alexander.shishkin@linux.intel.com>
References: <1386765443-26966-1-git-send-email-alexander.shishkin@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Adrian Hunter <adrian.hunter@intel.com>

After decoding Instruction Tracing samples, the
Instruction Tracing data is no longer needed
(having been replaced by synthesized events)
so cut it out.

Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
---
 tools/perf/builtin-inject.c | 29 +++++++++++++++++++++++++++++
 1 file changed, 29 insertions(+)

diff --git a/tools/perf/builtin-inject.c b/tools/perf/builtin-inject.c
index feeeb56..ed2b48f 100644
--- a/tools/perf/builtin-inject.c
+++ b/tools/perf/builtin-inject.c
@@ -32,6 +32,7 @@ struct perf_inject {
 	u64		 bytes_written;
 	struct list_head samples;
 	struct itrace_synth_opts itrace_synth_opts;
+	char		 event_copy[PERF_SAMPLE_MAX_SIZE];
 };
 
 struct event_entry {
@@ -143,6 +144,28 @@ static int perf_event__repipe(struct perf_tool *tool,
 	return perf_event__repipe_synth(tool, event);
 }
 
+static union perf_event *
+perf_inject__cut_itrace_sample(struct perf_inject *inject,
+			       union perf_event *event,
+			       struct perf_sample *sample)
+{
+	size_t sz1 = sample->itrace_sample.data - (void *)event;
+	size_t sz2 = event->header.size - sample->itrace_sample.size - sz1;
+	union perf_event *ev = (union perf_event *)inject->event_copy;
+
+	if (sz1 > event->header.size || sz2 > event->header.size ||
+	    sz1 + sz2 > event->header.size ||
+	    sz1 < sizeof(struct perf_event_header) + sizeof(u64))
+		return event;
+
+	memcpy(ev, event, sz1);
+	memcpy((void *)ev + sz1, (void *)event + event->header.size - sz2, sz2);
+	ev->header.size = sz1 + sz2;
+	((u64 *)((void *)ev + sz1))[-1] = 0;
+
+	return ev;
+}
+
 typedef int (*inject_handler)(struct perf_tool *tool,
 			      union perf_event *event,
 			      struct perf_sample *sample,
@@ -155,6 +178,9 @@ static int perf_event__repipe_sample(struct perf_tool *tool,
 				     struct perf_evsel *evsel,
 				     struct machine *machine)
 {
+	struct perf_inject *inject = container_of(tool, struct perf_inject,
+						  tool);
+
 	if (evsel->handler) {
 		inject_handler f = evsel->handler;
 		return f(tool, event, sample, evsel, machine);
@@ -162,6 +188,9 @@ static int perf_event__repipe_sample(struct perf_tool *tool,
 
 	build_id__mark_dso_hit(tool, event, sample, evsel, machine);
 
+	if (inject->itrace_synth_opts.set && sample->itrace_sample.size)
+		event = perf_inject__cut_itrace_sample(inject, event, sample);
+
 	return perf_event__repipe_synth(tool, event);
 }
 
-- 
1.8.5.1

