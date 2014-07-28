Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752544AbaG1I2T (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2014 04:28:19 -0400
Received: from terminus.zytor.com ([198.137.202.10]:42738 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751779AbaG1I2Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2014 04:28:16 -0400
Date: Mon, 28 Jul 2014 01:27:16 -0700
From: tip-bot for Adrian Hunter <tipbot@zytor.com>
Message-ID: <tip-9b0d2d875d57d85fdfb35ac27f89951520a8b473@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, eranian@google.com,
        paulus@samba.org, hpa@zytor.com, mingo@kernel.org,
        peterz@infradead.org, namhyung@gmail.com, jolsa@redhat.com,
        fweisbec@gmail.com, adrian.hunter@intel.com, dsahern@gmail.com,
        tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, paulus@samba.org,
        eranian@google.com, linux-kernel@vger.kernel.org, acme@redhat.com,
        peterz@infradead.org, namhyung@gmail.com, jolsa@redhat.com,
        fweisbec@gmail.com, dsahern@gmail.com, adrian.hunter@intel.com,
        tglx@linutronix.de
In-Reply-To: <1406035081-14301-31-git-send-email-adrian.hunter@intel.com>
References: <1406035081-14301-31-git-send-email-adrian.hunter@intel.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf tools: Expose 'addr'
  functions so they can be reused
Git-Commit-ID: 9b0d2d875d57d85fdfb35ac27f89951520a8b473
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  9b0d2d875d57d85fdfb35ac27f89951520a8b473
Gitweb:     http://git.kernel.org/tip/9b0d2d875d57d85fdfb35ac27f89951520a8b473
Author:     Adrian Hunter <adrian.hunter@intel.com>
AuthorDate: Tue, 22 Jul 2014 16:17:39 +0300
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Fri, 25 Jul 2014 12:08:34 -0300

perf tools: Expose 'addr' functions so they can be reused

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
index 582da97..f57035b 100644
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
index 7e0e8ae..1398c83 100644
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
index e5dd40a..94d6976 100644
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
