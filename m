Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752016Ab3FWDWd (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Jun 2013 23:22:33 -0400
Received: from dmz-mailsec-scanner-8.mit.edu ([18.7.68.37]:49987 "EHLO
	dmz-mailsec-scanner-8.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751903Ab3FWDWa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Jun 2013 23:22:30 -0400
X-AuditID: 12074425-b7f0c8e000000953-c2-51c668c86f18
Date: Sat, 22 Jun 2013 23:17:20 -0400
From: Greg Price <price@MIT.EDU>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@redhat.com>,
        Jiri Olsa <jolsa@redhat.com>, David Ahern <dsahern@gmail.com>
Subject: Re: [PATCH] perf report: Add option to collapse undesired parts of
 call graph
Message-ID: <20130623031720.GW22203@biohazard-cafe.mit.edu>
References: <20121207072726.GY22203@biohazard-cafe.mit.edu>
 <20130111052736.GG3054@ghostprotocols.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130111052736.GG3054@ghostprotocols.net>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprPKsWRmVeSWpSXmKPExsUixCmqrHsi41igwaZ7chYX2y6yWRx4fIDF
	YuveNywWR8/+ZbK4vGsOm8WlAwuYLNYcWczuwO5x5SmHx+kePY+ds+6ye7zfd5XNY+6uPkaP
	z5vkAtiiuGxSUnMyy1KL9O0SuDLeHLzOVDDRreLEC5MGxh0mXYwcHBICJhLvXpd3MXICmWIS
	F+6tZ+ti5OIQEtjHKPFs2RkmCGcjo8TCgwdZIZzPjBJPen+xg7SwCKhKHHxxnhXEZhNQkPgx
	fx0ziC0iYCbxf/lPsG5mgbuMEt8mTWECSQgLREhM3/wfrIFXwFpi+pQ2sLiQQIbEp3c72SDi
	ghInZz5hAbGZBbQkbvx7yQRyKrOAtMTyfxwgJqeAucSVxTogFaICKhLX9rezTWAUnIWkeRaS
	5lkIzQsYmVcxyqbkVunmJmbmFKcm6xYnJ+blpRbpWujlZpbopaaUbmIExQO7i+oOxgmHlA4x
	CnAwKvHwJsgdCxRiTSwrrsw9xCjJwaQkysufABTiS8pPqcxILM6ILyrNSS0+xCjBwawkwuuf
	ApTjTUmsrEotyodJSXOwKInzit3aGSgkkJ5YkpqdmlqQWgSTleHgUJLgVQHGvZBgUWp6akVa
	Zk4JQpqJgxNkOA/Q8DPpIMOLCxJzizPTIfKnGBWlxHm5QZoFQBIZpXlwvbB09YpRHOgVYd61
	IO08wFQH1/0KaDAT0OA9qw+BDC5JREhJNTCuFVt8TPrJst05QeuPcUScy56gZ3l0YtnlZau+
	aASZzglKzKn45lUmy3H/y0P/WXutj8pznfk2P5L3uLz+hSOr9lz3F/k7wzU883eFyC2XL0U/
	15b+MrT8K7JQV9pJO05po3JzZPHX26Gvn757Y6m45/rtvg+ByjeklT7G6Sw5eG5K9PXlR+vE
	lFiKMxINtZiLihMBZ55amzIDAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

For example, in an application with an expensive function
implemented with deeply nested recursive calls, the default
call-graph presentation is dominated by the different callchains
within that function.  By treating the function as a black box,
we can collect the callchains leading into the function and
compactly identify what to blame for expensive calls.

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

If we make garbage_collect() a black box, its callers are coalesced:
$ perf report --blackbox garbage_collect -d ruby 2>- | grep -m10 ^[^#]*[a-z]
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

Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: David Ahern <dsahern@gmail.com>
Signed-off-by: Greg Price <price@mit.edu>
---

On Fri, Jan 11, 2013 at 02:27:36AM -0300, Arnaldo Carvalho de Melo wrote:
> Looks like an interesting feature, will review this soon,

Rebased on top of v3.10-rc7, please take a look at your convenience.


 tools/perf/builtin-report.c | 19 ++++++++++++++++---
 tools/perf/builtin-top.c    |  3 +--
 tools/perf/util/machine.c   | 26 +++++++++++++++++---------
 tools/perf/util/machine.h   |  9 ++++++++-
 tools/perf/util/session.c   |  3 +--
 5 files changed, 43 insertions(+), 17 deletions(-)

diff --git a/tools/perf/builtin-report.c b/tools/perf/builtin-report.c
index bd0ca81..bf0d860 100644
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
@@ -764,6 +764,8 @@ int cmd_report(int argc, const char **argv, const char *prefix __maybe_unused)
 		     "Default: fractal,0.5,callee", &parse_callchain_opt, callchain_default_opt),
 	OPT_BOOLEAN('G', "inverted", &report.inverted_callchain,
 		    "alias for inverted call graph"),
+	OPT_STRING(0, "blackbox", &blackbox_pattern, "regex",
+		   "functions to treat as black boxes in call graphs, collapsing callees"),
 	OPT_STRING('d', "dsos", &symbol_conf.dso_list_str, "dso[,dso...]",
 		   "only consider symbols in these dsos"),
 	OPT_STRING('c', "comms", &symbol_conf.comm_list_str, "comm[,comm...]",
@@ -918,6 +920,17 @@ repeat:
 	} else
 		symbol_conf.exclude_other = false;
 
+	if (blackbox_pattern) {
+		int err = regcomp(&blackbox_regex, blackbox_pattern, REG_EXTENDED);
+		if (err) {
+			char buf[BUFSIZ];
+			regerror(err, &blackbox_regex, buf, sizeof(buf));
+			pr_err("Invalid blackbox regex: %s\n%s", blackbox_pattern, buf);
+			goto error;
+		}
+		have_blackbox = 1;
+	}
+
 	if (argc) {
 		/*
 		 * Special case: if there's an argument left then assume that
diff --git a/tools/perf/builtin-top.c b/tools/perf/builtin-top.c
index 67bdb9f..abec83d 100644
--- a/tools/perf/builtin-top.c
+++ b/tools/perf/builtin-top.c
@@ -775,8 +775,7 @@ static void perf_event__process_sample(struct perf_tool *tool,
 		    sample->callchain) {
 			err = machine__resolve_callchain(machine, evsel,
 							 al.thread, sample,
-							 &parent);
-
+							 &parent, NULL);
 			if (err)
 				return;
 		}
diff --git a/tools/perf/util/machine.c b/tools/perf/util/machine.c
index b2ecad6..a14489c 100644
--- a/tools/perf/util/machine.c
+++ b/tools/perf/util/machine.c
@@ -11,6 +11,10 @@
 #include <stdbool.h>
 #include "unwind.h"
 
+regex_t blackbox_regex;
+const char *blackbox_pattern;
+int have_blackbox = 0;
+
 int machine__init(struct machine *machine, const char *root_dir, pid_t pid)
 {
 	map_groups__init(&machine->kmaps);
@@ -1058,11 +1062,10 @@ int machine__process_event(struct machine *machine, union perf_event *event)
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
 
@@ -1159,8 +1162,8 @@ struct branch_info *machine__resolve_bstack(struct machine *machine,
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
@@ -1211,8 +1214,13 @@ static int machine__resolve_callchain_sample(struct machine *machine,
 					   MAP__FUNCTION, ip, &al, NULL);
 		if (al.sym != NULL) {
 			if (sort__has_parent && !*parent &&
-			    symbol__match_parent_regex(al.sym))
+			    symbol__match_regex(al.sym, &parent_regex))
 				*parent = al.sym;
+			else if (have_blackbox && root_al &&
+			         symbol__match_regex(al.sym, &blackbox_regex)) {
+				*root_al = al;
+				callchain_cursor_reset(&callchain_cursor);
+			}
 			if (!symbol_conf.use_callchain)
 				break;
 		}
@@ -1237,15 +1245,15 @@ int machine__resolve_callchain(struct machine *machine,
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
index 7794068..6f0310a 100644
--- a/tools/perf/util/machine.h
+++ b/tools/perf/util/machine.h
@@ -3,8 +3,14 @@
 
 #include <sys/types.h>
 #include <linux/rbtree.h>
+#include <regex.h>
 #include "map.h"
 
+extern regex_t blackbox_regex;
+extern const char *blackbox_pattern;
+extern int have_blackbox;
+
+struct addr_location;
 struct branch_stack;
 struct perf_evsel;
 struct perf_sample;
@@ -83,7 +89,8 @@ int machine__resolve_callchain(struct machine *machine,
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
-- 
1.8.2
