Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756438Ab3AaRcH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jan 2013 12:32:07 -0500
Received: from 173-166-109-252-newengland.hfc.comcastbusiness.net ([173.166.109.252]:60072
	"EHLO bombadil.infradead.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753385Ab3AaRZi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jan 2013 12:25:38 -0500
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Namhyung Kim <namhyung.kim@lge.com>,
        Namhyung Kim <namhyung@kernel.org>, Jiri Olsa <jolsa@redhat.com>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Stephane Eranian <eranian@google.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 20/25] perf evlist: Add --group option
Date: Thu, 31 Jan 2013 14:25:23 -0300
Message-Id: <1359653128-10433-21-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.8.1.1.361.gec3ae6e
In-Reply-To: <1359653128-10433-1-git-send-email-acme@infradead.org>
References: <1359653128-10433-1-git-send-email-acme@infradead.org>
Content-Type: text/plain; charset="utf-8"
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Namhyung Kim <namhyung.kim@lge.com>

Add '-g/--group' option for showing event groups.  For simplicity it is
currently not compatible with other options.

  $ perf evlist --group
  {ref-cycles,cycles}

  $ perf evlist
  ref-cycles
  cycles

Suggested-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/r/1358845787-1350-20-git-send-email-namhyung@kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/Documentation/perf-evlist.txt |  4 ++++
 tools/perf/builtin-evlist.c              |  7 +++++++
 tools/perf/util/evsel.c                  | 24 ++++++++++++++++++++++--
 3 files changed, 33 insertions(+), 2 deletions(-)

diff --git a/tools/perf/Documentation/perf-evlist.txt b/tools/perf/Documentation/perf-evlist.txt
index 1521734..1ceb370 100644
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
index 1312a5e..85a5e35 100644
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
index 94e7404..a547015 100644
--- a/tools/perf/util/evsel.c
+++ b/tools/perf/util/evsel.c
@@ -1389,7 +1389,27 @@ int perf_evsel__fprintf(struct perf_evsel *evsel,
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
@@ -1430,7 +1450,7 @@ int perf_evsel__fprintf(struct perf_evsel *evsel,
 		if_print(bp_type);
 		if_print(branch_sample_type);
 	}
-
+out:
 	fputc('\n', fp);
 	return ++printed;
 }
-- 
1.8.1.1.361.gec3ae6e

