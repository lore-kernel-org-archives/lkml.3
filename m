Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753058Ab3KKUZD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Nov 2013 15:25:03 -0500
Received: from merlin.infradead.org ([205.233.59.134]:43963 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751412Ab3KKUWy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Nov 2013 15:22:54 -0500
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>
Subject: [PATCH 05/10] perf machine: Simplify synthesize_threads method
Date: Mon, 11 Nov 2013 17:22:28 -0300
Message-Id: <1384201353-23863-6-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1384201353-23863-1-git-send-email-acme@infradead.org>
References: <1384201353-23863-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by merlin.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnaldo Carvalho de Melo <acme@redhat.com>

Several tools (top, kvm) don't need to be called back to process each of
the syntheiszed records, instead relying on the machine__process_event
function to change the per machine data structures that represent
threads and mmaps, so provide a way to ask for this common idiom.

Cc: Adrian Hunter <adrian.hunter@intel.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/n/tip-pusqibp8n3c4ynegd1frn4zd@git.kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/builtin-kvm.c    |  5 ++---
 tools/perf/builtin-record.c |  4 ++--
 tools/perf/builtin-top.c    |  5 ++---
 tools/perf/builtin-trace.c  |  4 ++--
 tools/perf/util/machine.c   |  6 +++---
 tools/perf/util/machine.h   | 14 +++++++++++---
 6 files changed, 22 insertions(+), 16 deletions(-)

diff --git a/tools/perf/builtin-kvm.c b/tools/perf/builtin-kvm.c
index f5d2c4bccbec..346bb5909e3d 100644
--- a/tools/perf/builtin-kvm.c
+++ b/tools/perf/builtin-kvm.c
@@ -1544,9 +1544,8 @@ static int kvm_events_live(struct perf_kvm_stat *kvm,
 	}
 	kvm->session->evlist = kvm->evlist;
 	perf_session__set_id_hdr_size(kvm->session);
-	machine__synthesize_threads(&kvm->session->machines.host, &kvm->tool,
-				    &kvm->opts.target, kvm->evlist->threads,
-				    perf_event__process, false);
+	machine__synthesize_threads(&kvm->session->machines.host, &kvm->opts.target,
+				    kvm->evlist->threads, false);
 	err = kvm_live_open_events(kvm);
 	if (err)
 		goto out;
diff --git a/tools/perf/builtin-record.c b/tools/perf/builtin-record.c
index 41d1f37f5348..fc68b26d58f9 100644
--- a/tools/perf/builtin-record.c
+++ b/tools/perf/builtin-record.c
@@ -480,8 +480,8 @@ static int __cmd_record(struct perf_record *rec, int argc, const char **argv)
 					 perf_event__synthesize_guest_os, tool);
 	}
 
-	err = machine__synthesize_threads(machine, tool, &opts->target, evsel_list->threads,
-					  process_synthesized_event, opts->sample_address);
+	err = __machine__synthesize_threads(machine, tool, &opts->target, evsel_list->threads,
+					    process_synthesized_event, opts->sample_address);
 	if (err != 0)
 		goto out_delete_session;
 
diff --git a/tools/perf/builtin-top.c b/tools/perf/builtin-top.c
index c3a936ef7688..8c520d9fecfc 100644
--- a/tools/perf/builtin-top.c
+++ b/tools/perf/builtin-top.c
@@ -950,9 +950,8 @@ static int __cmd_top(struct perf_top *top)
 	if (ret)
 		goto out_delete;
 
-	machine__synthesize_threads(&top->session->machines.host, &top->tool,
-				    &opts->target, top->evlist->threads,
-				    perf_event__process, false);
+	machine__synthesize_threads(&top->session->machines.host, &opts->target,
+				    top->evlist->threads, false);
 	ret = perf_top__start_counters(top);
 	if (ret)
 		goto out_delete;
diff --git a/tools/perf/builtin-trace.c b/tools/perf/builtin-trace.c
index 7690324824db..c3008b1c369c 100644
--- a/tools/perf/builtin-trace.c
+++ b/tools/perf/builtin-trace.c
@@ -1340,8 +1340,8 @@ static int trace__symbols_init(struct trace *trace, struct perf_evlist *evlist)
 	if (trace->host == NULL)
 		return -ENOMEM;
 
-	err = machine__synthesize_threads(trace->host, &trace->tool, &trace->opts.target,
-					  evlist->threads, trace__tool_process, false);
+	err = __machine__synthesize_threads(trace->host, &trace->tool, &trace->opts.target,
+					    evlist->threads, trace__tool_process, false);
 	if (err)
 		symbol__exit();
 
diff --git a/tools/perf/util/machine.c b/tools/perf/util/machine.c
index 9f2c61d5a9ed..680700b6d779 100644
--- a/tools/perf/util/machine.c
+++ b/tools/perf/util/machine.c
@@ -1395,9 +1395,9 @@ int machine__for_each_thread(struct machine *machine,
 	return rc;
 }
 
-int machine__synthesize_threads(struct machine *machine, struct perf_tool *tool,
-				struct perf_target *target, struct thread_map *threads,
-				perf_event__handler_t process, bool data_mmap)
+int __machine__synthesize_threads(struct machine *machine, struct perf_tool *tool,
+				  struct perf_target *target, struct thread_map *threads,
+				  perf_event__handler_t process, bool data_mmap)
 {
 	if (perf_target__has_task(target))
 		return perf_event__synthesize_thread_map(tool, threads, process, machine, data_mmap);
diff --git a/tools/perf/util/machine.h b/tools/perf/util/machine.h
index 14a89d2aecaf..fedd1dfaf715 100644
--- a/tools/perf/util/machine.h
+++ b/tools/perf/util/machine.h
@@ -179,7 +179,15 @@ int machine__for_each_thread(struct machine *machine,
 			     int (*fn)(struct thread *thread, void *p),
 			     void *priv);
 
-int machine__synthesize_threads(struct machine *machine, struct perf_tool *tool,
-				struct perf_target *target, struct thread_map *threads,
-				perf_event__handler_t process, bool data_mmap);
+int __machine__synthesize_threads(struct machine *machine, struct perf_tool *tool,
+				  struct perf_target *target, struct thread_map *threads,
+				  perf_event__handler_t process, bool data_mmap);
+static inline
+int machine__synthesize_threads(struct machine *machine, struct perf_target *target,
+				struct thread_map *threads, bool data_mmap)
+{
+	return __machine__synthesize_threads(machine, NULL, target, threads,
+					     perf_event__process, data_mmap);
+}
+
 #endif /* __PERF_MACHINE_H */
-- 
1.8.1.4

