Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932295Ab3KLV4N (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Nov 2013 16:56:13 -0500
Received: from terminus.zytor.com ([198.137.202.10]:40118 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932207Ab3KLVzw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Nov 2013 16:55:52 -0500
Date: Tue, 12 Nov 2013 13:55:12 -0800
From: tip-bot for Arnaldo Carvalho de Melo <tipbot@zytor.com>
Message-ID: <tip-pusqibp8n3c4ynegd1frn4zd@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, eranian@google.com, paulus@samba.org,
        acme@redhat.com, hpa@zytor.com, mingo@kernel.org, peterz@infradead.org,
        efault@gmx.de, jolsa@redhat.com, fweisbec@gmail.com,
        adrian.hunter@intel.com, dsahern@gmail.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, acme@redhat.com, paulus@samba.org,
        eranian@google.com, linux-kernel@vger.kernel.org, efault@gmx.de,
        peterz@infradead.org, jolsa@redhat.com, fweisbec@gmail.com,
        dsahern@gmail.com, adrian.hunter@intel.com, tglx@linutronix.de
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/urgent] perf machine:
  Simplify synthesize_threads method
Git-Commit-ID: a33fbd56ec83b5421090b4d8f2032f635e6a9488
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.1 (terminus.zytor.com [127.0.0.1]); Tue, 12 Nov 2013 13:55:18 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  a33fbd56ec83b5421090b4d8f2032f635e6a9488
Gitweb:     http://git.kernel.org/tip/a33fbd56ec83b5421090b4d8f2032f635e6a9488
Author:     Arnaldo Carvalho de Melo <acme@redhat.com>
AuthorDate: Mon, 11 Nov 2013 11:36:12 -0300
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Mon, 11 Nov 2013 15:56:40 -0300

perf machine: Simplify synthesize_threads method

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
index f5d2c4b..346bb59 100644
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
index 41d1f37..fc68b26 100644
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
index c3a936e..8c520d9 100644
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
index 7690324..c3008b1 100644
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
index 9f2c61d..680700b6 100644
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
index 14a89d2..fedd1df 100644
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
