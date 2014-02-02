Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752676AbaBBVju (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Feb 2014 16:39:50 -0500
Received: from mx1.redhat.com ([209.132.183.28]:14725 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752474AbaBBVjs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Feb 2014 16:39:48 -0500
From: Jiri Olsa <jolsa@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Jiri Olsa <jolsa@redhat.com>, Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Namhyung Kim <namhyung@kernel.org>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        David Ahern <dsahern@gmail.com>
Subject: [PATCH 07/22] perf tools: Implement selected bool se_snprintf callback logic
Date: Sun,  2 Feb 2014 22:38:55 +0100
Message-Id: <1391377150-23920-8-git-send-email-jolsa@redhat.com>
In-Reply-To: <1391377150-23920-1-git-send-email-jolsa@redhat.com>
References: <1391377150-23920-1-git-send-email-jolsa@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Pass the selected info for TUI browser.

Signed-off-by: Jiri Olsa <jolsa@redhat.com>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: David Ahern <dsahern@gmail.com>
---
 tools/perf/ui/browsers/hists.c | 5 +++--
 tools/perf/ui/hist.c           | 5 +++--
 tools/perf/ui/stdio/hist.c     | 2 +-
 tools/perf/util/hist.h         | 3 ++-
 4 files changed, 9 insertions(+), 6 deletions(-)

diff --git a/tools/perf/ui/browsers/hists.c b/tools/perf/ui/browsers/hists.c
index 0a08853..0f6d515 100644
--- a/tools/perf/ui/browsers/hists.c
+++ b/tools/perf/ui/browsers/hists.c
@@ -790,7 +790,8 @@ static int hist_browser__show_entry(struct hist_browser *browser,
 		if (!browser->b.navkeypressed)
 			width += 1;
 
-		hist_entry__sort_snprintf(entry, s, sizeof(s), browser->hists);
+		hist_entry__sort_snprintf(entry, current_entry, s, sizeof(s),
+					  browser->hists);
 		slsmg_write_nstring(s, width);
 		++row;
 		++printed;
@@ -1124,7 +1125,7 @@ static int hist_browser__fprintf_entry(struct hist_browser *browser,
 	if (symbol_conf.use_callchain)
 		folded_sign = hist_entry__folded(he);
 
-	hist_entry__sort_snprintf(he, s, sizeof(s), browser->hists);
+	hist_entry__sort_snprintf(he, false, s, sizeof(s), browser->hists);
 	percent = (he->stat.period * 100.0) / browser->hists->stats.total_period;
 
 	if (symbol_conf.use_callchain)
diff --git a/tools/perf/ui/hist.c b/tools/perf/ui/hist.c
index 75a8ea6..430c4ea 100644
--- a/tools/perf/ui/hist.c
+++ b/tools/perf/ui/hist.c
@@ -298,7 +298,8 @@ void perf_hpp__cancel_cumulate(void)
 	perf_hpp__format[PERF_HPP__OVERHEAD].header = hpp__header_overhead;
 }
 
-int hist_entry__sort_snprintf(struct hist_entry *he, char *s, size_t size,
+int hist_entry__sort_snprintf(struct hist_entry *he, bool selected,
+			      char *s, size_t size,
 			      struct hists *hists)
 {
 	const char *sep = symbol_conf.field_sep;
@@ -310,7 +311,7 @@ int hist_entry__sort_snprintf(struct hist_entry *he, char *s, size_t size,
 			continue;
 
 		ret += scnprintf(s + ret, size - ret, "%s", sep ?: "  ");
-		ret += se->se_snprintf(se, false, he, s + ret, size - ret,
+		ret += se->se_snprintf(se, selected, he, s + ret, size - ret,
 				       hists__col_len(hists, se->se_width_idx));
 	}
 
diff --git a/tools/perf/ui/stdio/hist.c b/tools/perf/ui/stdio/hist.c
index b48c7ba..ab6f4d6 100644
--- a/tools/perf/ui/stdio/hist.c
+++ b/tools/perf/ui/stdio/hist.c
@@ -360,7 +360,7 @@ static int hist_entry__fprintf(struct hist_entry *he, size_t size,
 		size = hpp.size = bfsz;
 
 	ret = hist_entry__period_snprintf(&hpp, he);
-	hist_entry__sort_snprintf(he, bf + ret, size - ret, hists);
+	hist_entry__sort_snprintf(he, false, bf + ret, size - ret, hists);
 
 	ret = fprintf(fp, "%s\n", bf);
 
diff --git a/tools/perf/util/hist.h b/tools/perf/util/hist.h
index ae403a6..9c0bd20 100644
--- a/tools/perf/util/hist.h
+++ b/tools/perf/util/hist.h
@@ -143,7 +143,8 @@ int hist_entry_iter__add(struct hist_entry_iter *iter, struct addr_location *al,
 int64_t hist_entry__cmp(struct hist_entry *left, struct hist_entry *right);
 int64_t hist_entry__collapse(struct hist_entry *left, struct hist_entry *right);
 int hist_entry__transaction_len(void);
-int hist_entry__sort_snprintf(struct hist_entry *he, char *bf, size_t size,
+int hist_entry__sort_snprintf(struct hist_entry *he, bool selected,
+			      char *bf, size_t size,
 			      struct hists *hists);
 void hist_entry__free(struct hist_entry *);
 
-- 
1.8.3.1

