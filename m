Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932273Ab3GKNIU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Jul 2013 09:08:20 -0400
Received: from mga11.intel.com ([192.55.52.93]:28287 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932094Ab3GKNIM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Jul 2013 09:08:12 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,1043,1363158000"; 
   d="scan'208";a="368613084"
From: Adrian Hunter <adrian.hunter@intel.com>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: linux-kernel@vger.kernel.org, David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Mike Galbraith <efault@gmx.de>, Namhyung Kim <namhyung@gmail.com>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>, Ingo Molnar <mingo@kernel.org>,
        Adrian Hunter <adrian.hunter@intel.com>
Subject: [PATCH V5 10/12] perf tools: add support for PERF_SAMPLE_IDENTFIER
Date: Thu, 11 Jul 2013 16:12:19 +0300
Message-Id: <1373548341-24119-11-git-send-email-adrian.hunter@intel.com>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1373548341-24119-1-git-send-email-adrian.hunter@intel.com>
References: <1373548341-24119-1-git-send-email-adrian.hunter@intel.com>
Organization: Intel Finland Oy, Registered Address: PL 281, 00181 Helsinki, Business Identity Code: 0357606 - 4, Domiciled in Helsinki
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Enable parsing of samples with sample format bit
PERF_SAMPLE_IDENTFIER.  In addition, if the kernel supports
it, prefer it to selecting PERF_SAMPLE_ID thereby avoiding
the need to force compatible sample types.

Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
---
 tools/perf/tests/mmap-basic.c |  2 +-
 tools/perf/util/event.h       |  9 +++--
 tools/perf/util/evlist.c      | 94 +++++++++++++++++++++++++++++++++++++++++--
 tools/perf/util/evlist.h      |  1 +
 tools/perf/util/evsel.c       | 41 +++++++++++++++----
 tools/perf/util/evsel.h       |  3 +-
 6 files changed, 134 insertions(+), 16 deletions(-)

diff --git a/tools/perf/tests/mmap-basic.c b/tools/perf/tests/mmap-basic.c
index 5b1b5ab..c4185b9 100644
--- a/tools/perf/tests/mmap-basic.c
+++ b/tools/perf/tests/mmap-basic.c
@@ -72,7 +72,7 @@ int test__basic_mmap(void)
 		}
 
 		evsels[i]->attr.wakeup_events = 1;
-		perf_evsel__set_sample_id(evsels[i]);
+		perf_evsel__set_sample_id(evsels[i], false);
 
 		perf_evlist__add(evlist, evsels[i]);
 
diff --git a/tools/perf/util/event.h b/tools/perf/util/event.h
index a7b2245..ce2a92c 100644
--- a/tools/perf/util/event.h
+++ b/tools/perf/util/event.h
@@ -53,7 +53,8 @@ struct read_event {
 	(PERF_SAMPLE_IP | PERF_SAMPLE_TID |		\
 	 PERF_SAMPLE_TIME | PERF_SAMPLE_ADDR |		\
 	PERF_SAMPLE_ID | PERF_SAMPLE_STREAM_ID |	\
-	 PERF_SAMPLE_CPU | PERF_SAMPLE_PERIOD)
+	 PERF_SAMPLE_CPU | PERF_SAMPLE_PERIOD |		\
+	 PERF_SAMPLE_IDENTIFIER)
 
 /*
  * Events have compatible sample types if the following bits all have the same
@@ -61,13 +62,15 @@ struct read_event {
  * events the order is: PERF_SAMPLE_IP, PERF_SAMPLE_TID, PERF_SAMPLE_TIME,
  * PERF_SAMPLE_ADDR, PERF_SAMPLE_ID.  For non-sample events the sample members
  * are accessed in reverse order.  The order is: PERF_SAMPLE_ID,
- * PERF_SAMPLE_STREAM_ID, PERF_SAMPLE_CPU.
+ * PERF_SAMPLE_STREAM_ID, PERF_SAMPLE_CPU.  PERF_SAMPLE_IDENTIFIER is added for
+ * completeness but it should not be used with PERF_SAMPLE_ID.  Sample types
+ * that include PERF_SAMPLE_IDENTIFIER are always compatible.
  */
 #define PERF_COMPAT_MASK				\
 	(PERF_SAMPLE_IP   | PERF_SAMPLE_TID       |	\
 	 PERF_SAMPLE_TIME | PERF_SAMPLE_ADDR      |	\
 	 PERF_SAMPLE_ID   | PERF_SAMPLE_STREAM_ID |	\
-	 PERF_SAMPLE_CPU)
+	 PERF_SAMPLE_CPU  | PERF_SAMPLE_IDENTIFIER)
 
 struct sample_event {
 	struct perf_event_header        header;
diff --git a/tools/perf/util/evlist.c b/tools/perf/util/evlist.c
index ffa4afb..42735db 100644
--- a/tools/perf/util/evlist.c
+++ b/tools/perf/util/evlist.c
@@ -88,10 +88,81 @@ void perf_evlist__make_sample_types_compatible(struct perf_evlist *evlist)
 	perf_evlist__set_id_pos(evlist);
 }
 
