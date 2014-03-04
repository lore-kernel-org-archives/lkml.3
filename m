Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756220AbaCDCnw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Mar 2014 21:43:52 -0500
Received: from LGEMRELSE6Q.lge.com ([156.147.1.121]:56478 "EHLO
	lgemrelse6q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756112AbaCDCmV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Mar 2014 21:42:21 -0500
X-Original-SENDERIP: 10.177.220.181
X-Original-MAILFROM: namhyung@kernel.org
From: Namhyung Kim <namhyung@kernel.org>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@kernel.org>,
        Paul Mackerras <paulus@samba.org>, Namhyung Kim <namhyung.kim@lge.com>,
        Namhyung Kim <namhyung@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, Jiri Olsa <jolsa@redhat.com>,
        David Ahern <dsahern@gmail.com>, Andi Kleen <andi@firstfloor.org>
Subject: [PATCH 09/10] perf report: Add -F option to specify output fields
Date: Tue,  4 Mar 2014 11:42:15 +0900
Message-Id: <1393900936-22977-10-git-send-email-namhyung@kernel.org>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1393900936-22977-1-git-send-email-namhyung@kernel.org>
References: <1393900936-22977-1-git-send-email-namhyung@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The -F/--field option is to allow user setup output field in any
order.  It can recieve any sort keys and following (hpp) fields:

  overhead, overhead_sys, overhead_us, sample and period

If guest profiling is enabled, overhead_guest_{sys,us} will be
available too.

The output fields also affect sort order unless you give -s/--sort
option.  And any keys specified on -s option, will also be added to
the output field list automatically.

  $ perf report -F sym,sample,overhead
  ...
  #                     Symbol       Samples  Overhead
  # ..........................  ............  ........
  #
    [.] __cxa_atexit                       2     2.50%
    [.] __libc_csu_init                    4     5.00%
    [.] __new_exitfn                       3     3.75%
    [.] _dl_check_map_versions             1     1.25%
    [.] _dl_name_match_p                   4     5.00%
    [.] _dl_setup_hash                     1     1.25%
    [.] _dl_sysdep_start                   1     1.25%
    [.] _init                              5     6.25%
    [.] _setjmp                            6     7.50%
    [.] a                                  8    10.00%
    [.] b                                  8    10.00%
    [.] brk                                1     1.25%
    [.] c                                  8    10.00%

Note that, the example output above is captured after applying next
patch which fixes sort/comparing behavior.

Requested-by: Ingo Molnar <mingo@kernel.org>
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
---
 tools/perf/Documentation/perf-report.txt |  10 +++
 tools/perf/builtin-report.c              |   8 ++
 tools/perf/ui/hist.c                     |  43 ++++++++--
 tools/perf/util/hist.h                   |   5 ++
 tools/perf/util/sort.c                   | 135 ++++++++++++++++++++++++++++++-
 tools/perf/util/sort.h                   |   2 +
 6 files changed, 193 insertions(+), 10 deletions(-)

diff --git a/tools/perf/Documentation/perf-report.txt b/tools/perf/Documentation/perf-report.txt
index 09af66298564..77796d72361b 100644
--- a/tools/perf/Documentation/perf-report.txt
+++ b/tools/perf/Documentation/perf-report.txt
@@ -98,6 +98,16 @@ OPTIONS
 	And default sort keys are changed to comm, dso_from, symbol_from, dso_to
 	and symbol_to, see '--branch-stack'.
 
+-F::
+--field=::
+	Specify output field - multiple keys can be specified in CSV format.
+	Following fields are available:
+	overhead, overhead_sys, overhead_us, sample and period.
+	Also it can contain any sort key(s).
+
+	By default, every sort keys not specified in -F will be appended
+	automatically.
+
 -p::
 --parent=<regex>::
         A regex filter to identify parent. The parent is a caller of this
diff --git a/tools/perf/builtin-report.c b/tools/perf/builtin-report.c
index ca9a7fd2780e..accacb29f052 100644
--- a/tools/perf/builtin-report.c
+++ b/tools/perf/builtin-report.c
@@ -772,6 +772,8 @@ int cmd_report(int argc, const char **argv, const char *prefix __maybe_unused)
 		   " dso_to, dso_from, symbol_to, symbol_from, mispredict,"
 		   " weight, local_weight, mem, symbol_daddr, dso_daddr, tlb, "
 		   "snoop, locked, abort, in_tx, transaction"),
