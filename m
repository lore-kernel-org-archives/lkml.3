Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754584AbaCRIbP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Mar 2014 04:31:15 -0400
Received: from terminus.zytor.com ([198.137.202.10]:45689 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753900AbaCRIbL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Mar 2014 04:31:11 -0400
Date: Tue, 18 Mar 2014 01:30:48 -0700
From: tip-bot for Namhyung Kim <tipbot@zytor.com>
Message-ID: <tip-94a0793ddf7fa9890006a8dc203b985e7b120785@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, paulus@samba.org,
        hpa@zytor.com, mingo@kernel.org, andi@firstfloor.org,
        a.p.zijlstra@chello.nl, namhyung.kim@lge.com, namhyung@kernel.org,
        jolsa@redhat.com, dsahern@gmail.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, paulus@samba.org,
        linux-kernel@vger.kernel.org, acme@redhat.com, andi@firstfloor.org,
        a.p.zijlstra@chello.nl, namhyung.kim@lge.com, namhyung@kernel.org,
        jolsa@redhat.com, dsahern@gmail.com, tglx@linutronix.de
In-Reply-To: <1394437440-11609-2-git-send-email-namhyung@kernel.org>
References: <1394437440-11609-2-git-send-email-namhyung@kernel.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf ui hists: Pass evsel to hpp->header/
 width functions explicitly
Git-Commit-ID: 94a0793ddf7fa9890006a8dc203b985e7b120785
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

Commit-ID:  94a0793ddf7fa9890006a8dc203b985e7b120785
Gitweb:     http://git.kernel.org/tip/94a0793ddf7fa9890006a8dc203b985e7b120785
Author:     Namhyung Kim <namhyung@kernel.org>
AuthorDate: Mon, 10 Mar 2014 16:43:52 +0900
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Fri, 14 Mar 2014 18:08:40 -0300

perf ui hists: Pass evsel to hpp->header/width functions explicitly

Those functions need evsel to investigate event group and it's passed
via hpp->ptr.  However as it can be missed easily so it's better to
pass it via an argument IMHO.

Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Cc: Andi Kleen <andi@firstfloor.org>
Cc: David Ahern <dsahern@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Namhyung Kim <namhyung.kim@lge.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/1394437440-11609-2-git-send-email-namhyung@kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/builtin-diff.c  |  7 ++++---
 tools/perf/ui/gtk/hists.c  |  3 +--
 tools/perf/ui/hist.c       | 24 ++++++++++--------------
 tools/perf/ui/stdio/hist.c |  5 ++---
 tools/perf/util/hist.h     |  6 ++++--
 5 files changed, 21 insertions(+), 24 deletions(-)

diff --git a/tools/perf/builtin-diff.c b/tools/perf/builtin-diff.c
index a77e312..204fffe 100644
--- a/tools/perf/builtin-diff.c
+++ b/tools/perf/builtin-diff.c
@@ -952,8 +952,8 @@ static int hpp__entry_global(struct perf_hpp_fmt *_fmt, struct perf_hpp *hpp,
 				 dfmt->header_width, buf);
 }
 
