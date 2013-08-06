Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753444Ab3HFBm0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Aug 2013 21:42:26 -0400
Received: from mail-pa0-f47.google.com ([209.85.220.47]:54537 "EHLO
	mail-pa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752948Ab3HFBl6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Aug 2013 21:41:58 -0400
From: David Ahern <dsahern@gmail.com>
To: acme@ghostprotocols.net, linux-kernel@vger.kernel.org
Cc: xiaoguangrong@linux.vnet.ibm.com, David Ahern <dsahern@gmail.com>,
        Ingo Molnar <mingo@kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Peter Zijlstra <peterz@infradead.org>, Jiri Olsa <jolsa@redhat.com>,
        Namhyung Kim <namhyung@kernel.org>,
        Runzhen Wang <runzhen@linux.vnet.ibm.com>
Subject: [PATCH 5/5] perf kvm stat report: Add option to analyze specific VM
Date: Mon,  5 Aug 2013 21:41:37 -0400
Message-Id: <1375753297-69645-6-git-send-email-dsahern@gmail.com>
X-Mailer: git-send-email 1.7.10.1
In-Reply-To: <1375753297-69645-1-git-send-email-dsahern@gmail.com>
References: <1375753297-69645-1-git-send-email-dsahern@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add an option to analyze a specific VM within a data file. This
allows the collection of kvm events for all VMs and then analyze
data for each VM (or set of VMs) individually.

Signed-off-by: David Ahern <dsahern@gmail.com>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
Cc: Runzhen Wang <runzhen@linux.vnet.ibm.com>
---
 tools/perf/builtin-kvm.c |   38 ++++++++++++++++++++++++++++++++++++--
 1 file changed, 36 insertions(+), 2 deletions(-)

diff --git a/tools/perf/builtin-kvm.c b/tools/perf/builtin-kvm.c
index 5edbd3b..16a672f 100644
--- a/tools/perf/builtin-kvm.c
+++ b/tools/perf/builtin-kvm.c
@@ -9,7 +9,7 @@
 #include "util/thread.h"
 #include "util/header.h"
 #include "util/session.h"
-
+#include "util/intlist.h"
 #include "util/parse-options.h"
 #include "util/trace-event.h"
 #include "util/debug.h"
@@ -108,6 +108,9 @@ struct perf_kvm_stat {
 	u64 lost_events;
 	u64 threshold;
 
+	const char *pid_str;
+	struct intlist *pid_list;
+
 	struct rb_root result;
 
 	int timerfd;
@@ -790,16 +793,29 @@ static int process_lost_event(struct perf_tool *tool,
 	return 0;
 }
 
+static bool skip_sample(struct perf_kvm_stat *kvm,
+			struct perf_sample *sample)
+{
+	if (kvm->pid_list && intlist__find(kvm->pid_list, sample->pid) == NULL)
+		return true;
+
+	return false;
+}
+
 static int process_sample_event(struct perf_tool *tool,
 				union perf_event *event,
 				struct perf_sample *sample,
 				struct perf_evsel *evsel,
 				struct machine *machine)
 {
-	struct thread *thread = machine__findnew_thread(machine, sample->tid);
+	struct thread *thread;
 	struct perf_kvm_stat *kvm = container_of(tool, struct perf_kvm_stat,
 						 tool);
 
+	if (skip_sample(kvm, sample))
+		return 0;
+
+	thread = machine__findnew_thread(machine, sample->tid);
 	if (thread == NULL) {
 		pr_debug("problem processing %d event, skipping it.\n",
 			event->header.type);
@@ -1222,11 +1238,27 @@ static int read_events(struct perf_kvm_stat *kvm)
 	return perf_session__process_events(kvm->session, &kvm->tool);
 }
 
+static int parse_target_str(struct perf_kvm_stat *kvm)
+{
+	if (kvm->pid_str) {
+		kvm->pid_list = intlist__new(kvm->pid_str);
+		if (kvm->pid_list == NULL) {
+			pr_err("Error parsing process id string\n");
+			return -EINVAL;
+		}
+	}
+
+	return 0;
+}
+
 static int kvm_events_report_vcpu(struct perf_kvm_stat *kvm)
 {
 	int ret = -EINVAL;
 	int vcpu = kvm->trace_vcpu;
 
+	if (parse_target_str(kvm) != 0)
+		goto exit;
+
 	if (!verify_vcpu(vcpu))
 		goto exit;
 
@@ -1313,6 +1345,8 @@ kvm_events_report(struct perf_kvm_stat *kvm, int argc, const char **argv)
 		OPT_STRING('k', "key", &kvm->sort_key, "sort-key",
 			    "key for sorting: sample(sort by samples number)"
 			    " time (sort by avg time)"),
+		OPT_STRING('p', "pid", &kvm->pid_str, "pid",
+			   "analyze events only for given process id(s)"),
 		OPT_END()
 	};
 
-- 
1.7.10.1

