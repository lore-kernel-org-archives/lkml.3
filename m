Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756730Ab3K2Nqz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Nov 2013 08:46:55 -0500
Received: from mail-pb0-f46.google.com ([209.85.160.46]:34328 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756510Ab3K2NqZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Nov 2013 08:46:25 -0500
From: Ramkumar Ramachandra <artagnon@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Jiri Olsa <jolsa@redhat.com>, Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH v4 2/3] perf diff: color the Ratio column
Date: Fri, 29 Nov 2013 19:06:31 +0530
Message-Id: <1385732192-27713-3-git-send-email-artagnon@gmail.com>
X-Mailer: git-send-email 1.8.5.rc0.5.g70ebc73.dirty
In-Reply-To: <1385732192-27713-1-git-send-email-artagnon@gmail.com>
References: <1385732192-27713-1-git-send-email-artagnon@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In

  $ perf diff -c ratio

color the Ratio column using percent_color_snprintf().

Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Ramkumar Ramachandra <artagnon@gmail.com>
---
 tools/perf/builtin-diff.c | 20 ++++++++++++++++++++
 1 file changed, 20 insertions(+)

diff --git a/tools/perf/builtin-diff.c b/tools/perf/builtin-diff.c
index c970aae..25dac6c 100644
--- a/tools/perf/builtin-diff.c
+++ b/tools/perf/builtin-diff.c
@@ -794,6 +794,17 @@ static int __hpp__color_compare(struct perf_hpp_fmt *fmt,
 		scnprintf(pfmt, 20, "%%%+d.2f%%%%", dfmt->header_width - 1);
 		return percent_color_snprintf(hpp->buf, hpp->size,
 					pfmt, fabs(diff));
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
@@ -808,6 +819,12 @@ static int hpp__color_delta(struct perf_hpp_fmt *fmt,
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
@@ -986,6 +1003,9 @@ static void data__hpp_register(struct data__file *d, int idx)
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

