Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755313AbaIKTKE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Sep 2014 15:10:04 -0400
Received: from mga02.intel.com ([134.134.136.20]:41856 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755082AbaIKTJp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Sep 2014 15:09:45 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,506,1406617200"; 
   d="scan'208";a="571925955"
From: kan.liang@intel.com
To: acme@kernel.org, jolsa@redhat.com
Cc: linux-kernel@vger.kernel.org, ak@linux.intel.com,
        Kan Liang <kan.liang@intel.com>
Subject: [PATCH V6 2/3] perf tools: parse the pmu event prefix and surfix
Date: Thu, 11 Sep 2014 15:08:58 -0400
Message-Id: <1410462539-5468-3-git-send-email-kan.liang@intel.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1410462539-5468-1-git-send-email-kan.liang@intel.com>
References: <1410462539-5468-1-git-send-email-kan.liang@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Kan Liang <kan.liang@intel.com>

There are two types of event formats for PMU events. E.g. el-abort OR
cpu/el-abort/. However, the lexer mistakenly recognizes the simple style
format as two events.

The parse_events_pmu_check function uses bsearch to search the name in
known pmu event list. It can tell the lexer that the name is a PE_NAME
or a PMU event name prefix or a PMU event name suffix. All these
information will be used for accurately parsing kernel PMU events.

The pmu events list will be read from sysfs at runtime.

Note: Currently, the patch only want to handle the PMU event name as
"a-b" and "a". The only exception, "stalled-cycles-frontend" and
"stalled-cycles-fronted", are already hardcoded in lexer.

Signed-off-by: Kan Liang <kan.liang@intel.com>
---
 tools/perf/util/parse-events.c | 112 +++++++++++++++++++++++++++++++++++++++++
 tools/perf/util/parse-events.h |  14 ++++++
 tools/perf/util/pmu.c          |  10 ----
 tools/perf/util/pmu.h          |  10 ++++
 4 files changed, 136 insertions(+), 10 deletions(-)

diff --git a/tools/perf/util/parse-events.c b/tools/perf/util/parse-events.c
index b9174bc..20e01d1 100644
--- a/tools/perf/util/parse-events.c
+++ b/tools/perf/util/parse-events.c
@@ -30,6 +30,9 @@ extern int parse_events_debug;
 #endif
 int parse_events_parse(void *data, void *scanner);
 
+static struct perf_pmu_event_symbol *perf_pmu_events_list;
+static int perf_pmu_events_list_num;
+
 static struct event_symbol event_symbols_hw[PERF_COUNT_HW_MAX] = {
 	[PERF_COUNT_HW_CPU_CYCLES] = {
 		.symbol = "cpu-cycles",
@@ -864,6 +867,114 @@ int parse_events_name(struct list_head *list, char *name)
 	return 0;
 }
 
+static int
+comp_pmu(const void *p1, const void *p2)
+{
+	struct perf_pmu_event_symbol *pmu1 =
+			(struct perf_pmu_event_symbol *) p1;
+	struct perf_pmu_event_symbol *pmu2 =
+			(struct perf_pmu_event_symbol *) p2;
+
+	return strcmp(pmu1->symbol, pmu2->symbol);
+}
+
+/*
+ * Read the pmu events list from sysfs
+ * Save it into perf_pmu_events_list
+ */
+static void perf_pmu__parse_init(void)
+{
+
+	struct perf_pmu *pmu = NULL;
+	struct perf_pmu_alias *alias;
+	int len = 0;
+
+	pmu = perf_pmu__find("cpu");
+	if ((pmu == NULL) || list_empty(&pmu->aliases)) {
+		perf_pmu_events_list_num = -1;
+		return;
+	}
+	list_for_each_entry(alias, &pmu->aliases, list) {
+		if (strchr(alias->name, '-'))
+			len++;
+		len++;
+	}
+	perf_pmu_events_list =
+		malloc(sizeof(struct perf_pmu_event_symbol) * len);
+	perf_pmu_events_list_num = len;
+
+	len = 0;
+	pmu = perf_pmu__find("cpu");
+	list_for_each_entry(alias, &pmu->aliases, list) {
+		struct perf_pmu_event_symbol *p =
+			perf_pmu_events_list + len;
+		char *tmp = strchr(alias->name, '-');
+
+		if (tmp != NULL) {
+			p->symbol = malloc(tmp - alias->name + 1);
+			strlcpy(p->symbol, alias->name,
+				tmp - alias->name + 1);
+			p->type = KERNEL_PMU_EVENT_PREFIX;
+			tmp++;
+			p++;
+			p->symbol = malloc(strlen(tmp) + 1);
+			strcpy(p->symbol, tmp);
+			p->type = KERNEL_PMU_EVENT_SUFFIX;
+			len += 2;
+		} else {
+			p->symbol = malloc(strlen(alias->name) + 1);
+			strcpy(p->symbol, alias->name);
+			p->type = KERNEL_PMU_EVENT;
+			len++;
+		}
+	}
+	qsort(perf_pmu_events_list, len,
+		sizeof(struct perf_pmu_event_symbol), comp_pmu);
+}
+
+static void perf_pmu__parse_cleanup(void)
+{
+	if (perf_pmu_events_list_num > 0) {
+		struct perf_pmu_event_symbol *p;
+		int i;
+
+		for (i = 0; i < perf_pmu_events_list_num; i++) {
+			p = perf_pmu_events_list + i;
+			free(p->symbol);
+		}
+		free(perf_pmu_events_list);
+		perf_pmu_events_list = NULL;
+		perf_pmu_events_list_num = 0;
+	}
+}
+
+enum perf_pmu_event_symbol_type
+perf_pmu__parse_check(const char *name)
+{
+	struct perf_pmu_event_symbol p, *r;
+
+	/* scan kernel pmu events from sysfs if needed */
+	if (perf_pmu_events_list_num == 0)
+		perf_pmu__parse_init();
+	/*
+	 * name "cpu" could be prefix of cpu-cycles or cpu// events.
+	 * cpu-cycles has been handled by hardcode.
+	 * So it must be cpu// events, not kernel pmu event.
+	 */
+	if ((perf_pmu_events_list_num <= 0) || !strcmp(name, "cpu"))
+		return NONE_KERNEL_PMU_EVENT;
+
+	p.symbol = malloc(strlen(name) + 1);
+	strcpy(p.symbol, name);
+	r = bsearch(&p, perf_pmu_events_list,
+			(size_t) perf_pmu_events_list_num,
+			sizeof(struct perf_pmu_event_symbol), comp_pmu);
+	free(p.symbol);
+	if (r == NULL)
+		return NONE_KERNEL_PMU_EVENT;
+	return r->type;
+}
+
 static int parse_events__scanner(const char *str, void *data, int start_token)
 {
 	YY_BUFFER_STATE buffer;
@@ -918,6 +1029,7 @@ int parse_events(struct perf_evlist *evlist, const char *str)
 	int ret;
 
 	ret = parse_events__scanner(str, &data, PE_START_EVENTS);
+	perf_pmu__parse_cleanup();
 	if (!ret) {
 		int entries = data.idx - evlist->nr_entries;
 		perf_evlist__splice_list_tail(evlist, &data.list, entries);
diff --git a/tools/perf/util/parse-events.h b/tools/perf/util/parse-events.h
index df094b4..9f064e4 100644
--- a/tools/perf/util/parse-events.h
+++ b/tools/perf/util/parse-events.h
@@ -35,6 +35,18 @@ extern int parse_filter(const struct option *opt, const char *str, int unset);
 
 #define EVENTS_HELP_MAX (128*1024)
 
+enum perf_pmu_event_symbol_type {
+	NONE_KERNEL_PMU_EVENT,		/* not a PMU EVENT */
+	KERNEL_PMU_EVENT,		/* normal style PMU event */
+	KERNEL_PMU_EVENT_PREFIX,	/* prefix of pre-suf style event */
+	KERNEL_PMU_EVENT_SUFFIX,	/* suffix of pre-suf style event */
+};
+
+struct perf_pmu_event_symbol {
+	char	*symbol;
+	enum perf_pmu_event_symbol_type	type;
+};
+
 enum {
 	PARSE_EVENTS__TERM_TYPE_NUM,
 	PARSE_EVENTS__TERM_TYPE_STR,
@@ -95,6 +107,8 @@ int parse_events_add_breakpoint(struct list_head *list, int *idx,
 				void *ptr, char *type);
 int parse_events_add_pmu(struct list_head *list, int *idx,
 			 char *pmu , struct list_head *head_config);
+enum perf_pmu_event_symbol_type
+perf_pmu__parse_check(const char *name);
 void parse_events__set_leader(char *name, struct list_head *list);
 void parse_events_update_lists(struct list_head *list_event,
 			       struct list_head *list_all);
diff --git a/tools/perf/util/pmu.c b/tools/perf/util/pmu.c
index 22a4ad5..f358345 100644
--- a/tools/perf/util/pmu.c
+++ b/tools/perf/util/pmu.c
@@ -12,16 +12,6 @@
 #include "parse-events.h"
 #include "cpumap.h"
 
-#define UNIT_MAX_LEN	31 /* max length for event unit name */
-
-struct perf_pmu_alias {
-	char *name;
-	struct list_head terms; /* HEAD struct parse_events_term -> list */
-	struct list_head list;  /* ELEM */
-	char unit[UNIT_MAX_LEN+1];
-	double scale;
-};
-
 struct perf_pmu_format {
 	char *name;
 	int value;
diff --git a/tools/perf/util/pmu.h b/tools/perf/util/pmu.h
index 0f5c0a8..2020519 100644
--- a/tools/perf/util/pmu.h
+++ b/tools/perf/util/pmu.h
@@ -25,6 +25,16 @@ struct perf_pmu {
 	struct list_head list;    /* ELEM */
 };
 
+#define UNIT_MAX_LEN	31 /* max length for event unit name */
+
+struct perf_pmu_alias {
+	char *name;
+	struct list_head terms; /* HEAD struct parse_events_term -> list */
+	struct list_head list;  /* ELEM */
+	char unit[UNIT_MAX_LEN+1];
+	double scale;
+};
+
 struct perf_pmu *perf_pmu__find(const char *name);
 int perf_pmu__config(struct perf_pmu *pmu, struct perf_event_attr *attr,
 		     struct list_head *head_terms);
-- 
1.8.3.2

