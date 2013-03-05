Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759741Ab3CEFzf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Mar 2013 00:55:35 -0500
Received: from LGEMRELSE7Q.lge.com ([156.147.1.151]:55270 "EHLO
	LGEMRELSE7Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759441Ab3CEFxt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Mar 2013 00:53:49 -0500
X-AuditID: 9c930197-b7cc2ae000000eb7-f1-5135886991e4
From: Namhyung Kim <namhyung@kernel.org>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Jiri Olsa <jolsa@redhat.com>, Andi Kleen <andi@firstfloor.org>,
        Namhyung Kim <namhyung.kim@lge.com>, Pekka Enberg <penberg@kernel.org>
Subject: [PATCH 06/12] perf evsel: Introduce perf_evsel__is_group_event() helper
Date: Tue,  5 Mar 2013 14:53:26 +0900
Message-Id: <1362462812-30885-7-git-send-email-namhyung@kernel.org>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1362462812-30885-1-git-send-email-namhyung@kernel.org>
References: <1362462812-30885-1-git-send-email-namhyung@kernel.org>
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Namhyung Kim <namhyung.kim@lge.com>

The perf_evsel__is_group_event function is for checking whether given
evsel needs event group view support or not.  Please note that it's
different to the existing perf_evsel__is_group_leader() which checks
only the given evsel is a leader or a standalone (i.e. non-group)
event regardless of event group feature.

Signed-off-by: Namhyung Kim <namhyung@kernel.org>
---
 tools/perf/builtin-report.c    |  2 +-
 tools/perf/ui/browsers/hists.c |  4 ++--
 tools/perf/ui/gtk/hists.c      |  7 ++-----
 tools/perf/ui/hist.c           |  7 ++-----
 tools/perf/util/annotate.c     |  9 +++------
 tools/perf/util/evsel.h        | 24 ++++++++++++++++++++++++
 6 files changed, 34 insertions(+), 19 deletions(-)

diff --git a/tools/perf/builtin-report.c b/tools/perf/builtin-report.c
index 96b5a7fee4bb..3f4a79ba5ada 100644
--- a/tools/perf/builtin-report.c
+++ b/tools/perf/builtin-report.c
@@ -314,7 +314,7 @@ static size_t hists__fprintf_nr_sample_events(struct hists *self,
 	char buf[512];
 	size_t size = sizeof(buf);
 
-	if (symbol_conf.event_group && evsel->nr_members > 1) {
+	if (perf_evsel__is_group_event(evsel)) {
 		struct perf_evsel *pos;
 
 		perf_evsel__group_desc(evsel, buf, size);
diff --git a/tools/perf/ui/browsers/hists.c b/tools/perf/ui/browsers/hists.c
index 0e125e1543dc..a5843fd6ab51 100644
--- a/tools/perf/ui/browsers/hists.c
+++ b/tools/perf/ui/browsers/hists.c
@@ -1193,7 +1193,7 @@ static int hists__browser_title(struct hists *hists, char *bf, size_t size,
 	char buf[512];
 	size_t buflen = sizeof(buf);
 
-	if (symbol_conf.event_group && evsel->nr_members > 1) {
+	if (perf_evsel__is_group_event(evsel)) {
 		struct perf_evsel *pos;
 
 		perf_evsel__group_desc(evsel, buf, buflen);
@@ -1709,7 +1709,7 @@ static void perf_evsel_menu__write(struct ui_browser *browser,
 	ui_browser__set_color(browser, current_entry ? HE_COLORSET_SELECTED :
 						       HE_COLORSET_NORMAL);
 
-	if (symbol_conf.event_group && evsel->nr_members > 1) {
+	if (perf_evsel__is_group_event(evsel)) {
 		struct perf_evsel *pos;
 
 		ev_name = perf_evsel__group_name(evsel);
diff --git a/tools/perf/ui/gtk/hists.c b/tools/perf/ui/gtk/hists.c
index 1e764a8ad259..6f259b3d14e2 100644
--- a/tools/perf/ui/gtk/hists.c
+++ b/tools/perf/ui/gtk/hists.c
@@ -32,21 +32,18 @@ static int __hpp__color_fmt(struct perf_hpp *hpp, struct hist_entry *he,
 	int ret;
 	double percent = 0.0;
 	struct hists *hists = he->hists;
+	struct perf_evsel *evsel = hists_to_evsel(hists);
 
 	if (hists->stats.total_period)
 		percent = 100.0 * get_field(he) / hists->stats.total_period;
 
 	ret = __percent_color_snprintf(hpp->buf, hpp->size, percent);
 
-	if (symbol_conf.event_group) {
+	if (perf_evsel__is_group_event(evsel)) {
 		int prev_idx, idx_delta;
-		struct perf_evsel *evsel = hists_to_evsel(hists);
 		struct hist_entry *pair;
 		int nr_members = evsel->nr_members;
 
-		if (nr_members <= 1)
-			return ret;
-
 		prev_idx = perf_evsel__group_idx(evsel);
 
 		list_for_each_entry(pair, &he->pairs.head, pairs.node) {
diff --git a/tools/perf/ui/hist.c b/tools/perf/ui/hist.c
index d671e63aa351..4bf91b09d62d 100644
--- a/tools/perf/ui/hist.c
+++ b/tools/perf/ui/hist.c
@@ -16,6 +16,7 @@ static int __hpp__fmt(struct perf_hpp *hpp, struct hist_entry *he,
 {
 	int ret;
 	struct hists *hists = he->hists;
+	struct perf_evsel *evsel = hists_to_evsel(hists);
 
 	if (fmt_percent) {
 		double percent = 0.0;
@@ -28,15 +29,11 @@ static int __hpp__fmt(struct perf_hpp *hpp, struct hist_entry *he,
 	} else
 		ret = print_fn(hpp->buf, hpp->size, fmt, get_field(he));
 
-	if (symbol_conf.event_group) {
+	if (perf_evsel__is_group_event(evsel)) {
 		int prev_idx, idx_delta;
-		struct perf_evsel *evsel = hists_to_evsel(hists);
 		struct hist_entry *pair;
 		int nr_members = evsel->nr_members;
 
-		if (nr_members <= 1)
-			return ret;
-
 		prev_idx = perf_evsel__group_idx(evsel);
 
 		list_for_each_entry(pair, &he->pairs.head, pairs.node) {
diff --git a/tools/perf/util/annotate.c b/tools/perf/util/annotate.c
index 0955cff5b0ef..f080cc40f00b 100644
--- a/tools/perf/util/annotate.c
+++ b/tools/perf/util/annotate.c
@@ -649,9 +649,7 @@ static int disasm_line__print(struct disasm_line *dl, struct symbol *sym, u64 st
 
 		next = disasm__get_next_ip_line(&notes->src->source, dl);
 
-		if (symbol_conf.event_group &&
-		    perf_evsel__is_group_leader(evsel) &&
-		    evsel->nr_members > 1) {
+		if (perf_evsel__is_group_event(evsel)) {
 			nr_percent = evsel->nr_members;
 			ppercents = calloc(nr_percent, sizeof(double));
 			if (ppercents == NULL)
@@ -721,8 +719,7 @@ static int disasm_line__print(struct disasm_line *dl, struct symbol *sym, u64 st
 		if (queue)
 			return -1;
 
-		if (symbol_conf.event_group &&
-		    perf_evsel__is_group_leader(evsel))
+		if (perf_evsel__is_group_event(evsel))
 			width *= evsel->nr_members;
 
 		if (!*dl->line)
@@ -1126,7 +1123,7 @@ int symbol__annotate_printf(struct symbol *sym, struct map *map,
 	len = symbol__size(sym);
 	namelen = strlen(d_filename);
 
-	if (symbol_conf.event_group && perf_evsel__is_group_leader(evsel))
+	if (perf_evsel__is_group_event(evsel))
 		width *= evsel->nr_members;
 
 	printf(" %-*.*s|	Source code & Disassembly of %s\n",
diff --git a/tools/perf/util/evsel.h b/tools/perf/util/evsel.h
index 52021c3087df..bf758e53c929 100644
--- a/tools/perf/util/evsel.h
+++ b/tools/perf/util/evsel.h
@@ -9,6 +9,7 @@
 #include "xyarray.h"
 #include "cgroup.h"
 #include "hist.h"
+#include "symbol.h"
  
 struct perf_counts_values {
 	union {
@@ -246,11 +247,34 @@ static inline struct perf_evsel *perf_evsel__next(struct perf_evsel *evsel)
 	return list_entry(evsel->node.next, struct perf_evsel, node);
 }
 
+/**
+ * perf_evsel__is_group_leader - Return whether given evsel is a leader event
+ *
+ * @evsel - evsel selector to be tested
+ *
+ * Return %true if @evsel is a group leader or a stand-alone event
+ */
 static inline bool perf_evsel__is_group_leader(const struct perf_evsel *evsel)
 {
 	return evsel->leader == evsel;
 }
 
+/**
+ * perf_evsel__is_group_event - Return whether given evsel is a group event
+ *
+ * @evsel - evsel selector to be tested
+ *
+ * Return %true iff event group view is enabled and @evsel is a actual group
+ * leader which has other members in the group
+ */
+static inline bool perf_evsel__is_group_event(struct perf_evsel *evsel)
+{
+	if (!symbol_conf.event_group)
+		return false;
+
+	return perf_evsel__is_group_leader(evsel) && evsel->nr_members > 1;
+}
+
 struct perf_attr_details {
 	bool freq;
 	bool verbose;
-- 
1.7.11.7

