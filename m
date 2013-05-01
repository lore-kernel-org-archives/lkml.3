Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761463Ab3EAPSB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 May 2013 11:18:01 -0400
Received: from mx1.redhat.com ([209.132.183.28]:36005 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761462Ab3EAPRl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 May 2013 11:17:41 -0400
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
Subject: [PATCH 4/8] perf tools: Add formula interface to interface formula definitions
Date: Wed,  1 May 2013 17:15:42 +0200
Message-Id: <1367421346-18257-5-git-send-email-jolsa@redhat.com>
In-Reply-To: <1367421346-18257-1-git-send-email-jolsa@redhat.com>
References: <1367421346-18257-1-git-send-email-jolsa@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adding formula object to interface formula definitions like:

  set {
       events {
               CY = cycles
               IN = instructions
               BR = branches
       }

       cpi      = CY / IN
       bdensity = IN / BR

       print cpi
       print bdensity
  }

The 'set' defines set of counter that share same events.
Each 'set' defines:
  events   - event string that would go into stat -e option
  counters - any number of counters based on above events

Each event and counter is defined as an assignment (via =)
to the name(tag), which could be later used within counter
formulas.

Each counter (cpi/branch-rate above) defines formula that
produces the counter number.

Formula grammar:

  expr: '-' expr       |
        expr '+' expr  |
        expr '-' expr  |
        expr '*' expr  |
        expr '/' expr  |
        value          |
        name

  where name could be any event or counter name(tag), like:
  (considering the architectural events name patchset
   is included)

  set {
        events {
                IN = instructions
                R0 = cpu/OFFCORE_RESPONSE_0,offcore_rsp=OFFCORE_RESPONSE.(DMND_IFETCH|LLC_MISS_LOCAL)/
        }

        kinst     = IN / 1000
        llc_imiss = R0 / kinst

        print llc_imiss
  }

It's possible to enable counter to be displayed via 'print'
label on separate line. Only counters marked like that
will be displayed to the user.

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
 tools/perf/Makefile       |  11 +
 tools/perf/util/evlist.c  |  13 ++
 tools/perf/util/evlist.h  |   4 +
 tools/perf/util/formula.c | 513 ++++++++++++++++++++++++++++++++++++++++++++++
 tools/perf/util/formula.h | 137 +++++++++++++
 tools/perf/util/formula.l | 119 +++++++++++
 tools/perf/util/formula.y | 249 ++++++++++++++++++++++
 7 files changed, 1046 insertions(+)
 create mode 100644 tools/perf/util/formula.c
 create mode 100644 tools/perf/util/formula.h
 create mode 100644 tools/perf/util/formula.l
 create mode 100644 tools/perf/util/formula.y

diff --git a/tools/perf/Makefile b/tools/perf/Makefile
index b0f164b..bcbc524 100644
--- a/tools/perf/Makefile
+++ b/tools/perf/Makefile
@@ -326,8 +326,15 @@ $(OUTPUT)util/pmu-flex.c: util/pmu.l $(OUTPUT)util/pmu-bison.c
 $(OUTPUT)util/pmu-bison.c: util/pmu.y
 	$(QUIET_BISON)$(BISON) -v util/pmu.y -d -o $(OUTPUT)util/pmu-bison.c -p perf_pmu_
 
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
 
@@ -420,6 +427,7 @@ LIB_H += util/intlist.h
 LIB_H += util/perf_regs.h
 LIB_H += util/unwind.h
 LIB_H += util/vdso.h
+LIB_H += util/formula.h
 LIB_H += ui/helpline.h
 LIB_H += ui/progress.h
 LIB_H += ui/util.h
@@ -492,6 +500,9 @@ LIB_OBJS += $(OUTPUT)util/rblist.o
 LIB_OBJS += $(OUTPUT)util/intlist.o
 LIB_OBJS += $(OUTPUT)util/vdso.o
 LIB_OBJS += $(OUTPUT)util/stat.o
+LIB_OBJS += $(OUTPUT)util/formula.o
+LIB_OBJS += $(OUTPUT)util/formula-flex.o
+LIB_OBJS += $(OUTPUT)util/formula-bison.o
 
 LIB_OBJS += $(OUTPUT)ui/setup.o
 LIB_OBJS += $(OUTPUT)ui/helpline.o
diff --git a/tools/perf/util/evlist.c b/tools/perf/util/evlist.c
index f7c7278..ec69b2b 100644
--- a/tools/perf/util/evlist.c
+++ b/tools/perf/util/evlist.c
@@ -863,3 +863,16 @@ size_t perf_evlist__fprintf(struct perf_evlist *evlist, FILE *fp)
 
 	return printed + fprintf(fp, "\n");;
 }
