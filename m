Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755422Ab3AXTB0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jan 2013 14:01:26 -0500
Received: from terminus.zytor.com ([198.137.202.10]:33097 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751893Ab3AXTBY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jan 2013 14:01:24 -0500
Date: Thu, 24 Jan 2013 11:00:58 -0800
From: tip-bot for Arnaldo Carvalho de Melo <acme@redhat.com>
Message-ID: <tip-2ny5pzsing0dcth7hws48x9c@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, eranian@google.com, paulus@samba.org,
        acme@redhat.com, hpa@zytor.com, mingo@kernel.org, peterz@infradead.org,
        efault@gmx.de, namhyung@gmail.com, jolsa@redhat.com,
        fweisbec@gmail.com, dsahern@gmail.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, acme@redhat.com, paulus@samba.org,
        eranian@google.com, linux-kernel@vger.kernel.org, efault@gmx.de,
        peterz@infradead.org, namhyung@gmail.com, jolsa@redhat.com,
        fweisbec@gmail.com, dsahern@gmail.com, tglx@linutronix.de
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf evsel:
  Update sample_size when setting sample_type bits
Git-Commit-ID: 7be5ebe8767eaa482e18f566de5f56c1519abf59
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Thu, 24 Jan 2013 11:01:04 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  7be5ebe8767eaa482e18f566de5f56c1519abf59
Gitweb:     http://git.kernel.org/tip/7be5ebe8767eaa482e18f566de5f56c1519abf59
Author:     Arnaldo Carvalho de Melo <acme@redhat.com>
AuthorDate: Mon, 10 Dec 2012 14:53:43 -0300
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Mon, 10 Dec 2012 14:53:43 -0300

perf evsel: Update sample_size when setting sample_type bits

We use evsel->sample_size to detect underflows in
perf_evsel__parse_sample, but we were failing to update it after
perf_evsel__init(), i.e. when we decide, after creating an evsel, that
we want some extra field bit set.

Fix it by introducing methods to set a bit that will take care of
correctly adjusting evsel->sample_size.

Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Namhyung Kim <namhyung@gmail.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/n/tip-2ny5pzsing0dcth7hws48x9c@git.kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>

Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/builtin-record.c    |  2 +-
 tools/perf/builtin-top.c       | 11 ++++++-----
 tools/perf/tests/perf-record.c |  6 +++---
 tools/perf/util/evlist.c       |  2 +-
 tools/perf/util/evsel.c        | 45 ++++++++++++++++++++++++++++++------------
 tools/perf/util/evsel.h        | 11 +++++++++++
 6 files changed, 54 insertions(+), 23 deletions(-)

diff --git a/tools/perf/builtin-record.c b/tools/perf/builtin-record.c
index f3151d3..0be6605 100644
--- a/tools/perf/builtin-record.c
+++ b/tools/perf/builtin-record.c
@@ -286,7 +286,7 @@ try_again:
 					 */
 					opts->sample_id_all_missing = true;
 					if (!opts->sample_time && !opts->raw_samples && !time_needed)
-						attr->sample_type &= ~PERF_SAMPLE_TIME;
+						perf_evsel__reset_sample_bit(pos, TIME);
 
 					goto retry_sample_id;
 				}
