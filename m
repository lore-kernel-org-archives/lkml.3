Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756667Ab3BAK6f (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Feb 2013 05:58:35 -0500
Received: from terminus.zytor.com ([198.137.202.10]:52176 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964778Ab3BAK60 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Feb 2013 05:58:26 -0500
Date: Fri, 1 Feb 2013 02:58:05 -0800
From: tip-bot for Namhyung Kim <namhyung.kim@lge.com>
Message-ID: <tip-e6ab07d027d47e55d8a5c0f33b16dfdd3e18c96f@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, eranian@google.com, paulus@samba.org,
        acme@redhat.com, hpa@zytor.com, mingo@kernel.org,
        a.p.zijlstra@chello.nl, namhyung.kim@lge.com, namhyung@kernel.org,
        jolsa@redhat.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, acme@redhat.com, paulus@samba.org,
        eranian@google.com, linux-kernel@vger.kernel.org,
        a.p.zijlstra@chello.nl, namhyung.kim@lge.com, tglx@linutronix.de,
        namhyung@kernel.org, jolsa@redhat.com
In-Reply-To: <1358845787-1350-20-git-send-email-namhyung@kernel.org>
References: <1358845787-1350-20-git-send-email-namhyung@kernel.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf evlist: Add --group option
Git-Commit-ID: e6ab07d027d47e55d8a5c0f33b16dfdd3e18c96f
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Fri, 01 Feb 2013 02:58:11 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  e6ab07d027d47e55d8a5c0f33b16dfdd3e18c96f
Gitweb:     http://git.kernel.org/tip/e6ab07d027d47e55d8a5c0f33b16dfdd3e18c96f
Author:     Namhyung Kim <namhyung.kim@lge.com>
AuthorDate: Tue, 22 Jan 2013 18:09:47 +0900
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Thu, 31 Jan 2013 13:07:49 -0300

perf evlist: Add --group option

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
