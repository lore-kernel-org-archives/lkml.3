Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758307AbaKUJca (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Nov 2014 04:32:30 -0500
Received: from mx1.redhat.com ([209.132.183.28]:43361 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758286AbaKUJc0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Nov 2014 04:32:26 -0500
From: Jiri Olsa <jolsa@kernel.org>
To: linux-kernel@vger.kernel.org
Cc: Matt Fleming <matt.fleming@intel.com>, Andi Kleen <ak@linux.intel.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@kernel.org>, Namhyung Kim <namhyung@kernel.org>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Stephane Eranian <eranian@google.com>, Jiri Olsa <jolsa@kernel.org>
Subject: [PATCH 08/11] perf tools: Add per-pkg format file parsing
Date: Fri, 21 Nov 2014 10:31:12 +0100
Message-Id: <1416562275-12404-9-git-send-email-jolsa@kernel.org>
In-Reply-To: <1416562275-12404-1-git-send-email-jolsa@kernel.org>
References: <1416562275-12404-1-git-send-email-jolsa@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Matt Fleming <matt.fleming@intel.com>

The .per-pkg file indicates that all but one value per socket
should be discarded. Adding support to check up this file and
set event flag accordingly.

This patch is part of Matt's original patch:
  http://marc.info/?l=linux-kernel&m=141527675002139&w=2
only the file parsing part, the rest is solved
differently.

Cc: Andi Kleen <ak@linux.intel.com>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Stephane Eranian <eranian@google.com>
Signed-off-by: Matt Fleming <matt.fleming@intel.com>
Signed-off-by: Jiri Olsa <jolsa@kernel.org>
---
 tools/perf/util/evsel.h        |  1 +
 tools/perf/util/parse-events.c |  1 +
 tools/perf/util/pmu.c          | 27 +++++++++++++++++++++++++++
 tools/perf/util/pmu.h          |  2 ++
 4 files changed, 31 insertions(+)

diff --git a/tools/perf/util/evsel.h b/tools/perf/util/evsel.h
index 17da44de7339..be295f185c32 100644
--- a/tools/perf/util/evsel.h
+++ b/tools/perf/util/evsel.h
@@ -91,6 +91,7 @@ struct perf_evsel {
 	bool			immediate;
 	bool			system_wide;
 	bool			tracking;
+	bool			per_pkg;
 	/* parse modifier helper */
 	int			exclude_GH;
 	int			nr_members;
diff --git a/tools/perf/util/parse-events.c b/tools/perf/util/parse-events.c
index c659a3ca1283..5a373483f0e4 100644
--- a/tools/perf/util/parse-events.c
+++ b/tools/perf/util/parse-events.c
@@ -681,6 +681,7 @@ int parse_events_add_pmu(struct list_head *list, int *idx,
 	if (evsel) {
 		evsel->unit = info.unit;
 		evsel->scale = info.scale;
+		evsel->per_pkg = info.per_pkg;
 	}
 
 	return evsel ? 0 : -ENOMEM;
diff --git a/tools/perf/util/pmu.c b/tools/perf/util/pmu.c
index 881b75490533..f003b5a9e059 100644
--- a/tools/perf/util/pmu.c
+++ b/tools/perf/util/pmu.c
@@ -163,6 +163,24 @@ error:
 	return -1;
 }
 
+static int
+perf_pmu__parse_per_pkg(struct perf_pmu_alias *alias, char *dir, char *name)
+{
+	char path[PATH_MAX];
+	int fd;
+
+	snprintf(path, PATH_MAX, "%s/%s.per-pkg", dir, name);
+
+	fd = open(path, O_RDONLY);
+	if (fd == -1)
+		return -1;
+
+	close(fd);
+
+	alias->per_pkg = true;
+	return 0;
+}
+
 static int perf_pmu__new_alias(struct list_head *list, char *dir, char *name, FILE *file)
 {
 	struct perf_pmu_alias *alias;
@@ -181,6 +199,7 @@ static int perf_pmu__new_alias(struct list_head *list, char *dir, char *name, FI
 	INIT_LIST_HEAD(&alias->terms);
 	alias->scale = 1.0;
 	alias->unit[0] = '\0';
+	alias->per_pkg = false;
 
 	ret = parse_events_terms(&alias->terms, buf);
 	if (ret) {
@@ -194,6 +213,7 @@ static int perf_pmu__new_alias(struct list_head *list, char *dir, char *name, FI
 	 */
 	perf_pmu__parse_unit(alias, dir, name);
 	perf_pmu__parse_scale(alias, dir, name);
+	perf_pmu__parse_per_pkg(alias, dir, name);
 
 	list_add_tail(&alias->list, list);
 
@@ -209,6 +229,8 @@ static inline bool pmu_alias_info_file(char *name)
 		return true;
 	if (len > 6 && !strcmp(name + len - 6, ".scale"))
 		return true;
+	if (len > 8 && !strcmp(name + len - 8, ".per-pkg"))
+		return true;
 
 	return false;
 }
@@ -649,6 +671,8 @@ int perf_pmu__check_alias(struct perf_pmu *pmu, struct list_head *head_terms,
 	struct perf_pmu_alias *alias;
 	int ret;
 
+	info->per_pkg = false;
+
 	/*
 	 * Mark unit and scale as not set
 	 * (different from default values, see below)
@@ -668,6 +692,9 @@ int perf_pmu__check_alias(struct perf_pmu *pmu, struct list_head *head_terms,
 		if (ret)
 			return ret;
 
+		if (alias->per_pkg)
+			info->per_pkg = true;
+
 		list_del(&term->list);
 		free(term);
 	}
diff --git a/tools/perf/util/pmu.h b/tools/perf/util/pmu.h
index 8092de78e818..c3a74e0e17a2 100644
--- a/tools/perf/util/pmu.h
+++ b/tools/perf/util/pmu.h
@@ -29,6 +29,7 @@ struct perf_pmu {
 struct perf_pmu_info {
 	const char *unit;
 	double scale;
+	bool per_pkg;
 };
 
 #define UNIT_MAX_LEN	31 /* max length for event unit name */
@@ -39,6 +40,7 @@ struct perf_pmu_alias {
 	struct list_head list;  /* ELEM */
 	char unit[UNIT_MAX_LEN+1];
 	double scale;
+	bool per_pkg;
 };
 
 struct perf_pmu *perf_pmu__find(const char *name);
-- 
1.9.3

