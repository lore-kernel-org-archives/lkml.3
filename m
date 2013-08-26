Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756979Ab3HZMys (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Aug 2013 08:54:48 -0400
Received: from mga01.intel.com ([192.55.52.88]:14401 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756960Ab3HZMyq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Aug 2013 08:54:46 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.89,958,1367996400"; 
   d="scan'208";a="392111822"
From: Adrian Hunter <adrian.hunter@intel.com>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: linux-kernel@vger.kernel.org, David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Mike Galbraith <efault@gmx.de>, Namhyung Kim <namhyung@gmail.com>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>, Ingo Molnar <mingo@kernel.org>
Subject: [PATCH V12 09/13] perf tools: add support for PERF_SAMPLE_IDENTFIER
Date: Mon, 26 Aug 2013 16:00:26 +0300
Message-Id: <1377522030-27870-10-git-send-email-adrian.hunter@intel.com>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1377522030-27870-1-git-send-email-adrian.hunter@intel.com>
References: <1377522030-27870-1-git-send-email-adrian.hunter@intel.com>
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
 tools/perf/util/evlist.c      |  5 ++-
 tools/perf/util/evlist.h      |  2 +
 tools/perf/util/evsel.c       | 45 +++++++++++++++++----
 tools/perf/util/evsel.h       |  3 +-
 tools/perf/util/record.c      | 94 ++++++++++++++++++++++++++++++++++++++++---
 7 files changed, 141 insertions(+), 19 deletions(-)

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
index de4bfe0..b0921fe 100644
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
index 310eb4f..1fd9a8f 100644
--- a/tools/perf/util/evlist.c
+++ b/tools/perf/util/evlist.c
@@ -56,7 +56,7 @@ struct perf_evlist *perf_evlist__new(void)
  * Events with compatible sample types all have the same id_pos
  * and is_pos.  For convenience, put a copy on evlist.
  */
-static void perf_evlist__set_id_pos(struct perf_evlist *evlist)
+void perf_evlist__set_id_pos(struct perf_evlist *evlist)
 {
 	struct perf_evsel *first = perf_evlist__first(evlist);
 
@@ -842,6 +842,9 @@ u16 perf_evlist__id_hdr_size(struct perf_evlist *evlist)
 
 	if (sample_type & PERF_SAMPLE_CPU)
 		size += sizeof(data->cpu) * 2;
+
+	if (sample_type & PERF_SAMPLE_IDENTIFIER)
+		size += sizeof(data->id);
 out:
 	return size;
 }
diff --git a/tools/perf/util/evlist.h b/tools/perf/util/evlist.h
index b01eef5..4d1d342 100644
--- a/tools/perf/util/evlist.h
+++ b/tools/perf/util/evlist.h
@@ -88,7 +88,9 @@ union perf_event *perf_evlist__mmap_read(struct perf_evlist *self, int idx);
 int perf_evlist__open(struct perf_evlist *evlist);
 void perf_evlist__close(struct perf_evlist *evlist);
 
+void perf_evlist__set_id_pos(struct perf_evlist *evlist);
 void perf_evlist__make_sample_types_compatible(struct perf_evlist *evlist);
+bool perf_can_sample_identifier(void);
 void perf_evlist__config(struct perf_evlist *evlist,
 			 struct perf_record_opts *opts);
 
diff --git a/tools/perf/util/evsel.c b/tools/perf/util/evsel.c
index 4f105e0..db4e431 100644
--- a/tools/perf/util/evsel.c
+++ b/tools/perf/util/evsel.c
@@ -51,13 +51,17 @@ int __perf_evsel__sample_size(u64 sample_type)
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
 
@@ -81,13 +85,16 @@ static int __perf_evsel__calc_id_pos(u64 sample_type)
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
 
@@ -136,9 +143,15 @@ void __perf_evsel__reset_sample_bit(struct perf_evsel *evsel,
 	}
 }
 
-void perf_evsel__set_sample_id(struct perf_evsel *evsel)
+void perf_evsel__set_sample_id(struct perf_evsel *evsel,
+			       bool can_sample_identifier)
 {
-	perf_evsel__set_sample_bit(evsel, ID);
+	if (can_sample_identifier) {
+		perf_evsel__reset_sample_bit(evsel, ID);
+		perf_evsel__set_sample_bit(evsel, IDENTIFIER);
+	} else {
+		perf_evsel__set_sample_bit(evsel, ID);
+	}
 	evsel->attr.read_format |= PERF_FORMAT_ID;
 }
 
@@ -571,7 +584,7 @@ void perf_evsel__config(struct perf_evsel *evsel,
 		 * We need ID even in case of single event, because
 		 * PERF_SAMPLE_READ process ID specific data.
 		 */
-		perf_evsel__set_sample_id(evsel);
+		perf_evsel__set_sample_id(evsel, false);
 
 		/*
 		 * Apply group format only if we belong to group
@@ -1150,6 +1163,11 @@ static int perf_evsel__parse_id_sample(const struct perf_evsel *evsel,
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
@@ -1246,6 +1264,12 @@ int perf_evsel__parse_sample(struct perf_evsel *evsel, union perf_event *event,
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
@@ -1276,7 +1300,6 @@ int perf_evsel__parse_sample(struct perf_evsel *evsel, union perf_event *event,
 		array++;
 	}
 
-	data->id = -1ULL;
 	if (type & PERF_SAMPLE_ID) {
 		data->id = *array;
 		array++;
@@ -1458,6 +1481,11 @@ int perf_event__synthesize_sample(union perf_event *event, u64 type,
 
 	array = event->sample.array;
 
+	if (type & PERF_SAMPLE_IDENTIFIER) {
+		*array = sample->id;
+		array++;
+	}
+
 	if (type & PERF_SAMPLE_IP) {
 		*array = sample->ip;
 		array++;
@@ -1646,6 +1674,7 @@ static int sample_type__fprintf(FILE *fp, bool *first, u64 value)
 		bit_name(READ), bit_name(CALLCHAIN), bit_name(ID), bit_name(CPU),
 		bit_name(PERIOD), bit_name(STREAM_ID), bit_name(RAW),
 		bit_name(BRANCH_STACK), bit_name(REGS_USER), bit_name(STACK_USER),
+		bit_name(IDENTIFIER),
 		{ .name = NULL, }
 	};
 #undef bit_name
diff --git a/tools/perf/util/evsel.h b/tools/perf/util/evsel.h
index 3056f4f..97e7a35 100644
--- a/tools/perf/util/evsel.h
+++ b/tools/perf/util/evsel.h
@@ -152,7 +152,8 @@ void __perf_evsel__reset_sample_bit(struct perf_evsel *evsel,
 #define perf_evsel__reset_sample_bit(evsel, bit) \
 	__perf_evsel__reset_sample_bit(evsel, PERF_SAMPLE_##bit)
 
-void perf_evsel__set_sample_id(struct perf_evsel *evsel);
+void perf_evsel__set_sample_id(struct perf_evsel *evsel,
+			       bool use_sample_identifier);
 
 int perf_evsel__set_filter(struct perf_evsel *evsel, int ncpus, int nthreads,
 			   const char *filter);
diff --git a/tools/perf/util/record.c b/tools/perf/util/record.c
index 67291e4..6e01bf2 100644
--- a/tools/perf/util/record.c
+++ b/tools/perf/util/record.c
@@ -1,11 +1,83 @@
 #include "evlist.h"
 #include "evsel.h"
 #include "cpumap.h"
+#include "parse-events.h"
+
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
 
 void perf_evlist__config(struct perf_evlist *evlist,
-			 struct perf_record_opts *opts)
+			struct perf_record_opts *opts)
 {
 	struct perf_evsel *evsel;
+	bool use_sample_identifier = false;
+
 	/*
 	 * Set the evsel leader links before we configure attributes,
 	 * since some might depend on this info.
@@ -16,12 +88,24 @@ void perf_evlist__config(struct perf_evlist *evlist,
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
-- 
1.7.11.7

