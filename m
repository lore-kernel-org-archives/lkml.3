Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754664Ab3KUOnb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Nov 2013 09:43:31 -0500
Received: from mail-pb0-f41.google.com ([209.85.160.41]:45594 "EHLO
	mail-pb0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754577Ab3KUOnL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Nov 2013 09:43:11 -0500
From: Ramkumar Ramachandra <artagnon@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>, Jiri Olsa <jolsa@redhat.com>,
        Namhyung Kim <namhyung@kernel.org>
Subject: [INCOMPLETE PATCH 4/4] perf diff: give Ratio column an appropriate color
Date: Thu, 21 Nov 2013 20:03:47 +0530
Message-Id: <1385044427-13995-5-git-send-email-artagnon@gmail.com>
X-Mailer: git-send-email 1.8.5.rc0.5.g70ebc73.dirty
In-Reply-To: <1385044427-13995-1-git-send-email-artagnon@gmail.com>
References: <1385044427-13995-1-git-send-email-artagnon@gmail.com>
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
 The incomplete bit is marked using a TODO; removing two trailing '%'
 symbols doesn't seem to work. Can someone please tell me how to fix
 this problem?

 Thanks.

 tools/perf/builtin-diff.c | 21 +++++++++++++++++++++
 1 file changed, 21 insertions(+)

diff --git a/tools/perf/builtin-diff.c b/tools/perf/builtin-diff.c
index 4477aa2..844841e 100644
--- a/tools/perf/builtin-diff.c
+++ b/tools/perf/builtin-diff.c
@@ -786,6 +786,9 @@ static int __hpp__color_compare(struct perf_hpp_fmt *fmt,
 		case COMPUTE_DELTA:
 			delta = pair->diff.period_ratio_delta;
 			break;
+		case COMPUTE_RATIO:
+			delta = pair->diff.period_ratio;
+			break;
 		default:
 			BUG_ON(1);
 		}
@@ -794,6 +797,9 @@ static int __hpp__color_compare(struct perf_hpp_fmt *fmt,
 		case COMPUTE_DELTA:
 			delta = compute_delta(he, pair);
 			break;
+		case COMPUTE_RATIO:
+			delta = compute_ratio(he, pair);
+			break;
 		default:
 			BUG_ON(1);
 		}
@@ -806,6 +812,12 @@ static int __hpp__color_compare(struct perf_hpp_fmt *fmt,
 					delta > 0 ? PERF_COLOR_GREEN : PERF_COLOR_RED,
 					pfmt, delta);
 			break;
+		case COMPUTE_RATIO:
+			/* TODO: strip trailing % without breaking color */
+			scnprintf(pfmt, 20, "%%%d.6f%%%%", dfmt->header_width - 1);
+			return percent_color_snprintf(hpp->buf, hpp->size,
+						pfmt, delta);
+			break;
 		default:
 			BUG_ON(1);
 		}
@@ -821,6 +833,12 @@ static int hpp__color_delta(struct perf_hpp_fmt *fmt,
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
@@ -1002,6 +1020,9 @@ static void data__hpp_register(struct data__file *d, int idx)
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

