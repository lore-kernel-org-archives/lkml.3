Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754503AbaLHGvl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Dec 2014 01:51:41 -0500
Received: from terminus.zytor.com ([198.137.202.10]:34767 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754133AbaLHGvj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Dec 2014 01:51:39 -0500
Date: Sun, 7 Dec 2014 22:51:16 -0800
From: tip-bot for Jiri Olsa <tipbot@zytor.com>
Message-ID: <tip-1d9e446b91e182055d874fbb30150aad479a4981@git.kernel.org>
Cc: jolsa@kernel.org, ak@linux.intel.com, dsahern@gmail.com,
        matt.fleming@intel.com, namhyung@kernel.org, a.p.zijlstra@chello.nl,
        hpa@zytor.com, mingo@kernel.org, acme@redhat.com,
        linux-kernel@vger.kernel.org, paulus@samba.org, tglx@linutronix.de,
        fweisbec@gmail.com, eranian@google.com, cjashfor@linux.vnet.ibm.com
Reply-To: a.p.zijlstra@chello.nl, matt.fleming@intel.com, namhyung@kernel.org,
        ak@linux.intel.com, dsahern@gmail.com, jolsa@kernel.org,
        cjashfor@linux.vnet.ibm.com, eranian@google.com, tglx@linutronix.de,
        fweisbec@gmail.com, acme@redhat.com, paulus@samba.org,
        linux-kernel@vger.kernel.org, mingo@kernel.org, hpa@zytor.com
In-Reply-To: <1416562275-12404-10-git-send-email-jolsa@kernel.org>
References: <1416562275-12404-10-git-send-email-jolsa@kernel.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf tools: Add snapshot format file parsing
Git-Commit-ID: 1d9e446b91e182055d874fbb30150aad479a4981
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

Commit-ID:  1d9e446b91e182055d874fbb30150aad479a4981
Gitweb:     http://git.kernel.org/tip/1d9e446b91e182055d874fbb30150aad479a4981
Author:     Jiri Olsa <jolsa@kernel.org>
AuthorDate: Fri, 21 Nov 2014 10:31:13 +0100
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Mon, 24 Nov 2014 18:03:51 -0300

perf tools: Add snapshot format file parsing

The .snapshot file indicates that the provided event value is a snapshot
value and we have to bypass the delta computation logic.

Adding support to check up this file and set event flag accordingly.

Signed-off-by: Jiri Olsa <jolsa@kernel.org>
Cc: Andi Kleen <ak@linux.intel.com>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Matt Fleming <matt.fleming@intel.com>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/r/1416562275-12404-10-git-send-email-jolsa@kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/evsel.h        |  1 +
 tools/perf/util/parse-events.c |  1 +
 tools/perf/util/pmu.c          | 47 ++++++++++++++++++++++++++++++++----------
 tools/perf/util/pmu.h          |  2 ++
 4 files changed, 40 insertions(+), 11 deletions(-)

diff --git a/tools/perf/util/evsel.h b/tools/perf/util/evsel.h
index 792b0ea..b18d58d 100644
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
index 5a373483..77b43fe 100644
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
index f003b5a..5c9c494 100644
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
index c3a74e0..6b1249f 100644
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