-static int hpp__header(struct perf_hpp_fmt *fmt,
-		       struct perf_hpp *hpp)
+static int hpp__header(struct perf_hpp_fmt *fmt, struct perf_hpp *hpp,
+		       struct perf_evsel *evsel __maybe_unused)
 {
 	struct diff_hpp_fmt *dfmt =
 		container_of(fmt, struct diff_hpp_fmt, fmt);
@@ -963,7 +963,8 @@ static int hpp__header(struct perf_hpp_fmt *fmt,
 }
 
 static int hpp__width(struct perf_hpp_fmt *fmt,
-		      struct perf_hpp *hpp __maybe_unused)
+		      struct perf_hpp *hpp __maybe_unused,
+		      struct perf_evsel *evsel __maybe_unused)
 {
 	struct diff_hpp_fmt *dfmt =
 		container_of(fmt, struct diff_hpp_fmt, fmt);
diff --git a/tools/perf/ui/gtk/hists.c b/tools/perf/ui/gtk/hists.c
index 7912dab..e395ef9 100644
--- a/tools/perf/ui/gtk/hists.c
+++ b/tools/perf/ui/gtk/hists.c
@@ -165,7 +165,6 @@ static void perf_gtk__show_hists(GtkWidget *window, struct hists *hists,
 	struct perf_hpp hpp = {
 		.buf		= s,
 		.size		= sizeof(s),
-		.ptr		= hists_to_evsel(hists),
 	};
 
 	nr_cols = 0;
@@ -192,7 +191,7 @@ static void perf_gtk__show_hists(GtkWidget *window, struct hists *hists,
 	col_idx = 0;
 
 	perf_hpp__for_each_format(fmt) {
-		fmt->header(fmt, &hpp);
+		fmt->header(fmt, &hpp, hists_to_evsel(hists));
 
 		gtk_tree_view_insert_column_with_attributes(GTK_TREE_VIEW(view),
 							    -1, ltrim(s),
diff --git a/tools/perf/ui/hist.c b/tools/perf/ui/hist.c
index ac39313..0f403b8 100644
--- a/tools/perf/ui/hist.c
+++ b/tools/perf/ui/hist.c
@@ -118,29 +118,27 @@ int __hpp__fmt(struct perf_hpp *hpp, struct hist_entry *he,
 
 #define __HPP_HEADER_FN(_type, _str, _min_width, _unit_width) 		\
 static int hpp__header_##_type(struct perf_hpp_fmt *fmt __maybe_unused,	\
-			       struct perf_hpp *hpp)			\
+			       struct perf_hpp *hpp,			\
+			       struct perf_evsel *evsel)		\
 {									\
 	int len = _min_width;						\
 									\
-	if (symbol_conf.event_group) {					\
-		struct perf_evsel *evsel = hpp->ptr;			\
-									\
+	if (symbol_conf.event_group)					\
 		len = max(len, evsel->nr_members * _unit_width);	\
-	}								\
+									\
 	return scnprintf(hpp->buf, hpp->size, "%*s", len, _str);	\
 }
 
 #define __HPP_WIDTH_FN(_type, _min_width, _unit_width) 			\
 static int hpp__width_##_type(struct perf_hpp_fmt *fmt __maybe_unused,	\
-			      struct perf_hpp *hpp __maybe_unused)	\
+			      struct perf_hpp *hpp __maybe_unused,	\
+			      struct perf_evsel *evsel)			\
 {									\
 	int len = _min_width;						\
 									\
-	if (symbol_conf.event_group) {					\
-		struct perf_evsel *evsel = hpp->ptr;			\
-									\
+	if (symbol_conf.event_group)					\
 		len = max(len, evsel->nr_members * _unit_width);	\
-	}								\
+									\
 	return len;							\
 }
 
@@ -329,15 +327,13 @@ unsigned int hists__sort_list_width(struct hists *hists)
 	struct perf_hpp_fmt *fmt;
 	struct sort_entry *se;
 	int i = 0, ret = 0;
-	struct perf_hpp dummy_hpp = {
-		.ptr	= hists_to_evsel(hists),
-	};
+	struct perf_hpp dummy_hpp;
 
 	perf_hpp__for_each_format(fmt) {
 		if (i)
 			ret += 2;
 
-		ret += fmt->width(fmt, &dummy_hpp);
+		ret += fmt->width(fmt, &dummy_hpp, hists_to_evsel(hists));
 	}
 
 	list_for_each_entry(se, &hist_entry__sort_list, list)
diff --git a/tools/perf/ui/stdio/hist.c b/tools/perf/ui/stdio/hist.c
index 9bad892..d59893e 100644
--- a/tools/perf/ui/stdio/hist.c
+++ b/tools/perf/ui/stdio/hist.c
@@ -379,7 +379,6 @@ size_t hists__fprintf(struct hists *hists, bool show_header, int max_rows,
 	struct perf_hpp dummy_hpp = {
 		.buf	= bf,
 		.size	= sizeof(bf),
-		.ptr	= hists_to_evsel(hists),
 	};
 	bool first = true;
 	size_t linesz;
@@ -398,7 +397,7 @@ size_t hists__fprintf(struct hists *hists, bool show_header, int max_rows,
 		else
 			first = false;
 
-		fmt->header(fmt, &dummy_hpp);
+		fmt->header(fmt, &dummy_hpp, hists_to_evsel(hists));
 		fprintf(fp, "%s", bf);
 	}
 
@@ -443,7 +442,7 @@ size_t hists__fprintf(struct hists *hists, bool show_header, int max_rows,
 		else
 			first = false;
 
-		width = fmt->width(fmt, &dummy_hpp);
+		width = fmt->width(fmt, &dummy_hpp, hists_to_evsel(hists));
 		for (i = 0; i < width; i++)
 			fprintf(fp, ".");
 	}
diff --git a/tools/perf/util/hist.h b/tools/perf/util/hist.h
index 9e1cada..0c76bf9 100644
--- a/tools/perf/util/hist.h
+++ b/tools/perf/util/hist.h
@@ -132,8 +132,10 @@ struct perf_hpp {
 };
 
 struct perf_hpp_fmt {
-	int (*header)(struct perf_hpp_fmt *fmt, struct perf_hpp *hpp);
-	int (*width)(struct perf_hpp_fmt *fmt, struct perf_hpp *hpp);
+	int (*header)(struct perf_hpp_fmt *fmt, struct perf_hpp *hpp,
+		      struct perf_evsel *evsel);
+	int (*width)(struct perf_hpp_fmt *fmt, struct perf_hpp *hpp,
+		     struct perf_evsel *evsel);
 	int (*color)(struct perf_hpp_fmt *fmt, struct perf_hpp *hpp,
 		     struct hist_entry *he);
 	int (*entry)(struct perf_hpp_fmt *fmt, struct perf_hpp *hpp,
