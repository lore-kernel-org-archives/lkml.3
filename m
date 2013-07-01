Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754310Ab3GAO2y (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Jul 2013 10:28:54 -0400
Received: from dmz-mailsec-scanner-8.mit.edu ([18.7.68.37]:54617 "EHLO
	dmz-mailsec-scanner-8.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751318Ab3GAO2x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Jul 2013 10:28:53 -0400
X-AuditID: 12074425-b7f0c8e000000953-d4-51d19224b1e4
Date: Mon, 1 Jul 2013 10:28:45 -0400
From: Greg Price <price@MIT.EDU>
To: linux-kernel@vger.kernel.org,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Namhyung Kim <namhyung@kernel.org>, Jiri Olsa <jolsa@redhat.com>,
        Ingo Molnar <mingo@redhat.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        David Ahern <dsahern@gmail.com>
Subject: [PATCH v2] perf report/top: Add option to collapse undesired parts
 of call graph
Message-ID: <20130701142841.GE22203@biohazard-cafe.mit.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprCKsWRmVeSWpSXmKPExsUixCmqrasy6WKgwc2NAhYX2y6yWRx4fIDF
	YuveNywWR8/+ZbK4vGsOm8WlAwuYLJqWbWWxWHNkMbsDh8eVpxwep3v0PHbOusvusWlVJ5vH
	+31X2Tzm7upj9Pi8SS6APYrLJiU1J7MstUjfLoEr42/LTdaCC/EV93qnsTcw/vPoYuTkkBAw
	kZg6byMrhC0mceHeerYuRi4OIYF9jBJ9F9+yQDgbGCVu/v/OBOF8YpTY1vUMrIVFQEViwqSF
	YDabgILEj/nrmEGKRAQuMgIljoMlmAUqJN5/eM0GYgsLREs0HdsKFucVsJbo/XOTDcIWlDg5
	8wkLRL2WxI1/L4G2cQDZ0hLL/3GAhEWBdl3b3842gZF/FpKOWUg6ZiF0LGBkXsUom5JbpZub
	mJlTnJqsW5ycmJeXWqRroZebWaKXmlK6iREU+OwuqjsYJxxSOsQowMGoxMO7YPqFQCHWxLLi
	ytxDjJIcTEqivNITLgYK8SXlp1RmJBZnxBeV5qQWH2KU4GBWEuG96Q2U401JrKxKLcqHSUlz
	sCiJ8z5/ejZQSCA9sSQ1OzW1ILUIJivDwaEkwSs7EahRsCg1PbUiLTOnBCHNxMEJMpwHaPgP
	kMW8xQWJucWZ6RD5U4yKUuK8NiDNAiCJjNI8uF5YYnrFKA70ijAvJ0gVDzCpwXW/AhrMBDSY
	t/UcyOCSRISUVAOj7wq16rtl9k9yc9sPx77Y9l9cqUBxZseHEy/Oebm+/bjgStrSHE7vZ1ci
	U/a5vbN9rnyzdfLR1f2zD7zcNmN3aXW4rtSp7Q+C5x4v9Picufe02X//pan2kosPPa3fkPjs
	0t9r/LU818ptHjq+v3Xwz42ZR7tWX3x79ZuZuotXmeDXh0qu637or1NiKc5INNRiLipOBAD3
	9M7jJwMAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

For example, in an application with an expensive function
implemented with deeply nested recursive calls, the default
call-graph presentation is dominated by the different callchains
within that function.  By ignoring these callees, we can collect
the callchains leading into the function and compactly identify
what to blame for expensive calls.

For example, in this report the callers of garbage_collect() are
scattered across the tree:
$ perf report -d ruby 2>- | grep -m10 ^[^#]*[a-z]
    22.03%     ruby  [.] gc_mark
               --- gc_mark
                  |--59.40%-- mark_keyvalue
                  |          st_foreach
                  |          gc_mark_children
                  |          |--99.75%-- rb_gc_mark
                  |          |          rb_vm_mark
                  |          |          gc_mark_children
                  |          |          gc_marks
                  |          |          |--99.00%-- garbage_collect

If we ignore the callees of garbage_collect(), its callers are coalesced:
$ perf report --ignore-callees garbage_collect -d ruby 2>- | grep -m10 ^[^#]*[a-z]
    72.92%     ruby  [.] garbage_collect
               --- garbage_collect
                   vm_xmalloc
                  |--47.08%-- ruby_xmalloc
                  |          st_insert2
                  |          rb_hash_aset
                  |          |--98.45%-- features_index_add
                  |          |          rb_provide_feature
                  |          |          rb_require_safe
                  |          |          vm_call_method

Link: http://lkml.kernel.org/r/20130623031720.GW22203@biohazard-cafe.mit.edu
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Paul Mackerras <paulus@samba.org>
Cc: David Ahern <dsahern@gmail.com>
Signed-off-by: Greg Price <price@mit.edu>
---

Now on top of v3.10.  Option renamed, added to top, comment and doc added.

 tools/perf/Documentation/perf-report.txt |  5 +++++
 tools/perf/Documentation/perf-top.txt    |  5 +++++
 tools/perf/builtin-report.c              | 27 ++++++++++++++++++++++++---
 tools/perf/builtin-top.c                 |  6 ++++--
 tools/perf/util/machine.c                | 24 +++++++++++++++---------
 tools/perf/util/machine.h                |  4 +++-
 tools/perf/util/session.c                |  3 +--
 tools/perf/util/sort.c                   |  2 ++
 tools/perf/util/sort.h                   |  4 ++++
 9 files changed, 63 insertions(+), 17 deletions(-)

diff --git a/tools/perf/Documentation/perf-report.txt b/tools/perf/Documentation/perf-report.txt
index 7d5f4f3..57f2137 100644
--- a/tools/perf/Documentation/perf-report.txt
+++ b/tools/perf/Documentation/perf-report.txt
@@ -135,6 +135,11 @@ OPTIONS
 --inverted::
         alias for inverted caller based call graph.
 
+--ignore-callees=<regex>::
+        Ignore callees of the function(s) matching the given regex.
+        This has the effect of collecting the callers of each such
+        function into one place in the call-graph tree.
+
 --pretty=<key>::
         Pretty printing style.  key: normal, raw
 
diff --git a/tools/perf/Documentation/perf-top.txt b/tools/perf/Documentation/perf-top.txt
index 9f1a2fe..be66778 100644
--- a/tools/perf/Documentation/perf-top.txt
+++ b/tools/perf/Documentation/perf-top.txt
@@ -155,6 +155,11 @@ Default is to monitor all CPUS.
 
 	Default: fractal,0.5,callee.
 
+--ignore-callees=<regex>::
+        Ignore callees of the function(s) matching the given regex.
+        This has the effect of collecting the callers of each such
+        function into one place in the call-graph tree.
+
 INTERACTIVE PROMPTING KEYS
 --------------------------
 
diff --git a/tools/perf/builtin-report.c b/tools/perf/builtin-report.c
index bd0ca81..842575f 100644
--- a/tools/perf/builtin-report.c
+++ b/tools/perf/builtin-report.c
@@ -83,7 +83,7 @@ static int perf_report__add_mem_hist_entry(struct perf_tool *tool,
 	if ((sort__has_parent || symbol_conf.use_callchain) &&
 	    sample->callchain) {
 		err = machine__resolve_callchain(machine, evsel, al->thread,
-						 sample, &parent);
+						 sample, &parent, al);
 		if (err)
 			return err;
 	}
@@ -174,7 +174,7 @@ static int perf_report__add_branch_hist_entry(struct perf_tool *tool,
 	if ((sort__has_parent || symbol_conf.use_callchain)
 	    && sample->callchain) {
 		err = machine__resolve_callchain(machine, evsel, al->thread,
-						 sample, &parent);
+						 sample, &parent, al);
 		if (err)
 			return err;
 	}
@@ -245,7 +245,7 @@ static int perf_evsel__add_hist_entry(struct perf_evsel *evsel,
 
 	if ((sort__has_parent || symbol_conf.use_callchain) && sample->callchain) {
 		err = machine__resolve_callchain(machine, evsel, al->thread,
-						 sample, &parent);
+						 sample, &parent, al);
 		if (err)
 			return err;
 	}
@@ -687,6 +687,24 @@ setup:
 	return 0;
 }
 
+int
+report_parse_ignore_callees_opt(const struct option *opt __maybe_unused,
+                          const char *arg, int unset __maybe_unused)
+{
+	if (arg) {
+		int err = regcomp(&ignore_callees_regex, arg, REG_EXTENDED);
+		if (err) {
+			char buf[BUFSIZ];
+			regerror(err, &ignore_callees_regex, buf, sizeof(buf));
+			pr_err("Invalid --ignore-callees regex: %s\n%s", arg, buf);
+			return -1;
+		}
+		have_ignore_callees = 1;
+	}
+
+	return 0;
+}
+
 static int
 parse_branch_mode(const struct option *opt __maybe_unused,
 		  const char *str __maybe_unused, int unset)
@@ -764,6 +782,9 @@ int cmd_report(int argc, const char **argv, const char *prefix __maybe_unused)
 		     "Default: fractal,0.5,callee", &parse_callchain_opt, callchain_default_opt),
 	OPT_BOOLEAN('G', "inverted", &report.inverted_callchain,
 		    "alias for inverted call graph"),
+	OPT_CALLBACK(0, "ignore-callees", NULL, "regex",
+		   "ignore callees of these functions in call graphs",
+		   report_parse_ignore_callees_opt),
 	OPT_STRING('d', "dsos", &symbol_conf.dso_list_str, "dso[,dso...]",
 		   "only consider symbols in these dsos"),
 	OPT_STRING('c', "comms", &symbol_conf.comm_list_str, "comm[,comm...]",
diff --git a/tools/perf/builtin-top.c b/tools/perf/builtin-top.c
index 67bdb9f..ef4da38 100644
--- a/tools/perf/builtin-top.c
+++ b/tools/perf/builtin-top.c
@@ -775,8 +775,7 @@ static void perf_event__process_sample(struct perf_tool *tool,
 		    sample->callchain) {
 			err = machine__resolve_callchain(machine, evsel,
 							 al.thread, sample,
-							 &parent);
-
+							 &parent, &al);
 			if (err)
 				return;
 		}
@@ -1095,6 +1094,9 @@ int cmd_top(int argc, const char **argv, const char *prefix __maybe_unused)
 	OPT_CALLBACK_DEFAULT('G', "call-graph", &top.record_opts,
 			     "mode[,dump_size]", record_callchain_help,
 			     &parse_callchain_opt, "fp"),
+	OPT_CALLBACK(0, "ignore-callees", NULL, "regex",
+		   "ignore callees of these functions in call graphs",
+		   report_parse_ignore_callees_opt),
 	OPT_BOOLEAN(0, "show-total-period", &symbol_conf.show_total_period,
 		    "Show a column with the sum of periods"),
 	OPT_STRING(0, "dsos", &symbol_conf.dso_list_str, "dso[,dso...]",
diff --git a/tools/perf/util/machine.c b/tools/perf/util/machine.c
index b2ecad6..6ab6112 100644
--- a/tools/perf/util/machine.c
+++ b/tools/perf/util/machine.c
@@ -1058,11 +1058,10 @@ int machine__process_event(struct machine *machine, union perf_event *event)
 	return ret;
 }
 
-static bool symbol__match_parent_regex(struct symbol *sym)
+static bool symbol__match_regex(struct symbol *sym, regex_t *regex)
 {
-	if (sym->name && !regexec(&parent_regex, sym->name, 0, NULL, 0))
+	if (sym->name && !regexec(regex, sym->name, 0, NULL, 0))
 		return 1;
-
 	return 0;
 }
 
@@ -1159,8 +1158,8 @@ struct branch_info *machine__resolve_bstack(struct machine *machine,
 static int machine__resolve_callchain_sample(struct machine *machine,
 					     struct thread *thread,
 					     struct ip_callchain *chain,
-					     struct symbol **parent)
-
+					     struct symbol **parent,
+					     struct addr_location *root_al)
 {
 	u8 cpumode = PERF_RECORD_MISC_USER;
 	unsigned int i;
@@ -1211,8 +1210,15 @@ static int machine__resolve_callchain_sample(struct machine *machine,
 					   MAP__FUNCTION, ip, &al, NULL);
 		if (al.sym != NULL) {
 			if (sort__has_parent && !*parent &&
-			    symbol__match_parent_regex(al.sym))
+			    symbol__match_regex(al.sym, &parent_regex))
 				*parent = al.sym;
+			else if (have_ignore_callees && root_al &&
+			  symbol__match_regex(al.sym, &ignore_callees_regex)) {
+				/* Treat this symbol as the root,
+				   forgetting its callees. */
+				*root_al = al;
+				callchain_cursor_reset(&callchain_cursor);
+			}
 			if (!symbol_conf.use_callchain)
 				break;
 		}
@@ -1237,15 +1243,15 @@ int machine__resolve_callchain(struct machine *machine,
 			       struct perf_evsel *evsel,
 			       struct thread *thread,
 			       struct perf_sample *sample,
-			       struct symbol **parent)
-
+			       struct symbol **parent,
+			       struct addr_location *root_al)
 {
 	int ret;
 
 	callchain_cursor_reset(&callchain_cursor);
 
 	ret = machine__resolve_callchain_sample(machine, thread,
-						sample->callchain, parent);
+	                                        sample->callchain, parent, root_al);
 	if (ret)
 		return ret;
 
diff --git a/tools/perf/util/machine.h b/tools/perf/util/machine.h
index 7794068..9ce97a5 100644
--- a/tools/perf/util/machine.h
+++ b/tools/perf/util/machine.h
@@ -5,6 +5,7 @@
 #include <linux/rbtree.h>
 #include "map.h"
 
+struct addr_location;
 struct branch_stack;
 struct perf_evsel;
 struct perf_sample;
@@ -83,7 +84,8 @@ int machine__resolve_callchain(struct machine *machine,
 			       struct perf_evsel *evsel,
 			       struct thread *thread,
 			       struct perf_sample *sample,
-			       struct symbol **parent);
+			       struct symbol **parent,
+			       struct addr_location *root_al);
 
 /*
  * Default guest kernel is defined by parameter --guestkallsyms
diff --git a/tools/perf/util/session.c b/tools/perf/util/session.c
index cf1fe01..7024950 100644
--- a/tools/perf/util/session.c
+++ b/tools/perf/util/session.c
@@ -1397,9 +1397,8 @@ void perf_evsel__print_ip(struct perf_evsel *evsel, union perf_event *event,
 
 	if (symbol_conf.use_callchain && sample->callchain) {
 
-
 		if (machine__resolve_callchain(machine, evsel, al.thread,
-					       sample, NULL) != 0) {
+					       sample, NULL, NULL) != 0) {
 			if (verbose)
 				error("Failed to resolve callchain. Skipping\n");
 			return;
diff --git a/tools/perf/util/sort.c b/tools/perf/util/sort.c
index 5f52d49..295eef8 100644
--- a/tools/perf/util/sort.c
+++ b/tools/perf/util/sort.c
@@ -6,6 +6,8 @@ const char	default_parent_pattern[] = "^sys_|^do_page_fault";
 const char	*parent_pattern = default_parent_pattern;
 const char	default_sort_order[] = "comm,dso,symbol";
 const char	*sort_order = default_sort_order;
+regex_t		ignore_callees_regex;
+int		have_ignore_callees = 0;
 int		sort__need_collapse = 0;
 int		sort__has_parent = 0;
 int		sort__has_sym = 0;
diff --git a/tools/perf/util/sort.h b/tools/perf/util/sort.h
index f24bdf6..3275f6b 100644
--- a/tools/perf/util/sort.h
+++ b/tools/perf/util/sort.h
@@ -29,6 +29,8 @@ extern const char *sort_order;
 extern const char default_parent_pattern[];
 extern const char *parent_pattern;
 extern const char default_sort_order[];
+extern regex_t ignore_callees_regex;
+extern int have_ignore_callees;
 extern int sort__need_collapse;
 extern int sort__has_parent;
 extern int sort__has_sym;
@@ -175,4 +177,6 @@ extern int sort_dimension__add(const char *);
 void sort_entry__setup_elide(struct sort_entry *self, struct strlist *list,
 			     const char *list_name, FILE *fp);
 
+int report_parse_ignore_callees_opt(const struct option *opt, const char *arg, int unset);
+
 #endif	/* __PERF_SORT_H */
-- 
1.8.2
