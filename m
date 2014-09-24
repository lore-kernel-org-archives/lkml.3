Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753546AbaIXOE0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2014 10:04:26 -0400
Received: from mail-wi0-f171.google.com ([209.85.212.171]:36528 "EHLO
	mail-wi0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753347AbaIXOEX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2014 10:04:23 -0400
From: Matt Fleming <matt@console-pimps.org>
To: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@kernel.org>,
        Jiri Olsa <jolsa@redhat.com>,
        Arnaldo Carvalho de Melo <acme@kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>,
        Matt Fleming <matt.fleming@intel.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 02/11] perf tools: Refactor unit and scale function parameters
Date: Wed, 24 Sep 2014 15:04:06 +0100
Message-Id: <1411567455-31264-3-git-send-email-matt@console-pimps.org>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1411567455-31264-1-git-send-email-matt@console-pimps.org>
References: <1411567455-31264-1-git-send-email-matt@console-pimps.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Matt Fleming <matt.fleming@intel.com>

Passing pointers to alias modifiers 'unit' and 'scale' isn't very
future-proof since if we add more modifiers to the list we'll end up
passing more arguments.

Instead wrap everything up in a struct perf_pmu_info, which can easily
be expanded when additional alias modifiers are necessary in the future.

Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Signed-off-by: Matt Fleming <matt.fleming@intel.com>
---
 tools/perf/util/parse-events.c |  9 ++++-----
 tools/perf/util/pmu.c          | 38 +++++++++++++++++++++++---------------
 tools/perf/util/pmu.h          |  7 ++++++-
 3 files changed, 33 insertions(+), 21 deletions(-)

