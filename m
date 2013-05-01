Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761405Ab3EAPRj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 May 2013 11:17:39 -0400
Received: from mx1.redhat.com ([209.132.183.28]:47018 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761462Ab3EAPRN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 May 2013 11:17:13 -0400
From: Jiri Olsa <jolsa@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Jiri Olsa <jolsa@redhat.com>, Andi Kleen <andi@firstfloor.org>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Namhyung Kim <namhyung@kernel.org>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Ulrich Drepper <drepper@gmail.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Will Deacon <will.deacon@arm.com>,
        Stephane Eranian <eranian@google.com>
Subject: [PATCH 3/8] perf tools: Add formula-* parsing support for events
Date: Wed,  1 May 2013 17:15:41 +0200
Message-Id: <1367421346-18257-4-git-send-email-jolsa@redhat.com>
In-Reply-To: <1367421346-18257-1-git-send-email-jolsa@redhat.com>
References: <1367421346-18257-1-git-send-email-jolsa@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adding a possibility to specify formula-$NAME within
the -e option same way as an event.

This adds only the functionality to parse  out the formula
names and populate string array within struct perf_evlist.

The formula processing itself will come in next patches.

Signed-off-by: Jiri Olsa <jolsa@redhat.com>
Cc: Andi Kleen <andi@firstfloor.org>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Ulrich Drepper <drepper@gmail.com>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Will Deacon <will.deacon@arm.com>
Cc: Stephane Eranian <eranian@google.com>
---
 tools/perf/util/evlist.h       |  5 +++++
 tools/perf/util/parse-events.c | 32 ++++++++++++++++++++++++++++++++
 tools/perf/util/parse-events.h |  3 +++
 tools/perf/util/parse-events.l | 10 +++++++++-
 tools/perf/util/parse-events.y | 34 ++++++++++++++++++++++++++++++++++
 5 files changed, 83 insertions(+), 1 deletion(-)

diff --git a/tools/perf/util/evlist.h b/tools/perf/util/evlist.h
index 0583d36..dbfb59f 100644
--- a/tools/perf/util/evlist.h
+++ b/tools/perf/util/evlist.h
@@ -42,6 +42,7 @@ struct perf_evlist {
 	struct thread_map *threads;
 	struct cpu_map	  *cpus;
 	struct perf_evsel *selected;
+	char		 **formulas;
 };
 
 struct perf_evsel_str_handler {
@@ -164,4 +165,8 @@ static inline void perf_mmap__write_tail(struct perf_mmap *md,
 	pc->data_tail = tail;
 }
 
+static inline bool perf_evlist__has_formulas(struct perf_evlist *evlist)
+{
+	return evlist->formulas != NULL;
+}
 #endif /* __PERF_EVLIST_H */
diff --git a/tools/perf/util/parse-events.c b/tools/perf/util/parse-events.c
index e8e9dc8..fe0a554 100644
--- a/tools/perf/util/parse-events.c
+++ b/tools/perf/util/parse-events.c
@@ -877,6 +877,7 @@ int parse_events(struct perf_evlist *evlist, const char *str)
 		int entries = data.idx - evlist->nr_entries;
 		perf_evlist__splice_list_tail(evlist, &data.list, entries);
 		evlist->nr_groups += data.nr_groups;
+		evlist->formulas = data.formulas;
 		return 0;
 	}
 
@@ -1239,6 +1240,31 @@ void parse_events__free_terms(struct list_head *terms)
 	free(terms);
 }
 
