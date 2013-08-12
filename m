Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756155Ab3HLKRq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Aug 2013 06:17:46 -0400
Received: from terminus.zytor.com ([198.137.202.10]:47683 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756097Ab3HLKR0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Aug 2013 06:17:26 -0400
Date: Mon, 12 Aug 2013 03:17:03 -0700
From: tip-bot for Jiri Olsa <tipbot@zytor.com>
Message-ID: <tip-0tgdoln5rwk3wocshb442cl3@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, paulus@samba.org,
        hpa@zytor.com, mingo@kernel.org, a.p.zijlstra@chello.nl,
        namhyung@kernel.org, jolsa@redhat.com, fweisbec@gmail.com,
        tglx@linutronix.de, cjashfor@linux.vnet.ibm.com
Reply-To: mingo@kernel.org, hpa@zytor.com, paulus@samba.org,
        linux-kernel@vger.kernel.org, acme@redhat.com, a.p.zijlstra@chello.nl,
        namhyung@kernel.org, jolsa@redhat.com, fweisbec@gmail.com,
        tglx@linutronix.de, cjashfor@linux.vnet.ibm.com
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf tools:
  Add support for parsing PERF_SAMPLE_READ sample type
Git-Commit-ID: 9ede473cc9f655f8a10cfc8ebbf04c48d84db7ee
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Mon, 12 Aug 2013 03:17:11 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  9ede473cc9f655f8a10cfc8ebbf04c48d84db7ee
Gitweb:     http://git.kernel.org/tip/9ede473cc9f655f8a10cfc8ebbf04c48d84db7ee
Author:     Jiri Olsa <jolsa@redhat.com>
AuthorDate: Wed, 10 Oct 2012 17:38:13 +0200
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Wed, 7 Aug 2013 17:35:20 -0300

perf tools: Add support for parsing PERF_SAMPLE_READ sample type

Adding support to parse out the PERF_SAMPLE_READ sample bits.  The code
contains both single and group format specification.

This code parse out and prepare PERF_SAMPLE_READ data into the
perf_sample struct. It will be used for group leader sampling feature
comming in shortly.

Signed-off-by: Jiri Olsa <jolsa@redhat.com>
Acked-by: Namhyung Kim <namhyung@kernel.org>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/n/tip-0tgdoln5rwk3wocshb442cl3@git.kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/event.h   | 18 ++++++++++++++++++
 tools/perf/util/evlist.c  | 26 ++++++++++++++++++++++++++
 tools/perf/util/evlist.h  |  2 ++
 tools/perf/util/evsel.c   | 30 ++++++++++++++++++++++++++++--
 tools/perf/util/session.c | 38 ++++++++++++++++++++++++++++++++++++++
 5 files changed, 112 insertions(+), 2 deletions(-)

diff --git a/tools/perf/util/event.h b/tools/perf/util/event.h
index 1ebb8fb..6119a64 100644
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
@@ -97,6 +114,7 @@ struct perf_sample {
 	struct branch_stack *branch_stack;
 	struct regs_dump  user_regs;
 	struct stack_dump user_stack;
+	struct sample_read read;
 };
 
 #define PERF_MEM_DATA_SRC_NONE \
diff --git a/tools/perf/util/evlist.c b/tools/perf/util/evlist.c
index 0d3b739..df77a44 100644
--- a/tools/perf/util/evlist.c
+++ b/tools/perf/util/evlist.c
@@ -676,6 +676,32 @@ u64 perf_evlist__sample_type(struct perf_evlist *evlist)
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
index 0583d36..c7178b7 100644
--- a/tools/perf/util/evlist.h
+++ b/tools/perf/util/evlist.h
@@ -118,6 +118,7 @@ int perf_evlist__apply_filters(struct perf_evlist *evlist);
 void __perf_evlist__set_leader(struct list_head *list);
 void perf_evlist__set_leader(struct perf_evlist *evlist);
 
+u64 perf_evlist__read_format(struct perf_evlist *evlist);
 u64 perf_evlist__sample_type(struct perf_evlist *evlist);
 bool perf_evlist__sample_id_all(struct perf_evlist *evlist);
 u16 perf_evlist__id_hdr_size(struct perf_evlist *evlist);
@@ -127,6 +128,7 @@ int perf_evlist__parse_sample(struct perf_evlist *evlist, union perf_event *even
 
 bool perf_evlist__valid_sample_type(struct perf_evlist *evlist);
 bool perf_evlist__valid_sample_id_all(struct perf_evlist *evlist);
+bool perf_evlist__valid_read_format(struct perf_evlist *evlist);
 
 void perf_evlist__splice_list_tail(struct perf_evlist *evlist,
 				   struct list_head *list,
diff --git a/tools/perf/util/evsel.c b/tools/perf/util/evsel.c
index 8bed0c1..9ab8fff 100644
--- a/tools/perf/util/evsel.c
+++ b/tools/perf/util/evsel.c
@@ -1096,8 +1096,34 @@ int perf_evsel__parse_sample(struct perf_evsel *evsel, union perf_event *event,
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
index 272c9cf..f082921 100644
--- a/tools/perf/util/session.c
+++ b/tools/perf/util/session.c
@@ -71,6 +71,11 @@ static int perf_session__open(struct perf_session *self, bool force)
 		goto out_close;
 	}
 
+	if (!perf_evlist__valid_read_format(self->evlist)) {
+		pr_err("non matching read_format");
+		goto out_close;
+	}
+
 	self->size = input_stat.st_size;
 	return 0;
 
@@ -749,6 +754,36 @@ static void perf_session__print_tstamp(struct perf_session *session,
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
@@ -798,6 +833,9 @@ static void dump_sample(struct perf_evsel *evsel, union perf_event *event,
 
 	if (sample_type & PERF_SAMPLE_DATA_SRC)
 		printf(" . data_src: 0x%"PRIx64"\n", sample->data_src);
+
+	if (sample_type & PERF_SAMPLE_READ)
+		sample_read__printf(sample, evsel->attr.read_format);
 }
 
 static struct machine *
