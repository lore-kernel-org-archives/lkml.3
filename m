Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751616AbaEUNMx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 May 2014 09:12:53 -0400
Received: from mx1.redhat.com ([209.132.183.28]:11733 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750861AbaEUNMw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 May 2014 09:12:52 -0400
From: Jiri Olsa <jolsa@kernel.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Namhyung Kim <namhyung@kernel.org>,
        Jiri Olsa <jolsa@kernel.org>
Subject: [PATCH 01/22] perf tools: Add ->cmp(), ->collapse() and ->sort() to perf_hpp_fmt
Date: Wed, 21 May 2014 15:12:23 +0200
Message-Id: <1400677964-25160-2-git-send-email-jolsa@kernel.org>
In-Reply-To: <1400677964-25160-1-git-send-email-jolsa@kernel.org>
References: <1400677964-25160-1-git-send-email-jolsa@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Namhyung Kim <namhyung@kernel.org>

Those function pointers will be used to sort report output based on
the selected fields.  This is a preparation of later change.

Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Acked-by: Ingo Molnar <mingo@kernel.org>
Link: http://lkml.kernel.org/r/1400480762-22852-2-git-send-email-namhyung@kernel.org
Signed-off-by: Jiri Olsa <jolsa@kernel.org>
---
 tools/perf/ui/hist.c   | 39 +++++++++++++++++++++++++++++++++++----
 tools/perf/util/hist.h |  3 +++
 2 files changed, 38 insertions(+), 4 deletions(-)

diff --git a/tools/perf/ui/hist.c b/tools/perf/ui/hist.c
index 0912805..d4a4f2e 100644
--- a/tools/perf/ui/hist.c
+++ b/tools/perf/ui/hist.c
@@ -192,6 +192,14 @@ static int hpp__entry_##_type(struct perf_hpp_fmt *_fmt __maybe_unused,		\
 			  hpp_entry_scnprintf, true);				\
 }
 
+#define __HPP_SORT_FN(_type, _field)						\
+static int64_t hpp__sort_##_type(struct hist_entry *a, struct hist_entry *b)	\
+{										\
+	s64 __a = he_get_##_field(a);						\
+	s64 __b = he_get_##_field(b);						\
+	return __a - __b;							\
+}
+
 #define __HPP_ENTRY_RAW_FN(_type, _field)					\
 static u64 he_get_raw_##_field(struct hist_entry *he)				\
 {										\
@@ -206,16 +214,27 @@ static int hpp__entry_##_type(struct perf_hpp_fmt *_fmt __maybe_unused,		\
 			  hpp_entry_scnprintf, false);				\
 }
 
+#define __HPP_SORT_RAW_FN(_type, _field)					\
+static int64_t hpp__sort_##_type(struct hist_entry *a, struct hist_entry *b)	\
+{										\
+	s64 __a = he_get_raw_##_field(a);					\
+	s64 __b = he_get_raw_##_field(b);					\
+	return __a - __b;							\
+}
+
+
 #define HPP_PERCENT_FNS(_type, _str, _field, _min_width, _unit_width)	\
 __HPP_HEADER_FN(_type, _str, _min_width, _unit_width)			\
 __HPP_WIDTH_FN(_type, _min_width, _unit_width)				\
 __HPP_COLOR_PERCENT_FN(_type, _field)					\
-__HPP_ENTRY_PERCENT_FN(_type, _field)
+__HPP_ENTRY_PERCENT_FN(_type, _field)					\
+__HPP_SORT_FN(_type, _field)
 
 #define HPP_RAW_FNS(_type, _str, _field, _min_width, _unit_width)	\
 __HPP_HEADER_FN(_type, _str, _min_width, _unit_width)			\
 __HPP_WIDTH_FN(_type, _min_width, _unit_width)				\
-__HPP_ENTRY_RAW_FN(_type, _field)
+__HPP_ENTRY_RAW_FN(_type, _field)					\
+__HPP_SORT_RAW_FN(_type, _field)
 
 
 HPP_PERCENT_FNS(overhead, "Overhead", period, 8, 8)
@@ -227,19 +246,31 @@ HPP_PERCENT_FNS(overhead_guest_us, "guest usr", period_guest_us, 9, 8)
 HPP_RAW_FNS(samples, "Samples", nr_events, 12, 12)
 HPP_RAW_FNS(period, "Period", period, 12, 12)
 
+static int64_t hpp__nop_cmp(struct hist_entry *a __maybe_unused,
+			    struct hist_entry *b __maybe_unused)
+{
+	return 0;
+}
+
 #define HPP__COLOR_PRINT_FNS(_name)			\
 	{						\
 		.header	= hpp__header_ ## _name,	\
 		.width	= hpp__width_ ## _name,		\
 		.color	= hpp__color_ ## _name,		\
-		.entry	= hpp__entry_ ## _name		\
+		.entry	= hpp__entry_ ## _name,		\
+		.cmp	= hpp__nop_cmp,			\
+		.collapse = hpp__nop_cmp,		\
+		.sort	= hpp__sort_ ## _name,		\
 	}
 
 #define HPP__PRINT_FNS(_name)				\
 	{						\
 		.header	= hpp__header_ ## _name,	\
 		.width	= hpp__width_ ## _name,		\
-		.entry	= hpp__entry_ ## _name		\
+		.entry	= hpp__entry_ ## _name,		\
+		.cmp	= hpp__nop_cmp,			\
+		.collapse = hpp__nop_cmp,		\
+		.sort	= hpp__sort_ ## _name,		\
 	}
 
 struct perf_hpp_fmt perf_hpp__format[] = {
diff --git a/tools/perf/util/hist.h b/tools/perf/util/hist.h
index 38c3e87..36dbe00 100644
--- a/tools/perf/util/hist.h
+++ b/tools/perf/util/hist.h
@@ -160,6 +160,9 @@ struct perf_hpp_fmt {
 		     struct hist_entry *he);
 	int (*entry)(struct perf_hpp_fmt *fmt, struct perf_hpp *hpp,
 		     struct hist_entry *he);
+	int64_t (*cmp)(struct hist_entry *a, struct hist_entry *b);
+	int64_t (*collapse)(struct hist_entry *a, struct hist_entry *b);
+	int64_t (*sort)(struct hist_entry *a, struct hist_entry *b);
 
 	struct list_head list;
 };
-- 
1.8.3.1