+typedef void (*setup_probe_fn_t)(struct perf_evsel *evsel);
+
+static int perf_do_probe_api(setup_probe_fn_t fn, int cpu, const char *str)
+{
+	struct perf_evlist *evlist;
+	struct perf_evsel *evsel;
+	int err = -EAGAIN, fd;
+
+	evlist = perf_evlist__new();
+	if (!evlist)
+		return -ENOMEM;
+
+	if (parse_events(evlist, str))
+		goto out_delete;
+
+	evsel = perf_evlist__first(evlist);
+
+	fd = sys_perf_event_open(&evsel->attr, -1, cpu, -1, 0);
+	if (fd < 0)
+		goto out_delete;
+	close(fd);
+
+	fn(evsel);
+
+	fd = sys_perf_event_open(&evsel->attr, -1, cpu, -1, 0);
+	if (fd < 0) {
+		if (errno == EINVAL)
+			err = -EINVAL;
+		goto out_delete;
+	}
+	close(fd);
+	err = 0;
+
+out_delete:
+	perf_evlist__delete(evlist);
+	return err;
+}
+
+static bool perf_probe_api(setup_probe_fn_t fn)
+{
+	const char *try[] = {"cycles:u", "instructions:u", "cpu-clock", NULL};
+	struct cpu_map *cpus;
+	int cpu, ret, i = 0;
+
+	cpus = cpu_map__new(NULL);
+	if (!cpus)
+		return false;
+	cpu = cpus->map[0];
+	cpu_map__delete(cpus);
+
+	do {
+		ret = perf_do_probe_api(fn, cpu, try[i++]);
+		if (!ret)
+			return true;
+	} while (ret == -EAGAIN && try[i]);
+
+	return false;
+}
+
+static void perf_probe_sample_identifier(struct perf_evsel *evsel)
+{
+	evsel->attr.sample_type |= PERF_SAMPLE_IDENTIFIER;
+}
+
+bool perf_can_sample_identifier(void)
+{
+	return perf_probe_api(perf_probe_sample_identifier);
+}
+
 void perf_evlist__config(struct perf_evlist *evlist,
 			struct perf_record_opts *opts)
 {
 	struct perf_evsel *evsel;
+	bool use_sample_identifier = false;
+
 	/*
 	 * Set the evsel leader links before we configure attributes,
 	 * since some might depend on this info.
@@ -102,14 +173,26 @@ void perf_evlist__config(struct perf_evlist *evlist,
 	if (evlist->cpus->map[0] < 0)
 		opts->no_inherit = true;
 
-	list_for_each_entry(evsel, &evlist->entries, node) {
+	list_for_each_entry(evsel, &evlist->entries, node)
 		perf_evsel__config(evsel, opts);
 
-		if (evlist->nr_entries > 1)
-			perf_evsel__set_sample_id(evsel);
+	if (evlist->nr_entries > 1) {
+		struct perf_evsel *first = perf_evlist__first(evlist);
+
+		list_for_each_entry(evsel, &evlist->entries, node) {
+			if (evsel->attr.sample_type == first->attr.sample_type)
+				continue;
+			use_sample_identifier = perf_can_sample_identifier();
+			break;
+		}
+		list_for_each_entry(evsel, &evlist->entries, node)
+			perf_evsel__set_sample_id(evsel, use_sample_identifier);
 	}
 
-	perf_evlist__make_sample_types_compatible(evlist);
+	if (use_sample_identifier)
+		perf_evlist__set_id_pos(evlist);
+	else
+		perf_evlist__make_sample_types_compatible(evlist);
 }
 
 static void perf_evlist__purge(struct perf_evlist *evlist)
@@ -813,6 +896,9 @@ u16 perf_evlist__id_hdr_size(struct perf_evlist *evlist)
 
 	if (sample_type & PERF_SAMPLE_CPU)
 		size += sizeof(data->cpu) * 2;
+
+	if (sample_type & PERF_SAMPLE_IDENTIFIER)
+		size += sizeof(data->id);
 out:
 	return size;
 }
diff --git a/tools/perf/util/evlist.h b/tools/perf/util/evlist.h
index b1be475..9b767e6 100644
--- a/tools/perf/util/evlist.h
+++ b/tools/perf/util/evlist.h
@@ -88,6 +88,7 @@ int perf_evlist__open(struct perf_evlist *evlist);
 void perf_evlist__close(struct perf_evlist *evlist);
 
 void perf_evlist__make_sample_types_compatible(struct perf_evlist *evlist);
+bool perf_can_sample_identifier(void);
 void perf_evlist__config(struct perf_evlist *evlist,
 			 struct perf_record_opts *opts);
 
diff --git a/tools/perf/util/evsel.c b/tools/perf/util/evsel.c
index dfdd6cb..4940f65 100644
--- a/tools/perf/util/evsel.c
+++ b/tools/perf/util/evsel.c
@@ -50,13 +50,17 @@ int __perf_evsel__sample_size(u64 sample_type)
  * __perf_evsel__calc_id_pos - calculate id_pos.
  * @sample_type: sample type
  *
- * This function returns the position of the event id (PERF_SAMPLE_ID) in a
- * sample event i.e. in the array of struct sample_event.
+ * This function returns the position of the event id (PERF_SAMPLE_ID or
+ * PERF_SAMPLE_IDENTIFIER) in a sample event i.e. in the array of struct
+ * sample_event.
  */
 static int __perf_evsel__calc_id_pos(u64 sample_type)
 {
 	int idx = 0;
 
+	if (sample_type & PERF_SAMPLE_IDENTIFIER)
+		return 0;
+
 	if (!(sample_type & PERF_SAMPLE_ID))
 		return -1;
 
@@ -80,13 +84,16 @@ static int __perf_evsel__calc_id_pos(u64 sample_type)
  * @sample_type: sample type
  *
  * This function returns the position (counting backwards) of the event id
- * (PERF_SAMPLE_ID) in a non-sample event i.e. if sample_id_all is used there is
- * an id sample appended to non-sample events.
+ * (PERF_SAMPLE_ID or PERF_SAMPLE_IDENTIFIER) in a non-sample event i.e. if
+ * sample_id_all is used there is an id sample appended to non-sample events.
  */
 static int __perf_evsel__calc_is_pos(u64 sample_type)
 {
 	int idx = 1;
 
+	if (sample_type & PERF_SAMPLE_IDENTIFIER)
+		return 1;
+
 	if (!(sample_type & PERF_SAMPLE_ID))
 		return -1;
 
@@ -135,9 +142,13 @@ void __perf_evsel__reset_sample_bit(struct perf_evsel *evsel,
 	}
 }
 
-void perf_evsel__set_sample_id(struct perf_evsel *evsel)
+void perf_evsel__set_sample_id(struct perf_evsel *evsel,
+			       bool can_sample_identifier)
 {
-	perf_evsel__set_sample_bit(evsel, ID);
+	if (can_sample_identifier)
+		perf_evsel__set_sample_bit(evsel, IDENTIFIER);
+	else
+		perf_evsel__set_sample_bit(evsel, ID);
 	evsel->attr.read_format |= PERF_FORMAT_ID;
 }
 
@@ -1071,6 +1082,11 @@ static int perf_evsel__parse_id_sample(const struct perf_evsel *evsel,
 	array += ((event->header.size -
 		   sizeof(event->header)) / sizeof(u64)) - 1;
 
+	if (type & PERF_SAMPLE_IDENTIFIER) {
+		sample->id = *array;
+		array--;
+	}
+
 	if (type & PERF_SAMPLE_CPU) {
 		u.val64 = *array;
 		if (swapped) {
@@ -1175,6 +1191,12 @@ int perf_evsel__parse_sample(struct perf_evsel *evsel, union perf_event *event,
 	if (evsel->sample_size + sizeof(event->header) > event->header.size)
 		return -EFAULT;
 
+	data->id = -1ULL;
+	if (type & PERF_SAMPLE_IDENTIFIER) {
+		data->id = *array;
+		array++;
+	}
+
 	if (type & PERF_SAMPLE_IP) {
 		data->ip = *array;
 		array++;
@@ -1205,7 +1227,6 @@ int perf_evsel__parse_sample(struct perf_evsel *evsel, union perf_event *event,
 		array++;
 	}
 
-	data->id = -1ULL;
 	if (type & PERF_SAMPLE_ID) {
 		data->id = *array;
 		array++;
@@ -1348,6 +1369,11 @@ int perf_event__synthesize_sample(union perf_event *event, u64 type,
 
 	array = event->sample.array;
 
+	if (type & PERF_SAMPLE_IDENTIFIER) {
+		*array = sample->id;
+		array++;
+	}
+
 	if (type & PERF_SAMPLE_IP) {
 		*array = sample->ip;
 		array++;
@@ -1536,6 +1562,7 @@ static int sample_type__fprintf(FILE *fp, bool *first, u64 value)
 		bit_name(READ), bit_name(CALLCHAIN), bit_name(ID), bit_name(CPU),
 		bit_name(PERIOD), bit_name(STREAM_ID), bit_name(RAW),
 		bit_name(BRANCH_STACK), bit_name(REGS_USER), bit_name(STACK_USER),
+		bit_name(IDENTIFIER),
 		{ .name = NULL, }
 	};
 #undef bit_name
diff --git a/tools/perf/util/evsel.h b/tools/perf/util/evsel.h
index c6d616c..bca8e5f 100644
--- a/tools/perf/util/evsel.h
+++ b/tools/perf/util/evsel.h
@@ -148,7 +148,8 @@ void __perf_evsel__reset_sample_bit(struct perf_evsel *evsel,
 #define perf_evsel__reset_sample_bit(evsel, bit) \
 	__perf_evsel__reset_sample_bit(evsel, PERF_SAMPLE_##bit)
 
-void perf_evsel__set_sample_id(struct perf_evsel *evsel);
+void perf_evsel__set_sample_id(struct perf_evsel *evsel,
+			       bool use_sample_identifier);
 
 int perf_evsel__set_filter(struct perf_evsel *evsel, int ncpus, int nthreads,
 			   const char *filter);
-- 
1.7.11.7

