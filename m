Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755283Ab3BDMed (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Feb 2013 07:34:33 -0500
Received: from mx1.redhat.com ([209.132.183.28]:20375 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755248Ab3BDMeb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Feb 2013 07:34:31 -0500
From: Jiri Olsa <jolsa@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Jiri Olsa <jolsa@redhat.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>,
        Paul Mackerras <paulus@samba.org>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Namhyung Kim <namhyung@kernel.org>
Subject: [PATCH 05/11] perf tools: Add support for parsing PERF_SAMPLE_READ sample type
Date: Mon,  4 Feb 2013 13:32:59 +0100
Message-Id: <1359981185-16819-6-git-send-email-jolsa@redhat.com>
In-Reply-To: <1359981185-16819-1-git-send-email-jolsa@redhat.com>
References: <1359981185-16819-1-git-send-email-jolsa@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adding support to parse out the PERF_SAMPLE_READ sample bits.
The code contains both single and group format specification.

This code parse out and prepare PERF_SAMPLE_READ data into the
perf_sample struct. It will be used for group leader sampling
feature comming in shortly.

Signed-off-by: Jiri Olsa <jolsa@redhat.com>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Namhyung Kim <namhyung@kernel.org>
---
 tools/perf/util/event.h   | 18 ++++++++++++++++++
 tools/perf/util/evlist.c  | 27 +++++++++++++++++++++++++++
 tools/perf/util/evlist.h  |  2 ++
 tools/perf/util/evsel.c   | 30 ++++++++++++++++++++++++++++--
 tools/perf/util/session.c | 38 ++++++++++++++++++++++++++++++++++++++
 5 files changed, 113 insertions(+), 2 deletions(-)

diff --git a/tools/perf/util/event.h b/tools/perf/util/event.h
index 0d573ff..108da52 100644
--- a/tools/perf/util/event.h
+++ b/tools/perf/util/event.h
@@ -80,6 +80,23 @@ struct stack_dump {
 	char *data;
 };
 
+struct sample_read_value {
+	u64 value;
+	u64 id;
+};
+
+struct sample_read {
+	u64 time_enabled;
+	u64 time_running;
+	union {
+		struct {
+			u64 nr;
+			struct sample_read_value *values;
+		} group;
+		struct sample_read_value one;
+	};
+};
+
 struct perf_sample {
 	u64 ip;
 	u32 pid, tid;
@@ -95,6 +112,7 @@ struct perf_sample {
 	struct branch_stack *branch_stack;
 	struct regs_dump  user_regs;
 	struct stack_dump user_stack;
+	struct sample_read read;
 };
 
 struct build_id_event {
diff --git a/tools/perf/util/evlist.c b/tools/perf/util/evlist.c
index 51e21f9..5ba5509 100644
--- a/tools/perf/util/evlist.c
+++ b/tools/perf/util/evlist.c
@@ -674,6 +674,33 @@ u64 perf_evlist__sample_type(struct perf_evlist *evlist)
 	return first->attr.sample_type;
 }
 
+bool perf_evlist__valid_read_format(struct perf_evlist *evlist)
+{
+	struct perf_evsel *first = perf_evlist__first(evlist), *pos = first;
+	u64 read_format = first->attr.read_format;
+	u64 sample_type = first->attr.sample_type;
+
+	list_for_each_entry_continue(pos, &evlist->entries, node) {
+		if (read_format != pos->attr.read_format)
+			return false;
+	}
+
+	/* PERF_SAMPLE_READ imples PERF_FORMAT_ID. */
+	if ((sample_type & PERF_SAMPLE_READ) &&
+	    !(read_format & PERF_FORMAT_ID)) {
+		pr_err("Wrong format type for sample read type.\n");
+		return false;
+	}
+
+	return true;
+}
+
+u64 perf_evlist__read_format(struct perf_evlist *evlist)
+{
+	struct perf_evsel *first = perf_evlist__first(evlist);
+	return first->attr.read_format;
+}
+
 u16 perf_evlist__id_hdr_size(struct perf_evlist *evlist)
 {
 	struct perf_evsel *first = perf_evlist__first(evlist);
diff --git a/tools/perf/util/evlist.h b/tools/perf/util/evlist.h
index 73579a2..0b7297c 100644
--- a/tools/perf/util/evlist.h
+++ b/tools/perf/util/evlist.h
@@ -111,6 +111,7 @@ int perf_evlist__apply_filters(struct perf_evlist *evlist);
 void __perf_evlist__set_leader(struct list_head *list);
 void perf_evlist__set_leader(struct perf_evlist *evlist);
 
+u64 perf_evlist__read_format(struct perf_evlist *evlist);
 u64 perf_evlist__sample_type(struct perf_evlist *evlist);
 bool perf_evlist__sample_id_all(struct perf_evlist *evlist);
 u16 perf_evlist__id_hdr_size(struct perf_evlist *evlist);
@@ -120,6 +121,7 @@ int perf_evlist__parse_sample(struct perf_evlist *evlist, union perf_event *even
 
 bool perf_evlist__valid_sample_type(struct perf_evlist *evlist);
 bool perf_evlist__valid_sample_id_all(struct perf_evlist *evlist);
+bool perf_evlist__valid_read_format(struct perf_evlist *evlist);
 
 void perf_evlist__splice_list_tail(struct perf_evlist *evlist,
 				   struct list_head *list,
diff --git a/tools/perf/util/evsel.c b/tools/perf/util/evsel.c
index a547015..f841f5d 100644
--- a/tools/perf/util/evsel.c
+++ b/tools/perf/util/evsel.c
@@ -1084,8 +1084,34 @@ int perf_evsel__parse_sample(struct perf_evsel *evsel, union perf_event *event,
 	}
 
 	if (type & PERF_SAMPLE_READ) {
-		fprintf(stderr, "PERF_SAMPLE_READ is unsupported for now\n");
-		return -1;
+		u64 read_format = evsel->attr.read_format;
+
+		if (read_format & PERF_FORMAT_GROUP)
+			data->read.group.nr = *array;
+		else
+			data->read.one.value = *array;
+
+		array++;
+
+		if (read_format & PERF_FORMAT_TOTAL_TIME_ENABLED) {
+			data->read.time_enabled = *array;
+			array++;
+		}
+
+		if (read_format & PERF_FORMAT_TOTAL_TIME_RUNNING) {
+			data->read.time_running = *array;
+			array++;
+		}
+
+		/* PERF_FORMAT_ID is forced for PERF_SAMPLE_READ */
+		if (read_format & PERF_FORMAT_GROUP) {
+			data->read.group.values = (struct sample_read_value *) array;
+			array = (void *) array + data->read.group.nr *
+				sizeof(struct sample_read_value);
+		} else {
+			data->read.one.id = *array;
+			array++;
+		}
 	}
 
 	if (type & PERF_SAMPLE_CALLCHAIN) {
diff --git a/tools/perf/util/session.c b/tools/perf/util/session.c
index bd85280b..0612ae5 100644
--- a/tools/perf/util/session.c
+++ b/tools/perf/util/session.c
@@ -73,6 +73,11 @@ static int perf_session__open(struct perf_session *self, bool force)
 		goto out_close;
 	}
 
+	if (!perf_evlist__valid_read_format(self->evlist)) {
+		pr_err("non matching read_format");
+		goto out_close;
+	}
+
 	self->size = input_stat.st_size;
 	return 0;
 
@@ -757,6 +762,36 @@ static void perf_session__print_tstamp(struct perf_session *session,
 		printf("%" PRIu64 " ", sample->time);
 }
 
+static void sample_read__printf(struct perf_sample *sample, u64 read_format)
+{
+	printf("... sample_read:\n");
+
+	if (read_format & PERF_FORMAT_TOTAL_TIME_ENABLED)
+		printf("...... time enabled %016" PRIx64 "\n",
+		       sample->read.time_enabled);
+
+	if (read_format & PERF_FORMAT_TOTAL_TIME_RUNNING)
+		printf("...... time running %016" PRIx64 "\n",
+		       sample->read.time_running);
+
+	if (read_format & PERF_FORMAT_GROUP) {
+		u64 i;
+
+		printf(".... group nr %" PRIu64 "\n", sample->read.group.nr);
+
+		for (i = 0; i < sample->read.group.nr; i++) {
+			struct sample_read_value *value;
+
+			value = &sample->read.group.values[i];
+			printf("..... id %016" PRIx64
+			       ", value %016" PRIx64 "\n",
+			       value->id, value->value);
+		}
+	} else
+		printf("..... id %016" PRIx64 ", value %016" PRIx64 "\n",
+			sample->read.one.id, sample->read.one.value);
+}
+
 static void dump_event(struct perf_session *session, union perf_event *event,
 		       u64 file_offset, struct perf_sample *sample)
 {
@@ -800,6 +835,9 @@ static void dump_sample(struct perf_evsel *evsel, union perf_event *event,
 
 	if (sample_type & PERF_SAMPLE_STACK_USER)
 		stack_user__printf(&sample->user_stack);
+
+	if (sample_type & PERF_SAMPLE_READ)
+		sample_read__printf(sample, evsel->attr.read_format);
 }
 
 static struct machine *
-- 
1.7.11.7