+static char **formula_add(char **f, char *new)
+{
+	int i;
+#define FORMULAS_CNT 20
+
+	if (!f) {
+		f = zalloc(sizeof(char *) * FORMULAS_CNT + 1);
+		if (!f)
+			return NULL;
+	}
+
+	for (i = 0; f[i] && (i < FORMULAS_CNT); i++);
+
+	if (i == FORMULAS_CNT) {
+		pr_err("Too many formula defined, max = %d\n",
+		       FORMULAS_CNT);
+		return NULL;
+	}
+
+	pr_debug("parse events: formula %s\n", new);
+
+	f[i] = new;
+	return f;
+}
+
 int parse_events_config_process(struct parse_events_evlist *data,
 				struct list_head *head)
 {
@@ -1249,6 +1275,12 @@ int parse_events_config_process(struct parse_events_evlist *data,
 		case PARSE_EVENTS_CONFIG_EVENTS:
 			parse_events_update_lists(cfg->events, &data->list);
 			break;
+		case PARSE_EVENTS_CONFIG_FORMULA:
+			data->formulas = formula_add(data->formulas,
+						     cfg->formula);
+			if (!data->formulas)
+				return -1;
+			break;
 		default:
 			break;
 		}
diff --git a/tools/perf/util/parse-events.h b/tools/perf/util/parse-events.h
index 98810f1..1b6c34d 100644
--- a/tools/perf/util/parse-events.h
+++ b/tools/perf/util/parse-events.h
@@ -63,6 +63,7 @@ struct parse_events_term {
 
 struct parse_events_evlist {
 	struct list_head list;
+	char **formulas;
 	int idx;
 	int nr_groups;
 };
@@ -73,6 +74,7 @@ struct parse_events_terms {
 
 enum parse_events_config_type {
 	PARSE_EVENTS_CONFIG_EVENTS,
+	PARSE_EVENTS_CONFIG_FORMULA,
 };
 
 struct parse_events_config {
@@ -80,6 +82,7 @@ struct parse_events_config {
 
 	union {
 		struct list_head *events;
+		char *formula;
 		void *val;
 	};
 
diff --git a/tools/perf/util/parse-events.l b/tools/perf/util/parse-events.l
index 5b4ef52..7d0d630 100644
--- a/tools/perf/util/parse-events.l
+++ b/tools/perf/util/parse-events.l
@@ -72,10 +72,12 @@ static int term(yyscan_t scanner, int type)
 %x mem
 %s config
 %x event
+%x formula
 
 group		[^,{}/]*[{][^}]*[}][^,{}/]*
 event_pmu	[^,{}/]+[/][^/]*[/][^,{}/]*
 event		[^,{}/]+
+formula		formula-[^,{}/]+
 
 num_dec		[0-9]+
 num_hex		0x[a-fA-F0-9]+
@@ -106,7 +108,7 @@ modifier_bp	[rwx]{1,3}
 %}
 
 <event>{
-
+{formula}	|
 {group}		{
 			BEGIN(INITIAL); yyless(0);
 		}
@@ -156,6 +158,11 @@ branch_type		{ return term(yyscanner, PARSE_EVENTS__TERM_TYPE_BRANCH_SAMPLE_TYPE
 <<EOF>>			{ BEGIN(INITIAL); }
 }
 
+<formula>{
+-			{ return '-'; }
+{name_minus}		{ BEGIN(INITIAL); return str(yyscanner, PE_FORMULA_NAME); }
+}
+
 cpu-cycles|cycles				{ return sym(yyscanner, PERF_TYPE_HARDWARE, PERF_COUNT_HW_CPU_CYCLES); }
 stalled-cycles-frontend|idle-cycles-frontend	{ return sym(yyscanner, PERF_TYPE_HARDWARE, PERF_COUNT_HW_STALLED_CYCLES_FRONTEND); }
 stalled-cycles-backend|idle-cycles-backend	{ return sym(yyscanner, PERF_TYPE_HARDWARE, PERF_COUNT_HW_STALLED_CYCLES_BACKEND); }
@@ -191,6 +198,7 @@ speculative-read|speculative-load	|
 refs|Reference|ops|access		|
 misses|miss				{ return str(yyscanner, PE_NAME_CACHE_OP_RESULT); }
 
+formula			{ BEGIN(formula); return PE_FORMULA; }
 mem:			{ BEGIN(mem); return PE_PREFIX_MEM; }
 r{num_raw_hex}		{ return raw(yyscanner); }
 {num_dec}		{ return value(yyscanner, 10); }
diff --git a/tools/perf/util/parse-events.y b/tools/perf/util/parse-events.y
index bae1879..ed2d174 100644
--- a/tools/perf/util/parse-events.y
+++ b/tools/perf/util/parse-events.y
@@ -55,6 +55,7 @@ static inc_group_count(struct list_head *list,
 %token PE_NAME_CACHE_TYPE PE_NAME_CACHE_OP_RESULT
 %token PE_PREFIX_MEM PE_PREFIX_RAW PE_PREFIX_GROUP
 %token PE_ERROR
+%token PE_FORMULA PE_FORMULA_NAME
 %type <num> PE_VALUE
 %type <num> PE_VALUE_SYM_HW
 %type <num> PE_VALUE_SYM_SW
@@ -66,6 +67,7 @@ static inc_group_count(struct list_head *list,
 %type <str> PE_MODIFIER_EVENT
 %type <str> PE_MODIFIER_BP
 %type <str> PE_EVENT_NAME
+%type <str> PE_FORMULA_NAME
 %type <num> value_sym
 %type <head> event_config
 %type <term> event_term
@@ -85,6 +87,8 @@ static inc_group_count(struct list_head *list,
 %type <head> group
 %type <head> groups
 %type <cfg> groups_config
+%type <cfg> groups_formula
+%type <str> formula
 
 %union
 {
@@ -118,6 +122,15 @@ groups ',' groups_config
 	$$ = head;
 }
 |
+groups ',' groups_formula
+{
+	struct list_head *head = $1;
+	struct parse_events_config *cfg = $3;
+
+	list_add_tail(&cfg->list, head);
+	$$ = head;
+}
+|
 groups_config
 {
 	struct list_head *head = HEAD();
@@ -126,6 +139,15 @@ groups_config
 	list_add_tail(&cfg->list, head);
 	$$ = head;
 }
+|
+groups_formula
+{
+	struct list_head *head = HEAD();
+	struct parse_events_config *cfg = $1;
+
+	list_add_tail(&cfg->list, head);
+	$$ = head;
+}
 
 groups_config:
 group
@@ -436,6 +458,18 @@ PE_TERM
 	$$ = term;
 }
 
+groups_formula:
+formula
+{
+	$$ = CONFIG(FORMULA, $1);
+}
+
+formula:
+PE_FORMULA '-' PE_FORMULA_NAME
+{
+	$$ = strdup($3);
+}
+
 sep_dc: ':' |
 
 sep_slash_dc: '/' | ':' |
-- 
1.7.11.7

