Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752265AbaAMUsL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jan 2014 15:48:11 -0500
Received: from merlin.infradead.org ([205.233.59.134]:40354 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751548AbaAMUsH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jan 2014 15:48:07 -0500
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Ramkumar Ramachandra <artagnon@gmail.com>,
        Jiri Olsa <jolsa@redhat.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 36/38] perf diff: Color the Weighted Diff column
Date: Mon, 13 Jan 2014 17:47:37 -0300
Message-Id: <1389646059-24881-37-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1389646059-24881-1-git-send-email-acme@infradead.org>
References: <1389646059-24881-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by merlin.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ramkumar Ramachandra <artagnon@gmail.com>

In

  $ perf diff -c wdiff:M,N

color the numbers in the Weighted Diff column using color_snprintf(),
picking the colors using get_percent_color().

Signed-off-by: Ramkumar Ramachandra <artagnon@gmail.com>
Acked-by: Jiri Olsa <jolsa@redhat.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Link: http://lkml.kernel.org/r/1388390555-10808-1-git-send-email-artagnon@gmail.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/builtin-diff.c | 22 ++++++++++++++++++++++
 1 file changed, 22 insertions(+)

diff --git a/tools/perf/builtin-diff.c b/tools/perf/builtin-diff.c
index 73d8bffdd484..a77e31246c00 100644
--- a/tools/perf/builtin-diff.c
+++ b/tools/perf/builtin-diff.c
@@ -778,6 +778,7 @@ static int __hpp__color_compare(struct perf_hpp_fmt *fmt,
 		container_of(fmt, struct diff_hpp_fmt, fmt);
 	struct hist_entry *pair = get_pair_fmt(he, dfmt);
 	double diff;
+	s64 wdiff;
 	char pfmt[20] = " ";
 
 	if (!pair)
@@ -806,6 +807,18 @@ static int __hpp__color_compare(struct perf_hpp_fmt *fmt,
 		scnprintf(pfmt, 20, "%%%d.6f", dfmt->header_width);
 		return value_color_snprintf(hpp->buf, hpp->size,
 					pfmt, diff);
+	case COMPUTE_WEIGHTED_DIFF:
+		if (he->dummy)
+			goto dummy_print;
+		if (pair->diff.computed)
+			wdiff = pair->diff.wdiff;
+		else
+			wdiff = compute_wdiff(he, pair);
+
+		scnprintf(pfmt, 20, "%%14ld", dfmt->header_width);
+		return color_snprintf(hpp->buf, hpp->size,
+				get_percent_color(wdiff),
+				pfmt, wdiff);
 	default:
 		BUG_ON(1);
 	}
@@ -826,6 +839,12 @@ static int hpp__color_ratio(struct perf_hpp_fmt *fmt,
 	return __hpp__color_compare(fmt, hpp, he, COMPUTE_RATIO);
 }
 
+static int hpp__color_wdiff(struct perf_hpp_fmt *fmt,
+			struct perf_hpp *hpp, struct hist_entry *he)
+{
+	return __hpp__color_compare(fmt, hpp, he, COMPUTE_WEIGHTED_DIFF);
+}
+
 static void
 hpp__entry_unpair(struct hist_entry *he, int idx, char *buf, size_t size)
 {
@@ -1007,6 +1026,9 @@ static void data__hpp_register(struct data__file *d, int idx)
 	case PERF_HPP_DIFF__RATIO:
 		fmt->color = hpp__color_ratio;
 		break;
+	case PERF_HPP_DIFF__WEIGHTED_DIFF:
+		fmt->color = hpp__color_wdiff;
+		break;
 	default:
 		break;
 	}
-- 
1.8.1.4

