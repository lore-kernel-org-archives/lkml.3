Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753647AbaLCQ0z (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2014 11:26:55 -0500
Received: from mx1.redhat.com ([209.132.183.28]:56160 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751313AbaLCQYw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2014 11:24:52 -0500
From: Jiri Olsa <jolsa@kernel.org>
To: linux-kernel@vger.kernel.org
Cc: Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Jeremie Galarneau <jgalar@efficios.com>, Jiri Olsa <jolsa@kernel.org>,
        Namhyung Kim <namhyung@gmail.com>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Tom Zanussi <tzanussi@gmail.com>
Subject: [PATCH 4/8] perf data: Add a 'perf' prefix to the generic fields
Date: Wed,  3 Dec 2014 17:23:58 +0100
Message-Id: <1417623842-14331-5-git-send-email-jolsa@kernel.org>
In-Reply-To: <1417623842-14331-1-git-send-email-jolsa@kernel.org>
References: <1417623842-14331-1-git-send-email-jolsa@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>

Some of the tracers bring their own id or pid fields and we can end up
having two of them. This patch adds a "perf_" prefix to the 'generic'
fields so we avoid a clash of the member names.

The change is visible in the babeltrace output:

Before:
  $ babeltrace ./ctf-data/
  [03:19:13.962131936] (+0.000001935) cycles: { }, { ip = 0xFFFFFFFF8105443A, tid = 20714, pid = 20714, period = 8 }
  [03:19:13.962133732] (+0.000001796) cycles: { }, { ip = 0xFFFFFFFF8105443A, tid = 20714, pid = 20714, period = 114 }
  ...

Now:
  $ babeltrace ./ctf-data/
  [03:19:13.962131936] (+0.000001935) cycles: { }, { perf_ip = 0xFFFFFFFF8105443A, perf_tid = 20714, perf_pid = 20714, perf_period = 8 }
  [03:19:13.962133732] (+0.000001796) cycles: { }, { perf_ip = 0xFFFFFFFF8105443A, perf_tid = 20714, perf_pid = 20714, perf_period = 114 }
  ...

Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Jeremie Galarneau <jgalar@efficios.com>
Cc: Jiri Olsa <jolsa@kernel.org>
Cc: Namhyung Kim <namhyung@gmail.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: Tom Zanussi <tzanussi@gmail.com>
Signed-off-by: Jiri Olsa <jolsa@kernel.org>
Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
---
 tools/perf/util/data-convert-bt.c | 42 ++++++++++++++++++++-------------------
 1 file changed, 22 insertions(+), 20 deletions(-)

diff --git a/tools/perf/util/data-convert-bt.c b/tools/perf/util/data-convert-bt.c
index 33a0774f03e4..3c39fae9c07e 100644
--- a/tools/perf/util/data-convert-bt.c
+++ b/tools/perf/util/data-convert-bt.c
@@ -147,60 +147,62 @@ static int add_generic_values(struct ctf_writer *cw,
 	 */
 
 	if (type & PERF_SAMPLE_IP) {
-		ret = value_set_u64_hex(cw, event, "ip", sample->ip);
+		ret = value_set_u64_hex(cw, event, "perf_ip", sample->ip);
 		if (ret)
 			return -1;
 	}
 
 	if (type & PERF_SAMPLE_TID) {
-		ret = value_set_s32(cw, event, "tid", sample->tid);
+		ret = value_set_s32(cw, event, "perf_tid", sample->tid);
 		if (ret)
 			return -1;
 
-		ret = value_set_s32(cw, event, "pid", sample->tid);
+		ret = value_set_s32(cw, event, "perf_pid", sample->tid);
 		if (ret)
 			return -1;
 	}
 
 	if ((type & PERF_SAMPLE_ID) ||
 	    (type & PERF_SAMPLE_IDENTIFIER)) {
-		ret = value_set_u64(cw, event, "id", sample->id);
+		ret = value_set_u64(cw, event, "perf_id", sample->id);
 		if (ret)
 			return -1;
 	}
 
 	if (type & PERF_SAMPLE_STREAM_ID) {
-		ret = value_set_u64(cw, event, "stream_id", sample->id);
+		ret = value_set_u64(cw, event, "perf_stream_id", sample->id);
 		if (ret)
 			return -1;
 	}
 
 	if (type & PERF_SAMPLE_CPU) {
-		ret = value_set_u32(cw, event, "cpu", sample->cpu);
+		ret = value_set_u32(cw, event, "perf_cpu", sample->cpu);
 		if (ret)
 			return -1;
 	}
 
 	if (type & PERF_SAMPLE_PERIOD) {
-		ret = value_set_u64(cw, event, "period", sample->period);
+		ret = value_set_u64(cw, event, "perf_period", sample->period);
 		if (ret)
 			return -1;
 	}
 
 	if (type & PERF_SAMPLE_WEIGHT) {
-		ret = value_set_u64(cw, event, "weight", sample->weight);
+		ret = value_set_u64(cw, event, "perf_weight", sample->weight);
 		if (ret)
 			return -1;
 	}
 
 	if (type & PERF_SAMPLE_DATA_SRC) {
-		ret = value_set_u64(cw, event, "data_src", sample->data_src);
+		ret = value_set_u64(cw, event, "perf_data_src",
+				sample->data_src);
 		if (ret)
 			return -1;
 	}
 
 	if (type & PERF_SAMPLE_TRANSACTION) {
-		ret = value_set_u64(cw, event, "transaction", sample->transaction);
+		ret = value_set_u64(cw, event, "perf_transaction",
+				sample->transaction);
 		if (ret)
 			return -1;
 	}
@@ -276,34 +278,34 @@ static int add_generic_types(struct ctf_writer *cw, struct perf_evsel *evsel,
 	} while (0)
 
 	if (type & PERF_SAMPLE_IP)
-		ADD_FIELD(event_class, cw->data.u64_hex, "ip");
+		ADD_FIELD(event_class, cw->data.u64_hex, "perf_ip");
 
 	if (type & PERF_SAMPLE_TID) {
-		ADD_FIELD(event_class, cw->data.s32, "tid");
-		ADD_FIELD(event_class, cw->data.s32, "pid");
+		ADD_FIELD(event_class, cw->data.s32, "perf_tid");
+		ADD_FIELD(event_class, cw->data.s32, "perf_pid");
 	}
 
 	if ((type & PERF_SAMPLE_ID) ||
 	    (type & PERF_SAMPLE_IDENTIFIER))
-		ADD_FIELD(event_class, cw->data.u64, "id");
+		ADD_FIELD(event_class, cw->data.u64, "perf_id");
 
 	if (type & PERF_SAMPLE_STREAM_ID)
-		ADD_FIELD(event_class, cw->data.u64, "stream_id");
+		ADD_FIELD(event_class, cw->data.u64, "perf_stream_id");
 
 	if (type & PERF_SAMPLE_CPU)
-		ADD_FIELD(event_class, cw->data.u32, "cpu");
+		ADD_FIELD(event_class, cw->data.u32, "perf_cpu");
 
 	if (type & PERF_SAMPLE_PERIOD)
-		ADD_FIELD(event_class, cw->data.u64, "period");
+		ADD_FIELD(event_class, cw->data.u64, "perf_period");
 
 	if (type & PERF_SAMPLE_WEIGHT)
-		ADD_FIELD(event_class, cw->data.u64, "weight");
+		ADD_FIELD(event_class, cw->data.u64, "perf_weight");
 
 	if (type & PERF_SAMPLE_DATA_SRC)
-		ADD_FIELD(event_class, cw->data.u64, "data_src");
+		ADD_FIELD(event_class, cw->data.u64, "perf_data_src");
 
 	if (type & PERF_SAMPLE_TRANSACTION)
-		ADD_FIELD(event_class, cw->data.u64, "transaction");
+		ADD_FIELD(event_class, cw->data.u64, "perf_transaction");
 
 #undef ADD_FIELD
 	return 0;
-- 
1.9.3

