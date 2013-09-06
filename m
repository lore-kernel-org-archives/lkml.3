Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752498Ab3IFMOz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Sep 2013 08:14:55 -0400
Received: from terminus.zytor.com ([198.137.202.10]:53711 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751267Ab3IFMOx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Sep 2013 08:14:53 -0400
Date: Fri, 6 Sep 2013 05:14:13 -0700
From: tip-bot for Arnaldo Carvalho de Melo <tipbot@zytor.com>
Message-ID: <tip-vdfkkyfdp8rboh7j9344o3ss@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, paulus@samba.org, eranian@google.com,
        acme@redhat.com, hpa@zytor.com, mingo@kernel.org, peterz@infradead.org,
        efault@gmx.de, jolsa@redhat.com, fweisbec@gmail.com,
        adrian.hunter@intel.com, dsahern@gmail.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, acme@redhat.com, eranian@google.com,
        paulus@samba.org, linux-kernel@vger.kernel.org, efault@gmx.de,
        peterz@infradead.org, jolsa@redhat.com, fweisbec@gmail.com,
        dsahern@gmail.com, adrian.hunter@intel.com, tglx@linutronix.de
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/urgent] perf hists: Fix formatting of long symbol names
Git-Commit-ID: 99cf666c5c0cd4f4c3e4155e7b01cf593d71d60e
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Fri, 06 Sep 2013 05:14:20 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  99cf666c5c0cd4f4c3e4155e7b01cf593d71d60e
Gitweb:     http://git.kernel.org/tip/99cf666c5c0cd4f4c3e4155e7b01cf593d71d60e
Author:     Arnaldo Carvalho de Melo <acme@redhat.com>
AuthorDate: Thu, 5 Sep 2013 15:39:12 -0300
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Thu, 5 Sep 2013 16:18:28 -0300

perf hists: Fix formatting of long symbol names

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
 