diff --git a/tools/perf/util/parse-events.c b/tools/perf/util/parse-events.c
index 61be3e695ec2..9522cf22ad81 100644
--- a/tools/perf/util/parse-events.c
+++ b/tools/perf/util/parse-events.c
@@ -634,10 +634,9 @@ int parse_events_add_pmu(struct list_head *list, int *idx,
 			 char *name, struct list_head *head_config)
 {
 	struct perf_event_attr attr;
+	struct perf_pmu_info info;
 	struct perf_pmu *pmu;
 	struct perf_evsel *evsel;
-	const char *unit;
-	double scale;
 
 	pmu = perf_pmu__find(name);
 	if (!pmu)
@@ -656,7 +655,7 @@ int parse_events_add_pmu(struct list_head *list, int *idx,
 		return evsel ? 0 : -ENOMEM;
 	}
 
-	if (perf_pmu__check_alias(pmu, head_config, &unit, &scale))
+	if (perf_pmu__check_alias(pmu, head_config, &info))
 		return -EINVAL;
 
 	/*
@@ -671,8 +670,8 @@ int parse_events_add_pmu(struct list_head *list, int *idx,
 	evsel = __add_event(list, idx, &attr, pmu_event_name(head_config),
 			    pmu->cpus);
 	if (evsel) {
-		evsel->unit = unit;
-		evsel->scale = scale;
+		evsel->unit = info.unit;
+		evsel->scale = info.scale;
 	}
 
 	return evsel ? 0 : -ENOMEM;
diff --git a/tools/perf/util/pmu.c b/tools/perf/util/pmu.c
index 22a4ad5a927a..93a41ca96b8e 100644
--- a/tools/perf/util/pmu.c
+++ b/tools/perf/util/pmu.c
@@ -210,6 +210,19 @@ static int perf_pmu__new_alias(struct list_head *list, char *dir, char *name, FI
 	return 0;
 }
 
+static inline bool pmu_alias_info_file(char *name)
+{
+	size_t len;
+
+	len = strlen(name);
+	if (len > 5 && !strcmp(name + len - 5, ".unit"))
+		return true;
+	if (len > 6 && !strcmp(name + len - 6, ".scale"))
+		return true;
+
+	return false;
+}
+
 /*
  * Process all the sysfs attributes located under the directory
  * specified in 'dir' parameter.
@@ -218,7 +231,6 @@ static int pmu_aliases_parse(char *dir, struct list_head *head)
 {
 	struct dirent *evt_ent;
 	DIR *event_dir;
-	size_t len;
 	int ret = 0;
 
 	event_dir = opendir(dir);
@@ -234,13 +246,9 @@ static int pmu_aliases_parse(char *dir, struct list_head *head)
 			continue;
 
 		/*
-		 * skip .unit and .scale info files
-		 * parsed in perf_pmu__new_alias()
+		 * skip info files parsed in perf_pmu__new_alias()
 		 */
-		len = strlen(name);
-		if (len > 5 && !strcmp(name + len - 5, ".unit"))
-			continue;
-		if (len > 6 && !strcmp(name + len - 6, ".scale"))
+		if (pmu_alias_info_file(name))
 			continue;
 
 		snprintf(path, PATH_MAX, "%s/%s", dir, name);
@@ -645,7 +653,7 @@ static int check_unit_scale(struct perf_pmu_alias *alias,
  * defined for the alias
  */
 int perf_pmu__check_alias(struct perf_pmu *pmu, struct list_head *head_terms,
-			  const char **unit, double *scale)
+			  struct perf_pmu_info *info)
 {
 	struct parse_events_term *term, *h;
 	struct perf_pmu_alias *alias;
@@ -655,8 +663,8 @@ int perf_pmu__check_alias(struct perf_pmu *pmu, struct list_head *head_terms,
 	 * Mark unit and scale as not set
 	 * (different from default values, see below)
 	 */
-	*unit   = NULL;
-	*scale  = 0.0;
+	info->unit   = NULL;
+	info->scale  = 0.0;
 
 	list_for_each_entry_safe(term, h, head_terms, list) {
 		alias = pmu_find_alias(pmu, term);
@@ -666,7 +674,7 @@ int perf_pmu__check_alias(struct perf_pmu *pmu, struct list_head *head_terms,
 		if (ret)
 			return ret;
 
-		ret = check_unit_scale(alias, unit, scale);
+		ret = check_unit_scale(alias, &info->unit, &info->scale);
 		if (ret)
 			return ret;
 
@@ -679,11 +687,11 @@ int perf_pmu__check_alias(struct perf_pmu *pmu, struct list_head *head_terms,
 	 * set defaults as for evsel
 	 * unit cannot left to NULL
 	 */
-	if (*unit == NULL)
-		*unit   = "";
+	if (info->unit == NULL)
+		info->unit   = "";
 
-	if (*scale == 0.0)
-		*scale  = 1.0;
+	if (info->scale == 0.0)
+		info->scale  = 1.0;
 
 	return 0;
 }
diff --git a/tools/perf/util/pmu.h b/tools/perf/util/pmu.h
index 0f5c0a88fdc8..fe90a012c003 100644
--- a/tools/perf/util/pmu.h
+++ b/tools/perf/util/pmu.h
@@ -25,6 +25,11 @@ struct perf_pmu {
 	struct list_head list;    /* ELEM */
 };
 
+struct perf_pmu_info {
+	const char *unit;
+	double scale;
+};
+
 struct perf_pmu *perf_pmu__find(const char *name);
 int perf_pmu__config(struct perf_pmu *pmu, struct perf_event_attr *attr,
 		     struct list_head *head_terms);
@@ -33,7 +38,7 @@ int perf_pmu__config_terms(struct list_head *formats,
 			   struct list_head *head_terms,
 			   bool zero);
 int perf_pmu__check_alias(struct perf_pmu *pmu, struct list_head *head_terms,
-			  const char **unit, double *scale);
+			  struct perf_pmu_info *info);
 struct list_head *perf_pmu__alias(struct perf_pmu *pmu,
 				  struct list_head *head_terms);
 int perf_pmu_wrap(void);
-- 
1.9.3

