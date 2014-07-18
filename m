Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934222AbaGREYm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2014 00:24:42 -0400
Received: from terminus.zytor.com ([198.137.202.10]:33107 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934090AbaGREYk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2014 00:24:40 -0400
Date: Thu, 17 Jul 2014 21:23:28 -0700
From: tip-bot for Adrian Hunter <tipbot@zytor.com>
Message-ID: <tip-022c50d09c2c2bc31506ad16c4bcba7fb418ce34@git.kernel.org>
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
In-Reply-To: <1405332185-4050-4-git-send-email-adrian.hunter@intel.com>
References: <1405332185-4050-4-git-send-email-adrian.hunter@intel.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf script:
  Display PERF_RECORD_MISC_COMM_EXEC flag
Git-Commit-ID: 022c50d09c2c2bc31506ad16c4bcba7fb418ce34
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

Commit-ID:  022c50d09c2c2bc31506ad16c4bcba7fb418ce34
Gitweb:     http://git.kernel.org/tip/022c50d09c2c2bc31506ad16c4bcba7fb418ce34
Author:     Adrian Hunter <adrian.hunter@intel.com>
AuthorDate: Mon, 14 Jul 2014 13:02:27 +0300
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Wed, 16 Jul 2014 17:57:34 -0300

perf script: Display PERF_RECORD_MISC_COMM_EXEC flag

Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Namhyung Kim <namhyung@gmail.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/r/1405332185-4050-4-git-send-email-adrian.hunter@intel.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/event.c | 9 ++++++++-
 tools/perf/util/evsel.c | 3 ++-
 2 files changed, 10 insertions(+), 2 deletions(-)

diff --git a/tools/perf/util/event.c b/tools/perf/util/event.c
index d0281bd..198c4cc 100644
--- a/tools/perf/util/event.c
+++ b/tools/perf/util/event.c
@@ -603,7 +603,14 @@ int perf_event__synthesize_kernel_mmap(struct perf_tool *tool,
 
 size_t perf_event__fprintf_comm(union perf_event *event, FILE *fp)
 {
-	return fprintf(fp, ": %s:%d\n", event->comm.comm, event->comm.tid);
+	const char *s;
+
+	if (event->header.misc & PERF_RECORD_MISC_COMM_EXEC)
+		s = " exec";
+	else
+		s = "";
+
+	return fprintf(fp, "%s: %s:%d\n", s, event->comm.comm, event->comm.tid);
 }
 
 int perf_event__process_comm(struct perf_tool *tool __maybe_unused,
diff --git a/tools/perf/util/evsel.c b/tools/perf/util/evsel.c
index 8606175..b760d32 100644
--- a/tools/perf/util/evsel.c
+++ b/tools/perf/util/evsel.c
@@ -960,6 +960,7 @@ static size_t perf_event_attr__fprintf(struct perf_event_attr *attr, FILE *fp)
 	ret += PRINT_ATTR2(exclude_user, exclude_kernel);
 	ret += PRINT_ATTR2(exclude_hv, exclude_idle);
 	ret += PRINT_ATTR2(mmap, comm);
+	ret += PRINT_ATTR2(mmap2, comm_exec);
 	ret += PRINT_ATTR2(freq, inherit_stat);
 	ret += PRINT_ATTR2(enable_on_exec, task);
 	ret += PRINT_ATTR2(watermark, precise_ip);
@@ -967,7 +968,6 @@ static size_t perf_event_attr__fprintf(struct perf_event_attr *attr, FILE *fp)
 	ret += PRINT_ATTR2(exclude_host, exclude_guest);
 	ret += PRINT_ATTR2N("excl.callchain_kern", exclude_callchain_kernel,
 			    "excl.callchain_user", exclude_callchain_user);
-	ret += PRINT_ATTR_U32(mmap2);
 
 	ret += PRINT_ATTR_U32(wakeup_events);
 	ret += PRINT_ATTR_U32(wakeup_watermark);
@@ -1940,6 +1940,7 @@ int perf_evsel__fprintf(struct perf_evsel *evsel,
 		if_print(mmap);
 		if_print(mmap2);
 		if_print(comm);
+		if_print(comm_exec);
 		if_print(freq);
 		if_print(inherit_stat);
 		if_print(enable_on_exec);
