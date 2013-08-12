Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756820Ab3HLKZn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Aug 2013 06:25:43 -0400
Received: from terminus.zytor.com ([198.137.202.10]:48163 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756776Ab3HLKYI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Aug 2013 06:24:08 -0400
Date: Mon, 12 Aug 2013 03:23:32 -0700
From: tip-bot for David Ahern <tipbot@zytor.com>
Message-ID: <tip-2e73f00fe707a8f2476d989de946c12078c7c066@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, hpa@zytor.com,
        mingo@kernel.org, peterz@infradead.org, namhyung@kernel.org,
        runzhen@linux.vnet.ibm.com, jolsa@redhat.com, fweisbec@gmail.com,
        xiaoguangrong@linux.vnet.ibm.com, dsahern@gmail.com,
        tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        acme@redhat.com, peterz@infradead.org, namhyung@kernel.org,
        jolsa@redhat.com, runzhen@linux.vnet.ibm.com, fweisbec@gmail.com,
        xiaoguangrong@linux.vnet.ibm.com, dsahern@gmail.com,
        tglx@linutronix.de
In-Reply-To: <1375753297-69645-6-git-send-email-dsahern@gmail.com>
References: <1375753297-69645-6-git-send-email-dsahern@gmail.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf kvm stat report:
  Add option to analyze specific VM
Git-Commit-ID: 2e73f00fe707a8f2476d989de946c12078c7c066
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Mon, 12 Aug 2013 03:23:39 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  2e73f00fe707a8f2476d989de946c12078c7c066
Gitweb:     http://git.kernel.org/tip/2e73f00fe707a8f2476d989de946c12078c7c066
Author:     David Ahern <dsahern@gmail.com>
AuthorDate: Mon, 5 Aug 2013 21:41:37 -0400
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Wed, 7 Aug 2013 17:35:39 -0300

perf kvm stat report: Add option to analyze specific VM

Add an option to analyze a specific VM within a data file. This allows
the collection of kvm events for all VMs and then analyze data for each
VM (or set of VMs) individually.

Signed-off-by: David Ahern <dsahern@gmail.com>
Reviewed-by: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Runzhen Wang <runzhen@linux.vnet.ibm.com>
Cc: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
Link: http://lkml.kernel.org/r/1375753297-69645-6-git-send-email-dsahern@gmail.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/builtin-kvm.c | 38 ++++++++++++++++++++++++++++++++++++--
 1 file changed, 36 insertions(+), 2 deletions(-)

diff --git a/tools/perf/builtin-kvm.c b/tools/perf/builtin-kvm.c
index b6595e9..2ceec81 100644
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
@@ -107,6 +107,9 @@ struct perf_kvm_stat {
 	u64 total_count;
 	u64 lost_events;
 
+	const char *pid_str;
+	struct intlist *pid_list;
+
 	struct rb_root result;
 
 	int timerfd;
@@ -777,16 +780,29 @@ static int process_lost_event(struct perf_tool *tool,
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
@@ -1209,11 +1225,27 @@ static int read_events(struct perf_kvm_stat *kvm)
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
 
@@ -1300,6 +1332,8 @@ kvm_events_report(struct perf_kvm_stat *kvm, int argc, const char **argv)
 		OPT_STRING('k', "key", &kvm->sort_key, "sort-key",
 			    "key for sorting: sample(sort by samples number)"
 			    " time (sort by avg time)"),
+		OPT_STRING('p', "pid", &kvm->pid_str, "pid",
+			   "analyze events only for given process id(s)"),
 		OPT_END()
 	};
 
