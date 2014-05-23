Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752908AbaEWPQH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 May 2014 11:16:07 -0400
Received: from mx1.redhat.com ([209.132.183.28]:61201 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752771AbaEWPQE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 May 2014 11:16:04 -0400
From: Jiri Olsa <jolsa@kernel.org>
To: linux-kernel@vger.kernel.org
Cc: Jiri Olsa <jolsa@kernel.org>, Arnaldo Carvalho de Melo <acme@kernel.org>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@kernel.org>, Namhyung Kim <namhyung@kernel.org>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Stephane Eranian <eranian@google.com>
Subject: [PATCH 2/2] perf tools: Move elide bool into perf_hpp_fmt struct
Date: Fri, 23 May 2014 17:15:47 +0200
Message-Id: <1400858147-7155-3-git-send-email-jolsa@kernel.org>
In-Reply-To: <1400858147-7155-1-git-send-email-jolsa@kernel.org>
References: <1400858147-7155-1-git-send-email-jolsa@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

After output/sort fields refactoring, it's expensive
to check the elide bool in its current location inside
the 'struct sort_entry'.

The perf_hpp__should_skip function gets highly noticable in
workloads with high number of output/sort fields, like for:

  $ perf report -i perf-test.data -F overhead,sample,period,comm,pid,dso,symbol,cpu --stdio

Performance report:
   9.70%  perf  [.] perf_hpp__should_skip                                                                          ◆

Moving the elide bool into the 'struct perf_hpp_fmt', which
makes the perf_hpp__should_skip just single struct read.

Got speedup of around 22% for my test perf.data workload.
The change should not harm any other workload types.

Performance counter stats for (10 runs):
  before:
   358,319,732,626      cycles                    ( +-  0.55% )
   467,129,581,515      instructions              #    1.30  insns per cycle          ( +-  0.00% )

     150.943975206 seconds time elapsed           ( +-  0.62% )

  now:
   278,785,972,990      cycles                    ( +-  0.12% )
   370,146,797,640      instructions              #    1.33  insns per cycle          ( +-  0.00% )

     116.416670507 seconds time elapsed           ( +-  0.31% )

Cc: Arnaldo Carvalho de Melo <acme@kernel.org>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Stephane Eranian <eranian@google.com>
Signed-off-by: Jiri Olsa <jolsa@kernel.org>
---
 tools/perf/ui/browsers/hists.c |  8 ++--
 tools/perf/util/hist.h         |  8 +++-
 tools/perf/util/sort.c         | 89 ++++++++++++++++++++++++++----------------
 tools/perf/util/sort.h         |  2 +-
 4 files changed, 67 insertions(+), 40 deletions(-)

diff --git a/tools/perf/ui/browsers/hists.c b/tools/perf/ui/browsers/hists.c
index 1c331b9..418a435 100644
--- a/tools/perf/ui/browsers/hists.c
+++ b/tools/perf/ui/browsers/hists.c
@@ -1699,14 +1699,14 @@ zoom_dso:
 zoom_out_dso:
 				ui_helpline__pop();
 				browser->hists->dso_filter = NULL;
-				sort_dso.elide = false;
+				perf_hpp__set_elide(HISTC_DSO, false);
 			} else {
 				if (dso == NULL)
 					continue;
 				ui_helpline__fpush("To zoom out press <- or -> + \"Zoom out of %s DSO\"",
 						   dso->kernel ? "the Kernel" : dso->short_name);
 				browser->hists->dso_filter = dso;
-				sort_dso.elide = true;
+				perf_hpp__set_elide(HISTC_DSO, true);
 				pstack__push(fstack, &browser->hists->dso_filter);
 			}
 			hists__filter_by_dso(hists);
@@ -1718,13 +1718,13 @@ zoom_thread:
 zoom_out_thread:
 				ui_helpline__pop();
 				browser->hists->thread_filter = NULL;
-				sort_thread.elide = false;
+				perf_hpp__set_elide(HISTC_THREAD, false);
 			} else {
 				ui_helpline__fpush("To zoom out press <- or -> + \"Zoom out of %s(%d) thread\"",
 						   thread->comm_set ? thread__comm_str(thread) : "",
 						   thread->tid);
 				browser->hists->thread_filter = thread;
-				sort_thread.elide = true;
+				perf_hpp__set_elide(HISTC_THREAD, false);
 				pstack__push(fstack, &browser->hists->thread_filter);
 			}
 			hists__filter_by_thread(hists);
diff --git a/tools/perf/util/hist.h b/tools/perf/util/hist.h
index a8418d1..dd3d763 100644
--- a/tools/perf/util/hist.h
+++ b/tools/perf/util/hist.h
@@ -166,6 +166,7 @@ struct perf_hpp_fmt {
 
 	struct list_head list;
 	struct list_head sort_list;
+	bool elide;
 };
 
 extern struct list_head perf_hpp__list;
@@ -208,7 +209,12 @@ void perf_hpp__append_sort_keys(void);
 
 bool perf_hpp__is_sort_entry(struct perf_hpp_fmt *format);
 bool perf_hpp__same_sort_entry(struct perf_hpp_fmt *a, struct perf_hpp_fmt *b);
-bool perf_hpp__should_skip(struct perf_hpp_fmt *format);
+
+static inline bool perf_hpp__should_skip(struct perf_hpp_fmt *format)
+{
+	return format->elide;
+}
+
 void perf_hpp__reset_width(struct perf_hpp_fmt *fmt, struct hists *hists);
 
 typedef u64 (*hpp_field_fn)(struct hist_entry *he);