diff --git a/tools/perf/builtin-top.c b/tools/perf/builtin-top.c
index 987e1b8..31a7c51 100644
--- a/tools/perf/builtin-top.c
+++ b/tools/perf/builtin-top.c
@@ -901,24 +901,25 @@ static void perf_top__start_counters(struct perf_top *top)
 	list_for_each_entry(counter, &evlist->entries, node) {
 		struct perf_event_attr *attr = &counter->attr;
 
-		attr->sample_type = PERF_SAMPLE_IP | PERF_SAMPLE_TID;
+		perf_evsel__set_sample_bit(counter, IP);
+		perf_evsel__set_sample_bit(counter, TID);
 
 		if (top->freq) {
-			attr->sample_type |= PERF_SAMPLE_PERIOD;
+			perf_evsel__set_sample_bit(counter, PERIOD);
 			attr->freq	  = 1;
 			attr->sample_freq = top->freq;
 		}
 
 		if (evlist->nr_entries > 1) {
-			attr->sample_type |= PERF_SAMPLE_ID;
+			perf_evsel__set_sample_bit(counter, ID);
 			attr->read_format |= PERF_FORMAT_ID;
 		}
 
 		if (perf_target__has_cpu(&top->target))
-			attr->sample_type |= PERF_SAMPLE_CPU;
+			perf_evsel__set_sample_bit(counter, CPU);
 
 		if (symbol_conf.use_callchain)
-			attr->sample_type |= PERF_SAMPLE_CALLCHAIN;
+			perf_evsel__set_sample_bit(counter, CALLCHAIN);
 
 		attr->mmap = 1;
 		attr->comm = 1;
diff --git a/tools/perf/tests/perf-record.c b/tools/perf/tests/perf-record.c
index 70e0d44..5902772 100644
--- a/tools/perf/tests/perf-record.c
+++ b/tools/perf/tests/perf-record.c
@@ -103,9 +103,9 @@ int test__PERF_RECORD(void)
 	 * Config the evsels, setting attr->comm on the first one, etc.
 	 */
 	evsel = perf_evlist__first(evlist);
-	evsel->attr.sample_type |= PERF_SAMPLE_CPU;
-	evsel->attr.sample_type |= PERF_SAMPLE_TID;
-	evsel->attr.sample_type |= PERF_SAMPLE_TIME;
+	perf_evsel__set_sample_bit(evsel, CPU);
+	perf_evsel__set_sample_bit(evsel, TID);
+	perf_evsel__set_sample_bit(evsel, TIME);
 	perf_evlist__config_attrs(evlist, &opts);
 
 	err = sched__get_first_possible_cpu(evlist->workload.pid, &cpu_mask);
diff --git a/tools/perf/util/evlist.c b/tools/perf/util/evlist.c
index d0e1e82..2655659 100644
--- a/tools/perf/util/evlist.c
+++ b/tools/perf/util/evlist.c
@@ -61,7 +61,7 @@ void perf_evlist__config_attrs(struct perf_evlist *evlist,
 		perf_evsel__config(evsel, opts);
 
 		if (evlist->nr_entries > 1)
-			evsel->attr.sample_type |= PERF_SAMPLE_ID;
+			perf_evsel__set_sample_bit(evsel, ID);
 	}
 }
 
diff --git a/tools/perf/util/evsel.c b/tools/perf/util/evsel.c
index bb58b05..fc80f5a 100644
--- a/tools/perf/util/evsel.c
+++ b/tools/perf/util/evsel.c
@@ -50,6 +50,24 @@ void hists__init(struct hists *hists)
 	pthread_mutex_init(&hists->lock, NULL);
 }
 
