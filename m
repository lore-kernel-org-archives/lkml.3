Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752815Ab3LKMmk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Dec 2013 07:42:40 -0500
Received: from mga09.intel.com ([134.134.136.24]:19672 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752797Ab3LKMmg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Dec 2013 07:42:36 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,871,1378882800"; 
   d="scan'208";a="422887267"
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
Subject: [PATCH v0 58/71] perf tools: Add Instruction Tracing Snapshot Mode
Date: Wed, 11 Dec 2013 14:37:10 +0200
Message-Id: <1386765443-26966-59-git-send-email-alexander.shishkin@linux.intel.com>
X-Mailer: git-send-email 1.8.4.rc2
In-Reply-To: <1386765443-26966-1-git-send-email-alexander.shishkin@linux.intel.com>
References: <1386765443-26966-1-git-send-email-alexander.shishkin@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Adrian Hunter <adrian.hunter@intel.com>

Add support for making snapshots of
Instruction Tracing data.

Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
---
 tools/perf/perf.h        |  2 ++
 tools/perf/util/itrace.c | 79 +++++++++++++++++++++++++++++++++++++++++++-----
 tools/perf/util/itrace.h | 20 ++++++++++++
 3 files changed, 93 insertions(+), 8 deletions(-)

diff --git a/tools/perf/perf.h b/tools/perf/perf.h
index c748383..531b258 100644
--- a/tools/perf/perf.h
+++ b/tools/perf/perf.h
@@ -263,6 +263,7 @@ struct perf_record_opts {
 	bool	     period;
 	bool	     full_itrace;
 	bool	     sample_itrace;
+	bool	     itrace_snapshot_mode;
 	unsigned int freq;
 	unsigned int mmap_pages;
 	unsigned int itrace_mmap_pages;
@@ -273,6 +274,7 @@ struct perf_record_opts {
 	u64	     itrace_sample_config;
 	u32	     itrace_sample_type;
 	size_t	     itrace_sample_size;
+	size_t	     itrace_snapshot_size;
 	u16	     stack_dump_size;
 	bool	     sample_transaction;
 };
diff --git a/tools/perf/util/itrace.c b/tools/perf/util/itrace.c
index d64dcb1..da2f175 100644
--- a/tools/perf/util/itrace.c
+++ b/tools/perf/util/itrace.c
@@ -561,6 +561,29 @@ void itrace_record__free(struct itrace_record *itr)
 		itr->free(itr);
 }
 
+int itrace_record__snapshot_start(struct itrace_record *itr)
+{
+	if (itr && itr->snapshot_start)
+		return itr->snapshot_start(itr);
+	return 0;
+}
+
+int itrace_record__snapshot_finish(struct itrace_record *itr)
+{
+	if (itr && itr->snapshot_finish)
+		return itr->snapshot_finish(itr);
+	return 0;
+}
+
+int itrace_record__find_snapshot(struct itrace_record *itr, int idx,
+				 struct itrace_mmap *mm,
+				 unsigned char *data, u64 *head, u64 *old)
+{
+	if (itr && itr->find_snapshot)
+		return itr->find_snapshot(itr, idx, mm, data, head, old);
+	return 0;
+}
+
 int itrace_record__options(struct itrace_record *itr,
 			   struct perf_evlist *evlist,
 			   struct perf_record_opts *opts)
@@ -592,6 +615,21 @@ int itrace_parse_sample_options(const struct option *opt, const char *str,
 	return itrace_not_supported();
 }
 
+int itrace_parse_snapshot_options(const struct option *opt, const char *str,
+				  int unset)
+{
+	struct itrace_record *itr = *(struct itrace_record **)opt->data;
+	struct perf_record_opts *opts = opt->value;
+
+	if (unset)
+		return 0;
+
+	if (itr)
+		return itr->parse_snapshot_options(itr, opts, str);
+
+	return itrace_not_supported();
+}
+
 struct itrace_record *__attribute__ ((weak)) itrace_record__init(int *err)
 {
 	*err = 0;
@@ -898,8 +936,10 @@ int perf_event__count_itrace_error(struct perf_tool *tool __maybe_unused,
 	return 0;
 }
 
-int itrace_mmap__read(struct itrace_mmap *mm, struct itrace_record *itr,
-		      struct perf_tool *tool, process_itrace_t fn)
+static int __itrace_mmap__read(struct itrace_mmap *mm,
+			       struct itrace_record *itr,
+			       struct perf_tool *tool, process_itrace_t fn,
+			       bool snapshot, size_t snapshot_size)
 {
 	u64 head = itrace_mmap__read_head(mm);
 	u64 old = mm->prev, offset, ref;
@@ -908,6 +948,10 @@ int itrace_mmap__read(struct itrace_mmap *mm, struct itrace_record *itr,
 	union perf_event ev;
 	void *data1, *data2;
 
+	if (snapshot && itrace_record__find_snapshot(itr, mm->idx, mm, data,
+						     &head, &old))
+		return -1;
+
 	if (old == head)
 		return 0;
 
@@ -927,6 +971,9 @@ int itrace_mmap__read(struct itrace_mmap *mm, struct itrace_record *itr,
 	else
 		size = mm->len - (old_off - head_off);
 
+	if (snapshot && size > snapshot_size)
+		size = snapshot_size;
+
 	ref = itrace_record__reference(itr);
 
 	if (head > old || size <= head || mm->mask) {
@@ -969,14 +1016,30 @@ int itrace_mmap__read(struct itrace_mmap *mm, struct itrace_record *itr,
 
 	mm->prev = head;
 
-	itrace_mmap__write_tail(mm, head);
-	if (itr->read_finish) {
-		int err;
+	if (!snapshot) {
+		itrace_mmap__write_tail(mm, head);
+		if (itr->read_finish) {
+			int err;
 
-		err = itr->read_finish(itr, mm->idx);
-		if (err < 0)
-			return err;
+			err = itr->read_finish(itr, mm->idx);
+			if (err < 0)
+				return err;
+		}
 	}
 
 	return 1;
 }
+
+int itrace_mmap__read(struct itrace_mmap *mm, struct itrace_record *itr,
+		      struct perf_tool *tool, process_itrace_t fn)
+{
+	return __itrace_mmap__read(mm, itr, tool, fn, false, 0);
+}
+
+int itrace_mmap__read_snapshot(struct itrace_mmap *mm,
+			       struct itrace_record *itr,
+			       struct perf_tool *tool, process_itrace_t fn,
+			       size_t snapshot_size)
+{
+	return __itrace_mmap__read(mm, itr, tool, fn, true, snapshot_size);
+}
diff --git a/tools/perf/util/itrace.h b/tools/perf/util/itrace.h
index 2ebcdec..9ff633c 100644
--- a/tools/perf/util/itrace.h
+++ b/tools/perf/util/itrace.h
@@ -241,6 +241,14 @@ struct itrace_record {
 			 struct itrace_info_event *itrace_info,
 			 size_t priv_size);
 	void (*free)(struct itrace_record *itr);
+	int (*snapshot_start)(struct itrace_record *itr);
+	int (*snapshot_finish)(struct itrace_record *itr);
+	int (*find_snapshot)(struct itrace_record *itr, int idx,
+			     struct itrace_mmap *mm, unsigned char *data,
+			     u64 *head, u64 *old);
+	int (*parse_snapshot_options)(struct itrace_record *itr,
+				      struct perf_record_opts *opts,
+				      const char *str);
 	u64 (*reference)(struct itrace_record *itr);
 	int (*read_finish)(struct itrace_record *itr, int idx);
 };
@@ -294,6 +302,11 @@ int itrace_mmap__read(struct itrace_mmap *mm,
 			    struct itrace_record *itr, struct perf_tool *tool,
 			    process_itrace_t fn);
 
+int itrace_mmap__read_snapshot(struct itrace_mmap *mm,
+			       struct itrace_record *itr,
+			       struct perf_tool *tool, process_itrace_t fn,
+			       size_t snapshot_size);
+
 int itrace_queues__init(struct itrace_queues *queues);
 int itrace_queues__add_event(struct itrace_queues *queues,
 			     struct perf_session *session,
@@ -321,6 +334,8 @@ struct itrace_record *itrace_record__init(int *err);
 
 int itrace_parse_sample_options(const struct option *opt, const char *str,
 				int unset);
+int itrace_parse_snapshot_options(const struct option *opt, const char *str,
+				  int unset);
 int itrace_record__options(struct itrace_record *itr,
 			     struct perf_evlist *evlist,
 			     struct perf_record_opts *opts);
@@ -330,6 +345,11 @@ int itrace_record__info_fill(struct itrace_record *itr,
 			     struct itrace_info_event *itrace_info,
 			     size_t priv_size);
 void itrace_record__free(struct itrace_record *itr);
+int itrace_record__snapshot_start(struct itrace_record *itr);
+int itrace_record__snapshot_finish(struct itrace_record *itr);
+int itrace_record__find_snapshot(struct itrace_record *itr, int idx,
+				 struct itrace_mmap *mm,
+				 unsigned char *data, u64 *head, u64 *old);
 u64 itrace_record__reference(struct itrace_record *itr);
 
 void itrace_synth_error(struct itrace_error_event *itrace_error, int type,
-- 
1.8.5.1

