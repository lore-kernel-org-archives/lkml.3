Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753169Ab3LBGxq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Dec 2013 01:53:46 -0500
Received: from LGEMRELSE1Q.lge.com ([156.147.1.111]:59500 "EHLO
	LGEMRELSE1Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753001Ab3LBGxW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Dec 2013 01:53:22 -0500
X-AuditID: 9c93016f-b7ce9ae000002b4b-c8-529c2e614617
From: Namhyung Kim <namhyung@kernel.org>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@kernel.org>, Namhyung Kim <namhyung.kim@lge.com>,
        LKML <linux-kernel@vger.kernel.org>, Jiri Olsa <jolsa@redhat.com>,
        David Ahern <dsahern@gmail.com>, Stephane Eranian <eranian@google.com>,
        Andi Kleen <andi@firstfloor.org>, Pekka Enberg <penberg@kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>
Subject: [PATCH 1/3] perf tools: Record total sampling time
Date: Mon,  2 Dec 2013 15:53:17 +0900
Message-Id: <1385967199-3759-2-git-send-email-namhyung@kernel.org>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1385967199-3759-1-git-send-email-namhyung@kernel.org>
References: <1385967199-3759-1-git-send-email-namhyung@kernel.org>
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Namhyung Kim <namhyung.kim@lge.com>

It's sometimes useful to see total sampling or elapsed time with
normal performance result.  To do that, record first and last sample
time for each evsel and to display it in the header (--stdio only for
now).

  $ perf record -a sleep 1
  $ perf report --stdio
  ...
  # Samples: 4K of event 'cycles'
  # Event count (approx.): 4087481688
  # Total sampling time  : 1.001260 (sec)
  #
  # Overhead       Command               Shared Object                   Symbol
  # ........  ............  ..........................  .......................
  #
      89.06%      nautilus  libgobject-2.0.so.0.3701.0  [.] 0x0000000000020bf0
       1.79%   kworker/1:0  [kernel.kallsyms]           [k] generic_exec_single
       1.75%       swapper  [kernel.kallsyms]           [k] intel_idle
       1.14%      nautilus  [unknown]                   [.] 0x0000003153f2ff61
       0.69%   kworker/0:1  [kernel.kallsyms]           [k] generic_exec_single
       0.67%      nautilus  ld-2.17.so                  [.] do_lookup_x

Signed-off-by: Namhyung Kim <namhyung@kernel.org>
---
 tools/perf/builtin-report.c | 15 ++++++++++++++-
 tools/perf/util/evsel.h     |  2 ++
 tools/perf/util/hist.h      |  1 +
 tools/perf/util/session.c   |  7 +++++++
 4 files changed, 24 insertions(+), 1 deletion(-)

diff --git a/tools/perf/builtin-report.c b/tools/perf/builtin-report.c
index 8cf8e66ba594..1d47fbec4421 100644
--- a/tools/perf/builtin-report.c
+++ b/tools/perf/builtin-report.c
@@ -456,6 +456,14 @@ static size_t hists__fprintf_nr_sample_events(struct perf_report *rep,
 		ret += fprintf(fp, "\n# Sort order   : %s", sort_order);
 	} else
 		ret += fprintf(fp, "\n# Event count (approx.): %" PRIu64, nr_events);
+	if (rep->tool.ordered_samples) {
+		u64 total_time = hists->stats.total_time;
+		u64 sec = total_time / NSEC_PER_SEC;
+		u64 usec = (total_time - sec * NSEC_PER_SEC) / NSEC_PER_USEC;
+
+		ret += fprintf(fp, "\n# Total sampling time  : "
+			       "%" PRIu64 ".%06" PRIu64 " (sec)", sec, usec);
+	}
 	return ret + fprintf(fp, "\n#\n");
 }
 
@@ -565,8 +573,13 @@ static int __cmd_report(struct perf_report *rep)
 	}
 
 	nr_samples = 0;
-	list_for_each_entry(pos, &session->evlist->entries, node)
+	list_for_each_entry(pos, &session->evlist->entries, node) {
 		nr_samples += pos->hists.nr_entries;
+		if (rep->tool.ordered_samples) {
+			pos->hists.stats.total_time = pos->last_timestamp -
+							pos->first_timestamp;
+		}
+	}
 
 	ui_progress__init(&prog, nr_samples, "Merging related events...");
 
diff --git a/tools/perf/util/evsel.h b/tools/perf/util/evsel.h
index 8120eeb86ac1..20a7c653b74b 100644
--- a/tools/perf/util/evsel.h
+++ b/tools/perf/util/evsel.h
@@ -67,6 +67,8 @@ struct perf_evsel {
 	int			idx;
 	u32			ids;
 	struct hists		hists;
+	u64			first_timestamp;
+	u64			last_timestamp;
 	char			*name;
 	double			scale;
 	const char		*unit;
diff --git a/tools/perf/util/hist.h b/tools/perf/util/hist.h
index b621347a1585..bc5acdfc2b4b 100644
--- a/tools/perf/util/hist.h
+++ b/tools/perf/util/hist.h
@@ -28,6 +28,7 @@ struct symbol;
  */
 struct events_stats {
 	u64 total_period;
+	u64 total_time;
 	u64 total_lost;
 	u64 total_invalid_chains;
 	u32 nr_events[PERF_RECORD_HEADER_MAX];
diff --git a/tools/perf/util/session.c b/tools/perf/util/session.c
index 4ce146bae552..e4b158f0586a 100644
--- a/tools/perf/util/session.c
+++ b/tools/perf/util/session.c
@@ -925,6 +925,13 @@ perf_session__deliver_sample(struct perf_session *session,
 	u64 sample_type = evsel->attr.sample_type;
 	u64 read_format = evsel->attr.read_format;
 
+	if (tool->ordered_samples) {
+		if (evsel->first_timestamp == 0)
+			evsel->first_timestamp = sample->time;
+
+		evsel->last_timestamp = sample->time;
+	}
+
 	/* Standard sample delievery. */
 	if (!(sample_type & PERF_SAMPLE_READ))
 		return tool->sample(tool, event, sample, evsel, machine);
-- 
1.7.11.7

