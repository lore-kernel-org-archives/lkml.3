Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934677AbaGYPjA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jul 2014 11:39:00 -0400
Received: from mail.kernel.org ([198.145.19.201]:35242 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934552AbaGYPi4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jul 2014 11:38:56 -0400
From: Arnaldo Carvalho de Melo <acme@kernel.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Adrian Hunter <adrian.hunter@intel.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Namhyung Kim <namhyung@gmail.com>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 24/27] perf tools: Expose 'addr' functions so they can be reused
Date: Fri, 25 Jul 2014 12:37:06 -0300
Message-Id: <1406302629-11790-25-git-send-email-acme@kernel.org>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1406302629-11790-1-git-send-email-acme@kernel.org>
References: <1406302629-11790-1-git-send-email-acme@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Adrian Hunter <adrian.hunter@intel.com>

Move some functions and functionality related to the use of
'addr' out of builtin-script so they can be reused.

The moved functions are: is_bts_event() and sample_addr_correlates_sym()
and a new function perf_event__preprocess_sample_addr() is created from
bits of print_sample_addr().

perf_event__preprocess_sample_addr() is the equivalent of
perf_event__preprocess_sample() but for 'addr' instead of 'ip'.

Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Namhyung Kim <namhyung@gmail.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/r/1406035081-14301-31-git-send-email-adrian.hunter@intel.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/builtin-script.c | 34 +---------------------------------
 tools/perf/util/event.c     | 42 ++++++++++++++++++++++++++++++++++++++++++
 tools/perf/util/event.h     | 10 ++++++++++
 3 files changed, 53 insertions(+), 33 deletions(-)

diff --git a/tools/perf/builtin-script.c b/tools/perf/builtin-script.c
index 582da97872e5..f57035b89c15 100644
--- a/tools/perf/builtin-script.c
+++ b/tools/perf/builtin-script.c
@@ -358,27 +358,6 @@ static void print_sample_start(struct perf_sample *sample,
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
@@ -386,24 +365,13 @@ static void print_sample_addr(union perf_event *event,
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
index 7e0e8ae568ec..1398c83d896d 100644
--- a/tools/perf/util/event.c
+++ b/tools/perf/util/event.c
@@ -874,3 +874,45 @@ int perf_event__preprocess_sample(const union perf_event *event,
 
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
index e5dd40addb30..94d6976180da 100644
--- a/tools/perf/util/event.h
+++ b/tools/perf/util/event.h
@@ -288,6 +288,16 @@ int perf_event__preprocess_sample(const union perf_event *event,
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
1.9.3

