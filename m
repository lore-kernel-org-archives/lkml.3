Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753753AbaB1RtJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Feb 2014 12:49:09 -0500
Received: from mx1.redhat.com ([209.132.183.28]:61177 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753215AbaB1Rnj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Feb 2014 12:43:39 -0500
From: Don Zickus <dzickus@redhat.com>
To: acme@ghostprotocols.net
Cc: LKML <linux-kernel@vger.kernel.org>, jolsa@redhat.com, jmario@redhat.com,
        fowles@inreach.com, eranian@google.com,
        Don Zickus <dzickus@redhat.com>
Subject: [PATCH 07/19] perf, callchain: Add generic callchain print handler for stdio
Date: Fri, 28 Feb 2014 12:42:56 -0500
Message-Id: <1393609388-40489-8-git-send-email-dzickus@redhat.com>
In-Reply-To: <1393609388-40489-1-git-send-email-dzickus@redhat.com>
References: <1393609388-40489-1-git-send-email-dzickus@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

My initial implementation for rbtree sorting in the c2c tool does not use the
normal history elements.  As a result, adding callchain support (which is
deeply integrated with history elements) is more challenging when trying to
display its output.

To make things simpler for myself (and to avoid rewriting the same code into
the c2c tool), I provided a generic interface that takes an unsorted callchain
list along with its total and relative sample size, and sorts it locally based
on period and calls the appropriate graph function (passing the correct sample
size).

This makes things easier because the c2c tool can be dumber and just collect
callchains and not worry about the magic needed to sort and display them
correctly.

Unfortunately, this is assuming a stdio output only and does not use the other
gui type outputs.

Regardless, this patch provides useful info for the tool right now.  Tweaks and
recommendations for a better approach are welcomed. :-)

Signed-off-by: Don Zickus <dzickus@redhat.com>
---
 tools/perf/ui/stdio/hist.c | 37 +++++++++++++++++++++++++++++++++++++
 tools/perf/util/hist.h     |  4 ++++
 2 files changed, 41 insertions(+)

diff --git a/tools/perf/ui/stdio/hist.c b/tools/perf/ui/stdio/hist.c
index 831fbb7..0a40f59 100644
--- a/tools/perf/ui/stdio/hist.c
+++ b/tools/perf/ui/stdio/hist.c
@@ -536,3 +536,40 @@ size_t events_stats__fprintf(struct events_stats *stats, FILE *fp)
 
 	return ret;
 }
+
+size_t generic_entry_callchain__fprintf(struct callchain_root *unsorted_callchain,
+					u64 total_samples, u64 relative_samples,
+					int left_margin, FILE *fp)
+{
+	struct rb_root sorted_chain;
+	u64 min_callchain_hits;
+
+	if (!symbol_conf.use_callchain)
+		return 0;
+
+	min_callchain_hits = total_samples * (callchain_param.min_percent / 100);
+
+	callchain_param.sort(&sorted_chain, unsorted_callchain,
+				min_callchain_hits, &callchain_param);
+
+	switch (callchain_param.mode) {
+	case CHAIN_GRAPH_REL:
+		return callchain__fprintf_graph(fp, &sorted_chain, relative_samples,
+						left_margin);
+		break;
+	case CHAIN_GRAPH_ABS:
+		return callchain__fprintf_graph(fp, &sorted_chain, total_samples,
+						left_margin);
+		break;
+	case CHAIN_FLAT:
+		return callchain__fprintf_flat(fp, &sorted_chain, total_samples);
+		break;
+	case CHAIN_NONE:
+		break;
+	default:
+		pr_err("Bad callchain mode\n");
+	}
+
+	return 0;
+}
+
diff --git a/tools/perf/util/hist.h b/tools/perf/util/hist.h
index d226c5b..df981ce 100644
--- a/tools/perf/util/hist.h
+++ b/tools/perf/util/hist.h
@@ -112,6 +112,10 @@ size_t events_stats__fprintf(struct events_stats *stats, FILE *fp);
 size_t hists__fprintf(struct hists *hists, bool show_header, int max_rows,
 		      int max_cols, float min_pcnt, FILE *fp);
 
+size_t generic_entry_callchain__fprintf(struct callchain_root *unsorted_callchain,
+					u64 total_samples, u64 relative_samples,
+					int left_margin, FILE *fp);
+
 void hists__filter_by_dso(struct hists *hists);
 void hists__filter_by_thread(struct hists *hists);
 void hists__filter_by_symbol(struct hists *hists);
-- 
1.7.11.7

