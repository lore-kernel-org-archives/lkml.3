Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751338AbaKFMXg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Nov 2014 07:23:36 -0500
Received: from mail-wg0-f49.google.com ([74.125.82.49]:60025 "EHLO
	mail-wg0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751293AbaKFMXd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Nov 2014 07:23:33 -0500
From: Matt Fleming <matt@console-pimps.org>
To: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@kernel.org>,
        Jiri Olsa <jolsa@redhat.com>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Andi Kleen <andi@firstfloor.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>,
        Kanaka Juvva <kanaka.d.juvva@intel.com>, Jiri Olsa <jolsa@kernel.org>
Subject: [PATCH 02/11] perf tools: Implement snapshot event file logic
Date: Thu,  6 Nov 2014 12:23:13 +0000
Message-Id: <1415276602-10337-3-git-send-email-matt@console-pimps.org>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1415276602-10337-1-git-send-email-matt@console-pimps.org>
References: <1415276602-10337-1-git-send-email-matt@console-pimps.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jiri Olsa <jolsa@kernel.org>

Adding support to parse and read the snapshot file,
and using this information to omit the compute_delta
function logic.

Signed-off-by: Jiri Olsa <jolsa@kernel.org>
---
 tools/perf/util/evsel.c        |  6 ++++--
 tools/perf/util/evsel.h        |  1 +
 tools/perf/util/parse-events.c |  1 +
 tools/perf/util/pmu.c          | 47 ++++++++++++++++++++++++++++++++----------
 tools/perf/util/pmu.h          |  2 ++
 5 files changed, 44 insertions(+), 13 deletions(-)

diff --git a/tools/perf/util/evsel.c b/tools/perf/util/evsel.c
index a748e5e16533..bbbebbb49c3a 100644
--- a/tools/perf/util/evsel.c
+++ b/tools/perf/util/evsel.c
@@ -902,7 +902,8 @@ int __perf_evsel__read_on_cpu(struct perf_evsel *evsel,
 	if (readn(FD(evsel, cpu, thread), &count, nv * sizeof(u64)) < 0)
 		return -errno;
 
-	compute_deltas(evsel, cpu, &count);
+	if (!evsel->snapshot)
+		compute_deltas(evsel, cpu, &count);
 
 	if (scale) {
 		if (count.run == 0)
@@ -949,7 +950,8 @@ int __perf_evsel__read(struct perf_evsel *evsel,
 		}
 	}
 
-	compute_deltas(evsel, -1, aggr);
+	if (!evsel->snapshot)
+		compute_deltas(evsel, -1, aggr);
 
 	evsel->counts->scaled = 0;
 	if (scale) {
diff --git a/tools/perf/util/evsel.h b/tools/perf/util/evsel.h
index 13ca8a7693e4..d9fa85e203f8 100644
--- a/tools/perf/util/evsel.h
+++ b/tools/perf/util/evsel.h
@@ -73,6 +73,7 @@ struct perf_evsel {
 	char			*name;
 	double			scale;
 	const char		*unit;
+	bool			snapshot;
 	struct event_format	*tp_format;
 	union {
 		void		*priv;
diff --git a/tools/perf/util/parse-events.c b/tools/perf/util/parse-events.c
index 5a373483f0e4..77b43fe43d55 100644
--- a/tools/perf/util/parse-events.c
+++ b/tools/perf/util/parse-events.c
@@ -682,6 +682,7 @@ int parse_events_add_pmu(struct list_head *list, int *idx,
 		evsel->unit = info.unit;
 		evsel->scale = info.scale;
 		evsel->per_pkg = info.per_pkg;
+		evsel->snapshot = info.snapshot;
 	}
 
 	return evsel ? 0 : -ENOMEM;
diff --git a/tools/perf/util/pmu.c b/tools/perf/util/pmu.c
index f003b5a9e059..5c9c4947cfb4 100644
--- a/tools/perf/util/pmu.c
+++ b/tools/perf/util/pmu.c
@@ -181,6 +181,23 @@ perf_pmu__parse_per_pkg(struct perf_pmu_alias *alias, char *dir, char *name)
 	return 0;
 }
 
+static int perf_pmu__parse_snapshot(struct perf_pmu_alias *alias,
+				    char *dir, char *name)
+{
+	char path[PATH_MAX];
+	int fd;
+
+	snprintf(path, PATH_MAX, "%s/%s.snapshot", dir, name);
+
+	fd = open(path, O_RDONLY);
+	if (fd == -1)
+		return -1;
+
+	alias->snapshot = true;
+	close(fd);
+	return 0;
+}
+
 static int perf_pmu__new_alias(struct list_head *list, char *dir, char *name, FILE *file)
 {
 	struct perf_pmu_alias *alias;
@@ -214,6 +231,7 @@ static int perf_pmu__new_alias(struct list_head *list, char *dir, char *name, FI
 	perf_pmu__parse_unit(alias, dir, name);
 	perf_pmu__parse_scale(alias, dir, name);
 	perf_pmu__parse_per_pkg(alias, dir, name);
+	perf_pmu__parse_snapshot(alias, dir, name);
 
 	list_add_tail(&alias->list, list);
 
@@ -231,6 +249,8 @@ static inline bool pmu_alias_info_file(char *name)
 		return true;
 	if (len > 8 && !strcmp(name + len - 8, ".per-pkg"))
 		return true;
+	if (len > 9 && !strcmp(name + len - 9, ".snapshot"))
+		return true;
 
 	return false;
 }
@@ -639,23 +659,27 @@ static struct perf_pmu_alias *pmu_find_alias(struct perf_pmu *pmu,
 }
 
 
-static int check_unit_scale(struct perf_pmu_alias *alias,
-			    const char **unit, double *scale)
+static int check_info_data(struct perf_pmu_alias *alias,
+			   struct perf_pmu_info *info)
 {
 	/*
 	 * Only one term in event definition can
-	 * define unit and scale, fail if there's
-	 * more than one.
+	 * define unit, scale and snapshot, fail
+	 * if there's more than one.
 	 */
-	if ((*unit && alias->unit) ||
-	    (*scale && alias->scale))
+	if ((info->unit && alias->unit) ||
+	    (info->scale && alias->scale) ||
+	    (info->snapshot && alias->snapshot))
 		return -EINVAL;
 
 	if (alias->unit)
-		*unit = alias->unit;
+		info->unit = alias->unit;
 
 	if (alias->scale)
-		*scale = alias->scale;
+		info->scale = alias->scale;
+
+	if (alias->snapshot)
+		info->snapshot = alias->snapshot;
 
 	return 0;
 }
@@ -677,8 +701,9 @@ int perf_pmu__check_alias(struct perf_pmu *pmu, struct list_head *head_terms,
 	 * Mark unit and scale as not set
 	 * (different from default values, see below)
 	 */
-	info->unit   = NULL;
-	info->scale  = 0.0;
+	info->unit     = NULL;
+	info->scale    = 0.0;
+	info->snapshot = false;
 
 	list_for_each_entry_safe(term, h, head_terms, list) {
 		alias = pmu_find_alias(pmu, term);
@@ -688,7 +713,7 @@ int perf_pmu__check_alias(struct perf_pmu *pmu, struct list_head *head_terms,
 		if (ret)
 			return ret;
 
-		ret = check_unit_scale(alias, &info->unit, &info->scale);
+		ret = check_info_data(alias, info);
 		if (ret)
 			return ret;
 
diff --git a/tools/perf/util/pmu.h b/tools/perf/util/pmu.h
index c3a74e0e17a2..6b1249fbdb5f 100644
--- a/tools/perf/util/pmu.h
+++ b/tools/perf/util/pmu.h
@@ -30,6 +30,7 @@ struct perf_pmu_info {
 	const char *unit;
 	double scale;
 	bool per_pkg;
+	bool snapshot;
 };
 
 #define UNIT_MAX_LEN	31 /* max length for event unit name */
@@ -41,6 +42,7 @@ struct perf_pmu_alias {
 	char unit[UNIT_MAX_LEN+1];
 	double scale;
 	bool per_pkg;
+	bool snapshot;
 };
 
 struct perf_pmu *perf_pmu__find(const char *name);
-- 
1.9.3

