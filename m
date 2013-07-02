Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756297Ab3GBTkG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Jul 2013 15:40:06 -0400
Received: from mail-pd0-f178.google.com ([209.85.192.178]:45758 "EHLO
	mail-pd0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754741Ab3GBT1q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Jul 2013 15:27:46 -0400
From: David Ahern <dsahern@gmail.com>
To: acme@ghostprotocols.net, linux-kernel@vger.kernel.org
Cc: David Ahern <dsahern@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Ingo Molnar <mingo@kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Namhyung Kim <namhyung@kernel.org>,
        Adrian Hunter <adrian.hunter@intel.com>
Subject: [PATCH 6/6] perf parse events: demystify memory allocations
Date: Tue,  2 Jul 2013 13:27:25 -0600
Message-Id: <1372793245-4136-7-git-send-email-dsahern@gmail.com>
X-Mailer: git-send-email 1.7.10.1
In-Reply-To: <1372793245-4136-1-git-send-email-dsahern@gmail.com>
References: <1372793245-4136-1-git-send-email-dsahern@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

List heads are currently allocated way down the function chain in __add_event
and add_tracepoint and then freed when the scanner code calls
parse_events_update_lists.

Be more explicit with where memory is allocated and who should free it. With
this patch the list_head is allocated in the scanner code and freed when the
scanner code calls parse_events_update_lists.

Signed-off-by: David Ahern <dsahern@gmail.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Adrian Hunter <adrian.hunter@intel.com>
---
 tools/perf/util/parse-events.c |   52 +++++++++++----------------------
 tools/perf/util/parse-events.h |   10 +++----
 tools/perf/util/parse-events.y |   62 ++++++++++++++++++++++++++--------------
 3 files changed, 61 insertions(+), 63 deletions(-)

diff --git a/tools/perf/util/parse-events.c b/tools/perf/util/parse-events.c
index 3a34f7b..8e3e270 100644
--- a/tools/perf/util/parse-events.c
+++ b/tools/perf/util/parse-events.c
@@ -264,40 +264,29 @@ const char *event_type(int type)
 
 
 
-static int __add_event(struct list_head **_list, int *idx,
+static int __add_event(struct list_head *list, int *idx,
 		       struct perf_event_attr *attr,
 		       char *name, struct cpu_map *cpus)
 {
 	struct perf_evsel *evsel;
-	struct list_head *list = *_list;
-
-	if (!list) {
-		list = malloc(sizeof(*list));
-		if (!list)
-			return -ENOMEM;
-		INIT_LIST_HEAD(list);
-	}
 
 	event_attr_init(attr);
 
 	evsel = perf_evsel__new(attr, (*idx)++);
-	if (!evsel) {
-		free(list);
+	if (!evsel)
 		return -ENOMEM;
-	}
 
 	evsel->cpus = cpus;
 	if (name)
 		evsel->name = strdup(name);
 	list_add_tail(&evsel->node, list);
-	*_list = list;
 	return 0;
 }
 
-static int add_event(struct list_head **_list, int *idx,
+static int add_event(struct list_head *list, int *idx,
 		     struct perf_event_attr *attr, char *name)
 {
-	return __add_event(_list, idx, attr, name, NULL);
+	return __add_event(list, idx, attr, name, NULL);
 }
 
 static int parse_aliases(char *str, const char *names[][PERF_EVSEL__MAX_ALIASES], int size)
@@ -318,7 +307,7 @@ static int parse_aliases(char *str, const char *names[][PERF_EVSEL__MAX_ALIASES]
 	return -1;
 }
 
-int parse_events_add_cache(struct list_head **list, int *idx,
+int parse_events_add_cache(struct list_head *list, int *idx,
 			   char *type, char *op_result1, char *op_result2)
 {
 	struct perf_event_attr attr;
@@ -379,31 +368,21 @@ int parse_events_add_cache(struct list_head **list, int *idx,
 	return add_event(list, idx, &attr, name);
 }
 
-static int add_tracepoint(struct list_head **listp, int *idx,
+static int add_tracepoint(struct list_head *list, int *idx,
 			  char *sys_name, char *evt_name)
 {
 	struct perf_evsel *evsel;
-	struct list_head *list = *listp;
-
-	if (!list) {
-		list = malloc(sizeof(*list));
-		if (!list)
-			return -ENOMEM;
-		INIT_LIST_HEAD(list);
-	}
 
 	evsel = perf_evsel__newtp(sys_name, evt_name, (*idx)++);
-	if (!evsel) {
-		free(list);
+	if (!evsel)
 		return -ENOMEM;
-	}
 
 	list_add_tail(&evsel->node, list);
-	*listp = list;
+
 	return 0;
 }
 
-static int add_tracepoint_multi_event(struct list_head **list, int *idx,
+static int add_tracepoint_multi_event(struct list_head *list, int *idx,
 				      char *sys_name, char *evt_name)
 {
 	char evt_path[MAXPATHLEN];
@@ -435,7 +414,7 @@ static int add_tracepoint_multi_event(struct list_head **list, int *idx,
 	return ret;
 }
 
-static int add_tracepoint_event(struct list_head **list, int *idx,
+static int add_tracepoint_event(struct list_head *list, int *idx,
 				char *sys_name, char *evt_name)
 {
 	return strpbrk(evt_name, "*?") ?
@@ -443,7 +422,7 @@ static int add_tracepoint_event(struct list_head **list, int *idx,
 	       add_tracepoint(list, idx, sys_name, evt_name);
 }
 
-static int add_tracepoint_multi_sys(struct list_head **list, int *idx,
+static int add_tracepoint_multi_sys(struct list_head *list, int *idx,
 				    char *sys_name, char *evt_name)
 {
 	struct dirent *events_ent;
@@ -475,7 +454,7 @@ static int add_tracepoint_multi_sys(struct list_head **list, int *idx,
 	return ret;
 }
 
-int parse_events_add_tracepoint(struct list_head **list, int *idx,
+int parse_events_add_tracepoint(struct list_head *list, int *idx,
 				char *sys, char *event)
 {
 	int ret;
@@ -530,7 +509,7 @@ do {					\
 	return 0;
 }
 
-int parse_events_add_breakpoint(struct list_head **list, int *idx,
+int parse_events_add_breakpoint(struct list_head *list, int *idx,
 				void *ptr, char *type)
 {
 	struct perf_event_attr attr;
@@ -611,7 +590,7 @@ static int config_attr(struct perf_event_attr *attr,
 	return 0;
 }
 
-int parse_events_add_numeric(struct list_head **list, int *idx,
+int parse_events_add_numeric(struct list_head *list, int *idx,
 			     u32 type, u64 config,
 			     struct list_head *head_config)
 {
@@ -644,7 +623,7 @@ static char *pmu_event_name(struct list_head *head_terms)
 	return NULL;
 }
 
-int parse_events_add_pmu(struct list_head **list, int *idx,
+int parse_events_add_pmu(struct list_head *list, int *idx,
 			 char *name, struct list_head *head_config)
 {
 	struct perf_event_attr attr;
@@ -687,6 +666,7 @@ void parse_events__set_leader(char *name, struct list_head *list)
 	leader->group_name = name ? strdup(name) : NULL;
 }
 
+/* list_event is assumed to point to malloc'ed memory */
 void parse_events_update_lists(struct list_head *list_event,
 			       struct list_head *list_all)
 {
diff --git a/tools/perf/util/parse-events.h b/tools/perf/util/parse-events.h
index 080f7cf..f1cb4c4 100644
--- a/tools/perf/util/parse-events.h
+++ b/tools/perf/util/parse-events.h
@@ -85,16 +85,16 @@ void parse_events__free_terms(struct list_head *terms);
 int parse_events__modifier_event(struct list_head *list, char *str, bool add);
 int parse_events__modifier_group(struct list_head *list, char *event_mod);
 int parse_events_name(struct list_head *list, char *name);
-int parse_events_add_tracepoint(struct list_head **list, int *idx,
+int parse_events_add_tracepoint(struct list_head *list, int *idx,
 				char *sys, char *event);
-int parse_events_add_numeric(struct list_head **list, int *idx,
+int parse_events_add_numeric(struct list_head *list, int *idx,
 			     u32 type, u64 config,
 			     struct list_head *head_config);
-int parse_events_add_cache(struct list_head **list, int *idx,
+int parse_events_add_cache(struct list_head *list, int *idx,
 			   char *type, char *op_result1, char *op_result2);
-int parse_events_add_breakpoint(struct list_head **list, int *idx,
+int parse_events_add_breakpoint(struct list_head *list, int *idx,
 				void *ptr, char *type);
-int parse_events_add_pmu(struct list_head **list, int *idx,
+int parse_events_add_pmu(struct list_head *list, int *idx,
 			 char *pmu , struct list_head *head_config);
 void parse_events__set_leader(char *name, struct list_head *list);
 void parse_events_update_lists(struct list_head *list_event,
diff --git a/tools/perf/util/parse-events.y b/tools/perf/util/parse-events.y
index afc44c1..4eb67ec 100644
--- a/tools/perf/util/parse-events.y
+++ b/tools/perf/util/parse-events.y
@@ -22,6 +22,13 @@ do { \
 		YYABORT; \
 } while (0)
 
+#define ALLOC_LIST(list) \
+do { \
+	list = malloc(sizeof(*list)); \
+	ABORT_ON(!list);              \
+	INIT_LIST_HEAD(list);         \
+} while (0)
+
 static inc_group_count(struct list_head *list,
 		       struct parse_events_evlist *data)
 {
@@ -196,9 +203,10 @@ event_pmu:
 PE_NAME '/' event_config '/'
 {
 	struct parse_events_evlist *data = _data;
-	struct list_head *list = NULL;
+	struct list_head *list;
 
-	ABORT_ON(parse_events_add_pmu(&list, &data->idx, $1, $3));
+	ALLOC_LIST(list);
+	ABORT_ON(parse_events_add_pmu(list, &data->idx, $1, $3));
 	parse_events__free_terms($3);
 	$$ = list;
 }
@@ -212,11 +220,12 @@ event_legacy_symbol:
 value_sym '/' event_config '/'
 {
 	struct parse_events_evlist *data = _data;
-	struct list_head *list = NULL;
+	struct list_head *list;
 	int type = $1 >> 16;
 	int config = $1 & 255;
 
-	ABORT_ON(parse_events_add_numeric(&list, &data->idx,
+	ALLOC_LIST(list);
+	ABORT_ON(parse_events_add_numeric(list, &data->idx,
 					  type, config, $3));
 	parse_events__free_terms($3);
 	$$ = list;
@@ -225,11 +234,12 @@ value_sym '/' event_config '/'
 value_sym sep_slash_dc
 {
 	struct parse_events_evlist *data = _data;
-	struct list_head *list = NULL;
+	struct list_head *list;
 	int type = $1 >> 16;
 	int config = $1 & 255;
 
-	ABORT_ON(parse_events_add_numeric(&list, &data->idx,
+	ALLOC_LIST(list);
+	ABORT_ON(parse_events_add_numeric(list, &data->idx,
 					  type, config, NULL));
 	$$ = list;
 }
@@ -238,27 +248,30 @@ event_legacy_cache:
 PE_NAME_CACHE_TYPE '-' PE_NAME_CACHE_OP_RESULT '-' PE_NAME_CACHE_OP_RESULT
 {
 	struct parse_events_evlist *data = _data;
-	struct list_head *list = NULL;
+	struct list_head *list;
 
-	ABORT_ON(parse_events_add_cache(&list, &data->idx, $1, $3, $5));
+	ALLOC_LIST(list);
+	ABORT_ON(parse_events_add_cache(list, &data->idx, $1, $3, $5));
 	$$ = list;
 }
 |
 PE_NAME_CACHE_TYPE '-' PE_NAME_CACHE_OP_RESULT
 {
 	struct parse_events_evlist *data = _data;
-	struct list_head *list = NULL;
+	struct list_head *list;
 
-	ABORT_ON(parse_events_add_cache(&list, &data->idx, $1, $3, NULL));
+	ALLOC_LIST(list);
+	ABORT_ON(parse_events_add_cache(list, &data->idx, $1, $3, NULL));
 	$$ = list;
 }
 |
 PE_NAME_CACHE_TYPE
 {
 	struct parse_events_evlist *data = _data;
-	struct list_head *list = NULL;
+	struct list_head *list;
 
-	ABORT_ON(parse_events_add_cache(&list, &data->idx, $1, NULL, NULL));
+	ALLOC_LIST(list);
+	ABORT_ON(parse_events_add_cache(list, &data->idx, $1, NULL, NULL));
 	$$ = list;
 }
 
@@ -266,9 +279,10 @@ event_legacy_mem:
 PE_PREFIX_MEM PE_VALUE ':' PE_MODIFIER_BP sep_dc
 {
 	struct parse_events_evlist *data = _data;
-	struct list_head *list = NULL;
+	struct list_head *list;
 
-	ABORT_ON(parse_events_add_breakpoint(&list, &data->idx,
+	ALLOC_LIST(list);
+	ABORT_ON(parse_events_add_breakpoint(list, &data->idx,
 					     (void *) $2, $4));
 	$$ = list;
 }
@@ -276,9 +290,10 @@ PE_PREFIX_MEM PE_VALUE ':' PE_MODIFIER_BP sep_dc
 PE_PREFIX_MEM PE_VALUE sep_dc
 {
 	struct parse_events_evlist *data = _data;
-	struct list_head *list = NULL;
+	struct list_head *list;
 
-	ABORT_ON(parse_events_add_breakpoint(&list, &data->idx,
+	ALLOC_LIST(list);
+	ABORT_ON(parse_events_add_breakpoint(list, &data->idx,
 					     (void *) $2, NULL));
 	$$ = list;
 }
@@ -287,9 +302,10 @@ event_legacy_tracepoint:
 PE_NAME ':' PE_NAME
 {
 	struct parse_events_evlist *data = _data;
-	struct list_head *list = NULL;
+	struct list_head *list;
 
-	ABORT_ON(parse_events_add_tracepoint(&list, &data->idx, $1, $3));
+	ALLOC_LIST(list);
+	ABORT_ON(parse_events_add_tracepoint(list, &data->idx, $1, $3));
 	$$ = list;
 }
 
@@ -297,9 +313,10 @@ event_legacy_numeric:
 PE_VALUE ':' PE_VALUE
 {
 	struct parse_events_evlist *data = _data;
-	struct list_head *list = NULL;
+	struct list_head *list;
 
-	ABORT_ON(parse_events_add_numeric(&list, &data->idx, (u32)$1, $3, NULL));
+	ALLOC_LIST(list);
+	ABORT_ON(parse_events_add_numeric(list, &data->idx, (u32)$1, $3, NULL));
 	$$ = list;
 }
 
@@ -307,9 +324,10 @@ event_legacy_raw:
 PE_RAW
 {
 	struct parse_events_evlist *data = _data;
-	struct list_head *list = NULL;
+	struct list_head *list;
 
-	ABORT_ON(parse_events_add_numeric(&list, &data->idx,
+	ALLOC_LIST(list);
+	ABORT_ON(parse_events_add_numeric(list, &data->idx,
 					  PERF_TYPE_RAW, $1, NULL));
 	$$ = list;
 }
-- 
1.7.10.1