+	OPT_STRING('F', "field", &field_order, "key[,keys...]",
+		   "output field(s): overhead, period, sample plus all of sort keys"),
 	OPT_BOOLEAN(0, "showcpuutilization", &symbol_conf.show_cpu_utilization,
 		    "Show sample percentage for different cpu modes"),
 	OPT_STRING('p', "parent", &parent_pattern, "regex",
@@ -975,6 +977,12 @@ repeat:
 
 	sort__setup_elide(stdout);
 
+	if (setup_output_field() < 0) {
+		parse_options_usage(report_usage, options, "F", 1);
+		goto error;
+	}
+
+
 	ret = __cmd_report(&report);
 	if (ret == K_SWITCH_INPUT_DATA) {
 		perf_session__delete(session);
diff --git a/tools/perf/ui/hist.c b/tools/perf/ui/hist.c
index 8b7eb052a432..c5cf6c1d73dd 100644
--- a/tools/perf/ui/hist.c
+++ b/tools/perf/ui/hist.c
@@ -339,8 +339,6 @@ LIST_HEAD(perf_hpp__sort_list);
 #undef __HPP_ENTRY_RAW_FN
 
 
-void perf_hpp__setup_output_field(void);
-
 void perf_hpp__init(void)
 {
 	struct list_head *list;
@@ -356,6 +354,12 @@ void perf_hpp__init(void)
 			INIT_LIST_HEAD(&fmt->sort_list);
 	}
 
+	/*
+	 * If user specified field order, no need to setup default fields.
+	 */
+	if (field_order)
+		return;
+
 	perf_hpp__column_enable(PERF_HPP__OVERHEAD);
 
 	if (symbol_conf.show_cpu_utilization) {
@@ -378,8 +382,6 @@ void perf_hpp__init(void)
 	list = &perf_hpp__format[PERF_HPP__OVERHEAD].sort_list;
 	if (list_empty(list))
 		list_add(list, &perf_hpp__sort_list);
-
-	perf_hpp__setup_output_field();
 }
 
 void perf_hpp__column_register(struct perf_hpp_fmt *format)
@@ -404,8 +406,37 @@ void perf_hpp__setup_output_field(void)
 
 	/* append sort keys to output field */
 	perf_hpp__for_each_sort_list(fmt) {
-		if (list_empty(&fmt->list))
-			perf_hpp__column_register(fmt);
+		if (!list_empty(&fmt->list))
+			continue;
+
+		/*
+		 * sort entry fields are dynamically created,
+		 * so they can share a same sort key even though
+		 * the list is empty.
+		 */
+		if (perf_hpp__is_sort_entry(fmt)) {
+			struct perf_hpp_fmt *pos;
+
+			perf_hpp__for_each_format(pos) {
+				if (perf_hpp__same_sort_entry(pos, fmt))
+					goto next;
+			}
+		}
+
+		perf_hpp__column_register(fmt);
+next:
+		;
+	}
+}
+
+void perf_hpp__append_sort_keys(void)
+{
+	struct perf_hpp_fmt *fmt;
+
+	/* append sort keys to output field */
+	perf_hpp__for_each_format(fmt) {
+		if (list_empty(&fmt->sort_list))
+			perf_hpp__register_sort_field(fmt);
 	}
 }
 
diff --git a/tools/perf/util/hist.h b/tools/perf/util/hist.h
index 7e32d7c2341a..298c8502bb7f 100644
--- a/tools/perf/util/hist.h
+++ b/tools/perf/util/hist.h
@@ -189,6 +189,11 @@ void perf_hpp__init(void);
 void perf_hpp__column_register(struct perf_hpp_fmt *format);
 void perf_hpp__column_enable(unsigned col);
 void perf_hpp__register_sort_field(struct perf_hpp_fmt *format);
+void perf_hpp__setup_output_field(void);
+void perf_hpp__append_sort_keys(void);
+
+bool perf_hpp__is_sort_entry(struct perf_hpp_fmt *format);
+bool perf_hpp__same_sort_entry(struct perf_hpp_fmt *a, struct perf_hpp_fmt *b);
 
 typedef u64 (*hpp_field_fn)(struct hist_entry *he);
 typedef int (*hpp_callback_fn)(struct perf_hpp *hpp, bool front);
diff --git a/tools/perf/util/sort.c b/tools/perf/util/sort.c
index 916652af8304..39f8f36fc37a 100644
--- a/tools/perf/util/sort.c
+++ b/tools/perf/util/sort.c
@@ -9,6 +9,7 @@ const char	default_parent_pattern[] = "^sys_|^do_page_fault";
 const char	*parent_pattern = default_parent_pattern;
 const char	default_sort_order[] = "comm,dso,symbol";
 const char	*sort_order = default_sort_order;
+const char	*field_order;
 regex_t		ignore_callees_regex;
 int		have_ignore_callees = 0;
 int		sort__need_collapse = 0;
@@ -1053,6 +1054,20 @@ struct hpp_sort_entry {
 	struct sort_entry *se;
 };
 
+bool perf_hpp__same_sort_entry(struct perf_hpp_fmt *a, struct perf_hpp_fmt *b)
+{
+	struct hpp_sort_entry *hse_a;
+	struct hpp_sort_entry *hse_b;
+
+	if (!perf_hpp__is_sort_entry(a) || !perf_hpp__is_sort_entry(b))
+		return false;
+
+	hse_a = container_of(a, struct hpp_sort_entry, hpp);
+	hse_b = container_of(b, struct hpp_sort_entry, hpp);
+
+	return hse_a->se == hse_b->se;
+}
+
 static int __sort__hpp_header(struct perf_hpp_fmt *fmt, struct perf_hpp *hpp,
 			      struct perf_evsel *evsel)
 {
@@ -1088,14 +1103,15 @@ static int __sort__hpp_entry(struct perf_hpp_fmt *fmt, struct perf_hpp *hpp,
 	return hse->se->se_snprintf(he, hpp->buf, hpp->size, len);
 }
 
-static int __sort_dimension__add_hpp(struct sort_dimension *sd)
+static struct hpp_sort_entry *
+__sort_dimension__alloc_hpp(struct sort_dimension *sd)
 {
 	struct hpp_sort_entry *hse;
 
 	hse = malloc(sizeof(*hse));
 	if (hse == NULL) {
 		pr_err("Memory allocation failed\n");
-		return -1;
+		return NULL;
 	}
 
 	hse->se = sd->entry;
@@ -1106,21 +1122,47 @@ static int __sort_dimension__add_hpp(struct sort_dimension *sd)
 
 	hse->hpp.cmp = sd->entry->se_cmp;
 	hse->hpp.collapse = sd->entry->se_collapse ? : sd->entry->se_cmp;
-	hse->hpp.sort = hse->hpp.collapse;
+	hse->hpp.sort = sd->entry->se_sort ? : hse->hpp.collapse;
 
 	INIT_LIST_HEAD(&hse->hpp.list);
 	INIT_LIST_HEAD(&hse->hpp.sort_list);
 
+	return hse;
+}
+
+bool perf_hpp__is_sort_entry(struct perf_hpp_fmt *format)
+{
+	return format->header == __sort__hpp_header;
+}
+
+static int __sort_dimension__add_hpp_sort(struct sort_dimension *sd)
+{
+	struct hpp_sort_entry *hse = __sort_dimension__alloc_hpp(sd);
+
+	if (hse == NULL)
+		return -1;
+
 	perf_hpp__register_sort_field(&hse->hpp);
 	return 0;
 }
 
+static int __sort_dimension__add_hpp_output(struct sort_dimension *sd)
+{
+	struct hpp_sort_entry *hse = __sort_dimension__alloc_hpp(sd);
+
+	if (hse == NULL)
+		return -1;
+
+	perf_hpp__column_register(&hse->hpp);
+	return 0;
+}
+
 static int __sort_dimension__add(struct sort_dimension *sd, enum sort_type idx)
 {
 	if (sd->taken)
 		return 0;
 
-	if (__sort_dimension__add_hpp(sd) < 0)
+	if (__sort_dimension__add_hpp_sort(sd) < 0)
 		return -1;
 
 	if (sd->entry->se_collapse)
@@ -1223,6 +1265,9 @@ int setup_sorting(void)
 	char *tmp, *tok, *str = strdup(sort_order);
 	int ret = 0;
 
+	if (field_order && sort_order == default_sort_order)
+		goto out;
+
 	if (str == NULL) {
 		error("Not enough memory to setup sort keys");
 		return -ENOMEM;
@@ -1240,6 +1285,7 @@ int setup_sorting(void)
 		}
 	}
 
+out:
 	free(str);
 	return ret;
 }
@@ -1307,3 +1353,84 @@ void sort__setup_elide(FILE *output)
 	list_for_each_entry(se, &hist_entry__sort_list, list)
 		se->elide = false;
 }
