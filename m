Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757045Ab3IETnD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Sep 2013 15:43:03 -0400
Received: from merlin.infradead.org ([205.233.59.134]:59287 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756694Ab3IETmz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Sep 2013 15:42:55 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>
Subject: [PATCH 4/6] perf hists: Fix formatting of long symbol names
Date: Thu,  5 Sep 2013 16:42:41 -0300
Message-Id: <1378410163-2606-5-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1378410163-2606-1-git-send-email-acme@infradead.org>
References: <1378410163-2606-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by merlin.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnaldo Carvalho de Melo <acme@redhat.com>

We had a hardcoded buffer for formatting histogram entries, truncating
long symbol names (C++ anyone?).

Fix it by using hists__sort_list_width() before formatting the first
histogram entry to calculate the max lenght needed by traversing the
overheads and columns lists (sort order).

Reported-by: Stephane Eranian <eranian@google.com>
Tested-by: Stephane Eranian <eranian@google.com>
Cc: Adrian Hunter <adrian.hunter@intel.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/n/tip-vdfkkyfdp8rboh7j9344o3ss@git.kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/ui/stdio/hist.c | 23 +++++++++++++++++------
 1 file changed, 17 insertions(+), 6 deletions(-)

diff --git a/tools/perf/ui/stdio/hist.c b/tools/perf/ui/stdio/hist.c
index 5b4fb33..194e2f4 100644
--- a/tools/perf/ui/stdio/hist.c
+++ b/tools/perf/ui/stdio/hist.c
@@ -350,9 +350,9 @@ static int hist_entry__period_snprintf(struct perf_hpp *hpp,
 }
 
 static int hist_entry__fprintf(struct hist_entry *he, size_t size,
-			       struct hists *hists, FILE *fp)
+			       struct hists *hists,
+			       char *bf, size_t bfsz, FILE *fp)
 {
-	char bf[512];
 	int ret;
 	struct perf_hpp hpp = {
 		.buf		= bf,
@@ -360,8 +360,8 @@ static int hist_entry__fprintf(struct hist_entry *he, size_t size,
 	};
 	bool color = !symbol_conf.field_sep;
 
-	if (size == 0 || size > sizeof(bf))
-		size = hpp.size = sizeof(bf);
+	if (size == 0 || size > bfsz)
+		size = hpp.size = bfsz;
 
 	ret = hist_entry__period_snprintf(&hpp, he, color);
 	hist_entry__sort_snprintf(he, bf + ret, size - ret, hists);
@@ -392,6 +392,8 @@ size_t hists__fprintf(struct hists *hists, bool show_header, int max_rows,
 		.ptr	= hists_to_evsel(hists),
 	};
 	bool first = true;
+	size_t linesz;
+	char *line = NULL;
 
 	init_rem_hits();
 
@@ -479,6 +481,13 @@ size_t hists__fprintf(struct hists *hists, bool show_header, int max_rows,
 		goto out;
 
 print_entries:
+	linesz = hists__sort_list_width(hists) + 3 + 1;
+	line = malloc(linesz);
+	if (line == NULL) {
+		ret = -1;
+		goto out;
+	}
+
 	for (nd = rb_first(&hists->entries); nd; nd = rb_next(nd)) {
 		struct hist_entry *h = rb_entry(nd, struct hist_entry, rb_node);
 		float percent = h->stat.period * 100.0 /
@@ -490,10 +499,10 @@ print_entries:
 		if (percent < min_pcnt)
 			continue;
 
-		ret += hist_entry__fprintf(h, max_cols, hists, fp);
+		ret += hist_entry__fprintf(h, max_cols, hists, line, linesz, fp);
 
 		if (max_rows && ++nr_rows >= max_rows)
-			goto out;
+			break;
 
 		if (h->ms.map == NULL && verbose > 1) {
 			__map_groups__fprintf_maps(&h->thread->mg,
@@ -501,6 +510,8 @@ print_entries:
 			fprintf(fp, "%.10s end\n", graph_dotted_line);
 		}
 	}
+
+	free(line);
 out:
 	free(rem_sq_bracket);
 
-- 
1.8.1.4

