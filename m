Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753395Ab3H0IRv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Aug 2013 04:17:51 -0400
Received: from mga03.intel.com ([143.182.124.21]:48948 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753099Ab3H0IRr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Aug 2013 04:17:47 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.89,966,1367996400"; 
   d="scan'208";a="352105033"
From: Adrian Hunter <adrian.hunter@intel.com>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: linux-kernel@vger.kernel.org, David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Mike Galbraith <efault@gmx.de>, Namhyung Kim <namhyung@gmail.com>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>, Ingo Molnar <mingo@kernel.org>
Subject: [PATCH V13 07/12] perf tools: add support for PERF_SAMPLE_IDENTFIER
Date: Tue, 27 Aug 2013 11:23:09 +0300
Message-Id: <1377591794-30553-8-git-send-email-adrian.hunter@intel.com>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1377591794-30553-1-git-send-email-adrian.hunter@intel.com>
References: <1377591794-30553-1-git-send-email-adrian.hunter@intel.com>
Organization: Intel Finland Oy, Registered Address: PL 281, 00181 Helsinki, Business Identity Code: 0357606 - 4, Domiciled in Helsinki
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Enable parsing of samples with sample format bit
PERF_SAMPLE_IDENTFIER.  In addition, if the kernel supports
it, prefer it to selecting PERF_SAMPLE_ID thereby allowing
non-matching sample types.

Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
---
 tools/perf/builtin-report.c   |   2 +-
 tools/perf/tests/mmap-basic.c |   2 +-
 tools/perf/util/event.h       |   3 +-
 tools/perf/util/evlist.c      | 111 +++++++++++++++++++++++++++++++++++++++---
 tools/perf/util/evlist.h      |   8 ++-
 tools/perf/util/evsel.c       | 101 ++++++++++++++++++++++++++++++++++++--
 tools/perf/util/evsel.h       |  14 +++++-
 tools/perf/util/record.c      |  89 +++++++++++++++++++++++++++++++--
 tools/perf/util/session.c     |   2 +-
 9 files changed, 310 insertions(+), 22 deletions(-)

diff --git a/tools/perf/builtin-report.c b/tools/perf/builtin-report.c
index 958a56a..9725aa3 100644
--- a/tools/perf/builtin-report.c
+++ b/tools/perf/builtin-report.c
@@ -365,7 +365,7 @@ static int process_read_event(struct perf_tool *tool,
 static int perf_report__setup_sample_type(struct perf_report *rep)
 {
 	struct perf_session *self = rep->session;
-	u64 sample_type = perf_evlist__sample_type(self->evlist);
+	u64 sample_type = perf_evlist__combined_sample_type(self->evlist);
 
 	if (!self->fd_pipe && !(sample_type & PERF_SAMPLE_CALLCHAIN)) {
 		if (sort__has_parent) {
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
index 19d911c..4913339 100644
--- a/tools/perf/util/event.h
+++ b/tools/perf/util/event.h
@@ -53,7 +53,8 @@ struct read_event {
 	(PERF_SAMPLE_IP | PERF_SAMPLE_TID |		\
 	 PERF_SAMPLE_TIME | PERF_SAMPLE_ADDR |		\
 	PERF_SAMPLE_ID | PERF_SAMPLE_STREAM_ID |	\
-	 PERF_SAMPLE_CPU | PERF_SAMPLE_PERIOD)
+	 PERF_SAMPLE_CPU | PERF_SAMPLE_PERIOD |		\
+	 PERF_SAMPLE_IDENTIFIER)
 
 struct sample_event {
 	struct perf_event_header        header;
diff --git a/tools/perf/util/evlist.c b/tools/perf/util/evlist.c
index 9d682e5..6a629af 100644
--- a/tools/perf/util/evlist.c
+++ b/tools/perf/util/evlist.c
@@ -49,6 +49,21 @@ struct perf_evlist *perf_evlist__new(void)
 	return evlist;
 }
 
+/**
+ * perf_evlist__set_id_pos - set the positions of event ids.
+ * @evlist: selected event list
+ *
+ * Events with compatible sample types all have the same id_pos
+ * and is_pos.  For convenience, put a copy on evlist.
+ */
+void perf_evlist__set_id_pos(struct perf_evlist *evlist)
+{
+	struct perf_evsel *first = perf_evlist__first(evlist);
+
+	evlist->id_pos = first->id_pos;
+	evlist->is_pos = first->is_pos;
+}
+
 static void perf_evlist__purge(struct perf_evlist *evlist)
 {
 	struct perf_evsel *pos, *n;
@@ -79,15 +94,20 @@ void perf_evlist__delete(struct perf_evlist *evlist)
 void perf_evlist__add(struct perf_evlist *evlist, struct perf_evsel *entry)
 {
 	list_add_tail(&entry->node, &evlist->entries);
-	++evlist->nr_entries;
+	if (!evlist->nr_entries++)
+		perf_evlist__set_id_pos(evlist);
 }
 
 void perf_evlist__splice_list_tail(struct perf_evlist *evlist,
 				   struct list_head *list,
 				   int nr_entries)
 {
+	bool set_id_pos = !evlist->nr_entries;
+
 	list_splice_tail(list, &evlist->entries);
 	evlist->nr_entries += nr_entries;
+	if (set_id_pos)
+		perf_evlist__set_id_pos(evlist);
 }
 
 void __perf_evlist__set_leader(struct list_head *list)
@@ -349,6 +369,55 @@ struct perf_evsel *perf_evlist__id2evsel(struct perf_evlist *evlist, u64 id)
 	return NULL;
 }
 
+static int perf_evlist__event2id(struct perf_evlist *evlist,
+				 union perf_event *event, u64 *id)
+{
+	const u64 *array = event->sample.array;
+	ssize_t n;
+
+	n = (event->header.size - sizeof(event->header)) >> 3;
+
+	if (event->header.type == PERF_RECORD_SAMPLE) {
+		if (evlist->id_pos >= n)
+			return -1;
+		*id = array[evlist->id_pos];
+	} else {
+		if (evlist->is_pos > n)
+			return -1;
+		n -= evlist->is_pos;
+		*id = array[n];
+	}
+	return 0;
+}
+
+static struct perf_evsel *perf_evlist__event2evsel(struct perf_evlist *evlist,
+						   union perf_event *event)
+{
+	struct hlist_head *head;
+	struct perf_sample_id *sid;
+	int hash;
+	u64 id;
+
+	if (evlist->nr_entries == 1)
+		return perf_evlist__first(evlist);
+
+	if (perf_evlist__event2id(evlist, event, &id))
+		return NULL;
+
+	/* Synthesized events have an id of zero */
+	if (!id)
+		return perf_evlist__first(evlist);
+
+	hash = hash_64(id, PERF_EVLIST__HLIST_BITS);
+	head = &evlist->heads[hash];
+
+	hlist_for_each_entry(sid, head, node) {
+		if (sid->id == id)
+			return sid->evsel;
+	}
+	return NULL;
+}
+
 union perf_event *perf_evlist__mmap_read(struct perf_evlist *evlist, int idx)
 {
 	struct perf_mmap *md = &evlist->mmap[idx];
@@ -659,20 +728,40 @@ int perf_evlist__set_filter(struct perf_evlist *evlist, const char *filter)
 
 bool perf_evlist__valid_sample_type(struct perf_evlist *evlist)
 {
-	struct perf_evsel *first = perf_evlist__first(evlist), *pos = first;
+	struct perf_evsel *pos;
 
-	list_for_each_entry_continue(pos, &evlist->entries, node) {
-		if (first->attr.sample_type != pos->attr.sample_type)
+	if (evlist->nr_entries == 1)
+		return true;
+
+	if (evlist->id_pos < 0 || evlist->is_pos < 0)
+		return false;
+
+	list_for_each_entry(pos, &evlist->entries, node) {
+		if (pos->id_pos != evlist->id_pos ||
+		    pos->is_pos != evlist->is_pos)
 			return false;
 	}
 
 	return true;
 }
 
-u64 perf_evlist__sample_type(struct perf_evlist *evlist)
+u64 __perf_evlist__combined_sample_type(struct perf_evlist *evlist)
 {
-	struct perf_evsel *first = perf_evlist__first(evlist);
-	return first->attr.sample_type;
+	struct perf_evsel *evsel;
+
+	if (evlist->combined_sample_type)
+		return evlist->combined_sample_type;
+
+	list_for_each_entry(evsel, &evlist->entries, node)
+		evlist->combined_sample_type |= evsel->attr.sample_type;
+
+	return evlist->combined_sample_type;
+}
+
+u64 perf_evlist__combined_sample_type(struct perf_evlist *evlist)
+{
+	evlist->combined_sample_type = 0;
+	return __perf_evlist__combined_sample_type(evlist);
 }
 
 bool perf_evlist__valid_read_format(struct perf_evlist *evlist)
@@ -727,6 +816,9 @@ u16 perf_evlist__id_hdr_size(struct perf_evlist *evlist)
 
 	if (sample_type & PERF_SAMPLE_CPU)
 		size += sizeof(data->cpu) * 2;
+
+	if (sample_type & PERF_SAMPLE_IDENTIFIER)
+		size += sizeof(data->id);
 out:
 	return size;
 }
@@ -885,7 +977,10 @@ int perf_evlist__start_workload(struct perf_evlist *evlist)
 int perf_evlist__parse_sample(struct perf_evlist *evlist, union perf_event *event,
 			      struct perf_sample *sample)
 {
-	struct perf_evsel *evsel = perf_evlist__first(evlist);
+	struct perf_evsel *evsel = perf_evlist__event2evsel(evlist, event);
+
+	if (!evsel)
+		return -EFAULT;
 	return perf_evsel__parse_sample(evsel, event, sample);
 }
 
diff --git a/tools/perf/util/evlist.h b/tools/perf/util/evlist.h
index 327abab..ab95d72 100644
--- a/tools/perf/util/evlist.h
+++ b/tools/perf/util/evlist.h
@@ -32,6 +32,9 @@ struct perf_evlist {
 	int		 nr_fds;
 	int		 nr_mmaps;
 	int		 mmap_len;
+	int		 id_pos;
+	int		 is_pos;
+	u64		 combined_sample_type;
 	struct {
 		int	cork_fd;
 		pid_t	pid;
@@ -85,6 +88,8 @@ union perf_event *perf_evlist__mmap_read(struct perf_evlist *self, int idx);
 int perf_evlist__open(struct perf_evlist *evlist);
 void perf_evlist__close(struct perf_evlist *evlist);
 
+void perf_evlist__set_id_pos(struct perf_evlist *evlist);
+bool perf_can_sample_identifier(void);
 void perf_evlist__config(struct perf_evlist *evlist,
 			 struct perf_record_opts *opts);
 
@@ -121,7 +126,8 @@ void __perf_evlist__set_leader(struct list_head *list);
 void perf_evlist__set_leader(struct perf_evlist *evlist);
 
 u64 perf_evlist__read_format(struct perf_evlist *evlist);
-u64 perf_evlist__sample_type(struct perf_evlist *evlist);
+u64 __perf_evlist__combined_sample_type(struct perf_evlist *evlist);
+u64 perf_evlist__combined_sample_type(struct perf_evlist *evlist);
 bool perf_evlist__sample_id_all(struct perf_evlist *evlist);
 u16 perf_evlist__id_hdr_size(struct perf_evlist *evlist);
 
diff --git a/tools/perf/util/evsel.c b/tools/perf/util/evsel.c
index 7e328c4..db4e431 100644
--- a/tools/perf/util/evsel.c
+++ b/tools/perf/util/evsel.c
@@ -31,7 +31,7 @@ static struct {
 
 #define FD(e, x, y) (*(int *)xyarray__entry(e->fd, x, y))
 
-static int __perf_evsel__sample_size(u64 sample_type)
+int __perf_evsel__sample_size(u64 sample_type)
 {
 	u64 mask = sample_type & PERF_SAMPLE_MASK;
 	int size = 0;
@@ -47,6 +47,72 @@ static int __perf_evsel__sample_size(u64 sample_type)
 	return size;
 }
 
+/**
+ * __perf_evsel__calc_id_pos - calculate id_pos.
+ * @sample_type: sample type
+ *
+ * This function returns the position of the event id (PERF_SAMPLE_ID or
+ * PERF_SAMPLE_IDENTIFIER) in a sample event i.e. in the array of struct
+ * sample_event.
+ */
+static int __perf_evsel__calc_id_pos(u64 sample_type)
+{
+	int idx = 0;
+
+	if (sample_type & PERF_SAMPLE_IDENTIFIER)
+		return 0;
+
+	if (!(sample_type & PERF_SAMPLE_ID))
+		return -1;
+
+	if (sample_type & PERF_SAMPLE_IP)
+		idx += 1;
+
+	if (sample_type & PERF_SAMPLE_TID)
+		idx += 1;
+
+	if (sample_type & PERF_SAMPLE_TIME)
+		idx += 1;
+
+	if (sample_type & PERF_SAMPLE_ADDR)
+		idx += 1;
+
+	return idx;
+}
+
+/**
+ * __perf_evsel__calc_is_pos - calculate is_pos.
+ * @sample_type: sample type
+ *
+ * This function returns the position (counting backwards) of the event id
+ * (PERF_SAMPLE_ID or PERF_SAMPLE_IDENTIFIER) in a non-sample event i.e. if
+ * sample_id_all is used there is an id sample appended to non-sample events.
+ */
+static int __perf_evsel__calc_is_pos(u64 sample_type)
+{
+	int idx = 1;
+
+	if (sample_type & PERF_SAMPLE_IDENTIFIER)
+		return 1;
+
+	if (!(sample_type & PERF_SAMPLE_ID))
+		return -1;
+
+	if (sample_type & PERF_SAMPLE_CPU)
+		idx += 1;
+
+	if (sample_type & PERF_SAMPLE_STREAM_ID)
+		idx += 1;
+
+	return idx;
+}
+
+void perf_evsel__calc_id_pos(struct perf_evsel *evsel)
+{
+	evsel->id_pos = __perf_evsel__calc_id_pos(evsel->attr.sample_type);
+	evsel->is_pos = __perf_evsel__calc_is_pos(evsel->attr.sample_type);
+}
+
 void hists__init(struct hists *hists)
 {
 	memset(hists, 0, sizeof(*hists));
@@ -63,6 +129,7 @@ void __perf_evsel__set_sample_bit(struct perf_evsel *evsel,
 	if (!(evsel->attr.sample_type & bit)) {
 		evsel->attr.sample_type |= bit;
 		evsel->sample_size += sizeof(u64);
+		perf_evsel__calc_id_pos(evsel);
 	}
 }
 
@@ -72,12 +139,19 @@ void __perf_evsel__reset_sample_bit(struct perf_evsel *evsel,
 	if (evsel->attr.sample_type & bit) {
 		evsel->attr.sample_type &= ~bit;
 		evsel->sample_size -= sizeof(u64);
+		perf_evsel__calc_id_pos(evsel);
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
 
@@ -90,6 +164,7 @@ void perf_evsel__init(struct perf_evsel *evsel,
 	INIT_LIST_HEAD(&evsel->node);
 	hists__init(&evsel->hists);
 	evsel->sample_size = __perf_evsel__sample_size(attr->sample_type);
+	perf_evsel__calc_id_pos(evsel);
 }
 
 struct perf_evsel *perf_evsel__new(struct perf_event_attr *attr, int idx)
@@ -509,7 +584,7 @@ void perf_evsel__config(struct perf_evsel *evsel,
 		 * We need ID even in case of single event, because
 		 * PERF_SAMPLE_READ process ID specific data.
 		 */
-		perf_evsel__set_sample_id(evsel);
+		perf_evsel__set_sample_id(evsel, false);
 
 		/*
 		 * Apply group format only if we belong to group
@@ -1088,6 +1163,11 @@ static int perf_evsel__parse_id_sample(const struct perf_evsel *evsel,
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
@@ -1184,6 +1264,12 @@ int perf_evsel__parse_sample(struct perf_evsel *evsel, union perf_event *event,
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
@@ -1214,7 +1300,6 @@ int perf_evsel__parse_sample(struct perf_evsel *evsel, union perf_event *event,
 		array++;
 	}
 
-	data->id = -1ULL;
 	if (type & PERF_SAMPLE_ID) {
 		data->id = *array;
 		array++;
@@ -1396,6 +1481,11 @@ int perf_event__synthesize_sample(union perf_event *event, u64 type,
 
 	array = event->sample.array;
 
+	if (type & PERF_SAMPLE_IDENTIFIER) {
+		*array = sample->id;
+		array++;
+	}
+
 	if (type & PERF_SAMPLE_IP) {
 		*array = sample->ip;
 		array++;
@@ -1584,6 +1674,7 @@ static int sample_type__fprintf(FILE *fp, bool *first, u64 value)
 		bit_name(READ), bit_name(CALLCHAIN), bit_name(ID), bit_name(CPU),
 		bit_name(PERIOD), bit_name(STREAM_ID), bit_name(RAW),
 		bit_name(BRANCH_STACK), bit_name(REGS_USER), bit_name(STACK_USER),
+		bit_name(IDENTIFIER),
 		{ .name = NULL, }
 	};
 #undef bit_name
diff --git a/tools/perf/util/evsel.h b/tools/perf/util/evsel.h
index 532a5f9..4a7bdc7 100644
--- a/tools/perf/util/evsel.h
+++ b/tools/perf/util/evsel.h
@@ -48,6 +48,12 @@ struct perf_sample_id {
  * @name - Can be set to retain the original event name passed by the user,
  *         so that when showing results in tools such as 'perf stat', we
  *         show the name used, not some alias.
+ * @id_pos: the position of the event id (PERF_SAMPLE_ID or
+ *          PERF_SAMPLE_IDENTIFIER) in a sample event i.e. in the array of
+ *          struct sample_event
+ * @is_pos: the position (counting backwards) of the event id (PERF_SAMPLE_ID or
+ *          PERF_SAMPLE_IDENTIFIER) in a non-sample event i.e. if sample_id_all
+ *          is used there is an id sample appended to non-sample events
  */
 struct perf_evsel {
 	struct list_head	node;
@@ -74,6 +80,8 @@ struct perf_evsel {
 	} handler;
 	struct cpu_map		*cpus;
 	unsigned int		sample_size;
+	int			id_pos;
+	int			is_pos;
 	bool 			supported;
 	bool 			needs_swap;
 	/* parse modifier helper */
@@ -104,6 +112,9 @@ void perf_evsel__delete(struct perf_evsel *evsel);
 void perf_evsel__config(struct perf_evsel *evsel,
 			struct perf_record_opts *opts);
 
+int __perf_evsel__sample_size(u64 sample_type);
+void perf_evsel__calc_id_pos(struct perf_evsel *evsel);
+
 bool perf_evsel__is_cache_op_valid(u8 type, u8 op);
 
 #define PERF_EVSEL__MAX_ALIASES 8
@@ -142,7 +153,8 @@ void __perf_evsel__reset_sample_bit(struct perf_evsel *evsel,
 #define perf_evsel__reset_sample_bit(evsel, bit) \
 	__perf_evsel__reset_sample_bit(evsel, PERF_SAMPLE_##bit)
 
-void perf_evsel__set_sample_id(struct perf_evsel *evsel);
+void perf_evsel__set_sample_id(struct perf_evsel *evsel,
+			       bool use_sample_identifier);
 
 int perf_evsel__set_filter(struct perf_evsel *evsel, int ncpus, int nthreads,
 			   const char *filter);
diff --git a/tools/perf/util/record.c b/tools/perf/util/record.c
index 9b5ef79..18d73aa 100644
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
 			struct perf_record_opts *opts)
 {
 	struct perf_evsel *evsel;
+	bool use_sample_identifier = false;
+
 	/*
 	 * Set the evsel leader links before we configure attributes,
 	 * since some might depend on this info.
@@ -16,10 +88,21 @@ void perf_evlist__config(struct perf_evlist *evlist,
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
+
+	perf_evlist__set_id_pos(evlist);
 }
diff --git a/tools/perf/util/session.c b/tools/perf/util/session.c
index c3ac483..07642a7 100644
--- a/tools/perf/util/session.c
+++ b/tools/perf/util/session.c
@@ -739,7 +739,7 @@ static void perf_session__print_tstamp(struct perf_session *session,
 				       union perf_event *event,
 				       struct perf_sample *sample)
 {
-	u64 sample_type = perf_evlist__sample_type(session->evlist);
+	u64 sample_type = __perf_evlist__combined_sample_type(session->evlist);
 
 	if (event->header.type != PERF_RECORD_SAMPLE &&
 	    !perf_evlist__sample_id_all(session->evlist)) {
-- 
1.7.11.7

