Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933836AbaJ2OPz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Oct 2014 10:15:55 -0400
Received: from mail.kernel.org ([198.145.19.201]:41016 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933054AbaJ2OHQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Oct 2014 10:07:16 -0400
From: Arnaldo Carvalho de Melo <acme@kernel.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>,
        Adrian Hunter <adrian.hunter@intel.com>, Borislav Petkov <bp@suse.de>,
        David Ahern <dsahern@gmail.com>, Don Zickus <dzickus@redhat.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Jean Pihet <jean.pihet@linaro.org>, Jiri Olsa <jolsa@redhat.com>,
        Mike Galbraith <efault@gmx.de>, Namhyung Kim <namhyung@kernel.org>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>
Subject: [PATCH 04/25] perf thread: Adopt resolve_callchain method from machine
Date: Wed, 29 Oct 2014 12:06:16 -0200
Message-Id: <1414591597-2763-5-git-send-email-acme@kernel.org>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1414591597-2763-1-git-send-email-acme@kernel.org>
References: <1414591597-2763-1-git-send-email-acme@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnaldo Carvalho de Melo <acme@redhat.com>

Shortening function signature lenght too, since a thread's machine can be
obtained from thread->mg->machine, no need to pass thread, machine.

Cc: Adrian Hunter <adrian.hunter@intel.com>
Cc: Borislav Petkov <bp@suse.de>
Cc: David Ahern <dsahern@gmail.com>
Cc: Don Zickus <dzickus@redhat.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Jean Pihet <jean.pihet@linaro.org>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/n/tip-5wb6css280ty0cel5p0zo2b1@git.kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/callchain.c                            |  4 ++--
 tools/perf/util/machine.c                              | 15 +++++++--------
 tools/perf/util/machine.h                              | 13 ++++++-------
 tools/perf/util/scripting-engines/trace-event-python.c |  6 +++---
 tools/perf/util/session.c                              |  6 +++---
 5 files changed, 21 insertions(+), 23 deletions(-)

diff --git a/tools/perf/util/callchain.c b/tools/perf/util/callchain.c
index c84d3f8dcb75..00229809a904 100644
--- a/tools/perf/util/callchain.c
+++ b/tools/perf/util/callchain.c
@@ -754,8 +754,8 @@ int sample__resolve_callchain(struct perf_sample *sample, struct symbol **parent
 
 	if (symbol_conf.use_callchain || symbol_conf.cumulate_callchain ||
 	    sort__has_parent) {
-		return machine__resolve_callchain(al->machine, evsel, al->thread,
-						  sample, parent, al, max_stack);
+		return thread__resolve_callchain(al->thread, evsel, sample,
+						 parent, al, max_stack);
 	}
 	return 0;
 }
diff --git a/tools/perf/util/machine.c b/tools/perf/util/machine.c
index 08e63fdbd14f..fd192e4885cc 100644
--- a/tools/perf/util/machine.c
+++ b/tools/perf/util/machine.c
@@ -1464,13 +1464,12 @@ static int unwind_entry(struct unwind_entry *entry, void *arg)
 				       entry->map, entry->sym);
 }
 
-int machine__resolve_callchain(struct machine *machine,
-			       struct perf_evsel *evsel,
-			       struct thread *thread,
-			       struct perf_sample *sample,
-			       struct symbol **parent,
-			       struct addr_location *root_al,
-			       int max_stack)
+int thread__resolve_callchain(struct thread *thread,
+			      struct perf_evsel *evsel,
+			      struct perf_sample *sample,
+			      struct symbol **parent,
+			      struct addr_location *root_al,
+			      int max_stack)
 {
 	int ret = thread__resolve_callchain_sample(thread, sample->callchain,
 						   parent, root_al, max_stack);
@@ -1487,7 +1486,7 @@ int machine__resolve_callchain(struct machine *machine,
 	    (!sample->user_stack.size))
 		return 0;
 
-	return unwind__get_entries(unwind_entry, &callchain_cursor, machine,
+	return unwind__get_entries(unwind_entry, &callchain_cursor, thread->mg->machine,
 				   thread, sample, max_stack);
 
 }
diff --git a/tools/perf/util/machine.h b/tools/perf/util/machine.h
index 2b651a7f5d0d..88ec74e18cbf 100644
--- a/tools/perf/util/machine.h
+++ b/tools/perf/util/machine.h
@@ -122,13 +122,12 @@ struct branch_info *sample__resolve_bstack(struct perf_sample *sample,
 					   struct addr_location *al);
 struct mem_info *sample__resolve_mem(struct perf_sample *sample,
 				     struct addr_location *al);
-int machine__resolve_callchain(struct machine *machine,
-			       struct perf_evsel *evsel,
-			       struct thread *thread,
-			       struct perf_sample *sample,
-			       struct symbol **parent,
-			       struct addr_location *root_al,
-			       int max_stack);
+int thread__resolve_callchain(struct thread *thread,
+			      struct perf_evsel *evsel,
+			      struct perf_sample *sample,
+			      struct symbol **parent,
+			      struct addr_location *root_al,
+			      int max_stack);
 
 /*
  * Default guest kernel is defined by parameter --guestkallsyms
diff --git a/tools/perf/util/scripting-engines/trace-event-python.c b/tools/perf/util/scripting-engines/trace-event-python.c
index 496f21cadd97..25e5a238f1cb 100644
--- a/tools/perf/util/scripting-engines/trace-event-python.c
+++ b/tools/perf/util/scripting-engines/trace-event-python.c
@@ -312,9 +312,9 @@ static PyObject *python_process_callchain(struct perf_sample *sample,
 	if (!symbol_conf.use_callchain || !sample->callchain)
 		goto exit;
 
-	if (machine__resolve_callchain(al->machine, evsel, al->thread,
-					   sample, NULL, NULL,
-					   PERF_MAX_STACK_DEPTH) != 0) {
+	if (thread__resolve_callchain(al->thread, evsel,
+				      sample, NULL, NULL,
+				      PERF_MAX_STACK_DEPTH) != 0) {
 		pr_err("Failed to resolve callchain. Skipping\n");
 		goto exit;
 	}
diff --git a/tools/perf/util/session.c b/tools/perf/util/session.c
index 6702ac28754b..776010844cdc 100644
--- a/tools/perf/util/session.c
+++ b/tools/perf/util/session.c
@@ -1417,9 +1417,9 @@ void perf_evsel__print_ip(struct perf_evsel *evsel, struct perf_sample *sample,
 	if (symbol_conf.use_callchain && sample->callchain) {
 		struct addr_location node_al;
 
-		if (machine__resolve_callchain(al->machine, evsel, al->thread,
-					       sample, NULL, NULL,
-					       PERF_MAX_STACK_DEPTH) != 0) {
+		if (thread__resolve_callchain(al->thread, evsel,
+					      sample, NULL, NULL,
+					      PERF_MAX_STACK_DEPTH) != 0) {
 			if (verbose)
 				error("Failed to resolve callchain. Skipping\n");
 			return;
-- 
1.9.3

