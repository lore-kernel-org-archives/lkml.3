Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758573AbaH0ClQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Aug 2014 22:41:16 -0400
Received: from mga09.intel.com ([134.134.136.24]:1828 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757799AbaH0ClM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Aug 2014 22:41:12 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,408,1406617200"; 
   d="scan'208";a="563926538"
From: kan.liang@intel.com
To: acme@kernel.org, jolsa@redhat.com
Cc: linux-kernel@vger.kernel.org, ak@linux.intel.com,
        Kan Liang <kan.liang@intel.com>
Subject: [PATCH V2 2/3] perf tools: parse the pmu event prefix and surfix
Date: Tue, 26 Aug 2014 22:33:11 -0400
Message-Id: <1409106792-22333-2-git-send-email-kan.liang@intel.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1409106792-22333-1-git-send-email-kan.liang@intel.com>
References: <1409106792-22333-1-git-send-email-kan.liang@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Kan Liang <kan.liang@intel.com>

There are two types of event formats for PMU events. E.g. el-abort OR
perf tools: parse the pmu event prefix and surfix

There are two types of event formats for PMU events. E.g. el-abort OR
cpu/el-abort/. However, the lexer mistakenly recognizes the simple style
format as two events.

The parse_events_pmu_check function uses bsearch to search the name in
known pmu event list. It can tell the lexer that the name is a PE_NAME
or a PMU event name prefix or a PMU event name suffix. All these
information will be used for accurately parsing kernel PMU events.

The pmu events list will be read from sysfs at runtime.

Signed-off-by: Kan Liang <kan.liang@intel.com>
---
V2: Read kernel PMU events from sysfs at runtime

 tools/perf/util/parse-events.c | 103 +++++++++++++++++++++++++++++++++++++++++
 tools/perf/util/parse-events.h |  15 ++++++
 tools/perf/util/pmu.c          |  10 ----
 tools/perf/util/pmu.h          |  10 ++++
 4 files changed, 128 insertions(+), 10 deletions(-)

diff --git a/tools/perf/util/parse-events.c b/tools/perf/util/parse-events.c
index 7a0aa75..5e69e65 100644
--- a/tools/perf/util/parse-events.c
+++ b/tools/perf/util/parse-events.c
@@ -29,6 +29,9 @@ extern int parse_events_debug;
 #endif
 int parse_events_parse(void *data, void *scanner);
 
+static struct kernel_pmu_event_symbol *kernel_pmu_events_list;
+static size_t kernel_pmu_events_list_num;
+
 static struct event_symbol event_symbols_hw[PERF_COUNT_HW_MAX] = {
 	[PERF_COUNT_HW_CPU_CYCLES] = {
 		.symbol = "cpu-cycles",
@@ -852,6 +855,103 @@ int parse_events_name(struct list_head *list, char *name)
 	return 0;
 }
 
+static int
+comp_pmu(const void *p1, const void *p2)
+{
+	struct kernel_pmu_event_symbol *pmu1 =
+			(struct kernel_pmu_event_symbol *) p1;
+	struct kernel_pmu_event_symbol *pmu2 =
+			(struct kernel_pmu_event_symbol *) p2;
+
+	return strcmp(pmu1->symbol, pmu2->symbol);
+}
+
+enum kernel_pmu_event_type
+parse_events_pmu_check(const char *name)
+{
+	struct kernel_pmu_event_symbol p, *r;
+
+	/*
+	 * name "cpu" could be prefix of cpu-cycles or cpu// events.
+	 * cpu-cycles has been handled by hardcode.
+	 * So it must be cpu// events, not kernel pmu event.
+	 */
+	if (!kernel_pmu_events_list_num || !strcmp(name, "cpu"))
+		return NONE_KERNEL_PMU_EVENT;
+
+	strcpy(p.symbol, name);
+	r = bsearch(&p, kernel_pmu_events_list,
+			kernel_pmu_events_list_num,
+			sizeof(struct kernel_pmu_event_symbol), comp_pmu);
+	if (r == NULL)
+		return NONE_KERNEL_PMU_EVENT;
+	return r->type;
+}
+
+/*
+ * Read the pmu events list from sysfs
+ * Save it into kernel_pmu_events_list
+ */
+static void scan_kernel_pmu_events_list(void)
+{
+
+	struct perf_pmu *pmu = NULL;
+	struct perf_pmu_alias *alias;
+	int len = 0;
+
+	while ((pmu = perf_pmu__scan(pmu)) != NULL)
+		list_for_each_entry(alias, &pmu->aliases, list) {
+			if (!strcmp(pmu->name, "cpu")) {
+				if (strchr(alias->name, '-'))
+					len++;
+				len++;
+			}
+	}
+	if (len == 0)
+		return;
+	kernel_pmu_events_list =
+		malloc(sizeof(struct kernel_pmu_event_symbol) * len);
+	kernel_pmu_events_list_num = len;
+
+	pmu = NULL;
+	len = 0;
+	while ((pmu = perf_pmu__scan(pmu)) != NULL)
+		list_for_each_entry(alias, &pmu->aliases, list) {
+			if (!strcmp(pmu->name, "cpu")) {
+				struct kernel_pmu_event_symbol *p =
+					kernel_pmu_events_list + len;
+				char *tmp = strchr(alias->name, '-');
+
+				if (tmp != NULL) {
+					strncpy(p->symbol, alias->name,
+							tmp - alias->name);
+					p->type = KERNEL_PMU_EVENT_PREFIX;
+					tmp++;
+					p++;
+					strcpy(p->symbol, tmp);
+					p->type = KERNEL_PMU_EVENT_SUFFIX;
+					len += 2;
+				} else {
+					strcpy(p->symbol, alias->name);
+					p->type = KERNEL_PMU_EVENT;
+					len++;
+				}
+			}
+		}
+	qsort(kernel_pmu_events_list, len,
+		sizeof(struct kernel_pmu_event_symbol), comp_pmu);
+
+}
+
+static void release_kernel_pmu_events_list(void)
+{
+	if (kernel_pmu_events_list) {
+		free(kernel_pmu_events_list);
+		kernel_pmu_events_list = NULL;
+	}
+	kernel_pmu_events_list_num = 0;
+}
+
 static int parse_events__scanner(const char *str, void *data, int start_token)
 {
 	YY_BUFFER_STATE buffer;
@@ -905,7 +1005,10 @@ int parse_events(struct perf_evlist *evlist, const char *str)
 	};
 	int ret;
 
+	/* scan kernel pmu events from sysfs */
+	scan_kernel_pmu_events_list();
 	ret = parse_events__scanner(str, &data, PE_START_EVENTS);
+	release_kernel_pmu_events_list();
 	if (!ret) {
 		int entries = data.idx - evlist->nr_entries;
 		perf_evlist__splice_list_tail(evlist, &data.list, entries);
diff --git a/tools/perf/util/parse-events.h b/tools/perf/util/parse-events.h
index df094b4..d06fec4 100644
--- a/tools/perf/util/parse-events.h
+++ b/tools/perf/util/parse-events.h
@@ -35,6 +35,19 @@ extern int parse_filter(const struct option *opt, const char *str, int unset);
 
 #define EVENTS_HELP_MAX (128*1024)
 
+#define KERNEL_PMU_EVENT_MAX	1024
+enum kernel_pmu_event_type {
+	NONE_KERNEL_PMU_EVENT,		/* not a PMU EVENT */
+	KERNEL_PMU_EVENT,		/* normal style PMU event */
+	KERNEL_PMU_EVENT_PREFIX,	/* prefix of pre-suf style event */
+	KERNEL_PMU_EVENT_SUFFIX,	/* suffix of pre-suf style event */
+};
+
+struct kernel_pmu_event_symbol {
+	char	symbol[KERNEL_PMU_EVENT_MAX];
+	enum kernel_pmu_event_type	type;
+};
+
 enum {
 	PARSE_EVENTS__TERM_TYPE_NUM,
 	PARSE_EVENTS__TERM_TYPE_STR,
@@ -95,6 +108,8 @@ int parse_events_add_breakpoint(struct list_head *list, int *idx,
 				void *ptr, char *type);
 int parse_events_add_pmu(struct list_head *list, int *idx,
 			 char *pmu , struct list_head *head_config);
+enum kernel_pmu_event_type
+parse_events_pmu_check(const char *name);
 void parse_events__set_leader(char *name, struct list_head *list);
 void parse_events_update_lists(struct list_head *list_event,
 			       struct list_head *list_all);
diff --git a/tools/perf/util/pmu.c b/tools/perf/util/pmu.c
index 7a811eb..16d5c1a 100644
--- a/tools/perf/util/pmu.c
+++ b/tools/perf/util/pmu.c
@@ -10,16 +10,6 @@
 #include "parse-events.h"
 #include "cpumap.h"
 
-#define UNIT_MAX_LEN	31 /* max length for event unit name */
-
-struct perf_pmu_alias {
-	char *name;
-	struct list_head terms;
-	struct list_head list;
-	char unit[UNIT_MAX_LEN+1];
-	double scale;
-};
-
 struct perf_pmu_format {
 	char *name;
 	int value;
diff --git a/tools/perf/util/pmu.h b/tools/perf/util/pmu.h
index c14a543..d9e00d6 100644
--- a/tools/perf/util/pmu.h
+++ b/tools/perf/util/pmu.h
@@ -22,6 +22,16 @@ struct perf_pmu {
 	struct list_head list;
 };
 
+#define UNIT_MAX_LEN	31 /* max length for event unit name */
+
+struct perf_pmu_alias {
+	char *name;
+	struct list_head terms;
+	struct list_head list;
+	char unit[UNIT_MAX_LEN+1];
+	double scale;
+};
+
 struct perf_pmu *perf_pmu__find(const char *name);
 int perf_pmu__config(struct perf_pmu *pmu, struct perf_event_attr *attr,
 		     struct list_head *head_terms);
-- 
1.8.3.2

