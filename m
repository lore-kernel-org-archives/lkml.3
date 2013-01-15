Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756806Ab3AOOSi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2013 09:18:38 -0500
Received: from mx1.redhat.com ([209.132.183.28]:59503 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755648Ab3AOOSh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2013 09:18:37 -0500
From: Jiri Olsa <jolsa@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Jiri Olsa <jolsa@redhat.com>, Arnaldo Carvalho de Melo <acme@redhat.com>,
        Namhyung Kim <namhyung@kernel.org>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Andi Kleen <andi@firstfloor.org>, David Ahern <dsahern@gmail.com>,
        Ulrich Drepper <drepper@gmail.com>
Subject: [PATCH 2/4] perf tool: Add formula interface to interface ratio definitions
Date: Tue, 15 Jan 2013 14:39:52 +0100
Message-Id: <1358257194-8204-3-git-send-email-jolsa@redhat.com>
In-Reply-To: <1358257194-8204-1-git-send-email-jolsa@redhat.com>
References: <1358257194-8204-1-git-send-email-jolsa@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adding formula object to interface formula definitions like:

set {
        events = {cycles,instructions,branch-instructions}:u

        cpi {
                formula = cycles / instructions
                desc = cycles per instruction
        }

	branch-rate {
                formula = branch-instructions / instructions
                desc = branch rate
        }
}

The 'set' defines set of counter that share same events.
Each 'set' defines:
  events   - event string that would go into stat/record -e option
  counters - any number of counters based on above events

Each counter (cpi/branch-rate) defines
  formula - formula with that produce the counter number
            event names and numbers could be used
  desc    - text description of the counter

Interface:
  perf_formula__init
  - initialize perf_formula handler

  perf_formula__load
  - load file into the handler

  perf_formula__free
  - cleanup

  perf_formula__set
  - get 'set' handler

  perf_formula__evlist
  - update perf_evlist with needed events

  perf_formula__print
  - display output ratios

Signed-off-by: Jiri Olsa <jolsa@redhat.com>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Andi Kleen <andi@firstfloor.org>
Cc: David Ahern <dsahern@gmail.com>
Cc: Ulrich Drepper <drepper@gmail.com>
---
 tools/perf/Makefile       |  11 ++
 tools/perf/util/evlist.c  |  13 ++
 tools/perf/util/evlist.h  |   4 +
 tools/perf/util/formula.c | 387 ++++++++++++++++++++++++++++++++++++++++++++++
 tools/perf/util/formula.h | 113 ++++++++++++++
 tools/perf/util/formula.l | 119 ++++++++++++++
 tools/perf/util/formula.y | 248 +++++++++++++++++++++++++++++
 7 files changed, 895 insertions(+)
 create mode 100644 tools/perf/util/formula.c
 create mode 100644 tools/perf/util/formula.h
 create mode 100644 tools/perf/util/formula.l
 create mode 100644 tools/perf/util/formula.y

diff --git a/tools/perf/Makefile b/tools/perf/Makefile
index 103ed95..0f120a4 100644
--- a/tools/perf/Makefile
+++ b/tools/perf/Makefile
@@ -296,8 +296,15 @@ $(OUTPUT)util/pmu-flex.c: util/pmu.l $(OUTPUT)util/pmu-bison.c
 $(OUTPUT)util/pmu-bison.c: util/pmu.y
 	$(QUIET_BISON)$(BISON) -v util/pmu.y -d -o $(OUTPUT)util/pmu-bison.c
 
+$(OUTPUT)util/formula-flex.c: util/formula.l util/formula.y $(OUTPUT)util/formula-bison.c
+	$(QUIET_FLEX)$(FLEX) --header-file=$(OUTPUT)util/formula-flex.h $(PARSER_DEBUG_FLEX) -t util/formula.l > $(OUTPUT)util/formula-flex.c
+
+$(OUTPUT)util/formula-bison.c: util/formula.y
+	$(QUIET_BISON)$(BISON) -v util/formula.y -d $(PARSER_DEBUG_BISON) -o $(OUTPUT)util/formula-bison.c
+
 $(OUTPUT)util/parse-events.o: $(OUTPUT)util/parse-events-flex.c $(OUTPUT)util/parse-events-bison.c
 $(OUTPUT)util/pmu.o: $(OUTPUT)util/pmu-flex.c $(OUTPUT)util/pmu-bison.c
+$(OUTPUT)util/formula.o: $(OUTPUT)util/formula-flex.c $(OUTPUT)util/formula-bison.c
 
 LIB_FILE=$(OUTPUT)libperf.a
 
@@ -391,6 +398,7 @@ LIB_H += util/intlist.h
 LIB_H += util/perf_regs.h
 LIB_H += util/unwind.h
 LIB_H += util/vdso.h
+LIB_H += util/formula.h
 LIB_H += ui/helpline.h
 LIB_H += ui/progress.h
 LIB_H += ui/util.h
@@ -464,6 +472,9 @@ LIB_OBJS += $(OUTPUT)util/rblist.o
 LIB_OBJS += $(OUTPUT)util/intlist.o
 LIB_OBJS += $(OUTPUT)util/vdso.o
 LIB_OBJS += $(OUTPUT)util/stat.o
+LIB_OBJS += $(OUTPUT)util/formula.o
+LIB_OBJS += $(OUTPUT)util/formula-flex.o
+LIB_OBJS += $(OUTPUT)util/formula-bison.o
 
 LIB_OBJS += $(OUTPUT)ui/setup.o
 LIB_OBJS += $(OUTPUT)ui/helpline.o
diff --git a/tools/perf/util/evlist.c b/tools/perf/util/evlist.c
index dc8aee9..e1a6126 100644
--- a/tools/perf/util/evlist.c
+++ b/tools/perf/util/evlist.c
@@ -845,3 +845,16 @@ size_t perf_evlist__fprintf(struct perf_evlist *evlist, FILE *fp)
 
 	return printed + fprintf(fp, "\n");;
 }
