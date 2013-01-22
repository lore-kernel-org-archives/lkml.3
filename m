Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756135Ab3AVJLg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jan 2013 04:11:36 -0500
Received: from LGEMRELSE7Q.lge.com ([156.147.1.151]:60773 "EHLO
	LGEMRELSE7Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755901Ab3AVJLc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jan 2013 04:11:32 -0500
X-AuditID: 9c930197-b7ca4ae000006ba8-b4-50fe57be6b09
From: Namhyung Kim <namhyung@kernel.org>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Namhyung Kim <namhyung.kim@lge.com>, Jiri Olsa <jolsa@redhat.com>,
        Stephane Eranian <eranian@google.com>
Subject: [PATCH 19/19] perf evlist: Add --group option
Date: Tue, 22 Jan 2013 18:09:47 +0900
Message-Id: <1358845787-1350-20-git-send-email-namhyung@kernel.org>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1358845787-1350-1-git-send-email-namhyung@kernel.org>
References: <1358845787-1350-1-git-send-email-namhyung@kernel.org>
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Namhyung Kim <namhyung.kim@lge.com>

Add '-g/--group' option for showing event groups.  For simplicity it
is currently not compatible with other options.

  $ perf evlist --group
  {ref-cycles,cycles}

  $ perf evlist
  ref-cycles
  cycles

Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Stephane Eranian <eranian@google.com>
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
---
 tools/perf/Documentation/perf-evlist.txt |  4 ++++
 tools/perf/builtin-evlist.c              |  7 +++++++
 tools/perf/util/evsel.c                  | 24 ++++++++++++++++++++++--
 3 files changed, 33 insertions(+), 2 deletions(-)

diff --git a/tools/perf/Documentation/perf-evlist.txt b/tools/perf/Documentation/perf-evlist.txt
index 15217345c2fa..1ceb3700ffbb 100644
--- a/tools/perf/Documentation/perf-evlist.txt
+++ b/tools/perf/Documentation/perf-evlist.txt
@@ -28,6 +28,10 @@ OPTIONS
 --verbose=::
 	Show all fields.
 
+-g::
+--group::
+	Show event group information.
+
 SEE ALSO
 --------
 linkperf:perf-record[1], linkperf:perf-list[1],
diff --git a/tools/perf/builtin-evlist.c b/tools/perf/builtin-evlist.c
index 1312a5e03ec7..85a5e35dd147 100644
--- a/tools/perf/builtin-evlist.c
+++ b/tools/perf/builtin-evlist.c
@@ -39,6 +39,8 @@ int cmd_evlist(int argc, const char **argv, const char *prefix __maybe_unused)
 	OPT_BOOLEAN('F', "freq", &details.freq, "Show the sample frequency"),
 	OPT_BOOLEAN('v', "verbose", &details.verbose,
 		    "Show all event attr details"),
+	OPT_BOOLEAN('g', "group", &symbol_conf.event_group,
+		    "Show event group information"),
 	OPT_END()
 	};
 	const char * const evlist_usage[] = {
@@ -50,5 +52,10 @@ int cmd_evlist(int argc, const char **argv, const char *prefix __maybe_unused)
 	if (argc)
 		usage_with_options(evlist_usage, options);
 
+	if (symbol_conf.event_group && (details.verbose || details.freq)) {
+		pr_err("--group option is not compatible with other options\n");
+		usage_with_options(evlist_usage, options);
+	}
+
 	return __cmd_evlist(input_name, &details);
 }
diff --git a/tools/perf/util/evsel.c b/tools/perf/util/evsel.c
index 35b2a0a0a490..93d723bf996c 100644
--- a/tools/perf/util/evsel.c
+++ b/tools/perf/util/evsel.c
@@ -1358,7 +1358,27 @@ int perf_evsel__fprintf(struct perf_evsel *evsel,
 			struct perf_attr_details *details, FILE *fp)
 {
 	bool first = true;
-	int printed = fprintf(fp, "%s", perf_evsel__name(evsel));
+	int printed = 0;
+
+	if (symbol_conf.event_group) {
+		struct perf_evsel *pos;
+
+		if (!perf_evsel__is_group_leader(evsel))
+			return 0;
+
+		if (evsel->nr_members > 1)
+			printed += fprintf(fp, "%s{", evsel->group_name ?: "");
+
+		printed += fprintf(fp, "%s", perf_evsel__name(evsel));
+		for_each_group_member(pos, evsel)
+			printed += fprintf(fp, ",%s", perf_evsel__name(pos));
+
+		if (evsel->nr_members > 1)
+			printed += fprintf(fp, "}");
+		goto out;
+	}
+
+	printed += fprintf(fp, "%s", perf_evsel__name(evsel));
 
 	if (details->verbose || details->freq) {
 		printed += comma_fprintf(fp, &first, " sample_freq=%" PRIu64,
@@ -1399,7 +1419,7 @@ int perf_evsel__fprintf(struct perf_evsel *evsel,
 		if_print(bp_type);
 		if_print(branch_sample_type);
 	}
-
+out:
 	fputc('\n', fp);
 	return ++printed;
 }
-- 
1.7.11.7