+void __perf_evsel__set_sample_bit(struct perf_evsel *evsel,
+				  enum perf_event_sample_format bit)
+{
+	if (!(evsel->attr.sample_type & bit)) {
+		evsel->attr.sample_type |= bit;
+		evsel->sample_size += sizeof(u64);
+	}
+}
+
+void __perf_evsel__reset_sample_bit(struct perf_evsel *evsel,
+				    enum perf_event_sample_format bit)
+{
+	if (evsel->attr.sample_type & bit) {
+		evsel->attr.sample_type &= ~bit;
+		evsel->sample_size -= sizeof(u64);
+	}
+}
+
 void perf_evsel__init(struct perf_evsel *evsel,
 		      struct perf_event_attr *attr, int idx)
 {
@@ -445,7 +463,8 @@ void perf_evsel__config(struct perf_evsel *evsel,
 			      PERF_FORMAT_TOTAL_TIME_RUNNING |
 			      PERF_FORMAT_ID;
 
-	attr->sample_type  |= PERF_SAMPLE_IP | PERF_SAMPLE_TID;
+	perf_evsel__set_sample_bit(evsel, IP);
+	perf_evsel__set_sample_bit(evsel, TID);
 
 	/*
 	 * We default some events to a 1 default interval. But keep
@@ -454,7 +473,7 @@ void perf_evsel__config(struct perf_evsel *evsel,
 	if (!attr->sample_period || (opts->user_freq != UINT_MAX &&
 				     opts->user_interval != ULLONG_MAX)) {
 		if (opts->freq) {
-			attr->sample_type	|= PERF_SAMPLE_PERIOD;
+			perf_evsel__set_sample_bit(evsel, PERIOD);
 			attr->freq		= 1;
 			attr->sample_freq	= opts->freq;
 		} else {
@@ -469,16 +488,16 @@ void perf_evsel__config(struct perf_evsel *evsel,
 		attr->inherit_stat = 1;
 
 	if (opts->sample_address) {
-		attr->sample_type	|= PERF_SAMPLE_ADDR;
+		perf_evsel__set_sample_bit(evsel, ADDR);
 		attr->mmap_data = track;
 	}
 
 	if (opts->call_graph) {
-		attr->sample_type	|= PERF_SAMPLE_CALLCHAIN;
+		perf_evsel__set_sample_bit(evsel, CALLCHAIN);
 
 		if (opts->call_graph == CALLCHAIN_DWARF) {
-			attr->sample_type |= PERF_SAMPLE_REGS_USER |
-					     PERF_SAMPLE_STACK_USER;
+			perf_evsel__set_sample_bit(evsel, REGS_USER);
+			perf_evsel__set_sample_bit(evsel, STACK_USER);
 			attr->sample_regs_user = PERF_REGS_MASK;
 			attr->sample_stack_user = opts->stack_dump_size;
 			attr->exclude_callchain_user = 1;
@@ -486,20 +505,20 @@ void perf_evsel__config(struct perf_evsel *evsel,
 	}
 
 	if (perf_target__has_cpu(&opts->target))
-		attr->sample_type	|= PERF_SAMPLE_CPU;
+		perf_evsel__set_sample_bit(evsel, CPU);
 
 	if (opts->period)
-		attr->sample_type	|= PERF_SAMPLE_PERIOD;
+		perf_evsel__set_sample_bit(evsel, PERIOD);
 
 	if (!opts->sample_id_all_missing &&
 	    (opts->sample_time || !opts->no_inherit ||
 	     perf_target__has_cpu(&opts->target)))
-		attr->sample_type	|= PERF_SAMPLE_TIME;
+		perf_evsel__set_sample_bit(evsel, TIME);
 
 	if (opts->raw_samples) {
-		attr->sample_type	|= PERF_SAMPLE_TIME;
-		attr->sample_type	|= PERF_SAMPLE_RAW;
-		attr->sample_type	|= PERF_SAMPLE_CPU;
+		perf_evsel__set_sample_bit(evsel, TIME);
+		perf_evsel__set_sample_bit(evsel, RAW);
+		perf_evsel__set_sample_bit(evsel, CPU);
 	}
 
 	if (opts->no_delay) {
@@ -507,7 +526,7 @@ void perf_evsel__config(struct perf_evsel *evsel,
 		attr->wakeup_events = 1;
 	}
 	if (opts->branch_stack) {
-		attr->sample_type	|= PERF_SAMPLE_BRANCH_STACK;
+		perf_evsel__set_sample_bit(evsel, BRANCH_STACK);
 		attr->branch_sample_type = opts->branch_stack;
 	}
 
diff --git a/tools/perf/util/evsel.h b/tools/perf/util/evsel.h
index 3f7ff47..7398539 100644
--- a/tools/perf/util/evsel.h
+++ b/tools/perf/util/evsel.h
@@ -118,6 +118,17 @@ void perf_evsel__free_fd(struct perf_evsel *evsel);
 void perf_evsel__free_id(struct perf_evsel *evsel);
 void perf_evsel__close_fd(struct perf_evsel *evsel, int ncpus, int nthreads);
 
+void __perf_evsel__set_sample_bit(struct perf_evsel *evsel,
+				  enum perf_event_sample_format bit);
+void __perf_evsel__reset_sample_bit(struct perf_evsel *evsel,
+				    enum perf_event_sample_format bit);
+
+#define perf_evsel__set_sample_bit(evsel, bit) \
+	__perf_evsel__set_sample_bit(evsel, PERF_SAMPLE_##bit)
+
+#define perf_evsel__reset_sample_bit(evsel, bit) \
+	__perf_evsel__reset_sample_bit(evsel, PERF_SAMPLE_##bit)
+
 int perf_evsel__set_filter(struct perf_evsel *evsel, int ncpus, int nthreads,
 			   const char *filter);
 