+
+struct perf_evsel*
+perf_evlist__find_evsel_name(struct perf_evlist *evlist, char *name)
+{
+	struct perf_evsel *evsel;
+
+	list_for_each_entry(evsel, &evlist->entries, node) {
+		if (!strcmp(name, perf_evsel__name(evsel)))
+			return evsel;
+	}
+
+	return NULL;
+}
diff --git a/tools/perf/util/evlist.h b/tools/perf/util/evlist.h
index 457e235..a8630f2 100644
--- a/tools/perf/util/evlist.h
+++ b/tools/perf/util/evlist.h
@@ -135,4 +135,8 @@ static inline struct perf_evsel *perf_evlist__last(struct perf_evlist *evlist)
 }
 
 size_t perf_evlist__fprintf(struct perf_evlist *evlist, FILE *fp);
+
+struct perf_evsel*
+perf_evlist__find_evsel_name(struct perf_evlist *evlist, char *name);
+
 #endif /* __PERF_EVLIST_H */
diff --git a/tools/perf/util/formula.c b/tools/perf/util/formula.c
new file mode 100644
index 0000000..e9fa05b
--- /dev/null
+++ b/tools/perf/util/formula.c
@@ -0,0 +1,387 @@
+
+#include <linux/compiler.h>
+#include <stdio.h>
+#include "stat.h"
+#include "parse-events.h"
+#include "formula.h"
+#include "formula-bison.h"
+#define YY_EXTRA_TYPE int
+#include "formula-flex.h"
+
+#ifdef PARSER_DEBUG
+extern int perf_formula_debug;
+#endif
+int perf_formula_parse(void *_data, void *scanner);
+
+void perf_formula__init(struct perf_formula *f)
+{
+	memset(f, 0x0, sizeof(*f));
+	INIT_LIST_HEAD(&f->head_files);
+}
+
+static int scanner_expr(const char *str, void *data)
+{
+	YY_BUFFER_STATE buffer;
+	void *scanner;
+	int ret;
+
+	ret = perf_formula_lex_init_extra(PF_START_EXPR, &scanner);
+	if (ret)
+		return ret;
+
+	buffer = perf_formula__scan_string(str, scanner);
+
+#ifdef PARSER_DEBUG
+	perf_formula_debug = 1;
+#endif
+	ret = perf_formula_parse(data, scanner);
+
+	perf_formula__flush_buffer(buffer, scanner);
+	perf_formula__delete_buffer(buffer, scanner);
+	perf_formula_lex_destroy(scanner);
+	return ret;
+}
+
+static int scanner_config(FILE *file, void *data)
+{
+	void *scanner;
+	int ret;
+
+	ret = perf_formula_lex_init_extra(PF_START_CONFIG, &scanner);
+	if (ret)
+		return ret;
+
+	perf_formula_set_in(file, scanner);
+
+#ifdef PARSER_DEBUG
+	perf_formula_debug = 1;
+#endif
+	ret = perf_formula_parse(data, scanner);
+
+	perf_formula_lex_destroy(scanner);
+	return ret;
+}
+
+static int config_parse(struct perf_formula__file *file)
+{
+	FILE *f;
+	int ret;
+
+	f = fopen(file->path, "r");
+	if (!f)
+		return -EINVAL;
+
+	ret = scanner_config(f, file);
+
+	fclose(f);
+	return ret;
+}
+
+static int counter_init(struct perf_formula__counter *counter)
+{
+	struct perf_formula__expr expr = {
+		.test_only = true,
+	};
+
+	return scanner_expr(counter->formula, &expr);
+}
+
+static int set_init(struct perf_formula__set *set)
+{
+	struct perf_formula__counter *counter;
+	int ret = 0;
+
+	list_for_each_entry(counter, &set->head_counters, list) {
+		ret = counter_init(counter);
+		if (ret)
+			break;
+
+		counter->set = set;
+	}
+
+	return ret;
+}
+
+static int file_init(struct perf_formula__file *file)
+{
+	struct perf_formula__set *set;
+	int ret;
+
+	ret = config_parse(file);
+
+	list_for_each_entry(set, &file->head_sets, list) {
+		ret = set_init(set);
+		if (ret)
+			break;
+	}
+
+	return ret;
+}
+
+static void file_free(struct perf_formula__file *file)
+{
+	struct perf_formula__set *set;
+
+	list_for_each_entry(set, &file->head_sets, list) {
+		struct perf_formula__counter *counter;
+
+		list_for_each_entry(counter, &set->head_counters, list)
+			free(counter);
+
+		free(set);
+	}
+
+	free(file->path);
+	free(file);
+}
+
+int perf_formula__load(struct perf_formula *f, char *path)
+{
+	struct perf_formula__file *file;
+	int ret;
+
+	file = zalloc(sizeof(*file));
+	if (!file)
+		return -ENOMEM;
+
+	INIT_LIST_HEAD(&file->list);
+	INIT_LIST_HEAD(&file->head_sets);
+	file->path = strdup(path);
+
+	ret = file_init(file);
+	if (ret)
+		file_free(file);
+	else
+		list_add_tail(&file->list, &f->head_files);
+
+	return ret;
+}
+
+int perf_formula__free(struct perf_formula *f)
+{
+	struct perf_formula__file *file;
+
+	list_for_each_entry(file, &f->head_files, list)
+		file_free(file);
+
+	return 0;
+}
+
+enum {
+	CB_NEXT,
+	CB_OK,
+	CB_FAIL,
+};
+
+typedef int (*set_cb)(struct perf_formula__set *set, void *data);
+
+static int for_each_set(struct perf_formula *formula,
+			set_cb cb, void *data)
+{
+	struct perf_formula__file *file;
+
+	list_for_each_entry(file, &formula->head_files, list) {
+		struct perf_formula__set *set;
+
+		list_for_each_entry(set, &file->head_sets, list) {
+			int ret = cb(set, data);
+
+			if (ret == CB_NEXT)
+				continue;
+			else if (ret == CB_OK)
+				return 0;
+			else if (ret == CB_FAIL)
+				return -1;
+		}
+	}
+
+	return 0;
+}
+struct find_set_data {
+	struct perf_formula__set *set;
+	char *name;
+};
+
+static int find_set_cb(struct perf_formula__set *set, void *data)
+{
+	struct find_set_data *d = data;
+
+	if (strcmp(set->name, d->name))
+		return CB_NEXT;
+
+	d->set = set;
+	return CB_OK;
+}
+
+struct perf_formula__set*
+perf_formula__set(struct perf_formula *f, char *name)
+{
+	struct find_set_data data = {
+		.name = name,
+	};
+
+	if (for_each_set(f, find_set_cb, &data))
+		return NULL;
+
+	return data.set;
+}
+
+static int counter_print(FILE *out, struct perf_formula__counter *counter,
+			 struct perf_formula__expr *expr)
+{
+	int ret;
+
+	ret = scanner_expr(counter->formula, expr);
+
+	if (ret) {
+		fprintf(stderr, "failed to process counter %s\n",
+			counter->name);
+		return -1;
+	}
+
+	fprintf(out, "%'18.8F %-25s # %s\n",
+		expr->result, counter->name, counter->desc);
+
+	return ret;
+}
+
+int perf_formula__print(FILE *file,
+			struct perf_formula__set *set,
+			struct perf_evlist *evlist,
+			struct perf_formula__value **values)
+{
+	struct perf_formula__counter *counter;
+	struct perf_formula__expr expr = {
+		.evlist = evlist,
+		.values = values,
+	};
+
+	list_for_each_entry(counter, &set->head_counters, list)
+		if (counter_print(file, counter, &expr))
+			break;
+
+	fprintf(file, "\n");
+	return 0;
+}
+
+static int set_evlist(struct perf_formula__set *set,
+		      struct perf_evlist *evlist)
+{
+	struct perf_evlist *evlist_tmp = evlist;
+
+	if (set->loaded)
+		return 0;
+
+	if (parse_events(evlist_tmp, set->events))
+		return -1;
+
+	set->loaded = true;
+
+	return 0;
+}
+
+int perf_formula__evlist(struct perf_formula__set *set,
+			 struct perf_evlist *evlist)
+{
+	return set_evlist(set, evlist);
+}
+
+struct perf_formula__counter*
+perf_formula__counter_new(char *name, struct list_head *head)
+{
+	struct perf_formula__counter *counter;
+	struct perf_formula__config *config;
+
+	counter = zalloc(sizeof(*counter));
+	if (!counter)
+		return NULL;
+
+	INIT_LIST_HEAD(&counter->list);					\
+
+	list_for_each_entry(config, head, list) {
+		switch (config->type) {
+		case PERF_FORMULA__CONFIG_FORMULA:
+			counter->formula = config->formula;
+			break;
+
+		case PERF_FORMULA__CONFIG_DESC:
+			counter->desc = config->desc;
+			break;
+
+		case PERF_FORMULA__CONFIG_COUNTER:
+		case PERF_FORMULA__CONFIG_EVENTS:
+		default:
+			BUG_ON(1);
+		}
+	}
+
+	counter->name = strdup(name);
+	return counter;
+}
+
+struct perf_formula__set*
+perf_formula__set_new(char *name, struct list_head *head)
+{
+	struct perf_formula__set *set;
+	struct perf_formula__config *config;
+
+	set = zalloc(sizeof(*set));
+	if (!set)
+		return NULL;
+
+	INIT_LIST_HEAD(&set->list);
+	INIT_LIST_HEAD(&set->head_counters);
+
+	list_for_each_entry(config, head, list) {
+		struct perf_formula__counter *counter;
+
+		switch (config->type) {
+		case PERF_FORMULA__CONFIG_COUNTER:
+			counter = config->counter;
+
+			list_add_tail(&counter->list,
+				      &set->head_counters);
+			break;
+
+		case PERF_FORMULA__CONFIG_EVENTS:
+			if (set->events) {
+				free(set);
+				return NULL;
+			}
+
+			set->events = config->events;
+			break;
+
+		case PERF_FORMULA__CONFIG_FORMULA:
+		case PERF_FORMULA__CONFIG_DESC:
+		default:
+			BUG_ON(1);
+		}
+	}
+
+	set->name = strdup(name);
+	return set;
+}
+
+struct perf_stat {
+	struct stats	  res_stats[3];
+};
+
+double perf_formula__expr_resolve(struct perf_formula__expr *expr,
+				  char *name)
+{
+	struct perf_evsel *evsel;
+	double res = 0;
+
+	if (expr->test_only)
+		return 1;
+
+	evsel = perf_evlist__find_evsel_name(expr->evlist, name);
+	if (evsel) {
+		struct perf_stat *ps = evsel->priv;
+		res = avg_stats(&ps->res_stats[0]);
+	} else
+		pr_err("failed to resolve event '%s'\n", name);
+
+	return res;
+}
diff --git a/tools/perf/util/formula.h b/tools/perf/util/formula.h
new file mode 100644
index 0000000..e7d988b
--- /dev/null
+++ b/tools/perf/util/formula.h
@@ -0,0 +1,113 @@
+#ifndef __PERF_FORMULA
+#define __PERF_FORMULA
+
+/*
+ * format:
+ *
+ * IPC {
+ *    events = cycles,instructions
+ *
+ *    counter IPC {
+ *       formula = instructions/cycles
+ *       desc = krava
+ *    }
+ * }
+ *
+ */
+
+#include <linux/list.h>
+#include "evlist.h"
+
+struct perf_formula {
+	struct list_head head_files;
+};
+
+struct perf_formula__file {
+	char *path;
+
+	struct list_head head_sets;
+	struct list_head list;
+};
+
+struct perf_formula__set {
+	char *name;
+	char *events;
+	bool loaded;
+
+	struct list_head head_counters;
+	struct list_head list;
+};
+
+struct perf_formula__counter {
+	char *name;
+	char *formula;
+	char *desc;
+
+	struct perf_formula__set *set;
+
+	struct list_head list;
+};
+
+#define PERF_FORMULA__VALUE(n, p)	\
+{					\
+	.name = n,			\
+	.ptr  = p,			\
+}
+
+struct perf_formula__value {
+	char   *name;
+	double *ptr;
+};
+
+struct perf_formula__expr {
+	struct perf_evlist *evlist;
+	struct perf_formula__value **values;
+	double result;
+	bool test_only;
+};
+
+struct perf_formula__config {
+	enum {
+		PERF_FORMULA__CONFIG_COUNTER,
+		PERF_FORMULA__CONFIG_EVENTS,
+		PERF_FORMULA__CONFIG_FORMULA,
+		PERF_FORMULA__CONFIG_DESC,
+	} type;
+
+	union {
+		struct perf_formula__counter *counter;
+		char *events;
+		char *formula;
+		char *desc;
+	};
+
+	struct list_head list;
+};
+
+
+void perf_formula__init(struct perf_formula *f);
+
+int perf_formula__load(struct perf_formula *f, char *path);
+int perf_formula__free(struct perf_formula *f);
+
+struct perf_formula__set*
+perf_formula__set(struct perf_formula *f, char *name);
+
+int perf_formula__evlist(struct perf_formula__set *set,
+			 struct perf_evlist *evlist);
+
+int perf_formula__print(FILE *file,
+			struct perf_formula__set *set,
+			struct perf_evlist *evlist,
+			struct perf_formula__value **values);
+
+struct perf_formula__counter*
+perf_formula__counter_new(char *name, struct list_head *head);
+
+struct perf_formula__set*
+perf_formula__set_new(char *name, struct list_head *head);
+
+double perf_formula__expr_resolve(struct perf_formula__expr *expr,
+				  char *name);
+
+#endif /* __PERF_FORMULA */
diff --git a/tools/perf/util/formula.l b/tools/perf/util/formula.l
new file mode 100644
index 0000000..e7669a5
--- /dev/null
+++ b/tools/perf/util/formula.l
@@ -0,0 +1,119 @@
+
+%option reentrant
+%option bison-bridge
+%option prefix="perf_formula_"
+%option stack
+
+%{
+#include "formula-bison.h"
+#include "formula.h"
+
+char *perf_formula_get_text(yyscan_t yyscanner);
+YYSTYPE *perf_formula_get_lval(yyscan_t yyscanner);
+
+static int __value(YYSTYPE *yylval, char *str, int base, int token)
+{
+	double num;
+
+	errno = 0;
+	num = strtoull(str, NULL, base);
+	if (errno)
+		return PF_ERROR;
+
+	yylval->num = num;
+	return token;
+}
+
+static int value(yyscan_t scanner, int base)
+{
+	YYSTYPE *yylval = perf_formula_get_lval(scanner);
+	char *text = perf_formula_get_text(scanner);
+
+	return __value(yylval, text, base, PF_VALUE);
+}
+
+static int str(yyscan_t scanner, int token)
+{
+	YYSTYPE *yylval = perf_formula_get_lval(scanner);
+	char *text = perf_formula_get_text(scanner);
+
+	yylval->str = strdup(text);
+	return token;
+}
+
+%}
+
+num_dec		[0-9]+
+num_hex		0x[a-fA-F0-9]+
+name		[a-zA-Z_*?][a-zA-Z0-9_*?\.-]*
+
+%x config
+%x expr
+%x config_eoln_str
+
+%%
+
+%{
+	{
+		int start_token;
+
+		start_token = perf_formula_get_extra(yyscanner);
+
+		if (start_token == PF_START_CONFIG)
+			BEGIN(config);
+		else if (start_token == PF_START_EXPR)
+			BEGIN(expr);
+
+		if (start_token) {
+			perf_formula_set_extra(NULL, yyscanner);
+			return start_token;
+		}
+	}
+%}
+
+<config>{
+"{"		{ return '{'; }
+"}"		{ return '}'; }
+"="		{ return '='; }
+
+events		{ BEGIN(config_eoln_str); return PF_EVENTS; }
+formula		{ BEGIN(config_eoln_str); return PF_FORMULA; }
+desc		{ BEGIN(config_eoln_str); return PF_DESC; }
+
+{name}		{ return str(yyscanner, PF_NAME); }
+
+\n		{ }
+}
+
+<config_eoln_str>{
+[ \t]*=		{ return '='; }
+[^=\n]+		{
+			str(yyscanner, PF_EOLN_STR);
+			BEGIN(config);
+			return PF_EOLN_STR;
+                }
+
+<<EOF>>		{
+			BEGIN(config);
+		}
+}
+
+<expr>{
+"*"		{ return '*'; }
+"-"		{ return '-'; }
+"+"		{ return '+'; }
+"/"		{ return '/'; }
+
+{name}		{ return str(yyscanner, PF_NAME); }
+{num_dec}	{ return value(yyscanner, 10); }
+{num_hex}	{ return value(yyscanner, 16); }
+
+.		{ }
+}
+
+%%
+
+int perf_formula_wrap(void *scanner __maybe_unused)
+{
+	return 1;
+}
diff --git a/tools/perf/util/formula.y b/tools/perf/util/formula.y
new file mode 100644
index 0000000..42b6ebf
--- /dev/null
+++ b/tools/perf/util/formula.y
@@ -0,0 +1,248 @@
+%pure-parser
+%name-prefix "perf_formula_"
+%parse-param {void *_data}
+%parse-param {void *scanner}
+%lex-param {void* scanner}
+
+%left '+' '-' '*' '/'
+
+%{
+
+#define YYDEBUG 1
+
+#include "util.h"
+#include "formula.h"
+#include "formula-bison.h"
+
+extern int formula_lex(YYSTYPE* lvalp, void* scanner);
+
+
+#define ABORT() YYABORT
+
+#define ABORT_ON(val) \
+do { \
+	if (val) \
+		YYABORT; \
+} while (0)
+
+#define HEAD() ({						\
+	struct list_head *__head = zalloc(sizeof(*__head));	\
+	ABORT_ON(!__head);					\
+	INIT_LIST_HEAD(__head);					\
+	__head;							\
+})
+
+#define CONFIG() ({						\
+	struct perf_formula__config *__config;			\
+	__config = zalloc(sizeof(*__config));			\
+	ABORT_ON(!__config);					\
+	INIT_LIST_HEAD(&__config->list);			\
+	__config;						\
+})
+
+%}
+
+%token PF_START_CONFIG PF_START_EXPR
+%token PF_NAME
+%token PF_VALUE
+%token PF_FORMULA
+%token PF_DESC
+%token PF_EVENTS
+%token PF_EOLN_STR
+%token PF_ERROR
+
+%type <str> PF_NAME
+%type <num> PF_VALUE
+%type <str> PF_EOLN_STR
+%type <head> set_def
+%type <head> counter_def
+%type <config> set_token
+%type <config> counter_token
+%type <counter> counter
+%type <num> expr
+
+%union
+{
+	char *str;
+	double num;
+	struct list_head *head;
+	struct config *config;
+	struct perf_formula__counter *counter;
+}
+
+%%
+
+start:
+PF_START_CONFIG start_config
+|
+PF_START_EXPR start_expr
+
+start_config: sets
+
+sets:
+sets set | set
+
+set:
+PF_NAME '{' set_def '}'
+{
+	struct perf_formula__file *file = _data;
+	struct perf_formula__set *set;
+
+	set = perf_formula__set_new($1, $3);
+	ABORT_ON(!set);
+
+	list_add_tail(&set->list, &file->head_sets);
+}
+
+set_def:
+set_def set_token
+{
+	struct list_head *head = $1;
+	struct perf_formula__config *config = $2;
+
+	list_add_tail(&config->list, head);
+	$$ = head;
+}
+|
+set_token
+{
+	struct list_head *head = HEAD();
+	struct perf_formula__config *config = $1;
+
+	list_add_tail(&config->list, head);
+	$$ = head;
+}
+
+set_token:
+counter
+{
+	struct perf_formula__config *config = CONFIG();
+
+	config->type = PERF_FORMULA__CONFIG_COUNTER;
+	config->counter = $1;
+
+	$$ = config;
+}
+|
+PF_EVENTS '=' PF_EOLN_STR
+{
+	struct perf_formula__config *config = CONFIG();
+
+	config->type = PERF_FORMULA__CONFIG_EVENTS;
+	config->counter = $3;
+
+	$$ = config;
+}
+
+counter:
+PF_NAME '{' counter_def '}'
+{
+	struct perf_formula__counter *counter;
+	struct config *config;
+
+	counter = perf_formula__counter_new($1, $3);
+	ABORT_ON(!counter);
+
+	$$ = counter;
+}
+
+counter_def:
+counter_def counter_token
+{
+	struct list_head *head = $1;
+	struct perf_formula__config *config = $2;
+
+	list_add_tail(&config->list, head);
+	$$ = head;
+}
+|
+counter_token
+{
+	struct list_head *head = HEAD();
+	struct perf_formula__config *config = $1;
+
+	list_add_tail(&config->list, head);
+	$$ = head;
+}
+
+counter_token:
+PF_FORMULA '=' PF_EOLN_STR
+{
+	struct perf_formula__config *config = CONFIG();
+
+	config->type = PERF_FORMULA__CONFIG_FORMULA;
+	config->counter = $3;
+
+	$$ = config;
+}
+|
+PF_DESC '=' PF_EOLN_STR
+{
+	struct perf_formula__config *config = CONFIG();
+
+	config->type = PERF_FORMULA__CONFIG_DESC;
+	config->counter = $3;
+
+	$$ = config;
+}
+
+start_expr:
+expr
+{
+	struct perf_formula__expr *expr = _data;
+
+	expr->result = $1;
+}
+
+expr:
+PF_VALUE
+{
+	$$ = $1;
+}
+|
+PF_NAME
+{
+	$$ = perf_formula__expr_resolve(_data, $1);
+}
+|
+'-' expr
+{
+	$$ = - $2;
+}
+|
+expr '+' expr
+{
+	$$ = $1 + $3;
+}
+|
+expr '-' expr
+{
+	$$ = $1 - $3;
+}
+|
+expr '*' expr
+{
+	$$ = $1 * $3;
+}
+|
+expr '/' expr
+{
+	if (!$3) {
+		pr_err("division by zero\n");
+		ABORT();
+	}
+
+	$$ = $1 / $3;
+}
+|
+'(' expr ')'
+{
+}
+
+%%
+
+void perf_formula_error(void *data __maybe_unused,
+			void *scanner __maybe_unused,
+			char const *msg __maybe_unused)
+{
+}
-- 
1.7.11.7

