Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751986AbaFEOcb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jun 2014 10:32:31 -0400
Received: from terminus.zytor.com ([198.137.202.10]:48142 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751503AbaFEOc1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jun 2014 10:32:27 -0400
Date: Thu, 5 Jun 2014 07:32:07 -0700
From: tip-bot for Jiri Olsa <tipbot@zytor.com>
Message-ID: <tip-f29984226978313039d7dfe9b45eaa55a3aad03d@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, eranian@google.com, paulus@samba.org,
        hpa@zytor.com, mingo@kernel.org, jolsa@kernel.org,
        a.p.zijlstra@chello.nl, acme@kernel.org, namhyung@kernel.org,
        fweisbec@gmail.com, dsahern@gmail.com, tglx@linutronix.de,
        cjashfor@linux.vnet.ibm.com
Reply-To: mingo@kernel.org, hpa@zytor.com, paulus@samba.org,
        eranian@google.com, linux-kernel@vger.kernel.org, jolsa@kernel.org,
        a.p.zijlstra@chello.nl, acme@kernel.org, namhyung@kernel.org,
        fweisbec@gmail.com, dsahern@gmail.com, tglx@linutronix.de,
        cjashfor@linux.vnet.ibm.com
In-Reply-To: <20140601142622.GA9131@krava.brq.redhat.com>
References: <20140601142622.GA9131@krava.brq.redhat.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf tools:
  Move elide bool into perf_hpp_fmt struct
Git-Commit-ID: f29984226978313039d7dfe9b45eaa55a3aad03d
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  f29984226978313039d7dfe9b45eaa55a3aad03d
Gitweb:     http://git.kernel.org/tip/f29984226978313039d7dfe9b45eaa55a3aad03d
Author:     Jiri Olsa <jolsa@kernel.org>
AuthorDate: Fri, 23 May 2014 17:15:47 +0200
Committer:  Jiri Olsa <jolsa@kernel.org>
CommitDate: Tue, 3 Jun 2014 21:34:59 +0200

perf tools: Move elide bool into perf_hpp_fmt struct

After output/sort fields refactoring, it's expensive
to check the elide bool in its current location inside
the 'struct sort_entry'.

The perf_hpp__should_skip function gets highly noticable in
workloads with high number of output/sort fields, like for:

  $ perf report -i perf-test.data -F overhead,sample,period,comm,pid,dso,symbol,cpu --stdio

Performance report:
   9.70%  perf  [.] perf_hpp__should_skip

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

Acked-by: Namhyung Kim <namhyung@kernel.org>
Cc: Arnaldo Carvalho de Melo <acme@kernel.org>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/r/20140601142622.GA9131@krava.brq.redhat.com
Signed-off-by: Jiri Olsa <jolsa@kernel.org>
---
 tools/perf/ui/browsers/hists.c |  8 ++--
 tools/perf/util/hist.h         |  8 +++-
 tools/perf/util/sort.c         | 90 ++++++++++++++++++++++++++----------------
 tools/perf/util/sort.h         |  2 +-
 4 files changed, 68 insertions(+), 40 deletions(-)

diff --git a/tools/perf/ui/browsers/hists.c b/tools/perf/ui/browsers/hists.c
index 5905acd..52c03fb 100644
--- a/tools/perf/ui/browsers/hists.c
+++ b/tools/perf/ui/browsers/hists.c
@@ -1706,14 +1706,14 @@ zoom_dso:
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
@@ -1725,13 +1725,13 @@ zoom_thread:
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
index 82b28ff..d2bf035 100644
--- a/tools/perf/util/hist.h
+++ b/tools/perf/util/hist.h
@@ -205,6 +205,7 @@ struct perf_hpp_fmt {
 
 	struct list_head list;
 	struct list_head sort_list;
+	bool elide;
 };
 
 extern struct list_head perf_hpp__list;
@@ -252,7 +253,12 @@ void perf_hpp__append_sort_keys(void);
 
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
index 2aba620..45512ba 100644
--- a/tools/perf/util/sort.c
+++ b/tools/perf/util/sort.c
@@ -1157,6 +1157,7 @@ __sort_dimension__alloc_hpp(struct sort_dimension *sd)
 
 	INIT_LIST_HEAD(&hse->hpp.list);
 	INIT_LIST_HEAD(&hse->hpp.sort_list);
+	hse->hpp.elide = false;
 
 	return hse;
 }
@@ -1364,27 +1365,64 @@ static int __setup_sorting(void)
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
@@ -1392,26 +1430,12 @@ void sort__setup_elide(FILE *output)
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
@@ -1422,8 +1446,7 @@ void sort__setup_elide(FILE *output)
 		if (!perf_hpp__is_sort_entry(fmt))
 			continue;
 
-		hse = container_of(fmt, struct hpp_sort_entry, hpp);
-		if (!hse->se->elide)
+		if (!fmt->elide)
 			return;
 	}
 
@@ -1431,8 +1454,7 @@ void sort__setup_elide(FILE *output)
 		if (!perf_hpp__is_sort_entry(fmt))
 			continue;
 
-		hse = container_of(fmt, struct hpp_sort_entry, hpp);
-		hse->se->elide = false;
+		fmt->elide = false;
 	}
 }
 
diff --git a/tools/perf/util/sort.h b/tools/perf/util/sort.h
index 426b873..5bf0098 100644
--- a/tools/perf/util/sort.h
+++ b/tools/perf/util/sort.h
@@ -202,7 +202,6 @@ struct sort_entry {
 	int	(*se_snprintf)(struct hist_entry *he, char *bf, size_t size,
 			       unsigned int width);
 	u8	se_width_idx;
-	bool	elide;
 };
 
 extern struct sort_entry sort_thread;
@@ -213,6 +212,7 @@ int setup_output_field(void);
 void reset_output_field(void);
 extern int sort_dimension__add(const char *);
 void sort__setup_elide(FILE *fp);
+void perf_hpp__set_elide(int idx, bool elide);
 
 int report_parse_ignore_callees_opt(const struct option *opt, const char *arg, int unset);
 
