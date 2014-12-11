Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964997AbaLKPOR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Dec 2014 10:14:17 -0500
Received: from mx1.redhat.com ([209.132.183.28]:42995 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964877AbaLKPNn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Dec 2014 10:13:43 -0500
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
Subject: [PATCH 6/8] perf data: Switch to multiple cpu stream files
Date: Thu, 11 Dec 2014 16:12:27 +0100
Message-Id: <1418310749-22267-7-git-send-email-jolsa@kernel.org>
In-Reply-To: <1418310749-22267-1-git-send-email-jolsa@kernel.org>
References: <1418310749-22267-1-git-send-email-jolsa@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>

Currently we store the data into single data strea/file. The cpu
if data is stored within the event sample. The lttng puts the CPU
number that belongs to the event into the packet context instead
into the event.

This patch makes sure that the trace produce by perf does look the
same way. We now use one stream per-CPU. Having it all in one stream
increased the total size of the resulting file. The test went from
416KiB (with perf_cpu event member) to 24MiB due to the required
(and pointless) flush. With the per-cpu streams the total size went
up to 588KiB.

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
 tools/perf/util/data-convert-bt.c | 205 +++++++++++++++++++++++++++++++++-----
 1 file changed, 181 insertions(+), 24 deletions(-)

diff --git a/tools/perf/util/data-convert-bt.c b/tools/perf/util/data-convert-bt.c
index 6fa5c3ef336b..4bb769e081a8 100644
--- a/tools/perf/util/data-convert-bt.c
+++ b/tools/perf/util/data-convert-bt.c
@@ -38,12 +38,20 @@ struct evsel_priv {
 	struct bt_ctf_event_class *event_class;
 };
 
+#define MAX_CPUS	4096
+
+struct ctf_stream {
+	struct bt_ctf_stream *stream;
+	int cpu;
+};
+
 struct ctf_writer {
 	/* writer primitives */
-	struct bt_ctf_writer		*writer;
-	struct bt_ctf_stream		*stream;
-	struct bt_ctf_stream_class	*stream_class;
-	struct bt_ctf_clock		*clock;
+	struct bt_ctf_writer		 *writer;
+	struct ctf_stream		**stream;
+	int				  stream_cnt;
+	struct bt_ctf_stream_class	 *stream_class;
+	struct bt_ctf_clock		 *clock;
 
 	/* data types */
 	union {
@@ -346,12 +354,6 @@ static int add_generic_values(struct ctf_writer *cw,
 			return -1;
 	}
 
-	if (type & PERF_SAMPLE_CPU) {
-		ret = value_set_u32(cw, event, "perf_cpu", sample->cpu);
-		if (ret)
-			return -1;
-	}
-
 	if (type & PERF_SAMPLE_PERIOD) {
 		ret = value_set_u64(cw, event, "perf_period", sample->period);
 		if (ret)
@@ -381,6 +383,113 @@ static int add_generic_values(struct ctf_writer *cw,
 	return 0;
 }
 
+static int ctf_stream__flush(struct ctf_stream *cs)
+{
+	int err = 0;
+
+	if (cs) {
+		err = bt_ctf_stream_flush(cs->stream);
+		if (err)
+			pr_err("CTF stream %d flush failed\n", cs->cpu);
+
+		pr("Flush stream for cpu %d\n", cs->cpu);
+	}
+
+	return err;
+}
+
+static struct ctf_stream *ctf_stream__create(struct ctf_writer *cw, int cpu)
+{
+	struct ctf_stream *cs;
+	struct bt_ctf_field *pkt_ctx   = NULL;
+	struct bt_ctf_field *cpu_field = NULL;
+	struct bt_ctf_stream *stream   = NULL;
+	int ret;
+
+	cs = zalloc(sizeof(*cs));
+	if (!cs) {
+		pr_err("Failed to allocate ctf stream\n");
+		return NULL;
+	}
+
+	stream = bt_ctf_writer_create_stream(cw->writer, cw->stream_class);
+	if (!stream) {
+		pr_err("Failed to create CTF stream\n");
+		goto out;
+	}
+
+	pkt_ctx = bt_ctf_stream_get_packet_context(stream);
+	if (!pkt_ctx) {
+		pr_err("Failed to obtain packet context\n");
+		goto out;
+	}
+
+	cpu_field = bt_ctf_field_structure_get_field(pkt_ctx, "cpu_id");
+	bt_ctf_field_put(pkt_ctx);
+	if (!cpu_field) {
+		pr_err("Failed to obtain cpu field\n");
+		goto out;
+	}
+
+	ret = bt_ctf_field_unsigned_integer_set_value(cpu_field, (u32) cpu);
+	if (ret) {
+		pr_err("Failed to update CPU number\n");
+		goto out;
+	}
+
+	bt_ctf_field_put(cpu_field);
+
+	cs->cpu    = cpu;
+	cs->stream = stream;
+	return cs;
+
+out:
+	if (cpu_field)
+		bt_ctf_field_put(cpu_field);
+	if (stream)
+		bt_ctf_stream_put(stream);
+
+	free(cs);
+	return NULL;
+}
+
+static void ctf_stream__delete(struct ctf_stream *cs)
+{
+	if (cs) {
+		bt_ctf_stream_put(cs->stream);
+		free(cs);
+	}
+}
+
+static struct ctf_stream *ctf_stream(struct ctf_writer *cw, int cpu)
+{
+	struct ctf_stream *cs = cw->stream[cpu];
+
+	if (!cs) {
+		cs = ctf_stream__create(cw, cpu);
+		cw->stream[cpu] = cs;
+	}
+
+	return cs;
+}
+
+static int get_sample_cpu(struct ctf_writer *cw, struct perf_sample *sample,
+			  struct perf_evsel *evsel)
+{
+	int cpu = 0;
+
+	if (evsel->attr.sample_type & PERF_SAMPLE_CPU)
+		cpu = sample->cpu;
+
+	if (cpu > cw->stream_cnt) {
+		pr_err("Event was recorded for CPU %d, limit is at %d.\n",
+			cpu, cw->stream_cnt);
+		cpu = 0;
+	}
+
+	return cpu;
+}
+
 static int process_sample_event(struct perf_tool *tool,
 				union perf_event *_event __maybe_unused,
 				struct perf_sample *sample,
@@ -390,6 +499,7 @@ static int process_sample_event(struct perf_tool *tool,
 	struct convert *c = container_of(tool, struct convert, tool);
 	struct evsel_priv *priv = evsel->priv;
 	struct ctf_writer *cw = &c->writer;
+	struct ctf_stream *cs;
 	struct bt_ctf_event_class *event_class;
 	struct bt_ctf_event *event;
 	int ret;
@@ -424,9 +534,12 @@ static int process_sample_event(struct perf_tool *tool,
 			return -1;
 	}
 
-	bt_ctf_stream_append_event(cw->stream, event);
+	cs = ctf_stream(cw, get_sample_cpu(cw, sample, evsel));
+	if (cs)
+		bt_ctf_stream_append_event(cs->stream, event);
+
 	bt_ctf_event_put(event);
-	return 0;
+	return cs ? 0 : -1;
 }
 
 static int add_tracepoint_fields_types(struct ctf_writer *cw,
@@ -528,9 +641,6 @@ static int add_generic_types(struct ctf_writer *cw, struct perf_evsel *evsel,
 	if (type & PERF_SAMPLE_STREAM_ID)
 		ADD_FIELD(event_class, cw->data.u64, "perf_stream_id");
 
-	if (type & PERF_SAMPLE_CPU)
-		ADD_FIELD(event_class, cw->data.u32, "perf_cpu");
-
 	if (type & PERF_SAMPLE_PERIOD)
 		ADD_FIELD(event_class, cw->data.u64, "perf_period");
 
@@ -604,6 +714,39 @@ static int setup_events(struct ctf_writer *cw, struct perf_session *session)
 	return 0;
 }
 
+static int setup_streams(struct ctf_writer *cw, struct perf_session *session)
+{
+	struct ctf_stream **stream;
+	struct perf_header *ph = &session->header;
+	int ncpus;
+
+	/*
+	 * Try to get the number of cpus used in the data file,
+	 * if not present fallback to the MAX_CPUS.
+	 */
+	ncpus = ph->env.nr_cpus_avail ?: MAX_CPUS;
+
+	stream = zalloc(sizeof(*stream) * ncpus);
+	if (!stream) {
+		pr_err("Failed to allocate streams.\n");
+		return -ENOMEM;
+	}
+
+	cw->stream     = stream;
+	cw->stream_cnt = ncpus;
+	return 0;
+}
+
+static void free_streams(struct ctf_writer *cw)
+{
+	int cpu;
+
+	for (cpu = 0; cpu < cw->stream_cnt; cpu++)
+		ctf_stream__delete(cw->stream[cpu]);
+
+	free(cw->stream);
+}
+
 static int ctf_writer__setup_env(struct ctf_writer *cw,
 				 struct perf_session *session)
 {
@@ -713,7 +856,7 @@ static void ctf_writer__cleanup(struct ctf_writer *cw)
 	ctf_writer__cleanup_data(cw);
 
 	bt_ctf_clock_put(cw->clock);
-	bt_ctf_stream_put(cw->stream);
+	free_streams(cw);
 	bt_ctf_stream_class_put(cw->stream_class);
 	bt_ctf_writer_put(cw->writer);
 
@@ -725,8 +868,9 @@ static int ctf_writer__init(struct ctf_writer *cw, const char *path)
 {
 	struct bt_ctf_writer		*writer;
 	struct bt_ctf_stream_class	*stream_class;
-	struct bt_ctf_stream		*stream;
 	struct bt_ctf_clock		*clock;
+	struct bt_ctf_field_type	*pkt_ctx_type;
+	int				ret;
 
 	/* CTF writer */
 	writer = bt_ctf_writer_create(path);
@@ -767,14 +911,15 @@ static int ctf_writer__init(struct ctf_writer *cw, const char *path)
 	if (ctf_writer__init_data(cw))
 		goto err_cleanup;
 
-	/* CTF stream instance */
-	stream = bt_ctf_writer_create_stream(writer, stream_class);
-	if (!stream) {
-		pr("Failed to create CTF stream.\n");
+	/* Add cpu_id for packet context */
+	pkt_ctx_type = bt_ctf_stream_class_get_packet_context_type(stream_class);
+	if (!pkt_ctx_type)
 		goto err_cleanup;
-	}
 
-	cw->stream = stream;
+	ret = bt_ctf_field_type_structure_add_field(pkt_ctx_type, cw->data.u32, "cpu_id");
+	bt_ctf_field_type_put(pkt_ctx_type);
+	if (ret)
+		goto err_cleanup;
 
 	/* CTF clock writer setup */
 	if (bt_ctf_writer_add_clock(writer, clock)) {
@@ -791,6 +936,14 @@ err:
 	return -1;
 }
 
+static void ctf_writer__flush_streams(struct ctf_writer *cw)
+{
+	int cpu;
+
+	for (cpu = 0; cpu < cw->stream_cnt; cpu++)
+		ctf_stream__flush(cw->stream[cpu]);
+}
+
 int bt_convert__perf2ctf(const char *input, const char *path)
 {
 	struct perf_session *session;
@@ -833,9 +986,13 @@ int bt_convert__perf2ctf(const char *input, const char *path)
 	if (setup_events(cw, session))
 		goto free_session;
 
+	if (setup_streams(cw, session))
+		goto free_session;
+
 	err = perf_session__process_events(session, &c.tool);
 	if (!err)
-		err = bt_ctf_stream_flush(cw->stream);
+		ctf_writer__flush_streams(cw);
+
 
 	fprintf(stderr,
 		"[ perf data convert: Converted '%s' into CTF data '%s' ]\n",
-- 
1.9.3

