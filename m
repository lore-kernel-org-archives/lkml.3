Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758618Ab3JOFW7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Oct 2013 01:22:59 -0400
Received: from terminus.zytor.com ([198.137.202.10]:32842 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757767Ab3JOFWz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Oct 2013 01:22:55 -0400
Date: Mon, 14 Oct 2013 22:21:50 -0700
From: tip-bot for David Ahern <tipbot@zytor.com>
Message-ID: <tip-4bb09192d38ef08f0619667527cabb26354fff89@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, eranian@google.com,
        paulus@samba.org, hpa@zytor.com, mingo@kernel.org,
        peterz@infradead.org, efault@gmx.de, jolsa@redhat.com,
        fweisbec@gmail.com, dsahern@gmail.com, adrian.hunter@intel.com,
        tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, paulus@samba.org,
        eranian@google.com, linux-kernel@vger.kernel.org, acme@redhat.com,
        efault@gmx.de, peterz@infradead.org, jolsa@redhat.com,
        fweisbec@gmail.com, adrian.hunter@intel.com, dsahern@gmail.com,
        tglx@linutronix.de
In-Reply-To: <1378319865-55695-1-git-send-email-dsahern@gmail.com>
References: <1378319865-55695-1-git-send-email-dsahern@gmail.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf trace: Add option to show full timestamp
Git-Commit-ID: 4bb09192d38ef08f0619667527cabb26354fff89
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.1 (terminus.zytor.com [127.0.0.1]); Mon, 14 Oct 2013 22:21:56 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  4bb09192d38ef08f0619667527cabb26354fff89
Gitweb:     http://git.kernel.org/tip/4bb09192d38ef08f0619667527cabb26354fff89
Author:     David Ahern <dsahern@gmail.com>
AuthorDate: Wed, 4 Sep 2013 12:37:43 -0600
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Wed, 9 Oct 2013 11:10:49 -0300

perf trace: Add option to show full timestamp

Current timestamp shown for output is time relative to firt sample. This
patch adds an option to show the absolute perf_clock timestamp which is
useful when comparing output across commands (e.g., perf-trace to
perf-script).

Signed-off-by: David Ahern <dsahern@gmail.com>
Cc: Adrian Hunter <adrian.hunter@intel.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/r/1378319865-55695-1-git-send-email-dsahern@gmail.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/Documentation/perf-trace.txt | 4 ++++
 tools/perf/builtin-trace.c              | 7 +++++--
 2 files changed, 9 insertions(+), 2 deletions(-)

diff --git a/tools/perf/Documentation/perf-trace.txt b/tools/perf/Documentation/perf-trace.txt
index daccd2c..a93e91a 100644
--- a/tools/perf/Documentation/perf-trace.txt
+++ b/tools/perf/Documentation/perf-trace.txt
@@ -78,6 +78,10 @@ the thread executes on the designated CPUs. Default is to monitor all CPUs.
 --input
 	Process events from a given perf data file.
 
+-T
+--time
+	Print full timestamp rather time relative to first sample.
+
 SEE ALSO
 --------
 linkperf:perf-record[1], linkperf:perf-script[1]
diff --git a/tools/perf/builtin-trace.c b/tools/perf/builtin-trace.c
index 7ce036e..bc21140 100644
--- a/tools/perf/builtin-trace.c
+++ b/tools/perf/builtin-trace.c
@@ -624,6 +624,7 @@ struct trace {
 	struct perf_record_opts opts;
 	struct machine		host;
 	u64			base_time;
+	bool			full_time;
 	FILE			*output;
 	unsigned long		nr_events;
 	struct strlist		*ev_qualifier;
@@ -1066,7 +1067,7 @@ static int trace__process_sample(struct perf_tool *tool,
 	if (skip_sample(trace, sample))
 		return 0;
 
-	if (trace->base_time == 0)
+	if (!trace->full_time && trace->base_time == 0)
 		trace->base_time = sample->time;
 
 	if (handler)
@@ -1195,7 +1196,7 @@ again:
 				continue;
 			}
 
-			if (trace->base_time == 0)
+			if (!trace->full_time && trace->base_time == 0)
 				trace->base_time = sample.time;
 
 			if (type != PERF_RECORD_SAMPLE) {
@@ -1433,6 +1434,8 @@ int cmd_trace(int argc, const char **argv, const char *prefix __maybe_unused)
 		     trace__set_duration),
 	OPT_BOOLEAN(0, "sched", &trace.sched, "show blocking scheduler events"),
 	OPT_INCR('v', "verbose", &verbose, "be more verbose"),
+	OPT_BOOLEAN('T', "time", &trace.full_time,
+		    "Show full timestamp, not time relative to first start"),
 	OPT_END()
 	};
 	int err;
