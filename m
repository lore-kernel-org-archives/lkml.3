Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756907Ab3CULUL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Mar 2013 07:20:11 -0400
Received: from terminus.zytor.com ([198.137.202.10]:56441 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751384Ab3CULUI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Mar 2013 07:20:08 -0400
Date: Thu, 21 Mar 2013 04:18:33 -0700
From: tip-bot for Namhyung Kim <tipbot@zytor.com>
Message-ID: <tip-759ff497e0e6749437b6723f8d26de0b1833c199@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, paulus@samba.org,
        hpa@zytor.com, mingo@kernel.org, andi@firstfloor.org,
        a.p.zijlstra@chello.nl, penberg@kernel.org, namhyung.kim@lge.com,
        namhyung@kernel.org, jolsa@redhat.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, paulus@samba.org,
        linux-kernel@vger.kernel.org, acme@redhat.com, andi@firstfloor.org,
        a.p.zijlstra@chello.nl, penberg@kernel.org, namhyung.kim@lge.com,
        tglx@linutronix.de, namhyung@kernel.org, jolsa@redhat.com
In-Reply-To: <1362462812-30885-7-git-send-email-namhyung@kernel.org>
References: <1362462812-30885-7-git-send-email-namhyung@kernel.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf evsel: Introduce perf_evsel__is_group_event(
 ) helper
Git-Commit-ID: 759ff497e0e6749437b6723f8d26de0b1833c199
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Thu, 21 Mar 2013 04:18:44 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  759ff497e0e6749437b6723f8d26de0b1833c199
Gitweb:     http://git.kernel.org/tip/759ff497e0e6749437b6723f8d26de0b1833c199
Author:     Namhyung Kim <namhyung.kim@lge.com>
AuthorDate: Tue, 5 Mar 2013 14:53:26 +0900
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Fri, 15 Mar 2013 13:06:05 -0300

perf evsel: Introduce perf_evsel__is_group_event() helper

The perf_evsel__is_group_event function is for checking whether given
evsel needs event group view support or not.  Please note that it's
different to the existing perf_evsel__is_group_leader() which checks
only the given evsel is a leader or a standalone (i.e. non-group) event
regardless of event group feature.

Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Cc: Andi Kleen <andi@firstfloor.org>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Pekka Enberg <penberg@kernel.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/1362462812-30885-7-git-send-email-namhyung@kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/builtin-report.c    |  2 +-
 tools/perf/ui/browsers/hists.c |  4 ++--
 tools/perf/ui/gtk/hists.c      |  7 ++-----
 tools/perf/ui/hist.c           |  7 ++-----
 tools/perf/util/annotate.c     |  9 +++------
 tools/perf/util/evsel.h        | 24 ++++++++++++++++++++++++
 6 files changed, 34 insertions(+), 19 deletions(-)

diff --git a/tools/perf/builtin-report.c b/tools/perf/builtin-report.c
index 96b5a7f..3f4a79b 100644
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
index 0e125e1..a5843fd 100644
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
index 1e764a8..6f259b3 100644
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
index d671e63..4bf91b0 100644
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
index 0955cff..f080cc4 100644
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
index 52021c3..bf758e5 100644
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