+
+static int output_field_add(char *tok)
+{
+	unsigned int i;
+
+	for (i = 0; i < ARRAY_SIZE(common_sort_dimensions); i++) {
+		struct sort_dimension *sd = &common_sort_dimensions[i];
+
+		if (strncasecmp(tok, sd->name, strlen(tok)))
+			continue;
+
+		return __sort_dimension__add_hpp_output(sd);
+	}
+
+	for (i = 0; i < ARRAY_SIZE(hpp_sort_dimensions); i++) {
+		struct hpp_dimension *hd = &hpp_sort_dimensions[i];
+
+		if (strncasecmp(tok, hd->name, strlen(tok)))
+			continue;
+
+		perf_hpp__column_register(hd->fmt);
+		return 0;
+	}
+
+	for (i = 0; i < ARRAY_SIZE(bstack_sort_dimensions); i++) {
+		struct sort_dimension *sd = &bstack_sort_dimensions[i];
+
+		if (strncasecmp(tok, sd->name, strlen(tok)))
+			continue;
+
+		return __sort_dimension__add_hpp_output(sd);
+	}
+
+	for (i = 0; i < ARRAY_SIZE(memory_sort_dimensions); i++) {
+		struct sort_dimension *sd = &memory_sort_dimensions[i];
+
+		if (strncasecmp(tok, sd->name, strlen(tok)))
+			continue;
+
+		return __sort_dimension__add(sd, i + __SORT_MEMORY_MODE);
+	}
+
+	return -ESRCH;
+}
+
+int setup_output_field(void)
+{
+	char *tmp, *tok, *str;
+	int ret = 0;
+
+	if (field_order == NULL)
+		goto out;
+
+	str = strdup(field_order);
+	if (str == NULL) {
+		error("Not enough memory to setup output fields");
+		return -ENOMEM;
+	}
+
+	for (tok = strtok_r(str, ", ", &tmp);
+			tok; tok = strtok_r(NULL, ", ", &tmp)) {
+		ret = output_field_add(tok);
+		if (ret == -EINVAL) {
+			error("Invalid --field key: `%s'", tok);
+			break;
+		} else if (ret == -ESRCH) {
+			error("Unknown --field key: `%s'", tok);
+			break;
+		}
+	}
+
+	free(str);
+
+out:
+	/* copy sort keys to output fields */
+	perf_hpp__setup_output_field();
+	/* and then copy output fields to sort keys */
+	perf_hpp__append_sort_keys();
+
+	return ret;
+}
diff --git a/tools/perf/util/sort.h b/tools/perf/util/sort.h
index 43e5ff42a609..ba65741783fa 100644
--- a/tools/perf/util/sort.h
+++ b/tools/perf/util/sort.h
@@ -25,6 +25,7 @@
 
 extern regex_t parent_regex;
 extern const char *sort_order;
+extern const char *field_order;
 extern const char default_parent_pattern[];
 extern const char *parent_pattern;
 extern const char default_sort_order[];
@@ -189,6 +190,7 @@ extern struct sort_entry sort_thread;
 extern struct list_head hist_entry__sort_list;
 
 int setup_sorting(void);
+int setup_output_field(void);
 extern int sort_dimension__add(const char *);
 void sort__setup_elide(FILE *fp);
 
-- 
1.7.11.7

