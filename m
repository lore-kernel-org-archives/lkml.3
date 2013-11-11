Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751595Ab3KKUW7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Nov 2013 15:22:59 -0500
Received: from merlin.infradead.org ([205.233.59.134]:43942 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750991Ab3KKUWu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Nov 2013 15:22:50 -0500
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>
Subject: [PATCH 04/10] perf machine: Introduce synthesize_threads method out of open coded equivalent
Date: Mon, 11 Nov 2013 17:22:27 -0300
Message-Id: <1384201353-23863-5-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1384201353-23863-1-git-send-email-acme@infradead.org>
References: <1384201353-23863-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by merlin.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnaldo Carvalho de Melo <acme@redhat.com>

Further simplifications to be done on following patch, as most tools
don't use the callback, using instead just the canned
machine__process_event one.

Cc: Adrian Hunter <adrian.hunter@intel.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/n/tip-r1m0vuuj3cat4bampno9yc8d@git.kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/builtin-kvm.c    | 15 +++------------
 tools/perf/builtin-record.c | 12 ++----------
 tools/perf/builtin-top.c    | 11 +++--------
 tools/perf/builtin-trace.c  | 11 ++---------
 tools/perf/util/machine.c   | 12 ++++++++++++
 tools/perf/util/machine.h   |  4 ++++
 6 files changed, 26 insertions(+), 39 deletions(-)

diff --git a/tools/perf/builtin-kvm.c b/tools/perf/builtin-kvm.c
index f36e8209c300..f5d2c4bccbec 100644
--- a/tools/perf/builtin-kvm.c
+++ b/tools/perf/builtin-kvm.c
@@ -1544,18 +1544,9 @@ static int kvm_events_live(struct perf_kvm_stat *kvm,
 	}
 	kvm->session->evlist = kvm->evlist;
 	perf_session__set_id_hdr_size(kvm->session);
-
-
-	if (perf_target__has_task(&kvm->opts.target))
-		perf_event__synthesize_thread_map(&kvm->tool,
-						  kvm->evlist->threads,
-						  perf_event__process,
-						  &kvm->session->machines.host, false);
-	else
-		perf_event__synthesize_threads(&kvm->tool, perf_event__process,
-					       &kvm->session->machines.host, false);
-
-
+	machine__synthesize_threads(&kvm->session->machines.host, &kvm->tool,
+				    &kvm->opts.target, kvm->evlist->threads,
+				    perf_event__process, false);
 	err = kvm_live_open_events(kvm);
 	if (err)
 		goto out;
diff --git a/tools/perf/builtin-record.c b/tools/perf/builtin-record.c
index afb252cf6eca..41d1f37f5348 100644
--- a/tools/perf/builtin-record.c
+++ b/tools/perf/builtin-record.c
@@ -480,16 +480,8 @@ static int __cmd_record(struct perf_record *rec, int argc, const char **argv)
 					 perf_event__synthesize_guest_os, tool);
 	}
 
-	if (perf_target__has_task(&opts->target))
-		err = perf_event__synthesize_thread_map(tool, evsel_list->threads,
-							process_synthesized_event,
-							machine, opts->sample_address);
-	else if (perf_target__has_cpu(&opts->target))
-		err = perf_event__synthesize_threads(tool, process_synthesized_event,
-						     machine, opts->sample_address);
-	else /* command specified */
-		err = 0;
-
+	err = machine__synthesize_threads(machine, tool, &opts->target, evsel_list->threads,
+					  process_synthesized_event, opts->sample_address);
 	if (err != 0)
 		goto out_delete_session;
 
diff --git a/tools/perf/builtin-top.c b/tools/perf/builtin-top.c
index cc96d753db96..c3a936ef7688 100644
--- a/tools/perf/builtin-top.c
+++ b/tools/perf/builtin-top.c
@@ -950,14 +950,9 @@ static int __cmd_top(struct perf_top *top)
 	if (ret)
 		goto out_delete;
 
-	if (perf_target__has_task(&opts->target))
-		perf_event__synthesize_thread_map(&top->tool, top->evlist->threads,
-						  perf_event__process,
-						  &top->session->machines.host, false);
-	else
-		perf_event__synthesize_threads(&top->tool, perf_event__process,
-					       &top->session->machines.host, false);
-
+	machine__synthesize_threads(&top->session->machines.host, &top->tool,
+				    &opts->target, top->evlist->threads,
+				    perf_event__process, false);
 	ret = perf_top__start_counters(top);
 	if (ret)
 		goto out_delete;
diff --git a/tools/perf/builtin-trace.c b/tools/perf/builtin-trace.c
index 277c2367e0cf..7690324824db 100644
--- a/tools/perf/builtin-trace.c
+++ b/tools/perf/builtin-trace.c
@@ -1340,15 +1340,8 @@ static int trace__symbols_init(struct trace *trace, struct perf_evlist *evlist)
 	if (trace->host == NULL)
 		return -ENOMEM;
 
-	if (perf_target__has_task(&trace->opts.target)) {
-		err = perf_event__synthesize_thread_map(&trace->tool, evlist->threads,
-							trace__tool_process,
-							trace->host, false);
-	} else {
-		err = perf_event__synthesize_threads(&trace->tool, trace__tool_process,
-						     trace->host, false);
-	}
-
+	err = machine__synthesize_threads(trace->host, &trace->tool, &trace->opts.target,
+					  evlist->threads, trace__tool_process, false);
 	if (err)
 		symbol__exit();
 
diff --git a/tools/perf/util/machine.c b/tools/perf/util/machine.c
index ce034c183a7e..9f2c61d5a9ed 100644
--- a/tools/perf/util/machine.c
+++ b/tools/perf/util/machine.c
@@ -1394,3 +1394,15 @@ int machine__for_each_thread(struct machine *machine,
 	}
 	return rc;
 }
+
+int machine__synthesize_threads(struct machine *machine, struct perf_tool *tool,
+				struct perf_target *target, struct thread_map *threads,
+				perf_event__handler_t process, bool data_mmap)
+{
+	if (perf_target__has_task(target))
+		return perf_event__synthesize_thread_map(tool, threads, process, machine, data_mmap);
+	else if (perf_target__has_cpu(target))
+		return perf_event__synthesize_threads(tool, process, machine, data_mmap);
+	/* command specified */
+	return 0;
+}
diff --git a/tools/perf/util/machine.h b/tools/perf/util/machine.h
index 2389ba81fafe..14a89d2aecaf 100644
--- a/tools/perf/util/machine.h
+++ b/tools/perf/util/machine.h
@@ -4,6 +4,7 @@
 #include <sys/types.h>
 #include <linux/rbtree.h>
 #include "map.h"
+#include "event.h"
 
 struct addr_location;
 struct branch_stack;
@@ -178,4 +179,7 @@ int machine__for_each_thread(struct machine *machine,
 			     int (*fn)(struct thread *thread, void *p),
 			     void *priv);
 
+int machine__synthesize_threads(struct machine *machine, struct perf_tool *tool,
+				struct perf_target *target, struct thread_map *threads,
+				perf_event__handler_t process, bool data_mmap);
 #endif /* __PERF_MACHINE_H */
-- 
1.8.1.4