diff --git a/tools/perf/util/sort.c b/tools/perf/util/sort.c
index a1a5ba3..48cb026 100644
--- a/tools/perf/util/sort.c
+++ b/tools/perf/util/sort.c
@@ -1363,27 +1363,64 @@ static int __setup_sorting(void)
 	return ret;
 }
 
-bool perf_hpp__should_skip(struct perf_hpp_fmt *format)
+void perf_hpp__set_elide(int idx, bool elide)
 {
-	if (perf_hpp__is_sort_entry(format)) {
-		struct hpp_sort_entry *hse;
+	struct perf_hpp_fmt *fmt;
+	struct hpp_sort_entry *hse;
 
-		hse = container_of(format, struct hpp_sort_entry, hpp);
-		return hse->se->elide;
+	perf_hpp__for_each_format(fmt) {
+		if (!perf_hpp__is_sort_entry(fmt))
+			continue;
+
+		hse = container_of(fmt, struct hpp_sort_entry, hpp);
+		if (hse->se->se_width_idx == idx) {
+			fmt->elide = elide;
+			break;
+		}
 	}
-	return false;
 }
 
-static void sort_entry__setup_elide(struct sort_entry *se,
-				    struct strlist *list,
-				    const char *list_name, FILE *fp)
+static bool __get_elide(struct strlist *list, const char *list_name, FILE *fp)
 {
 	if (list && strlist__nr_entries(list) == 1) {
 		if (fp != NULL)
 			fprintf(fp, "# %s: %s\n", list_name,
 				strlist__entry(list, 0)->s);
-		se->elide = true;
+		return true;
+	}
+	return false;
+}
+
+static bool get_elide(int idx, FILE *output)
+{
+	switch (idx) {
+	case HISTC_SYMBOL:
+		return __get_elide(symbol_conf.sym_list, "symbol", output);
+	case HISTC_DSO:
+		return __get_elide(symbol_conf.dso_list, "dso", output);
+	case HISTC_COMM:
+		return __get_elide(symbol_conf.comm_list, "comm", output);
+	default:
+		break;
 	}
+
+	if (sort__mode != SORT_MODE__BRANCH)
+		return false;
+
+	switch (idx) {
+	case HISTC_SYMBOL_FROM:
+		return __get_elide(symbol_conf.sym_from_list, "sym_from", output);
+	case HISTC_SYMBOL_TO:
+		return __get_elide(symbol_conf.sym_to_list, "sym_to", output);
+	case HISTC_DSO_FROM:
+		return __get_elide(symbol_conf.dso_from_list, "dso_from", output);
+	case HISTC_DSO_TO:
+		return __get_elide(symbol_conf.dso_to_list, "dso_to", output);
+	default:
+		break;
+	}
+
+	return false;
 }
 
 void sort__setup_elide(FILE *output)
@@ -1391,26 +1428,12 @@ void sort__setup_elide(FILE *output)
 	struct perf_hpp_fmt *fmt;
 	struct hpp_sort_entry *hse;
 
-	sort_entry__setup_elide(&sort_dso, symbol_conf.dso_list,
-				"dso", output);
-	sort_entry__setup_elide(&sort_comm, symbol_conf.comm_list,
-				"comm", output);
-	sort_entry__setup_elide(&sort_sym, symbol_conf.sym_list,
-				"symbol", output);
-
-	if (sort__mode == SORT_MODE__BRANCH) {
-		sort_entry__setup_elide(&sort_dso_from,
-					symbol_conf.dso_from_list,
-					"dso_from", output);
-		sort_entry__setup_elide(&sort_dso_to,
-					symbol_conf.dso_to_list,
-					"dso_to", output);
-		sort_entry__setup_elide(&sort_sym_from,
-					symbol_conf.sym_from_list,
-					"sym_from", output);
-		sort_entry__setup_elide(&sort_sym_to,
-					symbol_conf.sym_to_list,
-					"sym_to", output);
+	perf_hpp__for_each_format(fmt) {
+		if (!perf_hpp__is_sort_entry(fmt))
+			continue;
+
+		hse = container_of(fmt, struct hpp_sort_entry, hpp);
+		fmt->elide = get_elide(hse->se->se_width_idx, output);
 	}
 
 	/*
@@ -1421,8 +1444,7 @@ void sort__setup_elide(FILE *output)
 		if (!perf_hpp__is_sort_entry(fmt))
 			continue;
 
-		hse = container_of(fmt, struct hpp_sort_entry, hpp);
-		if (!hse->se->elide)
+		if (!fmt->elide)
 			return;
 	}
 
@@ -1430,8 +1452,7 @@ void sort__setup_elide(FILE *output)
 		if (!perf_hpp__is_sort_entry(fmt))
 			continue;
 
-		hse = container_of(fmt, struct hpp_sort_entry, hpp);
-		hse->se->elide = false;
+		fmt->elide = false;
 	}
 }
 
diff --git a/tools/perf/util/sort.h b/tools/perf/util/sort.h
index 5f38d92..776aa41 100644
--- a/tools/perf/util/sort.h
+++ b/tools/perf/util/sort.h
@@ -186,7 +186,6 @@ struct sort_entry {
 	int	(*se_snprintf)(struct hist_entry *he, char *bf, size_t size,
 			       unsigned int width);
 	u8	se_width_idx;
-	bool	elide;
 };
 
 extern struct sort_entry sort_thread;
@@ -197,6 +196,7 @@ int setup_output_field(void);
 void reset_output_field(void);
 extern int sort_dimension__add(const char *);
 void sort__setup_elide(FILE *fp);
+void perf_hpp__set_elide(int idx, bool elide);
 
 int report_parse_ignore_callees_opt(const struct option *opt, const char *arg, int unset);
 
-- 
1.8.3.1

