Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751792AbaANODr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jan 2014 09:03:47 -0500
Received: from merlin.infradead.org ([205.233.59.134]:33332 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751664AbaANODk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jan 2014 09:03:40 -0500
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Ramkumar Ramachandra <artagnon@gmail.com>,
        Jiri Olsa <jolsa@redhat.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 34/38] perf diff: Color the Delta column
Date: Mon, 13 Jan 2014 17:47:35 -0300
Message-Id: <1389646059-24881-35-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1389646059-24881-1-git-send-email-acme@infradead.org>
References: <1389646059-24881-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by merlin.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ramkumar Ramachandra <artagnon@gmail.com>

Color the numbers in the Delta column using percent_color_snprintf().

Generalize the coloring function so that we can accommodate all three
comparison methods in future patches: delta, ratio, and wdiff.

Signed-off-by: Ramkumar Ramachandra <artagnon@gmail.com>
Acked-by: Jiri Olsa <jolsa@redhat.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Link: http://lkml.kernel.org/r/1388388861-7931-3-git-send-email-artagnon@gmail.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/builtin-diff.c | 49 ++++++++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 48 insertions(+), 1 deletion(-)

diff --git a/tools/perf/builtin-diff.c b/tools/perf/builtin-diff.c
index 987cac3b4bba..6c3f220115ac 100644
--- a/tools/perf/builtin-diff.c
+++ b/tools/perf/builtin-diff.c
@@ -770,6 +770,45 @@ static int hpp__entry_baseline(struct hist_entry *he, char *buf, size_t size)
 	return ret;
 }
 
+static int __hpp__color_compare(struct perf_hpp_fmt *fmt,
+				struct perf_hpp *hpp, struct hist_entry *he,
+				int comparison_method)
+{
+	struct diff_hpp_fmt *dfmt =
+		container_of(fmt, struct diff_hpp_fmt, fmt);
+	struct hist_entry *pair = get_pair_fmt(he, dfmt);
+	double diff;
+	char pfmt[20] = " ";
+
+	if (!pair)
+		goto dummy_print;
+
+	switch (comparison_method) {
+	case COMPUTE_DELTA:
+		if (pair->diff.computed)
+			diff = pair->diff.period_ratio_delta;
+		else
+			diff = compute_delta(he, pair);
+
+		if (fabs(diff) < 0.01)
+			goto dummy_print;
+		scnprintf(pfmt, 20, "%%%+d.2f%%%%", dfmt->header_width - 1);
+		return percent_color_snprintf(hpp->buf, hpp->size,
+					pfmt, diff);
+	default:
+		BUG_ON(1);
+	}
+dummy_print:
+	return scnprintf(hpp->buf, hpp->size, "%*s",
+			dfmt->header_width, pfmt);
+}
+
+static int hpp__color_delta(struct perf_hpp_fmt *fmt,
+			struct perf_hpp *hpp, struct hist_entry *he)
+{
+	return __hpp__color_compare(fmt, hpp, he, COMPUTE_DELTA);
+}
+
 static void
 hpp__entry_unpair(struct hist_entry *he, int idx, char *buf, size_t size)
 {
@@ -941,8 +980,16 @@ static void data__hpp_register(struct data__file *d, int idx)
 	fmt->entry  = hpp__entry_global;
 
 	/* TODO more colors */
-	if (idx == PERF_HPP_DIFF__BASELINE)
+	switch (idx) {
+	case PERF_HPP_DIFF__BASELINE:
 		fmt->color = hpp__color_baseline;
+		break;
+	case PERF_HPP_DIFF__DELTA:
+		fmt->color = hpp__color_delta;
+		break;
+	default:
+		break;
+	}
 
 	init_header(d, dfmt);
 	perf_hpp__column_register(fmt);
-- 
1.8.1.4

