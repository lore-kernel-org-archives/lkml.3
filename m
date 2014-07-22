Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755811AbaGVN2B (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2014 09:28:01 -0400
Received: from mga02.intel.com ([134.134.136.20]:45434 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755328AbaGVNUw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2014 09:20:52 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,710,1400050800"; 
   d="scan'208";a="576985957"
From: Adrian Hunter <adrian.hunter@intel.com>
To: Arnaldo Carvalho de Melo <acme@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Namhyung Kim <namhyung@gmail.com>, Paul Mackerras <paulus@samba.org>,
        Stephane Eranian <eranian@google.com>
Subject: [PATCH 30/52] perf tools: Expose 'addr' functions so they can be reused
Date: Tue, 22 Jul 2014 16:17:39 +0300
Message-Id: <1406035081-14301-31-git-send-email-adrian.hunter@intel.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1406035081-14301-1-git-send-email-adrian.hunter@intel.com>
References: <1406035081-14301-1-git-send-email-adrian.hunter@intel.com>
Organization: Intel Finland Oy, Registered Address: PL 281, 00181 Helsinki, Business Identity Code: 0357606 - 4, Domiciled in Helsinki
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Move some functions and functionality related to the use of
'addr' out of builtin-script so they can be reused.  The
moved functions are: is_bts_event() and sample_addr_correlates_sym()
and a new function perf_event__preprocess_sample_addr() is
created from bits of print_sample_addr().
perf_event__preprocess_sample_addr() is the equivalent of
perf_event__preprocess_sample() but for 'addr' instead of
'ip'.

Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
---
 tools/perf/builtin-script.c | 34 +---------------------------------
 tools/perf/util/event.c     | 42 ++++++++++++++++++++++++++++++++++++++++++
 tools/perf/util/event.h     | 10 ++++++++++
 3 files changed, 53 insertions(+), 33 deletions(-)

diff --git a/tools/perf/builtin-script.c b/tools/perf/builtin-script.c
index c1a56f2..163d12b 100644
--- a/tools/perf/builtin-script.c
+++ b/tools/perf/builtin-script.c
@@ -367,27 +367,6 @@ static void print_sample_start(struct perf_sample *sample,
 	}
 }
 
-static bool is_bts_event(struct perf_event_attr *attr)
-{
-	return ((attr->type == PERF_TYPE_HARDWARE) &&
-		(attr->config & PERF_COUNT_HW_BRANCH_INSTRUCTIONS) &&
-		(attr->sample_period == 1));
-}
-
-static bool sample_addr_correlates_sym(struct perf_event_attr *attr)
-{
-	if ((attr->type == PERF_TYPE_SOFTWARE) &&
-	    ((attr->config == PERF_COUNT_SW_PAGE_FAULTS) ||
-	     (attr->config == PERF_COUNT_SW_PAGE_FAULTS_MIN) ||
-	     (attr->config == PERF_COUNT_SW_PAGE_FAULTS_MAJ)))
-		return true;
-
-	if (is_bts_event(attr))
-		return true;
-
-	return false;
-}
-
 static void print_sample_addr(union perf_event *event,
 			  struct perf_sample *sample,
 			  struct machine *machine,
@@ -395,24 +374,13 @@ static void print_sample_addr(union perf_event *event,
 			  struct perf_event_attr *attr)
 {
 	struct addr_location al;
-	u8 cpumode = event->header.misc & PERF_RECORD_MISC_CPUMODE_MASK;
 
 	printf("%16" PRIx64, sample->addr);
 
 	if (!sample_addr_correlates_sym(attr))
 		return;
 
-	thread__find_addr_map(thread, machine, cpumode, MAP__FUNCTION,
-			      sample->addr, &al);
-	if (!al.map)
-		thread__find_addr_map(thread, machine, cpumode, MAP__VARIABLE,
-				      sample->addr, &al);
-
-	al.cpu = sample->cpu;
-	al.sym = NULL;
-
-	if (al.map)
-		al.sym = map__find_symbol(al.map, al.addr, NULL);
+	perf_event__preprocess_sample_addr(event, sample, machine, thread, &al);
 
 	if (PRINT_FIELD(SYM)) {
 		printf(" ");
diff --git a/tools/perf/util/event.c b/tools/perf/util/event.c
index dc32de0..1727574 100644
--- a/tools/perf/util/event.c
+++ b/tools/perf/util/event.c
@@ -875,3 +875,45 @@ int perf_event__preprocess_sample(const union perf_event *event,
 
 	return 0;
 }
+
+bool is_bts_event(struct perf_event_attr *attr)
+{
+	return attr->type == PERF_TYPE_HARDWARE &&
+	       (attr->config & PERF_COUNT_HW_BRANCH_INSTRUCTIONS) &&
+	       attr->sample_period == 1;
+}
+
+bool sample_addr_correlates_sym(struct perf_event_attr *attr)
+{
+	if (attr->type == PERF_TYPE_SOFTWARE &&
+	    (attr->config == PERF_COUNT_SW_PAGE_FAULTS ||
+	     attr->config == PERF_COUNT_SW_PAGE_FAULTS_MIN ||
+	     attr->config == PERF_COUNT_SW_PAGE_FAULTS_MAJ))
+		return true;
+
+	if (is_bts_event(attr))
+		return true;
+
+	return false;
+}
+
+void perf_event__preprocess_sample_addr(union perf_event *event,
+					struct perf_sample *sample,
+					struct machine *machine,
+					struct thread *thread,
+					struct addr_location *al)
+{
+	u8 cpumode = event->header.misc & PERF_RECORD_MISC_CPUMODE_MASK;
+
+	thread__find_addr_map(thread, machine, cpumode, MAP__FUNCTION,
+			      sample->addr, al);
+	if (!al->map)
+		thread__find_addr_map(thread, machine, cpumode, MAP__VARIABLE,
+				      sample->addr, al);
+
+	al->cpu = sample->cpu;
+	al->sym = NULL;
+
+	if (al->map)
+		al->sym = map__find_symbol(al->map, al->addr, NULL);
+}
diff --git a/tools/perf/util/event.h b/tools/perf/util/event.h
index ae75b48..b8e5d1a 100644
--- a/tools/perf/util/event.h
+++ b/tools/perf/util/event.h
@@ -329,6 +329,16 @@ int perf_event__preprocess_sample(const union perf_event *event,
 				  struct addr_location *al,
 				  struct perf_sample *sample);
 
+struct thread;
+
+bool is_bts_event(struct perf_event_attr *attr);
+bool sample_addr_correlates_sym(struct perf_event_attr *attr);
+void perf_event__preprocess_sample_addr(union perf_event *event,
+					struct perf_sample *sample,
+					struct machine *machine,
+					struct thread *thread,
+					struct addr_location *al);
+
 const char *perf_event__name(unsigned int id);
 
 size_t perf_event__sample_event_size(const struct perf_sample *sample, u64 type,
-- 
1.8.3.2

