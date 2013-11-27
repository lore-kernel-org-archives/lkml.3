Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754825Ab3K0LMc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Nov 2013 06:12:32 -0500
Received: from mail-pd0-f174.google.com ([209.85.192.174]:52082 "EHLO
	mail-pd0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754101Ab3K0LM2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Nov 2013 06:12:28 -0500
From: Ramkumar Ramachandra <artagnon@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>, Jiri Olsa <jolsa@redhat.com>,
        Namhyung Kim <namhyung@kernel.org>
Subject: [PATCH v3 3/4] perf diff: color the Ratio column
Date: Wed, 27 Nov 2013 16:32:33 +0530
Message-Id: <1385550154-11385-4-git-send-email-artagnon@gmail.com>
X-Mailer: git-send-email 1.8.5.rc0.5.g70ebc73.dirty
In-Reply-To: <1385550154-11385-1-git-send-email-artagnon@gmail.com>
References: <1385550154-11385-1-git-send-email-artagnon@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In

  $ perf diff -c ratio

color the Ratio column using percent_color_snprintf().

Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Ramkumar Ramachandra <artagnon@gmail.com>
---
 tools/perf/builtin-diff.c | 20 ++++++++++++++++++++
 1 file changed, 20 insertions(+)

diff --git a/tools/perf/builtin-diff.c b/tools/perf/builtin-diff.c
index 20284c3..26f6517 100644
--- a/tools/perf/builtin-diff.c
+++ b/tools/perf/builtin-diff.c
@@ -795,6 +795,17 @@ static int __hpp__color_compare(struct perf_hpp_fmt *fmt,
 		return color_snprintf(hpp->buf, hpp->size,
 				diff > 0 ? PERF_COLOR_GREEN : PERF_COLOR_RED,
 				pfmt, diff);
+	case COMPUTE_RATIO:
+		if (he->dummy)
+			goto dummy_print;
+		if (pair->diff.computed)
+			diff = pair->diff.period_ratio;
+		else
+			diff = compute_ratio(he, pair);
+
+		scnprintf(pfmt, 20, "%%%d.6f", dfmt->header_width);
+		return percent_color_snprintf(hpp->buf, hpp->size,
+					pfmt, diff);
 	default:
 		BUG_ON(1);
 	}
@@ -809,6 +820,12 @@ static int hpp__color_delta(struct perf_hpp_fmt *fmt,
 	return __hpp__color_compare(fmt, hpp, he, COMPUTE_DELTA);
 }
 
+static int hpp__color_ratio(struct perf_hpp_fmt *fmt,
+			struct perf_hpp *hpp, struct hist_entry *he)
+{
+	return __hpp__color_compare(fmt, hpp, he, COMPUTE_RATIO);
+}
+
 static void
 hpp__entry_unpair(struct hist_entry *he, int idx, char *buf, size_t size)
 {
@@ -987,6 +1004,9 @@ static void data__hpp_register(struct data__file *d, int idx)
 	case PERF_HPP_DIFF__DELTA:
 		fmt->color = hpp__color_delta;
 		break;
+	case PERF_HPP_DIFF__RATIO:
+		fmt->color = hpp__color_ratio;
+		break;
 	default:
 		break;
 	}
-- 
1.8.5.rc0.5.g70ebc73.dirty