+
+struct perf_evsel*
+perf_evlist__find_evsel_name(struct perf_evlist *evlist, char *name)
+{
+	struct perf_evsel *evsel;
+
+	list_for_each_entry(evsel, &evlist->entries, node) {
+		if (strstr(perf_evsel__name(evsel), name))
+			return evsel;
+	}
+
+	return NULL;
+}
diff --git a/tools/perf/util/evlist.h b/tools/perf/util/evlist.h
index dbfb59f..abf76a4 100644
--- a/tools/perf/util/evlist.h
+++ b/tools/perf/util/evlist.h
@@ -169,4 +169,8 @@ static inline bool perf_evlist__has_formulas(struct perf_evlist *evlist)
 {
 	return evlist->formulas != NULL;
 }
+
+struct perf_evsel*
+perf_evlist__find_evsel_name(struct perf_evlist *evlist, char *name);
+
 #endif /* __PERF_EVLIST_H */
diff --git a/tools/perf/util/formula.c b/tools/perf/util/formula.c
new file mode 100644
index 0000000..2edc720
--- /dev/null
+++ b/tools/perf/util/formula.c
@@ -0,0 +1,513 @@
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
+#define FORMULA_SET_ALL ((void *) -1)
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
+static int config_parse(struct perf_formula_file *file)
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
+static int counter_init(struct perf_formula_counter *counter)
+{
+	struct perf_formula_expr expr = {
+		.test_only = true,
+	};
+
+	return scanner_expr(counter->formula, &expr);
+}
+
+static int set_init(struct perf_formula_set *set)
+{
+	struct perf_formula_counter *counter;
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
+static int file_init(struct perf_formula_file *file)
+{
+	struct perf_formula_set *set;
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
+static void file_free(struct perf_formula_file *file)
+{
+	struct perf_formula_set *set;
+
+	list_for_each_entry(set, &file->head_sets, list) {
+		struct perf_formula_counter *counter;
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
+	struct perf_formula_file *file;
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
+	struct perf_formula_file *file;
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
+typedef int (*set_cb)(struct perf_formula_set *set, void *data);
+
+static int for_each_set(struct perf_formula *formula,
+			set_cb cb, void *data)
+{
+	struct perf_formula_file *file;
+
+	list_for_each_entry(file, &formula->head_files, list) {
+		struct perf_formula_set *set;
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
+
+struct find_set_data {
+	struct perf_formula_set *set;
+	char *name;
+};
+
+static int find_set_cb(struct perf_formula_set *set, void *data)
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
+struct perf_formula_set*
+perf_formula__set(struct perf_formula *f, char *name)
+{
+	struct find_set_data data = {
+		.name = name,
+	};
+
+	if (!strcmp(name, "all"))
+		return FORMULA_SET_ALL;
+
+	if (for_each_set(f, find_set_cb, &data))
+		return NULL;
+
+	return data.set;
+}
+
+static int eval_counter(struct perf_formula_counter *counter,
+			struct perf_formula_expr *expr)
+{
+	int ret;
+
+	ret = scanner_expr(counter->formula, expr);
+	if (!ret) {
+		counter->result = expr->result;
+		pr_debug2("formula counter eval %s = %F\n",
+			 counter->name, counter->result);
+	}
+
+	return ret;
+}
+
+static int eval_set_cb(struct perf_formula_set *set, void *data)
+{
+	struct perf_formula_expr *expr = data;
+	struct perf_formula_counter *counter;
+
+	expr->set = set;
+
+	pr_debug2("formula eval %s\n", set->name);
+
+	list_for_each_entry(counter, &set->head_counters, list) {
+		if (eval_counter(counter, expr)) {
+			pr_err("failed to eval counter %s\n",
+			        counter->name);
+			return CB_FAIL;
+		}
+
+		if (expr->print && counter->print)
+			fprintf(expr->file,
+				"%'18.8F %-25s\n",
+				counter->result, counter->name);
+	}
+
+	return CB_NEXT;
+}
+
+int perf_formula__eval(struct perf_formula *f,
+		       struct perf_formula_set *set,
+		       struct perf_formula_expr *expr)
+{
+	if (set != FORMULA_SET_ALL)
+		return eval_set_cb(set, expr);
+
+	return for_each_set(f, eval_set_cb, expr);
+}
+
+int perf_formula__print(FILE *file,
+			struct perf_formula *f,
+			struct perf_formula_set *set,
+			struct perf_evlist *evlist,
+			struct perf_formula_value **values)
+{
+	struct perf_formula_expr expr = {
+		.set = set,
+		.evlist = evlist,
+		.values = values,
+		.print = true,
+		.file = file,
+	};
+
+	return perf_formula__eval(f, set, &expr);
+}
+
+static int set_evlist(struct perf_formula_set *set,
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
+static int evlist_cb(struct perf_formula_set *set, void *data)
+{
+       struct perf_evlist *evlist = data;
+
+	if (set_evlist(set, evlist))
+		return CB_FAIL;
+
+	return CB_NEXT;
+}
+
+int perf_formula__evlist(struct perf_formula *f,
+			 struct perf_formula_set *set,
+			 struct perf_evlist *evlist)
+{
+	if (set != FORMULA_SET_ALL)
+		return set_evlist(set, evlist);
+
+	return for_each_set(f, evlist_cb, (void *) evlist);
+}
+
+static struct perf_formula_counter*
+set_counter(struct perf_formula_set *set, struct perf_formula_config *config)
+{
+	struct perf_formula_counter *counter;
+
+	counter = zalloc(sizeof(*counter));
+	if (!counter)
+		return NULL;
+
+	INIT_LIST_HEAD(&counter->list);
+	counter->name    = config->ass.name;
+	counter->formula = config->ass.value;
+	counter->set     = set;
+	counter->print   = false;
+
+	list_add_tail(&counter->list, &set->head_counters);
+	return counter;
+}
+
+static int
+set_events(struct perf_formula_set *set, struct perf_formula_config *config)
+{
+	struct perf_formula_config *event;
+#define MAX_EVENTS 4096
+	char buf[MAX_EVENTS];
+
+	/* grouped by default */
+	buf[0] = '{';
+	buf[1] = 0x0;
+
+	list_for_each_entry(event, &config->events, list) {
+		struct perf_formula_event *e;
+
+		e = zalloc(sizeof(*e));
+		if (!e)
+			goto out;
+
+		INIT_LIST_HEAD(&e->list);
+		e->name   = event->ass.name;
+		e->config = event->ass.value;
+		list_add_tail(&e->list, &set->head_events);
+
+		/* TODO length check */
+		strcat(buf, event->ass.value);
+
+		if (!list_is_last(&event->list, &config->events))
+			strcat(buf, ",");
+	}
+
+	strcat(buf, "}");
+	set->events = strdup(buf);
+	return 0;
+
+ out:
+	/* TODO free everything ;-) */
+	return -ENOMEM;
+}
+
+static int
+set_print(struct perf_formula_set *set, struct perf_formula_config *config)
+{
+	struct perf_formula_counter *counter;
+
+	list_for_each_entry(counter, &set->head_counters, list) {
+		if (!strcmp(counter->name, config->print)) {
+			counter->print = true;
+			return 0;
+		}
+	}
+
+	return -1;
+}
+
+struct perf_formula_set*
+perf_formula_set__new(char *name, struct list_head *head)
+{
+	struct perf_formula_set *set;
+	struct perf_formula_config *config;
+
+	set = zalloc(sizeof(*set));
+	if (!set)
+		return NULL;
+
+	INIT_LIST_HEAD(&set->list);
+	INIT_LIST_HEAD(&set->head_counters);
+	INIT_LIST_HEAD(&set->head_events);
+
+	list_for_each_entry(config, head, list) {
+		switch (config->type) {
+		case PERF_FORMULA_CONFIG_EVENTS:
+			if (set_events(set, config))
+				goto out;
+			break;
+
+		case PERF_FORMULA_CONFIG_PRINT:
+			if (set_print(set, config))
+				goto out;
+			break;
+
+		case PERF_FORMULA_CONFIG_ASS:
+			if (!set_counter(set, config))
+				goto out;
+			break;
+
+		default:
+			BUG_ON(1);
+		}
+	}
+
+	set->name = strdup(name);
+	return set;
+
+ out:
+	free(set);
+	return NULL;
+}
+
+static struct perf_evsel*
+resolve_evsel(struct perf_formula_expr *expr, char *name)
+{
+	struct perf_formula_set *set = expr->set;
+	struct perf_formula_event *e;
+
+	list_for_each_entry(e, &set->head_events, list) {
+		if (strcmp(e->name, name))
+			continue;
+
+		return perf_evlist__find_evsel_name(expr->evlist, e->config);
+	}
+
+	return NULL;
+}
+
+static struct perf_formula_counter*
+resolve_counter(struct perf_formula_expr *expr, char *name)
+{
+	struct perf_formula_set *set = expr->set;
+	struct perf_formula_counter *counter;
+
+	list_for_each_entry(counter, &set->head_counters, list) {
+		if (!strcmp(counter->name, name))
+			return counter;
+	}
+
+	return NULL;
+}
+
+double perf_formula_expr__resolve(struct perf_formula_expr *expr,
+				  char *name)
+{
+	struct perf_evsel *evsel;
+	double result = 0;
+
+	if (expr->test_only)
+		return 1;
+
+	evsel = resolve_evsel(expr, name);
+	if (evsel) {
+		struct perf_counts *counts = evsel->counts;
+		result = counts->aggr.val;
+	} else {
+		struct perf_formula_counter *counter;
+
+		counter = resolve_counter(expr, name);
+		if (counter)
+			result = counter->result;
+		else {
+			pr_err("formula: failed to resolve '%s'\n",
+			       name);
+			result = -1;
+		}
+	}
+
+	pr_debug2("formula resolve %s = %F\n", name, result);
+	return result;
+}
diff --git a/tools/perf/util/formula.h b/tools/perf/util/formula.h
new file mode 100644
index 0000000..90325ec
--- /dev/null
+++ b/tools/perf/util/formula.h
@@ -0,0 +1,137 @@
+#ifndef __PERF_FORMULA
+#define __PERF_FORMULA
+
+/*
+ * format:
+ * set {
+ *      events {
+ *              CY = cycles
+ *              IN = instructions
+ *              BR = branches
+ *      }
+ *
+ *      cpi      = CY / IN
+ *      bdensity = IN / BR
+ *
+ *      print cpi
+ *      print bdensity
+ * }
+ *
+ * TODO add following syntax:
+ *      print cpi = CY / IN
+ */
+
+#include <linux/list.h>
+#include "evlist.h"
+
+struct perf_formula {
+	struct list_head head_files;
+};
+
+struct perf_formula_file {
+	char *path;
+
+	struct list_head head_sets;
+	struct list_head list;
+};
+
+struct perf_formula_set {
+	char *name;
+	char *events;
+	bool  loaded;
+
+	struct list_head head_events;
+	struct list_head head_counters;
+	struct list_head list;
+};
+
+struct perf_formula_event {
+	char *name;
+	char *config;
+
+	struct perf_evsel *evsel;
+	struct list_head list;
+};
+
+struct perf_formula_counter {
+	char  *name;
+	char  *formula;
+	bool   print;
+	double result;
+
+	struct perf_formula_set *set;
+	struct list_head list;
+};
+
+struct perf_formula_value {
+	char   *name;
+	double *ptr;
+};
+
+struct perf_formula_expr {
+	bool   test_only;
+	bool   print;
+
+	double result;
+	FILE  *file;
+
+	struct perf_evlist         *evlist;
+	struct perf_formula_set    *set;
+	struct perf_formula_value **values;
+};
+
+struct perf_formula_ass {
+	char *name;
+	char *value;
+};
+
+struct perf_formula_config {
+	enum {
+		PERF_FORMULA_CONFIG_EVENTS,
+		PERF_FORMULA_CONFIG_PRINT,
+		PERF_FORMULA_CONFIG_ASS,
+	} type;
+
+	union {
+		struct perf_formula_counter *counter;
+		struct perf_formula_ass      ass;
+		struct list_head             events;
+		char                        *print;
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
+struct perf_formula_set*
+perf_formula__set(struct perf_formula *f, char *name);
+
+int perf_formula__evlist(struct perf_formula *f,
+			 struct perf_formula_set *set,
+			 struct perf_evlist *evlist);
+
+int perf_formula__print(FILE *file,
+			struct perf_formula *f,
+			struct perf_formula_set *set,
+			struct perf_evlist *evlist,
+			struct perf_formula_value **values);
+
+struct perf_formula_counter*
+perf_formula_counter__new(char *name, struct list_head *head);
+
+int perf_formula__eval(struct perf_formula *f,
+		       struct perf_formula_set *set,
+		       struct perf_formula_expr *expr);
+
+struct perf_formula_set*
+perf_formula_set__new(char *name, struct list_head *head);
+
+double perf_formula_expr__resolve(struct perf_formula_expr *expr,
+				  char *name);
+
+#endif /* __PERF_FORMULA */
diff --git a/tools/perf/util/formula.l b/tools/perf/util/formula.l
new file mode 100644
index 0000000..3e83a0e
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
+"="		{ BEGIN(config_eoln_str); return '='; }
+
+events		{ return PF_EVENTS; }
+print		{ return PF_PRINT; }
+{name}		{ return str(yyscanner, PF_NAME); }
+
+\n		{ }
+.		{ }
+}
+
+<config_eoln_str>{
+[^\n]+		{
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
+"("		{ return '('; }
+")"		{ return ')'; }
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
index 0000000..955264c
--- /dev/null
+++ b/tools/perf/util/formula.y
@@ -0,0 +1,249 @@
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
+	struct perf_formula_config *__config;			\
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
+%token PF_PRINT
+
+%type <str> PF_NAME
+%type <num> PF_VALUE
+%type <str> PF_EOLN_STR
+%type <head> set_def
+%type <config> set_token
+%type <config> events_def
+%type <config> ass
+%type <num> expr
+
+%union
+{
+	char *str;
+	double num;
+	struct list_head *head;
+	struct config *config;
+	struct perf_formula_counter *counter;
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
+	struct perf_formula_file *file = _data;
+	struct perf_formula_set *set;
+
+	set = perf_formula_set__new($1, $3);
+	ABORT_ON(!set);
+
+	list_add_tail(&set->list, &file->head_sets);
+}
+
+set_def:
+set_def set_token
+{
+	struct list_head *head = $1;
+	struct perf_formula_config *config = $2;
+
+	list_add_tail(&config->list, head);
+	$$ = head;
+}
+|
+set_token
+{
+	struct list_head *head = HEAD();
+	struct perf_formula_config *config = $1;
+
+	list_add_tail(&config->list, head);
+	$$ = head;
+}
+
+set_token:
+PF_EVENTS '{' events_def '}'
+{
+	$$ = $3;
+}
+|
+PF_PRINT PF_NAME
+{
+	struct perf_formula_config *config = CONFIG();
+
+	config->type  = PERF_FORMULA_CONFIG_PRINT;
+	config->print = strdup($2);
+
+	$$ = config;
+}
+|
+ass
+
+/*
+ * TODO add 'print ass' processing in here, like:
+ * ...
+ * |
+ * PF_PRINT ass
+ * {
+ * ...
+ * }
+ */
+
+events_def:
+events_def ass
+{
+	struct perf_formula_config *config = $1;
+	struct perf_formula_config *ass    = $2;
+
+	list_add_tail(&ass->list, &config->events);
+
+	$$ = config;
+}
+|
+ass
+{
+	struct perf_formula_config *config = CONFIG();
+	struct perf_formula_config *ass    = $1;
+
+	config->type = PERF_FORMULA_CONFIG_EVENTS;
+	INIT_LIST_HEAD(&config->events);
+	list_add_tail(&ass->list, &config->events);
+
+	$$ = config;
+}
+
+ass:
+PF_NAME '=' PF_EOLN_STR
+{
+	struct perf_formula_config *config = CONFIG();
+
+	config->type = PERF_FORMULA_CONFIG_ASS;
+	config->ass.name  = strdup($1);
+	config->ass.value = strdup($3);
+
+	$$ = config;
+}
+
+start_expr:
+expr
+{
+	struct perf_formula_expr *expr = _data;
+
+	expr->result = $1;
+}
+
+expr:
+PF_VALUE
+{
+	$$ = $1;
+	pr_debug2("value %F\n", $$);
+}
+|
+PF_NAME
+{
+	$$ = perf_formula_expr__resolve(_data, $1);
+}
+|
+'-' expr
+{
+	$$ = - $2;
+	pr_debug2("%F = - %F\n", $$, $2);
+}
+|
+expr '+' expr
+{
+	$$ = $1 + $3;
+	pr_debug2("%F = %F + %F\n", $$, $1, $3);
+}
+|
+expr '-' expr
+{
+	$$ = $1 - $3;
+	pr_debug2("%F = %F - %F\n", $$, $1, $3);
+}
+|
+expr '*' expr
+{
+	$$ = $1 * $3;
+	pr_debug2("%F = %F * %F\n", $$, $1, $3);
+}
+|
+expr '/' expr
+{
+	if (!$3) {
+		pr_debug2("formula division by zero\n");
+		struct perf_formula_expr *expr = _data;
+		expr->result = 0.0;
+		YYACCEPT;
+	}
+
+
+	$$ = $1 / $3;
+	pr_debug2("%F = %F / %F\n", $$, $1, $3);
+}
+|
+'(' expr ')'
+{
+	$$ = $2;
+	pr_debug2("( %F )\n", $$);
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

